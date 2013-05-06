From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: fix memory leak in hpsa_big_passthru_ioctl
Date: Mon, 06 May 2013 09:45:52 -0500
Message-ID: <20130506144551.25227.77241.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6035 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3EFOrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 10:47:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

In the event of a dma mapping error, we forgot to free
the command we had allocated.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7f4f790..97351b4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3149,7 +3149,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 				hpsa_pci_unmap(h->pdev, c, i,
 					PCI_DMA_BIDIRECTIONAL);
 				status = -ENOMEM;
-				goto cleanup1;
+				goto cleanup0;
 			}
 			c->SG[i].Addr.lower = temp64.val32.lower;
 			c->SG[i].Addr.upper = temp64.val32.upper;
@@ -3165,24 +3165,23 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	/* Copy the error information out */
 	memcpy(&ioc->error_info, c->err_info, sizeof(ioc->error_info));
 	if (copy_to_user(argp, ioc, sizeof(*ioc))) {
-		cmd_special_free(h, c);
 		status = -EFAULT;
-		goto cleanup1;
+		goto cleanup0;
 	}
 	if (ioc->Request.Type.Direction == XFER_READ && ioc->buf_size > 0) {
 		/* Copy the data out of the buffer we created */
 		BYTE __user *ptr = ioc->buf;
 		for (i = 0; i < sg_used; i++) {
 			if (copy_to_user(ptr, buff[i], buff_size[i])) {
-				cmd_special_free(h, c);
 				status = -EFAULT;
-				goto cleanup1;
+				goto cleanup0;
 			}
 			ptr += buff_size[i];
 		}
 	}
-	cmd_special_free(h, c);
 	status = 0;
+cleanup0:
+	cmd_special_free(h, c);
 cleanup1:
 	if (buff) {
 		for (i = 0; i < sg_used; i++)

