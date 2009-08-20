From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 07/17] Handle failure of blk_init_queue gracefully in
	cciss_add_disk.
Date: Thu, 20 Aug 2009 10:18:18 -0500
Message-ID: <20090820151818.22833.40801.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754058AbZHTPSY@vger.kernel.org>
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Handle failure of blk_init_queue gracefully in cciss_add_disk.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 557b958..60fe3c6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1689,6 +1689,8 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 				int drv_index)
 {
 	disk->queue = blk_init_queue(do_cciss_request, &h->lock);
+	if (!disk->queue)
+		goto init_queue_failure;
 	sprintf(disk->disk_name, "cciss/c%dd%d", h->ctlr, drv_index);
 	disk->major = h->major;
 	disk->first_minor = drv_index << NWD_SHIFT;
@@ -1729,6 +1731,7 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 cleanup_queue:
 	blk_cleanup_queue(disk->queue);
 	disk->queue = NULL;
+init_queue_failure:
 	return -1;
 }
 
