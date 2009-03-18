From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [Target_Core_Mod/Persistent_Reservations]: Allow non
	WRITE CDBs from unregistered initiators
Date: Tue, 17 Mar 2009 18:50:45 -0700
Message-ID: <1237341045.4214.53.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n26.bullet.mail.mud.yahoo.com ([68.142.206.221]:47048 "HELO
	n26.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756593AbZCRBvO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 21:51:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>

>From 669b1b2d3d69a5a31eae803f85baa1fe4295b190 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 17 Mar 2009 16:34:38 -0700
Subject: [PATCH 2/2] [Target_Core_Mod/Persistent_Reservations]: Allow non WRITE CDBs from unregistered initiators

This patch allows unregistered initiators to issue non WRITE CDBs when a PR_TYPE_WRITE_EXCLUSIVE,
PR_TYPE_WRITE_EXCLUSIVE_REGONLY or PR_TYPE_WRITE_EXCLUSIVE_ALLREG reservation is held for a
given Logical Unit.

Previously we expected initiators to PROUT REGISTER before allowing a LUN to accept any CDBs beyond
the explictly allowed CDBs list (as defined by spc4r17, table 45) when a reservation was held by
another initiator port in core_scsi3_pr_seq_non_holder().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pr.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index a76535f..82dde64 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -191,6 +191,8 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for the persistent reservation
 		 * holder.
 		 */
+		if (se_deve->deve_flags & DEF_PR_REGISTERED)
+			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
 		we = 1;
@@ -350,14 +352,22 @@ static int core_scsi3_pr_seq_non_holder(
 				" to %s reservation\n", cdb[0],
 				core_scsi3_pr_dump_type(pr_reg_type));
 			return 1;
-		} else if (registered_nexus) {
+		} else {
 			/*
-			 * Allow non WRITE CDBs for PR_*_REG_ONLY and
-			 * PR_*_ALL_REG to pass for registered_nexuxes.
+			 * Allow non WRITE CDBs for all Write Exclusive
+			 * PR TYPEs to pass for registered and
+			 * non-registered_nexuxes NOT holding the reservation.
+			 *
+			 * We only make noise for the unregisterd nexuses,
+			 * as we expect registered non-reservation holding
+			 * nexuses to issue CDBs.
 			 */
-			printk(KERN_INFO "Allowing implict CDB: 0x%02x for %s"
-				" reservation\n", cdb[0],
-				core_scsi3_pr_dump_type(pr_reg_type));
+			if (!(registered_nexus)) {
+				printk(KERN_INFO "Allowing implict CDB: 0x%02x"
+					" for %s reservation on unregistered"
+					" nexus\n", cdb[0],
+					core_scsi3_pr_dump_type(pr_reg_type));
+			}
 			return 0;
 		}
 	} else if (all_reg) {
-- 
1.5.4.1




