From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] scsi_debug: disable clustering
Date: Sat, 16 Feb 2008 23:57:15 +0900
Message-ID: <20080216235714H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:34293 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbYBPO5d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Feb 2008 09:57:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_debug: disable clustering

scsi_debug does at several places:

for_each_sg(sdb->table.sgl, sg, sdb->table.nents, k) {
	kaddr = (unsigned char *)
		kmap_atomic(sg_page(sg), KM_USER0);


We cannot do something like that with the clustering enabled (or we
can use scsi_kmap_atomic_sg).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1541c17..d1777a9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -222,7 +222,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.cmd_per_lun =		16,
 	.max_sectors =		0xffff,
 	.unchecked_isa_dma = 	0,
-	.use_clustering = 	ENABLE_CLUSTERING,
+	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
 };
 
-- 
1.5.3.7

