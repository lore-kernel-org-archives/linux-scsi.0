From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [Target_Core_Mod/Persistent_Reservations]: Add PROUT
	CLEAR service action
Date: Thu, 19 Mar 2009 01:57:15 -0700
Message-ID: <1237453035.4138.39.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n29.bullet.mail.mud.yahoo.com ([68.142.207.48]:22726 "HELO
	n29.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757487AbZCSI5T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2009 04:57:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>

>From 158217e58f9be1384fb06c4e296392101c7434f5 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Mar 2009 00:50:25 -0700
Subject: [PATCH 2/2] [Target_Core_Mod/Persistent_Reservations]: Add PROUT CLEAR service action

This patch adds support for the PROUT CLEAR service action, which releases
any associated reservation and all registrations, as long as the calling
I_T nexus has a registration valid Reservation Key.

Support for unit-attention + RESERVATIONS PREEMPTED is listed as a FIXME
in the code, and is a WIP.

Here is what it looks like in action with the same SCSI target device
across multiple iSCSI Target Portal Groups (eg: relivate target port 0x1 and 0x2)):
In the example, the I_T Nexus NOT holding the reservation (/dev/sde) is able to
successfully call PROUT CLEAR on the target port, this is the expected
behaviour as defined by spc4r17, section 5.7.11.6

initiator# sg_persist --out --register --param-sark=0x1234abcd -Y -v /dev/sdf
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 00 00 00 00 00 00 00 18 00
PR out: command (Register) successful

initiator# sg_persist --out --register --param-sark=0x4567ffff -Y -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 00 00 00 00 00 00 00 18 00
PR out: command (Register) successful

iniiator# sg_persist --out --reserve --param-rk=0x1234abcd --prout-type=5 -v /dev/sdf
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 01 05 00 00 00 00 00 18 00
PR out: command (Reserve) successful

initiator# sg_persist --out --clear --param-rk=0x4567ffff -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 03 00 00 00 00 00 00 18 00
PR out: command (Clear) successful

*) dmesg from lio-core-2.6.git node

SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234abcd PRgeneration: 0x00000000
SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000004567ffff PRgeneration: 0x00000001
SPC-3 PR [iSCSI] Service Action: RESERVE created new reservation holder TYPE: Write Exclusive Access, Registrants Only ALL_TG_PT: 1
SPC-3 PR [iSCSI] RESERVE Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] Service Action: implict RELEASE cleared reservation holder TYPE: Write Exclusive Access, Registrants Only ALL_TG_PT: 1
SPC-3 PR [iSCSI] RELEASE Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] Service Action: UNREGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234abcd PRgeneration: 0x00000000
SPC-3 PR [iSCSI] Service Action: UNREGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000004567ffff PRgeneration: 0x00000001
SPC-3 PR [iSCSI] Service Action: CLEAR complete

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pr.c |   63 +++++++++++++++++++++++++++++++++++-
 1 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index cce50dc..d733bae 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -1149,7 +1149,66 @@ static int core_scsi3_emulate_pro_clear(
 	se_cmd_t *cmd,
 	u64 res_key)
 {
-	core_scsi3_pr_generation(SE_DEV(cmd));
+	se_device_t *dev = cmd->se_dev;
+	se_session_t *se_sess = SE_SESS(cmd);
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	t10_pr_registration_t *pr_reg, *pr_reg_tmp, *pr_reg_n, *pr_res_holder;
+	/*
+	 * Locate the existing *pr_reg via se_node_acl_t pointers
+	 */
+	pr_reg_n = core_scsi3_locate_pr_reg(SE_DEV(cmd),
+			se_sess->se_node_acl);
+	if (!(pr_reg_n)) {
+		printk(KERN_ERR "SPC-3 PR: Unable to locate"
+			" PR_REGISTERED *pr_reg for CLEAR\n");
+			return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+	/*
+	 * From spc4r17 section 5.7.11.6, Clearing:
+	 *
+	 * Any application client may release the persistent reservation and
+	 * remove all registrations from a device server by issuing a
+	 * PERSISTENT RESERVE OUT command with CLEAR service action through a
+	 * registered I_T nexus with the following parameter:
+	 *
+	 *	a) RESERVATION KEY field set to the value of the reservation key
+	 * 	   that is registered with the logical unit for the I_T nexus.
+	 */
+	if (res_key != pr_reg_n->pr_res_key) {
+		printk(KERN_ERR "SPC-3 PR REGISTER: Received"
+			" res_key: 0x%016Lx does not match"
+			" existing SA REGISTER res_key:"
+			" 0x%016Lx\n", res_key, pr_reg_n->pr_res_key);
+		core_scsi3_put_pr_reg(pr_reg_n);
+		return PYX_TRANSPORT_RESERVATION_CONFLICT;
+	}
+	/*
+	 * a) Release the persistent reservation, if any;
+	 */
+	spin_lock(&dev->dev_reservation_lock);
+	pr_res_holder = dev->dev_pr_res_holder;
+	if (pr_res_holder) {
+		se_node_acl_t *pr_res_nacl = pr_res_holder->pr_reg_nacl;
+		__core_scsi3_complete_pro_release(dev, pr_res_nacl,
+			pr_res_holder, 0);
+	}
+	spin_unlock(&dev->dev_reservation_lock);
+	/*
+	 * b) Remove all registration(s) (see spc4r17 5.7.7);
+	 */
+	spin_lock(&pr_tmpl->registration_lock);
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
+			&pr_tmpl->registration_list, pr_reg_list) {
+#warning FIXME: UA + RESERVATIONS PREEMPTED for all other registered I_T nexuses
+		__core_scsi3_free_registration(dev, pr_reg,
+					(pr_reg_n == pr_reg) ? 1 : 0);
+	}
+	spin_unlock(&pr_tmpl->registration_lock);
+
+	printk(KERN_INFO "SPC-3 PR [%s] Service Action: CLEAR complete\n",
+		CMD_TFO(cmd)->get_fabric_name());
+
+	core_scsi3_pr_generation(dev);
 	return 0;
 }
 
@@ -1246,9 +1305,9 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 	case PRO_RELEASE:
 		return core_scsi3_emulate_pro_release(cmd,
 			type, scope, res_key);
-#if 0
 	case PRO_CLEAR:
 		return core_scsi3_emulate_pro_clear(cmd, res_key);
+#if 0
 	case PRO_PREEMPT:
 		return core_scsi3_emulate_pro_preempt(cmd,
 			type, scope, res_key, sa_res_key);
-- 
1.5.4.1




