From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] scsi: add sd_unprep_fn to free discard page
Date: Thu,  1 Jul 2010 19:49:18 +0900
Message-ID: <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: snitzer@redhat.com, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This fixes discard page leak by using q->unprep_rq_fn facility.

q->unprep_rq_fn is called when all the data buffer (req->bio and
scsi_data_buffer) in the request is freed.

sd_unprep() uses rq->buffer to free discard page allocated in
sd_prepare_discard().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sd.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 86da819..2d4e3a8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -425,6 +425,7 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	sector_t sector = bio->bi_sector;
 	unsigned int nr_sectors = bio_sectors(bio);
 	unsigned int len;
+	int ret;
 	struct page *page;
 
 	if (sdkp->device->sector_size == 4096) {
@@ -465,7 +466,15 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	}
 
 	blk_add_request_payload(rq, page, len);
-	return scsi_setup_blk_pc_cmnd(sdp, rq);
+	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
+	rq->buffer = page_address(page);
+	return ret;
+}
+
+static void sd_unprep_fn(struct request_queue *q, struct request *rq)
+{
+	if (rq->cmd_flags & REQ_DISCARD)
+		__free_page(virt_to_page(rq->buffer));
 }
 
 /**
@@ -2242,6 +2251,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	sd_revalidate_disk(gd);
 
 	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
+	blk_queue_unprep_rq(sdp->request_queue, sd_unprep_fn);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_EXT_DEVT;
-- 
1.6.5
