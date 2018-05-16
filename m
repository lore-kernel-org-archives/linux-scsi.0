From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/42] proc: introduce proc_create_seq{,_data}
Date: Wed, 16 May 2018 11:43:10 +0200
Message-ID: <20180516094346.20506-7-hch@lst.de>
References: <20180516094346.20506-1-hch@lst.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180516094346.20506-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Variants of proc_create{,_data} that directly take a struct seq_operations
argument and drastically reduces the boilerplate code in the callers.

All trivial callers converted over.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/hp/common/sba_iommu.c  | 15 +-----
 arch/ia64/kernel/perfmon.c       | 16 +------
 arch/s390/kernel/sysinfo.c       | 14 +-----
 block/genhd.c                    | 28 +----------
 crypto/proc.c                    | 14 +-----
 drivers/char/misc.c              | 15 +-----
 drivers/isdn/capi/kcapi_proc.c   | 80 ++------------------------------
 drivers/net/hamradio/bpqether.c  | 16 +------
 drivers/net/hamradio/scc.c       | 17 +------
 drivers/net/hamradio/yam.c       | 16 +------
 drivers/pci/proc.c               | 17 +------
 drivers/s390/block/dasd_proc.c   | 17 +------
 drivers/s390/char/tape_proc.c    | 19 +-------
 drivers/staging/ipx/ipx_proc.c   | 45 ++----------------
 drivers/tty/tty_ldisc.c          | 15 +-----
 drivers/video/fbdev/core/fbmem.c | 15 +-----
 drivers/zorro/proc.c             | 17 +------
 fs/cachefiles/proc.c             | 19 +-------
 fs/fscache/histogram.c           | 17 +------
 fs/fscache/internal.h            |  3 +-
 fs/fscache/proc.c                |  4 +-
 fs/proc/consoles.c               | 14 +-----
 fs/proc/devices.c                | 14 +-----
 fs/proc/generic.c                | 30 ++++++++++++
 fs/proc/internal.h               |  1 +
 fs/proc/interrupts.c             | 14 +-----
 fs/proc/nommu.c                  | 14 +-----
 fs/proc/proc_tty.c               | 16 +------
 include/linux/proc_fs.h          |  9 ++++
 include/linux/tty.h              |  3 +-
 include/net/ax25.h               |  5 +-
 include/net/netrom.h             |  5 +-
 include/net/rose.h               |  6 +--
 kernel/locking/lockdep_proc.c    | 29 +-----------
 kernel/sched/debug.c             | 28 +----------
 kernel/sched/stats.c             | 15 +-----
 mm/vmalloc.c                     | 11 +++--
 mm/vmstat.c                      | 56 ++--------------------
 net/appletalk/atalk_proc.c       | 48 +++----------------
 net/atm/br2684.c                 | 14 +-----
 net/ax25/af_ax25.c               | 21 ++-------
 net/ax25/ax25_route.c            | 15 +-----
 net/ax25/ax25_uid.c              | 15 +-----
 net/core/net-procfs.c            | 16 +------
 net/decnet/dn_dev.c              | 15 +-----
 net/llc/llc_proc.c               | 28 +----------
 net/netrom/af_netrom.c           | 18 ++-----
 net/netrom/nr_route.c            | 29 +-----------
 net/rose/af_rose.c               | 26 +++--------
 net/rose/rose_route.c            | 44 ++----------------
 net/sctp/objcnt.c                | 16 +------
 net/x25/x25_proc.c               | 48 +++----------------
 security/keys/proc.c             | 34 +-------------
 53 files changed, 151 insertions(+), 925 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index aec4a3354abe..cb5cd86a5530 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -1942,19 +1942,6 @@ static const struct seq_operations ioc_seq_ops = {
 	.show  = ioc_show
 };
 
-static int
-ioc_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &ioc_seq_ops);
-}
-
-static const struct file_operations ioc_fops = {
-	.open    = ioc_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release
-};
-
 static void __init
 ioc_proc_init(void)
 {
@@ -1964,7 +1951,7 @@ ioc_proc_init(void)
 	if (!dir)
 		return;
 
-	proc_create(ioc_list->name, 0, dir, &ioc_fops);
+	proc_create_seq(ioc_list->name, 0, dir, &ioc_seq_ops);
 }
 #endif
 
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 8fb280e33114..3b38c717008a 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -5708,13 +5708,6 @@ const struct seq_operations pfm_seq_ops = {
  	.show =		pfm_proc_show
 };
 
-static int
-pfm_proc_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &pfm_seq_ops);
-}
-
-
 /*
  * we come here as soon as local_cpu_data->pfm_syst_wide is set. this happens
  * during pfm_enable() hence before pfm_start(). We cannot assume monitoring
@@ -6537,13 +6530,6 @@ pfm_probe_pmu(void)
 	return 0;
 }
 
-static const struct file_operations pfm_proc_fops = {
-	.open		= pfm_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 int __init
 pfm_init(void)
 {
@@ -6615,7 +6601,7 @@ pfm_init(void)
 	/*
 	 * create /proc/perfmon (mostly for debugging purposes)
 	 */
-	perfmon_dir = proc_create("perfmon", S_IRUGO, NULL, &pfm_proc_fops);
+	perfmon_dir = proc_create_seq("perfmon", S_IRUGO, NULL, &pfm_seq_ops);
 	if (perfmon_dir == NULL) {
 		printk(KERN_ERR "perfmon: cannot create /proc entry, perfmon disabled\n");
 		pmu_conf = NULL;
diff --git a/arch/s390/kernel/sysinfo.c b/arch/s390/kernel/sysinfo.c
index fc7e04c2195b..fed49601f06d 100644
--- a/arch/s390/kernel/sysinfo.c
+++ b/arch/s390/kernel/sysinfo.c
@@ -386,18 +386,6 @@ static const struct seq_operations service_level_seq_ops = {
 	.show		= service_level_show
 };
 
-static int service_level_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &service_level_seq_ops);
-}
-
-static const struct file_operations service_level_ops = {
-	.open		= service_level_open,
-	.read		= seq_read,
-	.llseek 	= seq_lseek,
-	.release	= seq_release
-};
-
 static void service_level_vm_print(struct seq_file *m,
 				   struct service_level *slr)
 {
@@ -420,7 +408,7 @@ static struct service_level service_level_vm = {
 
 static __init int create_proc_service_level(void)
 {
-	proc_create("service_levels", 0, NULL, &service_level_ops);
+	proc_create_seq("service_levels", 0, NULL, &service_level_seq_ops);
 	if (MACHINE_IS_VM)
 		register_service_level(&service_level_vm);
 	return 0;
diff --git a/block/genhd.c b/block/genhd.c
index c4513fe1adda..6d7bc8958fda 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1027,18 +1027,6 @@ static const struct seq_operations partitions_op = {
 	.stop	= disk_seqf_stop,
 	.show	= show_partition
 };
-
-static int partitions_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &partitions_op);
-}
-
-static const struct file_operations proc_partitions_operations = {
-	.open		= partitions_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
 #endif
 
 
@@ -1377,22 +1365,10 @@ static const struct seq_operations diskstats_op = {
 	.show	= diskstats_show
 };
 
-static int diskstats_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &diskstats_op);
-}
-
-static const struct file_operations proc_diskstats_operations = {
-	.open		= diskstats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int __init proc_genhd_init(void)
 {
-	proc_create("diskstats", 0, NULL, &proc_diskstats_operations);
-	proc_create("partitions", 0, NULL, &proc_partitions_operations);
+	proc_create_seq("diskstats", 0, NULL, &diskstats_op);
+	proc_create_seq("partitions", 0, NULL, &partitions_op);
 	return 0;
 }
 module_init(proc_genhd_init);
diff --git a/crypto/proc.c b/crypto/proc.c
index 822fcef6d91c..f4eb6139973e 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -94,21 +94,9 @@ static const struct seq_operations crypto_seq_ops = {
 	.show		= c_show
 };
 
-static int crypto_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &crypto_seq_ops);
-}
-        
-static const struct file_operations proc_crypto_ops = {
-	.open		= crypto_info_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release
-};
-
 void __init crypto_init_proc(void)
 {
-	proc_create("crypto", 0, NULL, &proc_crypto_ops);
+	proc_create_seq("crypto", 0, NULL, &crypto_seq_ops);
 }
 
 void __exit crypto_exit_proc(void)
diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 1bb9e7cc82e3..53cfe574d8d4 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -95,19 +95,6 @@ static const struct seq_operations misc_seq_ops = {
 	.stop  = misc_seq_stop,
 	.show  = misc_seq_show,
 };
-
-static int misc_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &misc_seq_ops);
-}
-
-static const struct file_operations misc_proc_fops = {
-	.owner	 = THIS_MODULE,
-	.open    = misc_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-};
 #endif
 
 static int misc_open(struct inode *inode, struct file *file)
@@ -282,7 +269,7 @@ static int __init misc_init(void)
 	int err;
 	struct proc_dir_entry *ret;
 
-	ret = proc_create("misc", 0, NULL, &misc_proc_fops);
+	ret = proc_create_seq("misc", 0, NULL, &misc_seq_ops);
 	misc_class = class_create(THIS_MODULE, "misc");
 	err = PTR_ERR(misc_class);
 	if (IS_ERR(misc_class))
diff --git a/drivers/isdn/capi/kcapi_proc.c b/drivers/isdn/capi/kcapi_proc.c
index 68db3c5a1063..c94bd12c0f7c 100644
--- a/drivers/isdn/capi/kcapi_proc.c
+++ b/drivers/isdn/capi/kcapi_proc.c
@@ -108,32 +108,6 @@ static const struct seq_operations seq_contrstats_ops = {
 	.show	= contrstats_show,
 };
 
-static int seq_controller_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &seq_controller_ops);
-}
-
-static int seq_contrstats_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &seq_contrstats_ops);
-}
-
-static const struct file_operations proc_controller_ops = {
-	.owner		= THIS_MODULE,
-	.open		= seq_controller_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static const struct file_operations proc_contrstats_ops = {
-	.owner		= THIS_MODULE,
-	.open		= seq_contrstats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 // /proc/capi/applications:
 //      applid l3cnt dblkcnt dblklen #ncci recvqueuelen
 // /proc/capi/applstats:
@@ -216,34 +190,6 @@ static const struct seq_operations seq_applstats_ops = {
 	.show	= applstats_show,
 };
 
-static int
-seq_applications_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &seq_applications_ops);
-}
-
-static int
-seq_applstats_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &seq_applstats_ops);
-}
-
-static const struct file_operations proc_applications_ops = {
-	.owner		= THIS_MODULE,
-	.open		= seq_applications_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static const struct file_operations proc_applstats_ops = {
-	.owner		= THIS_MODULE,
-	.open		= seq_applstats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 // ---------------------------------------------------------------------------
 
 static void *capi_driver_start(struct seq_file *seq, loff_t *pos)
@@ -279,22 +225,6 @@ static const struct seq_operations seq_capi_driver_ops = {
 	.show	= capi_driver_show,
 };
 
-static int
-seq_capi_driver_open(struct inode *inode, struct file *file)
-{
-	int err;
-	err = seq_open(file, &seq_capi_driver_ops);
-	return err;
-}
-
-static const struct file_operations proc_driver_ops = {
-	.owner		= THIS_MODULE,
-	.open		= seq_capi_driver_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 // ---------------------------------------------------------------------------
 
 void __init
@@ -302,11 +232,11 @@ kcapi_proc_init(void)
 {
 	proc_mkdir("capi",             NULL);
 	proc_mkdir("capi/controllers", NULL);
-	proc_create("capi/controller",   0, NULL, &proc_controller_ops);
-	proc_create("capi/contrstats",   0, NULL, &proc_contrstats_ops);
-	proc_create("capi/applications", 0, NULL, &proc_applications_ops);
-	proc_create("capi/applstats",    0, NULL, &proc_applstats_ops);
-	proc_create("capi/driver",       0, NULL, &proc_driver_ops);
+	proc_create_seq("capi/controller",   0, NULL, &seq_controller_ops);
+	proc_create_seq("capi/contrstats",   0, NULL, &seq_contrstats_ops);
+	proc_create_seq("capi/applications", 0, NULL, &seq_applications_ops);
+	proc_create_seq("capi/applstats",    0, NULL, &seq_applstats_ops);
+	proc_create_seq("capi/driver",       0, NULL, &seq_capi_driver_ops);
 }
 
 void __exit
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index dfabbae72efd..f347fd9c5b28 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -449,20 +449,6 @@ static const struct seq_operations bpq_seqops = {
 	.show = bpq_seq_show,
 };
 
-static int bpq_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &bpq_seqops);
-}
-
-static const struct file_operations bpq_info_fops = {
-	.owner = THIS_MODULE,
-	.open = bpq_info_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
-
 /* ------------------------------------------------------------------------ */
 
 static const struct net_device_ops bpq_netdev_ops = {
@@ -590,7 +576,7 @@ static int bpq_device_event(struct notifier_block *this,
 static int __init bpq_init_driver(void)
 {
 #ifdef CONFIG_PROC_FS
-	if (!proc_create("bpqether", 0444, init_net.proc_net, &bpq_info_fops)) {
+	if (!proc_create_seq("bpqether", 0444, init_net.proc_net, &bpq_seqops)) {
 		printk(KERN_ERR
 			"bpq: cannot create /proc/net/bpqether entry.\n");
 		return -ENOENT;
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 3de272959090..6c03932d8a6b 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -2084,21 +2084,6 @@ static const struct seq_operations scc_net_seq_ops = {
 	.stop   = scc_net_seq_stop,
 	.show   = scc_net_seq_show,
 };
-
-
-static int scc_net_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scc_net_seq_ops);
-}
-
-static const struct file_operations scc_net_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open	 = scc_net_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release_private,
-};
-
 #endif /* CONFIG_PROC_FS */
 
  
@@ -2122,7 +2107,7 @@ static int __init scc_init_driver (void)
 	}
 	rtnl_unlock();
 
-	proc_create("z8530drv", 0, init_net.proc_net, &scc_net_seq_fops);
+	proc_create_seq("z8530drv", 0, init_net.proc_net, &scc_net_seq_ops);
 
 	return 0;
 }
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 83034eb7ed4f..16ec7af6ab7b 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -841,20 +841,6 @@ static const struct seq_operations yam_seqops = {
 	.stop = yam_seq_stop,
 	.show = yam_seq_show,
 };
-
-static int yam_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &yam_seqops);
-}
-
-static const struct file_operations yam_info_fops = {
-	.owner = THIS_MODULE,
-	.open = yam_info_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
 #endif
 
 
@@ -1168,7 +1154,7 @@ static int __init yam_init_driver(void)
 	yam_timer.expires = jiffies + HZ / 100;
 	add_timer(&yam_timer);
 
-	proc_create("yam", 0444, init_net.proc_net, &yam_info_fops);
+	proc_create_seq("yam", 0444, init_net.proc_net, &yam_seqops);
 	return 0;
  error:
 	while (--i >= 0) {
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 1ee8927a0635..7ac035af39f0 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -435,25 +435,12 @@ int pci_proc_detach_bus(struct pci_bus *bus)
 	return 0;
 }
 
-static int proc_bus_pci_dev_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &proc_bus_pci_devices_op);
-}
-
-static const struct file_operations proc_bus_pci_dev_operations = {
-	.owner		= THIS_MODULE,
-	.open		= proc_bus_pci_dev_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int __init pci_proc_init(void)
 {
 	struct pci_dev *dev = NULL;
 	proc_bus_pci_dir = proc_mkdir("bus/pci", NULL);
-	proc_create("devices", 0, proc_bus_pci_dir,
-		    &proc_bus_pci_dev_operations);
+	proc_create_seq("devices", 0, proc_bus_pci_dir,
+		    &proc_bus_pci_devices_op);
 	proc_initialized = 1;
 	for_each_pci_dev(dev)
 		pci_proc_attach_device(dev);
diff --git a/drivers/s390/block/dasd_proc.c b/drivers/s390/block/dasd_proc.c
index c33788a829c3..5cb80c645489 100644
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -131,19 +131,6 @@ static const struct seq_operations dasd_devices_seq_ops = {
 	.show		= dasd_devices_show,
 };
 
-static int dasd_devices_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &dasd_devices_seq_ops);
-}
-
-static const struct file_operations dasd_devices_file_ops = {
-	.owner		= THIS_MODULE,
-	.open		= dasd_devices_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 #ifdef CONFIG_DASD_PROFILE
 static int dasd_stats_all_block_on(void)
 {
@@ -352,10 +339,10 @@ dasd_proc_init(void)
 	dasd_proc_root_entry = proc_mkdir("dasd", NULL);
 	if (!dasd_proc_root_entry)
 		goto out_nodasd;
-	dasd_devices_entry = proc_create("devices",
+	dasd_devices_entry = proc_create_seq("devices",
 					 S_IFREG | S_IRUGO | S_IWUSR,
 					 dasd_proc_root_entry,
-					 &dasd_devices_file_ops);
+					 &dasd_devices_seq_ops);
 	if (!dasd_devices_entry)
 		goto out_nodevices;
 	dasd_statistics_entry = proc_create("statistics",
diff --git a/drivers/s390/char/tape_proc.c b/drivers/s390/char/tape_proc.c
index faae30476f4b..32a14ee31c6b 100644
--- a/drivers/s390/char/tape_proc.c
+++ b/drivers/s390/char/tape_proc.c
@@ -105,29 +105,14 @@ static const struct seq_operations tape_proc_seq = {
 	.show		= tape_proc_show,
 };
 
-static int tape_proc_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &tape_proc_seq);
-}
-
-static const struct file_operations tape_proc_ops =
-{
-	.owner		= THIS_MODULE,
-	.open		= tape_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 /*
  * Initialize procfs stuff on startup
  */
 void
 tape_proc_init(void)
 {
-	tape_proc_devices =
-		proc_create("tapedevices", S_IFREG | S_IRUGO | S_IWUSR, NULL,
-			    &tape_proc_ops);
+	tape_proc_devices = proc_create_seq("tapedevices",
+			S_IFREG | S_IRUGO | S_IWUSR, NULL,  &tape_proc_seq);
 	if (tape_proc_devices == NULL) {
 		return;
 	}
diff --git a/drivers/staging/ipx/ipx_proc.c b/drivers/staging/ipx/ipx_proc.c
index b9232e4e2ed4..360f0ad970de 100644
--- a/drivers/staging/ipx/ipx_proc.c
+++ b/drivers/staging/ipx/ipx_proc.c
@@ -244,42 +244,6 @@ static const struct seq_operations ipx_seq_socket_ops = {
 	.show   = ipx_seq_socket_show,
 };
 
-static int ipx_seq_route_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &ipx_seq_route_ops);
-}
-
-static int ipx_seq_interface_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &ipx_seq_interface_ops);
-}
-
-static int ipx_seq_socket_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &ipx_seq_socket_ops);
-}
-
-static const struct file_operations ipx_seq_interface_fops = {
-	.open           = ipx_seq_interface_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = seq_release,
-};
-
-static const struct file_operations ipx_seq_route_fops = {
-	.open           = ipx_seq_route_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = seq_release,
-};
-
-static const struct file_operations ipx_seq_socket_fops = {
-	.open           = ipx_seq_socket_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = seq_release,
-};
-
 static struct proc_dir_entry *ipx_proc_dir;
 
 int __init ipx_proc_init(void)
