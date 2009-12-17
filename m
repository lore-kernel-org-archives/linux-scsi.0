From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] cciss: fix reporting of scsi status again.
Date: Thu, 17 Dec 2009 08:22:53 -0600
Message-ID: <20091217142253.10824.4149.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:46351 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762755AbZLQOU6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2009 09:20:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: fix reporting of scsi status again.  This reverts an earlier
attempt to fix the status byte reporting.  The status byte does
not need to be shifted << 1.  Code like "scp-result |= CHECK_CONDITION << 1"
in other drivers works because CHECK_CONDITION is 0x01, not 0x02 --
CHECK_CONDITION is pre-shifted to the right 1 bit for some reason.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 75a9ca9..0634ec7 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -728,7 +728,7 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
-	cmd->result |= (ei->ScsiStatus << 1);
+	cmd->result |= ei->ScsiStatus;
 	/* printk("Scsistatus is 0x%02x\n", ei->ScsiStatus);  */
 
 	/* copy the sense data whether we need to or not. */

