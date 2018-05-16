From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/42] proc: introduce proc_create_single{,_data}
Date: Wed, 16 May 2018 11:43:12 +0200
Message-ID: <20180516094346.20506-9-hch@lst.de>
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

Variants of proc_create{,_data} that directly take a seq_file show
callback and drastically reduces the boilerplate code in the callers.

All trivial callers converted over.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm/kernel/dma.c                         | 14 +---
 arch/arm/kernel/swp_emulate.c                 | 15 +---
 arch/arm/mach-rpc/ecard.c                     | 16 +---
 arch/ia64/kernel/palinfo.c                    | 16 +---
 arch/ia64/kernel/salinfo.c                    | 42 ++++------
 arch/ia64/sn/kernel/sn2/prominfo_proc.c       | 32 +-------
 arch/ia64/sn/kernel/sn2/sn_proc_fs.c          | 62 ++------------
 arch/m68k/kernel/setup_mm.c                   | 14 +---
 arch/mips/pci/ops-pmcmsp.c                    | 28 +------
 arch/mips/sibyte/common/bus_watcher.c         | 16 +---
 arch/parisc/kernel/pci-dma.c                  | 17 +---
 arch/parisc/kernel/pdc_chassis.c              | 14 +---
 arch/powerpc/kernel/eeh.c                     | 14 +---
 arch/powerpc/kernel/rtas-proc.c               | 32 +-------
 arch/powerpc/platforms/cell/spufs/sched.c     | 14 +---
 arch/s390/kernel/sysinfo.c                    | 14 +---
 arch/sh/drivers/dma/dma-api.c                 | 14 +---
 arch/sparc/kernel/ioport.c                    | 19 +----
 arch/um/drivers/ubd_kern.c                    | 16 +---
 arch/x86/kernel/apm_32.c                      | 15 +---
 drivers/acpi/ac.c                             | 21 +----
 drivers/acpi/button.c                         | 19 +----
 drivers/block/DAC960.c                        | 49 ++---------
 drivers/block/pktcdvd.c                       | 14 +---
 drivers/block/ps3vram.c                       | 17 +---
 drivers/char/apm-emulation.c                  | 15 +---
 drivers/char/ds1620.c                         | 14 +---
 drivers/char/efirtc.c                         | 15 +---
 drivers/char/nvram.c                          | 15 +---
 drivers/char/rtc.c                            | 19 +----
 drivers/char/toshiba.c                        | 15 +---
 drivers/connector/connector.c                 | 15 +---
 drivers/input/misc/hp_sdc_rtc.c               | 14 +---
 drivers/isdn/capi/capi.c                      | 30 +------
 drivers/isdn/capi/capidrv.c                   | 15 +---
 drivers/isdn/hardware/eicon/diva_didd.c       | 17 +---
 drivers/isdn/hardware/eicon/divasi.c          | 17 +---
 drivers/macintosh/via-pmu.c                   | 57 +++----------
 drivers/media/pci/saa7164/saa7164-core.c      | 14 +---
 drivers/media/pci/zoran/videocodec.c          | 16 +---
 drivers/message/fusion/mptbase.c              | 57 +++----------
 drivers/mtd/mtdcore.c                         | 14 +---
 drivers/net/wireless/atmel/atmel.c            | 15 +---
 .../net/wireless/intersil/hostap/hostap_ap.c  | 16 +---
 drivers/net/wireless/ray_cs.c                 | 15 +---
 drivers/nubus/proc.c                          | 51 ++----------
 drivers/parisc/ccio-dma.c                     | 34 +-------
 drivers/parisc/sba_iommu.c                    | 32 +-------
 drivers/platform/x86/toshiba_acpi.c           | 17 +---
 drivers/pnp/pnpbios/proc.c                    | 78 ++----------------
 drivers/staging/comedi/proc.c                 | 18 +---
 drivers/usb/gadget/udc/at91_udc.c             | 16 +---
 drivers/usb/gadget/udc/fsl_udc_core.c         | 18 +---
 drivers/usb/gadget/udc/goku_udc.c             | 18 +---
 drivers/usb/gadget/udc/omap_udc.c             | 15 +---
 drivers/video/fbdev/via/viafbdev.c            | 17 +---
 fs/cifs/cifs_debug.c                          | 15 +---
 fs/f2fs/sysfs.c                               | 29 ++-----
 fs/filesystems.c                              | 14 +---
 fs/fscache/internal.h                         |  2 +-
 fs/fscache/proc.c                             |  4 +-
 fs/fscache/stats.c                            | 17 +---
 fs/proc/cmdline.c                             | 14 +---
 fs/proc/generic.c                             | 29 +++++++
 fs/proc/internal.h                            |  5 +-
 fs/proc/loadavg.c                             | 14 +---
 fs/proc/meminfo.c                             | 14 +---
 fs/proc/softirqs.c                            | 14 +---
 fs/proc/uptime.c                              | 14 +---
 fs/proc/version.c                             | 14 +---
 fs/reiserfs/procfs.c                          | 16 +---
 fs/xfs/xfs_stats.c                            | 31 +------
 include/linux/proc_fs.h                       | 10 ++-
 kernel/cgroup/cgroup-internal.h               |  2 +-
 kernel/cgroup/cgroup-v1.c                     | 14 +---
 kernel/cgroup/cgroup.c                        |  2 +-
 kernel/dma.c                                  | 14 +---
 kernel/exec_domain.c                          | 14 +---
 kernel/irq/proc.c                             | 82 +++----------------
 kernel/locking/lockdep_proc.c                 | 16 +---
 net/8021q/vlanproc.c                          | 21 +----
 net/ipv4/ipconfig.c                           | 14 +---
 net/ipv4/route.c                              | 15 +---
 net/ipv6/proc.c                               | 17 +---
 net/sched/sch_api.c                           | 14 +---
 85 files changed, 235 insertions(+), 1509 deletions(-)

diff --git a/arch/arm/kernel/dma.c b/arch/arm/kernel/dma.c
index e651c4d0a0d9..6739d37c2bc5 100644
--- a/arch/arm/kernel/dma.c
+++ b/arch/arm/kernel/dma.c
@@ -276,21 +276,9 @@ static int proc_dma_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int proc_dma_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_dma_show, NULL);
-}
-
-static const struct file_operations proc_dma_operations = {
-	.open		= proc_dma_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_dma_init(void)
 {
-	proc_create("dma", 0, NULL, &proc_dma_operations);
+	proc_create_single("dma", 0, NULL, proc_dma_show);
 	return 0;
 }
 
diff --git a/arch/arm/kernel/swp_emulate.c b/arch/arm/kernel/swp_emulate.c
index 3bda08bee674..6e971e114879 100644
--- a/arch/arm/kernel/swp_emulate.c
+++ b/arch/arm/kernel/swp_emulate.c
@@ -91,18 +91,6 @@ static int proc_status_show(struct seq_file *m, void *v)
 		seq_printf(m, "Last process:\t\t%d\n", previous_pid);
 	return 0;
 }
-
-static int proc_status_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_status_show, PDE_DATA(inode));
-}
-
-static const struct file_operations proc_status_fops = {
-	.open		= proc_status_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 /*
@@ -260,7 +248,8 @@ static int __init swp_emulation_init(void)
 		return 0;
 
 #ifdef CONFIG_PROC_FS
-	if (!proc_create("cpu/swp_emulation", S_IRUGO, NULL, &proc_status_fops))
+	if (!proc_create_single("cpu/swp_emulation", S_IRUGO, NULL,
+			proc_status_show))
 		return -ENOMEM;
 #endif /* CONFIG_PROC_FS */
 
diff --git a/arch/arm/mach-rpc/ecard.c b/arch/arm/mach-rpc/ecard.c
index bdb5ec1cf560..39aef4876ed4 100644
--- a/arch/arm/mach-rpc/ecard.c
+++ b/arch/arm/mach-rpc/ecard.c
@@ -657,25 +657,13 @@ static int ecard_devices_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int ecard_devices_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ecard_devices_proc_show, NULL);
-}
-
-static const struct file_operations bus_ecard_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ecard_devices_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static struct proc_dir_entry *proc_bus_ecard_dir = NULL;
 
 static void ecard_proc_init(void)
 {
 	proc_bus_ecard_dir = proc_mkdir("bus/ecard", NULL);
-	proc_create("devices", 0, proc_bus_ecard_dir, &bus_ecard_proc_fops);
+	proc_create_single("devices", 0, proc_bus_ecard_dir,
+			ecard_devices_proc_show);
 }
 
 #define ec_set_resource(ec,nr,st,sz)				\
diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index b6e597860888..f4a94241265c 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -920,18 +920,6 @@ static int proc_palinfo_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int proc_palinfo_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_palinfo_show, PDE_DATA(inode));
-}
-
-static const struct file_operations proc_palinfo_fops = {
-	.open		= proc_palinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int palinfo_add_proc(unsigned int cpu)
 {
 	pal_func_cpu_u_t f;
@@ -948,8 +936,8 @@ static int palinfo_add_proc(unsigned int cpu)
 
 	for (j=0; j < NR_PALINFO_ENTRIES; j++) {
 		f.func_id = j;
-		proc_create_data(palinfo_entries[j].name, 0, cpu_dir,
-				 &proc_palinfo_fops, (void *)f.value);
+		proc_create_single_data(palinfo_entries[j].name, 0, cpu_dir,
+				proc_palinfo_show, (void *)f.value);
 	}
 	return 0;
 }
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index 52c404b08904..aba1f463a8dd 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -54,8 +54,6 @@ MODULE_AUTHOR("Jesse Barnes <jbarnes@sgi.com>");
 MODULE_DESCRIPTION("/proc interface to IA-64 SAL features");
 MODULE_LICENSE("GPL");
 
-static const struct file_operations proc_salinfo_fops;
-
 typedef struct {
 	const char		*name;		/* name of the proc entry */
 	unsigned long           feature;        /* feature bit */
@@ -578,6 +576,17 @@ static int salinfo_cpu_pre_down(unsigned int cpu)
 	return 0;
 }
 
+/*
+ * 'data' contains an integer that corresponds to the feature we're
+ * testing
+ */
+static int proc_salinfo_show(struct seq_file *m, void *v)
+{
+	unsigned long data = (unsigned long)v;
+	seq_puts(m, (sal_platform_features & data) ? "1\n" : "0\n");
+	return 0;
+}
+
 static int __init
 salinfo_init(void)
 {
@@ -593,9 +602,9 @@ salinfo_init(void)
 
 	for (i=0; i < NR_SALINFO_ENTRIES; i++) {
 		/* pass the feature bit in question as misc data */
-		*sdir++ = proc_create_data(salinfo_entries[i].name, 0, salinfo_dir,
-					   &proc_salinfo_fops,
-					   (void *)salinfo_entries[i].feature);
+		*sdir++ = proc_create_single_data(salinfo_entries[i].name, 0,
+				salinfo_dir, proc_salinfo_show,
+				(void *)salinfo_entries[i].feature);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(salinfo_log_name); i++) {
@@ -633,27 +642,4 @@ salinfo_init(void)
 	return 0;
 }
 
-/*
- * 'data' contains an integer that corresponds to the feature we're
- * testing
- */
-static int proc_salinfo_show(struct seq_file *m, void *v)
-{
-	unsigned long data = (unsigned long)v;
-	seq_puts(m, (sal_platform_features & data) ? "1\n" : "0\n");
-	return 0;
-}
-
-static int proc_salinfo_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_salinfo_show, PDE_DATA(inode));
-}
-
-static const struct file_operations proc_salinfo_fops = {
-	.open		= proc_salinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 module_init(salinfo_init);
diff --git a/arch/ia64/sn/kernel/sn2/prominfo_proc.c b/arch/ia64/sn/kernel/sn2/prominfo_proc.c
index ec4de2b09653..e15457bf21ac 100644
--- a/arch/ia64/sn/kernel/sn2/prominfo_proc.c
+++ b/arch/ia64/sn/kernel/sn2/prominfo_proc.c
@@ -140,18 +140,6 @@ static int proc_fit_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int proc_fit_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_fit_show, PDE_DATA(inode));
-}
-
-static const struct file_operations proc_fit_fops = {
-	.open		= proc_fit_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int proc_version_show(struct seq_file *m, void *v)
 {
 	unsigned long nasid = (unsigned long)m->private;
@@ -174,18 +162,6 @@ static int proc_version_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int proc_version_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_version_show, PDE_DATA(inode));
-}
-
-static const struct file_operations proc_version_fops = {
-	.open		= proc_version_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /* module entry points */
 int __init prominfo_init(void);
 void __exit prominfo_exit(void);
@@ -217,10 +193,10 @@ int __init prominfo_init(void)
 		if (!dir)
 			continue;
 		nasid = cnodeid_to_nasid(cnodeid);
-		proc_create_data("fit", 0, dir,
-				 &proc_fit_fops, (void *)nasid);
-		proc_create_data("version", 0, dir,
-				 &proc_version_fops, (void *)nasid);
+		proc_create_single_data("fit", 0, dir, proc_fit_show, 
+				(void *)nasid);
+		proc_create_single_data("version", 0, dir, proc_version_show,
+				(void *)nasid);
 	}
 	return 0;
 }
