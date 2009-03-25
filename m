From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/Persistent_Reservations]: Add support for
	PROUT PREEMPT service action
Date: Wed, 25 Mar 2009 04:21:38 -0700
Message-ID: <1237980098.4138.439.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:42067 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752396AbZCYLVn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 07:21:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Greetings all,

This patch adds complete SPC-3 compliant PROUT PREEMPT service action support,
including support for all PROUT TYPEs and all UNIT ATTENTION conditions for I_T nexuses
that have had their reservations/registrations preempted as defined by spc4r17.

This is the primary PR service action that is used to fence a failing node when using
SPC-3 compliant persistent reservations with cluster storage.  Currently, Linux
distributions using fence_scsi use PROUT service action PREEMPT_AND_ABORT for cluster
operation.  This logic will be added to core_scsi3_emulate_pro_preempt() as testing
continues against different client side SPC-3 compliant PR setups.

These patches are made against lio-core-2.6.git/master and tested on
v2.6.29 x86 32-bit HVM using sg_persist and sg_request from sg3_utils.
The lio-core-2.6.git tree can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Here is what it looks like in action, here are two iSCSI LUNs connected via two
iSCSI sessions on two different iSCSI target ports

*) Create registrations for both target ports..

initiator# sg_persist --out --register --param-sark=0x1234abcd -Y -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 00 00 00 00 00 00 00 18 00
initiator# sg_persist --out --register --param-sark=0x4567ffff -Y -v /dev/sdh
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 00 00 00 00 00 00 00 18 00
PR out: command (Register) successful

target# tail -f /var/log/message

SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234abcd PRgeneration: 0x00000000
SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000004567ffff PRgeneration: 0x00000001

*) Create a write exclusive, all registrants persistent reservation on the first target port

initiator# sg_persist --out --reserve --param-rk=0x1234abcd --prout-type=7 -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 01 07 00 00 00 00 00 18 00
PR out: command (Reserve) successful

target# tail -f /var/log/messages

SPC-3 PR [iSCSI] Service Action: RESERVE created new reservation holder TYPE: Write Exclusive Access, All Registrants ALL_TG_PT: 1
SPC-3 PR [iSCSI] RESERVE Node: iqn.1993-08.org.debian:01:2dadf92d0ef

*) Preempt the existing reservation with a write exclusive, registrants only persistent reservation
   on the second target port

initiator# sg_persist --out --preempt --param-rk=0x4567ffff --param-sark=0x1234abcd --prout-type=5 -v /dev/sdh
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 04 05 00 00 00 00 00 18 00
PR out: command (Preempt) successful

target# tail -f /var/log/messages

SPC-3 PR [iSCSI] Service Action: implict RELEASE cleared reservation holder TYPE: Write Exclusive Access, All Registrants ALL_TG_PT: 1
SPC-3 PR [iSCSI] RELEASE Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] Service Action: UNREGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234abcd PRgeneration: 0x00000000
[iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x03
SPC-3 PR [iSCSI] Service Action: PREEMPT created new reservation holder TYPE: Write Exclusive Access, Registrants Only ALL_TG_PT: 1
SPC-3 PR [iSCSI] PREEMPT from Node: iqn.1993-08.org.debian:01:2dadf92d0ef

*) Call REQUEST_SENSE on the preempted target port to verify the ASC/ASCQ

initiator# sg_requests -v /dev/sde
    Request Sense cmd: 03 00 00 00 fc 00
Decode parameter data as sense data:
 Fixed format, current;  Sense key: Unit Attention
 Additional sense: Reservations preempted

target# tail -f /var/log/messages

