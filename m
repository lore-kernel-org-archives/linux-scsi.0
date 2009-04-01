From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/Persistent_Reservations]: Make
	'Registrants only' reservations allow multiple writers
Date: Wed, 01 Apr 2009 12:23:15 -0700
Message-ID: <1238613795.4250.333.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934076AbZDATXm@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Brad Fennell <wavebender@hotmail.com>, Jason Hodges <jasonahodges@gmail.com>, Rafiu Fakunle <rafiu@openfiler.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Greetings All,

This patch changes core_scsi3_pr_seq_non_holder() to allow 'Registrants only'
reservations to allow multiple writers from the reservation holder, and all registered
I_T Nexuses.  Previously, only 'All Registrants' reservations where allowed
to to have multiple writers because each registration in a 'All Registrants' reservation is
considered the reservation holder.

This patch allows an I_T nexus to write who is NOT the reservation holder, but does have
a valid registration.

These patches are made against lio-core-2.6.git/master and tested on
v2.6.29 x86 32-bit HVM using sg_persist from sg3_utils.  The lio-core-2.6.git tree
can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Here is what it looks like from the initiator side with /dev/sde and /dev/sdf representing
the same IBLOCK exported storage object across two different I_T nexuses:

[3:0:0:0]    disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd,t,0x1  /dev/sde
[4:0:0:0]    disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0,t,0x1  /dev/sdf

*) Register and and create a 'Write Exclusive, Registrants Only' reservation for /dev/sde

initiator# sg_persist --out --register-ignore --param-sark=0x1234abcd -Y -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 06 00 00 00 00 00 00 18 00
PR out: command (Register and ignore existing key) successful
initiator# sg_persist --out --reserve --param-rk=0x1234abcd --prout-type=5 -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 01 05 00 00 00 00 00 18 00
PR out: command (Reserve) successful

*) Attempt write on a unregistered I_T nexus (fails with RESERVATION CONFLICT):

initiator# dd if=/dev/zero of=/dev/sdf bs=2048 count=1
1+0 records in
1+0 records out
2048 bytes (2.0 kB) copied, 4.4217e-05 seconds, 46.3 MB/s

[ 1160.287946] sd 4:0:0:0: reservation conflict
[ 1160.287971] sd 4:0:0:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
[ 1160.287989] end_request: I/O error, dev sdf, sector 0
[ 1160.288115] Buffer I/O error on device sdf, logical block 0
[ 1160.288183] lost page write due to I/O error on sdf

*) Create a registration on /dev/sdf, while /dev/sde is still holding the reservation.

initiator# sg_persist --out --register-ignore --param-sark=0x4567ffff -Y -v /dev/sdf
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 06 00 00 00 00 00 00 18 00
PR out: command (Register and ignore existing key) successful

*) A Write now succeeds after /dev/sdf has been registered successfully.

initiator# dd if=/dev/zero of=/dev/sdf bs=2048 count=1
1+0 records in
1+0 records out
2048 bytes (2.0 kB) copied, 3.9031e-05 seconds, 52.5 MB/s

*) From the Target side:

SPC-3 PR [iSCSI] Service Action: REGISTER_AND_IGNORE_EXISTING_KEY Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234abcd PRgeneration: 0x00000000
SPC-3 PR [iSCSI] Service Action: RESERVE created new reservation holder TYPE: Write Exclusive Access, Registrants Only ALL_TG_PT: 1
SPC-3 PR [iSCSI] RESERVE Node: iqn.1993-08.org.debian:01:2dadf92d0ef
WRITE Conflict for unregistered nexus iqn.1993-08.org.debian:01:2dadf92d0ef CDB: 0x2a to Write Exclusive Access, Registrants Only reservation
SPC-3 PR [iSCSI] Service Action: REGISTER_AND_IGNORE_EXISTING_KEY Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000004567ffff PRgeneration: 0x00000001

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pr.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index 9fe6da5..63e19ad 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -181,7 +181,7 @@ static int core_scsi3_pr_seq_non_holder(
 	se_lun_t *se_lun = SE_LUN(cmd);
 	int other_cdb = 0;
 	int registered_nexus = 0, ret = 1; /* Conflict by default */
-	int all_reg = 0; /* ALL_REG */
+	int all_reg = 0, reg_only = 0; /* ALL_REG, REG_ONLY */
 	int we = 0; /* Write Exclusive */
 	int legacy = 0; /* Act like a legacy device and return
 			 * RESERVATION CONFLICT on some CDBs */
@@ -205,6 +205,7 @@ static int core_scsi3_pr_seq_non_holder(
 		/*
 		 * Some commands are only allowed for registered I_T Nexuses.
 		 */
+		reg_only = 1;
 		if (se_deve->deve_flags & DEF_PR_REGISTERED)
 			registered_nexus = 1;
 		break;
@@ -349,21 +350,17 @@ static int core_scsi3_pr_seq_non_holder(
 	 * Check if write exclusive initiator ports *NOT* holding the
 	 * WRITE_EXCLUSIVE_* reservation.
 	 */
-	if (we) {
+	if ((we) && !(registered_nexus)) {
 		if ((cmd->data_direction == SE_DIRECTION_WRITE) ||
 		    (cmd->data_direction == SE_DIRECTION_BIDI)) {
 			/*
 			 * Conflict for write exclusive
 			 */
-			printk(KERN_INFO "WRITE Conflict for %sregistered nexus"
+			printk(KERN_INFO "%s Conflict for unregistered nexus"
 				" %s CDB: 0x%02x to %s reservation\n",
-				(registered_nexus) ? "" : "un",
+				transport_dump_cmd_direction(cmd),
 				se_sess->se_node_acl->initiatorname, cdb[0],
 				core_scsi3_pr_dump_type(pr_reg_type));
-			if (cdb[0] == PERSISTENT_RESERVE_OUT)
-				printk(KERN_INFO "WRITE Conflict was"
-					" PERSISTENT_RESERVE_OUT, Service"
-					" Action: 0x%02x\n", cdb[1] & 0x1f);
 			return 1;
 		} else {
 			/*
@@ -385,20 +382,25 @@ static int core_scsi3_pr_seq_non_holder(
 #endif
 			return 0;
 		}
-	} else if (all_reg) {
+	} else if ((reg_only) || (all_reg)) {
 		if (registered_nexus) {
 			/*
-			 * For PR_*_ALL_REG reservation, treat all registered
-			 * nexuses as the reservation holder.
+			 * For PR_*_REG_ONLY and PR_*_ALL_REG reservations,
+			 * allow commands from registered nexuses.
 			 */
+#if 0
 			printk(KERN_INFO "Allowing implict CDB: 0x%02x for %s"
 				" reservation\n", cdb[0],
 				core_scsi3_pr_dump_type(pr_reg_type));
+#endif
 			return 0;
 		}
 	}
-	printk(KERN_INFO "Conflict for CDB: 0x%2x for %s reservation\n",
-		cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
+	printk(KERN_INFO "%s Conflict for %sregistered nexus %s CDB: 0x%2x"
+		" for %s reservation\n", transport_dump_cmd_direction(cmd),
+		(registered_nexus) ? "" : "un",
+		se_sess->se_node_acl->initiatorname, cdb[0],
+		core_scsi3_pr_dump_type(pr_reg_type));
 
 	return 1; /* Conflict by default */
 }
-- 
1.5.4.1
