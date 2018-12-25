From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] scsi: avoid a double-fetch and a redundant copy
Date: Tue, 25 Dec 2018 14:15:54 -0600
Message-ID: <20181225201554.69395-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

What we need is only "pack_id", so do not create a heap object or copy
the whole object in. The fix efficiently copies "pack_id" only.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/scsi/sg.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c6ad00703c5b..4dacbfffd113 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -446,16 +446,8 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 		}
 		if (old_hdr->reply_len < 0) {
 			if (count >= SZ_SG_IO_HDR) {
-				sg_io_hdr_t *new_hdr;
-				new_hdr = kmalloc(SZ_SG_IO_HDR, GFP_KERNEL);
-				if (!new_hdr) {
-					retval = -ENOMEM;
-					goto free_old_hdr;
-				}
-				retval =__copy_from_user
-				    (new_hdr, buf, SZ_SG_IO_HDR);
-				req_pack_id = new_hdr->pack_id;
-				kfree(new_hdr);
+				retval = get_user(req_pack_id,
+						&((sg_io_hdr_t *)buf->pack_id));
 				if (retval) {
 					retval = -EFAULT;
 					goto free_old_hdr;
-- 
2.17.2 (Apple Git-113)
