From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Avoid that toggling use_blk_mq triggers a memory leak
Date: Thu, 22 Sep 2016 14:20:54 -0700
Message-ID: <e76485aa-8e04-c6a7-8bcb-67b2ae569a60@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0076.outbound.protection.outlook.com ([104.47.42.76]:52447
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965227AbcIVVVF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Sep 2016 17:21:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch avoids that the following memory leak is triggered if
use_blk_mq is disabled after a SCSI host has been allocated by
the ib_srp driver and before the same SCSI host is freed:

unreferenced object 0xffff8803a168c568 (size 256):
  backtrace:
    [<ffffffff81620c95>] kmemleak_alloc+0x45/0xa0
    [<ffffffff811bb104>] __kmalloc_node+0x1e4/0x400
    [<ffffffff81309fe4>] blk_mq_alloc_tag_set+0xb4/0x230
    [<ffffffff814731b7>] scsi_mq_setup_tags+0xc7/0xd0
    [<ffffffff81469c26>] scsi_add_host_with_dma+0x216/0x2d0
    [<ffffffffa064bef5>] srp_create_target+0xe55/0x13d0 [ib_srp]
    [<ffffffff8143ce23>] dev_attr_store+0x13/0x20
    [<ffffffff8125f030>] sysfs_kf_write+0x40/0x50
    [<ffffffff8125e397>] kernfs_fop_write+0x137/0x1c0
    [<ffffffff811d8c13>] __vfs_write+0x23/0x140
    [<ffffffff811d92e0>] vfs_write+0xb0/0x190
    [<ffffffff811da5b4>] SyS_write+0x44/0xa0
    [<ffffffff8162c8a5>] entry_SYSCALL_64_fastpath+0x18/0xa8

Fixes: 9aa9cc4221f5 ("scsi: remove the disable_blk_mq host flag")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/hosts.c     | 2 ++
 drivers/scsi/scsi.c      | 1 -
 drivers/scsi/scsi_priv.h | 1 +
 include/scsi/scsi_host.h | 5 +----
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ba9af4a..ec6381e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -486,6 +486,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
+	shost->use_blk_mq = scsi_use_blk_mq;
+
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1f36aca..1deb6ad 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1160,7 +1160,6 @@ bool scsi_use_blk_mq = true;
 bool scsi_use_blk_mq = false;
 #endif
 module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
-EXPORT_SYMBOL_GPL(scsi_use_blk_mq);
 
 static int __init init_scsi(void)
 {
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 25e4643..c76e87d 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -29,6 +29,7 @@ extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
 
 /* scsi.c */
+extern bool scsi_use_blk_mq;
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
 #ifdef CONFIG_SCSI_LOGGING
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0dee7af..7e4cd53 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -771,12 +771,9 @@ static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
 		shost->tmf_in_progress;
 }
 
-extern bool scsi_use_blk_mq;
-
 static inline bool shost_use_blk_mq(struct Scsi_Host *shost)
 {
-	return scsi_use_blk_mq;
-
+	return shost->use_blk_mq;
 }
 
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
-- 
2.10.0

