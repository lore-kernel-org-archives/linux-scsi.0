From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/39] proc: introduce
 proc_create_net_single
Date: Thu, 19 Apr 2018 14:41:15 +0200
Message-ID: <20180419124140.9309-15-hch@lst.de>
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

Variant of proc_create_data that directly take a seq_file show
callback and deals with network namespaces in ->open and ->release.
All callers of proc_create + single_open_net converted over, and
single_{open,release}_net are removed entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/proc/proc_net.c             |  47 +++++++-----
 include/linux/proc_fs.h        |   4 ++
 include/linux/seq_file_net.h   |   7 +-
 net/can/bcm.c                  |  16 +----
 net/can/proc.c                 | 127 ++++++---------------------------
 net/ipv4/fib_trie.c            |  16 +----
 net/ipv4/proc.c                |  48 ++-----------
 net/ipv6/proc.c                |  31 ++------
 net/ipv6/route.c               |  15 +---
 net/kcm/kcmproc.c              |  16 +----
 net/netfilter/ipvs/ip_vs_ctl.c |  31 ++------
 net/sctp/proc.c                |  17 +----
 net/xfrm/xfrm_proc.c           |  16 +----
 13 files changed, 84 insertions(+), 307 deletions(-)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 9a1948d58f10..518b39025b23 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -93,37 +93,48 @@ struct proc_dir_entry *proc_create_net_data(const char *name, umode_t mode,
 }
 EXPORT_SYMBOL_GPL(proc_create_net_data);
 
-int single_open_net(struct inode *inode, struct file *file,
-		int (*show)(struct seq_file *, void *))
+static int single_open_net(struct inode *inode, struct file *file)
 {
-	int err;
+	struct proc_dir_entry *de = PDE(inode);
 	struct net *net;
+	int err;
 
-	err = -ENXIO;
 	net = get_proc_net(inode);
-	if (net == NULL)
-		goto err_net;
-
-	err = single_open(file, show, net);
-	if (err < 0)
-		goto err_open;
-
-	return 0;
+	if (!net)
+		return -ENXIO;
 
-err_open:
-	put_net(net);
-err_net:
+	err = single_open(file, de->single_show, net);
+	if (err)
+		put_net(net);
 	return err;
 }
-EXPORT_SYMBOL_GPL(single_open_net);
 
-int single_release_net(struct inode *ino, struct file *f)
+static int single_release_net(struct inode *ino, struct file *f)
 {
 	struct seq_file *seq = f->private_data;
 	put_net(seq->private);
 	return single_release(ino, f);
 }
