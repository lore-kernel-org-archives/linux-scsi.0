From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH 2/2] scsi_proc: Change /proc/scsi/scsi to use bus device iterator
Date: Mon, 11 Jan 2016 12:28:27 -0500
Message-ID: <1452533307-30142-3-git-send-email-emilne@redhat.com>
References: <1452533307-30142-1-git-send-email-emilne@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452533307-30142-1-git-send-email-emilne@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: gregkh@linuxfoundation.org, martin.petersen@oracle.com, hare@suse.com
List-Id: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

This prevents crashing due to accessing a removed element on the list,
the iterator will now hold the correct reference.  It was not sufficient
to rely on the klist's reference on the containing device object.

>From a patch originally developed by David Jeffery <djeffery@redhat.com>

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
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
