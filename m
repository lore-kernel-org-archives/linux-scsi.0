From: Jan Engelhardt <jengelh@medozas.de>
Subject: scsi: sg: do static init of leaf data
Date: Sun, 11 Jan 2009 10:38:34 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901111037460.9874@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52712 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZAKJig (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jan 2009 04:38:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

parent 1b39db82983d6e2238b6c461f876e3e5fe5c93d0 (v2.6.29-rc1-3-g1b39db8)
commit 55840de5a8bee6494db6a79c231ec76e22417534
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Jan 11 10:31:14 2009 +0100

scsi: sg: do static init of leaf data

It does not seem that fops->read will ever take anything but seq_read
(and seq_lseek for fops->lseek), so statically initializing these
comes cheaper, since the space used by fops is already used anyway.
This will also allow constification (next patch).

text    data     bss     dec     hex filename
17021    1004      52   18077    469d drivers/scsi/sg.o~new
17065    1004      52   18121    46c9 drivers/scsi/sg.o~old

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 drivers/scsi/sg.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8f0bd3f..cb830fc 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2224,10 +2224,12 @@ static int sg_proc_single_open_adio(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
 			          size_t count, loff_t *off);
 static struct file_operations adio_fops = {
-	/* .owner, .read and .llseek added in sg_proc_init() */
 	.open = sg_proc_single_open_adio,
 	.write = sg_proc_write_adio,
 	.release = single_release,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.owner = THIS_MODULE,
 };
 
 static int sg_proc_single_open_dressz(struct inode *inode, struct file *file);
@@ -2237,6 +2239,9 @@ static struct file_operations dressz_fops = {
 	.open = sg_proc_single_open_dressz,
 	.write = sg_proc_write_dressz,
 	.release = single_release,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.owner = THIS_MODULE,
 };
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
@@ -2244,6 +2249,9 @@ static int sg_proc_single_open_version(struct inode *inode, struct file *file);
 static struct file_operations version_fops = {
 	.open = sg_proc_single_open_version,
 	.release = single_release,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.owner = THIS_MODULE,
 };
 
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v);
@@ -2251,6 +2259,9 @@ static int sg_proc_single_open_devhdr(struct inode *inode, struct file *file);
 static struct file_operations devhdr_fops = {
 	.open = sg_proc_single_open_devhdr,
 	.release = single_release,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.owner = THIS_MODULE,
 };
 
 static int sg_proc_seq_show_dev(struct seq_file *s, void *v);
@@ -2261,6 +2272,9 @@ static void dev_seq_stop(struct seq_file *s, void *v);
 static struct file_operations dev_fops = {
 	.open = sg_proc_open_dev,
 	.release = seq_release,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.owner = THIS_MODULE,
 };
 static struct seq_operations dev_seq_ops = {
 	.start = dev_seq_start,
@@ -2274,6 +2288,9 @@ static int sg_proc_open_devstrs(struct inode *inode, struct file *file);
 static struct file_operations devstrs_fops = {
 	.open = sg_proc_open_devstrs,
 	.release = seq_release,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.owner = THIS_MODULE,
 };
 static struct seq_operations devstrs_seq_ops = {
 	.start = dev_seq_start,
@@ -2287,6 +2304,9 @@ static int sg_proc_open_debug(struct inode *inode, struct file *file);
 static struct file_operations debug_fops = {
 	.open = sg_proc_open_debug,
 	.release = seq_release,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.owner = THIS_MODULE,
 };
 static struct seq_operations debug_seq_ops = {
 	.start = dev_seq_start,
@@ -2324,9 +2344,6 @@ sg_proc_init(void)
 	for (k = 0; k < num_leaves; ++k) {
 		leaf = &sg_proc_leaf_arr[k];
 		mask = leaf->fops->write ? S_IRUGO | S_IWUSR : S_IRUGO;
-		leaf->fops->owner = THIS_MODULE;
-		leaf->fops->read = seq_read;
-		leaf->fops->llseek = seq_lseek;
 		proc_create(leaf->name, mask, sg_proc_sgp, leaf->fops);
 	}
 	return 0;
-- 
# Created with git-export-patch