diff --git a/arch/ia64/sn/kernel/sn2/sn_proc_fs.c b/arch/ia64/sn/kernel/sn2/sn_proc_fs.c
index 29cf8f8c08e9..c2a4d84297b0 100644
--- a/arch/ia64/sn/kernel/sn2/sn_proc_fs.c
+++ b/arch/ia64/sn/kernel/sn2/sn_proc_fs.c
@@ -18,33 +18,18 @@ static int partition_id_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int partition_id_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, partition_id_show, NULL);
-}
-
 static int system_serial_number_show(struct seq_file *s, void *p)
 {
 	seq_printf(s, "%s\n", sn_system_serial_number());
 	return 0;
 }
 
-static int system_serial_number_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, system_serial_number_show, NULL);
-}
-
 static int licenseID_show(struct seq_file *s, void *p)
 {
 	seq_printf(s, "0x%llx\n", sn_partition_serial_number_val());
 	return 0;
 }
 
-static int licenseID_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, licenseID_show, NULL);
-}
-
 static int coherence_id_show(struct seq_file *s, void *p)
 {
 	seq_printf(s, "%d\n", partition_coherence_id());
@@ -52,43 +37,10 @@ static int coherence_id_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int coherence_id_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, coherence_id_show, NULL);
-}
-
 /* /proc/sgi_sn/sn_topology uses seq_file, see sn_hwperf.c */
 extern int sn_topology_open(struct inode *, struct file *);
 extern int sn_topology_release(struct inode *, struct file *);
 
-static const struct file_operations proc_partition_id_fops = {
-	.open		= partition_id_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static const struct file_operations proc_system_sn_fops = {
-	.open		= system_serial_number_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static const struct file_operations proc_license_id_fops = {
-	.open		= licenseID_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static const struct file_operations proc_coherence_id_fops = {
-	.open		= coherence_id_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static const struct file_operations proc_sn_topo_fops = {
 	.open		= sn_topology_open,
 	.read		= seq_read,
@@ -104,13 +56,13 @@ void register_sn_procfs(void)
 	if (!(sgi_proc_dir = proc_mkdir("sgi_sn", NULL)))
 		return;
 
-	proc_create("partition_id", 0444, sgi_proc_dir,
-		    &proc_partition_id_fops);
-	proc_create("system_serial_number", 0444, sgi_proc_dir,
-		    &proc_system_sn_fops);
-	proc_create("licenseID", 0444, sgi_proc_dir, &proc_license_id_fops);
-	proc_create("coherence_id", 0444, sgi_proc_dir,
-		    &proc_coherence_id_fops);
+	proc_create_single("partition_id", 0444, sgi_proc_dir,
+			partition_id_show);
+	proc_create_single("system_serial_number", 0444, sgi_proc_dir,
+			system_serial_number_show);
+	proc_create_single("licenseID", 0444, sgi_proc_dir, licenseID_show);
+	proc_create_single("coherence_id", 0444, sgi_proc_dir,
+			coherence_id_show);
 	proc_create("sn_topology", 0444, sgi_proc_dir, &proc_sn_topo_fops);
 }
 
diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index dd25bfc22fb4..f35e3ebd6331 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -527,21 +527,9 @@ static int hardware_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int hardware_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, hardware_proc_show, NULL);
-}
-
-static const struct file_operations hardware_proc_fops = {
-	.open		= hardware_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_hardware_init(void)
 {
-	proc_create("hardware", 0, NULL, &hardware_proc_fops);
+	proc_create_single("hardware", 0, NULL, hardware_proc_show);
 	return 0;
 }
 module_init(proc_hardware_init);
diff --git a/arch/mips/pci/ops-pmcmsp.c b/arch/mips/pci/ops-pmcmsp.c
index dd2d9f7e9412..7649372103af 100644
--- a/arch/mips/pci/ops-pmcmsp.c
+++ b/arch/mips/pci/ops-pmcmsp.c
@@ -83,18 +83,6 @@ static int show_msp_pci_counts(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int msp_pci_rd_cnt_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, show_msp_pci_counts, NULL);
-}
-
-static const struct file_operations msp_pci_rd_cnt_fops = {
-	.open		= msp_pci_rd_cnt_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /*****************************************************************************
  *
  *  FUNCTION: gen_pci_cfg_wr_show
@@ -160,18 +148,6 @@ static int gen_pci_cfg_wr_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int gen_pci_cfg_wr_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, gen_pci_cfg_wr_show, NULL);
-}
-
-static const struct file_operations gen_pci_cfg_wr_fops = {
-	.open		= gen_pci_cfg_wr_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /*****************************************************************************
  *
  *  FUNCTION: pci_proc_init
@@ -188,8 +164,8 @@ static const struct file_operations gen_pci_cfg_wr_fops = {
  ****************************************************************************/
 static void pci_proc_init(void)
 {
-	proc_create("pmc_msp_pci_rd_cnt", 0, NULL, &msp_pci_rd_cnt_fops);
-	proc_create("pmc_msp_pci_cfg_wr", 0, NULL, &gen_pci_cfg_wr_fops);
+	proc_create_single("pmc_msp_pci_rd_cnt", 0, NULL, show_msp_pci_counts);
+	proc_create_single("pmc_msp_pci_cfg_wr", 0, NULL, gen_pci_cfg_wr_show);
 }
 #endif /* CONFIG_PROC_FS && PCI_COUNTERS */
 
diff --git a/arch/mips/sibyte/common/bus_watcher.c b/arch/mips/sibyte/common/bus_watcher.c
index a4e55999ecb4..4bb85de9229b 100644
--- a/arch/mips/sibyte/common/bus_watcher.c
+++ b/arch/mips/sibyte/common/bus_watcher.c
@@ -142,24 +142,12 @@ static int bw_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int bw_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, bw_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations bw_proc_fops = {
-	.open		= bw_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static void create_proc_decoder(struct bw_stats_struct *stats)
 {
 	struct proc_dir_entry *ent;
 
-	ent = proc_create_data("bus_watcher", S_IWUSR | S_IRUGO, NULL,
-			       &bw_proc_fops, stats);
+	ent = proc_create_single_data("bus_watcher", S_IWUSR | S_IRUGO, NULL,
+			bw_proc_show, stats);
 	if (!ent) {
 		printk(KERN_INFO "Unable to initialize bus_watcher /proc entry\n");
 		return;
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 91bc0cac03a1..6df07ce4f3c2 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -367,19 +367,6 @@ static int proc_pcxl_dma_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int proc_pcxl_dma_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_pcxl_dma_show, NULL);
-}
-
-static const struct file_operations proc_pcxl_dma_ops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_pcxl_dma_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init
 pcxl_dma_init(void)
 {
@@ -397,8 +384,8 @@ pcxl_dma_init(void)
 			"pcxl_dma_init: Unable to create gsc /proc dir entry\n");
 	else {
 		struct proc_dir_entry* ent;
-		ent = proc_create("pcxl_dma", 0, proc_gsc_root,
-				  &proc_pcxl_dma_ops);
+		ent = proc_create_single("pcxl_dma", 0, proc_gsc_root,
+				proc_pcxl_dma_show);
 		if (!ent)
 			printk(KERN_WARNING
 				"pci-dma.c: Unable to create pcxl_dma /proc entry.\n");
diff --git a/arch/parisc/kernel/pdc_chassis.c b/arch/parisc/kernel/pdc_chassis.c
index 3e04242de5a7..28e07482b0f1 100644
--- a/arch/parisc/kernel/pdc_chassis.c
+++ b/arch/parisc/kernel/pdc_chassis.c
@@ -266,18 +266,6 @@ static int pdc_chassis_warn_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int pdc_chassis_warn_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pdc_chassis_warn_show, NULL);
-}
-
-static const struct file_operations pdc_chassis_warn_fops = {
-	.open		= pdc_chassis_warn_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init pdc_chassis_create_procfs(void)
 {
 	unsigned long test;
@@ -292,7 +280,7 @@ static int __init pdc_chassis_create_procfs(void)
 
 	printk(KERN_INFO "Enabling PDC chassis warnings support v%s\n",
 			PDC_CHASSIS_VER);
-	proc_create("chassis", 0400, NULL, &pdc_chassis_warn_fops);
+	proc_create_single("chassis", 0400, NULL, pdc_chassis_warn_show);
 	return 0;
 }
 
diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index bc640e4c5ca5..90bb39b1a23c 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1775,18 +1775,6 @@ static int proc_eeh_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int proc_eeh_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_eeh_show, NULL);
-}
-
-static const struct file_operations proc_eeh_operations = {
-	.open      = proc_eeh_open,
-	.read      = seq_read,
-	.llseek    = seq_lseek,
-	.release   = single_release,
-};
-
 #ifdef CONFIG_DEBUG_FS
 static int eeh_enable_dbgfs_set(void *data, u64 val)
 {
@@ -1828,7 +1816,7 @@ DEFINE_SIMPLE_ATTRIBUTE(eeh_freeze_dbgfs_ops, eeh_freeze_dbgfs_get,
 static int __init eeh_init_proc(void)
 {
 	if (machine_is(pseries) || machine_is(powernv)) {
-		proc_create("powerpc/eeh", 0, NULL, &proc_eeh_operations);
+		proc_create_single("powerpc/eeh", 0, NULL, proc_eeh_show);
 #ifdef CONFIG_DEBUG_FS
 		debugfs_create_file("eeh_enable", 0600,
                                     powerpc_debugfs_root, NULL,
diff --git a/arch/powerpc/kernel/rtas-proc.c b/arch/powerpc/kernel/rtas-proc.c
index fb070d8cad07..d49063d0baa4 100644
--- a/arch/powerpc/kernel/rtas-proc.c
+++ b/arch/powerpc/kernel/rtas-proc.c
@@ -154,18 +154,6 @@ static ssize_t ppc_rtas_tone_volume_write(struct file *file,
 static int ppc_rtas_tone_volume_show(struct seq_file *m, void *v);
 static int ppc_rtas_rmo_buf_show(struct seq_file *m, void *v);
 
-static int sensors_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ppc_rtas_sensors_show, NULL);
-}
-
-static const struct file_operations ppc_rtas_sensors_operations = {
-	.open		= sensors_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int poweron_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, ppc_rtas_poweron_show, NULL);
@@ -231,18 +219,6 @@ static const struct file_operations ppc_rtas_tone_volume_operations = {
 	.release	= single_release,
 };
 
-static int rmo_buf_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ppc_rtas_rmo_buf_show, NULL);
-}
-
-static const struct file_operations ppc_rtas_rmo_buf_ops = {
-	.open		= rmo_buf_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int ppc_rtas_find_all_sensors(void);
 static void ppc_rtas_process_sensor(struct seq_file *m,
 	struct individual_sensor *s, int state, int error, const char *loc);
@@ -267,14 +243,14 @@ static int __init proc_rtas_init(void)
 		    &ppc_rtas_clock_operations);
 	proc_create("powerpc/rtas/poweron", 0644, NULL,
 		    &ppc_rtas_poweron_operations);
-	proc_create("powerpc/rtas/sensors", 0444, NULL,
-		    &ppc_rtas_sensors_operations);
+	proc_create_single("powerpc/rtas/sensors", 0444, NULL,
+			ppc_rtas_sensors_show);
 	proc_create("powerpc/rtas/frequency", 0644, NULL,
 		    &ppc_rtas_tone_freq_operations);
 	proc_create("powerpc/rtas/volume", 0644, NULL,
 		    &ppc_rtas_tone_volume_operations);
-	proc_create("powerpc/rtas/rmo_buffer", 0400, NULL,
-		    &ppc_rtas_rmo_buf_ops);
+	proc_create_single("powerpc/rtas/rmo_buffer", 0400, NULL,
+			ppc_rtas_rmo_buf_show);
 	return 0;
 }
 
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index ccc421503363..c9ef3c532169 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -1095,18 +1095,6 @@ static int show_spu_loadavg(struct seq_file *s, void *private)
 		atomic_read(&nr_spu_contexts),
 		idr_get_cursor(&task_active_pid_ns(current)->idr) - 1);
 	return 0;
-}
-
-static int spu_loadavg_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, show_spu_loadavg, NULL);
-}
-
-static const struct file_operations spu_loadavg_fops = {
-	.open		= spu_loadavg_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
 };
 
 int __init spu_sched_init(void)
