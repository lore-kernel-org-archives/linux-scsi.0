From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] [Target_Core_Mod/PERSISTENT_RESERVATION]: Add Service
	Action RESERVE/RELEASE w/ all_tg_pt=[0,1]
Date: Tue, 27 Jan 2009 23:41:49 -0800
Message-ID: <1233128509.6442.151.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:31340 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752032AbZA1Hm7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2009 02:42:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Joel Becker <joel.becker@oracle.com>, Hannes Reinecke <hare@suse.de>, Ming Zhang <blackmagic02881@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Rafiu Fakunle <rafiu@openfiler.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

>From d47e48470fce00264620252797aa7665bf51ecf4 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 27 Jan 2009 23:02:54 -0800
Subject: [PATCH 1/2] [Target_Core_Mod/PERSISTENT_RESERVATION]: Add Service Action RESERVE/RELEASE w/ all_tg_pt=[0,1]

This patch adds running logic for PROUT Service Actions RESERVE and RELEASE for
PR_TYPE_WRITE_EXCLUSIVE and PR_TYPE_EXCLUSIVE_ACCESS PR Types using All Target Ports Bit
(all_tg_pt) Enabled and Disabled.  Here is output from the kernel ringbuffer during
a successful PROUT REGISTER -> PROUT RESERVE -> PRIN READ_RESERVATION -> PROUT RELEASE
PROUT UNREGISTER using sg_persist:

SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000005678efff PRgeneration: 0x00000000
SPC-3 PR [iSCSI] Service Action: RESERVE created new reservation holder TYPE: Write Exclusive Access ALL_TG_PT: 1
SPC-3 PR [iSCSI] RESERVE Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] Service Action: RELEASE cleared reservation holder TYPE: Write Exclusive Access ALL_TG_PT: 1
SPC-3 PR [iSCSI] RELEASE Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] Service Action: UNREGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000005678efff PRgeneration: 0x00000000

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h |    3 +-
 drivers/lio-core/target_core_pr.c   |  354 +++++++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_pr.h   |    1 +
 3 files changed, 346 insertions(+), 12 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 3523023..e10538e 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -231,6 +231,7 @@ typedef struct t10_pr_registration_s {
 	u64 pr_res_key;
 	struct se_node_acl_s *pr_reg_nacl;
 	struct se_dev_entry_s *pr_reg_deve;
+	struct se_lun_s *pr_reg_lun_single_tg_pt; /* Used when pr_reg_all_tg_pt=0 */
 	struct list_head pr_reg_list;
 } t10_pr_registration_t;
 
