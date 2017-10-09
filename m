From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v7 2/9] md: Introduce md_stop_all_writes()
Date: Mon,  9 Oct 2017 16:13:53 -0700
Message-ID: <20171009231400.562-3-bart.vanassche@wdc.com>
References: <20171009231400.562-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47759 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755497AbdJIXOG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2017 19:14:06 -0400
In-Reply-To: <20171009231400.562-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Introduce md_stop_all_writes() because the next patch will add
a second caller for this function. This patch does not change
any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
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