-EXPORT_SYMBOL_GPL(single_release_net);
+
+static const struct file_operations proc_net_single_fops = {
+	.open		= single_open_net,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release_net,
+};
+
+struct proc_dir_entry *proc_create_net_single(const char *name, umode_t mode,
+		struct proc_dir_entry *parent,
+		int (*show)(struct seq_file *, void *), void *data)
+{
+	struct proc_dir_entry *p;
+
+	p = proc_create_data(name, mode, parent, &proc_net_single_fops, data);
+	if (p)
+		p->single_show = show;
+	return p;
+}
+EXPORT_SYMBOL_GPL(proc_create_net_single);
 
 static struct net *get_proc_task_net(struct inode *dir)
 {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index d58976e93ecd..84ec3cd44f8b 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -58,6 +58,9 @@ struct proc_dir_entry *proc_create_net_data(const char *name, umode_t mode,
 		size_t state_size, void *data);
 #define proc_create_net(name, mode, parent, state_size, ops) \
 	proc_create_net_data(name, mode, parent, state_size, ops, NULL)
+struct proc_dir_entry *proc_create_net_single(const char *name, umode_t mode,
+		struct proc_dir_entry *parent,
+		int (*show)(struct seq_file *, void *), void *data);
 
 #else /* CONFIG_PROC_FS */
 
@@ -97,6 +100,7 @@ static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *p
 
 #define proc_create_net_data(name, mode, parent, ops, state_size, data) ({NULL;})
 #define proc_create_net(name, mode, parent, state_size, ops) ({NULL;})
+#define proc_create_net_single(name, mode, parent, show, data) ({NULL;})
 
 #endif /* CONFIG_PROC_FS */
 
diff --git a/include/linux/seq_file_net.h b/include/linux/seq_file_net.h
index 5ea18a16291a..0fdbe1ddd8d1 100644
--- a/include/linux/seq_file_net.h
+++ b/include/linux/seq_file_net.h
@@ -13,9 +13,6 @@ struct seq_net_private {
 #endif
 };
 
-int single_open_net(struct inode *, struct file *file,
-		int (*show)(struct seq_file *, void *));
-int single_release_net(struct inode *, struct file *);
 static inline struct net *seq_file_net(struct seq_file *seq)
 {
 #ifdef CONFIG_NET_NS
@@ -26,8 +23,8 @@ static inline struct net *seq_file_net(struct seq_file *seq)
 }
 
 /*
- * This one is needed for single_open_net since net is stored directly in
- * private not as a struct i.e. seq_file_net can't be used.
+ * This one is needed for proc_create_net_single since net is stored directly
+ * in private not as a struct i.e. seq_file_net can't be used.
  */
 static inline struct net *seq_file_single_net(struct seq_file *seq)
 {
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 8073fa14e143..6ad89f49b341 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -239,18 +239,6 @@ static int bcm_proc_show(struct seq_file *m, void *v)
 	seq_putc(m, '\n');
 	return 0;
 }
-
-static int bcm_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, bcm_proc_show);
-}
-
-static const struct file_operations bcm_proc_fops = {
-	.open		= bcm_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release_net,
-};
 #endif /* CONFIG_PROC_FS */
 
 /*
@@ -1606,9 +1594,9 @@ static int bcm_connect(struct socket *sock, struct sockaddr *uaddr, int len,
 	if (net->can.bcmproc_dir) {
 		/* unique socket address as filename */
 		sprintf(bo->procname, "%lu", sock_i_ino(sk));
-		bo->bcm_proc_read = proc_create_data(bo->procname, 0644,
+		bo->bcm_proc_read = proc_create_net_single(bo->procname, 0644,
 						     net->can.bcmproc_dir,
-						     &bcm_proc_fops, sk);
+						     bcm_proc_show, sk);
 		if (!bo->bcm_proc_read) {
 			ret = -ENOMEM;
 			goto fail;
diff --git a/net/can/proc.c b/net/can/proc.c
index fde2fd55b826..70fea17bb04c 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -270,18 +270,6 @@ static int can_stats_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int can_stats_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, can_stats_proc_show);
-}
-
-static const struct file_operations can_stats_proc_fops = {
-	.open		= can_stats_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release_net,
-};
-
 static int can_reset_stats_proc_show(struct seq_file *m, void *v)
 {
 	struct net *net = m->private;
@@ -303,36 +291,12 @@ static int can_reset_stats_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int can_reset_stats_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, can_reset_stats_proc_show);
-}
-
-static const struct file_operations can_reset_stats_proc_fops = {
-	.open		= can_reset_stats_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int can_version_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "%s\n", CAN_VERSION_STRING);
 	return 0;
 }
 
