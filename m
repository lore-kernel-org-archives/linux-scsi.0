From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 30/72] ncr5380: Add missing break after case MESSAGE_REJECT
Date: Sun, 06 Dec 2015 12:31:56 +1100
Message-ID: <20151206013134.345577008@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-missing-break
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

MESSAGE REJECT does not imply DISCONNECT: the target is about to enter
MESSAGE IN or MESSAGE OUT phase.

This bug fix comes from atari_NCR5380.c. Unfortunately it never made it
into the original NCR5380.c core driver.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:30:17.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:30:18.000000000 +1100
@@ -1985,6 +1985,7 @@ static void NCR5380_information_transfer
 					default:
 						break;
 					}
+					break;
 				case DISCONNECT:{
 						/* Accept message by clearing ACK */
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
