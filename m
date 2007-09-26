From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 4/5] scsi_add_host sets device max_segment_size
Date: Wed, 26 Sep 2007 17:58:02 +0900
Message-ID: <20070925142159R.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50169 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbXIZI7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 04:59:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

scsi_add_host sets shost_gendev.parent->max_segment_size to enables
iommu code to merge sg lists properly about lld's max segment size
limit.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/hosts.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 22877d3..a71a836 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -206,6 +206,9 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
 
+	if (dev)
+		dev->max_segment_size = shost->dma_max_segment_size;
+
 	error = device_add(&shost->shost_gendev);
 	if (error)
 		goto out;
-- 
1.5.2.4

