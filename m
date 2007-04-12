From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] scsi: iterate over devices individually for /proc/scsi/scsi
Date: Thu, 12 Apr 2007 15:34:32 -0400
Message-ID: <461E89C8.7040507@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbXDLTes (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Apr 2007 15:34:48 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id CEDD5122ED
	for <linux-scsi@vger.kernel.org>; Thu, 12 Apr 2007 21:34:46 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

 On systems with very large numbers (> 1600 or so) of SCSI devices,
 cat /proc/scsi/scsi ends up failing with -ENOMEM. This is due to
 the show routine simply iterating over all of the devices with
 bus_for_each_dev(), and trying to dump all of them into the buffer
 at the same time. On my test system (using scsi_debug with 4064 devices),
 the output ends up being ~ 632k, far more than kmalloc will typically allow.

 This patch uses seq_file directly instead of single_file, and breaks up
 the operations into the 4 seq_file callbacks. The result is that
 each show() operation only dumps ~ 180 bytes into the buffer at a time
 so we don't run out of memory.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---

 drivers/scsi/scsi_proc.c |   69 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 6 deletions(-)

diff -rup a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	2007-04-12 13:41:06.000000000 -0400
+++ b/drivers/scsi/scsi_proc.c	2007-04-12 13:47:38.000000000 -0400
@@ -294,20 +294,77 @@ static ssize_t proc_scsi_write(struct fi
 	return err;
 }
 
-static int proc_scsi_show(struct seq_file *s, void *p)
+static struct device *next_device(struct klist_iter *i)
 {
-	seq_printf(s, "Attached devices:\n");
-	bus_for_each_dev(&scsi_bus_type, NULL, s, proc_print_scsidevice);
-	return 0;
+	struct klist_node *n = klist_next(i);
+	return n ? container_of(n, struct device, knode_bus) : NULL;
+}
+
+static void *scsi_seq_start(struct seq_file *sfile, loff_t *pos)
+{
+	struct klist_iter *iter;
+	struct device *dev = NULL;
+	loff_t l = *pos;
+
+	iter = kmalloc(sizeof (*iter), GFP_KERNEL);
+	if (!iter)
+		return ERR_PTR(-ENOMEM);
+
+	klist_iter_init_node(&scsi_bus_type.klist_devices, iter, NULL);
+
+	do {
+		dev = next_device(iter);
+	} while (l-- && dev);
+
+	sfile->private = iter;
+	return dev;
 }
 
+static void *scsi_seq_next(struct seq_file *sfile, void *v, loff_t *pos)
+{
+	struct klist_iter *iter = (struct klist_iter *)sfile->private;
+	++*pos;
+	return next_device(iter);
+}
+
+static void scsi_seq_stop(struct seq_file *sfile, void *v)
+{
+	struct klist_iter *iter = (struct klist_iter *)sfile->private;
+	sfile->private = NULL;
+	klist_iter_exit(iter);
+	kfree(iter);
+}
+
+static int scsi_seq_show(struct seq_file *sfile, void *v)
+{
+	struct klist_iter *iter = (struct klist_iter *)sfile->private;
+	struct device *dev = (struct device *)v;
+	struct klist_node *head;
+
+	spin_lock(&iter->i_klist->k_lock);
+	head = container_of(iter->i_klist->k_list.next,
+	                    struct klist_node, n_node);
+	if (&dev->knode_bus == head)
+		seq_puts(sfile, "Attached devices:\n");
+	spin_unlock(&iter->i_klist->k_lock);
+
+	return proc_print_scsidevice(dev, sfile);
+}
+
+static struct seq_operations scsi_seq_ops = {
+	.start	= scsi_seq_start,
+	.next	= scsi_seq_next,
+	.stop	= scsi_seq_stop,
+	.show	= scsi_seq_show
+};
+
 static int proc_scsi_open(struct inode *inode, struct file *file)
 {
 	/*
 	 * We don't really needs this for the write case but it doesn't
 	 * harm either.
 	 */
-	return single_open(file, proc_scsi_show, NULL);
+	return seq_open(file, &scsi_seq_ops);
 }
 
 static struct file_operations proc_scsi_operations = {
@@ -315,7 +372,7 @@ static struct file_operations proc_scsi_
 	.read		= seq_read,
 	.write		= proc_scsi_write,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= seq_release,
 };
 
 int __init scsi_init_procfs(void)

