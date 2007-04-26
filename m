From: akpm@linux-foundation.org
Subject: [patch 27/30] sas_scsi_host: partially convert to use the kthread API
Date: Thu, 26 Apr 2007 00:35:30 -0700
Message-ID: <200704260735.l3Q7ZURV024291@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933166AbXDZHgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 03:36:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, ebiederm@xmission.com, James.Bottomley@steeleye.com, djwong@us.ibm.com

From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the sas scsi host thread startup to use kthread_run not
kernel_thread and deamonize.  kthread_run is slightly simpler and more
maintainable.

akpm: the driver should also be converted to use kthread_should_stop() and
kthread_stop().

Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libsas/sas_scsi_host.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/libsas/sas_scsi_host.c~sas_scsi_host-partially-convert-to-use-the-kthread-api drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~sas_scsi_host-partially-convert-to-use-the-kthread-api
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -38,6 +38,7 @@
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
+#include <linux/kthread.h>
 #include <linux/scatterlist.h>
 
 /* ---------- SCSI Host glue ---------- */
@@ -869,7 +870,6 @@ static int sas_queue_thread(void *_sas_h
 	struct sas_ha_struct *sas_ha = _sas_ha;
 	struct scsi_core *core = &sas_ha->core;
 
-	daemonize("sas_queue_%d", core->shost->host_no);
 	current->flags |= PF_NOFREEZE;
 
 	complete(&queue_th_comp);
@@ -888,19 +888,20 @@ static int sas_queue_thread(void *_sas_h
 
 int sas_init_queue(struct sas_ha_struct *sas_ha)
 {
-	int res;
 	struct scsi_core *core = &sas_ha->core;
+	struct task_struct *task;
 
 	spin_lock_init(&core->task_queue_lock);
 	core->task_queue_size = 0;
 	INIT_LIST_HEAD(&core->task_queue);
 	init_MUTEX_LOCKED(&core->queue_thread_sema);
 
-	res = kernel_thread(sas_queue_thread, sas_ha, 0);
-	if (res >= 0)
+	task = kthread_run(sas_queue_thread, sas_ha,
+			   "sas_queue_%d", core->shost->host_no);
+	if (!IS_ERR(task))
 		wait_for_completion(&queue_th_comp);
 
-	return res < 0 ? res : 0;
+	return IS_ERR(task) ? PTR_ERR(task) : 0;
 }
 
 void sas_shutdown_queue(struct sas_ha_struct *sas_ha)
_