@@ -291,16 +255,17 @@ int __init ipx_proc_init(void)
 
 	if (!ipx_proc_dir)
 		goto out;
-	p = proc_create("interface", S_IRUGO,
-			ipx_proc_dir, &ipx_seq_interface_fops);
+	p = proc_create_seq("interface", S_IRUGO, ipx_proc_dir,
+			&ipx_seq_interface_ops);
 	if (!p)
 		goto out_interface;
 
-	p = proc_create("route", S_IRUGO, ipx_proc_dir, &ipx_seq_route_fops);
+	p = proc_create_seq("route", S_IRUGO, ipx_proc_dir, &ipx_seq_route_ops);
 	if (!p)
 		goto out_route;
 
-	p = proc_create("socket", S_IRUGO, ipx_proc_dir, &ipx_seq_socket_fops);
+	p = proc_create_seq("socket", S_IRUGO, ipx_proc_dir,
+			&ipx_seq_socket_ops);
 	if (!p)
 		goto out_socket;
 
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index fb7329ab2b37..fc4c97cae01e 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -229,26 +229,13 @@ static int tty_ldiscs_seq_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static const struct seq_operations tty_ldiscs_seq_ops = {
+const struct seq_operations tty_ldiscs_seq_ops = {
 	.start	= tty_ldiscs_seq_start,
 	.next	= tty_ldiscs_seq_next,
 	.stop	= tty_ldiscs_seq_stop,
 	.show	= tty_ldiscs_seq_show,
 };
 
-static int proc_tty_ldiscs_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &tty_ldiscs_seq_ops);
-}
-
-const struct file_operations tty_ldiscs_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_tty_ldiscs_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 /**
  *	tty_ldisc_ref_wait	-	wait for the tty ldisc
  *	@tty: tty device
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index f741ba8df01b..924d0730ffe2 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -713,19 +713,6 @@ static const struct seq_operations proc_fb_seq_ops = {
 	.show	= fb_seq_show,
 };
 
-static int proc_fb_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &proc_fb_seq_ops);
-}
-
-static const struct file_operations fb_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_fb_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 /*
  * We hold a reference to the fb_info in file->private_data,
  * but if the current registered fb has changed, we don't
@@ -1877,7 +1864,7 @@ fbmem_init(void)
 {
 	int ret;
 
-	if (!proc_create("fb", 0, NULL, &fb_proc_fops))
+	if (!proc_create_seq("fb", 0, NULL, &proc_fb_seq_ops))
 		return -ENOMEM;
 
 	ret = register_chrdev(FB_MAJOR, "fb", &fb_fops);
diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index df05a26ab8d8..2e4ca4dc0960 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -96,19 +96,6 @@ static const struct seq_operations zorro_devices_seq_ops = {
 	.show  = zorro_seq_show,
 };
 
-static int zorro_devices_proc_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &zorro_devices_seq_ops);
-}
-
-static const struct file_operations zorro_devices_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= zorro_devices_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static struct proc_dir_entry *proc_bus_zorro_dir;
 
 static int __init zorro_proc_attach_device(unsigned int slot)
@@ -132,8 +119,8 @@ static int __init zorro_proc_init(void)
 
 	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(ZORRO)) {
 		proc_bus_zorro_dir = proc_mkdir("bus/zorro", NULL);
-		proc_create("devices", 0, proc_bus_zorro_dir,
-			    &zorro_devices_proc_fops);
+		proc_create_seq("devices", 0, proc_bus_zorro_dir,
+			    &zorro_devices_seq_ops);
 		for (slot = 0; slot < zorro_num_autocon; slot++)
 			zorro_proc_attach_device(slot);
 	}
diff --git a/fs/cachefiles/proc.c b/fs/cachefiles/proc.c
index 125b90f6c796..0ce1aa56b67f 100644
--- a/fs/cachefiles/proc.c
+++ b/fs/cachefiles/proc.c
@@ -84,21 +84,6 @@ static const struct seq_operations cachefiles_histogram_ops = {
 	.show		= cachefiles_histogram_show,
 };
 
-/*
- * open "/proc/fs/cachefiles/XXX" which provide statistics summaries
- */
-static int cachefiles_histogram_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &cachefiles_histogram_ops);
-}
-
-static const struct file_operations cachefiles_histogram_fops = {
-	.open		= cachefiles_histogram_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 /*
  * initialise the /proc/fs/cachefiles/ directory
  */
@@ -109,8 +94,8 @@ int __init cachefiles_proc_init(void)
 	if (!proc_mkdir("fs/cachefiles", NULL))
 		goto error_dir;
 
-	if (!proc_create("fs/cachefiles/histogram", S_IFREG | 0444, NULL,
-			 &cachefiles_histogram_fops))
+	if (!proc_create_seq("fs/cachefiles/histogram", S_IFREG | 0444, NULL,
+			 &cachefiles_histogram_ops))
 		goto error_histogram;
 
 	_leave(" = 0");
diff --git a/fs/fscache/histogram.c b/fs/fscache/histogram.c
index 15a3d042247e..9a13e9e15b69 100644
--- a/fs/fscache/histogram.c
+++ b/fs/fscache/histogram.c
@@ -83,24 +83,9 @@ static void fscache_histogram_stop(struct seq_file *m, void *v)
 {
 }
 
-static const struct seq_operations fscache_histogram_ops = {
+const struct seq_operations fscache_histogram_ops = {
 	.start		= fscache_histogram_start,
 	.stop		= fscache_histogram_stop,
 	.next		= fscache_histogram_next,
 	.show		= fscache_histogram_show,
 };
-
-/*
- * open "/proc/fs/fscache/histogram" to provide latency data
- */
-static int fscache_histogram_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &fscache_histogram_ops);
-}
-
-const struct file_operations fscache_histogram_fops = {
-	.open		= fscache_histogram_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 500650f938fe..53cfd0b34c38 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -31,6 +31,7 @@
 #include <linux/fscache-cache.h>
 #include <trace/events/fscache.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 
 #define FSCACHE_MIN_THREADS	4
 #define FSCACHE_MAX_THREADS	32
@@ -84,7 +85,7 @@ static inline void fscache_hist(atomic_t histogram[], unsigned long start_jif)
 	atomic_inc(&histogram[jif]);
 }
 