-static int can_version_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, can_version_proc_show);
-}
-
-static const struct file_operations can_version_proc_fops = {
-	.open		= can_version_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static inline void can_rcvlist_proc_show_one(struct seq_file *m, int idx,
 					     struct net_device *dev,
 					     struct can_dev_rcv_lists *d)
@@ -373,18 +337,6 @@ static int can_rcvlist_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int can_rcvlist_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, can_rcvlist_proc_show);
-}
-
-static const struct file_operations can_rcvlist_proc_fops = {
-	.open		= can_rcvlist_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static inline void can_rcvlist_proc_show_array(struct seq_file *m,
 					       struct net_device *dev,
 					       struct hlist_head *rcv_array,
@@ -440,19 +392,6 @@ static int can_rcvlist_sff_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int can_rcvlist_sff_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, can_rcvlist_sff_proc_show);
-}
-
-static const struct file_operations can_rcvlist_sff_proc_fops = {
-	.open		= can_rcvlist_sff_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release_net,
-};
-
-
 static int can_rcvlist_eff_proc_show(struct seq_file *m, void *v)
 {
 	struct net_device *dev;
@@ -483,18 +422,6 @@ static int can_rcvlist_eff_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int can_rcvlist_eff_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, can_rcvlist_eff_proc_show);
-}
-
-static const struct file_operations can_rcvlist_eff_proc_fops = {
-	.open		= can_rcvlist_eff_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release_net,
-};
-
 /*
  * can_init_proc - create main CAN proc directory and procfs entries
  */
@@ -510,37 +437,29 @@ void can_init_proc(struct net *net)
 	}
 
 	/* own procfs entries from the AF_CAN core */