@@ -1135,7 +1123,7 @@ int __init spu_sched_init(void)
 
 	mod_timer(&spuloadavg_timer, 0);
 
-	entry = proc_create("spu_loadavg", 0, NULL, &spu_loadavg_fops);
+	entry = proc_create_single("spu_loadavg", 0, NULL, show_spu_loadavg);
 	if (!entry)
 		goto out_stop_kthread;
 
diff --git a/arch/s390/kernel/sysinfo.c b/arch/s390/kernel/sysinfo.c
index fed49601f06d..54f5496913fa 100644
--- a/arch/s390/kernel/sysinfo.c
+++ b/arch/s390/kernel/sysinfo.c
@@ -294,21 +294,9 @@ static int sysinfo_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int sysinfo_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, sysinfo_show, NULL);
-}
-
-static const struct file_operations sysinfo_fops = {
-	.open		= sysinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init sysinfo_create_proc(void)
 {
-	proc_create("sysinfo", 0444, NULL, &sysinfo_fops);
+	proc_create_single("sysinfo", 0444, NULL, sysinfo_show);
 	return 0;
 }
 device_initcall(sysinfo_create_proc);
diff --git a/arch/sh/drivers/dma/dma-api.c b/arch/sh/drivers/dma/dma-api.c
index c0eec08d8f95..b05be597b19f 100644
--- a/arch/sh/drivers/dma/dma-api.c
+++ b/arch/sh/drivers/dma/dma-api.c
@@ -339,18 +339,6 @@ static int dma_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int dma_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dma_proc_show, NULL);
-}
-
-static const struct file_operations dma_proc_fops = {
-	.open		= dma_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 int register_dmac(struct dma_info *info)
 {
 	unsigned int total_channels, i;
@@ -423,7 +411,7 @@ EXPORT_SYMBOL(unregister_dmac);
 static int __init dma_api_init(void)
 {
 	printk(KERN_NOTICE "DMA: Registering DMA API.\n");
-	return proc_create("dma", 0, NULL, &dma_proc_fops) ? 0 : -ENOMEM;
+	return proc_create_single("dma", 0, NULL, dma_proc_show) ? 0 : -ENOMEM;
 }
 subsys_initcall(dma_api_init);
 
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 3bcef9ce74df..cca9134cfa7d 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -678,25 +678,14 @@ static int sparc_io_proc_show(struct seq_file *m, void *v)
 
 	return 0;
 }
-
-static int sparc_io_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, sparc_io_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations sparc_io_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= sparc_io_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif /* CONFIG_PROC_FS */
 
 static void register_proc_sparc_ioport(void)
 {
 #ifdef CONFIG_PROC_FS
-	proc_create_data("io_map", 0, NULL, &sparc_io_proc_fops, &sparc_iomap);
-	proc_create_data("dvma_map", 0, NULL, &sparc_io_proc_fops, &_sparc_dvma);
+	proc_create_single_data("io_map", 0, NULL, sparc_io_proc_show,
+			&sparc_iomap);
+	proc_create_single_data("dvma_map", 0, NULL, sparc_io_proc_show,
+			&_sparc_dvma);
 #endif
 }
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index d4e8c497ae86..dcf5ea28a281 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -208,19 +208,6 @@ static int fake_ide_media_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int fake_ide_media_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, fake_ide_media_proc_show, NULL);
-}
-
-static const struct file_operations fake_ide_media_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= fake_ide_media_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static void make_ide_entries(const char *dev_name)
 {
 	struct proc_dir_entry *dir, *ent;
@@ -231,7 +218,8 @@ static void make_ide_entries(const char *dev_name)
 	dir = proc_mkdir(dev_name, proc_ide);
 	if(!dir) return;
 
-	ent = proc_create("media", S_IRUGO, dir, &fake_ide_media_proc_fops);
+	ent = proc_create_single("media", S_IRUGO, dir,
+			fake_ide_media_proc_show);
 	if(!ent) return;
 	snprintf(name, sizeof(name), "ide0/%s", dev_name);
 	proc_symlink(dev_name, proc_ide_root, name);
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index dfcbe6924eaf..cadeafabf167 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1715,19 +1715,6 @@ static int proc_apm_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int proc_apm_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_apm_show, NULL);
-}
-
-static const struct file_operations apm_file_ops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_apm_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int apm(void *unused)
 {
 	unsigned short	bx;
@@ -2360,7 +2347,7 @@ static int __init apm_init(void)
 	set_desc_base(&gdt[APM_DS >> 3],
 		 (unsigned long)__va((unsigned long)apm_info.bios.dseg << 4));
 
-	proc_create("apm", 0, NULL, &apm_file_ops);
+	proc_create_single("apm", 0, NULL, proc_apm_show);
 
 	kapmd_task = kthread_create(apm, NULL, "kapmd");
 	if (IS_ERR(kapmd_task)) {
diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 2d8de2f8c1ed..84fdfa70920a 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -82,7 +82,6 @@ static SIMPLE_DEV_PM_OPS(acpi_ac_pm, NULL, acpi_ac_resume);
 #ifdef CONFIG_ACPI_PROCFS_POWER
 extern struct proc_dir_entry *acpi_lock_ac_dir(void);
 extern void *acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir);
-static int acpi_ac_open_fs(struct inode *inode, struct file *file);
 #endif
 
 
@@ -111,16 +110,6 @@ struct acpi_ac {
 
 #define to_acpi_ac(x) power_supply_get_drvdata(x)
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-static const struct file_operations acpi_ac_fops = {
-	.owner = THIS_MODULE,
-	.open = acpi_ac_open_fs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-#endif
-
 /* --------------------------------------------------------------------------
                                AC Adapter Management
    -------------------------------------------------------------------------- */
@@ -209,11 +198,6 @@ static int acpi_ac_seq_show(struct seq_file *seq, void *offset)
 	return 0;
 }
 
-static int acpi_ac_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_ac_seq_show, PDE_DATA(inode));
-}
-
 static int acpi_ac_add_fs(struct acpi_ac *ac)
 {
 	struct proc_dir_entry *entry = NULL;
@@ -228,9 +212,8 @@ static int acpi_ac_add_fs(struct acpi_ac *ac)
 	}
 
 	/* 'state' [R] */
-	entry = proc_create_data(ACPI_AC_FILE_STATE,
-				 S_IRUGO, acpi_device_dir(ac->device),
-				 &acpi_ac_fops, ac);
+	entry = proc_create_single_data(ACPI_AC_FILE_STATE, S_IRUGO,
+			acpi_device_dir(ac->device), acpi_ac_seq_show, ac);
 	if (!entry)
 		return -ENODEV;
 	return 0;
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index f1cc4f9d31cd..2345a5ee2dbb 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -263,19 +263,6 @@ static int acpi_button_state_seq_show(struct seq_file *seq, void *offset)
 	return 0;
 }
 
-static int acpi_button_state_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_button_state_seq_show, PDE_DATA(inode));
-}
-
-static const struct file_operations acpi_button_state_fops = {
-	.owner = THIS_MODULE,
-	.open = acpi_button_state_open_fs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 static int acpi_button_add_fs(struct acpi_device *device)
 {
 	struct acpi_button *button = acpi_driver_data(device);
@@ -311,9 +298,9 @@ static int acpi_button_add_fs(struct acpi_device *device)
 	}
 
 	/* create /proc/acpi/button/lid/LID/state */
-	entry = proc_create_data(ACPI_BUTTON_FILE_STATE,
-				 S_IRUGO, acpi_device_dir(device),
-				 &acpi_button_state_fops, device);
+	entry = proc_create_single_data(ACPI_BUTTON_FILE_STATE, S_IRUGO,
+			acpi_device_dir(device), acpi_button_state_seq_show,
+			device);
 	if (!entry) {
 		ret = -ENODEV;
 		goto remove_dev_dir;
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index f781eff7d23e..6918c3d9482e 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6451,19 +6451,6 @@ static int dac960_proc_show(struct seq_file *m, void *v)
   return 0;
 }
 
-static int dac960_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dac960_proc_show, NULL);
-}
-
-static const struct file_operations dac960_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= dac960_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int dac960_initial_status_proc_show(struct seq_file *m, void *v)
 {
 	DAC960_Controller_T *Controller = (DAC960_Controller_T *)m->private;
@@ -6471,19 +6458,6 @@ static int dac960_initial_status_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int dac960_initial_status_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dac960_initial_status_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations dac960_initial_status_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= dac960_initial_status_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int dac960_current_status_proc_show(struct seq_file *m, void *v)
 {
   DAC960_Controller_T *Controller = (DAC960_Controller_T *) m->private;
@@ -6517,19 +6491,6 @@ static int dac960_current_status_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int dac960_current_status_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dac960_current_status_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations dac960_current_status_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= dac960_current_status_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int dac960_user_command_proc_show(struct seq_file *m, void *v)
 {
 	DAC960_Controller_T *Controller = (DAC960_Controller_T *)m->private;
@@ -6584,16 +6545,18 @@ static void DAC960_CreateProcEntries(DAC960_Controller_T *Controller)
 
 	if (DAC960_ProcDirectoryEntry == NULL) {
 		DAC960_ProcDirectoryEntry = proc_mkdir("rd", NULL);
-		proc_create("status", 0, DAC960_ProcDirectoryEntry,
-			    &dac960_proc_fops);
+		proc_create_single("status", 0, DAC960_ProcDirectoryEntry,
+				dac960_proc_show);
 	}
 
 	snprintf(Controller->ControllerName, sizeof(Controller->ControllerName),
 		 "c%d", Controller->ControllerNumber);
 	ControllerProcEntry = proc_mkdir(Controller->ControllerName,
 					 DAC960_ProcDirectoryEntry);
-	proc_create_data("initial_status", 0, ControllerProcEntry, &dac960_initial_status_proc_fops, Controller);
-	proc_create_data("current_status", 0, ControllerProcEntry, &dac960_current_status_proc_fops, Controller);
+	proc_create_single_data("initial_status", 0, ControllerProcEntry,
+			dac960_initial_status_proc_show, Controller);
+	proc_create_single_data("current_status", 0, ControllerProcEntry,
+			dac960_current_status_proc_show, Controller);
 	proc_create_data("user_command", S_IWUSR | S_IRUSR, ControllerProcEntry, &dac960_user_command_proc_fops, Controller);
 	Controller->ControllerProcEntry = ControllerProcEntry;
 }
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index c61d20c9f3f8..8dce5c04dbf2 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2538,18 +2538,6 @@ static int pkt_seq_show(struct seq_file *m, void *p)
 	return 0;
 }
 
-static int pkt_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pkt_seq_show, PDE_DATA(inode));
-}
-
-static const struct file_operations pkt_proc_fops = {
-	.open	= pkt_seq_open,
-	.read	= seq_read,
-	.llseek	= seq_lseek,
-	.release = single_release
-};
-
 static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 {
 	int i;
@@ -2604,7 +2592,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 		goto out_mem;
 	}
 
-	proc_create_data(pd->name, 0, pkt_proc, &pkt_proc_fops, pd);
+	proc_create_single_data(pd->name, 0, pkt_proc, pkt_seq_show, pd);
 	pkt_dbg(1, pd, "writer mapped to %s\n", bdevname(bdev, b));
 	return 0;
 
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 6a55959cbf78..8fa4533a1249 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -521,26 +521,13 @@ static int ps3vram_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int ps3vram_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ps3vram_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations ps3vram_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ps3vram_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static void ps3vram_proc_init(struct ps3_system_bus_device *dev)
 {
 	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
 	struct proc_dir_entry *pde;
 
-	pde = proc_create_data(DEVICE_NAME, 0444, NULL, &ps3vram_proc_fops,
-			       priv);
+	pde = proc_create_single_data(DEVICE_NAME, 0444, NULL,
+			ps3vram_proc_show, priv);
 	if (!pde)
 		dev_warn(&dev->core, "failed to create /proc entry\n");
 }
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index a5e2f9e557ea..53436c03dbce 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -461,19 +461,6 @@ static int proc_apm_show(struct seq_file *m, void *v)
 
 	return 0;
 }
-
-static int proc_apm_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_apm_show, NULL);
-}
-
-static const struct file_operations apm_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_apm_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 static int kapmd(void *arg)
@@ -657,7 +644,7 @@ static int __init apm_init(void)
 	wake_up_process(kapmd_tsk);
 
 #ifdef CONFIG_PROC_FS
-	proc_create("apm", 0, NULL, &apm_proc_fops);
+	proc_create_single("apm", 0, NULL, proc_apm_show);
 #endif
 
 	ret = misc_register(&apm_device);
diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index eb53cbadb68f..a5ecf6dae02e 100644
--- a/drivers/char/ds1620.c
+++ b/drivers/char/ds1620.c
@@ -345,18 +345,6 @@ static int ds1620_proc_therm_show(struct seq_file *m, void *v)
 		   fan_state[netwinder_get_fan()]);
 	return 0;
 }
-
-static int ds1620_proc_therm_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ds1620_proc_therm_show, NULL);
-}
-
-static const struct file_operations ds1620_proc_therm_fops = {
-	.open		= ds1620_proc_therm_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 static const struct file_operations ds1620_fops = {
@@ -404,7 +392,7 @@ static int __init ds1620_init(void)
 		return ret;
 
 #ifdef THERM_USE_PROC
-	if (!proc_create("therm", 0, NULL, &ds1620_proc_therm_fops))
+	if (!proc_create_single("therm", 0, NULL, ds1620_proc_therm_show))
 		printk(KERN_ERR "therm: unable to register /proc/therm\n");
 #endif
 
diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index dc62568b7dde..d9aab643997e 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -358,19 +358,6 @@ static int efi_rtc_proc_show(struct seq_file *m, void *v)
 
 	return 0;
 }
-
-static int efi_rtc_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, efi_rtc_proc_show, NULL);
-}
-
-static const struct file_operations efi_rtc_proc_fops = {
-	.open		= efi_rtc_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init 
 efi_rtc_init(void)
 {
@@ -386,7 +373,7 @@ efi_rtc_init(void)
 		return ret;
 	}
 
-	dir = proc_create("driver/efirtc", 0, NULL, &efi_rtc_proc_fops);
+	dir = proc_create_single("driver/efirtc", 0, NULL, efi_rtc_proc_show);
 	if (dir == NULL) {
 		printk(KERN_ERR "efirtc: can't create /proc/driver/efirtc.\n");
 		misc_deregister(&efi_rtc_dev);
diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 678fa97e41fb..25264d65e716 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -389,22 +389,9 @@ static int nvram_proc_read(struct seq_file *seq, void *offset)
 	return 0;
 }
 
-static int nvram_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, nvram_proc_read, NULL);
-}
-
-static const struct file_operations nvram_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= nvram_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int nvram_add_proc_fs(void)
 {
-	if (!proc_create("driver/nvram", 0, NULL, &nvram_proc_fops))
+	if (!proc_create_single("driver/nvram", 0, NULL, nvram_proc_read))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 57dc546628b5..94fedeeec035 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -171,7 +171,7 @@ static void mask_rtc_irq_bit(unsigned char bit)
 #endif
 
 #ifdef CONFIG_PROC_FS
-static int rtc_proc_open(struct inode *inode, struct file *file);
+static int rtc_proc_show(struct seq_file *seq, void *v);
 #endif
 
 /*
@@ -832,16 +832,6 @@ static struct miscdevice rtc_dev = {
 	.fops		= &rtc_fops,
 };
 
-#ifdef CONFIG_PROC_FS
-static const struct file_operations rtc_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= rtc_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-#endif
-
 static resource_size_t rtc_size;
 
 static struct resource * __init rtc_request_region(resource_size_t size)
@@ -982,7 +972,7 @@ static int __init rtc_init(void)
 	}
 
 #ifdef CONFIG_PROC_FS
-	ent = proc_create("driver/rtc", 0, NULL, &rtc_proc_fops);
+	ent = proc_create_single("driver/rtc", 0, NULL, rtc_proc_show);
 	if (!ent)
 		printk(KERN_WARNING "rtc: Failed to register with procfs.\n");
 #endif
@@ -1201,11 +1191,6 @@ static int rtc_proc_show(struct seq_file *seq, void *v)
 #undef YN
 #undef NY
 }
-
-static int rtc_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, rtc_proc_show, NULL);
-}
 #endif
 
 static void rtc_get_rtc_time(struct rtc_time *rtc_tm)
diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index 5488516da8ea..802376fe851a 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -326,19 +326,6 @@ static int proc_toshiba_show(struct seq_file *m, void *v)
 		key);
 	return 0;
 }
-
-static int proc_toshiba_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_toshiba_show, NULL);
-}
-
-static const struct file_operations proc_toshiba_fops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_toshiba_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 
@@ -524,7 +511,7 @@ static int __init toshiba_init(void)
 	{
 		struct proc_dir_entry *pde;
 
-		pde = proc_create("toshiba", 0, NULL, &proc_toshiba_fops);
+		pde = proc_create_single("toshiba", 0, NULL, proc_toshiba_show);
 		if (!pde) {
 			misc_deregister(&tosh_device);
 			return -ENOMEM;
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 8615594bd065..e718b8c69a56 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -260,19 +260,6 @@ static int cn_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int cn_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, cn_proc_show, NULL);
-}
-
-static const struct file_operations cn_file_ops = {
-	.owner   = THIS_MODULE,
-	.open    = cn_proc_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = single_release
-};
-
 static struct cn_dev cdev = {
 	.input   = cn_rx_skb,
 };
@@ -297,7 +284,7 @@ static int cn_init(void)
 
 	cn_already_initialized = 1;
 
-	proc_create("connector", S_IRUGO, init_net.proc_net, &cn_file_ops);
+	proc_create_single("connector", S_IRUGO, init_net.proc_net, cn_proc_show);
 
 	return 0;
 }
diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index 49b34de0aed4..47eb8ca729fe 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -509,18 +509,6 @@ static int hp_sdc_rtc_proc_show(struct seq_file *m, void *v)
 #undef NY
 }
 
-static int hp_sdc_rtc_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, hp_sdc_rtc_proc_show, NULL);
-}
-
-static const struct file_operations hp_sdc_rtc_proc_fops = {
-	.open		= hp_sdc_rtc_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int hp_sdc_rtc_ioctl(struct file *file, 
 			    unsigned int cmd, unsigned long arg)
 {
@@ -713,7 +701,7 @@ static int __init hp_sdc_rtc_init(void)
 	if (misc_register(&hp_sdc_rtc_dev) != 0)
 		printk(KERN_INFO "Could not register misc. dev for i8042 rtc\n");
 
-        proc_create("driver/rtc", 0, NULL, &hp_sdc_rtc_proc_fops);
+        proc_create_single("driver/rtc", 0, NULL, hp_sdc_rtc_proc_show);
 
 	printk(KERN_INFO "HP i8042 SDC + MSM-58321 RTC support loaded "
 			 "(RTC v " RTC_VERSION ")\n");
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 19cd93783c87..baa1ee2bc2ac 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1340,19 +1340,6 @@ static int capi20_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int capi20_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, capi20_proc_show, NULL);
-}
-
-static const struct file_operations capi20_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= capi20_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /*
  * /proc/capi/capi20ncci:
  *  applid ncci
@@ -1373,23 +1360,10 @@ static int capi20ncci_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int capi20ncci_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, capi20ncci_proc_show, NULL);
-}
-
-static const struct file_operations capi20ncci_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= capi20ncci_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static void __init proc_init(void)
 {
-	proc_create("capi/capi20", 0, NULL, &capi20_proc_fops);
-	proc_create("capi/capi20ncci", 0, NULL, &capi20ncci_proc_fops);
+	proc_create_single("capi/capi20", 0, NULL, capi20_proc_show);
+	proc_create_single("capi/capi20ncci", 0, NULL, capi20ncci_proc_show);
 }
 
 static void __exit proc_exit(void)
diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 49fef08858c5..7ac51798949d 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -2460,22 +2460,9 @@ static int capidrv_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int capidrv_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, capidrv_proc_show, NULL);
-}
-
-static const struct file_operations capidrv_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= capidrv_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static void __init proc_init(void)
 {
-	proc_create("capi/capidrv", 0, NULL, &capidrv_proc_fops);
+	proc_create_single("capi/capidrv", 0, NULL, capidrv_proc_show);
 }
 
 static void __exit proc_exit(void)
diff --git a/drivers/isdn/hardware/eicon/diva_didd.c b/drivers/isdn/hardware/eicon/diva_didd.c
index fab6ccfb00d5..60e79257dd5f 100644
--- a/drivers/isdn/hardware/eicon/diva_didd.c
+++ b/drivers/isdn/hardware/eicon/diva_didd.c
@@ -78,26 +78,13 @@ static int divadidd_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int divadidd_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, divadidd_proc_show, NULL);
-}
-
-static const struct file_operations divadidd_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= divadidd_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init create_proc(void)
 {
 	proc_net_eicon = proc_mkdir("eicon", init_net.proc_net);
 
 	if (proc_net_eicon) {
-		proc_didd = proc_create(DRIVERLNAME, S_IRUGO, proc_net_eicon,
-					&divadidd_proc_fops);
+		proc_didd = proc_create_single(DRIVERLNAME, S_IRUGO,
+				proc_net_eicon, divadidd_proc_show);
 		return (1);
 	}
 	return (0);
diff --git a/drivers/isdn/hardware/eicon/divasi.c b/drivers/isdn/hardware/eicon/divasi.c
index 525518c945fe..e7081e0c0e35 100644
--- a/drivers/isdn/hardware/eicon/divasi.c
+++ b/drivers/isdn/hardware/eicon/divasi.c
@@ -101,23 +101,10 @@ static int um_idi_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int um_idi_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, um_idi_proc_show, NULL);
-}
-
-static const struct file_operations um_idi_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= um_idi_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init create_um_idi_proc(void)
 {
-	um_idi_proc_entry = proc_create(DRIVERLNAME, S_IRUGO, proc_net_eicon,
-					&um_idi_proc_fops);
+	um_idi_proc_entry = proc_create_single(DRIVERLNAME, S_IRUGO,
+			proc_net_eicon, um_idi_proc_show);
 	if (!um_idi_proc_entry)
 		return (0);
 	return (1);
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 433dbeddfcf9..6663893f41c4 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -191,10 +191,10 @@ static int init_pmu(void);
 static void pmu_start(void);
 static irqreturn_t via_pmu_interrupt(int irq, void *arg);
 static irqreturn_t gpio1_interrupt(int irq, void *arg);
-static const struct file_operations pmu_info_proc_fops;
-static const struct file_operations pmu_irqstats_proc_fops;
+static int pmu_info_proc_show(struct seq_file *m, void *v);
+static int pmu_irqstats_proc_show(struct seq_file *m, void *v);
+static int pmu_battery_proc_show(struct seq_file *m, void *v);
 static void pmu_pass_intr(unsigned char *data, int len);
-static const struct file_operations pmu_battery_proc_fops;
 static const struct file_operations pmu_options_proc_fops;
 
 #ifdef CONFIG_ADB
@@ -511,13 +511,15 @@ static int __init via_pmu_dev_init(void)
 		for (i=0; i<pmu_battery_count; i++) {
 			char title[16];
 			sprintf(title, "battery_%ld", i);
-			proc_pmu_batt[i] = proc_create_data(title, 0, proc_pmu_root,
-					&pmu_battery_proc_fops, (void *)i);
+			proc_pmu_batt[i] = proc_create_single_data(title, 0,
+					proc_pmu_root, pmu_battery_proc_show,
+					(void *)i);
 		}
 
-		proc_pmu_info = proc_create("info", 0, proc_pmu_root, &pmu_info_proc_fops);
-		proc_pmu_irqstats = proc_create("interrupts", 0, proc_pmu_root,
-						&pmu_irqstats_proc_fops);
+		proc_pmu_info = proc_create_single("info", 0, proc_pmu_root,
+				pmu_info_proc_show);
+		proc_pmu_irqstats = proc_create_single("interrupts", 0,
+				proc_pmu_root, pmu_irqstats_proc_show);
 		proc_pmu_options = proc_create("options", 0600, proc_pmu_root,
 						&pmu_options_proc_fops);
 	}
@@ -811,19 +813,6 @@ static int pmu_info_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int pmu_info_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pmu_info_proc_show, NULL);
-}
-
-static const struct file_operations pmu_info_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pmu_info_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int pmu_irqstats_proc_show(struct seq_file *m, void *v)
 {
 	int i;
@@ -848,19 +837,6 @@ static int pmu_irqstats_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int pmu_irqstats_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pmu_irqstats_proc_show, NULL);
-}
-
-static const struct file_operations pmu_irqstats_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pmu_irqstats_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int pmu_battery_proc_show(struct seq_file *m, void *v)
 {
 	long batnum = (long)m->private;
@@ -875,19 +851,6 @@ static int pmu_battery_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int pmu_battery_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pmu_battery_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations pmu_battery_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pmu_battery_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int pmu_options_proc_show(struct seq_file *m, void *v)
 {
 #if defined(CONFIG_SUSPEND) && defined(CONFIG_PPC32)
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index fca36a4910c2..d697e1ad929c 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1122,23 +1122,11 @@ static int saa7164_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int saa7164_proc_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, saa7164_proc_show, NULL);
-}
-
-static const struct file_operations saa7164_proc_fops = {
-	.open		= saa7164_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int saa7164_proc_create(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("saa7164", S_IRUGO, NULL, &saa7164_proc_fops);
+	pe = proc_create_single("saa7164", S_IRUGO, NULL, saa7164_proc_show);
 	if (!pe)
 		return -ENOMEM;
 
diff --git a/drivers/media/pci/zoran/videocodec.c b/drivers/media/pci/zoran/videocodec.c
index 5ff23ef89215..4427ae7126e2 100644
--- a/drivers/media/pci/zoran/videocodec.c
+++ b/drivers/media/pci/zoran/videocodec.c
@@ -344,19 +344,6 @@ static int proc_videocodecs_show(struct seq_file *m, void *v)
 
 	return 0;
 }
-
-static int proc_videocodecs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_videocodecs_show, NULL);
-}
-
-static const struct file_operations videocodecs_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_videocodecs_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 /* ===================== */
@@ -373,7 +360,8 @@ videocodec_init (void)
 	       VIDEOCODEC_VERSION);
 
 #ifdef CONFIG_PROC_FS