-extern const struct file_operations fscache_histogram_fops;
+extern const struct seq_operations fscache_histogram_ops;
 
 #else
 #define fscache_hist(hist, start_jif) do {} while (0)
diff --git a/fs/fscache/proc.c b/fs/fscache/proc.c
index 1d9e4951a597..459df553ea09 100644
--- a/fs/fscache/proc.c
+++ b/fs/fscache/proc.c
@@ -32,8 +32,8 @@ int __init fscache_proc_init(void)
 #endif
 
 #ifdef CONFIG_FSCACHE_HISTOGRAM
-	if (!proc_create("fs/fscache/histogram", S_IFREG | 0444, NULL,
-			 &fscache_histogram_fops))
+	if (!proc_create_seq("fs/fscache/histogram", S_IFREG | 0444, NULL,
+			 &fscache_histogram_ops))
 		goto error_histogram;
 #endif
 
diff --git a/fs/proc/consoles.c b/fs/proc/consoles.c
index a8ac48aebd59..954caf0b7fee 100644
--- a/fs/proc/consoles.c
+++ b/fs/proc/consoles.c
@@ -91,21 +91,9 @@ static const struct seq_operations consoles_op = {
 	.show	= show_console_dev
 };
 
-static int consoles_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &consoles_op);
-}
-
-static const struct file_operations proc_consoles_operations = {
-	.open		= consoles_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int __init proc_consoles_init(void)
 {
-	proc_create("consoles", 0, NULL, &proc_consoles_operations);
+	proc_create_seq("consoles", 0, NULL, &consoles_op);
 	return 0;
 }
 fs_initcall(proc_consoles_init);
diff --git a/fs/proc/devices.c b/fs/proc/devices.c
index 2c7f22b14489..37d38697eaf8 100644
--- a/fs/proc/devices.c
+++ b/fs/proc/devices.c
@@ -51,21 +51,9 @@ static const struct seq_operations devinfo_ops = {
 	.show  = devinfo_show
 };
 
-static int devinfo_open(struct inode *inode, struct file *filp)
-{
-	return seq_open(filp, &devinfo_ops);
-}
-
-static const struct file_operations proc_devinfo_operations = {
-	.open		= devinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int __init proc_devices_init(void)
 {
-	proc_create("devices", 0, NULL, &proc_devinfo_operations);
+	proc_create_seq("devices", 0, NULL, &devinfo_ops);
 	return 0;
 }
 fs_initcall(proc_devices_init);
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index ab6a321076b8..af644caaaf85 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -25,6 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/uaccess.h>
+#include <linux/seq_file.h>
 
 #include "internal.h"
 
@@ -555,6 +556,35 @@ struct proc_dir_entry *proc_create(const char *name, umode_t mode,
 }
 EXPORT_SYMBOL(proc_create);
 
+static int proc_seq_open(struct inode *inode, struct file *file)
+{
+	struct proc_dir_entry *de = PDE(inode);
+
+	return seq_open(file, de->seq_ops);
+}
+
+static const struct file_operations proc_seq_fops = {
+	.open		= proc_seq_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+struct proc_dir_entry *proc_create_seq_data(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, const struct seq_operations *ops,
+		void *data)
+{
+	struct proc_dir_entry *p;
+
+	p = proc_create_reg(name, mode, &parent, data);
+	if (!p)
+		return NULL;
+	p->proc_fops = &proc_seq_fops;
+	p->seq_ops = ops;
+	return proc_register(parent, p);
+}
+EXPORT_SYMBOL(proc_create_seq_data);
+
 void proc_set_size(struct proc_dir_entry *de, loff_t size)
 {
 	de->size = size;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index dd1e11400b97..4fb01c5f9c1a 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -44,6 +44,7 @@ struct proc_dir_entry {
 	struct completion *pde_unload_completion;
 	const struct inode_operations *proc_iops;
 	const struct file_operations *proc_fops;
+	const struct seq_operations *seq_ops;
 	void *data;
 	unsigned int low_ino;
 	nlink_t nlink;
diff --git a/fs/proc/interrupts.c b/fs/proc/interrupts.c
index 6a6bee9c603c..cb0edc7cbf09 100644
--- a/fs/proc/interrupts.c
+++ b/fs/proc/interrupts.c
@@ -34,21 +34,9 @@ static const struct seq_operations int_seq_ops = {
 	.show  = show_interrupts
 };
 
-static int interrupts_open(struct inode *inode, struct file *filp)
-{
-	return seq_open(filp, &int_seq_ops);
-}
-
-static const struct file_operations proc_interrupts_operations = {
-	.open		= interrupts_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int __init proc_interrupts_init(void)
 {
-	proc_create("interrupts", 0, NULL, &proc_interrupts_operations);
+	proc_create_seq("interrupts", 0, NULL, &int_seq_ops);
 	return 0;
 }
 fs_initcall(proc_interrupts_init);
diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index 75634379f82e..3b63be64e436 100644
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -113,21 +113,9 @@ static const struct seq_operations proc_nommu_region_list_seqop = {
 	.show	= nommu_region_list_show
 };
 
-static int proc_nommu_region_list_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &proc_nommu_region_list_seqop);
-}
-
-static const struct file_operations proc_nommu_region_list_operations = {
-	.open    = proc_nommu_region_list_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-};
-
 static int __init proc_nommu_init(void)
 {
-	proc_create("maps", S_IRUGO, NULL, &proc_nommu_region_list_operations);
+	proc_create_seq("maps", S_IRUGO, NULL, &proc_nommu_region_list_seqop);
 	return 0;
 }
 
diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index d0cf1c50bb6c..b1a4a8ddd246 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -126,18 +126,6 @@ static const struct seq_operations tty_drivers_op = {
 	.show	= show_tty_driver
 };
 
-static int tty_drivers_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &tty_drivers_op);
-}
-
-static const struct file_operations proc_tty_drivers_operations = {
-	.open		= tty_drivers_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 /*
  * This function is called by tty_register_driver() to handle
  * registering the driver's /proc handler into /proc/tty/driver/<foo>
@@ -186,6 +174,6 @@ void __init proc_tty_init(void)
 	 * entry.
 	 */
 	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR|S_IXUSR, NULL);
-	proc_create("tty/ldiscs", 0, NULL, &tty_ldiscs_proc_fops);
-	proc_create("tty/drivers", 0, NULL, &proc_tty_drivers_operations);
+	proc_create_seq("tty/ldiscs", 0, NULL, &tty_ldiscs_seq_ops);
+	proc_create_seq("tty/drivers", 0, NULL, &tty_drivers_op);
 }
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 4edcde510631..f368a896a8cb 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 
 struct proc_dir_entry;
+struct seq_operations;
 
 #ifdef CONFIG_PROC_FS
 
@@ -23,6 +24,12 @@ extern struct proc_dir_entry *proc_mkdir_data(const char *, umode_t,
 extern struct proc_dir_entry *proc_mkdir_mode(const char *, umode_t,
 					      struct proc_dir_entry *);
 struct proc_dir_entry *proc_create_mount_point(const char *name);
+
+struct proc_dir_entry *proc_create_seq_data(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, const struct seq_operations *ops,
+		void *data);
+#define proc_create_seq(name, mode, parent, ops) \
+	proc_create_seq_data(name, mode, parent, ops, NULL)
  
 extern struct proc_dir_entry *proc_create_data(const char *, umode_t,
 					       struct proc_dir_entry *,
@@ -57,6 +64,8 @@ static inline struct proc_dir_entry *proc_mkdir_data(const char *name,
 	umode_t mode, struct proc_dir_entry *parent, void *data) { return NULL; }
 static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
 	umode_t mode, struct proc_dir_entry *parent) { return NULL; }
+#define proc_create_seq_data(name, mode, parent, ops, data) ({NULL;})
+#define proc_create_seq(name, mode, parent, ops) ({NULL;})
 #define proc_create(name, mode, parent, proc_fops) ({NULL;})
 #define proc_create_data(name, mode, parent, proc_fops, data) ({NULL;})
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1dd587ba6d88..9bd7d37adbfa 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -10,6 +10,7 @@
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
 #include <linux/tty_flags.h>
+#include <linux/seq_file.h>
 #include <uapi/linux/tty.h>
 #include <linux/rwsem.h>
 #include <linux/llist.h>
@@ -535,7 +536,7 @@ extern void tty_ldisc_deref(struct tty_ldisc *);
 extern struct tty_ldisc *tty_ldisc_ref_wait(struct tty_struct *);
 extern void tty_ldisc_hangup(struct tty_struct *tty, bool reset);
 extern int tty_ldisc_reinit(struct tty_struct *tty, int disc);
-extern const struct file_operations tty_ldiscs_proc_fops;
+extern const struct seq_operations tty_ldiscs_seq_ops;
 
 extern void tty_wakeup(struct tty_struct *tty);
 extern void tty_ldisc_flush(struct tty_struct *tty);
diff --git a/include/net/ax25.h b/include/net/ax25.h
index c91bc87931c7..3f9aea8087e3 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -15,6 +15,7 @@
 #include <linux/refcount.h>
 #include <net/neighbour.h>
 #include <net/sock.h>
+#include <linux/seq_file.h>
 
 #define	AX25_T1CLAMPLO  		1
 #define	AX25_T1CLAMPHI 			(30 * HZ)
@@ -399,7 +400,7 @@ int ax25_check_iframes_acked(ax25_cb *, unsigned short);
 /* ax25_route.c */
 void ax25_rt_device_down(struct net_device *);
 int ax25_rt_ioctl(unsigned int, void __user *);
-extern const struct file_operations ax25_route_fops;
+extern const struct seq_operations ax25_rt_seqops;
 ax25_route *ax25_get_route(ax25_address *addr, struct net_device *dev);
 int ax25_rt_autobind(ax25_cb *, ax25_address *);
 struct sk_buff *ax25_rt_build_path(struct sk_buff *, ax25_address *,
@@ -455,7 +456,7 @@ unsigned long ax25_display_timer(struct timer_list *);
 extern int  ax25_uid_policy;
 ax25_uid_assoc *ax25_findbyuid(kuid_t);
 int __must_check ax25_uid_ioctl(int, struct sockaddr_ax25 *);
-extern const struct file_operations ax25_uid_fops;
+extern const struct seq_operations ax25_uid_seqops;
 void ax25_uid_free(void);
 
 /* sysctl_net_ax25.c */
diff --git a/include/net/netrom.h b/include/net/netrom.h
index 0dad2dd5f9d7..5a0714ff500f 100644
--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <linux/refcount.h>
+#include <linux/seq_file.h>
 
 #define	NR_NETWORK_LEN			15
 #define	NR_TRANSPORT_LEN		5
@@ -216,8 +217,8 @@ struct net_device *nr_dev_get(ax25_address *);
 int nr_rt_ioctl(unsigned int, void __user *);
 void nr_link_failed(ax25_cb *, int);
 int nr_route_frame(struct sk_buff *, ax25_cb *);
-extern const struct file_operations nr_nodes_fops;
-extern const struct file_operations nr_neigh_fops;
+extern const struct seq_operations nr_node_seqops;
+extern const struct seq_operations nr_neigh_seqops;
 void nr_rt_free(void);
 
 /* nr_subr.c */
diff --git a/include/net/rose.h b/include/net/rose.h
index 04b72681f2ab..cf517d306a28 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -200,9 +200,9 @@ void rose_enquiry_response(struct sock *);
 
 /* rose_route.c */
 extern struct rose_neigh *rose_loopback_neigh;
-extern const struct file_operations rose_neigh_fops;
-extern const struct file_operations rose_nodes_fops;
-extern const struct file_operations rose_routes_fops;
+extern const struct seq_operations rose_neigh_seqops;
+extern const struct seq_operations rose_node_seqops;
+extern struct seq_operations rose_route_seqops;
 
 void rose_add_loopback_neigh(void);
 int __must_check rose_add_loopback_node(rose_address *);
diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index ad69bbc9bd28..3629049648a1 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -101,18 +101,6 @@ static const struct seq_operations lockdep_ops = {
 	.show	= l_show,
 };
 
-static int lockdep_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &lockdep_ops);
-}
-
-static const struct file_operations proc_lockdep_operations = {
-	.open		= lockdep_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 #ifdef CONFIG_PROVE_LOCKING
 static void *lc_start(struct seq_file *m, loff_t *pos)
 {
@@ -170,18 +158,6 @@ static const struct seq_operations lockdep_chains_ops = {
 	.stop	= lc_stop,
 	.show	= lc_show,
 };
-
-static int lockdep_chains_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &lockdep_chains_ops);
-}
-
-static const struct file_operations proc_lockdep_chains_operations = {
-	.open		= lockdep_chains_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
 #endif /* CONFIG_PROVE_LOCKING */
 
 static void lockdep_stats_debug_show(struct seq_file *m)
@@ -682,10 +658,9 @@ static const struct file_operations proc_lock_stat_operations = {
 
 static int __init lockdep_proc_init(void)
 {
-	proc_create("lockdep", S_IRUSR, NULL, &proc_lockdep_operations);
+	proc_create_seq("lockdep", S_IRUSR, NULL, &lockdep_ops);
 #ifdef CONFIG_PROVE_LOCKING
-	proc_create("lockdep_chains", S_IRUSR, NULL,
-		    &proc_lockdep_chains_operations);
+	proc_create_seq("lockdep_chains", S_IRUSR, NULL, &lockdep_chains_ops);
 #endif
 	proc_create("lockdep_stats", S_IRUSR, NULL,
 		    &proc_lockdep_stats_operations);
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 15b10e210a6b..e593b4118578 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -823,35 +823,9 @@ static const struct seq_operations sched_debug_sops = {
 	.show		= sched_debug_show,
 };
 
-static int sched_debug_release(struct inode *inode, struct file *file)
-{
-	seq_release(inode, file);
-
-	return 0;
-}
-
-static int sched_debug_open(struct inode *inode, struct file *filp)
-{
-	int ret = 0;
-
-	ret = seq_open(filp, &sched_debug_sops);
-
-	return ret;
-}
-
-static const struct file_operations sched_debug_fops = {
-	.open		= sched_debug_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= sched_debug_release,
-};
-
 static int __init init_sched_debug_procfs(void)
 {
-	struct proc_dir_entry *pe;
-
-	pe = proc_create("sched_debug", 0444, NULL, &sched_debug_fops);
-	if (!pe)
+	if (!proc_create_seq("sched_debug", 0444, NULL, &sched_debug_sops))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index ab112cbfd7c8..750fb3c67eed 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -120,22 +120,9 @@ static const struct seq_operations schedstat_sops = {
 	.show  = show_schedstat,
 };
 
-static int schedstat_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &schedstat_sops);
-}
-
-static const struct file_operations proc_schedstat_operations = {
-	.open    = schedstat_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-};
-
 static int __init proc_schedstat_init(void)
 {
-	proc_create("schedstat", 0, NULL, &proc_schedstat_operations);
-
+	proc_create_seq("schedstat", 0, NULL, &schedstat_sops);
 	return 0;
 }
 subsys_initcall(proc_schedstat_init);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ebff729cc956..bc43c7838778 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2753,11 +2753,8 @@ static const struct seq_operations vmalloc_op = {
 
 static int vmalloc_open(struct inode *inode, struct file *file)
 {
-	if (IS_ENABLED(CONFIG_NUMA))
-		return seq_open_private(file, &vmalloc_op,
+	return seq_open_private(file, &vmalloc_op,
 					nr_node_ids * sizeof(unsigned int));
-	else
-		return seq_open(file, &vmalloc_op);
 }
 
 static const struct file_operations proc_vmalloc_operations = {
@@ -2769,7 +2766,11 @@ static const struct file_operations proc_vmalloc_operations = {
 
 static int __init proc_vmalloc_init(void)
 {
-	proc_create("vmallocinfo", S_IRUSR, NULL, &proc_vmalloc_operations);
+	if (IS_ENABLED(CONFIG_NUMA))
+		proc_create("vmallocinfo", S_IRUSR, NULL,
+				&proc_vmalloc_operations);
+	else
+		proc_create_seq("vmallocinfo", S_IRUSR, NULL, &vmalloc_op);
 	return 0;
 }
 module_init(proc_vmalloc_init);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a2b9518980ce..75eda9c2b260 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1516,18 +1516,6 @@ static const struct seq_operations fragmentation_op = {
 	.show	= frag_show,
 };
 
-static int fragmentation_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &fragmentation_op);
-}
-
-static const struct file_operations buddyinfo_file_operations = {
-	.open		= fragmentation_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static const struct seq_operations pagetypeinfo_op = {
 	.start	= frag_start,
 	.next	= frag_next,
@@ -1535,18 +1523,6 @@ static const struct seq_operations pagetypeinfo_op = {
 	.show	= pagetypeinfo_show,
 };
 
-static int pagetypeinfo_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &pagetypeinfo_op);
-}
-
-static const struct file_operations pagetypeinfo_file_operations = {
-	.open		= pagetypeinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static bool is_zone_first_populated(pg_data_t *pgdat, struct zone *zone)
 {
 	int zid;
@@ -1663,18 +1639,6 @@ static const struct seq_operations zoneinfo_op = {
 	.show	= zoneinfo_show,
 };
 
-static int zoneinfo_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &zoneinfo_op);
-}
-
-static const struct file_operations zoneinfo_file_operations = {
-	.open		= zoneinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 enum writeback_stat_item {
 	NR_DIRTY_THRESHOLD,
 	NR_DIRTY_BG_THRESHOLD,
@@ -1762,18 +1726,6 @@ static const struct seq_operations vmstat_op = {
 	.stop	= vmstat_stop,
 	.show	= vmstat_show,
 };
-
-static int vmstat_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &vmstat_op);
-}
-
-static const struct file_operations vmstat_file_operations = {
-	.open		= vmstat_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SMP
@@ -2020,10 +1972,10 @@ void __init init_mm_internals(void)
 	start_shepherd_timer();
 #endif
 #ifdef CONFIG_PROC_FS
-	proc_create("buddyinfo", 0444, NULL, &buddyinfo_file_operations);
-	proc_create("pagetypeinfo", 0444, NULL, &pagetypeinfo_file_operations);
-	proc_create("vmstat", 0444, NULL, &vmstat_file_operations);
-	proc_create("zoneinfo", 0444, NULL, &zoneinfo_file_operations);
+	proc_create_seq("buddyinfo", 0444, NULL, &fragmentation_op);
+	proc_create_seq("pagetypeinfo", 0444, NULL, &pagetypeinfo_op);
+	proc_create_seq("vmstat", 0444, NULL, &vmstat_op);
+	proc_create_seq("zoneinfo", 0444, NULL, &zoneinfo_op);
 #endif
 }
 
diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index 7214aea14cb3..d456c702e725 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -210,42 +210,6 @@ static const struct seq_operations atalk_seq_socket_ops = {
 	.show   = atalk_seq_socket_show,
 };
 
-static int atalk_seq_interface_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &atalk_seq_interface_ops);
-}
-
-static int atalk_seq_route_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &atalk_seq_route_ops);
-}
-
-static int atalk_seq_socket_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &atalk_seq_socket_ops);
-}
-
-static const struct file_operations atalk_seq_interface_fops = {
-	.open		= atalk_seq_interface_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static const struct file_operations atalk_seq_route_fops = {
-	.open		= atalk_seq_route_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static const struct file_operations atalk_seq_socket_fops = {
-	.open		= atalk_seq_socket_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static struct proc_dir_entry *atalk_proc_dir;
 
 int __init atalk_proc_init(void)
@@ -257,18 +221,18 @@ int __init atalk_proc_init(void)
 	if (!atalk_proc_dir)
 		goto out;
 
-	p = proc_create("interface", 0444, atalk_proc_dir,
-			&atalk_seq_interface_fops);
+	p = proc_create_seq("interface", 0444, atalk_proc_dir,
+			&atalk_seq_interface_ops);
 	if (!p)
 		goto out_interface;
 
-	p = proc_create("route", 0444, atalk_proc_dir,
-			&atalk_seq_route_fops);
+	p = proc_create_seq("route", 0444, atalk_proc_dir,
+			&atalk_seq_route_ops);
 	if (!p)
 		goto out_route;
 
-	p = proc_create("socket", 0444, atalk_proc_dir,
-			&atalk_seq_socket_fops);
+	p = proc_create_seq("socket", 0444, atalk_proc_dir,
+			&atalk_seq_socket_ops);
 	if (!p)
 		goto out_socket;
 
diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index fd94bea36ee8..36b3adacc0dd 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -818,18 +818,6 @@ static const struct seq_operations br2684_seq_ops = {
 	.show = br2684_seq_show,
 };
 
-static int br2684_proc_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &br2684_seq_ops);
-}
-
-static const struct file_operations br2684_proc_ops = {
-	.open = br2684_proc_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
 extern struct proc_dir_entry *atm_proc_root;	/* from proc.c */
 #endif /* CONFIG_PROC_FS */
 
@@ -837,7 +825,7 @@ static int __init br2684_init(void)
 {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *p;
-	p = proc_create("br2684", 0, atm_proc_root, &br2684_proc_ops);
+	p = proc_create_seq("br2684", 0, atm_proc_root, &br2684_seq_ops);
 	if (p == NULL)
 		return -ENOMEM;
 #endif
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 2b41366fcad2..c603d33d5410 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1924,19 +1924,6 @@ static const struct seq_operations ax25_info_seqops = {
 	.stop = ax25_info_stop,
 	.show = ax25_info_show,
 };
-
-static int ax25_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &ax25_info_seqops);
-}
-
-static const struct file_operations ax25_info_fops = {
-	.open = ax25_info_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
 #endif
 
 static const struct net_proto_family ax25_family_ops = {
@@ -1989,10 +1976,10 @@ static int __init ax25_init(void)
 	dev_add_pack(&ax25_packet_type);
 	register_netdevice_notifier(&ax25_dev_notifier);
 
-	proc_create("ax25_route", 0444, init_net.proc_net,
-		    &ax25_route_fops);
-	proc_create("ax25", 0444, init_net.proc_net, &ax25_info_fops);
-	proc_create("ax25_calls", 0444, init_net.proc_net, &ax25_uid_fops);
+	proc_create_seq("ax25_route", 0444, init_net.proc_net, &ax25_rt_seqops);
+	proc_create_seq("ax25", 0444, init_net.proc_net, &ax25_info_seqops);
+	proc_create_seq("ax25_calls", 0444, init_net.proc_net,
+			&ax25_uid_seqops);
 out:
 	return rc;
 }
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 525558972fd9..a0eff323af12 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -323,25 +323,12 @@ static int ax25_rt_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations ax25_rt_seqops = {
+const struct seq_operations ax25_rt_seqops = {
 	.start = ax25_rt_seq_start,
 	.next = ax25_rt_seq_next,
 	.stop = ax25_rt_seq_stop,
 	.show = ax25_rt_seq_show,
 };
-
-static int ax25_rt_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &ax25_rt_seqops);
-}
-
-const struct file_operations ax25_route_fops = {
-	.open = ax25_rt_info_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
 #endif
 
 /*
diff --git a/net/ax25/ax25_uid.c b/net/ax25/ax25_uid.c
index 4ebe91ba317a..99d02e390e43 100644
--- a/net/ax25/ax25_uid.c
+++ b/net/ax25/ax25_uid.c
@@ -181,25 +181,12 @@ static int ax25_uid_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations ax25_uid_seqops = {
+const struct seq_operations ax25_uid_seqops = {
 	.start = ax25_uid_seq_start,
 	.next = ax25_uid_seq_next,
 	.stop = ax25_uid_seq_stop,
 	.show = ax25_uid_seq_show,
 };
-
-static int ax25_uid_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &ax25_uid_seqops);
-}
-
-const struct file_operations ax25_uid_fops = {
-	.open = ax25_uid_info_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
 #endif
 
 /*
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 9737302907b1..c4e8ebe55e26 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -195,18 +195,6 @@ static const struct seq_operations softnet_seq_ops = {
 	.show  = softnet_seq_show,
 };
 
-static int softnet_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &softnet_seq_ops);
-}
-
-static const struct file_operations softnet_seq_fops = {
-	.open    = softnet_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-};
-
 static void *ptype_get_idx(loff_t pos)
 {
 	struct packet_type *pt = NULL;
@@ -317,8 +305,8 @@ static int __net_init dev_proc_net_init(struct net *net)
 
 	if (!proc_create("dev", 0444, net->proc_net, &dev_seq_fops))
 		goto out;
-	if (!proc_create("softnet_stat", 0444, net->proc_net,
-			 &softnet_seq_fops))
+	if (!proc_create_seq("softnet_stat", 0444, net->proc_net,
+			 &softnet_seq_ops))
 		goto out_dev;
 	if (!proc_create("ptype", 0444, net->proc_net, &ptype_seq_fops))
 		goto out_softnet;
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index c03b046478c3..bfd43e8f2c06 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -1382,19 +1382,6 @@ static const struct seq_operations dn_dev_seq_ops = {
 	.stop	= dn_dev_seq_stop,
 	.show	= dn_dev_seq_show,
 };
-
-static int dn_dev_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &dn_dev_seq_ops);
-}
-
-static const struct file_operations dn_dev_seq_fops = {
-	.open	 = dn_dev_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
 #endif /* CONFIG_PROC_FS */
 
 static int addr[2];
@@ -1424,7 +1411,7 @@ void __init dn_dev_init(void)
 	rtnl_register_module(THIS_MODULE, PF_DECnet, RTM_GETADDR,
 			     NULL, dn_nl_dump_ifaddr, 0);
 
-	proc_create("decnet_dev", 0444, init_net.proc_net, &dn_dev_seq_fops);
+	proc_create_seq("decnet_dev", 0444, init_net.proc_net, &dn_dev_seq_ops);
 
 #ifdef CONFIG_SYSCTL
 	{
diff --git a/net/llc/llc_proc.c b/net/llc/llc_proc.c
index 62ea0aed94b4..f3a36c16a5e7 100644
--- a/net/llc/llc_proc.c
+++ b/net/llc/llc_proc.c
@@ -214,30 +214,6 @@ static const struct seq_operations llc_seq_core_ops = {
 	.show   = llc_seq_core_show,
 };
 
-static int llc_seq_socket_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &llc_seq_socket_ops);
-}
-
-static int llc_seq_core_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &llc_seq_core_ops);
-}
-
-static const struct file_operations llc_seq_socket_fops = {
-	.open		= llc_seq_socket_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static const struct file_operations llc_seq_core_fops = {
-	.open		= llc_seq_core_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static struct proc_dir_entry *llc_proc_dir;
 
 int __init llc_proc_init(void)
@@ -249,11 +225,11 @@ int __init llc_proc_init(void)
 	if (!llc_proc_dir)
 		goto out;
 
-	p = proc_create("socket", 0444, llc_proc_dir, &llc_seq_socket_fops);
+	p = proc_create_seq("socket", 0444, llc_proc_dir, &llc_seq_socket_ops);
 	if (!p)
 		goto out_socket;
 
-	p = proc_create("core", 0444, llc_proc_dir, &llc_seq_core_fops);
+	p = proc_create_seq("core", 0444, llc_proc_dir, &llc_seq_core_ops);
 	if (!p)
 		goto out_core;
 
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 4221d98a314b..c2888c78d4c1 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1338,18 +1338,6 @@ static const struct seq_operations nr_info_seqops = {
 	.stop = nr_info_stop,
 	.show = nr_info_show,
 };
-
-static int nr_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &nr_info_seqops);
-}
-
-static const struct file_operations nr_info_fops = {
-	.open = nr_info_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
 #endif	/* CONFIG_PROC_FS */
 
 static const struct net_proto_family nr_family_ops = {
@@ -1450,9 +1438,9 @@ static int __init nr_proto_init(void)
 
 	nr_loopback_init();
 
-	proc_create("nr", 0444, init_net.proc_net, &nr_info_fops);
-	proc_create("nr_neigh", 0444, init_net.proc_net, &nr_neigh_fops);
-	proc_create("nr_nodes", 0444, init_net.proc_net, &nr_nodes_fops);
+	proc_create_seq("nr", 0444, init_net.proc_net, &nr_info_seqops);
+	proc_create_seq("nr_neigh", 0444, init_net.proc_net, &nr_neigh_seqops);
+	proc_create_seq("nr_nodes", 0444, init_net.proc_net, &nr_node_seqops);
 out:
 	return rc;
 fail:
diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index b5a7dcb30991..6485f593e2f0 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -888,25 +888,13 @@ static int nr_node_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations nr_node_seqops = {
+const struct seq_operations nr_node_seqops = {
 	.start = nr_node_start,
 	.next = nr_node_next,
 	.stop = nr_node_stop,
 	.show = nr_node_show,
 };
 
-static int nr_node_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &nr_node_seqops);
-}
-
-const struct file_operations nr_nodes_fops = {
-	.open = nr_node_info_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
 static void *nr_neigh_start(struct seq_file *seq, loff_t *pos)
 {
 	spin_lock_bh(&nr_neigh_list_lock);
@@ -954,25 +942,12 @@ static int nr_neigh_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations nr_neigh_seqops = {
+const struct seq_operations nr_neigh_seqops = {
 	.start = nr_neigh_start,
 	.next = nr_neigh_next,
 	.stop = nr_neigh_stop,
 	.show = nr_neigh_show,
 };
-
-static int nr_neigh_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &nr_neigh_seqops);
-}
-
-const struct file_operations nr_neigh_fops = {
-	.open = nr_neigh_info_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
 #endif
 
 /*
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 9ff5e0a76593..22a7f2b413ac 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1453,18 +1453,6 @@ static const struct seq_operations rose_info_seqops = {
 	.stop = rose_info_stop,
 	.show = rose_info_show,
 };
-
-static int rose_info_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &rose_info_seqops);
-}
-
-static const struct file_operations rose_info_fops = {
-	.open = rose_info_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
 #endif	/* CONFIG_PROC_FS */
 
 static const struct net_proto_family rose_family_ops = {
@@ -1567,13 +1555,13 @@ static int __init rose_proto_init(void)
 
 	rose_add_loopback_neigh();
 
-	proc_create("rose", 0444, init_net.proc_net, &rose_info_fops);
-	proc_create("rose_neigh", 0444, init_net.proc_net,
-		    &rose_neigh_fops);
-	proc_create("rose_nodes", 0444, init_net.proc_net,
-		    &rose_nodes_fops);
-	proc_create("rose_routes", 0444, init_net.proc_net,
-		    &rose_routes_fops);
+	proc_create_seq("rose", 0444, init_net.proc_net, &rose_info_seqops);
+	proc_create_seq("rose_neigh", 0444, init_net.proc_net,
+		    &rose_neigh_seqops);
+	proc_create_seq("rose_nodes", 0444, init_net.proc_net,
+		    &rose_node_seqops);
+	proc_create_seq("rose_routes", 0444, init_net.proc_net,
+		    &rose_route_seqops);
 out:
 	return rc;
 fail:
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 178619ddab68..77e9f85a2c92 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -1143,25 +1143,13 @@ static int rose_node_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations rose_node_seqops = {
+const struct seq_operations rose_node_seqops = {
 	.start = rose_node_start,
 	.next = rose_node_next,
 	.stop = rose_node_stop,
 	.show = rose_node_show,
 };
 
-static int rose_nodes_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &rose_node_seqops);
-}
-
-const struct file_operations rose_nodes_fops = {
-	.open = rose_nodes_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
 static void *rose_neigh_start(struct seq_file *seq, loff_t *pos)
 	__acquires(rose_neigh_list_lock)
 {
@@ -1226,26 +1214,13 @@ static int rose_neigh_show(struct seq_file *seq, void *v)
 }
 
 
-static const struct seq_operations rose_neigh_seqops = {
+const struct seq_operations rose_neigh_seqops = {
 	.start = rose_neigh_start,
 	.next = rose_neigh_next,
 	.stop = rose_neigh_stop,
 	.show = rose_neigh_show,
 };
 
-static int rose_neigh_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &rose_neigh_seqops);
-}
-
-const struct file_operations rose_neigh_fops = {
-	.open = rose_neigh_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
-
 static void *rose_route_start(struct seq_file *seq, loff_t *pos)
 	__acquires(rose_route_list_lock)
 {
@@ -1311,25 +1286,12 @@ static int rose_route_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations rose_route_seqops = {
+struct seq_operations rose_route_seqops = {
 	.start = rose_route_start,
 	.next = rose_route_next,
 	.stop = rose_route_stop,
 	.show = rose_route_show,
 };
-
-static int rose_route_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &rose_route_seqops);
-}
-
-const struct file_operations rose_routes_fops = {
-	.open = rose_route_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
 #endif /* CONFIG_PROC_FS */
 
 /*
diff --git a/net/sctp/objcnt.c b/net/sctp/objcnt.c
index fd2684ad94c8..a6179b26b80c 100644
--- a/net/sctp/objcnt.c
+++ b/net/sctp/objcnt.c
@@ -108,25 +108,13 @@ static const struct seq_operations sctp_objcnt_seq_ops = {
 	.show  = sctp_objcnt_seq_show,
 };
 
-static int sctp_objcnt_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &sctp_objcnt_seq_ops);
-}
-
-static const struct file_operations sctp_objcnt_ops = {
-	.open	 = sctp_objcnt_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
-};
-
 /* Initialize the objcount in the proc filesystem.  */
 void sctp_dbg_objcnt_init(struct net *net)
 {
 	struct proc_dir_entry *ent;
 
-	ent = proc_create("sctp_dbg_objcnt", 0,
-			  net->sctp.proc_net_sctp, &sctp_objcnt_ops);
+	ent = proc_create_seq("sctp_dbg_objcnt", 0,
+			  net->sctp.proc_net_sctp, &sctp_objcnt_seq_ops);
 	if (!ent)
 		pr_warn("sctp_dbg_objcnt: Unable to create /proc entry.\n");
 }
diff --git a/net/x25/x25_proc.c b/net/x25/x25_proc.c
index 64b415e93f6a..da52c9dc256c 100644
--- a/net/x25/x25_proc.c
+++ b/net/x25/x25_proc.c
@@ -171,57 +171,21 @@ static const struct seq_operations x25_seq_forward_ops = {
 	.show   = x25_seq_forward_show,
 };
 
-static int x25_seq_socket_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &x25_seq_socket_ops);
-}
-
-static int x25_seq_route_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &x25_seq_route_ops);
-}
-
-static int x25_seq_forward_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &x25_seq_forward_ops);
-}
-
-static const struct file_operations x25_seq_socket_fops = {
-	.open		= x25_seq_socket_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static const struct file_operations x25_seq_route_fops = {
-	.open		= x25_seq_route_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static const struct file_operations x25_seq_forward_fops = {
-	.open		= x25_seq_forward_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 int __init x25_proc_init(void)
 {
 	if (!proc_mkdir("x25", init_net.proc_net))
 		return -ENOMEM;
 
-	if (!proc_create("x25/route", 0444, init_net.proc_net,
-			 &x25_seq_route_fops))
+	if (!proc_create_seq("x25/route", 0444, init_net.proc_net,
+			 &x25_seq_route_ops))
 		goto out;
 
-	if (!proc_create("x25/socket", 0444, init_net.proc_net,
-			 &x25_seq_socket_fops))
+	if (!proc_create_seq("x25/socket", 0444, init_net.proc_net,
+			 &x25_seq_socket_ops))
 		goto out;
 
-	if (!proc_create("x25/forward", 0444, init_net.proc_net,
-			 &x25_seq_forward_fops))
+	if (!proc_create_seq("x25/forward", 0444, init_net.proc_net,
+			 &x25_seq_forward_ops))
 		goto out;
 	return 0;
 
diff --git a/security/keys/proc.c b/security/keys/proc.c
index fbc4af5c6c9f..5af2934965d8 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -18,7 +18,6 @@
 #include <asm/errno.h>
 #include "internal.h"
 
-static int proc_keys_open(struct inode *inode, struct file *file);
 static void *proc_keys_start(struct seq_file *p, loff_t *_pos);
 static void *proc_keys_next(struct seq_file *p, void *v, loff_t *_pos);
 static void proc_keys_stop(struct seq_file *p, void *v);
@@ -31,14 +30,6 @@ static const struct seq_operations proc_keys_ops = {
 	.show	= proc_keys_show,
 };
 
-static const struct file_operations proc_keys_fops = {
-	.open		= proc_keys_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static int proc_key_users_open(struct inode *inode, struct file *file);
 static void *proc_key_users_start(struct seq_file *p, loff_t *_pos);
 static void *proc_key_users_next(struct seq_file *p, void *v, loff_t *_pos);
 static void proc_key_users_stop(struct seq_file *p, void *v);
@@ -51,13 +42,6 @@ static const struct seq_operations proc_key_users_ops = {
 	.show	= proc_key_users_show,
 };
 
-static const struct file_operations proc_key_users_fops = {
-	.open		= proc_key_users_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 /*
  * Declare the /proc files.
  */
@@ -65,11 +49,11 @@ static int __init key_proc_init(void)
 {
 	struct proc_dir_entry *p;
 
-	p = proc_create("keys", 0, NULL, &proc_keys_fops);
+	p = proc_create_seq("keys", 0, NULL, &proc_keys_ops);
 	if (!p)
 		panic("Cannot create /proc/keys\n");
 
-	p = proc_create("key-users", 0, NULL, &proc_key_users_fops);
+	p = proc_create_seq("key-users", 0, NULL, &proc_key_users_ops);
 	if (!p)
 		panic("Cannot create /proc/key-users\n");
 
@@ -96,11 +80,6 @@ static struct rb_node *key_serial_next(struct seq_file *p, struct rb_node *n)
 	return n;
 }
 
-static int proc_keys_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &proc_keys_ops);
-}
-
 static struct key *find_ge_key(struct seq_file *p, key_serial_t id)
 {
 	struct user_namespace *user_ns = seq_user_ns(p);
@@ -293,15 +272,6 @@ static struct rb_node *key_user_first(struct user_namespace *user_ns, struct rb_
 	return __key_user_next(user_ns, n);
 }
 
-/*
- * Implement "/proc/key-users" to provides a list of the key users and their
- * quotas.
- */
-static int proc_key_users_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &proc_key_users_ops);
-}
-
 static void *proc_key_users_start(struct seq_file *p, loff_t *_pos)
 	__acquires(key_user_lock)
 {
-- 
2.17.0
