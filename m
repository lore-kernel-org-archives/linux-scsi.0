From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] [TCM/PR]: Add support for compatible reservation handling (CRH=1)
Date: Mon,  8 Mar 2010 11:51:00 -0800
Message-ID: <1268077860-19734-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:23576 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755086Ab0CHTvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2010 14:51:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds proper support for compatible reservation handling (CRH=1) as defined by
SPC-4 Section 15.7.3 'Exceptions to SPC-2 RESERVE and RELEASE behavior' in a new function
core_scsi2_emulate_crh().  This CRH=1 logic allows legacy RESERVE and RELEASE to be completed GOOD
status in the following cases when an >= SPC-3 reservation or registration(s) exist:

                a) An I_T nexus that is a persistent reservation holder; or
                b) An I_T nexus that is registered if a registrants only or
                   all registrants type persistent reservation is present.

This patch also adds a SPC-2 defined check in the new core_scsi2_emulate_crh() to return
RESERVATION_CONFLICT when any other >= SPC-3 registrations exist that are not allowed by
CRH=1 logic.  It also adds the reserve check in core_scsi3_emulate_pr() to return RESERVATION_CONFLICT
for any received PERSISTENT_RESERVE_[IN,OUT] CDB when a legacy SPC-2 reservation is held.

Finally, this patch adds checks in core_scsi3_pr_seq_non_holder() and
core_scsi3_pr_reservation_check() to make the calls to core_scsi2_reservation_seq_non_holder()
and core_scsi2_reservation_check() respectively when a legacy SPC-2 reservation exists.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c |  176 +++++++++++++++++++++++++++++----------
 include/target/target_core_pr.h |    1 +
 2 files changed, 131 insertions(+), 46 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 93c4f7c..a1fcb56 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2,10 +2,10 @@
  * Filename:  target_core_pr.c
  *
  * This file contains SPC-3 compliant persistent reservations and
- * legacy SPC-2 reservations.
+ * legacy SPC-2 reservations with compatible reservation handling (CRH=1)
  *
- * Copyright (c) 2009 Rising Tide, Inc.
- * Copyright (c) 2009 Linux-iSCSI.org
+ * Copyright (c) 2009, 2010 Rising Tide, Inc.
+ * Copyright (c) 2009, 2010 Linux-iSCSI.org
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
@@ -120,6 +120,7 @@ int core_scsi2_reservation_release(se_cmd_t *cmd)
 		return 0;
 	}
 	dev->dev_reserved_node_acl = NULL;
+	dev->dev_flags &= ~DF_SPC2_RESERVATIONS;
 	printk(KERN_INFO "SCSI-2 Released reservation for %s LUN: %u ->"
 		" MAPPED LUN: %u for %s\n", TPG_TFO(tpg)->get_fabric_name(),
 		SE_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
@@ -140,9 +141,8 @@ int core_scsi2_reservation_reserve(se_cmd_t *cmd)
 	    (T_TASK(cmd)->t_task_cdb[1] & 0x02)) {
 		printk(KERN_ERR "LongIO and Obselete Bits set, returning"
 				" ILLEGAL_REQUEST\n");
-		return -1;
+		return PYX_TRANSPORT_ILLEGAL_REQUEST;
 	}