-	net->can.pde_version     = proc_create(CAN_PROC_VERSION, 0644,
-					       net->can.proc_dir,
-					       &can_version_proc_fops);
-	net->can.pde_stats       = proc_create(CAN_PROC_STATS, 0644,
-					       net->can.proc_dir,
-					       &can_stats_proc_fops);
-	net->can.pde_reset_stats = proc_create(CAN_PROC_RESET_STATS, 0644,
-					       net->can.proc_dir,
-					       &can_reset_stats_proc_fops);
-	net->can.pde_rcvlist_err = proc_create_data(CAN_PROC_RCVLIST_ERR, 0644,
-						    net->can.proc_dir,
-						    &can_rcvlist_proc_fops,
-						    (void *)RX_ERR);
-	net->can.pde_rcvlist_all = proc_create_data(CAN_PROC_RCVLIST_ALL, 0644,
-						    net->can.proc_dir,
-						    &can_rcvlist_proc_fops,
-						    (void *)RX_ALL);
-	net->can.pde_rcvlist_fil = proc_create_data(CAN_PROC_RCVLIST_FIL, 0644,
-						    net->can.proc_dir,
-						    &can_rcvlist_proc_fops,
-						    (void *)RX_FIL);
-	net->can.pde_rcvlist_inv = proc_create_data(CAN_PROC_RCVLIST_INV, 0644,
-						    net->can.proc_dir,
-						    &can_rcvlist_proc_fops,
-						    (void *)RX_INV);
-	net->can.pde_rcvlist_eff = proc_create(CAN_PROC_RCVLIST_EFF, 0644,
-					       net->can.proc_dir,
-					       &can_rcvlist_eff_proc_fops);
-	net->can.pde_rcvlist_sff = proc_create(CAN_PROC_RCVLIST_SFF, 0644,
-					       net->can.proc_dir,
-					       &can_rcvlist_sff_proc_fops);
+	net->can.pde_version = proc_create_net_single(CAN_PROC_VERSION, 0644,
+			net->can.proc_dir, can_version_proc_show, NULL);
+	net->can.pde_stats = proc_create_net_single(CAN_PROC_STATS, 0644,
+			net->can.proc_dir, can_stats_proc_show, NULL);
+	net->can.pde_reset_stats = proc_create_net_single(CAN_PROC_RESET_STATS,
+			0644, net->can.proc_dir, can_reset_stats_proc_show,
+			NULL);
+	net->can.pde_rcvlist_err = proc_create_net_single(CAN_PROC_RCVLIST_ERR,
+			0644, net->can.proc_dir, can_rcvlist_proc_show,
+			(void *)RX_ERR);
+	net->can.pde_rcvlist_all = proc_create_net_single(CAN_PROC_RCVLIST_ALL,
+			0644, net->can.proc_dir, can_rcvlist_proc_show,
+			(void *)RX_ALL);
+	net->can.pde_rcvlist_fil = proc_create_net_single(CAN_PROC_RCVLIST_FIL,
+			0644, net->can.proc_dir, can_rcvlist_proc_show,
+			(void *)RX_FIL);
+	net->can.pde_rcvlist_inv = proc_create_net_single(CAN_PROC_RCVLIST_INV,
+			0644, net->can.proc_dir, can_rcvlist_proc_show,
+			(void *)RX_INV);
+	net->can.pde_rcvlist_eff = proc_create_net_single(CAN_PROC_RCVLIST_EFF,
+			0644, net->can.proc_dir, can_rcvlist_eff_proc_show, NULL);
+	net->can.pde_rcvlist_sff = proc_create_net_single(CAN_PROC_RCVLIST_SFF,
+			0644, net->can.proc_dir, can_rcvlist_sff_proc_show, NULL);
 }
 
 /*
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 3293f04b941d..99c23a0cb8ca 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2348,18 +2348,6 @@ static int fib_triestat_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int fib_triestat_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, fib_triestat_seq_show);
-}
-
-static const struct file_operations fib_triestat_fops = {
-	.open	= fib_triestat_seq_open,
-	.read	= seq_read,
-	.llseek	= seq_lseek,
-	.release = single_release_net,
-};
-
 static struct key_vector *fib_trie_get_idx(struct seq_file *seq, loff_t pos)
 {
 	struct fib_trie_iter *iter = seq->private;
@@ -2719,8 +2707,8 @@ int __net_init fib_proc_init(struct net *net)
 			sizeof(struct fib_trie_iter)))
 		goto out1;
 
-	if (!proc_create("fib_triestat", 0444, net->proc_net,
-			 &fib_triestat_fops))
+	if (!proc_create_net_single("fib_triestat", 0444, net->proc_net,
+			fib_triestat_seq_show, NULL))
 		goto out2;
 
 	if (!proc_create_net("route", 0444, net->proc_net, &fib_route_seq_ops,
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index a058de677e94..573e43c8ed87 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -77,18 +77,6 @@ static int sockstat_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int sockstat_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, sockstat_seq_show);
-}
-
-static const struct file_operations sockstat_seq_fops = {
-	.open	 = sockstat_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = single_release_net,
-};
-
 /* snmp items */
 static const struct snmp_mib snmp4_ipstats_list[] = {
 	SNMP_MIB_ITEM("InReceives", IPSTATS_MIB_INPKTS),
@@ -460,20 +448,6 @@ static int snmp_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int snmp_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, snmp_seq_show);
-}
-
-static const struct file_operations snmp_seq_fops = {
-	.open	 = snmp_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = single_release_net,
-};
-
-
-
 /*
  *	Output /proc/net/netstat
  */
