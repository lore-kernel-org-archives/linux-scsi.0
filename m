From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/Persistent_Reservations]: Add
	PRO_REGISTER_AND_IGNORE_EXISTING_KEY support
Date: Sat, 14 Mar 2009 01:47:27 -0700
Message-ID: <1237020447.11120.1101.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n16a.bullet.mail.mud.yahoo.com ([68.142.207.126]:37278 "HELO
	n16a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751174AbZCNIxz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2009 04:53:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Greetings all,

This patch adds support for SPC-3 compliant PRO_REGISTER_AND_IGNORE_EXISTING_KEY
operation in lio-core-2.6.git.  The patch modifies core_scsi3_emulate_pro_register() by
adding 'int ignore_key' and ignored the conditional for (res_key != pr_reg->pr_res_key)
with ignore_key == 1.

Currently MSFT Windows 2008 cluster services depend upon this PERSISTENT_RESERVE_OUT logic
being supported (the patch is pretty simple to the existing REGISTER code btw).  If you
are currently testing LIO v3.0 code against (any) cluster side client setup, please let us
know your progress on: http://groups.google.com/group/linux-iscsi-target-dev

This patch are made against lio-core-2.6.git/master and tested on v2.6.29-rc5 x86
32-bit HVM. The lio-core-2.6.git tree can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

This patch has been tested with sg_persist from sg3_utils, here is what it looks like:

initiator# sg_persist --out --register-ignore --param-sark=0x1234abcd -Y -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  v3.
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 06 00 00 00 00 00 00 18 00
PR out: command (Register and ignore existing key) successful

initiator# sg_persist --out --reserve --param-rk=0x1234abcd --prout-type=1 -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  v3.
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 01 01 00 00 00 00 00 18 00
PR out: command (Reserve) successful

initiator# sg_persist --in --read-full-status /dev/sde -v
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  v3.
  Peripheral device type: disk
    Persistent Reservation In cmd: 5e 03 00 00 00 00 00 20 00 00
  PR generation=0x1
    Key=0x1234abcd
      All target ports bit set
      << Reservation holder >>
      scope: LU_SCOPE,  type: Write Exclusive
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef

initiator# sg_persist --out --register-ignore --param-sark=0x4321dcba -Y -v /dev/sde -v
open /dev/sde with flags=0x800
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  v3.
  Peripheral device type: disk
open /dev/sde with flags=0x802
    Persistent Reservation Out cmd: 5f 06 00 00 00 00 00 00 18 00 
    Persistent Reservation Out parameters:
 00     00 00 00 00 00 00 00 00  00 00 00 00 43 21 dc ba    ............C!..
 10     00 00 00 00 04 00 00 00                             ........        
PR out: command (Register and ignore existing key) successful

*) dmesg output

PC-3 PR [iSCSI] Service Action: REGISTER_AND_IGNORE_EXISTING_KEY Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234abcd PRgeneration: 0x00000000
SPC-3 PR [iSCSI] Service Action: RESERVE created new reservation holder TYPE: Write Exclusive Access ALL_TG_PT: 1
SPC-3 PR [iSCSI] RESERVE Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] REGISTER_AND_IGNORE_EXISTING_KEY: Changed Reservation Key for iqn.1993-08.org.debian:01:2dadf92d0ef to: 0x00000000005678ef PRgeneration: 0x00000001
SPC-3 PR [iSCSI] REGISTER_AND_IGNORE_EXISTING_KEY: Changed Reservation Key for iqn.1993-08.org.debian:01:2dadf92d0ef to: 0x000000004321dcba PRgeneration: 0x00000002

*) cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*

