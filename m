From: "Ed Lin" <ed.lin@promise.com>
Subject: [patch] scsi: use lock per host instead of per device for shared queue tag host
Date: Tue, 23 Jan 2007 16:53:44 -0800
Message-ID: <NONAMEBDp7mvjkO22Zh0000056d@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:50833 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965458AbXAXBHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 20:07:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

The block layer uses lock to protect request queue. Every scsi device
has a unique request queue, and queue lock is the default lock in struct
request_queue. This is good for normal cases. But for a  host with
shared queue tag (e.g. stex controllers), a queue lock per device means
the shared queue tag is not protected when multiple devices are accessed
at a same time.  This patch is a simple fix for this situation by introducing
a host queue lock to protect shared queue tag. Without this patch we will
see various kernel panics (including the BUG() and kernel errors in
blk_queue_start_tag and blk_queue_end_tag of ll_rw_blk.c) when accessing
different devices simultaneously (e.g. copying big file from one device to
another in smp kernels).

This is against kernel 2.6.20-rc5.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
 drivers/scsi/scsi_lib.c  |    2 +-
 drivers/scsi/stex.c      |    2 ++
 include/scsi/scsi_host.h |    3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff -purN a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2007-01-23 14:40:28.000000000 -0800
+++ b/drivers/scsi/scsi_lib.c	2007-01-23 14:46:43.000000000 -0800
@@ -1574,7 +1574,7 @@ struct request_queue *__scsi_alloc_queue
 {
 	struct request_queue *q;
 
-	q = blk_init_queue(request_fn, NULL);
+	q = blk_init_queue(request_fn, shost->req_q_lock);
 	if (!q)
 		return NULL;
 
diff -purN a/drivers/scsi/stex.c b/drivers/scsi/stex.c
--- a/drivers/scsi/stex.c	2007-01-23 14:40:28.000000000 -0800
+++ b/drivers/scsi/stex.c	2007-01-23 14:48:59.000000000 -0800
@@ -1254,6 +1254,8 @@ stex_probe(struct pci_dev *pdev, const s
 	if (err)
 		goto out_free_irq;
 
+	spin_lock_init(&host->__req_q_lock);
+	host->req_q_lock = &host->__req_q_lock;
 	err = scsi_init_shared_tag_map(host, host->can_queue);
 	if (err) {
 		printk(KERN_ERR DRV_NAME "(%s): init shared queue failed\n",
diff -purN a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2007-01-23 14:40:29.000000000 -0800
+++ b/include/scsi/scsi_host.h	2007-01-23 14:57:04.000000000 -0800
@@ -508,6 +508,9 @@ struct Scsi_Host {
 	spinlock_t		default_lock;
 	spinlock_t		*host_lock;
 
+	spinlock_t		__req_q_lock;
+	spinlock_t		*req_q_lock;/* protect shared block queue tag */
+
 	struct mutex		scan_mutex;/* serialize scanning activity */
 
 	struct list_head	eh_cmd_q;



