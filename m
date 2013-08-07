From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 4/8] [SCSI] megaraid: add missing __iomem annotation
Date: Wed, 07 Aug 2013 12:56:11 +0900
Message-ID: <001401ce9322$0dfeda20$29fc8e60$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:11301 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab3HGD4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Aug 2013 23:56:12 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR5002566XLCK00@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Wed, 07 Aug 2013 12:56:11 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'Neela Syam Kolli' <megaraidlinux@lsi.com>, 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>

Added missing __iomem annotation in order to fix the following
sparse warnings:

drivers/scsi/megaraid.c:4595:26: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/megaraid.c:4595:26:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/megaraid.c:4595:26:    got void *<noident>
drivers/scsi/megaraid.c:4653:26: warning: incorrect type in argument 1 (different address spaces)
drivers/scsi/megaraid.c:4653:26:    expected void volatile [noderef] <asn:2>*addr
drivers/scsi/megaraid.c:4653:26:    got void *<noident>

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/megaraid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 90c95a3..a395207 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4592,7 +4592,7 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	scsi_host_put(host);
  out_iounmap:
 	if (flag & BOARD_MEMMAP)
-		iounmap((void *)mega_baseport);
+		iounmap((void __iomem *)mega_baseport);
  out_release_region:
 	if (flag & BOARD_MEMMAP)
 		release_mem_region(tbase, 128);
@@ -4650,7 +4650,7 @@ megaraid_remove_one(struct pci_dev *pdev)
 
 	/* Free our resources */
 	if (adapter->flag & BOARD_MEMMAP) {
-		iounmap((void *)adapter->base);
+		iounmap((void __iomem *)adapter->base);
 		release_mem_region(adapter->host->base, 128);
 	} else
 		release_region(adapter->base, 16);
-- 
1.7.10.4


