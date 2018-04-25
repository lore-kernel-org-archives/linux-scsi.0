From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/40] ipv{4,6}/tcp: simplify procfs registration
Date: Wed, 25 Apr 2018 17:47:55 +0200
Message-ID: <20180425154827.32251-9-hch@lst.de>
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

Avoid most of the afinfo indirections and just call the proc helpers
directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/tcp.h   | 11 ++----
 net/ipv4/tcp_ipv4.c | 85 +++++++++++++++++----------------------------
 net/ipv6/tcp_ipv6.c | 27 +++++++++-----
 3 files changed, 53 insertions(+), 70 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9c9b3768b350..51dc7a26a2fa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1747,27 +1747,22 @@ enum tcp_seq_states {
 	TCP_SEQ_STATE_ESTABLISHED,
 };
 
-int tcp_seq_open(struct inode *inode, struct file *file);
+void *tcp_seq_start(struct seq_file *seq, loff_t *pos);
+void *tcp_seq_next(struct seq_file *seq, void *v, loff_t *pos);
+void tcp_seq_stop(struct seq_file *seq, void *v);
 
 struct tcp_seq_afinfo {
-	char				*name;
 	sa_family_t			family;
-	const struct file_operations	*seq_fops;
-	struct seq_operations		seq_ops;
 };
 
 struct tcp_iter_state {
 	struct seq_net_private	p;
-	sa_family_t		family;
 	enum tcp_seq_states	state;
 	struct sock		*syn_wait_sk;
 	int			bucket, offset, sbucket, num;
 	loff_t			last_pos;
 };
 