[iSCSI]: Released UNIT ATTENTION condition, mapped LUN: 0, reported ASC: 0x2a, ASCQ: 0x03

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h |    1 +
 drivers/lio-core/target_core_pr.c   |  314 ++++++++++++++++++++++++++++++++++-
 2 files changed, 309 insertions(+), 6 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index cb56d6a..5849a1f 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -286,6 +286,7 @@ typedef struct t10_pr_registration_s {
 	int pr_res_holder;
 	int pr_res_type;
 	int pr_res_scope;
+	u32 pr_res_mapped_lun;
 	u32 pr_res_generation;
 	u64 pr_res_key;
 	atomic_t pr_res_holders;
diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index 0ddf54c..8c10bd2 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -476,6 +476,7 @@ static int core_scsi3_alloc_registration(
 	atomic_set(&pr_reg->pr_res_holders, 0);
 	pr_reg->pr_reg_nacl = nacl;
 	pr_reg->pr_reg_deve = deve;
+	pr_reg->pr_res_mapped_lun = deve->mapped_lun;
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	pr_reg->pr_reg_tg_pt_lun = deve->se_lun;
@@ -805,7 +806,8 @@ static int core_scsi3_emulate_pro_register(
 
 					core_scsi3_ua_allocate(
 						pr_reg_p->pr_reg_nacl,
-						cmd->orig_fe_lun, 0x2A,
+						pr_reg_p->pr_res_mapped_lun,
+						0x2A,
 						ASCQ_2AH_RESERVATIONS_RELEASED);
 				}
 			}
@@ -1212,7 +1214,8 @@ static int core_scsi3_emulate_pro_release(
 		if (pr_reg_p == pr_reg)
 			continue;
 
-		core_scsi3_ua_allocate(pr_reg_p->pr_reg_nacl, cmd->orig_fe_lun,
+		core_scsi3_ua_allocate(pr_reg_p->pr_reg_nacl,
+				pr_reg_p->pr_res_mapped_lun,
 				0x2A, ASCQ_2AH_RESERVATIONS_RELEASED);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
@@ -1230,6 +1233,7 @@ static int core_scsi3_emulate_pro_clear(
 	se_session_t *se_sess = SE_SESS(cmd);
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 	t10_pr_registration_t *pr_reg, *pr_reg_tmp, *pr_reg_n, *pr_res_holder;
+	u32 pr_res_mapped_lun = 0;
 	int calling_it_nexus = 0;
 	/*
 	 * Locate the existing *pr_reg via se_node_acl_t pointers
@@ -1280,6 +1284,7 @@ static int core_scsi3_emulate_pro_clear(
 
 		calling_it_nexus = (pr_reg_n == pr_reg) ? 1 : 0;
 		pr_reg_nacl = pr_reg->pr_reg_nacl;
+		pr_res_mapped_lun = pr_reg->pr_res_mapped_lun;
 		__core_scsi3_free_registration(dev, pr_reg, calling_it_nexus);
 		/*
 		 * e) Establish a unit attention condition for the initiator
@@ -1289,7 +1294,7 @@ static int core_scsi3_emulate_pro_clear(
 		 *    additional sense code set to RESERVATIONS PREEMPTED.
 		 */
 		if (!(calling_it_nexus))
-			core_scsi3_ua_allocate(pr_reg_nacl, cmd->orig_fe_lun,
+			core_scsi3_ua_allocate(pr_reg_nacl, pr_res_mapped_lun,
 				0x2A, ASCQ_2AH_RESERVATIONS_PREEMPTED);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
@@ -1301,6 +1306,37 @@ static int core_scsi3_emulate_pro_clear(
 	return 0;
 }
 
+/*
+ * Called with se_device_t->dev_reservation_lock held.
+ */
+static void __core_scsi3_complete_pro_preempt(
+	se_device_t *dev,
+	t10_pr_registration_t *pr_reg,
+	int type,
+	int scope)
+{
+	se_node_acl_t *nacl = pr_reg->pr_reg_nacl;
+	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
+	/*
+	 * Do an implict RELEASE of the existing reservation.
+	 */
+	if (dev->dev_pr_res_holder)
+		__core_scsi3_complete_pro_release(dev, nacl,
+				dev->dev_pr_res_holder, 0);
+
+	dev->dev_pr_res_holder = pr_reg;
+	pr_reg->pr_res_holder = 1;
+	pr_reg->pr_res_type = type;
+	pr_reg->pr_res_scope = scope;
+
+	printk(KERN_INFO "SPC-3 PR [%s] Service Action: PREEMPT created new"
+		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
+		tfo->get_fabric_name(), core_scsi3_pr_dump_type(type),
+		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	printk(KERN_INFO "SPC-3 PR [%s] PREEMPT from Node: %s\n",
+		tfo->get_fabric_name(), nacl->initiatorname);
+}
+
 static int core_scsi3_emulate_pro_preempt(
 	se_cmd_t *cmd,
 	int type,
@@ -1308,6 +1344,272 @@ static int core_scsi3_emulate_pro_preempt(
 	u64 res_key,
 	u64 sa_res_key)
 {
+	se_device_t *dev = SE_DEV(cmd);
+	se_dev_entry_t *se_deve;
+	se_lun_t *se_lun = SE_LUN(cmd);
+	se_node_acl_t *pr_reg_nacl;
+	se_session_t *se_sess = SE_SESS(cmd);
+	t10_pr_registration_t *pr_reg, *pr_reg_tmp, *pr_reg_n, *pr_res_holder;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	u32 pr_res_mapped_lun = 0;
+	int all_reg = 0, calling_it_nexus = 0, released_regs = 0;
+	int prh_type = 0, prh_scope = 0;
+
+	if (!(se_sess))
+		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	se_deve = &se_sess->se_node_acl->device_list[se_lun->unpacked_lun];
+	if (!(se_deve->deve_flags & DEF_PR_REGISTERED))
+		return PYX_TRANSPORT_RESERVATION_CONFLICT;
+
+	pr_reg_n = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl);
+	if (!(pr_reg_n)) {
+		printk(KERN_ERR "SPC-3 PR: Unable to locate"
+			" PR_REGISTERED *pr_reg for PREEMPT\n");
+		return PYX_TRANSPORT_RESERVATION_CONFLICT;
+	}
+	if (pr_reg_n->pr_res_key != res_key) {
+		core_scsi3_put_pr_reg(pr_reg_n);
+		return PYX_TRANSPORT_RESERVATION_CONFLICT;
+	}
+	if (scope != PR_SCOPE_LU_SCOPE) {
+		printk(KERN_ERR "SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+		core_scsi3_put_pr_reg(pr_reg_n);
+		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+	}
+
+	spin_lock(&dev->dev_reservation_lock);
+	pr_res_holder = dev->dev_pr_res_holder;
+	if (pr_res_holder &&
+	   ((pr_res_holder->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
+	    (pr_res_holder->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)))
+		all_reg = 1;
+
+	if (!(all_reg) && !(sa_res_key)) {
+		spin_unlock(&dev->dev_reservation_lock);
+		core_scsi3_put_pr_reg(pr_reg_n);
+		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+	}
+	/*
+	 * From spc4r17, section 5.7.11.4.4 Removing Registrations:
+	 *
+	 * If the SERVICE ACTION RESERVATION KEY field does not identify a
+	 * persistent reservation holder or there is no persistent reservation
+	 * holder (i.e., there is no persistent reservation), then the device
+	 * server shall perform a preempt by doing the following in an
+	 * uninterrupted series of actions. (See below..)
+	 */
+	if (!(pr_res_holder) || (pr_res_holder->pr_res_key != sa_res_key)) {
+		/*
+		 * No existing or SA Reservation Key matching reservations..
+		 *
+		 * PROUT SA PREEMPT with All Registrant type reservations are
+		 * allowed to be processed without a matching SA Reservation Key
+		 */
+		spin_lock(&pr_tmpl->registration_lock);
+		list_for_each_entry_safe(pr_reg, pr_reg_tmp,
+				&pr_tmpl->registration_list, pr_reg_list) {
+			/*
+			 * Removing of registrations in non all registrants
+			 * type reservations without a matching SA reservation
+			 * key.
+			 *
+			 * a) Remove the registrations for all I_T nexuses
+			 *    specified by the SERVICE ACTION RESERVATION KEY
+			 *    field;
+			 * b) Ignore the contents of the SCOPE and TYPE fields;
+			 * c) Process tasks as defined in 5.7.1; and
+			 * d) Establish a unit attention condition for the
+			 *    initiator port associated with every I_T nexus
+			 *    that lost its registration other than the I_T
+			 *    nexus on which the PERSISTENT RESERVE OUT command
+			 *    was received, with the additional sense code set
+			 *    to REGISTRATIONS PREEMPTED.
+			 */
+			if (!(all_reg)) {
+				if (pr_reg->pr_res_key != sa_res_key)
+					continue;
+
+				calling_it_nexus = (pr_reg_n == pr_reg) ? 1 : 0;
+				pr_reg_nacl = pr_reg->pr_reg_nacl;
+				pr_res_mapped_lun = pr_reg->pr_res_mapped_lun;
+				__core_scsi3_free_registration(dev, pr_reg,
+							calling_it_nexus);
+				released_regs++;
+			} else {
+				/*
+				 * Case for any existing all registrants type
+				 * reservation, follow logic in spc4r17 section
+				 * 5.7.11.4 Preempting, Table 52 and Figure 7.
+				 *
+				 * For a ZERO SA Reservation key, release
+				 * all other registrations and do an implict
+				 * release of active persistent reservation.
+				 *
+				 * For a non-ZERO SA Reservation key, only
+				 * release the matching reservation key from
+				 * registrations.
+				 */
+				if ((sa_res_key) &&
+				     (pr_reg->pr_res_key != sa_res_key))
+					continue;
+
+				calling_it_nexus = (pr_reg_n == pr_reg) ? 1 : 0;
+				if (calling_it_nexus)
+					continue;
+
+				pr_reg_nacl = pr_reg->pr_reg_nacl;
+				pr_res_mapped_lun = pr_reg->pr_res_mapped_lun;
+				__core_scsi3_free_registration(dev, pr_reg, 0);
+				released_regs++;
+			}
+			if (!(calling_it_nexus))
+				core_scsi3_ua_allocate(pr_reg_nacl,
+					pr_res_mapped_lun, 0x2A,
+					ASCQ_2AH_RESERVATIONS_PREEMPTED);
+		}
+		spin_unlock(&pr_tmpl->registration_lock);
+		/*
+		 * If a PERSISTENT RESERVE OUT with a PREEMPT service action or
+		 * a PREEMPT AND ABORT service action sets the SERVICE ACTION
+		 * RESERVATION KEY field to a value that does not match any
+		 * registered reservation key, then the device server shall
+		 * complete the command with RESERVATION CONFLICT status.
+		 */
+		if (!(released_regs)) {
+			spin_unlock(&dev->dev_reservation_lock);
+			core_scsi3_put_pr_reg(pr_reg_n);
+			return PYX_TRANSPORT_RESERVATION_CONFLICT;
+		}
+		/*
+		 * For an existing all registrants type reservation
+		 * with a zero SA rservation key, preempt the existing
+		 * reservation with the new PR type and scope.
+		 */
+		if (pr_res_holder && all_reg && !(sa_res_key))
+			__core_scsi3_complete_pro_preempt(dev, pr_reg_n,
+					type, scope);
+		spin_unlock(&dev->dev_reservation_lock);
+
+		core_scsi3_put_pr_reg(pr_reg_n);
+		core_scsi3_pr_generation(SE_DEV(cmd));
+		return 0;
+	}
+	/*
+	 * The PREEMPTing SA reservation key matches that of the
+	 * existing persistent reservation, first, we check if
+	 * we are preempting our own reservation.
+	 */
+	if (pr_reg_n == pr_res_holder) {
+		/*
+		 * From spc4r17, section 5.7.11.4.3 Preempting
+		 * persistent reservations and registration handling
+		 *
+		 * If an all registrants persistent reservation is not
+		 * present, it is not an error for the persistent
+		 * reservation holder to preempt itself (i.e., a
+		 * PERSISTENT RESERVE OUT with a PREEMPT service action
+		 * or a PREEMPT AND ABORT service action with the
+		 * SERVICE ACTION RESERVATION KEY value equal to the
+		 * persistent reservation holder's reservation key that
+		 * is received from the persistent reservation holder).
+		 * In that case, the device server shall establish the
+		 * new persistent reservation and maintain the
+		 * registration.
+		 */
+		__core_scsi3_complete_pro_preempt(dev, pr_reg_n,
+				type, scope);
+		spin_unlock(&dev->dev_reservation_lock);
+
+		core_scsi3_put_pr_reg(pr_reg_n);
+		core_scsi3_pr_generation(SE_DEV(cmd));
+		return 0;
+	}
+	prh_type = pr_res_holder->pr_res_type;
+	prh_scope = pr_res_holder->pr_res_scope;
+	/*
+	 * If the SERVICE ACTION RESERVATION KEY field identifies a
+	 * persistent reservation holder (see 5.7.10), the device
+	 * server shall perform a preempt by doing the following as
+	 * an uninterrupted series of actions:
+	 *
+	 * a) Release the persistent reservation for the holder
+	 *    identified by the SERVICE ACTION RESERVATION KEY field;
+	 */
+	__core_scsi3_complete_pro_release(dev, pr_res_holder->pr_reg_nacl,
+				dev->dev_pr_res_holder, 0);
+	/*
+	 * b) Remove the registrations for all I_T nexuses identified
+	 *    by the SERVICE ACTION RESERVATION KEY field, except the
+	 *    I_T nexus that is being used for the PERSISTENT RESERVE
+	 *    OUT command. If an all registrants persistent reservation
+	 *    is present and the SERVICE ACTION RESERVATION KEY field
+	 *    is set to zero, then all registrations shall be removed
+	 *    except for that of the I_T nexus that is being used for
+	 *    the PERSISTENT RESERVE OUT command;
+	 */
+	spin_lock(&pr_tmpl->registration_lock);
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
+			&pr_tmpl->registration_list, pr_reg_list) {
+
+		calling_it_nexus = (pr_reg_n == pr_reg) ? 1 : 0;
+		if (calling_it_nexus)
+			continue;
+
+		if (!(all_reg))
+			if (pr_reg->pr_res_key != sa_res_key)
+				continue;
+
+		pr_reg_nacl = pr_reg->pr_reg_nacl;
+		pr_res_mapped_lun = pr_reg->pr_res_mapped_lun;
+		__core_scsi3_free_registration(dev, pr_reg,
+				calling_it_nexus);
+		/*
+		 * e) Establish a unit attention condition for the initiator
+		 *    port associated with every I_T nexus that lost its
+		 *    persistent reservation and/or registration, with the
+		 *    additional sense code set to REGISTRATIONS PREEMPTED;
+		 */
+		core_scsi3_ua_allocate(pr_reg_nacl, pr_res_mapped_lun, 0x2A,
+				ASCQ_2AH_RESERVATIONS_PREEMPTED);
+	}
+	spin_unlock(&pr_tmpl->registration_lock);
+	/*
+	 * c) Establish a persistent reservation for the preempting
+	 *    I_T nexus using the contents of the SCOPE and TYPE fields;
+	 */
+	__core_scsi3_complete_pro_preempt(dev, pr_reg_n, type, scope);
+	/*
+	 * d) Process tasks as defined in 5.7.1;
+	 * e) See above..
+	 * f) If the type or scope has changed, then for every I_T nexus
+	 *    whose reservation key was not removed, except for the I_T
+	 *    nexus on which the PERSISTENT RESERVE OUT command was
+	 *    received, the device server shall establish a unit
+	 *    attention condition for the initiator port associated with
+	 *    that I_T nexus, with the additional sense code set to
+	 *    RESERVATIONS RELEASED. If the type or scope have not
+	 *    changed, then no unit attention condition(s) shall be
+	 *    established for this reason.
+	 */
+	if ((prh_type != type) || (prh_scope != scope)) {
+		spin_lock(&pr_tmpl->registration_lock);
+		list_for_each_entry_safe(pr_reg, pr_reg_tmp,
+			&pr_tmpl->registration_list, pr_reg_list) {
+
+			calling_it_nexus = (pr_reg_n == pr_reg) ? 1 : 0;
+			if (calling_it_nexus)
+				continue;
+
+			core_scsi3_ua_allocate(pr_reg->pr_reg_nacl,
+					pr_reg->pr_res_mapped_lun, 0x2A,
+					ASCQ_2AH_RESERVATIONS_RELEASED);
+		}
+		spin_unlock(&pr_tmpl->registration_lock);
+	}
+	spin_unlock(&dev->dev_reservation_lock);
+
+	core_scsi3_put_pr_reg(pr_reg_n);
 	core_scsi3_pr_generation(SE_DEV(cmd));
 	return 0;
 }
@@ -1396,10 +1698,10 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 			type, scope, res_key);
 	case PRO_CLEAR:
 		return core_scsi3_emulate_pro_clear(cmd, res_key);
-#if 0
 	case PRO_PREEMPT:
-		return core_scsi3_emulate_pro_preempt(cmd,
-			type, scope, res_key, sa_res_key);
+		return core_scsi3_emulate_pro_preempt(cmd, type, scope,
+					res_key, sa_res_key);
+#if 0
 	case PRO_PREEMPT_AND_ABORT:
 		return core_scsi3_emulate_pro_preempt_and_abort(cmd,
 			type, scope, res_key, sa_res_key);
-- 
1.5.4.1



