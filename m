From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] sg.c: SG_DXFER_TO_FROM_DEV mean DMA_BIDIRECTIONAL
Date: Sat, 4 Nov 2006 11:58:15 -0800 (PST)
Message-ID: <20465.60059.qm@web31801.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-152056166-1162670295=:60059"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:29079 "HELO
	web31801.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S965326AbWKDT6S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 14:58:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dougg@torque.net>

--0-152056166-1162670295=:60059
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

SG_DXFER_TO_FROM_DEV means DMA_BIDIRECTIONAL, not
DMA_FROM_DEVICE.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/sg.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

This patch is 8 months old.

     Luben
--0-152056166-1162670295=:60059
Content-Type: text/inline; name="sg2.txt"
Content-Description: 2098548068-sg2.txt
Content-Disposition: name="sg2.txt"; filename="sg2.txt"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5a0a193..3f81477 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -608,12 +608,11 @@ sg_write(struct file *filp, const char _
 	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
 		if (printk_ratelimit())
 			printk(KERN_WARNING
-			       "sg_write: data in/out %d/%d bytes for SCSI command 0x%x--"
-			       "guessing data in;\n" KERN_WARNING "   "
-			       "program %s not setting count and/or reply_len properly\n",
+			       "sg_write: program %s: data in/out %d/%d bytes for SCSI command 0x%x--"
+			       "bidirectional;\n",
+			       current->comm,
 			       old_hdr.reply_len - (int)SZ_SG_HEADER,
-			       input_size, (unsigned int) cmnd[0],
-			       current->comm);
+			       input_size, (unsigned int) cmnd[0]);
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }
@@ -724,13 +723,13 @@ sg_common_write(Sg_fd * sfp, Sg_request
 	}
 
 	switch (hp->dxfer_direction) {
-	case SG_DXFER_TO_FROM_DEV:
 	case SG_DXFER_FROM_DEV:
 		data_dir = DMA_FROM_DEVICE;
 		break;
 	case SG_DXFER_TO_DEV:
 		data_dir = DMA_TO_DEVICE;
 		break;
+	case SG_DXFER_TO_FROM_DEV:
 	case SG_DXFER_UNKNOWN:
 		data_dir = DMA_BIDIRECTIONAL;
 		break;
-- 
1.4.3.3.g8478


--0-152056166-1162670295=:60059--
