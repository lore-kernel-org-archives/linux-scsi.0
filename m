From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] switch command completion queue to per-cpu data
Date: Mon, 22 Sep 2003 22:39:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030922203931.GA30386@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:28067 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263270AbTIVUj6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 16:39:58 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

 - DEFINE_PER_CPU works in modules now, use it
 - rename done_q to scsi_done_q - in the kernel we prefer descriptive
   prefixes even for statics..


diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Sat Sep 20 09:35:19 2003
+++ b/drivers/scsi/scsi.c	Sat Sep 20 09:35:19 2003
@@ -535,7 +535,7 @@
 /*
  * Per-CPU I/O completion queue.
  */
-static struct list_head done_q[NR_CPUS] __cacheline_aligned;
+static DEFINE_PER_CPU(struct list_head, scsi_done_q);
 
 /**
  * scsi_done - Enqueue the finished SCSI command into the done queue.
@@ -553,7 +553,6 @@
 void scsi_done(struct scsi_cmnd *cmd)
 {
 	unsigned long flags;
-	int cpu;
 
 	/*
 	 * We don't have to worry about this one timing out any more.
@@ -580,8 +579,7 @@
 	 * and need no spinlock.
 	 */
 	local_irq_save(flags);
-	cpu = smp_processor_id();
-	list_add_tail(&cmd->eh_entry, &done_q[cpu]);
+	list_add_tail(&cmd->eh_entry, &__get_cpu_var(scsi_done_q));
 	raise_softirq_irqoff(SCSI_SOFTIRQ);
 	local_irq_restore(flags);
 }
@@ -600,7 +598,7 @@
 	LIST_HEAD(local_q);
 
 	local_irq_disable();
-	list_splice_init(&done_q[smp_processor_id()], &local_q);
+	list_splice_init(&__get_cpu_var(scsi_done_q), &local_q);
 	local_irq_enable();
 
 	while (!list_empty(&local_q)) {
@@ -1008,7 +1006,7 @@
 		goto cleanup_sysctl;
 
 	for (i = 0; i < NR_CPUS; i++)
-		INIT_LIST_HEAD(&done_q[i]);
+		INIT_LIST_HEAD(&per_cpu(scsi_done_q, i));
 
 	devfs_mk_dir("scsi");
 	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
