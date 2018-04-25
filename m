From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/40] proc: introduce proc_create_seq_private
Date: Wed, 25 Apr 2018 17:47:52 +0200
Message-ID: <20180425154827.32251-6-hch@lst.de>
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

Variant of proc_create_data that directly take a struct seq_operations
argument + a private state size and drastically reduces the boilerplate
code in the callers.

All trivial callers converted over.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/locks.c                 | 16 ++--------------
 fs/proc/generic.c          |  9 ++++++---
 fs/proc/internal.h         |  1 +
 include/linux/atalk.h      |  7 ++++++-
 include/linux/proc_fs.h    |  9 ++++++---
 kernel/time/timer_list.c   | 16 ++--------------
 mm/vmalloc.c               | 18 +++---------------
 net/appletalk/aarp.c       | 20 +-------------------
 net/appletalk/atalk_proc.c |  3 ++-
 net/atm/lec.c              | 15 ++-------------
 net/decnet/af_decnet.c     | 17 +++--------------
 net/decnet/dn_route.c      | 19 +++----------------
 12 files changed, 37 insertions(+), 113 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 62bbe8b31f26..05e211be8684 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2788,22 +2788,10 @@ static const struct seq_operations locks_seq_operations = {
 	.show	= locks_show,
 };
 
-static int locks_open(struct inode *inode, struct file *filp)
-{
-	return seq_open_private(filp, &locks_seq_operations,
-					sizeof(struct locks_iterator));
-}
-
-static const struct file_operations proc_locks_operations = {
-	.open		= locks_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
-
 static int __init proc_locks_init(void)
 {
-	proc_create("locks", 0, NULL, &proc_locks_operations);
+	proc_create_seq_private("locks", 0, NULL, &locks_seq_operations,
+			sizeof(struct locks_iterator), NULL);
 	return 0;
 }
 fs_initcall(proc_locks_init);
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index af644caaaf85..f87cb0053387 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -560,6 +560,8 @@ static int proc_seq_open(struct inode *inode, struct file *file)
 {
 	struct proc_dir_entry *de = PDE(inode);
 
+	if (de->state_size)
+		return seq_open_private(file, de->seq_ops, de->state_size);
 	return seq_open(file, de->seq_ops);
 }
 
@@ -570,9 +572,9 @@ static const struct file_operations proc_seq_fops = {
 	.release	= seq_release,
 };
 
-struct proc_dir_entry *proc_create_seq_data(const char *name, umode_t mode,
+struct proc_dir_entry *proc_create_seq_private(const char *name, umode_t mode,
 		struct proc_dir_entry *parent, const struct seq_operations *ops,
-		void *data)
+		unsigned int state_size, void *data)
 {
 	struct proc_dir_entry *p;
 
@@ -581,9 +583,10 @@ struct proc_dir_entry *proc_create_seq_data(const char *name, umode_t mode,
 		return NULL;
 	p->proc_fops = &proc_seq_fops;
 	p->seq_ops = ops;
+	p->state_size = state_size;
 	return proc_register(parent, p);
 }
-EXPORT_SYMBOL(proc_create_seq_data);
+EXPORT_SYMBOL(proc_create_seq_private);
 
 void proc_set_size(struct proc_dir_entry *de, loff_t size)
 {
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 4fb01c5f9c1a..ed29e91ae483 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -45,6 +45,7 @@ struct proc_dir_entry {
 	const struct inode_operations *proc_iops;
 	const struct file_operations *proc_fops;
 	const struct seq_operations *seq_ops;
+	unsigned int state_size;
 	void *data;
 	unsigned int low_ino;
 	nlink_t nlink;
diff --git a/include/linux/atalk.h b/include/linux/atalk.h
index 40373920ea58..23f805562f4e 100644
--- a/include/linux/atalk.h
+++ b/include/linux/atalk.h
@@ -145,7 +145,12 @@ extern rwlock_t atalk_interfaces_lock;
 
 extern struct atalk_route atrtr_default;
 
-extern const struct file_operations atalk_seq_arp_fops;
+struct aarp_iter_state {
+	int bucket;
+	struct aarp_entry **table;
+};
+
+extern const struct seq_operations aarp_seq_ops;
 
 extern int sysctl_aarp_expiry_time;
 extern int sysctl_aarp_tick_time;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 45f5824b99dc..91d7b84c3c64 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -25,11 +25,13 @@ extern struct proc_dir_entry *proc_mkdir_mode(const char *, umode_t,
 					      struct proc_dir_entry *);
 struct proc_dir_entry *proc_create_mount_point(const char *name);
 
-struct proc_dir_entry *proc_create_seq_data(const char *name, umode_t mode,
+struct proc_dir_entry *proc_create_seq_private(const char *name, umode_t mode,
 		struct proc_dir_entry *parent, const struct seq_operations *ops,
-		void *data);
+		unsigned int state_size, void *data);
+#define proc_create_seq_data(name, mode, parent, ops, data) \
+	proc_create_seq_private(name, mode, parent, ops, 0, data)
 #define proc_create_seq(name, mode, parent, ops) \
-	proc_create_seq_data(name, mode, parent, ops, NULL)
+	proc_create_seq_private(name, mode, parent, ops, 0, NULL)
  
 extern struct proc_dir_entry *proc_create_data(const char *, umode_t,
 					       struct proc_dir_entry *,
@@ -64,6 +66,7 @@ static inline struct proc_dir_entry *proc_mkdir_data(const char *name,
 	umode_t mode, struct proc_dir_entry *parent, void *data) { return NULL; }
 static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
 	umode_t mode, struct proc_dir_entry *parent) { return NULL; }
+#define proc_create_seq_private(name, mode, parent, ops, 0, data) ({NULL;})
 #define proc_create_seq_data(name, mode, parent, ops, data) ({NULL;})
 #define proc_create_seq(name, mode, parent, ops) ({NULL;})
 #define proc_create(name, mode, parent, proc_fops) ({NULL;})
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 0ed768b56c60..675c4e9563a9 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -372,24 +372,12 @@ static const struct seq_operations timer_list_sops = {
 	.show = timer_list_show,
 };
 
-static int timer_list_open(struct inode *inode, struct file *filp)
-{
-	return seq_open_private(filp, &timer_list_sops,
-			sizeof(struct timer_list_iter));
-}
-
-static const struct file_operations timer_list_fops = {
-	.open		= timer_list_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
-
 static int __init init_timer_list_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("timer_list", 0400, NULL, &timer_list_fops);
+	pe = proc_create_seq_private("timer_list", 0400, NULL, &timer_list_sops,
+			sizeof(struct timer_list_iter), NULL);
 	if (!pe)
 		return -ENOMEM;
 	return 0;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bc43c7838778..63a5f502da08 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2751,24 +2751,12 @@ static const struct seq_operations vmalloc_op = {
 	.show = s_show,
 };
 
-static int vmalloc_open(struct inode *inode, struct file *file)
-{
-	return seq_open_private(file, &vmalloc_op,
-					nr_node_ids * sizeof(unsigned int));
-}
-
-static const struct file_operations proc_vmalloc_operations = {
-	.open		= vmalloc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
-
 static int __init proc_vmalloc_init(void)
 {
 	if (IS_ENABLED(CONFIG_NUMA))
-		proc_create("vmallocinfo", S_IRUSR, NULL,
-				&proc_vmalloc_operations);
+		proc_create_seq_private("vmallocinfo", S_IRUSR, NULL,
+				&vmalloc_op,
+				nr_node_ids * sizeof(unsigned int), NULL);
 	else
 		proc_create_seq("vmallocinfo", S_IRUSR, NULL, &vmalloc_op);
 	return 0;
diff --git a/net/appletalk/aarp.c b/net/appletalk/aarp.c
index d4c1021e74e1..49a16cee2aae 100644
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -907,11 +907,6 @@ void aarp_device_down(struct net_device *dev)
 }
 
 #ifdef CONFIG_PROC_FS
-struct aarp_iter_state {
-	int bucket;
-	struct aarp_entry **table;
-};
-
 /*
  * Get the aarp entry that is in the chain described
  * by the iterator.
@@ -1033,25 +1028,12 @@ static int aarp_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations aarp_seq_ops = {
+const struct seq_operations aarp_seq_ops = {
 	.start  = aarp_seq_start,
 	.next   = aarp_seq_next,
 	.stop   = aarp_seq_stop,
 	.show   = aarp_seq_show,
 };
-
-static int aarp_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_private(file, &aarp_seq_ops,
-			sizeof(struct aarp_iter_state));
-}
-
-const struct file_operations atalk_seq_arp_fops = {
-	.open           = aarp_seq_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release	= seq_release_private,
-};
 #endif
 
 /* General module cleanup. Called from cleanup_module() in ddp.c. */
diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index d456c702e725..8006295f8bd7 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -236,7 +236,8 @@ int __init atalk_proc_init(void)
 	if (!p)
 		goto out_socket;
 
-	p = proc_create("arp", 0444, atalk_proc_dir, &atalk_seq_arp_fops);
+	p = proc_create_seq_private("arp", 0444, atalk_proc_dir, &aarp_seq_ops,
+			sizeof(struct aarp_iter_state), NULL);
 	if (!p)
 		goto out_arp;
 
diff --git a/net/atm/lec.c b/net/atm/lec.c
index 01d5d20a6eb1..65114ee82b09 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -985,18 +985,6 @@ static const struct seq_operations lec_seq_ops = {
 	.stop = lec_seq_stop,
 	.show = lec_seq_show,
 };
-
-static int lec_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_private(file, &lec_seq_ops, sizeof(struct lec_state));
-}
-
-static const struct file_operations lec_seq_fops = {
-	.open = lec_seq_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release_private,
-};
 #endif
 
 static int lane_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
@@ -1042,7 +1030,8 @@ static int __init lane_module_init(void)
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *p;
 
-	p = proc_create("lec", 0444, atm_proc_root, &lec_seq_fops);
+	p = proc_create_seq_private("lec", 0444, atm_proc_root, &lec_seq_ops,
+			sizeof(struct lec_state), NULL);
 	if (!p) {
 		pr_err("Unable to initialize /proc/net/atm/lec\n");
 		return -ENOMEM;
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 32751602767f..7d6ff983ba2c 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -2314,19 +2314,6 @@ static const struct seq_operations dn_socket_seq_ops = {
 	.stop	= dn_socket_seq_stop,
 	.show	= dn_socket_seq_show,
 };
-
-static int dn_socket_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_private(file, &dn_socket_seq_ops,
-			sizeof(struct dn_iter_state));
-}
-
-static const struct file_operations dn_socket_seq_fops = {
-	.open		= dn_socket_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
 #endif
 
 static const struct net_proto_family	dn_family_ops = {
@@ -2383,7 +2370,9 @@ static int __init decnet_init(void)
 	dev_add_pack(&dn_dix_packet_type);
 	register_netdevice_notifier(&dn_dev_notifier);
 
-	proc_create("decnet", 0444, init_net.proc_net, &dn_socket_seq_fops);
+	proc_create_seq_private("decnet", 0444, init_net.proc_net,
+			&dn_socket_seq_ops, sizeof(struct dn_iter_state),
+			NULL);
 	dn_register_sysctl();
 out:
 	return rc;
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index eca0cc6b761f..e74765024d88 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1852,20 +1852,6 @@ static const struct seq_operations dn_rt_cache_seq_ops = {
 	.stop	= dn_rt_cache_seq_stop,
 	.show	= dn_rt_cache_seq_show,
 };
-
-static int dn_rt_cache_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open_private(file, &dn_rt_cache_seq_ops,
-			sizeof(struct dn_rt_cache_iter_state));
-}
-
-static const struct file_operations dn_rt_cache_seq_fops = {
-	.open	 = dn_rt_cache_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_private,
-};
-
 #endif /* CONFIG_PROC_FS */
 
 void __init dn_route_init(void)
@@ -1918,8 +1904,9 @@ void __init dn_route_init(void)
 
 	dn_dst_ops.gc_thresh = (dn_rt_hash_mask + 1);
 
-	proc_create("decnet_cache", 0444, init_net.proc_net,
-		    &dn_rt_cache_seq_fops);
+	proc_create_seq_private("decnet_cache", 0444, init_net.proc_net,
+			&dn_rt_cache_seq_ops,
+			sizeof(struct dn_rt_cache_iter_state), NULL);
 
 #ifdef CONFIG_DECNET_ROUTER
 	rtnl_register_module(THIS_MODULE, PF_DECnet, RTM_GETROUTE,
-- 
2.17.0
