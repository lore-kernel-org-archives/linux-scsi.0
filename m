From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 6/7] [Target_Core_Mod/PERSISTENT_RESERVATION]: Add Service
	Action REGISTER logic
Date: Mon, 26 Jan 2009 01:10:27 -0800
Message-ID: <1232961027.24642.133.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:21657 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750947AbZAZJKv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 04:10:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, Rafiu Fakunle <rafiu@openfiler.com>

>From efe89a76da4a6c065ab972884afecd786d6881f6 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 26 Jan 2009 00:41:53 -0800
Subject: [PATCH 6/7] [Target_Core_Mod/PERSISTENT_RESERVATION]: Add Service Action REGISTER logic

This patch adds a number of functions including proper support using sg3_utils
sg_persist --register.  It also adds support for changing a registered registration
key and PERSISTENT_RESERVE_OUT Service Actions READ_KEYS and READ_RESERVATION.

This code follows spc4r14, and looks like the follwing from Target_Core_Mod/ConfigFS
for a *SINGLE* $HBA/$STORAGE_OBJECT:

/sys/kernel/config/target/core/
|-- iblock_0
|   |-- hba_info
|   `-- lvm_test0
|       |-- attrib
|       |   |-- hw_max_sectors
|       |   |-- hw_queue_depth
|       |   |-- max_sectors
|       |   |-- queue_depth
|       |   |-- status_thread
|       |   |-- status_thread_tur
|       |   `-- task_timeout
|       |-- control
|       |-- enable
|       |-- fd
|       |-- info
|       |-- pr
|       |   |-- res_holder
|       |   |-- res_pr_all_tgt_pts
|       |   |-- res_pr_generation
|       |   |-- res_pr_registered_i_pts
|       |   `-- res_type
|       `-- wwn
|           |-- evpd_assoc_logical_unit
|           |-- evpd_assoc_scsi_target_device
|           |-- evpd_assoc_target_port
|           |-- evpd_protocol_identifier
|           `-- evpd_unit_serial

Here is what it looks like from Target_Core_Mod/ConfigFS from a active
PR REGISTER invocation:

*) target_core_mod/IBLOCK: configfs

target:/mnt/sdb/lio-core-2.6# cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*
Not Implemented yet
Not Implemented Yet
0x00000004
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000005678efff PRgen: 0x00000003
SPC3_PERSISTENT_RESERVATIONS

*) target_core_mod/IBLOCK: dmesg

SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for SINGLE TCM Subsystem iblock Object Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234abcd PRgeneration: 0x00000000
SPC-3 PR [iSCSI] REGISTER: Changed Reservation Key for iqn.1993-08.org.debian:01:2dadf92d0ef to: 0x000000005678efff PRgeneration: 0x00000001

Here is what legacy SPC-2 Reservations looks like from ConfigFS

target:/mnt/sdb/lio-core-2.6# cat /sys/kernel/config/target/core/rd_mcp_0/ramdisk/pr/*
None
res_pr_generation only valid for SPC3_PERSISTENT_RESERVATIONS
res_pr_generation only valid for SPC3_PERSISTENT_RESERVATIONS
res_pr_registered_i_pts only valid for SPC3_PERSISTENT_RESERVATIONS
SPC2_RESERVATIONS

This code is a WIP for >= SPC-3 Persistent Rervations across
Target_Core_Mod/ConfigFS

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_device.c |    5 +-
 drivers/lio-core/target_core_pr.c     |  495 ++++++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_pr.h     |   18 ++
 3 files changed, 501 insertions(+), 17 deletions(-)

diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 49d25b9..98334a4 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -50,6 +50,7 @@
 #include <iscsi_target_error.h>
 #include <target_core_device.h>
 #include <target_core_hba.h>
+#include <target_core_pr.h>
 #include <target_core_tpg.h>
 #include <target_core_transport.h>
 #include <target_core_fabric_ops.h>
@@ -565,9 +566,6 @@ done:
 	buf[2] = ((lun_count >> 8) & 0xff);
 	buf[3] = (lun_count & 0xff);
 
-	se_task->task_scsi_status = GOOD;
-	transport_complete_task(se_task, 1);
-
 	return(PYX_TRANSPORT_SENT_TO_TRANSPORT);
 }
 
@@ -593,6 +591,7 @@ extern void se_release_device_for_hba (se_device_t *dev)
 	hba->dev_count--;
 	spin_unlock(&hba->device_lock);
 
+	core_scsi3_free_all_registrations(dev);
 	se_release_evpd_for_dev(dev);
 		
 	kfree(dev->dev_status_queue_obj);
diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index a81ceaf..ce1a5d3 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -42,6 +42,8 @@
 #include <target_core_fabric_ops.h>
 #include <target_core_configfs.h>
 
+extern struct kmem_cache *t10_pr_reg_cache;
+
 #undef TARGET_CORE_PR_C
 
 extern int core_scsi2_reservation_seq_non_holder (
@@ -149,6 +151,7 @@ extern int core_scsi2_reservation_reserve (se_cmd_t *cmd)
         }
 
 	dev->dev_reserved_node_acl = sess->se_node_acl;
+	dev->dev_flags |= DF_SPC2_RESERVATIONS;
 	printk("SCSI-2 Reserved %s LUN: %u -> MAPPED LUN: %u for %s\n",
 		TPG_TFO(tpg)->get_fabric_name(),
 		SE_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
@@ -251,74 +254,536 @@ static int core_scsi3_pr_seq_non_holder (
 	return(1);
 }
 
+static u32 core_scsi3_pr_generation (se_device_t *dev)
+{
+	se_subsystem_dev_t *su_dev = SU_DEV(dev);
+	u32 prg;
+	/*
+	 * PRGeneration field shall contain the value of a 32-bit wrapping
+	 * counter mainted by the device server.
+	 *
+	 * Note that this is done regardless of Active Persist across
+	 * Target PowerLoss (APTPL)
+	 *
+	 * See spc4r17 section 6.3.12 READ_KEYS service action
+	 */
+	spin_lock(&dev->dev_reservation_lock);
+	prg = T10_RES(su_dev)->pr_generation++;
+	spin_unlock(&dev->dev_reservation_lock);
+
+	return(prg);
+}
+
 static int core_scsi3_pr_reservation_check (se_cmd_t *cmd)
 {
+	se_device_t *dev = cmd->se_dev;
+	se_session_t *sess = cmd->se_sess;
+	int ret;
+
+	if (!(sess))
+		return(0);
+
+	spin_lock(&dev->dev_reservation_lock);
+	if (!(dev->dev_pr_res_holder)) {
+		spin_unlock(&dev->dev_reservation_lock);
+		return(0);
+	}
+	ret = (dev->dev_pr_res_holder->pr_reg_nacl != sess->se_node_acl) ? -1 : 0;
+	spin_unlock(&dev->dev_reservation_lock);
+
 	return(0);
 }
 
 static int core_scsi3_legacy_reserve (se_cmd_t *cmd)
 {
-	return(0);
+	/*
+	 * FIXME: See spc4r17 Section 5.7.3
+	 */
+	return(core_scsi2_reservation_reserve(cmd));
 }
 
 static int core_scsi3_legacy_release (se_cmd_t *cmd)
 {
+	/*
+	 * FIXME: See spc4r17 Section 5.7.3
+	 */
+	return(core_scsi2_reservation_release(cmd));
+}
+
+static t10_pr_registration_t *core_scsi3_alloc_registration (
+	se_device_t *dev,
+	se_node_acl_t *nacl,
+	se_dev_entry_t *deve,
+	u64 sa_res_key,
+	int all_tg_pt)
+{
+	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	t10_pr_registration_t *pr_reg;
+
+	if (!(pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_KERNEL))) {
+		printk(KERN_ERR "Unable to allocate t10_pr_registration_t\n");
+		return(NULL);
+	}
+
+	INIT_LIST_HEAD(&pr_reg->pr_reg_list);
+	pr_reg->pr_reg_nacl = nacl;
+	pr_reg->pr_reg_deve = deve;
+	pr_reg->pr_res_key = sa_res_key;
+	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
+	/*
+	 * Increment PRgeneration counter for se_device_t upon a successful
+	 * REGISTER, see spc4r17 section 6.3.2 READ_KEYS service action
+	 */
+	pr_reg->pr_res_generation = core_scsi3_pr_generation(dev);
+
+	spin_lock(&pr_tmpl->registration_lock);
+	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
+	spin_unlock(&pr_tmpl->registration_lock);
+
+	deve->deve_flags |= DEF_PR_REGISTERED;
+	printk("SPC-3 PR [%s] Service Action: REGISTER Initiator Node: %s\n",
+		tfo->get_fabric_name(), nacl->initiatorname);
+	printk("SPC-3 PR [%s] for %s TCM Subsystem %s Object Port(s)\n", 
+		tfo->get_fabric_name(), (pr_reg->pr_reg_all_tg_pt) ?
+		"ALL" : "SINGLE", TRANSPORT(dev)->name);
+	printk("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration: 0x%08x\n",
+		tfo->get_fabric_name(), pr_reg->pr_res_key,
+		pr_reg->pr_res_generation);
+
+	return(pr_reg);
+}
+
+static t10_pr_registration_t *core_scsi3_locate_pr_reg (
+	se_device_t *dev,
+	se_node_acl_t *nacl)
+{
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	t10_pr_registration_t *pr_reg, *pr_reg_tmp;
+
+	spin_lock(&pr_tmpl->registration_lock);
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
+			&pr_tmpl->registration_list, pr_reg_list) {
+		if (pr_reg->pr_reg_nacl == nacl) {
+			spin_unlock(&pr_tmpl->registration_lock);
+			return(pr_reg);
+		}
+	}
+	spin_unlock(&pr_tmpl->registration_lock);
+
+	return(NULL);
+}
+
+static void core_scsi3_free_registration (
+	se_device_t *dev,
+	t10_pr_registration_t *pr_reg)
+{
+	se_node_acl_t *nacl = pr_reg->pr_reg_nacl;
+	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+
+	pr_reg->pr_reg_deve->deve_flags &= ~DEF_PR_REGISTERED;
+
+	printk("SPC-3 PR [%s] Service Action: UNREGISTER Initiator Node: %s\n",
+		tfo->get_fabric_name(), nacl->initiatorname);
+	printk("SPC-3 PR [%s] for %s TCM Subsystem %s Object Port(s)\n",
+		tfo->get_fabric_name(), (pr_reg->pr_reg_all_tg_pt) ?
+		"ALL" : "SINGLE", TRANSPORT(dev)->name);
+	printk("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration: 0x%08x\n",
+		tfo->get_fabric_name(),  pr_reg->pr_res_key,
+		pr_reg->pr_res_generation);
+
+	spin_lock(&pr_tmpl->registration_lock);
+	list_del(&pr_reg->pr_reg_list);
+	pr_reg->pr_reg_deve = NULL;
+	pr_reg->pr_reg_nacl = NULL;
+	kmem_cache_free(t10_pr_reg_cache, pr_reg);
+	spin_unlock(&pr_tmpl->registration_lock);
+
+	return;
+}
+
+extern void core_scsi3_free_all_registrations (
+	se_device_t *dev)
+{
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	t10_pr_registration_t *pr_reg, *pr_reg_tmp;
+
+	spin_lock(&pr_tmpl->registration_lock);
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
+			&pr_tmpl->registration_list, pr_reg_list) {
+		list_del(&pr_reg->pr_reg_list);
+		
+		pr_reg->pr_reg_deve->deve_flags &= ~DEF_PR_REGISTERED;
+		pr_reg->pr_reg_deve = NULL;
+		pr_reg->pr_reg_nacl = NULL;
+		kmem_cache_free(t10_pr_reg_cache, pr_reg);
+	}
+	spin_unlock(&pr_tmpl->registration_lock);
+
+	return;
+}
+
+static int core_scsi3_emulate_pro_register (
+	se_cmd_t *cmd,
+	u64 res_key,
+	u64 sa_res_key,
+	int aptpl,
+	int all_tg_pt,
+	int spec_i_pt)
+{
+	se_subsystem_dev_t *su_dev = SU_DEV(cmd->se_dev);
+	se_session_t *se_sess = SE_SESS(cmd);
+	se_dev_entry_t *se_deve;
+	se_lun_t *se_lun = SE_LUN(cmd);
+	se_portal_group_t *se_tpg;
+	t10_pr_registration_t *pr_reg;
+
+	if (!(se_sess) || !(se_lun)) {
+		printk(KERN_ERR "SPC-3 PR: se_sess || se_lun_t is NULL!\n");
+		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+	}
+	se_tpg = se_sess->se_tpg;
+	se_deve = &se_sess->se_node_acl->device_list[se_lun->unpacked_lun];
+
+	if (aptpl) {
+		printk("Activate Persistence across Target Power Loss = 1"
+			" not implemented yet\n");
+		return(PYX_TRANSPORT_INVALID_PARAMETER_LIST);
+	}
+	/*
+	 * Follow logic from spc4r17 Section 5.7.7, Register Behaviors Table 47
+	 */
+	if (!(se_deve->deve_flags & DEF_PR_REGISTERED)) {
+		if (res_key) {
+			printk("SPC-3 PR: Reservation Key non-zero for SA REGISTER,"
+				" returning CONFLICT\n");
+			return(PYX_TRANSPORT_RESERVATION_CONFLICT);
+		}
+		/*
+		 * Do nothing but return GOOD status.
+		 */
+		if (!(sa_res_key)) 
+			return(PYX_TRANSPORT_SENT_TO_TRANSPORT);
+
+		if (!(spec_i_pt)) {
+			/*
+			 * Perform the Service Action REGISTER on the Initiator Port
+			 * Endpoint that the PRO was received from on the Logical Unit
+			 * of the SCSI device server.
+			 */
+			pr_reg = core_scsi3_alloc_registration(SE_DEV(cmd),
+					se_sess->se_node_acl, se_deve,
+					sa_res_key, all_tg_pt);
+			if (!(pr_reg)) {
+				printk(KERN_ERR "Unable to allocate t10_pr_registration_t\n");
+				return(PYX_TRANSPORT_INVALID_PARAMETER_LIST);
+			}
+		} else {
+			/*
+			 * FIXME: Extract SCSI TransportID from Parameter list and
+			 * loop through parameter list while calling logic from of
+			 * core_scsi3_alloc_registration()
+			 */
+			printk("Specify Initiator Ports (SPEC_I_PT) = 1 not implemented yet\n");
+			return(PYX_TRANSPORT_INVALID_PARAMETER_LIST);
+		}
+	} else {
+		/*
+		 * Locate the existing *pr_reg via se_node_acl_t pointers
+		 */
+		pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl);
+		if (!(pr_reg)) {
+			printk(KERN_ERR "SPC-3 PR: Unable to locate"
+				" PR_REGISTERED *pr_reg\n");
+			return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+		}
+		if (res_key != pr_reg->pr_res_key) {
+			printk(KERN_ERR "SPC-3 PR: Received res_key: 0x%016Lx"
+				" does not match existing SA REGISTER res_key:"
+				" 0x%016Lx\n", res_key, pr_reg->pr_res_key);
+			return(PYX_TRANSPORT_RESERVATION_CONFLICT);
+		}
+		if (spec_i_pt) {
+			printk(KERN_ERR "SPC-3 PR UNREGISTER: SPEC_I_PT"
+				" set while sa_res_key=0\n");
+			return(PYX_TRANSPORT_INVALID_PARAMETER_LIST);
+		}
+		/*
+		 * sa_res_key=0 Unregister Reservation Key for registered I_T Nexus 
+		 * sa_res_key=1 Change Reservation Key for registered I_T Nexus 
+		 */
+		if (!(sa_res_key))
+			core_scsi3_free_registration(SE_DEV(cmd), pr_reg);	
+		else {
+			/*
+			 * Increment PRgeneration counter for se_device_t"
+			 * upon a successful REGISTER, see spc4r17 section 6.3.2
+			 * READ_KEYS service action.
+			 */
+			pr_reg->pr_res_generation = core_scsi3_pr_generation(SE_DEV(cmd));
+			pr_reg->pr_res_key = sa_res_key;
+			printk("SPC-3 PR [%s] REGISTER: Changed Reservation Key"
+				" for %s to: 0x%016Lx PRgeneration: 0x%08x\n",
+				CMD_TFO(cmd)->get_fabric_name(),
+				pr_reg->pr_reg_nacl->initiatorname,
+				pr_reg->pr_res_key, pr_reg->pr_res_generation);
+		}
+	}
+
+	return(0);
+}
+
+static int core_scsi3_emulate_pro_reserve (
+	se_cmd_t *cmd,
+	int type,
+	int scope,
+	u64 res_key)
+{
+	return(0);
+}
+
+static int core_scsi3_emulate_pro_release (
+	se_cmd_t *cmd,
+	int type,
+	int scope,
+	u64 res_key)
+{
+	return(0);
+}
+
+static int core_scsi3_emulate_pro_clear (
+	se_cmd_t *cmd,
+	u64 res_key)
+{
+	core_scsi3_pr_generation(SE_DEV(cmd));	
 	return(0);
 }
 
-static int core_scsi3_emulate_pro_register (se_cmd_t *cmd)
+static int core_scsi3_emulate_pro_preempt (
+	se_cmd_t *cmd,
+	int type,
+	int scope,
+	u64 res_key,
+	u64 sa_res_key)
 {
+	core_scsi3_pr_generation(SE_DEV(cmd));
 	return(0);
 }
 
-static int core_scsi3_emulate_pro_reserve (se_cmd_t *cmd)
+static int core_scsi3_emulate_pro_preempt_and_abort (
+	se_cmd_t *cmd,
+	int type,
+	int scope,
+	u64 res_key,
+	u64 sa_res_key)
 {
+	core_scsi3_pr_generation(SE_DEV(cmd));
 	return(0);
 }
 
-static int core_scsi3_emulate_pro_release (se_cmd_t *cmd)
+static int core_scsi3_emulate_pro_register_and_ignore_existing_key (
+	se_cmd_t *cmd,
+	int sa_res_key,
+	int aptpl,
+	int all_tg_pt)
 {
+	core_scsi3_pr_generation(SE_DEV(cmd));
 	return(0);
 }
 
-static int core_scsi3_emulate_pro_clear (se_cmd_t *cmd)
+static int core_scsi3_emulate_pro_register_and_move (
+	se_cmd_t *cmd,
+	int type,
+	int scope,
+	u64 res_key,
+	u64 sa_res_key)
 {
+	core_scsi3_pr_generation(SE_DEV(cmd));
 	return(0);
 }
 
+static unsigned long long core_scsi3_extract_reservation_key (unsigned char *cdb)
+{
+	unsigned int __v1, __v2;
+
+	__v1 = (cdb[0] << 24) | (cdb[1] << 16) | (cdb[2] << 8) | cdb[3];
+	__v2 = (cdb[4] << 24) | (cdb[5] << 16) | (cdb[6] << 8) | cdb[7];
+
+	return(((unsigned long long)__v2) | (unsigned long long)__v1 << 32);
+}
+
+/*
+ * See spc4r17 section 6.14 Table 170
+ */
 static int core_scsi3_emulate_pr_out (se_cmd_t *cmd, unsigned char *cdb)
 {
+	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	u64 res_key, sa_res_key;
+	int scope, type, spec_i_pt, all_tg_pt, aptpl;
+
+	/*
+	 * FIXME: A NULL se_session_t pointer means an this is not coming from
+	 * a $FABRIC_MOD's nexus, but from internal passthrough ops.	
+	 */
+	if (!(SE_SESS(cmd)))
+		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+
+	/*
+	 * From the PERSISTENT_RESERVE_OUT command descriptor block (CDB)
+	 */
+	scope = (cdb[2] & 0xf0);
+	type = (cdb[2] & 0x0f);
+	/*
+	 * From PERSISTENT_RESERVE_OUT parameter list (payload)
+	 */
+	res_key = core_scsi3_extract_reservation_key(&buf[0]);
+	sa_res_key = core_scsi3_extract_reservation_key(&buf[8]);
+	spec_i_pt = (buf[20] & 0x08);
+	all_tg_pt = (buf[20] & 0x04);
+	aptpl = (buf[20] & 0x01);
+
+	/*
+	 * SPEC_I_PT=1 is only valid for Service action: REGISTER
+	 */
+	if (spec_i_pt && ((cdb[1] & 0x1f) != PRO_REGISTER))
+		return(PYX_TRANSPORT_INVALID_PARAMETER_LIST);
+	/*
+	 * (core_scsi3_emulate_pro_* function parameters
+	 * are defined by spc4r17 Table 174:
+	 * PERSISTENT_RESERVE_OUT service actions and valid parameters.
+	 */
 	switch (cdb[1] & 0x1f) {
 	case PRO_REGISTER:
-		return(core_scsi3_emulate_pro_register(cmd));
+		return(core_scsi3_emulate_pro_register(cmd,
+			res_key, sa_res_key, aptpl, all_tg_pt, spec_i_pt));
+#if 0
 	case PRO_RESERVE:
-		return(core_scsi3_emulate_pro_reserve(cmd));
+		return(core_scsi3_emulate_pro_reserve(cmd,
+			type, scope, res_key));
 	case PRO_RELEASE:
-		return(core_scsi3_emulate_pro_release(cmd));
+		return(core_scsi3_emulate_pro_release(cmd,
+			type, scope, res_key));
 	case PRO_CLEAR:
-		return(core_scsi3_emulate_pro_clear(cmd));
+		return(core_scsi3_emulate_pro_clear(cmd,
+			res_key));
 	case PRO_PREEMPT:
+		return(core_scsi3_emulate_pro_preempt(cmd,
+			type, scope, res_key, sa_res_key));
 	case PRO_PREEMPT_AND_ABORT:
+		return(core_scsi3_emulate_pro_preempt_and_abort(cmd,
+			type, scope, res_key, sa_res_key));
 	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
+		return(core_scsi3_emulate_pro_register_and_ignore_existing_key(cmd,
+			sa_res_key, aptpl, all_tg_pt));
 	case PRO_REGISTER_AND_MOVE:
-		printk(KERN_ERR "Unsupported PERSISTENT_RESERVE_OUT service"
-			" action: 0x%02x\n", cdb[1] & 0x1f);
-		return(-1);
+		return(core_scsi3_emulate_pro_register_and_move(cmd,
+			type, scope, res_key, sa_res_key));
+#endif
 	default:
 		printk(KERN_ERR "Unknown PERSISTENT_RESERVE_OUT service"
 			" action: 0x%02x\n", cdb[1] & 0x1f);
-		return(-1);
+		return(PYX_TRANSPORT_INVALID_CDB_FIELD);
 	}
 
+	return(PYX_TRANSPORT_INVALID_CDB_FIELD);
 }
 
+/*
+ * PERSISTENT_RESERVE_IN Service Action READ_KEYS
+ *
+ * See spc4r17 section 5.7.6.2 and section 6.13.2, Table 160
+ */
 static int core_scsi3_pri_read_keys (se_cmd_t *cmd)
 {
+	se_device_t *se_dev = SE_DEV(cmd);
+	se_subsystem_dev_t *su_dev = SU_DEV(se_dev);
+	t10_pr_registration_t *pr_reg;
+	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	u32 add_len = 0, off = 8;
+
+	buf[0] = ((T10_RES(su_dev)->pr_generation >> 24) & 0xff);
+	buf[1] = ((T10_RES(su_dev)->pr_generation >> 16) & 0xff);
+	buf[2] = ((T10_RES(su_dev)->pr_generation >> 8) & 0xff);
+	buf[3] = (T10_RES(su_dev)->pr_generation & 0xff);
+
+	spin_lock(&T10_RES(su_dev)->registration_lock);
+	list_for_each_entry(pr_reg, &T10_RES(su_dev)->registration_list,
+			pr_reg_list) {
+		/*
+		 * Check for overflow of 8byte PRI READ_KEYS payload and
+		 * next reservation key list descriptor.
+		 */
+		if ((add_len + 8) > (cmd->data_length - 8))
+			break;
+
+		buf[off++] = ((pr_reg->pr_res_key >> 56) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 48) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 40) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 32) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 24) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 16) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 8) & 0xff);
+		buf[off++] = (pr_reg->pr_res_key & 0xff);
+
+		add_len += 8;
+	}
+	spin_unlock(&T10_RES(su_dev)->registration_lock);
+
+	buf[4] = ((add_len >> 24) & 0xff);
+	buf[5] = ((add_len >> 16) & 0xff);
+	buf[6] = ((add_len >> 8) & 0xff);
+	buf[7] = (add_len & 0xff);
+
 	return(0);
 }
 
+/*
+ * PERSISTENT_RESERVE_IN Service Action READ_RESERVATION
+ *
+ * See spc4r17 section 5.7.6.3 and section 6.13.3.2 Table 161 and 162
+ */
 static int core_scsi3_pri_read_reservation (se_cmd_t *cmd)
 {
+	se_device_t *se_dev = SE_DEV(cmd);
+	se_subsystem_dev_t *su_dev = SU_DEV(se_dev);
+	t10_pr_registration_t *pr_reg;
+	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	u32 add_len = 16; /* Hardcoded to 16 when a reservation is held. */
+
+	buf[0] = ((T10_RES(su_dev)->pr_generation >> 24) & 0xff);
+	buf[1] = ((T10_RES(su_dev)->pr_generation >> 16) & 0xff);
+	buf[2] = ((T10_RES(su_dev)->pr_generation >> 8) & 0xff);
+	buf[3] = (T10_RES(su_dev)->pr_generation & 0xff);
+
+	spin_lock(&se_dev->dev_reservation_lock);
+	if ((pr_reg = se_dev->dev_pr_res_holder)) {
+		/*
+		 * Set the hardcoded Additional Length
+		 */
+		buf[4] = ((add_len >> 24) & 0xff);
+		buf[5] = ((add_len >> 16) & 0xff);
+		buf[6] = ((add_len >> 8) & 0xff);
+		buf[7] = (add_len & 0xff);
+		/*
+		 * Set the Reservation key
+		 */
+		buf[8] = ((pr_reg->pr_res_key >> 56) & 0xff);
+		buf[9] = ((pr_reg->pr_res_key >> 48) & 0xff);
+		buf[10] = ((pr_reg->pr_res_key >> 40) & 0xff);
+		buf[11] = ((pr_reg->pr_res_key >> 32) & 0xff);
+		buf[12] = ((pr_reg->pr_res_key >> 24) & 0xff);
+		buf[13] = ((pr_reg->pr_res_key >> 16) & 0xff);
+		buf[14] = ((pr_reg->pr_res_key >> 8) & 0xff);
+		buf[15] = (pr_reg->pr_res_key & 0xff);
+		/*
+		 * Set the SCOPE and TYPE
+		 */
+		buf[21] = ((pr_reg->pr_res_type << 8) & 0xff) |
+			   (pr_reg->pr_res_scope & 0xff);
+	}
+	spin_unlock(&se_dev->dev_reservation_lock);
+
 	return(0);
 }
 
@@ -339,14 +804,16 @@ static int core_scsi3_emulate_pr_in (se_cmd_t *cmd, unsigned char *cdb)
 		return(core_scsi3_pri_read_keys(cmd));
 	case PRI_READ_RESERVATION:
 		return(core_scsi3_pri_read_reservation(cmd));
+#if 0
 	case PRI_REPORT_CAPABILITIES:
 		return(core_scsi3_pri_report_capabilities(cmd));
 	case PRI_READ_FULL_STATUS:
 		return(core_scsi3_pri_read_full_status(cmd));
+#endif
 	default:
 		printk(KERN_ERR "Unknown PERSISTENT_RESERVE_IN service"
 			" action: 0x%02x\n", cdb[1] & 0x1f);
-		return(-1);
+		return(PYX_TRANSPORT_INVALID_CDB_FIELD);
 	}
 
 }
diff --git a/drivers/lio-core/target_core_pr.h b/drivers/lio-core/target_core_pr.h
index d32bbdd..3a3d646 100644
--- a/drivers/lio-core/target_core_pr.h
+++ b/drivers/lio-core/target_core_pr.h
@@ -20,6 +20,24 @@
 #define PRI_READ_RESERVATION			0x01
 #define PRI_REPORT_CAPABILITIES			0x02
 #define PRI_READ_FULL_STATUS			0x03
+/*
+ * PERSISTENT_RESERVE_ SCOPE field
+ *
+ * spc4r17 section 6.13.3.3 Table 163
+ */
+#define PR_SCOPE_LU_SCOPE			0x00
+/*
+ * PERSISTENT_RESERVE_* TYPE field
+ *
+ * spc4r17 section 6.13.3.4 Table 164
+ */
+#define PR_TYPE_WRITE_EXCLUSIVE			0x01
+#define PR_TYPE_EXCLUSIVE_ACCESS		0x03
+#define PR_TYPE_WRITE_EXCLUSIVE_REGONLY		0x05
+#define PR_TYPE_EXCLUSIVE_ACCESS_REGONLY	0x06
+#define PR_TYPE_WRITE_EXCLUSIVE_ALLREG		0x07
+#define PR_TYPE_EXCLUSIVE_ACCESS_ALLREG		0x08
 
+extern void core_scsi3_free_all_registrations (struct se_device_s *);
 extern int core_scsi3_emulate_pr (struct se_cmd_s *);
 extern int core_setup_reservations (struct se_device_s *);
-- 
1.5.4.1



