From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 30/77] ncr5380: Add missing break after case MESSAGE_REJECT
Date: Tue, 22 Dec 2015 12:18:08 +1100
Message-ID: <20151222011746.205576191@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40515 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbbLVCbP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 21:31:15 -0500
Content-Disposition: inline; filename=ncr5380-missing-break
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

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
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:16:16.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:16:17.000000000 +1100
@@ -1990,6 +1990,7 @@ static void NCR5380_information_transfer
 					default:
 						break;
 					}
+					break;
 				case DISCONNECT:{
 						/* Accept message by clearing ACK */
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);


