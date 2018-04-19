From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/39] sgi-gru: simplify procfs code
Date: Thu, 19 Apr 2018 14:41:18 +0200
Message-ID: <20180419124140.9309-18-hch@lst.de>
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
 drivers/misc/sgi-gru/gruprocfs.c | 81 ++++++--------------------------
 1 file changed, 14 insertions(+), 67 deletions(-)

diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index 4f7635922394..42ea2eccaee9 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -270,16 +270,6 @@ static int options_open(struct inode *inode, struct file *file)
 	return single_open(file, options_show, NULL);
 }
 
-static int cch_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &cch_seq_ops);
-}
-
-static int gru_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &gru_seq_ops);
-}
-
 /* *INDENT-OFF* */
 static const struct file_operations statistics_fops = {
 	.open 		= statistics_open,
@@ -305,73 +295,30 @@ static const struct file_operations options_fops = {
 	.release 	= single_release,
 };
 
-static const struct file_operations cch_fops = {
-	.open 		= cch_open,
-	.read 		= seq_read,
-	.llseek 	= seq_lseek,
-	.release 	= seq_release,
-};
-static const struct file_operations gru_fops = {
-	.open 		= gru_open,
-	.read 		= seq_read,
-	.llseek 	= seq_lseek,
-	.release 	= seq_release,
-};
-
-static struct proc_entry {
-	char *name;
-	umode_t mode;
-	const struct file_operations *fops;
-	struct proc_dir_entry *entry;
-} proc_files[] = {
-	{"statistics", 0644, &statistics_fops},
-	{"mcs_statistics", 0644, &mcs_statistics_fops},
-	{"debug_options", 0644, &options_fops},
-	{"cch_status", 0444, &cch_fops},
-	{"gru_status", 0444, &gru_fops},
-	{NULL}
-};
-/* *INDENT-ON* */
-
 static struct proc_dir_entry *proc_gru __read_mostly;
 
-static int create_proc_file(struct proc_entry *p)
-{
-	p->entry = proc_create(p->name, p->mode, proc_gru, p->fops);
-	if (!p->entry)
-		return -1;
-	return 0;
-}
-
-static void delete_proc_files(void)
-{
-	struct proc_entry *p;
-
-	if (proc_gru) {
-		for (p = proc_files; p->name; p++)
-			if (p->entry)
-				remove_proc_entry(p->name, proc_gru);
-		proc_remove(proc_gru);
-	}
-}
-
 int gru_proc_init(void)
 {
-	struct proc_entry *p;
-
 	proc_gru = proc_mkdir("sgi_uv/gru", NULL);
-
-	for (p = proc_files; p->name; p++)
-		if (create_proc_file(p))
-			goto err;
+	if (!proc_gru)
+		return -1;
+	if (!proc_create("statistics", 0644, proc_gru, &statistics_fops))
+		goto err;
+	if (!proc_create("mcs_statistics", 0644, proc_gru, &mcs_statistics_fops))
+		goto err;
+	if (!proc_create("debug_options", 0644, proc_gru, &options_fops))
+		goto err;
+	if (!proc_create_seq("cch_status", 0444, proc_gru, &cch_seq_ops))
+		goto err;
+	if (!proc_create_seq("gru_status", 0444, proc_gru, &gru_seq_ops))
+		goto err;
 	return 0;
-
 err:
-	delete_proc_files();
+	remove_proc_subtree("sgi_uv/gru", NULL);
 	return -1;
 }
 
 void gru_proc_exit(void)
 {
-	delete_proc_files();
+	remove_proc_subtree("sgi_uv/gru", NULL);
 }
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