-	videocodec_proc_entry = proc_create("videocodecs", 0, NULL, &videocodecs_proc_fops);
+	videocodec_proc_entry = proc_create_single("videocodecs", 0, NULL,
+			proc_videocodecs_show);
 	if (!videocodec_proc_entry) {
 		dprintk(1, KERN_ERR "videocodec: can't init procfs.\n");
 	}
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 51eb1b027963..a746ccdd630a 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -197,9 +197,9 @@ static int	mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_valu
 static int	mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init);
 
 #ifdef CONFIG_PROC_FS
-static const struct file_operations mpt_summary_proc_fops;
-static const struct file_operations mpt_version_proc_fops;
-static const struct file_operations mpt_iocinfo_proc_fops;
+static int mpt_summary_proc_show(struct seq_file *m, void *v);
+static int mpt_version_proc_show(struct seq_file *m, void *v);
+static int mpt_iocinfo_proc_show(struct seq_file *m, void *v);
 #endif
 static void	mpt_get_fw_exp_ver(char *buf, MPT_ADAPTER *ioc);
 
@@ -2040,8 +2040,10 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	dent = proc_mkdir(ioc->name, mpt_proc_root_dir);
 	if (dent) {
-		proc_create_data("info", S_IRUGO, dent, &mpt_iocinfo_proc_fops, ioc);
-		proc_create_data("summary", S_IRUGO, dent, &mpt_summary_proc_fops, ioc);
+		proc_create_single_data("info", S_IRUGO, dent,
+				mpt_iocinfo_proc_show, ioc);
+		proc_create_single_data("summary", S_IRUGO, dent,
+				mpt_summary_proc_show, ioc);
 	}
 #endif
 
@@ -6606,8 +6608,10 @@ procmpt_create(void)
 	if (mpt_proc_root_dir == NULL)
 		return -ENOTDIR;
 
-	proc_create("summary", S_IRUGO, mpt_proc_root_dir, &mpt_summary_proc_fops);
-	proc_create("version", S_IRUGO, mpt_proc_root_dir, &mpt_version_proc_fops);
+	proc_create_single("summary", S_IRUGO, mpt_proc_root_dir,
+			mpt_summary_proc_show);
+	proc_create_single("version", S_IRUGO, mpt_proc_root_dir,
+			mpt_version_proc_show);
 	return 0;
 }
 
@@ -6646,19 +6650,6 @@ static int mpt_summary_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int mpt_summary_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, mpt_summary_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations mpt_summary_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= mpt_summary_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int mpt_version_proc_show(struct seq_file *m, void *v)
 {
 	u8	 cb_idx;
@@ -6701,19 +6692,6 @@ static int mpt_version_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int mpt_version_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, mpt_version_proc_show, NULL);
-}
-
-static const struct file_operations mpt_version_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= mpt_version_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int mpt_iocinfo_proc_show(struct seq_file *m, void *v)
 {
 	MPT_ADAPTER	*ioc = m->private;
@@ -6793,19 +6771,6 @@ static int mpt_iocinfo_proc_show(struct seq_file *m, void *v)
 
 	return 0;
 }
-
-static int mpt_iocinfo_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, mpt_iocinfo_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations mpt_iocinfo_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= mpt_iocinfo_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif		/* CONFIG_PROC_FS } */
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 807d17d863b3..64a1fcaafd9a 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1829,18 +1829,6 @@ static int mtd_proc_show(struct seq_file *m, void *v)
 	mutex_unlock(&mtd_table_mutex);
 	return 0;
 }
-
-static int mtd_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, mtd_proc_show, NULL);
-}
-
-static const struct file_operations mtd_proc_ops = {
-	.open		= mtd_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif /* CONFIG_PROC_FS */
 
 /*====================================================================*/
@@ -1883,7 +1871,7 @@ static int __init init_mtd(void)
 		goto err_bdi;
 	}
 
-	proc_mtd = proc_create("mtd", 0, NULL, &mtd_proc_ops);
+	proc_mtd = proc_create_single("mtd", 0, NULL, mtd_proc_show);
 
 	ret = init_mtdchar();
 	if (ret)
diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index d122386c382b..b01dc34d55af 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -1482,18 +1482,6 @@ static int atmel_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int atmel_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, atmel_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations atmel_proc_fops = {
-	.open		= atmel_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static const struct net_device_ops atmel_netdev_ops = {
 	.ndo_open 		= atmel_open,
 	.ndo_stop		= atmel_close,
@@ -1614,7 +1602,8 @@ struct net_device *init_atmel_card(unsigned short irq, unsigned long port,
 
 	netif_carrier_off(dev);
 
-	if (!proc_create_data("driver/atmel", 0, NULL, &atmel_proc_fops, priv))
+	if (!proc_create_single_data("driver/atmel", 0, NULL, atmel_proc_show,
+			priv))
 		printk(KERN_WARNING "atmel: unable to create /proc entry.\n");
 
 	printk(KERN_INFO "%s: Atmel at76c50x. Version %d.%d. MAC %pM\n",
diff --git a/drivers/net/wireless/intersil/hostap/hostap_ap.c b/drivers/net/wireless/intersil/hostap/hostap_ap.c
index b4dfe1893d18..4f76f81dd3af 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_ap.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_ap.c
@@ -1106,18 +1106,6 @@ static int prism2_sta_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int prism2_sta_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, prism2_sta_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations prism2_sta_proc_fops = {
-	.open		= prism2_sta_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static void handle_add_proc_queue(struct work_struct *work)
 {
 	struct ap_data *ap = container_of(work, struct ap_data,
@@ -1138,9 +1126,9 @@ static void handle_add_proc_queue(struct work_struct *work)
 
 		if (sta) {
 			sprintf(name, "%pM", sta->addr);
-			sta->proc = proc_create_data(
+			sta->proc = proc_create_single_data(
 				name, 0, ap->proc,
-				&prism2_sta_proc_fops, sta);
+				prism2_sta_proc_show, sta);
 
 			atomic_dec(&sta->users);
 		}
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 7f9b16b97ea3..a7e0a17aa7e8 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2663,19 +2663,6 @@ static int ray_cs_proc_show(struct seq_file *m, void *v)
 	}
 	return 0;
 }
-
-static int ray_cs_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ray_cs_proc_show, NULL);
-}
-
-static const struct file_operations ray_cs_proc_fops = {
-	.owner = THIS_MODULE,
-	.open = ray_cs_proc_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
 #endif
 /*===========================================================================*/
 static int build_auth_frame(ray_dev_t *local, UCHAR *dest, int auth_type)
@@ -2814,7 +2801,7 @@ static int __init init_ray_cs(void)
 #ifdef CONFIG_PROC_FS
 	proc_mkdir("driver/ray_cs", NULL);
 
-	proc_create("driver/ray_cs/ray_cs", 0, NULL, &ray_cs_proc_fops);
+	proc_create_single("driver/ray_cs/ray_cs", 0, NULL, ray_cs_proc_show);
 	proc_create("driver/ray_cs/essid", 0200, NULL, &ray_cs_essid_proc_fops);
 	proc_create_data("driver/ray_cs/net_type", 0200, NULL, &int_proc_fops,
 			 &net_type);
diff --git a/drivers/nubus/proc.c b/drivers/nubus/proc.c
index c2e5a7e6bd3e..88e1f9a0faaf 100644
--- a/drivers/nubus/proc.c
+++ b/drivers/nubus/proc.c
@@ -45,18 +45,6 @@ nubus_devices_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int nubus_devices_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, nubus_devices_proc_show, NULL);
-}
-
-static const struct file_operations nubus_devices_proc_fops = {
-	.open		= nubus_devices_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static struct proc_dir_entry *proc_bus_nubus_dir;
 
 /*
@@ -149,18 +137,6 @@ static int nubus_proc_rsrc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int nubus_proc_rsrc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, nubus_proc_rsrc_show, inode);
-}
-
-static const struct file_operations nubus_proc_rsrc_fops = {
-	.open		= nubus_proc_rsrc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 void nubus_proc_add_rsrc_mem(struct proc_dir_entry *procdir,
 			     const struct nubus_dirent *ent,
 			     unsigned int size)
@@ -176,8 +152,8 @@ void nubus_proc_add_rsrc_mem(struct proc_dir_entry *procdir,
 		pde_data = nubus_proc_alloc_pde_data(nubus_dirptr(ent), size);
 	else
 		pde_data = NULL;
-	proc_create_data(name, S_IFREG | 0444, procdir,
-			 &nubus_proc_rsrc_fops, pde_data);
+	proc_create_single_data(name, S_IFREG | 0444, procdir,
+			nubus_proc_rsrc_show, pde_data);
 }
 
 void nubus_proc_add_rsrc(struct proc_dir_entry *procdir,
@@ -190,32 +166,21 @@ void nubus_proc_add_rsrc(struct proc_dir_entry *procdir,
 		return;
 
 	snprintf(name, sizeof(name), "%x", ent->type);
-	proc_create_data(name, S_IFREG | 0444, procdir,
-			 &nubus_proc_rsrc_fops,
-			 nubus_proc_alloc_pde_data(data, 0));
+	proc_create_single_data(name, S_IFREG | 0444, procdir,
+			nubus_proc_rsrc_show,
+			nubus_proc_alloc_pde_data(data, 0));
 }
 
 /*
  * /proc/nubus stuff
  */
 
-static int nubus_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, nubus_proc_show, NULL);
-}
-
-static const struct file_operations nubus_proc_fops = {
-	.open		= nubus_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 void __init nubus_proc_init(void)
 {
-	proc_create("nubus", 0, NULL, &nubus_proc_fops);
+	proc_create_single("nubus", 0, NULL, nubus_proc_show);
 	proc_bus_nubus_dir = proc_mkdir("bus/nubus", NULL);
 	if (!proc_bus_nubus_dir)
 		return;
-	proc_create("devices", 0, proc_bus_nubus_dir, &nubus_devices_proc_fops);
+	proc_create_single("devices", 0, proc_bus_nubus_dir,
+			nubus_devices_proc_show);
 }
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 126cf19e869b..21a3e93417c4 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1108,19 +1108,6 @@ static int ccio_proc_info(struct seq_file *m, void *p)
 	return 0;
 }
 
-static int ccio_proc_info_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, &ccio_proc_info, NULL);
-}
-
-static const struct file_operations ccio_proc_info_fops = {
-	.owner = THIS_MODULE,
-	.open = ccio_proc_info_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 static int ccio_proc_bitmap_info(struct seq_file *m, void *p)
 {
 	struct ioc *ioc = ioc_list;
@@ -1135,19 +1122,6 @@ static int ccio_proc_bitmap_info(struct seq_file *m, void *p)
 
 	return 0;
 }
-
-static int ccio_proc_bitmap_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, &ccio_proc_bitmap_info, NULL);
-}
-
-static const struct file_operations ccio_proc_bitmap_fops = {
-	.owner = THIS_MODULE,
-	.open = ccio_proc_bitmap_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
 #endif /* CONFIG_PROC_FS */
 
 /**
@@ -1589,10 +1563,10 @@ static int __init ccio_probe(struct parisc_device *dev)
 
 #ifdef CONFIG_PROC_FS
 	if (ioc_count == 0) {
-		proc_create(MODULE_NAME, 0, proc_runway_root,
-			    &ccio_proc_info_fops);
-		proc_create(MODULE_NAME"-bitmap", 0, proc_runway_root,
-			    &ccio_proc_bitmap_fops);
+		proc_create_single(MODULE_NAME, 0, proc_runway_root,
+				ccio_proc_info);
+		proc_create_single(MODULE_NAME"-bitmap", 0, proc_runway_root,
+				ccio_proc_bitmap_info);
 	}
 #endif
 	ioc_count++;
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 0a9c762a70fa..0d33d1f86d10 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1863,20 +1863,6 @@ static int sba_proc_info(struct seq_file *m, void *p)
 	return 0;
 }
 
-static int
-sba_proc_open(struct inode *i, struct file *f)
-{
-	return single_open(f, &sba_proc_info, NULL);
-}
-
-static const struct file_operations sba_proc_fops = {
-	.owner = THIS_MODULE,
-	.open = sba_proc_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 static int
 sba_proc_bitmap_info(struct seq_file *m, void *p)
 {
@@ -1889,20 +1875,6 @@ sba_proc_bitmap_info(struct seq_file *m, void *p)
 
 	return 0;
 }
-
-static int
-sba_proc_bitmap_open(struct inode *i, struct file *f)
-{
-	return single_open(f, &sba_proc_bitmap_info, NULL);
-}
-
-static const struct file_operations sba_proc_bitmap_fops = {
-	.owner = THIS_MODULE,
-	.open = sba_proc_bitmap_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
 #endif /* CONFIG_PROC_FS */
 
 static const struct parisc_device_id sba_tbl[] __initconst = {
@@ -2014,8 +1986,8 @@ static int __init sba_driver_callback(struct parisc_device *dev)
 		break;
 	}
 
-	proc_create("sba_iommu", 0, root, &sba_proc_fops);
-	proc_create("sba_iommu-bitmap", 0, root, &sba_proc_bitmap_fops);
+	proc_create_single("sba_iommu", 0, root, sba_proc_info);
+	proc_create_single("sba_iommu-bitmap", 0, root, sba_proc_bitmap_info);
 #endif
 
 	parisc_has_iommu();
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index e8d058c5ef21..eef76bfa5d73 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1689,19 +1689,6 @@ static int version_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int version_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, version_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations version_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= version_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /*
  * Proc and module init
  */
@@ -1722,8 +1709,8 @@ static void create_toshiba_proc_entries(struct toshiba_acpi_dev *dev)
 	if (dev->hotkey_dev)
 		proc_create_data("keys", S_IRUGO | S_IWUSR, toshiba_proc_dir,
 				 &keys_proc_fops, dev);
-	proc_create_data("version", S_IRUGO, toshiba_proc_dir,
-			 &version_proc_fops, dev);
+	proc_create_single_data("version", S_IRUGO, toshiba_proc_dir,
+			version_proc_show, dev);
 }
 
 static void remove_toshiba_proc_entries(struct toshiba_acpi_dev *dev)
