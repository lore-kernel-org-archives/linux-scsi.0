From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/5] block-cciss: Less function calls in cciss_bigpassthru()
 after error detection
Date: Thu, 18 Aug 2016 11:56:44 +0200
Message-ID: <d6586ebd-7422-4188-2a5b-af314e06f411@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <686a1f95-a76c-2624-50e1-9d0e59948e64@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <686a1f95-a76c-2624-50e1-9d0e59948e64@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: esc.storagedev@microsemi.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 17 Aug 2016 22:39:31 +0200

The kfree() function was called in a few cases by the
cciss_bigpassthru() function during error handling
even if a passed variable contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/cciss.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index e044342..43ac632 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1593,26 +1593,26 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 	if ((ioc->buf_size < 1) &&
 	    (ioc->Request.Type.Direction != XFER_NONE)) {
 		status = -EINVAL;
-		goto cleanup1;
+		goto free_ioc;
 	}
 	/* Check kmalloc limits  using all SGs */
 	if (ioc->malloc_size > MAX_KMALLOC_SIZE) {
 		status = -EINVAL;
-		goto cleanup1;
+		goto free_ioc;
 	}
 	if (ioc->buf_size > ioc->malloc_size * MAXSGENTRIES) {
 		status = -EINVAL;
-		goto cleanup1;
-	}
-	buff = kzalloc(MAXSGENTRIES * sizeof(char *), GFP_KERNEL);
-	if (!buff) {
-		status = -ENOMEM;
-		goto cleanup1;
+		goto free_ioc;
 	}
 	buff_size = kmalloc(MAXSGENTRIES * sizeof(int), GFP_KERNEL);
 	if (!buff_size) {
 		status = -ENOMEM;
-		goto cleanup1;
+		goto free_ioc;
+	}
+	buff = kzalloc(MAXSGENTRIES * sizeof(char *), GFP_KERNEL);
+	if (!buff) {
+		status = -ENOMEM;
+		goto free_size;
 	}
 	left = ioc->buf_size;
 	data_ptr = ioc->buf;
@@ -1622,12 +1622,12 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 		buff[sg_used] = kmalloc(sz, GFP_KERNEL);
 		if (buff[sg_used] == NULL) {
 			status = -ENOMEM;
-			goto cleanup1;
+			goto free_buffer;
 		}
 		if (ioc->Request.Type.Direction == XFER_WRITE) {
 			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
 				status = -EFAULT;
-				goto cleanup1;
+				goto free_buffer;
 			}
 		} else {
 			memset(buff[sg_used], 0, sz);
@@ -1639,7 +1639,7 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 	c = cmd_special_alloc(h);
 	if (!c) {
 		status = -ENOMEM;
-		goto cleanup1;
+		goto free_buffer;
 	}
 	c->cmd_type = CMD_IOCTL_PEND;
 	c->Header.ReplyQueue = 0;
@@ -1674,7 +1674,7 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 	if (copy_to_user(argp, ioc, sizeof(*ioc))) {
 		cmd_special_free(h, c);
 		status = -EFAULT;
-		goto cleanup1;
+		goto free_buffer;
 	}
 	if (ioc->Request.Type.Direction == XFER_READ) {
 		/* Copy the data out of the buffer we created */
@@ -1683,20 +1683,20 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 			if (copy_to_user(ptr, buff[i], buff_size[i])) {
 				cmd_special_free(h, c);
 				status = -EFAULT;
-				goto cleanup1;
+				goto free_buffer;
 			}
 			ptr += buff_size[i];
 		}
 	}
 	cmd_special_free(h, c);
 	status = 0;
-cleanup1:
-	if (buff) {
-		for (i = 0; i < sg_used; i++)
-			kfree(buff[i]);
-		kfree(buff);
-	}
+free_buffer:
+	for (i = 0; i < sg_used; i++)
+		kfree(buff[i]);
+	kfree(buff);
+free_size:
 	kfree(buff_size);
+free_ioc:
 	kfree(ioc);
 	return status;
 }
-- 
2.9.3
