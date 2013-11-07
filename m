From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 06/11] hpsa: fix memory leak in CCISS_BIG_PASSTHRU ioctl
Date: Thu, 07 Nov 2013 10:45:55 -0600
Message-ID: <20131107164555.3504.56044.stgit@beardog.cce.hp.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:45877 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3KGQp4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 11:45:56 -0500
In-Reply-To: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

We were leaking a command buffer if a DMA mapping error was
encountered in the CCISS_BIG_PASSTHRU ioctl.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b99a0a1..752d234 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3166,7 +3166,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 				hpsa_pci_unmap(h->pdev, c, i,
 					PCI_DMA_BIDIRECTIONAL);
 				status = -ENOMEM;
-				goto cleanup1;
+				goto cleanup0;
 			}
 			c->SG[i].Addr.lower = temp64.val32.lower;
 			c->SG[i].Addr.upper = temp64.val32.upper;
@@ -3182,24 +3182,23 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
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

