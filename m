From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 30/42] bonding: switch to proc_create_seq_data
Date: Wed, 16 May 2018 11:43:34 +0200
Message-ID: <20180516094346.20506-31-hch@lst.de>
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

And use proc private data directly instead of doing a detour
through seq->private.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/bonding/bond_procfs.c | 36 ++++++-------------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index 01059f1a7bca..9f7d83e827c3 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -10,7 +10,7 @@
 static void *bond_info_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
-	struct bonding *bond = seq->private;
+	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 	struct list_head *iter;
 	struct slave *slave;
 	loff_t off = 0;
@@ -29,7 +29,7 @@ static void *bond_info_seq_start(struct seq_file *seq, loff_t *pos)
 
 static void *bond_info_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct bonding *bond = seq->private;
+	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 	struct list_head *iter;
 	struct slave *slave;
 	bool found = false;
@@ -56,7 +56,7 @@ static void bond_info_seq_stop(struct seq_file *seq, void *v)
 
 static void bond_info_show_master(struct seq_file *seq)
 {
-	struct bonding *bond = seq->private;
+	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 	const struct bond_opt_value *optval;
 	struct slave *curr, *primary;
 	int i;
@@ -167,7 +167,7 @@ static void bond_info_show_master(struct seq_file *seq)
 static void bond_info_show_slave(struct seq_file *seq,
 				 const struct slave *slave)
 {
-	struct bonding *bond = seq->private;
+	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 
 	seq_printf(seq, "\nSlave Interface: %s\n", slave->dev->name);
 	seq_printf(seq, "MII Status: %s\n", bond_slave_link_status(slave->link));
@@ -257,38 +257,14 @@ static const struct seq_operations bond_info_seq_ops = {
 	.show  = bond_info_seq_show,
 };
 
-static int bond_info_open(struct inode *inode, struct file *file)
-{
-	struct seq_file *seq;
-	int res;
-
-	res = seq_open(file, &bond_info_seq_ops);
-	if (!res) {
-		/* recover the pointer buried in proc_dir_entry data */
-		seq = file->private_data;
-		seq->private = PDE_DATA(inode);
-	}
-
-	return res;
-}
-
-static const struct file_operations bond_info_fops = {
-	.owner   = THIS_MODULE,
-	.open    = bond_info_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-};
-
 void bond_create_proc_entry(struct bonding *bond)
 {
 	struct net_device *bond_dev = bond->dev;
 	struct bond_net *bn = net_generic(dev_net(bond_dev), bond_net_id);
 
 	if (bn->proc_dir) {
-		bond->proc_entry = proc_create_data(bond_dev->name,
-						    0444, bn->proc_dir,
-						    &bond_info_fops, bond);
+		bond->proc_entry = proc_create_seq_data(bond_dev->name, 0444,
+				bn->proc_dir, &bond_info_seq_ops, bond);
 		if (bond->proc_entry == NULL)
 			netdev_warn(bond_dev, "Cannot create /proc/net/%s/%s\n",
 				    DRV_NAME, bond_dev->name);
-- 
2.17.0
