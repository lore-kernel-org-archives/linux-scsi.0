From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/40] sg: simplify procfs code
Date: Wed, 25 Apr 2018 17:48:07 +0200
Message-ID: <20180425154827.32251-21-hch@lst.de>
References: <20180425154827.32251-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180425154827.32251-1-hch@lst.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Use remove_proc_subtree to remove the whole subtree on cleanup, and
unwind the registration loop into individual calls.  Switch to use
proc_create_seq where applicable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sg.c | 124 +++++-----------------------------------------
 1 file changed, 12 insertions(+), 112 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c198b96368dd..8ff687158704 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -66,7 +66,6 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 static char *sg_version_date = "20140603";
 
 static int sg_proc_init(void);
-static void sg_proc_cleanup(void);
 #endif
 
 #define SG_ALLOW_DIO_DEF 0
@@ -1661,7 +1660,7 @@ static void __exit
 exit_sg(void)
 {
 #ifdef CONFIG_SCSI_PROC_FS
-	sg_proc_cleanup();
+	remove_proc_subtree("scsi/sg", NULL);
 #endif				/* CONFIG_SCSI_PROC_FS */
 	scsi_unregister_interface(&sg_interface);
 	class_destroy(sg_sysfs_class);
@@ -2274,11 +2273,6 @@ sg_get_dev(int dev)
 }
 
 #ifdef CONFIG_SCSI_PROC_FS
-
-static struct proc_dir_entry *sg_proc_sgp = NULL;
-
-static char sg_proc_sg_dirname[] = "scsi/sg";
-
 static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 
 static int sg_proc_single_open_adio(struct inode *inode, struct file *file);
@@ -2306,37 +2300,11 @@ static const struct file_operations dressz_fops = {
 };
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
-static int sg_proc_single_open_version(struct inode *inode, struct file *file);
-static const struct file_operations version_fops = {
-	.owner = THIS_MODULE,
-	.open = sg_proc_single_open_version,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v);
-static int sg_proc_single_open_devhdr(struct inode *inode, struct file *file);
-static const struct file_operations devhdr_fops = {
-	.owner = THIS_MODULE,
-	.open = sg_proc_single_open_devhdr,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 static int sg_proc_seq_show_dev(struct seq_file *s, void *v);
-static int sg_proc_open_dev(struct inode *inode, struct file *file);
 static void * dev_seq_start(struct seq_file *s, loff_t *pos);
 static void * dev_seq_next(struct seq_file *s, void *v, loff_t *pos);
 static void dev_seq_stop(struct seq_file *s, void *v);
-static const struct file_operations dev_fops = {
-	.owner = THIS_MODULE,
-	.open = sg_proc_open_dev,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
 static const struct seq_operations dev_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
@@ -2345,14 +2313,6 @@ static const struct seq_operations dev_seq_ops = {
 };
 
 static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v);
-static int sg_proc_open_devstrs(struct inode *inode, struct file *file);
-static const struct file_operations devstrs_fops = {
-	.owner = THIS_MODULE,
-	.open = sg_proc_open_devstrs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
 static const struct seq_operations devstrs_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
@@ -2361,14 +2321,6 @@ static const struct seq_operations devstrs_seq_ops = {
 };
 
 static int sg_proc_seq_show_debug(struct seq_file *s, void *v);
-static int sg_proc_open_debug(struct inode *inode, struct file *file);
-static const struct file_operations debug_fops = {
-	.owner = THIS_MODULE,
-	.open = sg_proc_open_debug,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
 static const struct seq_operations debug_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
@@ -2376,50 +2328,23 @@ static const struct seq_operations debug_seq_ops = {
 	.show  = sg_proc_seq_show_debug,
 };
 
-
-struct sg_proc_leaf {
-	const char * name;
-	const struct file_operations * fops;
-};
-
-static const struct sg_proc_leaf sg_proc_leaf_arr[] = {
-	{"allow_dio", &adio_fops},
-	{"debug", &debug_fops},
-	{"def_reserved_size", &dressz_fops},
-	{"device_hdr", &devhdr_fops},
-	{"devices", &dev_fops},
-	{"device_strs", &devstrs_fops},
-	{"version", &version_fops}
-};
-
 static int
 sg_proc_init(void)
 {
-	int num_leaves = ARRAY_SIZE(sg_proc_leaf_arr);
-	int k;
+	struct proc_dir_entry *p;
 
-	sg_proc_sgp = proc_mkdir(sg_proc_sg_dirname, NULL);
-	if (!sg_proc_sgp)
+	p = proc_mkdir("scsi/sg", NULL);
+	if (!p)
 		return 1;
-	for (k = 0; k < num_leaves; ++k) {
-		const struct sg_proc_leaf *leaf = &sg_proc_leaf_arr[k];
-		umode_t mask = leaf->fops->write ? S_IRUGO | S_IWUSR : S_IRUGO;
-		proc_create(leaf->name, mask, sg_proc_sgp, leaf->fops);
-	}
-	return 0;
-}
 
-static void
-sg_proc_cleanup(void)
-{
-	int k;
-	int num_leaves = ARRAY_SIZE(sg_proc_leaf_arr);
-
-	if (!sg_proc_sgp)
-		return;
-	for (k = 0; k < num_leaves; ++k)
-		remove_proc_entry(sg_proc_leaf_arr[k].name, sg_proc_sgp);
-	remove_proc_entry(sg_proc_sg_dirname, NULL);
+	proc_create("allow_dio", S_IRUGO | S_IWUSR, p, &adio_fops);
+	proc_create_seq("debug", S_IRUGO, p, &debug_seq_ops);
+	proc_create("def_reserved_size", S_IRUGO | S_IWUSR, p, &dressz_fops);
+	proc_create_single("device_hdr", S_IRUGO, p, sg_proc_seq_show_devhdr);
+	proc_create_seq("devices", S_IRUGO, p, &dev_seq_ops);
+	proc_create_seq("device_strs", S_IRUGO, p, &devstrs_seq_ops);
+	proc_create_single("version", S_IRUGO, p, sg_proc_seq_show_version);
+	return 0;
 }
 
 
@@ -2482,22 +2407,12 @@ static int sg_proc_seq_show_version(struct seq_file *s, void *v)
 	return 0;
 }
 
-static int sg_proc_single_open_version(struct inode *inode, struct file *file)
-{
-	return single_open(file, sg_proc_seq_show_version, NULL);
-}
-
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
 {
 	seq_puts(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\tonline\n");
 	return 0;
 }
 
-static int sg_proc_single_open_devhdr(struct inode *inode, struct file *file)
-{
-	return single_open(file, sg_proc_seq_show_devhdr, NULL);
-}
-
 struct sg_proc_deviter {
 	loff_t	index;
 	size_t	max;
@@ -2531,11 +2446,6 @@ static void dev_seq_stop(struct seq_file *s, void *v)
 	kfree(s->private);
 }
 
-static int sg_proc_open_dev(struct inode *inode, struct file *file)
-{
-        return seq_open(file, &dev_seq_ops);
-}
-
 static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 {
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
@@ -2562,11 +2472,6 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 	return 0;
 }
 
-static int sg_proc_open_devstrs(struct inode *inode, struct file *file)
-{
-        return seq_open(file, &devstrs_seq_ops);
-}
-
 static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 {
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
@@ -2650,11 +2555,6 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 	}
 }
 
-static int sg_proc_open_debug(struct inode *inode, struct file *file)
-{
-        return seq_open(file, &debug_seq_ops);
-}
-
 static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 {
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
-- 
2.17.0
