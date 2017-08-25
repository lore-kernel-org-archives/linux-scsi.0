From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/3] SCSI-sg: Delete an error message for a failed memory
 allocation in sg_alloc()
Date: Fri, 25 Aug 2017 22:23:56 +0200
Message-ID: <a5815434-a4b8-66bf-f5ff-264b8310ac9d@users.sourceforge.net>
References: <0fffccee-7cc1-1321-2c6b-00ac06b304b8@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0fffccee-7cc1-1321-2c6b-00ac06b304b8@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 25 Aug 2017 21:48:11 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/sg.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d7ff71e0c85c..8ca10a2fc1a0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1404,11 +1404,8 @@ sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	u32 k;
 
 	sdp = kzalloc(sizeof(Sg_device), GFP_KERNEL);
-	if (!sdp) {
-		sdev_printk(KERN_WARNING, scsidp, "%s: kmalloc Sg_device "
-			    "failure\n", __func__);
+	if (!sdp)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	idr_preload(GFP_KERNEL);
 	write_lock_irqsave(&sg_index_lock, iflags);
-- 
2.14.0
