From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 34/40] atm: simplify procfs code
Date: Wed, 25 Apr 2018 17:48:21 +0200
Message-ID: <20180425154827.32251-35-hch@lst.de>
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
 net/atm/proc.c | 65 ++++++--------------------------------------------
 1 file changed, 7 insertions(+), 58 deletions(-)

diff --git a/net/atm/proc.c b/net/atm/proc.c
index 55410c00c7e2..f272b0f59d82 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -257,18 +257,6 @@ static const struct seq_operations atm_dev_seq_ops = {
 	.show	= atm_dev_seq_show,
 };
 
-static int atm_dev_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &atm_dev_seq_ops);
-}
-
-static const struct file_operations devices_seq_fops = {
-	.open		= atm_dev_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int pvc_seq_show(struct seq_file *seq, void *v)
 {
 	static char atm_pvc_banner[] =
@@ -440,58 +428,19 @@ void atm_proc_dev_deregister(struct atm_dev *dev)
 	kfree(dev->proc_name);
 }
 
-static struct atm_proc_entry {
-	char *name;
-	const struct file_operations *proc_fops;
-	struct proc_dir_entry *dirent;
-} atm_proc_ents[] = {
-	{ .name = "devices",	.proc_fops = &devices_seq_fops },
-	{ .name = "pvc",	.proc_fops = &pvc_seq_fops },
-	{ .name = "svc",	.proc_fops = &svc_seq_fops },
-	{ .name = "vc",		.proc_fops = &vcc_seq_fops },
-	{ .name = NULL,		.proc_fops = NULL }
-};
-
-static void atm_proc_dirs_remove(void)
-{
-	static struct atm_proc_entry *e;
-
-	for (e = atm_proc_ents; e->name; e++) {
-		if (e->dirent)
-			remove_proc_entry(e->name, atm_proc_root);
-	}
-	remove_proc_entry("atm", init_net.proc_net);
-}
-
 int __init atm_proc_init(void)
 {
-	static struct atm_proc_entry *e;
-	int ret;
-
 	atm_proc_root = proc_net_mkdir(&init_net, "atm", init_net.proc_net);
 	if (!atm_proc_root)
-		goto err_out;
-	for (e = atm_proc_ents; e->name; e++) {
-		struct proc_dir_entry *dirent;
-
-		dirent = proc_create(e->name, 0444,
-				     atm_proc_root, e->proc_fops);
-		if (!dirent)
-			goto err_out_remove;
-		e->dirent = dirent;
-	}
-	ret = 0;
-out:
-	return ret;
-
-err_out_remove:
-	atm_proc_dirs_remove();
-err_out:
-	ret = -ENOMEM;
-	goto out;
+		return -ENOMEM;
+	proc_create_seq("devices", 0444, atm_proc_root, &atm_dev_seq_ops);
+	proc_create("pvc", 0444, atm_proc_root, &pvc_seq_fops);
+	proc_create("svc", 0444, atm_proc_root, &svc_seq_fops);
+	proc_create("vc", 0444, atm_proc_root, &vcc_seq_fops);
+	return 0;
 }
 
 void atm_proc_exit(void)
 {
-	atm_proc_dirs_remove();
+	remove_proc_subtree("atm", init_net.proc_net);
 }
-- 
2.17.0
