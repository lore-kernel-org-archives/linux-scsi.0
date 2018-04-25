From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/40] ipv6/flowlabel: simplify pid namespace lookup
Date: Wed, 25 Apr 2018 17:47:58 +0200
Message-ID: <20180425154827.32251-12-hch@lst.de>
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

The shole seq_file sequence already operates under a single RCU lock pair,
so move the pid namespace lookup into it, and stop grabbing a reference
and remove all kinds of boilerplate code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv6/ip6_flowlabel.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index c05c4e82a7ca..a9f221d45ef9 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -754,7 +754,10 @@ static struct ip6_flowlabel *ip6fl_get_idx(struct seq_file *seq, loff_t pos)
 static void *ip6fl_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
+	struct ip6fl_iter_state *state = ip6fl_seq_private(seq);
+
 	rcu_read_lock_bh();
+	state->pid_ns = task_active_pid_ns(current);
 	return *pos ? ip6fl_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 }
 
@@ -810,36 +813,15 @@ static const struct seq_operations ip6fl_seq_ops = {
 
 static int ip6fl_seq_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
-	struct ip6fl_iter_state *state;
-	int err;
-
-	err = seq_open_net(inode, file, &ip6fl_seq_ops,
+	return seq_open_net(inode, file, &ip6fl_seq_ops,
 			   sizeof(struct ip6fl_iter_state));
-
-	if (!err) {
-		seq = file->private_data;
-		state = ip6fl_seq_private(seq);
-		rcu_read_lock();
-		state->pid_ns = get_pid_ns(task_active_pid_ns(current));
-		rcu_read_unlock();
-	}
-	return err;
-}
-
-static int ip6fl_seq_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *seq = file->private_data;
-	struct ip6fl_iter_state *state = ip6fl_seq_private(seq);
-	put_pid_ns(state->pid_ns);
-	return seq_release_net(inode, file);
 }
 
 static const struct file_operations ip6fl_seq_fops = {
 	.open		=	ip6fl_seq_open,
 	.read		=	seq_read,
 	.llseek		=	seq_lseek,
-	.release	=	ip6fl_seq_release,
+	.release	=	seq_release_net,
 };
 
 static int __net_init ip6_flowlabel_proc_init(struct net *net)
-- 
2.17.0