@@ -507,26 +481,16 @@ static int netstat_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int netstat_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, netstat_seq_show);
-}
-
-static const struct file_operations netstat_seq_fops = {
-	.open	 = netstat_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = single_release_net,
-};
-
 static __net_init int ip_proc_init_net(struct net *net)
 {
-	if (!proc_create("sockstat", 0444, net->proc_net,
-			 &sockstat_seq_fops))
+	if (!proc_create_net_single("sockstat", 0444, net->proc_net,
+			sockstat_seq_show, NULL))
 		goto out_sockstat;
-	if (!proc_create("netstat", 0444, net->proc_net, &netstat_seq_fops))
+	if (!proc_create_net_single("netstat", 0444, net->proc_net,
+			netstat_seq_show, NULL))
 		goto out_netstat;
-	if (!proc_create("snmp", 0444, net->proc_net, &snmp_seq_fops))
+	if (!proc_create_net_single("snmp", 0444, net->proc_net, snmp_seq_show,
+			NULL))
 		goto out_snmp;
 
 	return 0;
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index a0edf194822a..2356b4af7309 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -53,18 +53,6 @@ static int sockstat6_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int sockstat6_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, sockstat6_seq_show);
-}
-
-static const struct file_operations sockstat6_seq_fops = {
-	.open	 = sockstat6_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = single_release_net,
-};
-
 static const struct snmp_mib snmp6_ipstats_list[] = {
 /* ipv6 mib according to RFC 2465 */
 	SNMP_MIB_ITEM("Ip6InReceives", IPSTATS_MIB_INPKTS),
@@ -242,18 +230,6 @@ static int snmp6_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int snmp6_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, snmp6_seq_show);
-}
-
-static const struct file_operations snmp6_seq_fops = {
-	.open	 = snmp6_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = single_release_net,
-};
-
 static int snmp6_dev_seq_show(struct seq_file *seq, void *v)
 {
 	struct inet6_dev *idev = (struct inet6_dev *)seq->private;
@@ -302,11 +278,12 @@ int snmp6_unregister_dev(struct inet6_dev *idev)
 
 static int __net_init ipv6_proc_init_net(struct net *net)
 {
-	if (!proc_create("sockstat6", 0444, net->proc_net,
-			 &sockstat6_seq_fops))
+	if (!proc_create_net_single("sockstat6", 0444, net->proc_net,
+			sockstat6_seq_show, NULL))
 		return -ENOMEM;
 
-	if (!proc_create("snmp6", 0444, net->proc_net, &snmp6_seq_fops))
+	if (!proc_create_net_single("snmp6", 0444, net->proc_net,
+			snmp6_seq_show, NULL))
 		goto proc_snmp6_fail;
 
 	net->mib.proc_net_devsnmp6 = proc_mkdir("dev_snmp6", net->proc_net);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 07c4aafe7710..095ed6ae9cc9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4869,18 +4869,6 @@ static int rt6_stats_seq_show(struct seq_file *seq, void *v)
 
 	return 0;
 }
-
-static int rt6_stats_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, rt6_stats_seq_show);
-}
-
-static const struct file_operations rt6_stats_seq_fops = {
-	.open	 = rt6_stats_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = single_release_net,
-};
 #endif	/* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SYSCTL
@@ -5087,7 +5075,8 @@ static int __net_init ip6_route_net_init_late(struct net *net)
 #ifdef CONFIG_PROC_FS
 	proc_create_net("ipv6_route", 0, net->proc_net, &ipv6_route_seq_ops,
 			sizeof(struct ipv6_route_iter));
-	proc_create("rt6_stats", 0444, net->proc_net, &rt6_stats_seq_fops);
+	proc_create_net_single("rt6_stats", 0444, net->proc_net,
+			rt6_stats_seq_show, NULL);
 #endif
 	return 0;
 }
