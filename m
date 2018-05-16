From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/42] proc: don't detour through seq->private to get the inode
Date: Wed, 16 May 2018 11:43:07 +0200
Message-ID: <20180516094346.20506-4-hch@lst.de>
References: <20180516094346.20506-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180516094346.20506-1-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/proc/array.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 911f66924d81..4a8e413bf59b 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -677,20 +677,22 @@ get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
 
 static int children_seq_show(struct seq_file *seq, void *v)
 {
-	seq_printf(seq, "%d ", pid_nr_ns(v, proc_pid_ns(seq->private)));
+	struct inode *inode = file_inode(seq->file);
+
+	seq_printf(seq, "%d ", pid_nr_ns(v, proc_pid_ns(inode)));
 	return 0;
 }
 
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
@@ -711,17 +713,7 @@ static const struct seq_operations children_seq_ops = {
 
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
