From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/39] ext4: simplify procfs code
Date: Thu, 19 Apr 2018 14:41:22 +0200
Message-ID: <20180419124140.9309-22-hch@lst.de>
References: <20180419124140.9309-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <20180419124140.9309-1-hch@lst.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/jfs-discussion>,
 <mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
 <mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Corey Minyard <minyard@acm.org>, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Use remove_proc_subtree to remove the whole subtree on cleanup, and
unwind the registration loop into individual calls.  Switch to use
proc_create_seq where applicable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/ext4.h    |  2 +-
 fs/ext4/mballoc.c | 29 ++++------------------------
 fs/ext4/sysfs.c   | 49 +++++++++--------------------------------------
 3 files changed, 14 insertions(+), 66 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a42e71203e53..229ea4da6785 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2390,7 +2390,7 @@ extern int ext4_init_inode_table(struct super_block *sb,
 extern void ext4_end_bitmap_read(struct buffer_head *bh, int uptodate);
 
 /* mballoc.c */
-extern const struct file_operations ext4_seq_mb_groups_fops;
+extern const struct seq_operations ext4_mb_seq_groups_ops;
 extern long ext4_mb_stats;
 extern long ext4_mb_max_to_scan;
 extern int ext4_mb_init(struct super_block *);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 769a62708b1c..6884e81c1465 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2254,7 +2254,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 
 static void *ext4_mb_seq_groups_start(struct seq_file *seq, loff_t *pos)
 {
-	struct super_block *sb = seq->private;
+	struct super_block *sb = PDE_DATA(file_inode(seq->file));
 	ext4_group_t group;
 
 	if (*pos < 0 || *pos >= ext4_get_groups_count(sb))
@@ -2265,7 +2265,7 @@ static void *ext4_mb_seq_groups_start(struct seq_file *seq, loff_t *pos)
 
 static void *ext4_mb_seq_groups_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct super_block *sb = seq->private;
+	struct super_block *sb = PDE_DATA(file_inode(seq->file));
 	ext4_group_t group;
 
 	++*pos;
@@ -2277,7 +2277,7 @@ static void *ext4_mb_seq_groups_next(struct seq_file *seq, void *v, loff_t *pos)
 
 static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 {
-	struct super_block *sb = seq->private;
+	struct super_block *sb = PDE_DATA(file_inode(seq->file));
 	ext4_group_t group = (ext4_group_t) ((unsigned long) v);
 	int i;
 	int err, buddy_loaded = 0;
@@ -2330,34 +2330,13 @@ static void ext4_mb_seq_groups_stop(struct seq_file *seq, void *v)
 {
 }
 
-static const struct seq_operations ext4_mb_seq_groups_ops = {
+const struct seq_operations ext4_mb_seq_groups_ops = {
 	.start  = ext4_mb_seq_groups_start,
 	.next   = ext4_mb_seq_groups_next,
 	.stop   = ext4_mb_seq_groups_stop,
 	.show   = ext4_mb_seq_groups_show,
 };
 
-static int ext4_mb_seq_groups_open(struct inode *inode, struct file *file)
-{
-	struct super_block *sb = PDE_DATA(inode);
-	int rc;
-
-	rc = seq_open(file, &ext4_mb_seq_groups_ops);
-	if (rc == 0) {
-		struct seq_file *m = file->private_data;
-		m->private = sb;
-	}
-	return rc;
-
-}
-
-const struct file_operations ext4_seq_mb_groups_fops = {
-	.open		= ext4_mb_seq_groups_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static struct kmem_cache *get_groupinfo_cache(int blocksize_bits)
 {
 	int cache_index = blocksize_bits - EXT4_MIN_BLOCK_LOG_SIZE;
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 9ebd26c957c2..f34da0bb8f17 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -346,39 +346,9 @@ static struct kobject *ext4_root;
 
 static struct kobject *ext4_feat;
 
-#define PROC_FILE_SHOW_DEFN(name) \
-static int name##_open(struct inode *inode, struct file *file) \
-{ \
-	return single_open(file, ext4_seq_##name##_show, PDE_DATA(inode)); \
-} \
-\
-static const struct file_operations ext4_seq_##name##_fops = { \
-	.open		= name##_open, \
-	.read		= seq_read, \
-	.llseek		= seq_lseek, \
-	.release	= single_release, \
-}
-
-#define PROC_FILE_LIST(name) \
-	{ __stringify(name), &ext4_seq_##name##_fops }
-
-PROC_FILE_SHOW_DEFN(es_shrinker_info);
-PROC_FILE_SHOW_DEFN(options);
-
-static const struct ext4_proc_files {
-	const char *name;
-	const struct file_operations *fops;
-} proc_files[] = {
-	PROC_FILE_LIST(options),
-	PROC_FILE_LIST(es_shrinker_info),
-	PROC_FILE_LIST(mb_groups),
-	{ NULL, NULL },
-};
-
 int ext4_register_sysfs(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	const struct ext4_proc_files *p;
 	int err;
 
 	init_completion(&sbi->s_kobj_unregister);
@@ -392,11 +362,14 @@ int ext4_register_sysfs(struct super_block *sb)
 
 	if (ext4_proc_root)
 		sbi->s_proc = proc_mkdir(sb->s_id, ext4_proc_root);
-
 	if (sbi->s_proc) {
-		for (p = proc_files; p->name; p++)
-			proc_create_data(p->name, S_IRUGO, sbi->s_proc,
-					 p->fops, sb);
+		proc_create_single_data("options", S_IRUGO, sbi->s_proc,
+				ext4_seq_options_show, sb);
+		proc_create_single_data("es_shrinker_info", S_IRUGO,
+				sbi->s_proc, ext4_seq_es_shrinker_info_show,
+				sb);
+		proc_create_seq_data("mb_groups", S_IRUGO, sbi->s_proc,
+				&ext4_mb_seq_groups_ops, sb);
 	}
 	return 0;
 }
@@ -404,13 +377,9 @@ int ext4_register_sysfs(struct super_block *sb)
 void ext4_unregister_sysfs(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	const struct ext4_proc_files *p;
 
-	if (sbi->s_proc) {
-		for (p = proc_files; p->name; p++)
-			remove_proc_entry(p->name, sbi->s_proc);
-		remove_proc_entry(sb->s_id, ext4_proc_root);
-	}
+	if (sbi->s_proc)
+		remove_proc_subtree(sb->s_id, ext4_proc_root);
 	kobject_del(&sbi->s_kobj);
 }
 
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