diff --git a/drivers/pnp/pnpbios/proc.c b/drivers/pnp/pnpbios/proc.c
index 7d4aca7948dd..fe1c8f5d9af0 100644
--- a/drivers/pnp/pnpbios/proc.c
+++ b/drivers/pnp/pnpbios/proc.c
@@ -47,19 +47,6 @@ static int pnpconfig_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int pnpconfig_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pnpconfig_proc_show, NULL);
-}
-
-static const struct file_operations pnpconfig_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pnpconfig_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int escd_info_proc_show(struct seq_file *m, void *v)
 {
 	struct escd_info_struc escd;
@@ -74,19 +61,6 @@ static int escd_info_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int escd_info_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, escd_info_proc_show, NULL);
-}
-
-static const struct file_operations escd_info_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= escd_info_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 #define MAX_SANE_ESCD_SIZE (32*1024)
 static int escd_proc_show(struct seq_file *m, void *v)
 {
@@ -129,19 +103,6 @@ static int escd_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int escd_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, escd_proc_show, NULL);
-}
-
-static const struct file_operations escd_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= escd_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int pnp_legacyres_proc_show(struct seq_file *m, void *v)
 {
 	void *buf;
@@ -159,19 +120,6 @@ static int pnp_legacyres_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int pnp_legacyres_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pnp_legacyres_proc_show, NULL);
-}
-
-static const struct file_operations pnp_legacyres_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pnp_legacyres_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int pnp_devices_proc_show(struct seq_file *m, void *v)
 {
 	struct pnp_bios_node *node;
@@ -202,19 +150,6 @@ static int pnp_devices_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int pnp_devices_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pnp_devices_proc_show, NULL);
-}
-
-static const struct file_operations pnp_devices_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pnp_devices_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int pnpbios_proc_show(struct seq_file *m, void *v)
 {
 	void *data = m->private;
@@ -318,12 +253,13 @@ int __init pnpbios_proc_init(void)
 	proc_pnp_boot = proc_mkdir("boot", proc_pnp);
 	if (!proc_pnp_boot)
 		return -EIO;
-	proc_create("devices", 0, proc_pnp, &pnp_devices_proc_fops);
-	proc_create("configuration_info", 0, proc_pnp, &pnpconfig_proc_fops);
-	proc_create("escd_info", 0, proc_pnp, &escd_info_proc_fops);
-	proc_create("escd", S_IRUSR, proc_pnp, &escd_proc_fops);
-	proc_create("legacy_device_resources", 0, proc_pnp, &pnp_legacyres_proc_fops);
-
+	proc_create_single("devices", 0, proc_pnp, pnp_devices_proc_show);
+	proc_create_single("configuration_info", 0, proc_pnp,
+			pnpconfig_proc_show);
+	proc_create_single("escd_info", 0, proc_pnp, escd_info_proc_show);
+	proc_create_single("escd", S_IRUSR, proc_pnp, escd_proc_show);
+	proc_create_single("legacy_device_resources", 0, proc_pnp,
+			pnp_legacyres_proc_show);
 	return 0;
 }
 
diff --git a/drivers/staging/comedi/proc.c b/drivers/staging/comedi/proc.c
index 50d38938ac6f..8bc8e42beb90 100644
--- a/drivers/staging/comedi/proc.c
+++ b/drivers/staging/comedi/proc.c
@@ -62,25 +62,9 @@ static int comedi_read(struct seq_file *m, void *v)
 	return 0;
 }
 
-/*
- * seq_file wrappers for procfile show routines.
- */
-static int comedi_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, comedi_read, NULL);
-}
-
-static const struct file_operations comedi_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= comedi_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 void __init comedi_proc_init(void)
 {
-	if (!proc_create("comedi", 0444, NULL, &comedi_proc_fops))
+	if (!proc_create_single("comedi", 0444, NULL, comedi_read))
 		pr_warn("comedi: unable to create proc entry\n");
 }
 
diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index ad743a8493be..03959dc86cfd 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -234,22 +234,10 @@ static int proc_udc_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int proc_udc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_udc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations proc_ops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_udc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static void create_debug_file(struct at91_udc *udc)
 {
-	udc->pde = proc_create_data(debug_filename, 0, NULL, &proc_ops, udc);
+	udc->pde = proc_create_single_data(debug_filename, 0, NULL,
+			proc_udc_show, udc);
 }
 
 static void remove_debug_file(struct at91_udc *udc)
diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/udc/fsl_udc_core.c
index 56b517a38865..7d8af299dfc7 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2207,22 +2207,8 @@ static int fsl_proc_read(struct seq_file *m, void *v)
 	return 0;
 }
 
-/*
- * seq_file wrappers for procfile show routines.
- */
-static int fsl_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, fsl_proc_read, NULL);
-}
-
-static const struct file_operations fsl_proc_fops = {
-	.open		= fsl_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-#define create_proc_file()	proc_create(proc_filename, 0, NULL, &fsl_proc_fops)
+#define create_proc_file() \
+	proc_create_single(proc_filename, 0, NULL, fsl_proc_read)
 #define remove_proc_file()	remove_proc_entry(proc_filename, NULL)
 
 #else				/* !CONFIG_USB_GADGET_DEBUG_FILES */
diff --git a/drivers/usb/gadget/udc/goku_udc.c b/drivers/usb/gadget/udc/goku_udc.c
index 4504d0b202db..c3721225b61e 100644
--- a/drivers/usb/gadget/udc/goku_udc.c
+++ b/drivers/usb/gadget/udc/goku_udc.c
@@ -1241,22 +1241,6 @@ static int udc_proc_read(struct seq_file *m, void *v)
 	local_irq_restore(flags);
 	return 0;
 }
-
-/*
- * seq_file wrappers for procfile show routines.
- */
-static int udc_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, udc_proc_read, PDE_DATA(file_inode(file)));
-}
-
-static const struct file_operations udc_proc_fops = {
-	.open		= udc_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 #endif	/* CONFIG_USB_GADGET_DEBUG_FILES */
 
 /*-------------------------------------------------------------------------*/
@@ -1826,7 +1810,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 
 #ifdef CONFIG_USB_GADGET_DEBUG_FILES
-	proc_create_data(proc_node_name, 0, NULL, &udc_proc_fops, dev);
+	proc_create_single_data(proc_node_name, 0, NULL, udc_proc_read, dev);
 #endif
 
 	retval = usb_add_gadget_udc_release(&pdev->dev, &dev->gadget,
diff --git a/drivers/usb/gadget/udc/omap_udc.c b/drivers/usb/gadget/udc/omap_udc.c
index dc35a54bad90..3a16431da321 100644
--- a/drivers/usb/gadget/udc/omap_udc.c
+++ b/drivers/usb/gadget/udc/omap_udc.c
@@ -2432,22 +2432,9 @@ static int proc_udc_show(struct seq_file *s, void *_)
 	return 0;
 }
 
-static int proc_udc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_udc_show, NULL);
-}
-
-static const struct file_operations proc_ops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_udc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static void create_proc_file(void)
 {
-	proc_create(proc_filename, 0, NULL, &proc_ops);
+	proc_create_single(proc_filename, 0, NULL, proc_udc_show);
 }
 
 static void remove_proc_file(void)
diff --git a/drivers/video/fbdev/via/viafbdev.c b/drivers/video/fbdev/via/viafbdev.c
index badee04ef496..9b45125988fb 100644
--- a/drivers/video/fbdev/via/viafbdev.c
+++ b/drivers/video/fbdev/via/viafbdev.c
@@ -1475,19 +1475,6 @@ static int viafb_sup_odev_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int viafb_sup_odev_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, viafb_sup_odev_proc_show, NULL);
-}
-
-static const struct file_operations viafb_sup_odev_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= viafb_sup_odev_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static ssize_t odev_update(const char __user *buffer, size_t count, u32 *odev)
 {
 	char buf[64], *ptr = buf;
@@ -1616,8 +1603,8 @@ static void viafb_init_proc(struct viafb_shared *shared)
 				&viafb_vt1636_proc_fops);
 #endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
 
-		proc_create("supported_output_devices", 0, viafb_entry,
-			&viafb_sup_odev_proc_fops);
+		proc_create_single("supported_output_devices", 0, viafb_entry,
+			viafb_sup_odev_proc_show);
 		iga1_entry = proc_mkdir("iga1", viafb_entry);
 		shared->iga1_proc_entry = iga1_entry;
 		proc_create("output_devices", 0, iga1_entry,
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 9d69ea433330..4bc4a7ac61d9 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -314,18 +314,6 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int cifs_debug_data_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, cifs_debug_data_proc_show, NULL);
-}
-
-static const struct file_operations cifs_debug_data_proc_fops = {
-	.open		= cifs_debug_data_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 #ifdef CONFIG_CIFS_STATS
 static ssize_t cifs_stats_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
@@ -497,7 +485,8 @@ cifs_proc_init(void)
 	if (proc_fs_cifs == NULL)
 		return;
 
-	proc_create("DebugData", 0, proc_fs_cifs, &cifs_debug_data_proc_fops);
+	proc_create_single("DebugData", 0, proc_fs_cifs,
+			cifs_debug_data_proc_show);
 
 #ifdef CONFIG_CIFS_STATS
 	proc_create("Stats", 0, proc_fs_cifs, &cifs_stats_proc_fops);
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index f33a56d6e6dd..4b47ca6296a7 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -572,23 +572,6 @@ static int iostat_info_seq_show(struct seq_file *seq, void *offset)
 	return 0;
 }
 
