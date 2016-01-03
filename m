From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 44/78] ncr5380: Fix off-by-one bug in extended_msg[] bounds check
Date: Sun, 03 Jan 2016 16:05:45 +1100
Message-ID: <20160103050512.683368925@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49454 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcACFST (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 00:18:19 -0500
Content-Disposition: inline; filename=ncr5380-extended-message-length
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Fix the array bounds check when transferring an extended message from the
target.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |    3 ++-
 drivers/scsi/atari_NCR5380.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:57.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:59.000000000 +1100
@@ -2039,7 +2039,8 @@ static void NCR5380_information_transfer
 
 					dprintk(NDEBUG_EXTENDED, "scsi%d : length=%d, code=0x%02x\n", instance->host_no, (int) extended_msg[1], (int) extended_msg[2]);
 
-					if (!len && extended_msg[1] <= (sizeof(extended_msg) - 1)) {
+					if (!len && extended_msg[1] > 0 &&
+					    extended_msg[1] <= sizeof(extended_msg) - 2) {
 						/* Accept third byte by clearing ACK */
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 						len = extended_msg[1] - 1;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:57.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:59.000000000 +1100
@@ -2330,8 +2330,8 @@ static void NCR5380_information_transfer
 					dprintk(NDEBUG_EXTENDED, "scsi%d: length=%d, code=0x%02x\n", HOSTNO,
 						   (int)extended_msg[1], (int)extended_msg[2]);
 
-					if (!len && extended_msg[1] <=
-					    (sizeof(extended_msg) - 1)) {
+					if (!len && extended_msg[1] > 0 &&
+					    extended_msg[1] <= sizeof(extended_msg) - 2) {
 						/* Accept third byte by clearing ACK */
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 						len = extended_msg[1] - 1;


