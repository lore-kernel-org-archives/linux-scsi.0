From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 32/39] bluetooth: switch to
 proc_create_seq_data
Date: Thu, 19 Apr 2018 14:41:33 +0200
Message-ID: <20180419124140.9309-33-hch@lst.de>
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
through seq->private and private state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/bluetooth/af_bluetooth.c | 40 +++++-------------------------------
 1 file changed, 5 insertions(+), 35 deletions(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 84d92a077834..3264e1873219 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -605,15 +605,10 @@ int bt_sock_wait_ready(struct sock *sk, unsigned long flags)
 EXPORT_SYMBOL(bt_sock_wait_ready);
 
 #ifdef CONFIG_PROC_FS
-struct bt_seq_state {
-	struct bt_sock_list *l;
-};
-
 static void *bt_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(seq->private->l->lock)
 {
-	struct bt_seq_state *s = seq->private;
-	struct bt_sock_list *l = s->l;
+	struct bt_sock_list *l = PDE_DATA(file_inode(seq->file));
 
 	read_lock(&l->lock);
 	return seq_hlist_start_head(&l->head, *pos);
@@ -621,8 +616,7 @@ static void *bt_seq_start(struct seq_file *seq, loff_t *pos)
 
 static void *bt_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct bt_seq_state *s = seq->private;
-	struct bt_sock_list *l = s->l;
+	struct bt_sock_list *l = PDE_DATA(file_inode(seq->file));
 
 	return seq_hlist_next(v, &l->head, pos);
 }
@@ -630,16 +624,14 @@ static void *bt_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static void bt_seq_stop(struct seq_file *seq, void *v)
 	__releases(seq->private->l->lock)
 {
-	struct bt_seq_state *s = seq->private;
-	struct bt_sock_list *l = s->l;
+	struct bt_sock_list *l = PDE_DATA(file_inode(seq->file));
 
 	read_unlock(&l->lock);
 }
 
 static int bt_seq_show(struct seq_file *seq, void *v)
 {
-	struct bt_seq_state *s = seq->private;
-	struct bt_sock_list *l = s->l;
+	struct bt_sock_list *l = PDE_DATA(file_inode(seq->file));
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq ,"sk               RefCnt Rmem   Wmem   User   Inode  Parent");
@@ -681,35 +673,13 @@ static const struct seq_operations bt_seq_ops = {
 	.show  = bt_seq_show,
 };
 
-static int bt_seq_open(struct inode *inode, struct file *file)
-{
-	struct bt_sock_list *sk_list;
-	struct bt_seq_state *s;
-
-	sk_list = PDE_DATA(inode);
-	s = __seq_open_private(file, &bt_seq_ops,
-			       sizeof(struct bt_seq_state));
-	if (!s)
-		return -ENOMEM;
-
-	s->l = sk_list;
-	return 0;
-}
-
-static const struct file_operations bt_fops = {
-	.open = bt_seq_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release_private
-};
-
 int bt_procfs_init(struct net *net, const char *name,
 		   struct bt_sock_list *sk_list,
 		   int (* seq_show)(struct seq_file *, void *))
 {
 	sk_list->custom_seq_show = seq_show;
 
-	if (!proc_create_data(name, 0, net->proc_net, &bt_fops, sk_list))
+	if (!proc_create_seq_data(name, 0, net->proc_net, &bt_seq_ops, sk_list))
 		return -ENOMEM;
 	return 0;
 }
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
