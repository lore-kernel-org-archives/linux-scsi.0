From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 1/3] stex: add small dma buffer support
Date: Mon, 28 Sep 2009 22:58:17 -0800
Message-ID: <200909282258170275597@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:57248 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751918AbZI2GNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 02:13:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>

The controllers of st_seq and st_vsc type can work
if only small dma buffer is available, with a reduced
firmware feature set. Add support for this case.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

 drivers/scsi/stex.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 09fa886..af5bafc 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -160,6 +160,7 @@ enum {
 	INQUIRY_EVPD				= 0x01,
 
 	ST_ADDITIONAL_MEM			= 0x200000,
+	ST_ADDITIONAL_MEM_MIN			= 0x80000,
 };
 
 struct st_sgitem {
@@ -1001,7 +1002,7 @@ static int stex_common_handshake(struct st_hba *hba)
 	h->partner_type = HMU_PARTNER_TYPE;
 	if (hba->extra_offset) {
 		h->extra_offset = cpu_to_le32(hba->extra_offset);
-		h->extra_size = cpu_to_le32(ST_ADDITIONAL_MEM);
+		h->extra_size = cpu_to_le32(hba->dma_size - hba->extra_offset);
 	} else
 		h->extra_offset = h->extra_size = 0;
 
@@ -1528,10 +1529,24 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hba->dma_mem = dma_alloc_coherent(&pdev->dev,
 		hba->dma_size, &hba->dma_handle, GFP_KERNEL);
 	if (!hba->dma_mem) {
-		err = -ENOMEM;
-		printk(KERN_ERR DRV_NAME "(%s): dma mem alloc failed\n",
-			pci_name(pdev));
-		goto out_iounmap;
+		/* Retry minimum coherent mapping for st_seq and st_vsc */
+		if (hba->cardtype == st_seq ||
+		    (hba->cardtype == st_vsc && (pdev->subsystem_device & 1))) {
+			printk(KERN_WARNING DRV_NAME
+				"(%s): allocating min buffer for controller\n",
+				pci_name(pdev));
+			hba->dma_size = hba->extra_offset
+				+ ST_ADDITIONAL_MEM_MIN;
+			hba->dma_mem = dma_alloc_coherent(&pdev->dev,
+				hba->dma_size, &hba->dma_handle, GFP_KERNEL);
+		}
+
+		if (!hba->dma_mem) {
+			err = -ENOMEM;
+			printk(KERN_ERR DRV_NAME "(%s): dma mem alloc failed\n",
+				pci_name(pdev));
+			goto out_iounmap;
+		}
 	}
 
 	hba->ccb = kcalloc(ci->rq_count, sizeof(struct st_ccb), GFP_KERNEL);


