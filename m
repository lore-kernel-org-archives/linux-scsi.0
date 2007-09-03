From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 2/2] libata: remove blk_queue_max_phys_segments
Date: Mon, 3 Sep 2007 18:40:28 +0900
Message-ID: <20070903103519T.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:36935 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbXICJlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Sep 2007 05:41:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeff@garzik.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

Jeff, can I get your ACK on this patch?

Whatever in a request queue we set, iommu code ignores all the sg list
limitations.

---
>From 703d5158361bb6a4ecdc5cd9a6961a8cfb419f73 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 3 Sep 2007 06:49:11 +0100
Subject: [PATCH 2/2] remove blk_queue_max_phys_segments in libata

LIBATA_MAX_PRD is the maximum number of DMA scatter/gather elements
permitted by the HBA's DMA engine. It's properly set to
q->max_hw_segments via the sg_tablesize parameter.

libata shouldn't call blk_queue_max_phys_segments. Now LIBATA_MAX_PRD
is equal to SCSI_MAX_PHYS_SEGMENTS by default (both is 128), so
everything is fine. But if they are changed, some code (like the scsi
mid layer, sg chaining, etc) might not work properly.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/ata/libata-scsi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e836476..5194f3d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -800,8 +800,6 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 
 	ata_scsi_sdev_config(sdev);
 
-	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
-
 	sdev->manage_start_stop = 1;
 
 	if (dev)
-- 
1.5.2.4

