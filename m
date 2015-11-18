From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 46/71] ncr5380: Fix NDEBUG_NO_DATAOUT flag
Date: Wed, 18 Nov 2015 19:35:41 +1100
Message-ID: <20151118083509.391680666@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:43893 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbbKRIqe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2015 03:46:34 -0500
Content-Disposition: inline; filename=ncr5380-fix-NDEBUG_NO_DATAOUT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

NDEBUG_NO_DATAOUT should not disable DATA IN phases too. Fix this.
(This bug has long been fixed in atari_NCR5380.c.)

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:34:01.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:34:04.000000000 +1100
@@ -1833,7 +1833,6 @@ static void NCR5380_information_transfer
 				continue;
 			}
 			switch (phase) {
-			case PHASE_DATAIN:
 			case PHASE_DATAOUT:
 #if (NDEBUG & NDEBUG_NO_DATAOUT)
 				printk("scsi%d : NDEBUG_NO_DATAOUT set, attempted DATAOUT aborted\n", instance->host_no);
@@ -1843,6 +1842,7 @@ static void NCR5380_information_transfer
 				cmd->scsi_done(cmd);
 				return;
 #endif
+			case PHASE_DATAIN:
 				/* 
 				 * If there is no room left in the current buffer in the
 				 * scatter-gather list, move onto the next one.


