From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/40] proc: introduce proc_create_net{,_data}
Date: Wed, 25 Apr 2018 17:48:02 +0200
Message-ID: <20180425154827.32251-16-hch@lst.de>
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

Variants of proc_create{,_data} that directly take a struct seq_operations
and deal with network namespaces in ->open and ->release.  All callers of
proc_create + seq_open_net converted over, and seq_{open,release}_net are
removed entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ppp/pppoe.c                 | 18 +-------
 fs/nfs/client.c                         | 43 ++---------------
 fs/proc/proc_net.c                      | 61 ++++++++++++++++---------
 include/linux/proc_fs.h                 |  9 ++++
 include/linux/seq_file_net.h            |  3 --
 include/net/ip6_fib.h                   | 10 +++-
 include/net/phonet/pn_dev.h             |  4 +-
 include/net/udp.h                       |  4 +-
 net/8021q/vlanproc.c                    | 18 ++------
 net/atm/clip.c                          | 17 +------
 net/core/net-procfs.c                   | 49 +++-----------------
 net/core/sock.c                         | 16 +------
 net/decnet/dn_neigh.c                   | 18 +-------
 net/ipv4/arp.c                          | 17 ++-----
 net/ipv4/fib_trie.c                     | 32 ++-----------
 net/ipv4/igmp.c                         | 33 ++-----------
 net/ipv4/ipmr.c                         | 32 ++-----------
 net/ipv4/ping.c                         | 16 +------
 net/ipv4/raw.c                          | 17 +------
 net/ipv4/tcp_ipv4.c                     | 17 +------
 net/ipv4/udp.c                          | 21 ++-------
 net/ipv4/udplite.c                      |  4 +-
 net/ipv6/addrconf.c                     | 16 +------
 net/ipv6/anycast.c                      | 16 +------
 net/ipv6/ip6_fib.c                      | 18 +-------
 net/ipv6/ip6_flowlabel.c                | 17 +------
 net/ipv6/ip6mr.c                        | 32 ++-----------
 net/ipv6/mcast.c                        | 34 ++------------
 net/ipv6/ping.c                         | 16 +------
 net/ipv6/raw.c                          | 17 +------
 net/ipv6/route.c                        | 11 +----
 net/ipv6/tcp_ipv6.c                     | 17 +------
 net/ipv6/udp.c                          | 21 ++-------
 net/ipv6/udplite.c                      |  5 +-
 net/kcm/kcmproc.c                       | 16 +------
 net/key/af_key.c                        | 16 +------
 net/l2tp/l2tp_ppp.c                     | 22 +--------
 net/netfilter/ipvs/ip_vs_app.c          | 16 +------
 net/netfilter/ipvs/ip_vs_conn.c         | 35 ++------------
 net/netfilter/ipvs/ip_vs_ctl.c          | 16 +------
 net/netfilter/nf_conntrack_expect.c     | 17 +------
 net/netfilter/nf_conntrack_standalone.c | 33 ++-----------
 net/netfilter/nf_log.c                  | 19 +-------
 net/netfilter/nf_synproxy_core.c        | 17 +------
 net/netfilter/nfnetlink_log.c           | 18 +-------
 net/netfilter/nfnetlink_queue.c         | 18 +-------
 net/netfilter/x_tables.c                | 18 ++------
 net/netlink/af_netlink.c                | 18 +-------
 net/packet/af_packet.c                  | 17 +------
 net/phonet/pn_dev.c                     |  6 ++-
 net/phonet/socket.c                     | 30 +-----------
 net/rxrpc/ar-internal.h                 |  4 +-
 net/rxrpc/net_ns.c                      |  7 ++-
 net/rxrpc/proc.c                        | 31 +------------
 net/sctp/proc.c                         | 54 +++-------------------
 net/unix/af_unix.c                      | 17 +------
 net/wireless/wext-proc.c                | 17 +------
 57 files changed, 202 insertions(+), 939 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 1483bc7b01e1..714bb605a140 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -1092,21 +1092,6 @@ static const struct seq_operations pppoe_seq_ops = {
 	.stop		= pppoe_seq_stop,
 	.show		= pppoe_seq_show,
 };
-
-static int pppoe_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &pppoe_seq_ops,
-			sizeof(struct seq_net_private));
-}
-
-static const struct file_operations pppoe_seq_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pppoe_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 #endif /* CONFIG_PROC_FS */
 
 static const struct proto_ops pppoe_ops = {
@@ -1142,7 +1127,8 @@ static __net_init int pppoe_init_net(struct net *net)
 
 	rwlock_init(&pn->hash_lock);
 
-	pde = proc_create("pppoe", 0444, net->proc_net, &pppoe_seq_fops);
+	pde = proc_create_net("pppoe", 0444, net->proc_net,
+			&pppoe_seq_ops, sizeof(struct seq_net_private));
 #ifdef CONFIG_PROC_FS
 	if (!pde)
 		return -ENOMEM;
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index b9129e2befea..bbc91d7ca1bd 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1067,7 +1067,6 @@ void nfs_clients_init(struct net *net)
 }
 
 #ifdef CONFIG_PROC_FS
-static int nfs_server_list_open(struct inode *inode, struct file *file);
 static void *nfs_server_list_start(struct seq_file *p, loff_t *pos);
 static void *nfs_server_list_next(struct seq_file *p, void *v, loff_t *pos);
 static void nfs_server_list_stop(struct seq_file *p, void *v);
@@ -1080,14 +1079,6 @@ static const struct seq_operations nfs_server_list_ops = {
 	.show	= nfs_server_list_show,
 };
 
-static const struct file_operations nfs_server_list_fops = {
-	.open		= nfs_server_list_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
-static int nfs_volume_list_open(struct inode *inode, struct file *file);
 static void *nfs_volume_list_start(struct seq_file *p, loff_t *pos);
 static void *nfs_volume_list_next(struct seq_file *p, void *v, loff_t *pos);
 static void nfs_volume_list_stop(struct seq_file *p, void *v);
@@ -1100,23 +1091,6 @@ static const struct seq_operations nfs_volume_list_ops = {
 	.show	= nfs_volume_list_show,
 };
 
-static const struct file_operations nfs_volume_list_fops = {
-	.open		= nfs_volume_list_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
-/*
- * open "/proc/fs/nfsfs/servers" which provides a summary of servers with which
- * we're dealing
- */
-static int nfs_server_list_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &nfs_server_list_ops,
-			   sizeof(struct seq_net_private));
-}
-
 /*
  * set up the iterator to start reading from the server list and return the first item
  */
@@ -1184,15 +1158,6 @@ static int nfs_server_list_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-/*
- * open "/proc/fs/nfsfs/volumes" which provides a summary of extant volumes
- */
-static int nfs_volume_list_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &nfs_volume_list_ops,
-			   sizeof(struct seq_net_private));
-}
-
 /*
  * set up the iterator to start reading from the volume list and return the first item
  */
@@ -1278,14 +1243,14 @@ int nfs_fs_proc_net_init(struct net *net)
 		goto error_0;
 
 	/* a file of servers with which we're dealing */
-	p = proc_create("servers", S_IFREG|S_IRUGO,
-			nn->proc_nfsfs, &nfs_server_list_fops);
+	p = proc_create_net("servers", S_IFREG|S_IRUGO, nn->proc_nfsfs,
+			&nfs_server_list_ops, sizeof(struct seq_net_private));
 	if (!p)
 		goto error_1;
 
 	/* a file of volumes that we have mounted */
-	p = proc_create("volumes", S_IFREG|S_IRUGO,
-			nn->proc_nfsfs, &nfs_volume_list_fops);
+	p = proc_create_net("volumes", S_IFREG|S_IRUGO, nn->proc_nfsfs,
+			&nfs_volume_list_ops, sizeof(struct seq_net_private));
 	if (!p)
 		goto error_1;
 	return 0;
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 1763f370489d..2b04ca9d7601 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -38,20 +38,20 @@ static struct net *get_proc_net(const struct inode *inode)
 	return maybe_get_net(PDE_NET(PDE(inode)));
 }
 
