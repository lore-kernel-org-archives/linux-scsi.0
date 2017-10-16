From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v9 01/10] md: Rename md_notifier into md_reboot_notifier
Date: Mon, 16 Oct 2017 16:28:56 -0700
Message-ID: <20171016232905.5047-2-bart.vanassche@wdc.com>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171016232905.5047-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

This avoids confusion with the pm notifier that will be added
through a later patch.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Shaohua Li <shli@kernel.org>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-raid@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5d61049e7417..8933cafc212d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8966,7 +8966,7 @@ static int md_notify_reboot(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block md_notifier = {
+static struct notifier_block md_reboot_notifier = {
 	.notifier_call	= md_notify_reboot,
 	.next		= NULL,
 	.priority	= INT_MAX, /* before any real devices */
@@ -9003,7 +9003,7 @@ static int __init md_init(void)
 	blk_register_region(MKDEV(mdp_major, 0), 1UL<<MINORBITS, THIS_MODULE,
 			    md_probe, NULL, NULL);
 
-	register_reboot_notifier(&md_notifier);
+	register_reboot_notifier(&md_reboot_notifier);
 	raid_table_header = register_sysctl_table(raid_root_table);
 
 	md_geninit();
@@ -9243,7 +9243,7 @@ static __exit void md_exit(void)
 
 	unregister_blkdev(MD_MAJOR,"md");
 	unregister_blkdev(mdp_major, "mdp");
-	unregister_reboot_notifier(&md_notifier);
+	unregister_reboot_notifier(&md_reboot_notifier);
 	unregister_sysctl_table(raid_table_header);
 
 	/* We cannot unload the modules while some process is
-- 
2.14.2