-
 	/*
 	 * This is currently the case for target_core_mod passthrough se_cmd_t
 	 * ops
@@ -163,7 +163,7 @@ int core_scsi2_reservation_reserve(se_cmd_t *cmd)
 			cmd->se_deve->mapped_lun,
 			sess->se_node_acl->initiatorname);
 		spin_unlock(&dev->dev_reservation_lock);
-		return 1;
+		return PYX_TRANSPORT_RESERVATION_CONFLICT;
 	}
 
 	dev->dev_reserved_node_acl = sess->se_node_acl;
@@ -178,6 +178,99 @@ int core_scsi2_reservation_reserve(se_cmd_t *cmd)
 }
 EXPORT_SYMBOL(core_scsi2_reservation_reserve);
 
+static t10_pr_registration_t *core_scsi3_locate_pr_reg(se_device_t *,
+					se_node_acl_t *);
+static void core_scsi3_put_pr_reg(t10_pr_registration_t *);
+
+/*
+ * Setup in target_core_transport.c:transport_generic_cmd_sequencer()
+ * and called via struct se_cmd_s->transport_emulate_cdb() in TCM processing
+ * thread context.
+ */
+int core_scsi2_emulate_crh(struct se_cmd_s *cmd)
+{
+	se_session_t *se_sess = cmd->se_sess;
+	se_subsystem_dev_t *su_dev = cmd->se_dev->se_sub_dev;
+	t10_pr_registration_t *pr_reg;
+	t10_reservation_template_t *pr_tmpl = &su_dev->t10_reservation;
+	unsigned char *cdb = &T_TASK(cmd)->t_task_cdb[0];
+	int crh = (T10_RES(su_dev)->res_type == SPC3_PERSISTENT_RESERVATIONS);
+	int conflict = 0;
+
+	if (!(se_sess))
+		return 0;
+
+	if (!(crh))
+		goto after_crh;
+
+	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl);
+	if (pr_reg) {
+		/*
+		 * From spc4r17 5.7.3 Exceptions to SPC-2 RESERVE and RELEASE
+		 * behavior
+		 *
+		 * A RESERVE(6) or RESERVE(10) command shall complete with GOOD
+		 * status, but no reservation shall be established and the
+		 * persistent reservation shall not be changed, if the command
+		 * is received from a) and b) below.
+		 *
+		 * A RELEASE(6) or RELEASE(10) command shall complete with GOOD
+		 * status, but the persistent reservation shall not be released,
+		 * if the command is received from a) and b)
+		 * 
+		 * a) An I_T nexus that is a persistent reservation holder; or
+		 * b) An I_T nexus that is registered if a registrants only or
+		 *    all registrants type persistent reservation is present.
+		 *
+		 * In all other cases, a RESERVE(6) command, RESERVE(10) command,
+		 * RELEASE(6) command, or RELEASE(10) command shall be processed
+		 * as defined in SPC-2.
+		 */
+		if (pr_reg->pr_res_holder) {
+			core_scsi3_put_pr_reg(pr_reg);
+			return 0;
+		}
+		if ((pr_reg->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_REGONLY) ||
+		    (pr_reg->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_REGONLY) ||
+		    (pr_reg->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
+		    (pr_reg->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
+			core_scsi3_put_pr_reg(pr_reg);
+			return 0;
+		}
+		core_scsi3_put_pr_reg(pr_reg);
+		conflict = 1;
+	} else {
+		/*
+		 * Following spc2r20 5.5.1 Reservations overview:
+		 *
+		 * If a logical unit has executed a PERSISTENT RESERVE OUT
+		 * command with the REGISTER or the REGISTER AND IGNORE
+		 * EXISTING KEY service action and is still registered by any
+		 * initiator, all RESERVE commands and all RELEASE commands
+		 * regardless of initiator shall conflict and shall terminate
+		 * with a RESERVATION CONFLICT status.
+		 */
+		spin_lock(&pr_tmpl->registration_lock);	
+		conflict = (list_empty(&pr_tmpl->registration_list)) ? 0 : 1;
+		spin_unlock(&pr_tmpl->registration_lock);
+	}
+
+	if (conflict) {
+		printk(KERN_ERR "Received legacy SPC-2 RESERVE/RELEASE"
+			" while active SPC-3 registrations exist,"
+			" returning RESERVATION_CONFLICT\n");
+		return PYX_TRANSPORT_RESERVATION_CONFLICT;
+	}
+
+after_crh:
+	if ((cdb[0] == RESERVE) || (cdb[0] == RESERVE_10))
+		return core_scsi2_reservation_reserve(cmd);
+	else if ((cdb[0] == RELEASE) || (cdb[0] == RELEASE_10))
+		return core_scsi2_reservation_release(cmd);
+	else
+		return PYX_TRANSPORT_INVALID_CDB_FIELD;		
+}
+
 /*
  * Begin SPC-3/SPC-4 Persistent Reservations emulation support
  *
@@ -197,6 +290,12 @@ static int core_scsi3_pr_seq_non_holder(
 	int we = 0; /* Write Exclusive */
 	int legacy = 0; /* Act like a legacy device and return
 			 * RESERVATION CONFLICT on some CDBs */
+	/*
+	 * A legacy SPC-2 reservation is being held.
+	 */
+	if (cmd->se_dev->dev_flags & DF_SPC2_RESERVATIONS)
+		return core_scsi2_reservation_seq_non_holder(cmd,
+					cdb, pr_reg_type);
 
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 
@@ -287,14 +386,15 @@ static int core_scsi3_pr_seq_non_holder(
 			return -1;
 		}
 		break;
-	/* FIXME PR + legacy RELEASE + RESERVE */
 	case RELEASE:
 	case RELEASE_10:
-		ret = 1; /* Conflict */
+		/* Handled by CRH=1 in core_scsi2_emulate_crh() */
+		ret = 0;
 		break;
 	case RESERVE:
 	case RESERVE_10:
-		ret = 1; /* Conflict */
+		/* Handled by CRH=1 in core_scsi2_emulate_crh() */
+		ret = 0;
 		break;
 	case TEST_UNIT_READY:
 		ret = (legacy) ? 1 : 0; /* Conflict for legacy */
@@ -447,6 +547,11 @@ static int core_scsi3_pr_reservation_check(
 
 	if (!(sess))
 		return 0;
+	/*
+	 * A legacy SPC-2 reservation is being held.
+	 */
+	if (dev->dev_flags & DF_SPC2_RESERVATIONS)
+		return core_scsi2_reservation_check(cmd, pr_reg_type);
 
 	spin_lock(&dev->dev_reservation_lock);
 	if (!(dev->dev_pr_res_holder)) {
@@ -462,22 +567,6 @@ static int core_scsi3_pr_reservation_check(
 	return ret;
 }
 
-static int core_scsi3_legacy_reserve(se_cmd_t *cmd)
-{
-	/*
-	 * FIXME: See spc4r17 Section 5.7.3
-	 */
-	return core_scsi2_reservation_reserve(cmd);
-}
-
-static int core_scsi3_legacy_release(se_cmd_t *cmd)
-{
-	/*
-	 * FIXME: See spc4r17 Section 5.7.3
-	 */
-	return core_scsi2_reservation_release(cmd);
-}
-
 static t10_pr_registration_t *__core_scsi3_alloc_registration(
 	se_device_t *dev,
 	se_node_acl_t *nacl,
@@ -3342,12 +3431,7 @@ static int core_scsi3_pri_report_capabilities(se_cmd_t *cmd)
 
 	buf[0] = ((add_len << 8) & 0xff);
 	buf[1] = (add_len & 0xff);
-	/*
-	 * FIXME: Leave these features disabled for now..
-	 */
-#if 0
 	buf[2] |= 0x10; /* CRH: Compatible Reservation Hanlding bit. */
-#endif
 	buf[2] |= 0x08; /* SIP_C: Specify Initiator Ports Capable bit */
 	buf[2] |= 0x04; /* ATP_C: All Target Ports Capable bit */
 	buf[2] |= 0x01; /* PTPL_C: Persistence across Target Power Loss bit */
@@ -3535,6 +3619,22 @@ static int core_scsi3_emulate_pr_in(se_cmd_t *cmd, unsigned char *cdb)
 int core_scsi3_emulate_pr(se_cmd_t *cmd)
 {
 	unsigned char *cdb = &T_TASK(cmd)->t_task_cdb[0];
+	se_device_t *dev = cmd->se_dev;
+	/*
+	 * Following spc2r20 5.5.1 Reservations overview:
+	 *
+	 * If a logical unit has been reserved by any RESERVE command and is
+	 * still reserved by any initiator, all PERSISTENT RESERVE IN and all
+	 * PERSISTENT RESERVE OUT commands shall conflict regardless of
+	 * initiator or service action and shall terminate with a RESERVATION
+	 * CONFLICT status.
+	 */
+	if (dev->dev_flags & DF_SPC2_RESERVATIONS) {
+		printk(KERN_ERR "Received PERSISTENT_RESERVE CDB while legacy"
+			" SPC-2 reservation is held, returning"
+			" RESERVATION_CONFLICT\n");
+		return PYX_TRANSPORT_RESERVATION_CONFLICT;
+	}
 
 	return (cdb[0] == PERSISTENT_RESERVE_OUT) ?
 	       core_scsi3_emulate_pr_out(cmd, cdb) :
@@ -3546,16 +3646,6 @@ static int core_pt_reservation_check(se_cmd_t *cmd, u32 *pr_res_type)
 	return 0;
 }
 
-static int core_pt_reserve(se_cmd_t *cmd)
-{
-	return 0;
-}
-
-static int core_pt_release(se_cmd_t *cmd)
-{
-	return 0;
-}
-
 static int core_pt_seq_non_holder(
 	se_cmd_t *cmd,
 	unsigned char *cdb,
@@ -3578,8 +3668,6 @@ int core_setup_reservations(se_device_t *dev)
 	    !(DEV_ATTRIB(dev)->emulate_reservations)) {
 		rest->res_type = SPC_PASSTHROUGH;
 		rest->t10_reservation_check = &core_pt_reservation_check;
-		rest->t10_reserve = &core_pt_reserve;
-		rest->t10_release = &core_pt_release;
 		rest->t10_seq_non_holder = &core_pt_seq_non_holder;
 		printk(KERN_INFO "%s: Using SPC_PASSTHROUGH, no reservation"
 			" emulation\n", TRANSPORT(dev)->name);
@@ -3592,16 +3680,12 @@ int core_setup_reservations(se_device_t *dev)
 	if (TRANSPORT(dev)->get_device_rev(dev) >= SCSI_3) {
 		rest->res_type = SPC3_PERSISTENT_RESERVATIONS;
 		rest->t10_reservation_check = &core_scsi3_pr_reservation_check;
-		rest->t10_reserve = &core_scsi3_legacy_reserve;
-		rest->t10_release = &core_scsi3_legacy_release;
 		rest->t10_seq_non_holder = &core_scsi3_pr_seq_non_holder;
 		printk(KERN_INFO "%s: Using SPC3_PERSISTENT_RESERVATIONS"
 			" emulation\n", TRANSPORT(dev)->name);
 	} else {
 		rest->res_type = SPC2_RESERVATIONS;
 		rest->t10_reservation_check = &core_scsi2_reservation_check;
-		rest->t10_reserve = &core_scsi2_reservation_reserve;
-		rest->t10_release = &core_scsi2_reservation_release;
 		rest->t10_seq_non_holder =
 				&core_scsi2_reservation_seq_non_holder;
 		printk(KERN_INFO "%s: Using SPC2_RESERVATIONS emulation\n",
diff --git a/include/target/target_core_pr.h b/include/target/target_core_pr.h
index c791506..08e365b 100644
--- a/include/target/target_core_pr.h
+++ b/include/target/target_core_pr.h
@@ -45,6 +45,7 @@
 
 extern struct kmem_cache *t10_pr_reg_cache;
 
+extern int core_scsi2_emulate_crh(struct se_cmd_s *);
 extern int core_scsi3_alloc_aptpl_registration(
 			struct t10_reservation_template_s *, u64,
 			unsigned char *, u32, unsigned char *, u16, u32,
-- 
1.5.6.5

