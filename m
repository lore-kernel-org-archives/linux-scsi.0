From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 29/39] neigh: switch to proc_create_seq_data
Date: Thu, 19 Apr 2018 14:41:30 +0200
Message-ID: <20180419124140.9309-30-hch@lst.de>
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

And use proc private data directly instead of doing a detour
through seq->private.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/core/neighbour.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 7b7a14abba28..cbfb6d71b8be 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -58,7 +58,7 @@ static void neigh_update_notify(struct neighbour *neigh, u32 nlmsg_pid);
 static int pneigh_ifdown(struct neigh_table *tbl, struct net_device *dev);
 
 #ifdef CONFIG_PROC_FS
-static const struct file_operations neigh_stat_seq_fops;
+static const struct seq_operations neigh_stat_seq_ops;
 #endif
 
 /*
@@ -1550,8 +1550,8 @@ void neigh_table_init(int index, struct neigh_table *tbl)
 		panic("cannot create neighbour cache statistics");
 
 #ifdef CONFIG_PROC_FS
-	if (!proc_create_data(tbl->id, 0, init_net.proc_net_stat,
-			      &neigh_stat_seq_fops, tbl))
+	if (!proc_create_seq_data(tbl->id, 0, init_net.proc_net_stat,
+			      &neigh_stat_seq_ops, tbl))
 		panic("cannot create neighbour proc dir entry");
 #endif
 
@@ -2774,7 +2774,7 @@ EXPORT_SYMBOL(neigh_seq_stop);
 
 static void *neigh_stat_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct neigh_table *tbl = seq->private;
+	struct neigh_table *tbl = PDE_DATA(file_inode(seq->file));
 	int cpu;
 
 	if (*pos == 0)
@@ -2791,7 +2791,7 @@ static void *neigh_stat_seq_start(struct seq_file *seq, loff_t *pos)
 
 static void *neigh_stat_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct neigh_table *tbl = seq->private;
+	struct neigh_table *tbl = PDE_DATA(file_inode(seq->file));
 	int cpu;
 
 	for (cpu = *pos; cpu < nr_cpu_ids; ++cpu) {
@@ -2810,7 +2810,7 @@ static void neigh_stat_seq_stop(struct seq_file *seq, void *v)
 
 static int neigh_stat_seq_show(struct seq_file *seq, void *v)
 {
-	struct neigh_table *tbl = seq->private;
+	struct neigh_table *tbl = PDE_DATA(file_inode(seq->file));
 	struct neigh_statistics *st = v;
 
 	if (v == SEQ_START_TOKEN) {
@@ -2849,25 +2849,6 @@ static const struct seq_operations neigh_stat_seq_ops = {
 	.stop	= neigh_stat_seq_stop,
 	.show	= neigh_stat_seq_show,
 };
-
-static int neigh_stat_seq_open(struct inode *inode, struct file *file)
-{
-	int ret = seq_open(file, &neigh_stat_seq_ops);
-
-	if (!ret) {
-		struct seq_file *sf = file->private_data;
-		sf->private = PDE_DATA(inode);
-	}
-	return ret;
-};
-
-static const struct file_operations neigh_stat_seq_fops = {
-	.open 	 = neigh_stat_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
 #endif /* CONFIG_PROC_FS */
 
 static inline size_t neigh_nlmsg_size(void)
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