-#define F2FS_PROC_FILE_DEF(_name)					\
-static int _name##_open_fs(struct inode *inode, struct file *file)	\
-{									\
-	return single_open(file, _name##_seq_show, PDE_DATA(inode));	\
-}									\
-									\
-static const struct file_operations f2fs_seq_##_name##_fops = {		\
-	.open = _name##_open_fs,					\
-	.read = seq_read,						\
-	.llseek = seq_lseek,						\
-	.release = single_release,					\
-};
-
-F2FS_PROC_FILE_DEF(segment_info);
-F2FS_PROC_FILE_DEF(segment_bits);
-F2FS_PROC_FILE_DEF(iostat_info);
-
 int __init f2fs_init_sysfs(void)
 {
 	int ret;
@@ -632,12 +615,12 @@ int f2fs_register_sysfs(struct f2fs_sb_info *sbi)
 		sbi->s_proc = proc_mkdir(sb->s_id, f2fs_proc_root);
 
 	if (sbi->s_proc) {
-		proc_create_data("segment_info", S_IRUGO, sbi->s_proc,
-				 &f2fs_seq_segment_info_fops, sb);
-		proc_create_data("segment_bits", S_IRUGO, sbi->s_proc,
-				 &f2fs_seq_segment_bits_fops, sb);
-		proc_create_data("iostat_info", S_IRUGO, sbi->s_proc,
-				&f2fs_seq_iostat_info_fops, sb);
+		proc_create_single_data("segment_info", S_IRUGO, sbi->s_proc,
+				segment_info_seq_show, sb);
+		proc_create_single_data("segment_bits", S_IRUGO, sbi->s_proc,
+				segment_bits_seq_show, sb);
+		proc_create_single_data("iostat_info", S_IRUGO, sbi->s_proc,
+				iostat_info_seq_show, sb);
 	}
 	return 0;
 }
diff --git a/fs/filesystems.c b/fs/filesystems.c
index f2728a4a03a1..b03f57b1105b 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -238,21 +238,9 @@ static int filesystems_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int filesystems_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, filesystems_proc_show, NULL);
-}
-
-static const struct file_operations filesystems_proc_fops = {
-	.open		= filesystems_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_filesystems_init(void)
 {
-	proc_create("filesystems", 0, NULL, &filesystems_proc_fops);
+	proc_create_single("filesystems", 0, NULL, filesystems_proc_show);
 	return 0;
 }
 module_init(proc_filesystems_init);
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 53cfd0b34c38..f83328a7f048 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -295,7 +295,7 @@ static inline void fscache_stat_d(atomic_t *stat)
 
 #define __fscache_stat(stat) (stat)
 
-extern const struct file_operations fscache_stats_fops;
+int fscache_stats_show(struct seq_file *m, void *v);
 #else
 
 #define __fscache_stat(stat) (NULL)
diff --git a/fs/fscache/proc.c b/fs/fscache/proc.c
index 459df553ea09..49a8c90414bc 100644
--- a/fs/fscache/proc.c
+++ b/fs/fscache/proc.c
@@ -26,8 +26,8 @@ int __init fscache_proc_init(void)
 		goto error_dir;
 
 #ifdef CONFIG_FSCACHE_STATS
-	if (!proc_create("fs/fscache/stats", S_IFREG | 0444, NULL,
-			 &fscache_stats_fops))
+	if (!proc_create_single("fs/fscache/stats", S_IFREG | 0444, NULL,
+			fscache_stats_show))
 		goto error_stats;
 #endif
 
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index fcc8c2f2690e..00564a1dfd76 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -138,7 +138,7 @@ atomic_t fscache_n_cache_culled_objects;
 /*
  * display the general statistics
  */
-static int fscache_stats_show(struct seq_file *m, void *v)
+int fscache_stats_show(struct seq_file *m, void *v)
 {
 	seq_puts(m, "FS-Cache statistics\n");
 
@@ -284,18 +284,3 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_cache_culled_objects));
 	return 0;
 }
-
-/*
- * open "/proc/fs/fscache/stats" allowing provision of a statistical summary
- */
-static int fscache_stats_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, fscache_stats_show, NULL);
-}
-
-const struct file_operations fscache_stats_fops = {
-	.open		= fscache_stats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release        = single_release,
-};
diff --git a/fs/proc/cmdline.c b/fs/proc/cmdline.c
index 8233e7af9389..fa762c5fbcb2 100644
--- a/fs/proc/cmdline.c
+++ b/fs/proc/cmdline.c
@@ -11,21 +11,9 @@ static int cmdline_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int cmdline_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, cmdline_proc_show, NULL);
-}
-
-static const struct file_operations cmdline_proc_fops = {
-	.open		= cmdline_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_cmdline_init(void)
 {
-	proc_create("cmdline", 0, NULL, &cmdline_proc_fops);
+	proc_create_single("cmdline", 0, NULL, cmdline_proc_show);
 	return 0;
 }
 fs_initcall(proc_cmdline_init);
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index f87cb0053387..02bb1914f5f7 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -588,6 +588,35 @@ struct proc_dir_entry *proc_create_seq_private(const char *name, umode_t mode,
 }
 EXPORT_SYMBOL(proc_create_seq_private);
 
+static int proc_single_open(struct inode *inode, struct file *file)
+{
+	struct proc_dir_entry *de = PDE(inode);
+
+	return single_open(file, de->single_show, de->data);
+}
+
+static const struct file_operations proc_single_fops = {
+	.open		= proc_single_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+struct proc_dir_entry *proc_create_single_data(const char *name, umode_t mode,
+		struct proc_dir_entry *parent,
+		int (*show)(struct seq_file *, void *), void *data)
+{
+	struct proc_dir_entry *p;
+
+	p = proc_create_reg(name, mode, &parent, data);
+	if (!p)
+		return NULL;
+	p->proc_fops = &proc_single_fops;
+	p->single_show = show;
+	return proc_register(parent, p);
+}
+EXPORT_SYMBOL(proc_create_single_data);
+
 void proc_set_size(struct proc_dir_entry *de, loff_t size)
 {
 	de->size = size;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index bcfe830ffd59..84c68508a256 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -44,7 +44,10 @@ struct proc_dir_entry {
 	struct completion *pde_unload_completion;
 	const struct inode_operations *proc_iops;
 	const struct file_operations *proc_fops;
-	const struct seq_operations *seq_ops;
+	union {
+		const struct seq_operations *seq_ops;
+		int (*single_show)(struct seq_file *, void *);
+	};
 	void *data;
 	unsigned int state_size;
 	unsigned int low_ino;
diff --git a/fs/proc/loadavg.c b/fs/proc/loadavg.c
index b572cc865b92..d06694757201 100644
--- a/fs/proc/loadavg.c
+++ b/fs/proc/loadavg.c
@@ -28,21 +28,9 @@ static int loadavg_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int loadavg_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, loadavg_proc_show, NULL);
-}
-
-static const struct file_operations loadavg_proc_fops = {
-	.open		= loadavg_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_loadavg_init(void)
 {
-	proc_create("loadavg", 0, NULL, &loadavg_proc_fops);
+	proc_create_single("loadavg", 0, NULL, loadavg_proc_show);
 	return 0;
 }
 fs_initcall(proc_loadavg_init);
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 65a72ab57471..2fb04846ed11 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -149,21 +149,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int meminfo_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, meminfo_proc_show, NULL);
-}
-
-static const struct file_operations meminfo_proc_fops = {
-	.open		= meminfo_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_meminfo_init(void)
 {
-	proc_create("meminfo", 0, NULL, &meminfo_proc_fops);
+	proc_create_single("meminfo", 0, NULL, meminfo_proc_show);
 	return 0;
 }
 fs_initcall(proc_meminfo_init);
diff --git a/fs/proc/softirqs.c b/fs/proc/softirqs.c
index 24072cc06e65..12901dcf57e2 100644
--- a/fs/proc/softirqs.c
+++ b/fs/proc/softirqs.c
@@ -25,21 +25,9 @@ static int show_softirqs(struct seq_file *p, void *v)
 	return 0;
 }
 
-static int softirqs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, show_softirqs, NULL);
-}
-
-static const struct file_operations proc_softirqs_operations = {
-	.open		= softirqs_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_softirqs_init(void)
 {
-	proc_create("softirqs", 0, NULL, &proc_softirqs_operations);
+	proc_create_single("softirqs", 0, NULL, show_softirqs);
 	return 0;
 }
 fs_initcall(proc_softirqs_init);
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 95a708d83721..3bd12f955867 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -30,21 +30,9 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int uptime_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, uptime_proc_show, NULL);
-}
-
-static const struct file_operations uptime_proc_fops = {
-	.open		= uptime_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_uptime_init(void)
 {
-	proc_create("uptime", 0, NULL, &uptime_proc_fops);
+	proc_create_single("uptime", 0, NULL, uptime_proc_show);
 	return 0;
 }
 fs_initcall(proc_uptime_init);
diff --git a/fs/proc/version.c b/fs/proc/version.c
index 94901e8e700d..b449f186577f 100644
--- a/fs/proc/version.c
+++ b/fs/proc/version.c
@@ -15,21 +15,9 @@ static int version_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int version_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, version_proc_show, NULL);
-}
-
-static const struct file_operations version_proc_fops = {
-	.open		= version_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_version_init(void)
 {
-	proc_create("version", 0, NULL, &version_proc_fops);
+	proc_create_single("version", 0, NULL, version_proc_show);
 	return 0;
 }
 fs_initcall(proc_version_init);
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index fe999157dd97..e39b3910d24d 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -389,27 +389,13 @@ static int show_journal(struct seq_file *m, void *unused)
 	return 0;
 }
 
-static int r_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, PDE_DATA(inode), 
-				proc_get_parent_data(inode));
-}
-
-static const struct file_operations r_file_operations = {
-	.open = r_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 static struct proc_dir_entry *proc_info_root = NULL;
 static const char proc_info_root_name[] = "fs/reiserfs";
 
 static void add_file(struct super_block *sb, char *name,
 		     int (*func) (struct seq_file *, void *))
 {
-	proc_create_data(name, 0, REISERFS_SB(sb)->procdir,
-			 &r_file_operations, func);
+	proc_create_single_data(name, 0, REISERFS_SB(sb)->procdir, func, sb);
 }
 
 int reiserfs_proc_info_init(struct super_block *sb)
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 056e12b421eb..04762a72e344 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -124,18 +124,6 @@ static int xqm_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int xqm_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, xqm_proc_show, NULL);
-}
-
-static const struct file_operations xqm_proc_fops = {
-	.open		= xqm_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /* legacy quota stats interface no 2 */
 static int xqmstat_proc_show(struct seq_file *m, void *v)
 {
@@ -147,19 +135,6 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
 	seq_putc(m, '\n');
 	return 0;
 }
-
-static int xqmstat_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, xqmstat_proc_show, NULL);
-}
-
-static const struct file_operations xqmstat_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= xqmstat_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif /* CONFIG_XFS_QUOTA */
 
 #ifdef CONFIG_PROC_FS
@@ -174,11 +149,9 @@ xfs_init_procfs(void)
 		goto out;
 
 #ifdef CONFIG_XFS_QUOTA
-	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
-			 &xqmstat_proc_fops))
+	if (!proc_create_single("fs/xfs/xqmstat", 0, NULL, xqmstat_proc_show))
 		goto out;
-	if (!proc_create("fs/xfs/xqm", 0, NULL,
-			 &xqm_proc_fops))
+	if (!proc_create_single("fs/xfs/xqm", 0, NULL, xqm_proc_show))
 		goto out;
 #endif
 	return 0;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 314713a48817..2529b871f379 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 
 struct proc_dir_entry;
+struct seq_file;
 struct seq_operations;
 
 #ifdef CONFIG_PROC_FS