SPC-3 Reservation: iSCSI Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 Reservation: All Target Ports registration
0x00000003
SPC-3 Reservation: iSCSI Target Node Endpoint: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
SPC-3 Reservation: Relative Port Identifer Tag: 1 iSCSI Portal Group Tag: 1 iSCSI Logical Unit: 0
SPC-3 PR Registrations:
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000004321dcba PRgen: 0x00000002
SPC-3 Reservation Type: Write Exclusive Access
SPC3_PERSISTENT_RESERVATIONS


Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pr.c |   53 ++++++++++++++++++-------------------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index f948df1..a980e3a 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -314,7 +314,8 @@ static t10_pr_registration_t *core_scsi3_alloc_registration(
 	se_node_acl_t *nacl,
 	se_dev_entry_t *deve,
 	u64 sa_res_key,
-	int all_tg_pt)
+	int all_tg_pt,
+	int ignore_key)
 {
 	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
@@ -344,8 +345,9 @@ static t10_pr_registration_t *core_scsi3_alloc_registration(
 	spin_unlock(&pr_tmpl->registration_lock);
 
 	deve->deve_flags |= DEF_PR_REGISTERED;
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER Initiator"
-		" Node: %s\n", tfo->get_fabric_name(), nacl->initiatorname);
+	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
+		" Node: %s\n", tfo->get_fabric_name(), (ignore_key) ?
+		"_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname);
 	printk(KERN_INFO "SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
 		" Port(s)\n",  tfo->get_fabric_name(),
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
@@ -431,7 +433,8 @@ static int core_scsi3_emulate_pro_register(
 	u64 sa_res_key,
 	int aptpl,
 	int all_tg_pt,
-	int spec_i_pt)
+	int spec_i_pt,
+	int ignore_key)
 {
 	se_session_t *se_sess = SE_SESS(cmd);
 	se_dev_entry_t *se_deve;
@@ -474,7 +477,7 @@ static int core_scsi3_emulate_pro_register(
 			 */
 			pr_reg = core_scsi3_alloc_registration(SE_DEV(cmd),
 					se_sess->se_node_acl, se_deve,
-					sa_res_key, all_tg_pt);
+					sa_res_key, all_tg_pt, ignore_key);
 			if (!(pr_reg)) {
 				printk(KERN_ERR "Unable to allocate"
 					" t10_pr_registration_t\n");
@@ -501,12 +504,15 @@ static int core_scsi3_emulate_pro_register(
 				" PR_REGISTERED *pr_reg\n");
 			return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
-		if (res_key != pr_reg->pr_res_key) {
-			printk(KERN_ERR "SPC-3 PR REGISTER: Received res_key:"
-				" 0x%016Lx does not match existing SA REGISTER"
-				" res_key: 0x%016Lx\n", res_key,
-				pr_reg->pr_res_key);
-			return PYX_TRANSPORT_RESERVATION_CONFLICT;
+		if (!(ignore_key)) {
+			if (res_key != pr_reg->pr_res_key) {
+				printk(KERN_ERR "SPC-3 PR REGISTER: Received"
+					" res_key: 0x%016Lx does not match"
+					" existing SA REGISTER res_key:"
+					" 0x%016Lx\n", res_key,
+					pr_reg->pr_res_key);
+				return PYX_TRANSPORT_RESERVATION_CONFLICT;
+			}
 		}
 		if (spec_i_pt) {
 			printk(KERN_ERR "SPC-3 PR UNREGISTER: SPEC_I_PT"
@@ -529,9 +535,10 @@ static int core_scsi3_emulate_pro_register(
 			pr_reg->pr_res_generation = core_scsi3_pr_generation(
 							SE_DEV(cmd));
 			pr_reg->pr_res_key = sa_res_key;
-			printk("SPC-3 PR [%s] REGISTER: Changed Reservation Key"
-				" for %s to: 0x%016Lx PRgeneration: 0x%08x\n",
-				CMD_TFO(cmd)->get_fabric_name(),
+			printk("SPC-3 PR [%s] REGISTER%s: Changed Reservation"
+				" Key for %s to: 0x%016Lx PRgeneration:"
+				" 0x%08x\n", CMD_TFO(cmd)->get_fabric_name(),
+				(ignore_key) ? "_AND_IGNORE_EXISTING_KEY" : "",
 				pr_reg->pr_reg_nacl->initiatorname,
 				pr_reg->pr_res_key, pr_reg->pr_res_generation);
 		}
@@ -927,16 +934,6 @@ static int core_scsi3_emulate_pro_preempt_and_abort(
 	return 0;
 }
 
-static int core_scsi3_emulate_pro_register_and_ignore_existing_key(
-	se_cmd_t *cmd,
-	int sa_res_key,
-	int aptpl,
-	int all_tg_pt)
-{
-	core_scsi3_pr_generation(SE_DEV(cmd));
-	return 0;
-}
-
 static int core_scsi3_emulate_pro_register_and_move(
 	se_cmd_t *cmd,
 	int type,
@@ -1001,7 +998,7 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 	switch (cdb[1] & 0x1f) {
 	case PRO_REGISTER:
 		return core_scsi3_emulate_pro_register(cmd,
-			res_key, sa_res_key, aptpl, all_tg_pt, spec_i_pt);
+			res_key, sa_res_key, aptpl, all_tg_pt, spec_i_pt, 0);
 	case PRO_RESERVE:
 		return core_scsi3_emulate_pro_reserve(cmd,
 			type, scope, res_key);
@@ -1018,9 +1015,11 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 	case PRO_PREEMPT_AND_ABORT:
 		return core_scsi3_emulate_pro_preempt_and_abort(cmd,
 			type, scope, res_key, sa_res_key);
+#endif
 	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
-		return core_scsi3_emulate_pro_register_and_ignore_existing_key(
-			cmd, sa_res_key, aptpl, all_tg_pt);
+		return core_scsi3_emulate_pro_register(cmd,
+			0, sa_res_key, aptpl, all_tg_pt, spec_i_pt, 1);
+#if 0
 	case PRO_REGISTER_AND_MOVE:
 		return core_scsi3_emulate_pro_register_and_move(cmd,
 			type, scope, res_key, sa_res_key);
-- 
1.5.4.1