-int tcp_proc_register(struct net *net, struct tcp_seq_afinfo *afinfo);
-void tcp_proc_unregister(struct net *net, struct tcp_seq_afinfo *afinfo);
-
 extern struct request_sock_ops tcp_request_sock_ops;
 extern struct request_sock_ops tcp6_request_sock_ops;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f70586b50838..645f259d0972 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1961,6 +1961,7 @@ EXPORT_SYMBOL(tcp_v4_destroy_sock);
  */
 static void *listening_get_next(struct seq_file *seq, void *cur)
 {
+	struct tcp_seq_afinfo *afinfo = PDE_DATA(file_inode(seq->file));
 	struct tcp_iter_state *st = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct inet_listen_hashbucket *ilb;
@@ -1983,7 +1984,7 @@ static void *listening_get_next(struct seq_file *seq, void *cur)
 	sk_for_each_from(sk) {
 		if (!net_eq(sock_net(sk), net))
 			continue;
-		if (sk->sk_family == st->family)
+		if (sk->sk_family == afinfo->family)
 			return sk;
 	}
 	spin_unlock(&ilb->lock);
@@ -2020,6 +2021,7 @@ static inline bool empty_bucket(const struct tcp_iter_state *st)
  */
 static void *established_get_first(struct seq_file *seq)
 {
+	struct tcp_seq_afinfo *afinfo = PDE_DATA(file_inode(seq->file));
 	struct tcp_iter_state *st = seq->private;
 	struct net *net = seq_file_net(seq);
 	void *rc = NULL;
@@ -2036,7 +2038,7 @@ static void *established_get_first(struct seq_file *seq)
 
 		spin_lock_bh(lock);
 		sk_nulls_for_each(sk, node, &tcp_hashinfo.ehash[st->bucket].chain) {
-			if (sk->sk_family != st->family ||
+			if (sk->sk_family != afinfo->family ||
 			    !net_eq(sock_net(sk), net)) {
 				continue;
 			}
@@ -2051,6 +2053,7 @@ static void *established_get_first(struct seq_file *seq)
 
 static void *established_get_next(struct seq_file *seq, void *cur)
 {
+	struct tcp_seq_afinfo *afinfo = PDE_DATA(file_inode(seq->file));
 	struct sock *sk = cur;
 	struct hlist_nulls_node *node;
 	struct tcp_iter_state *st = seq->private;
@@ -2062,7 +2065,8 @@ static void *established_get_next(struct seq_file *seq, void *cur)
 	sk = sk_nulls_next(sk);
 
 	sk_nulls_for_each_from(sk, node) {
-		if (sk->sk_family == st->family && net_eq(sock_net(sk), net))
+		if (sk->sk_family == afinfo->family &&
+		    net_eq(sock_net(sk), net))
 			return sk;
 	}
 
@@ -2135,7 +2139,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 	return rc;
 }
 
-static void *tcp_seq_start(struct seq_file *seq, loff_t *pos)
+void *tcp_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct tcp_iter_state *st = seq->private;
 	void *rc;
@@ -2156,8 +2160,9 @@ static void *tcp_seq_start(struct seq_file *seq, loff_t *pos)
 	st->last_pos = *pos;
 	return rc;
 }
+EXPORT_SYMBOL(tcp_seq_start);
 
-static void *tcp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+void *tcp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct tcp_iter_state *st = seq->private;
 	void *rc = NULL;
@@ -2186,8 +2191,9 @@ static void *tcp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	st->last_pos = *pos;
 	return rc;
 }
+EXPORT_SYMBOL(tcp_seq_next);
 
-static void tcp_seq_stop(struct seq_file *seq, void *v)
+void tcp_seq_stop(struct seq_file *seq, void *v)
 {
 	struct tcp_iter_state *st = seq->private;
 
@@ -2202,47 +2208,7 @@ static void tcp_seq_stop(struct seq_file *seq, void *v)
 		break;
 	}
 }
-
-int tcp_seq_open(struct inode *inode, struct file *file)
-{
-	struct tcp_seq_afinfo *afinfo = PDE_DATA(inode);
-	struct tcp_iter_state *s;
-	int err;
-
-	err = seq_open_net(inode, file, &afinfo->seq_ops,
-			  sizeof(struct tcp_iter_state));
-	if (err < 0)
-		return err;
-
-	s = ((struct seq_file *)file->private_data)->private;
-	s->family		= afinfo->family;
-	s->last_pos		= 0;
-	return 0;
-}
-EXPORT_SYMBOL(tcp_seq_open);
-
-int tcp_proc_register(struct net *net, struct tcp_seq_afinfo *afinfo)
-{
-	int rc = 0;
-	struct proc_dir_entry *p;
-
-	afinfo->seq_ops.start		= tcp_seq_start;
-	afinfo->seq_ops.next		= tcp_seq_next;
-	afinfo->seq_ops.stop		= tcp_seq_stop;
-
-	p = proc_create_data(afinfo->name, 0444, net->proc_net,
-			     afinfo->seq_fops, afinfo);
-	if (!p)
-		rc = -ENOMEM;
-	return rc;
-}
-EXPORT_SYMBOL(tcp_proc_register);
-
-void tcp_proc_unregister(struct net *net, struct tcp_seq_afinfo *afinfo)
-{
-	remove_proc_entry(afinfo->name, net->proc_net);
-}
-EXPORT_SYMBOL(tcp_proc_unregister);
+EXPORT_SYMBOL(tcp_seq_stop);
 
 static void get_openreq4(const struct request_sock *req,
 			 struct seq_file *f, int i)
@@ -2377,6 +2343,19 @@ static int tcp4_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
+static const struct seq_operations tcp4_seq_ops = {
+	.show		= tcp4_seq_show,
+	.start		= tcp_seq_start,
+	.next		= tcp_seq_next,
+	.stop		= tcp_seq_stop,
+};
+
+static int tcp_seq_open(struct inode *inode, struct file *file)
+{
+	return seq_open_net(inode, file, &tcp4_seq_ops,
+			  sizeof(struct tcp_iter_state));
+}
+
 static const struct file_operations tcp_afinfo_seq_fops = {
 	.open    = tcp_seq_open,
 	.read    = seq_read,
@@ -2385,22 +2364,20 @@ static const struct file_operations tcp_afinfo_seq_fops = {
 };
 
 static struct tcp_seq_afinfo tcp4_seq_afinfo = {
-	.name		= "tcp",
 	.family		= AF_INET,
-	.seq_fops	= &tcp_afinfo_seq_fops,
-	.seq_ops	= {
-		.show		= tcp4_seq_show,
-	},
 };
 
 static int __net_init tcp4_proc_init_net(struct net *net)
 {
-	return tcp_proc_register(net, &tcp4_seq_afinfo);
+	if (!proc_create_data("tcp", 0444, net->proc_net,
+			&tcp_afinfo_seq_fops, &tcp4_seq_afinfo))
+		return -ENOMEM;
+	return 0;
 }
 
 static void __net_exit tcp4_proc_exit_net(struct net *net)
 {
-	tcp_proc_unregister(net, &tcp4_seq_afinfo);
+	remove_proc_entry("tcp", net->proc_net);
 }
 
 static struct pernet_operations tcp4_net_ops = {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 6d664d83cd16..c0329bb1692f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1909,30 +1909,41 @@ static int tcp6_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
+static const struct seq_operations tcp6_seq_ops = {
+	.show		= tcp6_seq_show,
+	.start		= tcp_seq_start,
+	.next		= tcp_seq_next,
+	.stop		= tcp_seq_stop,
+};
+
+static int tcp6_seq_open(struct inode *inode, struct file *file)
+{
+	return seq_open_net(inode, file, &tcp6_seq_ops,
+			  sizeof(struct tcp_iter_state));
+}
+
 static const struct file_operations tcp6_afinfo_seq_fops = {
-	.open    = tcp_seq_open,
+	.open    = tcp6_seq_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
 	.release = seq_release_net
 };
 
 static struct tcp_seq_afinfo tcp6_seq_afinfo = {
-	.name		= "tcp6",
 	.family		= AF_INET6,
-	.seq_fops	= &tcp6_afinfo_seq_fops,
-	.seq_ops	= {
-		.show		= tcp6_seq_show,
-	},
 };
 
 int __net_init tcp6_proc_init(struct net *net)
 {
-	return tcp_proc_register(net, &tcp6_seq_afinfo);
+	if (!proc_create_data("tcp6", 0444, net->proc_net,
+			&tcp6_afinfo_seq_fops, &tcp6_seq_afinfo))
+		return -ENOMEM;
+	return 0;
 }
 
 void tcp6_proc_exit(struct net *net)
 {
-	tcp_proc_unregister(net, &tcp6_seq_afinfo);
+	remove_proc_entry("tcp6", net->proc_net);
 }
 #endif
 
-- 
2.17.0
