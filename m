From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 44/72] ncr5380: Fix off-by-one bug in extended_msg[] bounds check
Date: Sun, 06 Dec 2015 12:32:10 +1100
Message-ID: <20151206013137.915522600@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-extended-message-length
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix the array bounds check when transferring an extended message from the
target.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |    3 ++-
 drivers/scsi/atari_NCR5380.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:30:36.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:30:38.000000000 +1100
@@ -2034,7 +2034,8 @@ static void NCR5380_information_transfer
 
 					dprintk(NDEBUG_EXTENDED, "scsi%d : length=%d, code=0x%02x\n", instance->host_no, (int) extended_msg[1], (int) extended_msg[2]);
 
-					if (!len && extended_msg[1] <= (sizeof(extended_msg) - 1)) {
+					if (!len && extended_msg[1] > 0 &&
+					    extended_msg[1] <= sizeof(extended_msg) - 2) {
 						/* Accept third byte by clearing ACK */
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 						len = extended_msg[1] - 1;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:36.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:38.000000000 +1100
@@ -2325,8 +2325,8 @@ static void NCR5380_information_transfer
 					dprintk(NDEBUG_EXTENDED, "scsi%d: length=%d, code=0x%02x\n", HOSTNO,
 						   (int)extended_msg[1], (int)extended_msg[2]);
 
-					if (!len && extended_msg[1] <=
-					    (sizeof(extended_msg) - 1)) {
+					if (!len && extended_msg[1] > 0 &&
+					    extended_msg[1] <= sizeof(extended_msg) - 2) {
 						/* Accept third byte by clearing ACK */
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 						len = extended_msg[1] - 1;