diff --git a/net/kcm/kcmproc.c b/net/kcm/kcmproc.c
index 6283ed2f43b2..370da2f80e3c 100644
--- a/net/kcm/kcmproc.c
+++ b/net/kcm/kcmproc.c
@@ -345,22 +345,10 @@ static int kcm_stats_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int kcm_stats_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, kcm_stats_seq_show);
-}
-
-static const struct file_operations kcm_stats_seq_fops = {
-	.open    = kcm_stats_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = single_release_net,
-};
-
 static int kcm_proc_init_net(struct net *net)
 {
-	if (!proc_create("kcm_stats", 0444, net->proc_net,
-			 &kcm_stats_seq_fops))
+	if (!proc_create_net_single("kcm_stats", 0444, net->proc_net,
+			 kcm_stats_seq_show, NULL))
 		goto out_kcm_stats;
 
 	if (!proc_create_net("kcm", 0444, net->proc_net, &kcm_seq_ops,
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 5d7abe11ccb5..f5a1d3503a7c 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2141,18 +2141,6 @@ static int ip_vs_stats_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int ip_vs_stats_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, ip_vs_stats_show);
-}
-
-static const struct file_operations ip_vs_stats_fops = {
-	.open = ip_vs_stats_seq_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release_net,
-};
-
 static int ip_vs_stats_percpu_show(struct seq_file *seq, void *v)
 {
 	struct net *net = seq_file_single_net(seq);
@@ -2208,18 +2196,6 @@ static int ip_vs_stats_percpu_show(struct seq_file *seq, void *v)
 
 	return 0;
 }
-
-static int ip_vs_stats_percpu_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, ip_vs_stats_percpu_show);
-}
-
-static const struct file_operations ip_vs_stats_percpu_fops = {
-	.open = ip_vs_stats_percpu_seq_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release_net,
-};
 #endif
 
 /*
@@ -4027,9 +4003,10 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 
 	proc_create_net("ip_vs", 0, ipvs->net->proc_net, &ip_vs_info_seq_ops,
 			sizeof(struct ip_vs_iter));
-	proc_create("ip_vs_stats", 0, ipvs->net->proc_net, &ip_vs_stats_fops);
-	proc_create("ip_vs_stats_percpu", 0, ipvs->net->proc_net,
-		    &ip_vs_stats_percpu_fops);
+	proc_create_net_single("ip_vs_stats", 0, ipvs->net->proc_net,
+			ip_vs_stats_show, NULL);
+	proc_create_net_single("ip_vs_stats_percpu", 0, ipvs->net->proc_net,
+			ip_vs_stats_percpu_show, NULL);
 
 	if (ip_vs_control_net_init_sysctl(ipvs))
 		goto err;
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 009c185b71eb..ef5c9a82d4e8 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -88,19 +88,6 @@ static int sctp_snmp_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-/* Initialize the seq file operations for 'snmp' object. */
-static int sctp_snmp_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, sctp_snmp_seq_show);
-}
-
-static const struct file_operations sctp_snmp_seq_fops = {
-	.open	 = sctp_snmp_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = single_release_net,
-};
-
 /* Dump local addresses of an association/endpoint. */
 static void sctp_seq_dump_local_addrs(struct seq_file *seq, struct sctp_ep_common *epb)
 {
@@ -408,8 +395,8 @@ int __net_init sctp_proc_init(struct net *net)
 	net->sctp.proc_net_sctp = proc_net_mkdir(net, "sctp", net->proc_net);
 	if (!net->sctp.proc_net_sctp)
 		return -ENOMEM;
-	if (!proc_create("snmp", 0444, net->sctp.proc_net_sctp,
-			 &sctp_snmp_seq_fops))
+	if (!proc_create_net_single("snmp", 0444, net->sctp.proc_net_sctp,
+			 sctp_snmp_seq_show, NULL))
 		goto cleanup;
 	if (!proc_create_net("eps", 0444, net->sctp.proc_net_sctp,
 			&sctp_eps_ops, sizeof(struct seq_net_private)))
diff --git a/net/xfrm/xfrm_proc.c b/net/xfrm/xfrm_proc.c
index ed06903cd84d..178318d2e120 100644
--- a/net/xfrm/xfrm_proc.c
+++ b/net/xfrm/xfrm_proc.c
@@ -65,22 +65,10 @@ static int xfrm_statistics_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int xfrm_statistics_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open_net(inode, file, xfrm_statistics_seq_show);
-}
-
-static const struct file_operations xfrm_statistics_seq_fops = {
-	.open	 = xfrm_statistics_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = single_release_net,
-};
-
 int __net_init xfrm_proc_init(struct net *net)
 {
-	if (!proc_create("xfrm_stat", 0444, net->proc_net,
-			 &xfrm_statistics_seq_fops))
+	if (!proc_create_net_single("xfrm_stat", 0444, net->proc_net,
+			 xfrm_statistics_seq_show, NULL))
 		return -ENOMEM;
 	return 0;
 }
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
