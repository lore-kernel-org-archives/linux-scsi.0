From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH for kernel 3.19] Avoid that scsi_device_put() triggers a kernel
 warning
Date: Mon, 05 Jan 2015 12:03:17 +0100
Message-ID: <54AA6F75.7040607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:51259 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbbAELEX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 06:04:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that the following warning is reported when a SCSI LLD kernel
module is unloaded:

WARNING: CPU: 5 PID: 228 at kernel/module.c:954 module_put+0x207/0x220()
Call Trace:
 [<ffffffff814d1fcf>] dump_stack+0x4c/0x65
 [<ffffffff81053ada>] warn_slowpath_common+0x8a/0xc0
 [<ffffffff81053bca>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810d0507>] module_put+0x207/0x220
 [<ffffffffa000bea8>] scsi_device_put+0x48/0x50 [scsi_mod]
 [<ffffffffa03676d2>] scsi_disk_put+0x32/0x50 [sd_mod]
 [<ffffffffa0368d4c>] sd_shutdown+0x8c/0x150 [sd_mod]
 [<ffffffffa0368e79>] sd_remove+0x69/0xc0 [sd_mod]
 [<ffffffff813457ef>] __device_release_driver+0x7f/0xf0
 [<ffffffff81345885>] device_release_driver+0x25/0x40
 [<ffffffff81345134>] bus_remove_device+0x124/0x1b0
 [<ffffffff8134189e>] device_del+0x13e/0x250
 [<ffffffffa001cdcd>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
 [<ffffffffa001b39f>] scsi_forget_host+0x6f/0x80 [scsi_mod]
 [<ffffffffa000d5f6>] scsi_remove_host+0x86/0x140 [scsi_mod]
 [<ffffffffa07d5c0b>] srp_remove_work+0x9b/0x210 [ib_srp]
 [<ffffffff8106fd28>] process_one_work+0x1d8/0x780
 [<ffffffff810703eb>] worker_thread+0x11b/0x4a0
 [<ffffffff81075a6f>] kthread+0xef/0x110
 [<ffffffff814dad6c>] ret_from_fork+0x7c/0xb0

See also patch "module: Remove stop_machine from module unloading"
(Masami Hiramatsu; commit e513cc1c07e2; kernel v3.19-rc1).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c     |  1 +
 drivers/scsi/scsi.c      | 13 ++++---------
 include/scsi/scsi_host.h |  3 +++
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e..e9155d0 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -380,6 +380,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
 	shost->host_lock = &shost->default_lock;
 	spin_lock_init(shost->host_lock);
+	atomic_set(&shost->module_refcnt, 0);
 	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e028854..ed325d1 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -988,7 +988,8 @@ int scsi_device_get(struct scsi_device *sdev)
 		return -ENXIO;
 	/* We can fail this if we're doing SCSI operations
 	 * from module exit (like cache flush) */
-	try_module_get(sdev->host->hostt->module);
+	if (try_module_get(sdev->host->hostt->module))
+		atomic_inc(&sdev->host->module_refcnt);
 
 	return 0;
 }
@@ -1004,14 +1005,8 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-#ifdef CONFIG_MODULE_UNLOAD
-	struct module *module = sdev->host->hostt->module;
-
-	/* The module refcount will be zero if scsi_device_get()
-	 * was called from a module removal routine */
-	if (module && module_refcount(module) != 0)
-		module_put(module);
-#endif
+	if (atomic_dec_if_positive(&sdev->host->module_refcnt) >= 0)
+		module_put(sdev->host->hostt->module);
 	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_device_put);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 019e668..b8e6f01 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -566,6 +566,9 @@ struct Scsi_Host {
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
 
+	/* Number of LLD kernel module references held by the SCSI core. */
+	atomic_t		 module_refcnt;
+
 	/*
 	 * Area to keep a shared tag map (if needed, will be
 	 * NULL if not).
-- 
2.1.2