@@ -570,6 +571,7 @@ typedef struct se_device_s {
 	spinlock_t		se_port_lock;
 	struct se_node_acl_s	*dev_reserved_node_acl; /* Used for legacy SPC-2 reservationsa */
 	struct t10_pr_registration_s *dev_pr_res_holder; /* Used for SPC-3 Persistent Reservations */
+	struct se_lun_s		*dev_pr_tg_port_res_lun; /* Used for PR all_tgt_pt=0 */
 	struct list_head	dev_sep_list;
 	struct timer_list		dev_status_timer;
 	struct task_struct		*process_thread; /* Pointer to descriptor for processing thread */
@@ -640,7 +642,6 @@ typedef struct se_lun_s {
 	se_lun_acl_t		*lun_acl_head;
 	se_lun_acl_t		*lun_acl_tail;
 	se_device_t		*se_dev;
-	struct t10_pr_registration_s *lun_pr_res_holder; /* Used for SPC-3 Persistent Reservations */
 	void			*lun_type_ptr;
 	struct config_group	lun_group;
 	struct se_obj_lun_type_s *lun_obj_api;
diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index 41fdf89..051d678 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -332,6 +332,13 @@ static t10_pr_registration_t *core_scsi3_alloc_registration (
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	/*
+	 * See All Target Ports (ALL_TG_PT) bit in spcr17, section 6.14.3
+	 * Basic PERSISTENT RESERVER OUT parameter list, page 290
+	 */
+	if (!(pr_reg->pr_reg_all_tg_pt)) 
+		pr_reg->pr_reg_lun_single_tg_pt = deve->se_lun; 
+
+	/*
 	 * Increment PRgeneration counter for se_device_t upon a successful
 	 * REGISTER, see spc4r17 section 6.3.2 READ_KEYS service action
 	 */
@@ -344,7 +351,7 @@ static t10_pr_registration_t *core_scsi3_alloc_registration (
 	deve->deve_flags |= DEF_PR_REGISTERED;
 	printk("SPC-3 PR [%s] Service Action: REGISTER Initiator Node: %s\n",
 		tfo->get_fabric_name(), nacl->initiatorname);
-	printk("SPC-3 PR [%s] for %s TCM Subsystem %s Object Port(s)\n", 
+	printk("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target Port(s)\n", 
 		tfo->get_fabric_name(), (pr_reg->pr_reg_all_tg_pt) ?
 		"ALL" : "SINGLE", TRANSPORT(dev)->name);
 	printk("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration: 0x%08x\n",
@@ -386,7 +393,7 @@ static void core_scsi3_free_registration (
 
 	printk("SPC-3 PR [%s] Service Action: UNREGISTER Initiator Node: %s\n",
 		tfo->get_fabric_name(), nacl->initiatorname);
-	printk("SPC-3 PR [%s] for %s TCM Subsystem %s Object Port(s)\n",
+	printk("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target Port(s)\n",
 		tfo->get_fabric_name(), (pr_reg->pr_reg_all_tg_pt) ?
 		"ALL" : "SINGLE", TRANSPORT(dev)->name);
 	printk("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration: 0x%08x\n",
@@ -432,7 +439,6 @@ static int core_scsi3_emulate_pro_register (
 	int all_tg_pt,
 	int spec_i_pt)
 {
-	se_subsystem_dev_t *su_dev = SU_DEV(cmd->se_dev);
 	se_session_t *se_sess = SE_SESS(cmd);
 	se_dev_entry_t *se_deve;
 	se_lun_t *se_lun = SE_LUN(cmd);
@@ -499,7 +505,7 @@ static int core_scsi3_emulate_pro_register (
 			return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
 		}
 		if (res_key != pr_reg->pr_res_key) {
-			printk(KERN_ERR "SPC-3 PR: Received res_key: 0x%016Lx"
+			printk(KERN_ERR "SPC-3 PR REGISTER: Received res_key: 0x%016Lx"
 				" does not match existing SA REGISTER res_key:"
 				" 0x%016Lx\n", res_key, pr_reg->pr_res_key);
 			return(PYX_TRANSPORT_RESERVATION_CONFLICT);
@@ -534,21 +540,349 @@ static int core_scsi3_emulate_pro_register (
 	return(0);
 }
 
-static int core_scsi3_emulate_pro_reserve (
+extern unsigned char *core_scsi3_pr_dump_type (int type)
+{
+	switch (type) {
+	case PR_TYPE_WRITE_EXCLUSIVE:
+		return("Write Exclusive Access");
+	case PR_TYPE_EXCLUSIVE_ACCESS:
+		return("Exclusive Access");
+	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
+		return("Write Exclusive Access, Registrants Only");
+	case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
+		return("Exclusive Access, Registrants Only");
+	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
+		return("Write Exclusive Access, All Registrants");
+	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
+		return("Exclusive Access, All Registrants");
+	default:
+		break;
+	}
+
+	return("Unknown SPC-3 PR Type");
+}
+
+static int core_scsi3_pro_reserve (
 	se_cmd_t *cmd,
+	se_device_t *dev,
 	int type,
 	int scope,
 	u64 res_key)
 {
+	se_session_t *se_sess = SE_SESS(cmd);
+	se_dev_entry_t *se_deve;
+	se_lun_t *se_lun = SE_LUN(cmd);
+	se_portal_group_t *se_tpg;
+	t10_pr_registration_t *pr_reg, *pr_res_holder;
+
+	if (!(se_sess) || !(se_lun)) {
+		printk(KERN_ERR "SPC-3 PR: se_sess || se_lun_t is NULL!\n");
+		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+	}
+	se_tpg = se_sess->se_tpg;
+	se_deve = &se_sess->se_node_acl->device_list[se_lun->unpacked_lun];
+	/*
+	 * Locate the existing *pr_reg via se_node_acl_t pointers
+	 */
+	pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl);
+	if (!(pr_reg)) {
+		printk(KERN_ERR "SPC-3 PR: Unable to locate"
+			" PR_REGISTERED *pr_reg\n");
+		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+	}
+	/*
+	 * From spc4r17 Section 5.7.9: Reserving:
+	 *
+	 * An application client creates a persistent reservation by issuing
+	 * a PERSISTENT RESERVE OUT command with RESERVE service action through
+	 * a registered I_T nexus with the following parameters:
+	 *    a) RESERVATION KEY set to the value of the reservation key that is
+	 * 	 registered with the logical unit for the I_T nexus; and
+	 */
+	if (res_key != pr_reg->pr_res_key) {
+		printk(KERN_ERR "SPC-3 PR RESERVE: Received res_key: 0x%016Lx"
+			" does not match existing SA REGISTER res_key:"
+			" 0x%016Lx\n", res_key, pr_reg->pr_res_key);
+		return(PYX_TRANSPORT_RESERVATION_CONFLICT);
+	}
+	/*
+	 * From spc4r17 Section 5.7.9: Reserving:
+	 *
+	 * From above:
+	 *  b) TYPE field and SCOPE field set to the persistent reservation
+         *       being created.
+	 * 
+	 * Only one persistent reservation is allowed at a time per logical unit
+	 * and that persistent reservation has a scope of LU_SCOPE.
+	 */
+	if (scope != PR_SCOPE_LU_SCOPE) {
+		printk(KERN_ERR "SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+		return(PYX_TRANSPORT_INVALID_PARAMETER_LIST);
+	}
+	/*
+	 * See if we have an existing PR reservation holder pointer at
+	 * se_device_t->dev_pr_res_holder in the form t10_pr_registration_t
+	 * *pr_res_holder.
+	 */
+	spin_lock(&dev->dev_reservation_lock);
+	if ((pr_res_holder = dev->dev_pr_res_holder)) {
+		/*
+		 * From spc4r17 Section 5.7.9: Reserving:
+		 * 
+		 * If the device server receives a PERSISTENT RESERVE OUT command
+		 * from an I_T nexus other than a persistent reservation holder
+		 * (see 5.7.10) that attempts to create a persistent reservation
+		 * when a persistent reservation already exists for the logical
+		 * unit, then the command shall be completed with
+		 * RESERVATION CONFLICT status.
+		 *
+		 */
+		if (pr_res_holder != pr_reg) {
+			se_node_acl_t *pr_res_nacl = pr_res_holder->pr_reg_nacl;
+			printk(KERN_ERR "SPC-3 PR: Attempted RESERVE from"
+				" [%s]: %s while reservation already held by"
+				" [%s]: %s, returning RESERVATION_CONFLICT\n",
+				CMD_TFO(cmd)->get_fabric_name(),
+				se_sess->se_node_acl->initiatorname,
+				TPG_TFO(pr_res_nacl->se_tpg)->get_fabric_name(),
+				pr_res_holder->pr_reg_nacl->initiatorname);
+
+			spin_unlock(&dev->dev_reservation_lock);
+			return(PYX_TRANSPORT_RESERVATION_CONFLICT);
+		}
+		/*
+		 * From spc4r17 Section 5.7.9: Reserving:
+		 *
+		 * If a persistent reservation holder attempts to modify the
+		 * type or scope of an existing persistent reservation, the
+		 * command shall be completed with RESERVATION CONFLICT status.
+		 */
+		if ((pr_res_holder->pr_res_type != type) ||
+		    (pr_res_holder->pr_res_scope != scope)) {
+			se_node_acl_t *pr_res_nacl = pr_res_holder->pr_reg_nacl;
+			printk(KERN_ERR "SPC-3 PR: Attempted RESERVE from"
+				" [%s]: %s trying to change TYPE and/or SCOPE,"
+				" while reservation already held by [%s]: %s,"
+				" returning RESERVATION_CONFLICT\n",
+				CMD_TFO(cmd)->get_fabric_name(),
+				se_sess->se_node_acl->initiatorname,
+				TPG_TFO(pr_res_nacl->se_tpg)->get_fabric_name(),
+				pr_res_holder->pr_reg_nacl->initiatorname);
+
+			spin_unlock(&dev->dev_reservation_lock);
+			return(PYX_TRANSPORT_RESERVATION_CONFLICT);
+		}
+		/*
+		 * From spc4r17 Section 5.7.9: Reserving:
+		 *
+		 * If the device server receives a PERSISTENT RESERVE OUT command
+		 * with RESERVE service action where the TYPE field and the SCOPE
+		 * field contain the same values as the existing type and scope
+		 * from a persistent reservation holder, it shall not make any
+		 * change to the existing persistent reservation and shall
+		 * completethe command with GOOD status.
+		 */
+		spin_unlock(&dev->dev_reservation_lock);
+		return(PYX_TRANSPORT_SENT_TO_TRANSPORT);
+	} 
+	/*
+	 * Otherwise, our *pr_reg becomes the PR reservation holder for said
+	 * TYPE/SCOPE.  Also set the received scope and type in *pr_reg.
+	 */
+	pr_reg->pr_res_scope = scope;
+	pr_reg->pr_res_type = type;
+	dev->dev_pr_res_holder = pr_reg;
+	/*
+	 * See All Target Ports (ALL_TG_PT) bit in spcr17, section 6.14.3
+	 * Basic PERSISTENT RESERVER OUT parameter list, page 290
+	 */
+	if (!(pr_reg->pr_reg_all_tg_pt)) {
+		dev->dev_pr_tg_port_res_lun = pr_reg->pr_reg_lun_single_tg_pt;
+	}
+	printk("SPC-3 PR [%s] Service Action: RESERVE created new reservation"
+		" holder TYPE: %s ALL_TG_PT: %d\n",
+		CMD_TFO(cmd)->get_fabric_name(), core_scsi3_pr_dump_type(type),
+		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	printk("SPC-3 PR [%s] RESERVE Node: %s\n", CMD_TFO(cmd)->get_fabric_name(),
+		se_sess->se_node_acl->initiatorname);
+	spin_unlock(&dev->dev_reservation_lock);
+
 	return(0);
 }
 
+static int core_scsi3_pro_reserve_regonly (
+	se_cmd_t *cmd,
+	se_device_t *dev,
+	int type,
+	int scope,
+	u64 res_key)
+{
+	return(0);
+}
+
+static int core_scsi3_pro_reserve_allreg (
+	se_cmd_t *cmd,
+	se_device_t *dev,
+	int type,
+	int scope,
+	u64 res_key)
+{
+	return(0);
+}
+
+static int core_scsi3_emulate_pro_reserve (
+	se_cmd_t *cmd,
+	int type,
+	int scope,
+	u64 res_key)
+{
+	se_device_t *dev = cmd->se_dev;
+	int ret = 0;
+
+	switch (type) {
+	case PR_TYPE_WRITE_EXCLUSIVE:
+		ret = core_scsi3_pro_reserve(cmd, dev, type, scope, res_key);
+		break;
+	case PR_TYPE_EXCLUSIVE_ACCESS:
+		ret = core_scsi3_pro_reserve(cmd, dev, type, scope, res_key);
+		break;
+#if 0
+	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
+		ret = core_scsi3_pro_reserve_regonly(cmd, dev, type, scope, res_key);
+		break;
+	case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
+		ret = core_scsi3_pro_reserve_regonly(cmd, dev, type, scope, res_key);
+		break;
+	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
+		ret = core_scsi3_pro_reserve_allreg(cmd, dev, type, scope, res_key);
+		break;
+	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
+		ret = core_scsi3_pro_reserve_allreg(cmd, dev, type, scope, res_key);
+		break;
+#endif
+	default:
+		printk(KERN_ERR "SPC-3 PR: Unknown Service Action RESERVE Type:"
+			" 0x%02x\n", type);
+		return(PYX_TRANSPORT_INVALID_CDB_FIELD);
+	}
+
+	return(ret);
+}
+
 static int core_scsi3_emulate_pro_release (
 	se_cmd_t *cmd,
 	int type,
 	int scope,
 	u64 res_key)
 {
+	se_device_t *dev = cmd->se_dev;
+	se_session_t *se_sess = SE_SESS(cmd);
+	se_lun_t *se_lun = SE_LUN(cmd);
+	t10_pr_registration_t *pr_reg, *pr_res_holder;
+
+	if (!(se_sess) || !(se_lun)) {
+		printk(KERN_ERR "SPC-3 PR: se_sess || se_lun_t is NULL!\n");
+		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+	}
+	/*
+	 * Locate the existing *pr_reg via se_node_acl_t pointers
+	 */
+	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl);
+	if (!(pr_reg)) {
+		printk(KERN_ERR "SPC-3 PR: Unable to locate"
+			" PR_REGISTERED *pr_reg\n");
+		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+	}
+	/*
+	 * From spc4r17 Section 5.7.11.2 Releasing:
+	 *
+	 * If there is no persistent reservation or in response to a persistent
+	 * reservation release request from a registered I_T nexus that is not a
+	 * persistent reservation holder (see 5.7.10), the device server shall do the following:
+	 *     a) Not release the persistent reservation, if any;
+	 *     b) Not remove any registrations; and
+	 *     c) Complete the command with GOOD status.
+	 */
+	spin_lock(&dev->dev_reservation_lock);
+	if (!(pr_res_holder = dev->dev_pr_res_holder)) {
+		/*
+		 * No persistent reservation, return GOOD status.
+		 */
+		spin_unlock(&dev->dev_reservation_lock);
+		return(PYX_TRANSPORT_SENT_TO_TRANSPORT);		
+	}
+	if (pr_res_holder != pr_reg) {
+		/*
+		 * Release request from a registered I_T nexus that is not a
+		 * persistent reservation holder. return GOOD status.
+		 */
+		spin_unlock(&dev->dev_reservation_lock);
+		return(PYX_TRANSPORT_SENT_TO_TRANSPORT);
+	}
+	/*
+	 * From spc4r17 Section 5.7.11.2 Releasing:
+	 * 
+	 * Only the persistent reservation holder (see 5.7.10) is allowed to
+	 * release a persistent reservation.
+	 *
+	 * An application client releases the persistent reservation by issuing
+	 * a PERSISTENT RESERVE OUT command with RELEASE service action through
+	 * an I_T nexus that is a persistent reservation holder with the following
+	 * parameters:
+	 *     a) RESERVATION KEY field set to the value of the reservation key that
+	 *	  is registered with the logical unit for the I_T nexus;
+	 */
+	if (res_key != pr_reg->pr_res_key) {
+		printk(KERN_ERR "SPC-3 PR RELEASE: Received res_key: 0x%016Lx"
+			" does not match existing SA REGISTER res_key:"
+			" 0x%016Lx\n", res_key, pr_reg->pr_res_key);
+		spin_unlock(&dev->dev_reservation_lock);
+		return(PYX_TRANSPORT_RESERVATION_CONFLICT);
+	}
+	/*
+	 * From spc4r17 Section 5.7.11.2 Releasing and above:
+	 *
+	 * b) TYPE field and SCOPE field set to match the persistent
+	 *    reservation being released.
+	 */
+	if ((pr_res_holder->pr_res_type != type) ||
+	    (pr_res_holder->pr_res_scope != scope)) {
+		se_node_acl_t *pr_res_nacl = pr_res_holder->pr_reg_nacl;
+		printk(KERN_ERR "SPC-3 PR RELEASE: Attempted to release"
+			" reservation from [%s]: %s with different TYPE "
+			"and/or SCOPE  while reservation already held by"
+			" [%s]: %s, returning RESERVATION_CONFLICT\n",
+			CMD_TFO(cmd)->get_fabric_name(),
+			se_sess->se_node_acl->initiatorname,
+			TPG_TFO(pr_res_nacl->se_tpg)->get_fabric_name(),
+			pr_res_holder->pr_reg_nacl->initiatorname);
+
+		spin_unlock(&dev->dev_reservation_lock);
+		return(PYX_TRANSPORT_RESERVATION_CONFLICT);
+	}
+	/*
+	 * Go ahead and release the current PR reservation holder.
+	 */
+	dev->dev_pr_res_holder = NULL;
+	/*
+	 * If All Target Ports (ALL_TG_PT) bit == 0, clear the
+	 * se_lun_t pointer as well..
+	 */
+	if (!(pr_reg->pr_reg_all_tg_pt)) {
+		dev->dev_pr_tg_port_res_lun = NULL;
+	}
+	printk("SPC-3 PR [%s] Service Action: RELEASE cleared reservation holder"
+		" TYPE: %s ALL_TG_PT: %d\n", CMD_TFO(cmd)->get_fabric_name(),
+		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
+		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	printk("SPC-3 PR [%s] RELEASE Node: %s\n", CMD_TFO(cmd)->get_fabric_name(),
+		se_sess->se_node_acl->initiatorname);
+	/*
+	 * Clear TYPE and SCOPE for the next PROUT Service Action: RESERVE
+	 */
+	pr_reg->pr_res_type = pr_reg->pr_res_scope = 0;
+	spin_unlock(&dev->dev_reservation_lock);
+
 	return(0);
 }
 
@@ -657,13 +991,13 @@ static int core_scsi3_emulate_pr_out (se_cmd_t *cmd, unsigned char *cdb)
 	case PRO_REGISTER:
 		return(core_scsi3_emulate_pro_register(cmd,
 			res_key, sa_res_key, aptpl, all_tg_pt, spec_i_pt));
-#if 0
 	case PRO_RESERVE:
 		return(core_scsi3_emulate_pro_reserve(cmd,
 			type, scope, res_key));
 	case PRO_RELEASE:
 		return(core_scsi3_emulate_pro_release(cmd,
 			type, scope, res_key));
+#if 0
 	case PRO_CLEAR:
 		return(core_scsi3_emulate_pro_clear(cmd,
 			res_key));
@@ -779,8 +1113,8 @@ static int core_scsi3_pri_read_reservation (se_cmd_t *cmd)
 		/*
 		 * Set the SCOPE and TYPE
 		 */
-		buf[21] = ((pr_reg->pr_res_type << 8) & 0xff) |
-			   (pr_reg->pr_res_scope & 0xff);
+		buf[21] = (pr_reg->pr_res_scope & 0xf0) |
+			  (pr_reg->pr_res_type & 0x0f);
 	}
 	spin_unlock(&se_dev->dev_reservation_lock);
 
@@ -795,8 +1129,6 @@ static int core_scsi3_pri_read_reservation (se_cmd_t *cmd)
 static int core_scsi3_pri_report_capabilities (se_cmd_t *cmd)
 {
 	se_device_t *se_dev = SE_DEV(cmd);
-	se_subsystem_dev_t *su_dev = SU_DEV(se_dev);
-	t10_pr_registration_t *pr_reg;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	u16 add_len = 8; /* Hardcoded to 8. */
 
@@ -807,7 +1139,7 @@ static int core_scsi3_pri_report_capabilities (se_cmd_t *cmd)
 	 */
 //	buf[2] |= 0x10; /* CRH: Compatible Reservation Hanlding bit. */
 //	buf[2] |= 0x08; /* SIP_C: Specify Initiator Ports Capable bit */
-//	buf[2] |= 0x04; /* ATP_C: All Target Ports Capable bit */ 
+	buf[2] |= 0x04; /* ATP_C: All Target Ports Capable bit */ 
 //	buf[2] |= 0x01; /* PTPL_C: Persistence across Target Power Loss Capable bit */
 	/*
 	 * We are filling in the PERSISTENT RESERVATION TYPE MASK below, so
diff --git a/drivers/lio-core/target_core_pr.h b/drivers/lio-core/target_core_pr.h
index 3a3d646..12802c1 100644
--- a/drivers/lio-core/target_core_pr.h
+++ b/drivers/lio-core/target_core_pr.h
@@ -39,5 +39,6 @@
 #define PR_TYPE_EXCLUSIVE_ACCESS_ALLREG		0x08
 
 extern void core_scsi3_free_all_registrations (struct se_device_s *);
+extern unsigned char *core_scsi3_pr_dump_type (int);
 extern int core_scsi3_emulate_pr (struct se_cmd_s *);
 extern int core_setup_reservations (struct se_device_s *);
-- 
1.5.4.1