-int seq_open_net(struct inode *ino, struct file *f,
-		 const struct seq_operations *ops, int size)
+static int seq_open_net(struct inode *inode, struct file *file)
 {
-	struct net *net;
+	size_t state_size = PDE(inode)->state_size;
 	struct seq_net_private *p;
+	struct net *net;
 
-	BUG_ON(size < sizeof(*p));
+	WARN_ON_ONCE(state_size < sizeof(*p));
 
-	net = get_proc_net(ino);
-	if (net == NULL)
+	net = get_proc_net(inode);
+	if (!net)
 		return -ENXIO;
 
-	p = __seq_open_private(f, ops, size);
-	if (p == NULL) {
+	p = __seq_open_private(file, PDE(inode)->seq_ops, state_size);
+	if (!p) {
 		put_net(net);
 		return -ENOMEM;
 	}
@@ -60,7 +60,38 @@ int seq_open_net(struct inode *ino, struct file *f,
 #endif
 	return 0;
 }
-EXPORT_SYMBOL_GPL(seq_open_net);
+
+static int seq_release_net(struct inode *ino, struct file *f)
+{
+	struct seq_file *seq = f->private_data;
+
+	put_net(seq_file_net(seq));
+	seq_release_private(ino, f);
+	return 0;
+}
+
+static const struct file_operations proc_net_seq_fops = {
+	.open		= seq_open_net,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_net,
+};
+
+struct proc_dir_entry *proc_create_net_data(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, const struct seq_operations *ops,
+		unsigned int state_size, void *data)
+{
+	struct proc_dir_entry *p;
+
+	p = proc_create_reg(name, mode, &parent, data);
+	if (!p)
+		return NULL;
+	p->proc_fops = &proc_net_seq_fops;
+	p->seq_ops = ops;
+	p->state_size = state_size;
+	return proc_register(parent, p);
+}
+EXPORT_SYMBOL_GPL(proc_create_net_data);
 
 int single_open_net(struct inode *inode, struct file *file,
 		int (*show)(struct seq_file *, void *))
@@ -86,18 +117,6 @@ int single_open_net(struct inode *inode, struct file *file,
 }
 EXPORT_SYMBOL_GPL(single_open_net);
 
-int seq_release_net(struct inode *ino, struct file *f)
-{
-	struct seq_file *seq;
-
-	seq = f->private_data;
-
-	put_net(seq_file_net(seq));
-	seq_release_private(ino, f);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(seq_release_net);
-
 int single_release_net(struct inode *ino, struct file *f)
 {
 	struct seq_file *seq = f->private_data;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 8e7230e76f1c..ae2f849776ec 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -53,6 +53,12 @@ extern void proc_remove(struct proc_dir_entry *);
 extern void remove_proc_entry(const char *, struct proc_dir_entry *);
 extern int remove_proc_subtree(const char *, struct proc_dir_entry *);
 
+struct proc_dir_entry *proc_create_net_data(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, const struct seq_operations *ops,
+		unsigned int state_size, void *data);
+#define proc_create_net(name, mode, parent, state_size, ops) \
+	proc_create_net_data(name, mode, parent, state_size, ops, NULL)
+
 #else /* CONFIG_PROC_FS */
 
 static inline void proc_root_init(void)
@@ -89,6 +95,9 @@ static inline void proc_remove(struct proc_dir_entry *de) {}
 #define remove_proc_entry(name, parent) do {} while (0)
 static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *parent) { return 0; }
 
+#define proc_create_net_data(name, mode, parent, ops, state_size, data) ({NULL;})
+#define proc_create_net(name, mode, parent, state_size, ops) ({NULL;})
+
 #endif /* CONFIG_PROC_FS */
 
 struct net;
diff --git a/include/linux/seq_file_net.h b/include/linux/seq_file_net.h
index ed20faa99e05..5ea18a16291a 100644
--- a/include/linux/seq_file_net.h
+++ b/include/linux/seq_file_net.h
@@ -13,11 +13,8 @@ struct seq_net_private {
 #endif
 };
 
-int seq_open_net(struct inode *, struct file *,
-		 const struct seq_operations *, int);
 int single_open_net(struct inode *, struct file *file,
 		int (*show)(struct seq_file *, void *));
-int seq_release_net(struct inode *, struct file *);
 int single_release_net(struct inode *, struct file *);
 static inline struct net *seq_file_net(struct seq_file *seq)
 {
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 5e86fd9dc857..0e79c3408569 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -394,7 +394,15 @@ void fib6_gc_cleanup(void);
 
 int fib6_init(void);
 
-int ipv6_route_open(struct inode *inode, struct file *file);
+struct ipv6_route_iter {
+	struct seq_net_private p;
+	struct fib6_walker w;
+	loff_t skip;
+	struct fib6_table *tbl;
+	int sernum;
+};
+
+extern const struct seq_operations ipv6_route_seq_ops;
 
 int call_fib6_notifier(struct notifier_block *nb, struct net *net,
 		       enum fib_event_type event_type,
diff --git a/include/net/phonet/pn_dev.h b/include/net/phonet/pn_dev.h
index 8639de5750f6..cbee32be1d9c 100644
--- a/include/net/phonet/pn_dev.h
+++ b/include/net/phonet/pn_dev.h
@@ -56,7 +56,7 @@ struct net_device *phonet_route_output(struct net *net, u8 daddr);
 
 #define PN_NO_ADDR	0xff
 
-extern const struct file_operations pn_sock_seq_fops;
-extern const struct file_operations pn_res_seq_fops;
+extern const struct seq_operations pn_sock_seq_ops;
+extern const struct seq_operations pn_res_seq_ops;
 
 #endif
diff --git a/include/net/udp.h b/include/net/udp.h
index 093cd323f66a..621778b80e3d 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -423,8 +423,8 @@ void *udp_seq_start(struct seq_file *seq, loff_t *pos);
 void *udp_seq_next(struct seq_file *seq, void *v, loff_t *pos);
 void udp_seq_stop(struct seq_file *seq, void *v);
 
-extern const struct file_operations udp_afinfo_seq_fops;
-extern const struct file_operations udp6_afinfo_seq_fops;
+extern const struct seq_operations udp_seq_ops;
+extern const struct seq_operations udp6_seq_ops;
 
 int udp4_proc_init(void);
 void udp4_proc_exit(void);
diff --git a/net/8021q/vlanproc.c b/net/8021q/vlanproc.c
index d3e3f0f2ec1c..d36e8c4b7f56 100644
--- a/net/8021q/vlanproc.c
+++ b/net/8021q/vlanproc.c
@@ -73,19 +73,6 @@ static const struct seq_operations vlan_seq_ops = {
 	.show = vlan_seq_show,
 };
 
-static int vlan_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &vlan_seq_ops,
-			sizeof(struct seq_net_private));
-}
-
-static const struct file_operations vlan_fops = {
-	.open    = vlan_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
 /*
  * Proc filesystem directory entries.
  */
@@ -132,8 +119,9 @@ int __net_init vlan_proc_init(struct net *net)
 	if (!vn->proc_vlan_dir)
 		goto err;
 
-	vn->proc_vlan_conf = proc_create(name_conf, S_IFREG | 0600,
-					 vn->proc_vlan_dir, &vlan_fops);
+	vn->proc_vlan_conf = proc_create_net(name_conf, S_IFREG | 0600,
+			vn->proc_vlan_dir, &vlan_seq_ops,
+			sizeof(struct seq_net_private));
 	if (!vn->proc_vlan_conf)
 		goto err;
 	return 0;
diff --git a/net/atm/clip.c b/net/atm/clip.c
index f07dbc632222..66caa48a27c2 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -863,20 +863,6 @@ static const struct seq_operations arp_seq_ops = {
 	.stop	= neigh_seq_stop,
 	.show	= clip_seq_show,
 };
-
-static int arp_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &arp_seq_ops,
-			    sizeof(struct clip_seq_state));
-}
-
-static const struct file_operations arp_seq_fops = {
-	.open		= arp_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-	.owner		= THIS_MODULE
-};
 #endif
 
 static void atm_clip_exit_noproc(void);
@@ -893,7 +879,8 @@ static int __init atm_clip_init(void)
 	{
 		struct proc_dir_entry *p;
 
-		p = proc_create("arp", 0444, atm_proc_root, &arp_seq_fops);
+		p = proc_create_net("arp", 0444, atm_proc_root, &arp_seq_ops,
+				sizeof(struct clip_seq_state));
 		if (!p) {
 			pr_err("Unable to initialize /proc/net/atm/arp\n");
 			atm_clip_exit_noproc();
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index c4e8ebe55e26..63881f72ef71 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -175,19 +175,6 @@ static const struct seq_operations dev_seq_ops = {
 	.show  = dev_seq_show,
 };
 
-static int dev_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &dev_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations dev_seq_fops = {
-	.open    = dev_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
 static const struct seq_operations softnet_seq_ops = {
 	.start = softnet_seq_start,
 	.next  = softnet_seq_next,
@@ -285,30 +272,18 @@ static const struct seq_operations ptype_seq_ops = {
 	.show  = ptype_seq_show,
 };
 
-static int ptype_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ptype_seq_ops,
-			sizeof(struct seq_net_private));
-}
-
-static const struct file_operations ptype_seq_fops = {
-	.open    = ptype_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
-
 static int __net_init dev_proc_net_init(struct net *net)
 {
 	int rc = -ENOMEM;
 
-	if (!proc_create("dev", 0444, net->proc_net, &dev_seq_fops))
+	if (!proc_create_net("dev", 0444, net->proc_net, &dev_seq_ops,
+			sizeof(struct seq_net_private)))
 		goto out;
 	if (!proc_create_seq("softnet_stat", 0444, net->proc_net,
 			 &softnet_seq_ops))
 		goto out_dev;
-	if (!proc_create("ptype", 0444, net->proc_net, &ptype_seq_fops))
+	if (!proc_create_net("ptype", 0444, net->proc_net, &ptype_seq_ops,
+			sizeof(struct seq_net_private)))
 		goto out_softnet;
 
 	if (wext_proc_init(net))
@@ -365,22 +340,10 @@ static const struct seq_operations dev_mc_seq_ops = {
 	.show  = dev_mc_seq_show,
 };
 
-static int dev_mc_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &dev_mc_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations dev_mc_seq_fops = {
-	.open    = dev_mc_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
 static int __net_init dev_mc_net_init(struct net *net)
 {
-	if (!proc_create("dev_mcast", 0, net->proc_net, &dev_mc_seq_fops))
+	if (!proc_create_net("dev_mcast", 0, net->proc_net, &dev_mc_seq_ops,
+			sizeof(struct seq_net_private)))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index 6444525f610c..835a22f94bc5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3439,22 +3439,10 @@ static const struct seq_operations proto_seq_ops = {
 	.show   = proto_seq_show,
 };
 
-static int proto_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &proto_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations proto_seq_fops = {
-	.open		= proto_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 static __net_init int proto_init_net(struct net *net)
 {
-	if (!proc_create("protocols", 0444, net->proc_net, &proto_seq_fops))
+	if (!proc_create_net("protocols", 0444, net->proc_net, &proto_seq_ops,
+			sizeof(struct seq_net_private)))
 		return -ENOMEM;
 
 	return 0;
diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index 13156165afa3..94b306f6d551 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -589,27 +589,13 @@ static const struct seq_operations dn_neigh_seq_ops = {
 	.stop  = neigh_seq_stop,
 	.show  = dn_neigh_seq_show,
 };
-
-static int dn_neigh_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &dn_neigh_seq_ops,
-			    sizeof(struct neigh_seq_state));
-}
-
-static const struct file_operations dn_neigh_seq_fops = {
-	.open		= dn_neigh_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 #endif
 
 void __init dn_neigh_init(void)
 {
 	neigh_table_init(NEIGH_DN_TABLE, &dn_neigh_table);
-	proc_create("decnet_neigh", 0444, init_net.proc_net,
-		    &dn_neigh_seq_fops);
+	proc_create_net("decnet_neigh", 0444, init_net.proc_net,
+			&dn_neigh_seq_ops, sizeof(struct neigh_seq_state));
 }
 
 void __exit dn_neigh_cleanup(void)
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index bf6c2d4d4fdc..e90c89ef8c08 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1418,23 +1418,12 @@ static const struct seq_operations arp_seq_ops = {
 	.show	= arp_seq_show,
 };
 
-static int arp_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &arp_seq_ops,
-			    sizeof(struct neigh_seq_state));
-}
-
-static const struct file_operations arp_seq_fops = {
-	.open           = arp_seq_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release	= seq_release_net,
-};
-
+/* ------------------------------------------------------------------------ */
 
 static int __net_init arp_net_init(struct net *net)
 {
-	if (!proc_create("arp", 0444, net->proc_net, &arp_seq_fops))
+	if (!proc_create_net("arp", 0444, net->proc_net, &arp_seq_ops,
+			sizeof(struct neigh_seq_state)))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 3dcffd3ce98c..3293f04b941d 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2533,19 +2533,6 @@ static const struct seq_operations fib_trie_seq_ops = {
 	.show   = fib_trie_seq_show,
 };
 
-static int fib_trie_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &fib_trie_seq_ops,
-			    sizeof(struct fib_trie_iter));
-}
-
-static const struct file_operations fib_trie_fops = {
-	.open   = fib_trie_seq_open,
-	.read   = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release_net,
-};
-
 struct fib_route_iter {
 	struct seq_net_private p;
 	struct fib_table *main_tb;
@@ -2726,29 +2713,18 @@ static const struct seq_operations fib_route_seq_ops = {
 	.show   = fib_route_seq_show,
 };
 
-static int fib_route_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &fib_route_seq_ops,
-			    sizeof(struct fib_route_iter));
-}
-
-static const struct file_operations fib_route_fops = {
-	.open   = fib_route_seq_open,
-	.read   = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release_net,
-};
-
 int __net_init fib_proc_init(struct net *net)
 {
-	if (!proc_create("fib_trie", 0444, net->proc_net, &fib_trie_fops))
+	if (!proc_create_net("fib_trie", 0444, net->proc_net, &fib_trie_seq_ops,
+			sizeof(struct fib_trie_iter)))
 		goto out1;
 
 	if (!proc_create("fib_triestat", 0444, net->proc_net,
 			 &fib_triestat_fops))
 		goto out2;
 
-	if (!proc_create("route", 0444, net->proc_net, &fib_route_fops))
+	if (!proc_create_net("route", 0444, net->proc_net, &fib_route_seq_ops,
+			sizeof(struct fib_route_iter)))
 		goto out3;
 
 	return 0;
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index b26a81a7de42..85b617b655bc 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2829,19 +2829,6 @@ static const struct seq_operations igmp_mc_seq_ops = {
 	.show	=	igmp_mc_seq_show,
 };
 
-static int igmp_mc_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &igmp_mc_seq_ops,
-			sizeof(struct igmp_mc_iter_state));
-}
-
-static const struct file_operations igmp_mc_seq_fops = {
-	.open		=	igmp_mc_seq_open,
-	.read		=	seq_read,
-	.llseek		=	seq_lseek,
-	.release	=	seq_release_net,
-};
-
 struct igmp_mcf_iter_state {
 	struct seq_net_private p;
 	struct net_device *dev;
@@ -2975,29 +2962,17 @@ static const struct seq_operations igmp_mcf_seq_ops = {
 	.show	=	igmp_mcf_seq_show,
 };
 
-static int igmp_mcf_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &igmp_mcf_seq_ops,
-			sizeof(struct igmp_mcf_iter_state));
-}
-
-static const struct file_operations igmp_mcf_seq_fops = {
-	.open		=	igmp_mcf_seq_open,
-	.read		=	seq_read,
-	.llseek		=	seq_lseek,
-	.release	=	seq_release_net,
-};
-
 static int __net_init igmp_net_init(struct net *net)
 {
 	struct proc_dir_entry *pde;
 	int err;
 
-	pde = proc_create("igmp", 0444, net->proc_net, &igmp_mc_seq_fops);
+	pde = proc_create_net("igmp", 0444, net->proc_net, &igmp_mc_seq_ops,
+			sizeof(struct igmp_mc_iter_state));
 	if (!pde)
 		goto out_igmp;
-	pde = proc_create("mcfilter", 0444, net->proc_net,
-			  &igmp_mcf_seq_fops);
+	pde = proc_create_net("mcfilter", 0444, net->proc_net,
+			&igmp_mcf_seq_ops, sizeof(struct igmp_mcf_iter_state));
 	if (!pde)
 		goto out_mcfilter;
 	err = inet_ctl_sock_create(&net->ipv4.mc_autojoin_sk, AF_INET,
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2fb4de3f7f66..37c4f885ff7b 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2828,19 +2828,6 @@ static const struct seq_operations ipmr_vif_seq_ops = {
 	.show  = ipmr_vif_seq_show,
 };
 
-static int ipmr_vif_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ipmr_vif_seq_ops,
-			    sizeof(struct mr_vif_iter));
-}
-
-static const struct file_operations ipmr_vif_fops = {
-	.open    = ipmr_vif_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
 static void *ipmr_mfc_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct net *net = seq_file_net(seq);
@@ -2900,19 +2887,6 @@ static const struct seq_operations ipmr_mfc_seq_ops = {
 	.stop  = mr_mfc_seq_stop,
 	.show  = ipmr_mfc_seq_show,
 };
-
-static int ipmr_mfc_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ipmr_mfc_seq_ops,
-			    sizeof(struct mr_mfc_iter));
-}
-
-static const struct file_operations ipmr_mfc_fops = {
-	.open    = ipmr_mfc_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
 #endif
 
 #ifdef CONFIG_IP_PIMSM_V2
@@ -2977,9 +2951,11 @@ static int __net_init ipmr_net_init(struct net *net)
 
 #ifdef CONFIG_PROC_FS
 	err = -ENOMEM;
-	if (!proc_create("ip_mr_vif", 0, net->proc_net, &ipmr_vif_fops))
+	if (!proc_create_net("ip_mr_vif", 0, net->proc_net, &ipmr_vif_seq_ops,
+			sizeof(struct mr_vif_iter)))
 		goto proc_vif_fail;
-	if (!proc_create("ip_mr_cache", 0, net->proc_net, &ipmr_mfc_fops))
+	if (!proc_create_net("ip_mr_cache", 0, net->proc_net, &ipmr_mfc_seq_ops,
+			sizeof(struct mr_mfc_iter)))
 		goto proc_cache_fail;
 #endif
 	return 0;
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 83170ebf5dfc..b5190bc35053 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -1154,22 +1154,10 @@ static const struct seq_operations ping_v4_seq_ops = {
 	.stop		= ping_seq_stop,
 };
 
-static int ping_v4_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ping_v4_seq_ops,
-			   sizeof(struct ping_iter_state));
-}
-
-const struct file_operations ping_v4_seq_fops = {
-	.open		= ping_v4_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 static int __net_init ping_v4_proc_init_net(struct net *net)
 {
-	if (!proc_create("icmp", 0444, net->proc_net, &ping_v4_seq_fops))
+	if (!proc_create_net("icmp", 0444, net->proc_net, &ping_v4_seq_ops,
+			sizeof(struct ping_iter_state)))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index ae57962b31e3..abb3c9490c55 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -1112,23 +1112,10 @@ static const struct seq_operations raw_seq_ops = {
 	.show  = raw_seq_show,
 };
 
-static int raw_v4_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &raw_seq_ops,
-			sizeof(struct raw_iter_state));
-}
-
-static const struct file_operations raw_seq_fops = {
-	.open	 = raw_v4_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_net,
-};
-
 static __net_init int raw_init_net(struct net *net)
 {
-	if (!proc_create_data("raw", 0444, net->proc_net, &raw_seq_fops,
-			&raw_v4_hashinfo))
+	if (!proc_create_net_data("raw", 0444, net->proc_net, &raw_seq_ops,
+			sizeof(struct raw_iter_state), &raw_v4_hashinfo))
 		return -ENOMEM;
 
 	return 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 645f259d0972..2c970626b398 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2350,27 +2350,14 @@ static const struct seq_operations tcp4_seq_ops = {
 	.stop		= tcp_seq_stop,
 };
 
-static int tcp_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &tcp4_seq_ops,
-			  sizeof(struct tcp_iter_state));
-}
-
-static const struct file_operations tcp_afinfo_seq_fops = {
-	.open    = tcp_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net
-};
-
 static struct tcp_seq_afinfo tcp4_seq_afinfo = {
 	.family		= AF_INET,
 };
 
 static int __net_init tcp4_proc_init_net(struct net *net)
 {
-	if (!proc_create_data("tcp", 0444, net->proc_net,
-			&tcp_afinfo_seq_fops, &tcp4_seq_afinfo))
+	if (!proc_create_net_data("tcp", 0444, net->proc_net, &tcp4_seq_ops,
+			sizeof(struct tcp_iter_state), &tcp4_seq_afinfo))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d48790ddb6cf..2f2c2e10c1a0 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2703,26 +2703,13 @@ int udp4_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations udp_seq_ops = {
+const struct seq_operations udp_seq_ops = {
 	.start		= udp_seq_start,
 	.next		= udp_seq_next,
 	.stop		= udp_seq_stop,
 	.show		= udp4_seq_show,
 };
-
-static int udp_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &udp_seq_ops,
-			sizeof(struct udp_iter_state));
-}
-
-const struct file_operations udp_afinfo_seq_fops = {
-	.open     = udp_seq_open,
-	.read     = seq_read,
-	.llseek   = seq_lseek,
-	.release  = seq_release_net
-};
-EXPORT_SYMBOL(udp_afinfo_seq_fops);
+EXPORT_SYMBOL(udp_seq_ops);
 
 static struct udp_seq_afinfo udp4_seq_afinfo = {
 	.family		= AF_INET,
@@ -2731,8 +2718,8 @@ static struct udp_seq_afinfo udp4_seq_afinfo = {
 
 static int __net_init udp4_proc_init_net(struct net *net)
 {
-	if (!proc_create_data("udp", 0444, net->proc_net, &udp_afinfo_seq_fops,
-			&udp4_seq_afinfo))
+	if (!proc_create_net_data("udp", 0444, net->proc_net, &udp_seq_ops,
+			sizeof(struct udp_iter_state), &udp4_seq_afinfo))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index 4a6e67bfbe0d..8545457752fb 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -81,8 +81,8 @@ static struct udp_seq_afinfo udplite4_seq_afinfo = {
 
 static int __net_init udplite4_proc_init_net(struct net *net)
 {
-	if (!proc_create_data("udplite", 0444, net->proc_net,
-			&udp_afinfo_seq_fops, &udplite4_seq_afinfo))
+	if (!proc_create_net_data("udplite", 0444, net->proc_net, &udp_seq_ops,
+			sizeof(struct udp_iter_state), &udplite4_seq_afinfo))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 78cef00c9596..1b5ea3379d9b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4254,22 +4254,10 @@ static const struct seq_operations if6_seq_ops = {
 	.stop	= if6_seq_stop,
 };
 
-static int if6_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &if6_seq_ops,
-			    sizeof(struct if6_iter_state));
-}
-
-static const struct file_operations if6_fops = {
-	.open		= if6_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 static int __net_init if6_proc_net_init(struct net *net)
 {
-	if (!proc_create("if_inet6", 0444, net->proc_net, &if6_fops))
+	if (!proc_create_net("if_inet6", 0444, net->proc_net, &if6_seq_ops,
+			sizeof(struct if6_iter_state)))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index bbcabbba9bd8..ebeaf47d5c8d 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -529,22 +529,10 @@ static const struct seq_operations ac6_seq_ops = {
 	.show	=	ac6_seq_show,
 };
 
-static int ac6_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ac6_seq_ops,
-			    sizeof(struct ac6_iter_state));
-}
-
-static const struct file_operations ac6_seq_fops = {
-	.open		=	ac6_seq_open,
-	.read		=	seq_read,
-	.llseek		=	seq_lseek,
-	.release	=	seq_release_net,
-};
-
 int __net_init ac6_proc_init(struct net *net)
 {
-	if (!proc_create("anycast6", 0444, net->proc_net, &ac6_seq_fops))
+	if (!proc_create_net("anycast6", 0444, net->proc_net, &ac6_seq_ops,
+			sizeof(struct ac6_iter_state)))
 		return -ENOMEM;
 
 	return 0;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index deab2db6692e..01372dd74e38 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2209,15 +2209,6 @@ void fib6_gc_cleanup(void)
 }
 
 #ifdef CONFIG_PROC_FS
-
-struct ipv6_route_iter {
-	struct seq_net_private p;
-	struct fib6_walker w;
-	loff_t skip;
-	struct fib6_table *tbl;
-	int sernum;
-};
-
 static int ipv6_route_seq_show(struct seq_file *seq, void *v)
 {
 	struct rt6_info *rt = v;
@@ -2383,17 +2374,10 @@ static void ipv6_route_seq_stop(struct seq_file *seq, void *v)
 	rcu_read_unlock_bh();
 }
 
-static const struct seq_operations ipv6_route_seq_ops = {
+const struct seq_operations ipv6_route_seq_ops = {
 	.start	= ipv6_route_seq_start,
 	.next	= ipv6_route_seq_next,
 	.stop	= ipv6_route_seq_stop,
 	.show	= ipv6_route_seq_show
 };
-
-int ipv6_route_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ipv6_route_seq_ops,
-			    sizeof(struct ipv6_route_iter));
-}
-
 #endif /* CONFIG_PROC_FS */
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index a9f221d45ef9..550c4b29b549 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -811,23 +811,10 @@ static const struct seq_operations ip6fl_seq_ops = {
 	.show	=	ip6fl_seq_show,
 };
 
-static int ip6fl_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ip6fl_seq_ops,
-			   sizeof(struct ip6fl_iter_state));
-}
-
-static const struct file_operations ip6fl_seq_fops = {
-	.open		=	ip6fl_seq_open,
-	.read		=	seq_read,
-	.llseek		=	seq_lseek,
-	.release	=	seq_release_net,
-};
-
 static int __net_init ip6_flowlabel_proc_init(struct net *net)
 {
-	if (!proc_create("ip6_flowlabel", 0444, net->proc_net,
-			 &ip6fl_seq_fops))
+	if (!proc_create_net("ip6_flowlabel", 0444, net->proc_net,
+			&ip6fl_seq_ops, sizeof(struct ip6fl_iter_state)))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 298fd8b6ed17..4a15529d33eb 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -439,19 +439,6 @@ static const struct seq_operations ip6mr_vif_seq_ops = {
 	.show  = ip6mr_vif_seq_show,
 };
 
-static int ip6mr_vif_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ip6mr_vif_seq_ops,
-			    sizeof(struct mr_vif_iter));
-}
-
-static const struct file_operations ip6mr_vif_fops = {
-	.open    = ip6mr_vif_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
 static void *ipmr_mfc_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct net *net = seq_file_net(seq);
@@ -512,19 +499,6 @@ static const struct seq_operations ipmr_mfc_seq_ops = {
 	.stop  = mr_mfc_seq_stop,
 	.show  = ipmr_mfc_seq_show,
 };
-
-static int ipmr_mfc_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ipmr_mfc_seq_ops,
-			    sizeof(struct mr_mfc_iter));
-}
-
-static const struct file_operations ip6mr_mfc_fops = {
-	.open    = ipmr_mfc_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
 #endif
 
 #ifdef CONFIG_IPV6_PIMSM_V2
@@ -1316,9 +1290,11 @@ static int __net_init ip6mr_net_init(struct net *net)
 
 #ifdef CONFIG_PROC_FS
 	err = -ENOMEM;
-	if (!proc_create("ip6_mr_vif", 0, net->proc_net, &ip6mr_vif_fops))
+	if (!proc_create_net("ip6_mr_vif", 0, net->proc_net, &ip6mr_vif_seq_ops,
+			sizeof(struct mr_vif_iter)))
 		goto proc_vif_fail;
-	if (!proc_create("ip6_mr_cache", 0, net->proc_net, &ip6mr_mfc_fops))
+	if (!proc_create_net("ip6_mr_cache", 0, net->proc_net, &ipmr_mfc_seq_ops,
+			sizeof(struct mr_mfc_iter)))
 		goto proc_cache_fail;
 #endif
 
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 793159d77d8a..975021df7c1c 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2749,19 +2749,6 @@ static const struct seq_operations igmp6_mc_seq_ops = {
 	.show	=	igmp6_mc_seq_show,
 };
 
-static int igmp6_mc_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &igmp6_mc_seq_ops,
-			    sizeof(struct igmp6_mc_iter_state));
-}
-
-static const struct file_operations igmp6_mc_seq_fops = {
-	.open		=	igmp6_mc_seq_open,
-	.read		=	seq_read,
-	.llseek		=	seq_lseek,
-	.release	=	seq_release_net,
-};
-
 struct igmp6_mcf_iter_state {
 	struct seq_net_private p;
 	struct net_device *dev;
@@ -2903,28 +2890,17 @@ static const struct seq_operations igmp6_mcf_seq_ops = {
 	.show	=	igmp6_mcf_seq_show,
 };
 
-static int igmp6_mcf_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &igmp6_mcf_seq_ops,
-			    sizeof(struct igmp6_mcf_iter_state));
-}
-
-static const struct file_operations igmp6_mcf_seq_fops = {
-	.open		=	igmp6_mcf_seq_open,
-	.read		=	seq_read,
-	.llseek		=	seq_lseek,
-	.release	=	seq_release_net,
-};
-
 static int __net_init igmp6_proc_init(struct net *net)
 {
 	int err;
 
 	err = -ENOMEM;
-	if (!proc_create("igmp6", 0444, net->proc_net, &igmp6_mc_seq_fops))
+	if (!proc_create_net("igmp6", 0444, net->proc_net, &igmp6_mc_seq_ops,
+			sizeof(struct igmp6_mc_iter_state)))
 		goto out;
-	if (!proc_create("mcfilter6", 0444, net->proc_net,
-			 &igmp6_mcf_seq_fops))
+	if (!proc_create_net("mcfilter6", 0444, net->proc_net,
+			&igmp6_mcf_seq_ops,
+			sizeof(struct igmp6_mcf_iter_state)))
 		goto out_proc_net_igmp6;
 
 	err = 0;
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 45d5c8e0f2bf..96f56bf49a30 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -223,22 +223,10 @@ static const struct seq_operations ping_v6_seq_ops = {
 	.stop		= ping_seq_stop,
 };
 
-static int ping_v6_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ping_v6_seq_ops,
-			   sizeof(struct ping_iter_state));
-}
-
-const struct file_operations ping_v6_seq_fops = {
-	.open		= ping_v6_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 static int __net_init ping_v6_proc_init_net(struct net *net)
 {
-	if (!proc_create("icmp6", 0444, net->proc_net, &ping_v6_seq_fops))
+	if (!proc_create_net("icmp6", 0444, net->proc_net, &ping_v6_seq_ops,
+			sizeof(struct ping_iter_state)))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index dade69bf61e6..afc307c89d1a 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1304,23 +1304,10 @@ static const struct seq_operations raw6_seq_ops = {
 	.show =		raw6_seq_show,
 };
 
-static int raw6_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &raw6_seq_ops,
-			sizeof(struct raw_iter_state));
-}
-
-static const struct file_operations raw6_seq_fops = {
-	.open =		raw6_seq_open,
-	.read =		seq_read,
-	.llseek =	seq_lseek,
-	.release =	seq_release_net,
-};
-
 static int __net_init raw6_init_net(struct net *net)
 {
-	if (!proc_create_data("raw6", 0444, net->proc_net, &raw6_seq_fops,
-			&raw_v6_hashinfo))
+	if (!proc_create_net_data("raw6", 0444, net->proc_net, &raw6_seq_ops,
+			sizeof(struct raw_iter_state), &raw_v6_hashinfo))
 		return -ENOMEM;
 
 	return 0;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 49b954d6d0fa..07c4aafe7710 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4855,14 +4855,6 @@ static int ip6_route_dev_notify(struct notifier_block *this,
  */
 
 #ifdef CONFIG_PROC_FS
-
-static const struct file_operations ipv6_route_proc_fops = {
-	.open		= ipv6_route_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 static int rt6_stats_seq_show(struct seq_file *seq, void *v)
 {
 	struct net *net = (struct net *)seq->private;
@@ -5093,7 +5085,8 @@ static void __net_exit ip6_route_net_exit(struct net *net)
 static int __net_init ip6_route_net_init_late(struct net *net)
 {
 #ifdef CONFIG_PROC_FS
-	proc_create("ipv6_route", 0, net->proc_net, &ipv6_route_proc_fops);
+	proc_create_net("ipv6_route", 0, net->proc_net, &ipv6_route_seq_ops,
+			sizeof(struct ipv6_route_iter));
 	proc_create("rt6_stats", 0444, net->proc_net, &rt6_stats_seq_fops);
 #endif
 	return 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c0329bb1692f..d2ce66b23430 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1916,27 +1916,14 @@ static const struct seq_operations tcp6_seq_ops = {
 	.stop		= tcp_seq_stop,
 };
 
-static int tcp6_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &tcp6_seq_ops,
-			  sizeof(struct tcp_iter_state));
-}
-
-static const struct file_operations tcp6_afinfo_seq_fops = {
-	.open    = tcp6_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net
-};
-
 static struct tcp_seq_afinfo tcp6_seq_afinfo = {
 	.family		= AF_INET6,
 };
 
 int __net_init tcp6_proc_init(struct net *net)
 {
-	if (!proc_create_data("tcp6", 0444, net->proc_net,
-			&tcp6_afinfo_seq_fops, &tcp6_seq_afinfo))
+	if (!proc_create_net_data("tcp6", 0444, net->proc_net, &tcp6_seq_ops,
+			sizeof(struct tcp_iter_state), &tcp6_seq_afinfo))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 68f11d6e3912..3ca8a6ed1794 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1480,26 +1480,13 @@ int udp6_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations udp6_seq_ops = {
+const struct seq_operations udp6_seq_ops = {
 	.start		= udp_seq_start,
 	.next		= udp_seq_next,
 	.stop		= udp_seq_stop,
 	.show		= udp6_seq_show,
 };
-
-static int udp6_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &udp6_seq_ops,
-			sizeof(struct udp_iter_state));
-}
-
-const struct file_operations udp6_afinfo_seq_fops = {
-	.open     = udp6_seq_open,
-	.read     = seq_read,
-	.llseek   = seq_lseek,
-	.release  = seq_release_net
-};
-EXPORT_SYMBOL(udp6_afinfo_seq_fops);
+EXPORT_SYMBOL(udp6_seq_ops);
 
 static struct udp_seq_afinfo udp6_seq_afinfo = {
 	.family		= AF_INET6,
@@ -1508,8 +1495,8 @@ static struct udp_seq_afinfo udp6_seq_afinfo = {
 
 int __net_init udp6_proc_init(struct net *net)
 {
-	if (!proc_create_data("udp6", 0444, net->proc_net,
-			&udp6_afinfo_seq_fops, &udp6_seq_afinfo))
+	if (!proc_create_net_data("udp6", 0444, net->proc_net, &udp6_seq_ops,
+			sizeof(struct udp_iter_state), &udp6_seq_afinfo))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index a119e57196b5..5000ad6878e6 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -100,8 +100,9 @@ static struct udp_seq_afinfo udplite6_seq_afinfo = {
 
 static int __net_init udplite6_proc_init_net(struct net *net)
 {
-	if (!proc_create_data("udplite6", 0444, net->proc_net,
-			&udp6_afinfo_seq_fops, &udplite6_seq_afinfo))
+	if (!proc_create_net_data("udplite6", 0444, net->proc_net,
+			&udp6_seq_ops, sizeof(struct udp_iter_state),
+			&udplite6_seq_afinfo))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/kcm/kcmproc.c b/net/kcm/kcmproc.c
index 6d0667e62baf..6283ed2f43b2 100644
--- a/net/kcm/kcmproc.c
+++ b/net/kcm/kcmproc.c
@@ -239,19 +239,6 @@ static const struct seq_operations kcm_seq_ops = {
 	.stop	= kcm_seq_stop,
 };
 
-static int kcm_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &kcm_seq_ops,
-			   sizeof(struct kcm_proc_mux_state));
-}
-
-static const struct file_operations kcm_seq_fops = {
-	.open		= kcm_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 static int kcm_stats_seq_show(struct seq_file *seq, void *v)
 {
 	struct kcm_psock_stats psock_stats;
@@ -376,7 +363,8 @@ static int kcm_proc_init_net(struct net *net)
 			 &kcm_stats_seq_fops))
 		goto out_kcm_stats;
 
-	if (!proc_create("kcm", 0444, net->proc_net, &kcm_seq_fops))
+	if (!proc_create_net("kcm", 0444, net->proc_net, &kcm_seq_ops,
+			sizeof(struct kcm_proc_mux_state)))
 		goto out_kcm;
 
 	return 0;
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 7e2e7188e7f4..3f7480a3d20a 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3787,24 +3787,12 @@ static const struct seq_operations pfkey_seq_ops = {
 	.show	= pfkey_seq_show,
 };
 
-static int pfkey_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &pfkey_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations pfkey_proc_ops = {
-	.open	 = pfkey_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_net,
-};
-
 static int __net_init pfkey_init_proc(struct net *net)
 {
 	struct proc_dir_entry *e;
 
-	e = proc_create("pfkey", 0, net->proc_net, &pfkey_proc_ops);
+	e = proc_create_net("pfkey", 0, net->proc_net, &pfkey_seq_ops,
+			sizeof(struct seq_net_private));
 	if (e == NULL)
 		return -ENOMEM;
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 7d0c963680e6..802e11bdb3f9 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1732,24 +1732,6 @@ static const struct seq_operations pppol2tp_seq_ops = {
 	.stop		= pppol2tp_seq_stop,
 	.show		= pppol2tp_seq_show,
 };
-
-/* Called when our /proc file is opened. We allocate data for use when
- * iterating our tunnel / session contexts and store it in the private
- * data of the seq_file.
- */
-static int pppol2tp_proc_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &pppol2tp_seq_ops,
-			    sizeof(struct pppol2tp_seq_data));
-}
-
-static const struct file_operations pppol2tp_proc_fops = {
-	.open		= pppol2tp_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 #endif /* CONFIG_PROC_FS */
 
 /*****************************************************************************
@@ -1761,8 +1743,8 @@ static __net_init int pppol2tp_init_net(struct net *net)
 	struct proc_dir_entry *pde;
 	int err = 0;
 
-	pde = proc_create("pppol2tp", 0444, net->proc_net,
-			  &pppol2tp_proc_fops);
+	pde = proc_create_net("pppol2tp", 0444, net->proc_net,
+			&pppol2tp_seq_ops, sizeof(struct pppol2tp_seq_data));
 	if (!pde) {
 		err = -ENOMEM;
 		goto out;
diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 1c98c907bc63..c3db074fc1f7 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -587,25 +587,13 @@ static const struct seq_operations ip_vs_app_seq_ops = {
 	.stop  = ip_vs_app_seq_stop,
 	.show  = ip_vs_app_seq_show,
 };
-
-static int ip_vs_app_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ip_vs_app_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations ip_vs_app_fops = {
-	.open	 = ip_vs_app_open,
-	.read	 = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
 #endif
 
 int __net_init ip_vs_app_net_init(struct netns_ipvs *ipvs)
 {
 	INIT_LIST_HEAD(&ipvs->app_list);
-	proc_create("ip_vs_app", 0, ipvs->net->proc_net, &ip_vs_app_fops);
+	proc_create_net("ip_vs_app", 0, ipvs->net->proc_net, &ip_vs_app_seq_ops,
+			sizeof(struct seq_net_private));
 	return 0;
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 370abbf6f421..2dde148f97b5 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1136,19 +1136,6 @@ static const struct seq_operations ip_vs_conn_seq_ops = {
 	.show  = ip_vs_conn_seq_show,
 };
 
-static int ip_vs_conn_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ip_vs_conn_seq_ops,
-			    sizeof(struct ip_vs_iter_state));
-}
-
-static const struct file_operations ip_vs_conn_fops = {
-	.open    = ip_vs_conn_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
 static const char *ip_vs_origin_name(unsigned int flags)
 {
 	if (flags & IP_VS_CONN_F_SYNC)
@@ -1212,20 +1199,6 @@ static const struct seq_operations ip_vs_conn_sync_seq_ops = {
 	.stop  = ip_vs_conn_seq_stop,
 	.show  = ip_vs_conn_sync_seq_show,
 };
-
-static int ip_vs_conn_sync_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ip_vs_conn_sync_seq_ops,
-			    sizeof(struct ip_vs_iter_state));
-}
-
-static const struct file_operations ip_vs_conn_sync_fops = {
-	.open    = ip_vs_conn_sync_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
 #endif
 
 
@@ -1385,9 +1358,11 @@ int __net_init ip_vs_conn_net_init(struct netns_ipvs *ipvs)
 {
 	atomic_set(&ipvs->conn_count, 0);
 
-	proc_create("ip_vs_conn", 0, ipvs->net->proc_net, &ip_vs_conn_fops);
-	proc_create("ip_vs_conn_sync", 0, ipvs->net->proc_net,
-		    &ip_vs_conn_sync_fops);
+	proc_create_net("ip_vs_conn", 0, ipvs->net->proc_net,
+			&ip_vs_conn_seq_ops, sizeof(struct ip_vs_iter_state));
+	proc_create_net("ip_vs_conn_sync", 0, ipvs->net->proc_net,
+			&ip_vs_conn_sync_seq_ops,
+			sizeof(struct ip_vs_iter_state));
 	return 0;
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 5ebde4b15810..5d7abe11ccb5 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2109,19 +2109,6 @@ static const struct seq_operations ip_vs_info_seq_ops = {
 	.show  = ip_vs_info_seq_show,
 };
 
-static int ip_vs_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ip_vs_info_seq_ops,
-			sizeof(struct ip_vs_iter));
-}
-
-static const struct file_operations ip_vs_info_fops = {
-	.open    = ip_vs_info_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
 static int ip_vs_stats_show(struct seq_file *seq, void *v)
 {
 	struct net *net = seq_file_single_net(seq);
@@ -4038,7 +4025,8 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 
 	spin_lock_init(&ipvs->tot_stats.lock);
 
-	proc_create("ip_vs", 0, ipvs->net->proc_net, &ip_vs_info_fops);
+	proc_create_net("ip_vs", 0, ipvs->net->proc_net, &ip_vs_info_seq_ops,
+			sizeof(struct ip_vs_iter));
 	proc_create("ip_vs_stats", 0, ipvs->net->proc_net, &ip_vs_stats_fops);
 	proc_create("ip_vs_stats_percpu", 0, ipvs->net->proc_net,
 		    &ip_vs_stats_percpu_fops);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 8ef21d9f9a00..3ba5aaa851e8 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -641,19 +641,6 @@ static const struct seq_operations exp_seq_ops = {
 	.stop = exp_seq_stop,
 	.show = exp_seq_show
 };
-
-static int exp_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &exp_seq_ops,
-			sizeof(struct ct_expect_iter_state));
-}
-
-static const struct file_operations exp_file_ops = {
-	.open    = exp_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
 #endif /* CONFIG_NF_CONNTRACK_PROCFS */
 
 static int exp_proc_init(struct net *net)
@@ -663,8 +650,8 @@ static int exp_proc_init(struct net *net)
 	kuid_t root_uid;
 	kgid_t root_gid;
 
-	proc = proc_create("nf_conntrack_expect", 0440, net->proc_net,
-			   &exp_file_ops);
+	proc = proc_create_net("nf_conntrack_expect", 0440, net->proc_net,
+			&exp_seq_ops, sizeof(struct ct_expect_iter_state));
 	if (!proc)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 037fec54c850..b642c0b2495c 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -375,19 +375,6 @@ static const struct seq_operations ct_seq_ops = {
 	.show  = ct_seq_show
 };
 
-static int ct_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ct_seq_ops,
-			sizeof(struct ct_iter_state));
-}
-
-static const struct file_operations ct_file_ops = {
-	.open    = ct_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
 static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct net *net = seq_file_net(seq);
@@ -467,26 +454,14 @@ static const struct seq_operations ct_cpu_seq_ops = {
 	.show	= ct_cpu_seq_show,
 };
 
-static int ct_cpu_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &ct_cpu_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations ct_cpu_seq_fops = {
-	.open	 = ct_cpu_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_net,
-};
-
 static int nf_conntrack_standalone_init_proc(struct net *net)
 {
 	struct proc_dir_entry *pde;
 	kuid_t root_uid;
 	kgid_t root_gid;
 
-	pde = proc_create("nf_conntrack", 0440, net->proc_net, &ct_file_ops);
+	pde = proc_create_net("nf_conntrack", 0440, net->proc_net, &ct_seq_ops,
+			sizeof(struct ct_iter_state));
 	if (!pde)
 		goto out_nf_conntrack;
 
@@ -495,8 +470,8 @@ static int nf_conntrack_standalone_init_proc(struct net *net)
 	if (uid_valid(root_uid) && gid_valid(root_gid))
 		proc_set_user(pde, root_uid, root_gid);
 
-	pde = proc_create("nf_conntrack", 0444, net->proc_net_stat,
-			  &ct_cpu_seq_fops);
+	pde = proc_create_net("nf_conntrack", 0444, net->proc_net_stat,
+			&ct_cpu_seq_ops, sizeof(struct seq_net_private));
 	if (!pde)
 		goto out_stat_nf_conntrack;
 	return 0;
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 6d0357817cda..426457047578 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -394,21 +394,6 @@ static const struct seq_operations nflog_seq_ops = {
 	.stop	= seq_stop,
 	.show	= seq_show,
 };
-
-static int nflog_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &nflog_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations nflog_file_ops = {
-	.open	 = nflog_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_net,
-};
-
-
 #endif /* PROC_FS */
 
 #ifdef CONFIG_SYSCTL
@@ -549,8 +534,8 @@ static int __net_init nf_log_net_init(struct net *net)
 	int ret = -ENOMEM;
 
 #ifdef CONFIG_PROC_FS
-	if (!proc_create("nf_log", 0444,
-			 net->nf.proc_netfilter, &nflog_file_ops))
+	if (!proc_create_net("nf_log", 0444, net->nf.proc_netfilter,
+			&nflog_seq_ops, sizeof(struct seq_net_private)))
 		return ret;
 #endif
 	ret = netfilter_log_sysctl_init(net);
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 6039b350abbe..8ff4d22f10b2 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -310,23 +310,10 @@ static const struct seq_operations synproxy_cpu_seq_ops = {
 	.show		= synproxy_cpu_seq_show,
 };
 
-static int synproxy_cpu_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &synproxy_cpu_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations synproxy_cpu_seq_fops = {
-	.open		= synproxy_cpu_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 static int __net_init synproxy_proc_init(struct net *net)
 {
-	if (!proc_create("synproxy", 0444, net->proc_net_stat,
-			 &synproxy_cpu_seq_fops))
+	if (!proc_create_net("synproxy", 0444, net->proc_net_stat,
+			&synproxy_cpu_seq_ops, sizeof(struct seq_net_private)))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 7b46aa4c478d..c14822b9729f 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1046,20 +1046,6 @@ static const struct seq_operations nful_seq_ops = {
 	.stop	= seq_stop,
 	.show	= seq_show,
 };
-
-static int nful_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &nful_seq_ops,
-			    sizeof(struct iter_state));
-}
-
-static const struct file_operations nful_file_ops = {
-	.open	 = nful_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_net,
-};
-
 #endif /* PROC_FS */
 
 static int __net_init nfnl_log_net_init(struct net *net)
@@ -1077,8 +1063,8 @@ static int __net_init nfnl_log_net_init(struct net *net)
 	spin_lock_init(&log->instances_lock);
 
 #ifdef CONFIG_PROC_FS
-	proc = proc_create("nfnetlink_log", 0440,
-			   net->nf.proc_netfilter, &nful_file_ops);
+	proc = proc_create_net("nfnetlink_log", 0440, net->nf.proc_netfilter,
+			&nful_seq_ops, sizeof(struct iter_state));
 	if (!proc)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 74a04638ef03..494a9ab35cb6 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1469,20 +1469,6 @@ static const struct seq_operations nfqnl_seq_ops = {
 	.stop	= seq_stop,
 	.show	= seq_show,
 };
-
-static int nfqnl_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &nfqnl_seq_ops,
-			sizeof(struct iter_state));
-}
-
-static const struct file_operations nfqnl_file_ops = {
-	.open	 = nfqnl_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_net,
-};
-
 #endif /* PROC_FS */
 
 static int __net_init nfnl_queue_net_init(struct net *net)
@@ -1496,8 +1482,8 @@ static int __net_init nfnl_queue_net_init(struct net *net)
 	spin_lock_init(&q->instances_lock);
 
 #ifdef CONFIG_PROC_FS
-	if (!proc_create("nfnetlink_queue", 0440,
-			 net->nf.proc_netfilter, &nfqnl_file_ops))
+	if (!proc_create_net("nfnetlink_queue", 0440, net->nf.proc_netfilter,
+			&nfqnl_seq_ops, sizeof(struct iter_state)))
 		return -ENOMEM;
 #endif
 	nf_register_queue_handler(net, &nfqh);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 3704101af27f..344dd01a5027 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1529,19 +1529,6 @@ static const struct seq_operations xt_table_seq_ops = {
 	.show	= xt_table_seq_show,
 };
 
-static int xt_table_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &xt_table_seq_ops,
-			sizeof(struct seq_net_private));
-}
-
-static const struct file_operations xt_table_ops = {
-	.open	 = xt_table_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_net,
-};
-
 /*
  * Traverse state for ip{,6}_{tables,matches} for helping crossing
  * the multi-AF mutexes.
@@ -1790,8 +1777,9 @@ int xt_proto_init(struct net *net, u_int8_t af)
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
-	proc = proc_create_data(buf, 0440, net->proc_net, &xt_table_ops,
-				(void *)(unsigned long)af);
+	proc = proc_create_net_data(buf, 0440, net->proc_net, &xt_table_seq_ops,
+			sizeof(struct seq_net_private),
+			(void *)(unsigned long)af);
 	if (!proc)
 		goto out;
 	if (uid_valid(root_uid) && gid_valid(root_gid))
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 55342c4d5cec..f7c9df6fa872 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2635,21 +2635,6 @@ static const struct seq_operations netlink_seq_ops = {
 	.stop   = netlink_seq_stop,
 	.show   = netlink_seq_show,
 };
-
-
-static int netlink_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &netlink_seq_ops,
-				sizeof(struct nl_seq_iter));
-}
-
-static const struct file_operations netlink_seq_fops = {
-	.open		= netlink_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 #endif
 
 int netlink_register_notifier(struct notifier_block *nb)
@@ -2694,7 +2679,8 @@ static const struct net_proto_family netlink_family_ops = {
 static int __net_init netlink_net_init(struct net *net)
 {
 #ifdef CONFIG_PROC_FS
-	if (!proc_create("netlink", 0, net->proc_net, &netlink_seq_fops))
+	if (!proc_create_net("netlink", 0, net->proc_net, &netlink_seq_ops,
+			sizeof(struct nl_seq_iter)))
 		return -ENOMEM;
 #endif
 	return 0;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c31b0687396a..fe9b9fe2e73f 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4526,20 +4526,6 @@ static const struct seq_operations packet_seq_ops = {
 	.stop	= packet_seq_stop,
 	.show	= packet_seq_show,
 };
-
-static int packet_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &packet_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations packet_seq_fops = {
-	.open		= packet_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 #endif
 
 static int __net_init packet_net_init(struct net *net)
@@ -4547,7 +4533,8 @@ static int __net_init packet_net_init(struct net *net)
 	mutex_init(&net->packet.sklist_lock);
 	INIT_HLIST_HEAD(&net->packet.sklist);
 
-	if (!proc_create("packet", 0, net->proc_net, &packet_seq_fops))
+	if (!proc_create_net("packet", 0, net->proc_net, &packet_seq_ops,
+			sizeof(struct seq_net_private)))
 		return -ENOMEM;
 
 	return 0;
diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index 77787512fc32..6cb4f602ab71 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -320,7 +320,8 @@ static int __net_init phonet_init_net(struct net *net)
 {
 	struct phonet_net *pnn = phonet_pernet(net);
 
-	if (!proc_create("phonet", 0, net->proc_net, &pn_sock_seq_fops))
+	if (!proc_create_net("phonet", 0, net->proc_net, &pn_sock_seq_ops,
+			sizeof(struct seq_net_private)))
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&pnn->pndevs.list);
@@ -351,7 +352,8 @@ int __init phonet_device_init(void)
 	if (err)
 		return err;
 
-	proc_create("pnresource", 0, init_net.proc_net, &pn_res_seq_fops);
+	proc_create_net("pnresource", 0, init_net.proc_net, &pn_res_seq_ops,
+			sizeof(struct seq_net_private));
 	register_netdevice_notifier(&phonet_device_notifier);
 	err = phonet_netlink_register();
 	if (err)
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index f9b40e6a18a5..30187990257f 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -620,25 +620,12 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations pn_sock_seq_ops = {
+const struct seq_operations pn_sock_seq_ops = {
 	.start = pn_sock_seq_start,
 	.next = pn_sock_seq_next,
 	.stop = pn_sock_seq_stop,
 	.show = pn_sock_seq_show,
 };
-
-static int pn_sock_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &pn_sock_seq_ops,
-				sizeof(struct seq_net_private));
-}
-
-const struct file_operations pn_sock_seq_fops = {
-	.open = pn_sock_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release_net,
-};
 #endif
 
 static struct  {
@@ -802,23 +789,10 @@ static int pn_res_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations pn_res_seq_ops = {
+const struct seq_operations pn_res_seq_ops = {
 	.start = pn_res_seq_start,
 	.next = pn_res_seq_next,
 	.stop = pn_res_seq_stop,
 	.show = pn_res_seq_show,
 };
-
-static int pn_res_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &pn_res_seq_ops,
-				sizeof(struct seq_net_private));
-}
-
-const struct file_operations pn_res_seq_fops = {
-	.open = pn_res_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release_net,
-};
 #endif
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 90d7079e0aa9..bbb86770318e 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1050,8 +1050,8 @@ void __rxrpc_queue_peer_error(struct rxrpc_peer *);
 /*
  * proc.c
  */
-extern const struct file_operations rxrpc_call_seq_fops;
-extern const struct file_operations rxrpc_connection_seq_fops;
+extern const struct seq_operations rxrpc_call_seq_ops;
+extern const struct seq_operations rxrpc_connection_seq_ops;
 
 /*
  * recvmsg.c
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index c7a023fb22d0..5d6a773db973 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -97,8 +97,11 @@ static __net_init int rxrpc_init_net(struct net *net)
 	if (!rxnet->proc_net)
 		goto err_proc;
 
-	proc_create("calls", 0444, rxnet->proc_net, &rxrpc_call_seq_fops);
-	proc_create("conns", 0444, rxnet->proc_net, &rxrpc_connection_seq_fops);
+	proc_create_net("calls", 0444, rxnet->proc_net, &rxrpc_call_seq_ops,
+			sizeof(struct seq_net_private));
+	proc_create_net("conns", 0444, rxnet->proc_net,
+			&rxrpc_connection_seq_ops,
+			sizeof(struct seq_net_private));
 	return 0;
 
 err_proc:
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 7e45db058823..d9fca8c4bcdc 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -115,26 +115,13 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations rxrpc_call_seq_ops = {
+const struct seq_operations rxrpc_call_seq_ops = {
 	.start  = rxrpc_call_seq_start,
 	.next   = rxrpc_call_seq_next,
 	.stop   = rxrpc_call_seq_stop,
 	.show   = rxrpc_call_seq_show,
 };
 
-static int rxrpc_call_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &rxrpc_call_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-const struct file_operations rxrpc_call_seq_fops = {
-	.open		= rxrpc_call_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 /*
  * generate a list of extant virtual connections in /proc/net/rxrpc_conns
  */
@@ -207,23 +194,9 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations rxrpc_connection_seq_ops = {
+const struct seq_operations rxrpc_connection_seq_ops = {
 	.start  = rxrpc_connection_seq_start,
 	.next   = rxrpc_connection_seq_next,
 	.stop   = rxrpc_connection_seq_stop,
 	.show   = rxrpc_connection_seq_show,
 };
-
-
-static int rxrpc_connection_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &rxrpc_connection_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-const struct file_operations rxrpc_connection_seq_fops = {
-	.open		= rxrpc_connection_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 1d9ccc6dab2b..009c185b71eb 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -225,21 +225,6 @@ static const struct seq_operations sctp_eps_ops = {
 	.show  = sctp_eps_seq_show,
 };
 
-
-/* Initialize the seq file operations for 'eps' object. */
-static int sctp_eps_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &sctp_eps_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations sctp_eps_seq_fops = {
-	.open	 = sctp_eps_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_net,
-};
-
 struct sctp_ht_iter {
 	struct seq_net_private p;
 	struct rhashtable_iter hti;
@@ -338,20 +323,6 @@ static const struct seq_operations sctp_assoc_ops = {
 	.show  = sctp_assocs_seq_show,
 };
 
-/* Initialize the seq file operations for 'assocs' object. */
-static int sctp_assocs_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &sctp_assoc_ops,
-			    sizeof(struct sctp_ht_iter));
-}
-
-static const struct file_operations sctp_assocs_seq_fops = {
-	.open	 = sctp_assocs_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_net,
-};
-
 static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
 {
 	struct sctp_association *assoc;
@@ -431,19 +402,6 @@ static const struct seq_operations sctp_remaddr_ops = {
 	.show  = sctp_remaddr_seq_show,
 };
 
-static int sctp_remaddr_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &sctp_remaddr_ops,
-			    sizeof(struct sctp_ht_iter));
-}
-
-static const struct file_operations sctp_remaddr_seq_fops = {
-	.open = sctp_remaddr_seq_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release_net,
-};
-
 /* Set up the proc fs entry for the SCTP protocol. */
 int __net_init sctp_proc_init(struct net *net)
 {
@@ -453,14 +411,14 @@ int __net_init sctp_proc_init(struct net *net)
 	if (!proc_create("snmp", 0444, net->sctp.proc_net_sctp,
 			 &sctp_snmp_seq_fops))
 		goto cleanup;
-	if (!proc_create("eps", 0444, net->sctp.proc_net_sctp,
-			 &sctp_eps_seq_fops))
+	if (!proc_create_net("eps", 0444, net->sctp.proc_net_sctp,
+			&sctp_eps_ops, sizeof(struct seq_net_private)))
 		goto cleanup;
-	if (!proc_create("assocs", 0444, net->sctp.proc_net_sctp,
-			 &sctp_assocs_seq_fops))
+	if (!proc_create_net("assocs", 0444, net->sctp.proc_net_sctp,
+			&sctp_assoc_ops, sizeof(struct sctp_ht_iter)))
 		goto cleanup;
-	if (!proc_create("remaddr", 0444, net->sctp.proc_net_sctp,
-			 &sctp_remaddr_seq_fops))
+	if (!proc_create_net("remaddr", 0444, net->sctp.proc_net_sctp,
+			&sctp_remaddr_ops, sizeof(struct sctp_ht_iter)))
 		goto cleanup;
 	return 0;
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 68bb70a62afe..e5473c03d667 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2852,20 +2852,6 @@ static const struct seq_operations unix_seq_ops = {
 	.stop   = unix_seq_stop,
 	.show   = unix_seq_show,
 };
-
-static int unix_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &unix_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations unix_seq_fops = {
-	.open		= unix_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
-};
-
 #endif
 
 static const struct net_proto_family unix_family_ops = {
@@ -2884,7 +2870,8 @@ static int __net_init unix_net_init(struct net *net)
 		goto out;
 
 #ifdef CONFIG_PROC_FS
-	if (!proc_create("unix", 0, net->proc_net, &unix_seq_fops)) {
+	if (!proc_create_net("unix", 0, net->proc_net, &unix_seq_ops,
+			sizeof(struct seq_net_private))) {
 		unix_sysctl_unregister(net);
 		goto out;
 	}
diff --git a/net/wireless/wext-proc.c b/net/wireless/wext-proc.c
index b4c464594a5e..cadcf8613af2 100644
--- a/net/wireless/wext-proc.c
+++ b/net/wireless/wext-proc.c
@@ -126,24 +126,11 @@ static const struct seq_operations wireless_seq_ops = {
 	.show  = wireless_dev_seq_show,
 };
 
-static int seq_open_wireless(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &wireless_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations wireless_seq_fops = {
-	.open    = seq_open_wireless,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
 int __net_init wext_proc_init(struct net *net)
 {
 	/* Create /proc/net/wireless entry */
-	if (!proc_create("wireless", 0444, net->proc_net,
-			 &wireless_seq_fops))
+	if (!proc_create_net("wireless", 0444, net->proc_net,
+			&wireless_seq_ops, sizeof(struct seq_net_private)))
 		return -ENOMEM;
 
 	return 0;
-- 
2.17.0
