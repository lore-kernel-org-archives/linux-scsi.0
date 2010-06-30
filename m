From: James Bottomley <James.Bottomley@suse.de>
Subject: [RFC 2/2] sd: free discard page in unprep function
Date: Wed, 30 Jun 2010 12:10:53 -0500
Message-ID: <1277917853.2839.174.camel@mulgrave.site>
References: <1277917264.2839.153.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756921Ab0F3RLB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 13:11:01 -0400
In-Reply-To: <1277917264.2839.153.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel@redhat.com

This isn't a proper patch, but really just an illustration how freeing
should be done ... it still needs to be paired correctly with the
allocation (and error handling on the allocation path).

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8802e48..7907be8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -461,6 +461,12 @@ static int sd_prepare_discard(struct request *rq)
 	return BLKPREP_OK;
 }
 
+static void sd_unprep_fn(struct request_queue *q, struct request *rq)
+{
+	if (rq->cmd_flags & REQ_DISCARD)
+		__free_page(bio_page(rq->bio));
+}
+
 /**
  *	sd_init_command - build a scsi (read or write) command from
  *	information in the request structure.
@@ -2226,6 +2232,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	sd_revalidate_disk(gd);
 
 	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
+	blk_queue_unprep_rq(sdp->request_queue, sd_unprep_fn);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_EXT_DEVT;


