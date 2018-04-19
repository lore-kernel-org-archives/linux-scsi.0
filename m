From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 36/39] proc: don't detour through seq->private to get the inode
Date: Thu, 19 Apr 2018 14:41:37 +0200
Message-ID: <20180419124140.9309-37-hch@lst.de>
References: <20180419124140.9309-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180419124140.9309-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Corey Minyard <minyard@acm.org>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/proc/array.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index ae2c807fd719..b34796b562ef 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -677,7 +677,7 @@ get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
 
 static int children_seq_show(struct seq_file *seq, void *v)
 {
-	struct inode *inode = seq->private;
+	struct inode *inode = file_inode(seq->file);
 	pid_t pid;
 
 	pid = pid_nr_ns(v, inode->i_sb->s_fs_info);
@@ -688,14 +688,14 @@ static int children_seq_show(struct seq_file *seq, void *v)
 
 static void *children_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	return get_children_pid(seq->private, NULL, *pos);
+	return get_children_pid(file_inode(seq->file), NULL, *pos);
 }
 
 static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct pid *pid;
 
-	pid = get_children_pid(seq->private, v, *pos + 1);
+	pid = get_children_pid(file_inode(seq->file), v, *pos + 1);
 	put_pid(v);
 
 	++*pos;
@@ -716,17 +716,7 @@ static const struct seq_operations children_seq_ops = {
 
 static int children_seq_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *m;
-	int ret;
-
-	ret = seq_open(file, &children_seq_ops);
-	if (ret)
-		return ret;
-
-	m = file->private_data;
-	m->private = inode;
-
-	return ret;
+	return seq_open(file, &children_seq_ops);
 }
 
 const struct file_operations proc_tid_children_operations = {
-- 
2.17.0
