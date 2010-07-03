From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi: need to reset unprep_rq_fn in sd_remove
Date: Sat, 3 Jul 2010 23:07:04 +0900
Message-ID: <20100703230650Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:58815 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab0GCOHg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Jul 2010 10:07:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: James.Bottomley@suse.de, hch@lst.de, snitzer@redhat.com, linux-scsi@vger.kernel.org

This is for block's for-2.6.36.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi: need to reset unprep_rq_fn in sd_remove

We need to reset q->unprep_rq_fn in sd_remove. Otherwise we hit kernel
oops if we access to a scsi disk device via sg after removing scsi
disk module.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aa6b48b..b13dffb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2378,6 +2378,7 @@ static int sd_remove(struct device *dev)
 	async_synchronize_full();
 	sdkp = dev_get_drvdata(dev);
 	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
+	blk_queue_unprep_rq(sdkp->device->request_queue, NULL);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
-- 
1.6.5