@@ -32,6 +33,11 @@ struct proc_dir_entry *proc_create_seq_private(const char *name, umode_t mode,
 	proc_create_seq_private(name, mode, parent, ops, 0, data)
 #define proc_create_seq(name, mode, parent, ops) \
 	proc_create_seq_private(name, mode, parent, ops, 0, NULL)
+struct proc_dir_entry *proc_create_single_data(const char *name, umode_t mode,
+		struct proc_dir_entry *parent,
+		int (*show)(struct seq_file *, void *), void *data);
+#define proc_create_single(name, mode, parent, show) \
+	proc_create_single_data(name, mode, parent, show, NULL)
  
 extern struct proc_dir_entry *proc_create_data(const char *, umode_t,
 					       struct proc_dir_entry *,
@@ -66,9 +72,11 @@ static inline struct proc_dir_entry *proc_mkdir_data(const char *name,
 	umode_t mode, struct proc_dir_entry *parent, void *data) { return NULL; }
 static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
 	umode_t mode, struct proc_dir_entry *parent) { return NULL; }
-#define proc_create_seq_private(name, mode, parent, ops, 0, data) ({NULL;})
+#define proc_create_seq_private(name, mode, parent, ops, size, data) ({NULL;})
 #define proc_create_seq_data(name, mode, parent, ops, data) ({NULL;})
 #define proc_create_seq(name, mode, parent, ops) ({NULL;})
+#define proc_create_single(name, mode, parent, show) ({NULL;})
+#define proc_create_single_data(name, mode, parent, show, data) ({NULL;})
 #define proc_create(name, mode, parent, proc_fops) ({NULL;})
 #define proc_create_data(name, mode, parent, proc_fops, data) ({NULL;})
 
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index b928b27050c6..0808a33d16d3 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -218,9 +218,9 @@ extern const struct proc_ns_operations cgroupns_operations;
  * cgroup-v1.c
  */
 extern struct cftype cgroup1_base_files[];
-extern const struct file_operations proc_cgroupstats_operations;
 extern struct kernfs_syscall_ops cgroup1_kf_syscall_ops;
 
+int proc_cgroupstats_show(struct seq_file *m, void *v);
 bool cgroup1_ssid_disabled(int ssid);
 void cgroup1_pidlist_destroy_all(struct cgroup *cgrp);
 void cgroup1_release_agent(struct work_struct *work);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index a2c05d2476ac..e06c97f3ed1a 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -682,7 +682,7 @@ struct cftype cgroup1_base_files[] = {
 };
 
 /* Display information about each subsystem and each hierarchy */
-static int proc_cgroupstats_show(struct seq_file *m, void *v)
+int proc_cgroupstats_show(struct seq_file *m, void *v)
 {
 	struct cgroup_subsys *ss;
 	int i;
@@ -705,18 +705,6 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int cgroupstats_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_cgroupstats_show, NULL);
-}
-
-const struct file_operations proc_cgroupstats_operations = {
-	.open = cgroupstats_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 /**
  * cgroupstats_build - build and fill cgroupstats
  * @stats: cgroupstats to fill information into
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a662bfcbea0e..12883656e63e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5335,7 +5335,7 @@ int __init cgroup_init(void)
 	WARN_ON(sysfs_create_mount_point(fs_kobj, "cgroup"));
 	WARN_ON(register_filesystem(&cgroup_fs_type));
 	WARN_ON(register_filesystem(&cgroup2_fs_type));
-	WARN_ON(!proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations));
+	WARN_ON(!proc_create_single("cgroups", 0, NULL, proc_cgroupstats_show));
 
 	return 0;
 }
diff --git a/kernel/dma.c b/kernel/dma.c
index 3506fc34a712..40f152936316 100644
--- a/kernel/dma.c
+++ b/kernel/dma.c
@@ -135,21 +135,9 @@ static int proc_dma_show(struct seq_file *m, void *v)
 }
 #endif /* MAX_DMA_CHANNELS */
 
-static int proc_dma_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_dma_show, NULL);
-}
-
-static const struct file_operations proc_dma_operations = {
-	.open		= proc_dma_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_dma_init(void)
 {
-	proc_create("dma", 0, NULL, &proc_dma_operations);
+	proc_create_single("dma", 0, NULL, proc_dma_show);
 	return 0;
 }
 
diff --git a/kernel/exec_domain.c b/kernel/exec_domain.c
index a5697119290e..33f07c5f2515 100644
--- a/kernel/exec_domain.c
+++ b/kernel/exec_domain.c
@@ -27,21 +27,9 @@ static int execdomains_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int execdomains_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, execdomains_proc_show, NULL);
-}
-
-static const struct file_operations execdomains_proc_fops = {
-	.open		= execdomains_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __init proc_execdomains_init(void)
 {
-	proc_create("execdomains", 0, NULL, &execdomains_proc_fops);
+	proc_create_single("execdomains", 0, NULL, execdomains_proc_show);
 	return 0;
 }
 module_init(proc_execdomains_init);
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 7cb091d81d91..37eda10f5c36 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -185,11 +185,6 @@ static int irq_affinity_list_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, irq_affinity_list_proc_show, PDE_DATA(inode));
 }
 
-static int irq_affinity_hint_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, irq_affinity_hint_proc_show, PDE_DATA(inode));
-}
-
 static const struct file_operations irq_affinity_proc_fops = {
 	.open		= irq_affinity_proc_open,
 	.read		= seq_read,
@@ -198,13 +193,6 @@ static const struct file_operations irq_affinity_proc_fops = {
 	.write		= irq_affinity_proc_write,
 };
 
-static const struct file_operations irq_affinity_hint_proc_fops = {
-	.open		= irq_affinity_hint_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static const struct file_operations irq_affinity_list_proc_fops = {
 	.open		= irq_affinity_list_proc_open,
 	.read		= seq_read,
@@ -223,32 +211,6 @@ static int irq_effective_aff_list_proc_show(struct seq_file *m, void *v)
 {
 	return show_irq_affinity(EFFECTIVE_LIST, m);
 }
-
-static int irq_effective_aff_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, irq_effective_aff_proc_show, PDE_DATA(inode));
-}
-
-static int irq_effective_aff_list_proc_open(struct inode *inode,
-					    struct file *file)
-{
-	return single_open(file, irq_effective_aff_list_proc_show,
-			   PDE_DATA(inode));
-}
-
-static const struct file_operations irq_effective_aff_proc_fops = {
-	.open		= irq_effective_aff_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static const struct file_operations irq_effective_aff_list_proc_fops = {
-	.open		= irq_effective_aff_list_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 static int default_affinity_show(struct seq_file *m, void *v)
@@ -313,18 +275,6 @@ static int irq_node_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "%d\n", irq_desc_get_node(desc));
 	return 0;
 }
-
-static int irq_node_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, irq_node_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations irq_node_proc_fops = {
-	.open		= irq_node_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 static int irq_spurious_proc_show(struct seq_file *m, void *v)
@@ -337,18 +287,6 @@ static int irq_spurious_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int irq_spurious_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, irq_spurious_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations irq_spurious_proc_fops = {
-	.open		= irq_spurious_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 #define MAX_NAMELEN 128
 
 static int name_unique(unsigned int irq, struct irqaction *new_action)
@@ -421,24 +359,24 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 			 &irq_affinity_proc_fops, irqp);
 
 	/* create /proc/irq/<irq>/affinity_hint */
-	proc_create_data("affinity_hint", 0444, desc->dir,
-			 &irq_affinity_hint_proc_fops, irqp);
+	proc_create_single_data("affinity_hint", 0444, desc->dir,
+			irq_affinity_hint_proc_show, irqp);
 
 	/* create /proc/irq/<irq>/smp_affinity_list */
 	proc_create_data("smp_affinity_list", 0644, desc->dir,
 			 &irq_affinity_list_proc_fops, irqp);
 
-	proc_create_data("node", 0444, desc->dir,
-			 &irq_node_proc_fops, irqp);
+	proc_create_single_data("node", 0444, desc->dir, irq_node_proc_show,
+			irqp);
 # ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
-	proc_create_data("effective_affinity", 0444, desc->dir,
-			 &irq_effective_aff_proc_fops, irqp);
-	proc_create_data("effective_affinity_list", 0444, desc->dir,
-			 &irq_effective_aff_list_proc_fops, irqp);
+	proc_create_single_data("effective_affinity", 0444, desc->dir,
+			irq_effective_aff_proc_show, irqp);
+	proc_create_single_data("effective_affinity_list", 0444, desc->dir,
+			irq_effective_aff_list_proc_show, irqp);
 # endif
 #endif
-	proc_create_data("spurious", 0444, desc->dir,
-			 &irq_spurious_proc_fops, (void *)(long)irq);
+	proc_create_single_data("spurious", 0444, desc->dir,
+			irq_spurious_proc_show, (void *)(long)irq);
 
 out_unlock:
 	mutex_unlock(&register_lock);
diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index 3629049648a1..3dd980dfba2d 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -331,18 +331,6 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int lockdep_stats_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, lockdep_stats_show, NULL);
-}
-
-static const struct file_operations proc_lockdep_stats_operations = {
-	.open		= lockdep_stats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 #ifdef CONFIG_LOCK_STAT
 
 struct lock_stat_data {
@@ -662,9 +650,7 @@ static int __init lockdep_proc_init(void)
 #ifdef CONFIG_PROVE_LOCKING
 	proc_create_seq("lockdep_chains", S_IRUSR, NULL, &lockdep_chains_ops);
 #endif
-	proc_create("lockdep_stats", S_IRUSR, NULL,
-		    &proc_lockdep_stats_operations);
-
+	proc_create_single("lockdep_stats", S_IRUSR, NULL, lockdep_stats_show);
 #ifdef CONFIG_LOCK_STAT
 	proc_create("lock_stat", S_IRUSR | S_IWUSR, NULL,
 		    &proc_lock_stat_operations);
diff --git a/net/8021q/vlanproc.c b/net/8021q/vlanproc.c
index a627a5db2125..d3e3f0f2ec1c 100644
--- a/net/8021q/vlanproc.c
+++ b/net/8021q/vlanproc.c
@@ -86,22 +86,6 @@ static const struct file_operations vlan_fops = {
 	.release = seq_release_net,
 };
 
-/*
- *	/proc/net/vlan/<device> file and inode operations
- */
-
-static int vlandev_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, vlandev_seq_show, PDE_DATA(inode));
-}
-
-static const struct file_operations vlandev_fops = {
-	.open    = vlandev_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = single_release,
-};
-
 /*
  * Proc filesystem directory entries.
  */
@@ -171,9 +155,8 @@ int vlan_proc_add_dev(struct net_device *vlandev)
 
 	if (!strcmp(vlandev->name, name_conf))
 		return -EINVAL;
-	vlan->dent =
-		proc_create_data(vlandev->name, S_IFREG | 0600,
-				 vn->proc_vlan_dir, &vlandev_fops, vlandev);
+	vlan->dent = proc_create_single_data(vlandev->name, S_IFREG | 0600,
+			vn->proc_vlan_dir, vlandev_seq_show, vlandev);
 	if (!vlan->dent)
 		return -ENOBUFS;
 	return 0;
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 43f620feb1c4..bbcbcc113d19 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1282,18 +1282,6 @@ static int pnp_seq_show(struct seq_file *seq, void *v)
 			   &ic_servaddr);
 	return 0;
 }
-
-static int pnp_seq_open(struct inode *indoe, struct file *file)
-{
-	return single_open(file, pnp_seq_show, NULL);
-}
-
-static const struct file_operations pnp_seq_fops = {
-	.open		= pnp_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif /* CONFIG_PROC_FS */
 
 /*
@@ -1369,7 +1357,7 @@ static int __init ip_auto_config(void)
 	unsigned int i;
 
 #ifdef CONFIG_PROC_FS
-	proc_create("pnp", 0444, init_net.proc_net, &pnp_seq_fops);
+	proc_create_single("pnp", 0444, init_net.proc_net, pnp_seq_show);
 #endif /* CONFIG_PROC_FS */
 
 	if (!ic_enable)
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 29268efad247..49f5f3e5dc30 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -360,18 +360,6 @@ static int rt_acct_proc_show(struct seq_file *m, void *v)
 	kfree(dst);
 	return 0;
 }
-
-static int rt_acct_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, rt_acct_proc_show, NULL);
-}
-
-static const struct file_operations rt_acct_proc_fops = {
-	.open		= rt_acct_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 static int __net_init ip_rt_do_proc_init(struct net *net)
@@ -389,7 +377,8 @@ static int __net_init ip_rt_do_proc_init(struct net *net)
 		goto err2;
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
-	pde = proc_create("rt_acct", 0, net->proc_net, &rt_acct_proc_fops);
+	pde = proc_create_single("rt_acct", 0, net->proc_net,
+			rt_acct_proc_show);
 	if (!pde)
 		goto err3;
 #endif
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index a85f7e0b14b1..a0edf194822a 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -267,18 +267,6 @@ static int snmp6_dev_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int snmp6_dev_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, snmp6_dev_seq_show, PDE_DATA(inode));
-}
-
-static const struct file_operations snmp6_dev_seq_fops = {
-	.open	 = snmp6_dev_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = single_release,
-};
-
 int snmp6_register_dev(struct inet6_dev *idev)
 {
 	struct proc_dir_entry *p;
@@ -291,9 +279,8 @@ int snmp6_register_dev(struct inet6_dev *idev)
 	if (!net->mib.proc_net_devsnmp6)
 		return -ENOENT;
 
-	p = proc_create_data(idev->dev->name, 0444,
-			     net->mib.proc_net_devsnmp6,
-			     &snmp6_dev_seq_fops, idev);
+	p = proc_create_single_data(idev->dev->name, 0444,
+			net->mib.proc_net_devsnmp6, snmp6_dev_seq_show, idev);
 	if (!p)
 		return -ENOMEM;
 
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 106dae7e4818..54eca685420f 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2092,23 +2092,11 @@ static int psched_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int psched_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, psched_show, NULL);
-}
-
-static const struct file_operations psched_fops = {
-	.open = psched_open,
-	.read  = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 static int __net_init psched_net_init(struct net *net)
 {
 	struct proc_dir_entry *e;
 
-	e = proc_create("psched", 0, net->proc_net, &psched_fops);
+	e = proc_create_single("psched", 0, net->proc_net, psched_show);
 	if (e == NULL)
 		return -ENOMEM;
 
-- 
2.17.0
