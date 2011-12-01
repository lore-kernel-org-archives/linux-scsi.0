From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/5] Staging: hv: storvsc: Disable clustering
Date: Thu,  1 Dec 2011 04:59:16 -0800
Message-ID: <1322744360-13067-1-git-send-email-kys@microsoft.com>
References: <1322744315-13017-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:58398
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754354Ab1LANYe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 08:24:34 -0500
In-Reply-To: <1322744315-13017-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>

Disable clustering, since the host side on Hyper-V requires that
each I/O element not exceed the page size. As part of this
cleanup, get rid of the function to merge bvecs, as the primary
reason for this function was to avoid having an element exceed
the page size. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 0245143..9153f98 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -798,13 +798,6 @@ static int storvsc_device_alloc(struct scsi_device *sdevice)
 	return 0;
 }
 
-static int storvsc_merge_bvec(struct request_queue *q,
-			      struct bvec_merge_data *bmd, struct bio_vec *bvec)
-{
-	/* checking done by caller. */
-	return bvec->bv_len;
-}
-
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
 	scsi_adjust_queue_depth(sdevice, MSG_SIMPLE_TAG,
@@ -812,8 +805,6 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	blk_queue_max_segment_size(sdevice->request_queue, PAGE_SIZE);
 
-	blk_queue_merge_bvec(sdevice->request_queue, storvsc_merge_bvec);
-
 	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
 
 	return 0;
@@ -1375,14 +1366,7 @@ static struct scsi_host_template scsi_driver = {
 	/* no use setting to 0 since ll_blk_rw reset it to 1 */
 	/* currently 32 */
 	.sg_tablesize =		MAX_MULTIPAGE_BUFFER_COUNT,
-	/*
-	 * ENABLE_CLUSTERING allows mutiple physically contig bio_vecs to merge
-	 * into 1 sg element. If set, we must limit the max_segment_size to
-	 * PAGE_SIZE, otherwise we may get 1 sg element that represents
-	 * multiple
-	 */
-	/* physically contig pfns (ie sg[x].length > PAGE_SIZE). */
-	.use_clustering =	ENABLE_CLUSTERING,
+	.use_clustering =	DISABLE_CLUSTERING,
 	/* Make sure we dont get a sg segment crosses a page boundary */
 	.dma_boundary =		PAGE_SIZE-1,
 };
-- 
1.7.4.1

