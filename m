From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v9 02/10] md: Introduce md_stop_all_writes()
Date: Mon, 16 Oct 2017 16:28:57 -0700
Message-ID: <20171016232905.5047-3-bart.vanassche@wdc.com>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:57364 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757514AbdJPX3V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2017 19:29:21 -0400
In-Reply-To: <20171016232905.5047-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Introduce md_stop_all_writes() because the next patch will add
a second caller for this function. This patch does not change
any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Shaohua Li <shli@kernel.org>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-raid@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/md/md.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8933cafc212d..b99584e5d6b1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8937,8 +8937,7 @@ int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 }
 EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 
-static int md_notify_reboot(struct notifier_block *this,
-			    unsigned long code, void *x)
+static void md_stop_all_writes(void)
 {
 	struct list_head *tmp;
 	struct mddev *mddev;
@@ -8962,6 +8961,12 @@ static int md_notify_reboot(struct notifier_block *this,
 	 */
 	if (need_delay)
 		mdelay(1000*1);
+}
+
+static int md_notify_reboot(struct notifier_block *this,
+			    unsigned long code, void *x)
+{
+	md_stop_all_writes();
 
 	return NOTIFY_DONE;
 }
-- 
2.14.2
