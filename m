From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v10 02/10] md: Introduce md_stop_all_writes()
Date: Tue, 17 Oct 2017 16:26:22 -0700
Message-ID: <20171017232630.4264-3-bart.vanassche@wdc.com>
References: <20171017232630.4264-1-bart.vanassche@wdc.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171017232630.4264-1-bart.vanassche@wdc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Introduce md_stop_all_writes() because the next patch will add
a second caller for this function. This patch does not change
any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Shaohua Li <shli@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-raid@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
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

