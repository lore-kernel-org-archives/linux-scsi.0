From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 5/5] hpsa: check for dma_mapping_error in hpsa_passthru ioctls
Date: Wed, 20 Feb 2013 11:24:57 -0600
Message-ID: <20130220172457.12929.43721.stgit@beardog.cce.hp.com>
References: <20130220172243.12929.69579.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:33525 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab3BTQZB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2013 11:25:01 -0500
In-Reply-To: <20130220172243.12929.69579.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, shuah.khan@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a7c3d47..7f4f790 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3014,6 +3014,13 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	if (iocommand.buf_size > 0) {
 		temp64.val = pci_map_single(h->pdev, buff,
 			iocommand.buf_size, PCI_DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(&h->pdev->dev, temp64.val)) {
+			c->SG[0].Addr.lower = 0;
+			c->SG[0].Addr.upper = 0;
+			c->SG[0].Len = 0;
+			rc = -ENOMEM;
+			goto out;
+		}
 		c->SG[0].Addr.lower = temp64.val32.lower;
 		c->SG[0].Addr.upper = temp64.val32.upper;
 		c->SG[0].Len = iocommand.buf_size;
@@ -3135,6 +3142,15 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		for (i = 0; i < sg_used; i++) {
 			temp64.val = pci_map_single(h->pdev, buff[i],
 				    buff_size[i], PCI_DMA_BIDIRECTIONAL);
+			if (dma_mapping_error(&h->pdev->dev, temp64.val)) {
+				c->SG[i].Addr.lower = 0;
+				c->SG[i].Addr.upper = 0;
+				c->SG[i].Len = 0;
+				hpsa_pci_unmap(h->pdev, c, i,
+					PCI_DMA_BIDIRECTIONAL);
+				status = -ENOMEM;
+				goto cleanup1;
+			}
 			c->SG[i].Addr.lower = temp64.val32.lower;
 			c->SG[i].Addr.upper = temp64.val32.upper;
 			c->SG[i].Len = buff_size[i];

