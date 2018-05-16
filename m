From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/42] =?UTF-8?q?netfilter/x=5Ftables:=20simplify=20=D1=95?=
 =?UTF-8?q?eq=5Ffile=20code?=
Date: Wed, 16 May 2018 11:43:19 +0200
Message-ID: <20180516094346.20506-16-hch@lst.de>
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

Just use the address family from the proc private data instead of copying
it into per-file data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/netfilter/x_tables.c | 39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 71325fef647d..3704101af27f 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1489,15 +1489,10 @@ void *xt_unregister_table(struct xt_table *table)
 EXPORT_SYMBOL_GPL(xt_unregister_table);
 
 #ifdef CONFIG_PROC_FS
-struct xt_names_priv {
-	struct seq_net_private p;
-	u_int8_t af;
-};
 static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct xt_names_priv *priv = seq->private;
 	struct net *net = seq_file_net(seq);
-	u_int8_t af = priv->af;
+	u_int8_t af = (unsigned long)PDE_DATA(file_inode(seq->file));
 
 	mutex_lock(&xt[af].mutex);
 	return seq_list_start(&net->xt.tables[af], *pos);
@@ -1505,17 +1500,15 @@ static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
 
 static void *xt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct xt_names_priv *priv = seq->private;
 	struct net *net = seq_file_net(seq);
-	u_int8_t af = priv->af;
+	u_int8_t af = (unsigned long)PDE_DATA(file_inode(seq->file));
 
 	return seq_list_next(v, &net->xt.tables[af], pos);
 }
 
 static void xt_table_seq_stop(struct seq_file *seq, void *v)
 {
-	struct xt_names_priv *priv = seq->private;
-	u_int8_t af = priv->af;
+	u_int8_t af = (unsigned long)PDE_DATA(file_inode(seq->file));
 
 	mutex_unlock(&xt[af].mutex);
 }
@@ -1538,16 +1531,8 @@ static const struct seq_operations xt_table_seq_ops = {
 
 static int xt_table_open(struct inode *inode, struct file *file)
 {
-	int ret;
-	struct xt_names_priv *priv;
-
-	ret = seq_open_net(inode, file, &xt_table_seq_ops,
-			   sizeof(struct xt_names_priv));
-	if (!ret) {
-		priv = ((struct seq_file *)file->private_data)->private;
-		priv->af = (unsigned long)PDE_DATA(inode);
-	}
-	return ret;
+	return seq_open_net(inode, file, &xt_table_seq_ops,
+			sizeof(struct seq_net_private));
 }
 
 static const struct file_operations xt_table_ops = {
@@ -1563,7 +1548,7 @@ static const struct file_operations xt_table_ops = {
  */
 struct nf_mttg_trav {
 	struct list_head *head, *curr;
-	uint8_t class, nfproto;
+	uint8_t class;
 };
 
 enum {
@@ -1580,6 +1565,7 @@ static void *xt_mttg_seq_next(struct seq_file *seq, void *v, loff_t *ppos,
 		[MTTG_TRAV_NFP_UNSPEC] = MTTG_TRAV_NFP_SPEC,
 		[MTTG_TRAV_NFP_SPEC]   = MTTG_TRAV_DONE,
 	};
+	uint8_t nfproto = (unsigned long)PDE_DATA(file_inode(seq->file));
 	struct nf_mttg_trav *trav = seq->private;
 
 	switch (trav->class) {
@@ -1594,9 +1580,9 @@ static void *xt_mttg_seq_next(struct seq_file *seq, void *v, loff_t *ppos,
 		if (trav->curr != trav->head)
 			break;
 		mutex_unlock(&xt[NFPROTO_UNSPEC].mutex);
-		mutex_lock(&xt[trav->nfproto].mutex);
+		mutex_lock(&xt[nfproto].mutex);
 		trav->head = trav->curr = is_target ?
-			&xt[trav->nfproto].target : &xt[trav->nfproto].match;
+			&xt[nfproto].target : &xt[nfproto].match;
 		trav->class = next_class[trav->class];
 		break;
 	case MTTG_TRAV_NFP_SPEC:
@@ -1628,6 +1614,7 @@ static void *xt_mttg_seq_start(struct seq_file *seq, loff_t *pos,
 
 static void xt_mttg_seq_stop(struct seq_file *seq, void *v)
 {
+	uint8_t nfproto = (unsigned long)PDE_DATA(file_inode(seq->file));
 	struct nf_mttg_trav *trav = seq->private;
 
 	switch (trav->class) {
@@ -1635,7 +1622,7 @@ static void xt_mttg_seq_stop(struct seq_file *seq, void *v)
 		mutex_unlock(&xt[NFPROTO_UNSPEC].mutex);
 		break;
 	case MTTG_TRAV_NFP_SPEC:
-		mutex_unlock(&xt[trav->nfproto].mutex);
+		mutex_unlock(&xt[nfproto].mutex);
 		break;
 	}
 }
@@ -1680,8 +1667,6 @@ static int xt_match_open(struct inode *inode, struct file *file)
 	trav = __seq_open_private(file, &xt_match_seq_ops, sizeof(*trav));
 	if (!trav)
 		return -ENOMEM;
-
-	trav->nfproto = (unsigned long)PDE_DATA(inode);
 	return 0;
 }
 
@@ -1732,8 +1717,6 @@ static int xt_target_open(struct inode *inode, struct file *file)
 	trav = __seq_open_private(file, &xt_target_seq_ops, sizeof(*trav));
 	if (!trav)
 		return -ENOMEM;
-
-	trav->nfproto = (unsigned long)PDE_DATA(inode);
 	return 0;
 }
 
-- 
2.17.0
