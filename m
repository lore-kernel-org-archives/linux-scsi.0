From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH RFC 2/2] scsi_proc: Change /proc/scsi/scsi to use bus device iterator
Date: Tue,  8 Dec 2015 09:08:24 -0500
Message-ID: <1449583704-32400-3-git-send-email-emilne@redhat.com>
References: <1449583704-32400-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbbLHOI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 09:08:26 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 8241419F26E
	for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2015 14:08:26 +0000 (UTC)
Received: from emilne.csb (dhcp-25-104.bos.redhat.com [10.18.25.104])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id tB8E8OxS005638
	for <linux-scsi@vger.kernel.org>; Tue, 8 Dec 2015 09:08:26 -0500
In-Reply-To: <1449583704-32400-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

This prevents crashing due to accessing a removed element on the list,
the iterator will now hold the correct reference.  It was not sufficient
to rely on the klist's reference on the containing device object.

>From a patch originally developed by David Jeffery <djeffery@redhat.com>

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_proc.c | 49 ++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 251598e..6c1b79d 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -40,6 +40,11 @@
 /* 4K page size, but our output routines, use some slack for overruns */
 #define PROC_BLOCK_SIZE (3*1024)
 
+struct scsi_proc_state {
+	struct klist_iter iter;
+	int pos;
+};
+
 static struct proc_dir_entry *proc_scsi;
 
 /* Protect sht->present and sht->proc_dir */
@@ -370,47 +375,50 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 	return err;
 }
 
-static int always_match(struct device *dev, void *data)
-{
-	return 1;
-}
-
-static inline struct device *next_scsi_device(struct device *start)
-{
-	struct device *next = bus_find_device(&scsi_bus_type, start, NULL,
-					      always_match);
-	put_device(start);
-	return next;
-}
-
 static void *scsi_seq_start(struct seq_file *sfile, loff_t *pos)
 {
+	struct scsi_proc_state *state = sfile->private;
 	struct device *dev = NULL;
 	loff_t n = *pos;
+	int err;
+
+	err = bus_device_iter_init(&state->iter, &scsi_bus_type);
+	if (err < 0)
+		return ERR_PTR(err);
 
-	while ((dev = next_scsi_device(dev))) {
+	while ((dev = bus_device_iter_next(&state->iter))) {
 		if (!n--)
 			break;
-		sfile->private++;
+		put_device(dev);
+		state->pos++;
 	}
 	return dev;
 }
 
 static void *scsi_seq_next(struct seq_file *sfile, void *v, loff_t *pos)
 {
+	struct scsi_proc_state *state = sfile->private;
+
 	(*pos)++;
-	sfile->private++;
-	return next_scsi_device(v);
+	put_device(v);
+	state->pos++;
+
+	return bus_device_iter_next(&state->iter);
 }
 
 static void scsi_seq_stop(struct seq_file *sfile, void *v)
 {
+	struct scsi_proc_state *state = sfile->private;
+
 	put_device(v);
+	bus_device_iter_exit(&state->iter);
 }
 
 static int scsi_seq_show(struct seq_file *sfile, void *dev)
 {
-	if (!sfile->private)
+	struct scsi_proc_state *state = sfile->private;
+
+	if (!state->pos)
 		seq_puts(sfile, "Attached devices:\n");
 
 	return proc_print_scsidevice(dev, sfile);
@@ -436,7 +444,8 @@ static int proc_scsi_open(struct inode *inode, struct file *file)
 	 * We don't really need this for the write case but it doesn't
 	 * harm either.
 	 */
-	return seq_open(file, &scsi_seq_ops);
+	return seq_open_private(file, &scsi_seq_ops,
+				sizeof(struct scsi_proc_state));
 }
 
 static const struct file_operations proc_scsi_operations = {
@@ -445,7 +454,7 @@ static const struct file_operations proc_scsi_operations = {
 	.read		= seq_read,
 	.write		= proc_scsi_write,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_private,
 };
 
 /**
-- 
2.1.0

