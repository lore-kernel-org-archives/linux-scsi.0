From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 26/40] drbd: switch to proc_create_single
Date: Wed, 25 Apr 2018 17:48:13 +0200
Message-ID: <20180425154827.32251-27-hch@lst.de>
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

And stop messing with try_module_get on THIS_MODULE, which doesn't make
any sense here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_int.h  |  2 +-
 drivers/block/drbd/drbd_main.c |  3 ++-
 drivers/block/drbd/drbd_proc.c | 34 +---------------------------------
 3 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 06ecee1b528e..461ddec04e7c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1643,7 +1643,7 @@ void drbd_bump_write_ordering(struct drbd_resource *resource, struct drbd_backin
 
 /* drbd_proc.c */
 extern struct proc_dir_entry *drbd_proc;
-extern const struct file_operations drbd_proc_fops;
+int drbd_seq_show(struct seq_file *seq, void *v);
 
 /* drbd_actlog.c */
 extern bool drbd_al_begin_io_prepare(struct drbd_device *device, struct drbd_interval *i);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 185f1ef00a7c..c2d154faac02 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3010,7 +3010,8 @@ static int __init drbd_init(void)
 		goto fail;
 
 	err = -ENOMEM;
-	drbd_proc = proc_create_data("drbd", S_IFREG | S_IRUGO , NULL, &drbd_proc_fops, NULL);
+	drbd_proc = proc_create_single("drbd", S_IFREG | S_IRUGO , NULL,
+			drbd_seq_show);
 	if (!drbd_proc)	{
 		pr_err("unable to register proc file\n");
 		goto fail;
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 582caeb0de86..74ef29247bb5 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -33,18 +33,7 @@
 #include <linux/drbd.h>
 #include "drbd_int.h"
 
-static int drbd_proc_open(struct inode *inode, struct file *file);
-static int drbd_proc_release(struct inode *inode, struct file *file);
-
-
 struct proc_dir_entry *drbd_proc;
-const struct file_operations drbd_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= drbd_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= drbd_proc_release,
-};
 
 static void seq_printf_with_thousands_grouping(struct seq_file *seq, long v)
 {
@@ -235,7 +224,7 @@ static void drbd_syncer_progress(struct drbd_device *device, struct seq_file *se
 	}
 }
 
-static int drbd_seq_show(struct seq_file *seq, void *v)
+int drbd_seq_show(struct seq_file *seq, void *v)
 {
 	int i, prev_i = -1;
 	const char *sn;
@@ -345,24 +334,3 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 
 	return 0;
 }
-
-static int drbd_proc_open(struct inode *inode, struct file *file)
-{
-	int err;
-
-	if (try_module_get(THIS_MODULE)) {
-		err = single_open(file, drbd_seq_show, NULL);
-		if (err)
-			module_put(THIS_MODULE);
-		return err;
-	}
-	return -ENODEV;
-}
-
-static int drbd_proc_release(struct inode *inode, struct file *file)
-{
-	module_put(THIS_MODULE);
-	return single_release(inode, file);
-}
-
-/* PROC FS stuff end */
-- 
2.17.0
