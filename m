From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/39] =?UTF-8?q?ipv{4,6}/raw:=20simplify=20=D1=95eq=5Ffil?= =?UTF-8?q?e=20code?=
Date: Thu, 19 Apr 2018 14:41:09 +0200
Message-ID: <20180419124140.9309-9-hch@lst.de>
References: <20180419124140.9309-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180419124140.9309-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Corey Minyard <minyard@acm.org>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Pass the hashtable to the proc private data instead of copying
it into the per-file private data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/raw.h |  4 ----
 net/ipv4/raw.c    | 36 ++++++++++++------------------------
 net/ipv6/raw.c    |  6 ++++--
 3 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 99d26d0c4a19..9c9fa98a91a4 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -48,7 +48,6 @@ void raw_proc_exit(void);
 struct raw_iter_state {
 	struct seq_net_private p;
 	int bucket;
-	struct raw_hashinfo *h;
 };
 
 static inline struct raw_iter_state *raw_seq_private(struct seq_file *seq)
@@ -58,9 +57,6 @@ static inline struct raw_iter_state *raw_seq_private(struct seq_file *seq)
 void *raw_seq_start(struct seq_file *seq, loff_t *pos);
 void *raw_seq_next(struct seq_file *seq, void *v, loff_t *pos);
 void raw_seq_stop(struct seq_file *seq, void *v);
-int raw_seq_open(struct inode *ino, struct file *file,
-		 struct raw_hashinfo *h, const struct seq_operations *ops);
-
 #endif
 
 int raw_hash_sk(struct sock *sk);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 1b4d3355624a..ae57962b31e3 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -1003,11 +1003,12 @@ struct proto raw_prot = {
 static struct sock *raw_get_first(struct seq_file *seq)
 {
 	struct sock *sk;
+	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
 	struct raw_iter_state *state = raw_seq_private(seq);
 
 	for (state->bucket = 0; state->bucket < RAW_HTABLE_SIZE;
 			++state->bucket) {
-		sk_for_each(sk, &state->h->ht[state->bucket])
+		sk_for_each(sk, &h->ht[state->bucket])
 			if (sock_net(sk) == seq_file_net(seq))
 				goto found;
 	}
@@ -1018,6 +1019,7 @@ static struct sock *raw_get_first(struct seq_file *seq)
 
 static struct sock *raw_get_next(struct seq_file *seq, struct sock *sk)
 {
+	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
 	struct raw_iter_state *state = raw_seq_private(seq);
 
 	do {
@@ -1027,7 +1029,7 @@ static struct sock *raw_get_next(struct seq_file *seq, struct sock *sk)
 	} while (sk && sock_net(sk) != seq_file_net(seq));
 
 	if (!sk && ++state->bucket < RAW_HTABLE_SIZE) {
-		sk = sk_head(&state->h->ht[state->bucket]);
+		sk = sk_head(&h->ht[state->bucket]);
 		goto try_again;
 	}
 	return sk;
@@ -1045,9 +1047,9 @@ static struct sock *raw_get_idx(struct seq_file *seq, loff_t pos)
 
 void *raw_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct raw_iter_state *state = raw_seq_private(seq);
+	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
 
-	read_lock(&state->h->lock);
+	read_lock(&h->lock);
 	return *pos ? raw_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 }
 EXPORT_SYMBOL_GPL(raw_seq_start);
@@ -1067,9 +1069,9 @@ EXPORT_SYMBOL_GPL(raw_seq_next);
 
 void raw_seq_stop(struct seq_file *seq, void *v)
 {
-	struct raw_iter_state *state = raw_seq_private(seq);
+	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
 
-	read_unlock(&state->h->lock);
+	read_unlock(&h->lock);
 }
 EXPORT_SYMBOL_GPL(raw_seq_stop);
 
@@ -1110,25 +1112,10 @@ static const struct seq_operations raw_seq_ops = {
 	.show  = raw_seq_show,
 };
 
-int raw_seq_open(struct inode *ino, struct file *file,
-		 struct raw_hashinfo *h, const struct seq_operations *ops)
-{
-	int err;
-	struct raw_iter_state *i;
-
-	err = seq_open_net(ino, file, ops, sizeof(struct raw_iter_state));
-	if (err < 0)
-		return err;
-
-	i = raw_seq_private((struct seq_file *)file->private_data);
-	i->h = h;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(raw_seq_open);
-
 static int raw_v4_seq_open(struct inode *inode, struct file *file)
 {
-	return raw_seq_open(inode, file, &raw_v4_hashinfo, &raw_seq_ops);
+	return seq_open_net(inode, file, &raw_seq_ops,
+			sizeof(struct raw_iter_state));
 }
 
 static const struct file_operations raw_seq_fops = {
@@ -1140,7 +1127,8 @@ static const struct file_operations raw_seq_fops = {
 
 static __net_init int raw_init_net(struct net *net)
 {
-	if (!proc_create("raw", 0444, net->proc_net, &raw_seq_fops))
+	if (!proc_create_data("raw", 0444, net->proc_net, &raw_seq_fops,
+			&raw_v4_hashinfo))
 		return -ENOMEM;
 
 	return 0;
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 5eb9b08947ed..dade69bf61e6 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1306,7 +1306,8 @@ static const struct seq_operations raw6_seq_ops = {
 
 static int raw6_seq_open(struct inode *inode, struct file *file)
 {
-	return raw_seq_open(inode, file, &raw_v6_hashinfo, &raw6_seq_ops);
+	return seq_open_net(inode, file, &raw6_seq_ops,
+			sizeof(struct raw_iter_state));
 }
 
 static const struct file_operations raw6_seq_fops = {
@@ -1318,7 +1319,8 @@ static const struct file_operations raw6_seq_fops = {
 
 static int __net_init raw6_init_net(struct net *net)
 {
-	if (!proc_create("raw6", 0444, net->proc_net, &raw6_seq_fops))
+	if (!proc_create_data("raw6", 0444, net->proc_net, &raw6_seq_fops,
+			&raw_v6_hashinfo))
 		return -ENOMEM;
 
 	return 0;
-- 
2.17.0
