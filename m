From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_debug 1.64 for lk2.5.47 mark II
Date: Mon, 18 Nov 2002 11:11:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118191112.GA1138@beaverton.ibm.com>
References: <3DD7A1AA.6040009@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DD7A1AA.6040009@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert [dougg@torque.net] wrote:
> Mike Anderson has "/sysfs/bus/pseudo" patches for scsi_debug
> which look good. Hopefully he can re-apply over this patch
> and send them to this list.
> 
> Doug Gilbert

Attached is patch that moves scsi_debug out of scsi bus sysfs
and into a pseudo bus. 

This patch depends on Douglas's patch previously sent on this thread.


-andmike
--
Michael Anderson
andmike@us.ibm.com

 scsi_debug.c |  160 +++++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 128 insertions(+), 32 deletions(-)
------

diff -Nru a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c	Mon Nov 18 10:45:25 2002
+++ b/drivers/scsi/scsi_debug.c	Mon Nov 18 10:45:25 2002
@@ -108,7 +108,12 @@
 #define SECT_SIZE (1 << POW2_SECT_SIZE)
 #define SECT_SIZE_PER(TGT) SECT_SIZE
 
-struct Scsi_Host * scsi_debug_hosts[MAX_NUM_HOSTS];
+struct sdebug_host_info {
+	struct Scsi_Host *shost;
+	struct device *dev;
+};
+
+struct sdebug_host_info * scsi_debug_hosts;
 
 #define SDEBUG_SENSE_LEN 32
 
@@ -146,7 +151,10 @@
 static spinlock_t queued_arr_lock = SPIN_LOCK_UNLOCKED;
 static rwlock_t atomic_rw = RW_LOCK_UNLOCKED;
 
-static struct device_driver sdebug_driverfs_driver;
+static char sdebug_proc_name[] = "scsi_debug";
+static struct device_driver sdebug_driverfs_driver = {
+	.name = sdebug_proc_name,
+};
 
 /* function declarations */
 static int resp_inquiry(unsigned char * cmd, int target, unsigned char * buff,
@@ -176,8 +184,15 @@
                            const char * dev_id_str, int dev_id_str_len);
 static void do_create_driverfs_files(void);
 static void do_remove_driverfs_files(void);
-static struct Scsi_Host * sdebug_add_shost(void);
+static void sdebug_add_shost(int num);
+static void sdebug_remove_shost(int num);
 
+static int sdebug_add_adapter(int num);
+static void sdebug_remove_adapter(int num);
+static struct device pseudo_primary;
+static struct bus_type pseudo_lld_bus;
+int scsi_debug_register_driver(struct device_driver *);
+int scsi_debug_unregister_driver(struct device_driver *);
 
 static unsigned char * scatg2virt(const struct scatterlist * sclp)
 {
@@ -796,8 +811,6 @@
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }
 
-static const char * sdebug_proc_name = "scsi_debug";
-
 static int scsi_debug_slave_attach(struct scsi_device * sdp)
 {
 	int k;
@@ -1401,7 +1414,6 @@
 static ssize_t sdebug_add_host_write(struct device_driver * ddp, 
 				  const char * buf, size_t count, loff_t off)
 {
-	struct Scsi_Host * hpnt;
         int delta_hosts, k;
 	char work[20];
 
@@ -1409,14 +1421,21 @@
                 return 0;
         if (1 != sscanf(buf, "%10s", work))
 		return -EINVAL;
-	if (1 != sscanf(work, "%d", &delta_hosts))
-		return -EINVAL;
+	{	/* temporary hack around sscanf() problem with -ve nums */
+		int neg = 0;
+
+		if ('-' == *work)
+			neg = 1;
+		if (1 != sscanf(work + neg, "%d", &delta_hosts))
+			return -EINVAL;
+		if (neg)
+			delta_hosts = -delta_hosts;
+	}
 	if (delta_hosts > 0) {
 		do {
 			for (k = 0; k < MAX_NUM_HOSTS; ++k) {
-				if (NULL == scsi_debug_hosts[k]) {
-					hpnt = sdebug_add_shost();
-					scsi_debug_hosts[k] = hpnt;
+				if (NULL == scsi_debug_hosts[k].shost) {
+					sdebug_add_shost(k);
 					break;
 				}
 			}
@@ -1427,10 +1446,8 @@
 	} else if (delta_hosts < 0) {
 		do {
 			for (k = MAX_NUM_HOSTS - 1; k >= 0; --k) {
-				if (scsi_debug_hosts[k]) {
-					scsi_remove_host(scsi_debug_hosts[k]);
-					scsi_unregister(scsi_debug_hosts[k]);
-					scsi_debug_hosts[k] = NULL;
+				if (scsi_debug_hosts[k].shost) {
+					sdebug_remove_shost(k);
 					break;
 				}
 			}
@@ -1468,26 +1485,40 @@
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_delay);
 }
 
-static struct Scsi_Host * sdebug_add_shost(void)
+static void sdebug_add_shost(int num)
 {
 	struct Scsi_Host * hpnt;
 	int err;
 
+	if (sdebug_add_adapter(num)){
+		printk(KERN_ERR "sdebug_add_shost: sdebug_add_adapter failed\n");
+		return;
+	}
 	hpnt = scsi_register(&sdebug_driver_template, 0);
 	if (NULL == hpnt) {
+		sdebug_remove_adapter(num);
 		printk(KERN_ERR "sdebug_add_shost: scsi_register failed\n");
-		return NULL;
+		return;
 	}
 	err = scsi_add_host(hpnt);
 	if (err) {
 		printk(KERN_ERR "sdebug_add_shost: scsi_add_host failed\n");
 		scsi_unregister(hpnt);
-		return NULL;
+		sdebug_remove_adapter(num);
+		return;
 	}
 	hpnt->max_lun = scsi_debug_max_luns;
-	return hpnt;
+
+	scsi_debug_hosts[num].shost = hpnt;
 }
 
+static void sdebug_remove_shost(int num)
+{
+	scsi_remove_host(scsi_debug_hosts[num].shost);
+	scsi_unregister(scsi_debug_hosts[num].shost);
+	sdebug_remove_adapter(num);
+	scsi_debug_hosts[num].shost = NULL;
+}
 
 static int __init scsi_debug_init(void)
 {
@@ -1524,6 +1555,14 @@
 		memset(devInfop, 0, sz);
 	}
 
+	sz = sizeof(struct sdebug_host_info) * MAX_NUM_HOSTS;
+	scsi_debug_hosts = vmalloc(sz);
+	if (NULL == scsi_debug_hosts) {
+		printk(KERN_ERR "scsi_debug_init: out of memory 1\n");
+		return -ENOMEM;
+	}
+	memset(scsi_debug_hosts, 0, sz);
+
 	sz = sdebug_store_size;
 	fake_storep = vmalloc(sz);
 	if (NULL == fake_storep) {
@@ -1536,23 +1575,22 @@
 
 	init_all_queued();
 
-	sdebug_driverfs_driver.name = (char *)sdebug_proc_name;
-	sdebug_driverfs_driver.bus = &scsi_driverfs_bus_type;
-	driver_register(&sdebug_driverfs_driver);
+	device_register(&pseudo_primary);
+	bus_register(&pseudo_lld_bus);
+	scsi_debug_register_driver(&sdebug_driverfs_driver);
 	do_create_driverfs_files();
 
 	sdebug_driver_template.proc_name = (char *)sdebug_proc_name;
 
-	memset(scsi_debug_hosts, 0, sizeof(struct Scsi_Host *) * MAX_NUM_HOSTS);
 	for (k = 0; (k < scsi_debug_add_host) && (k < MAX_NUM_HOSTS); k++) {
-		scsi_debug_hosts[k] = sdebug_add_shost();
-		if (NULL == scsi_debug_hosts[k]) {
+		sdebug_add_shost(k);
+		if (NULL == scsi_debug_hosts[k].shost) {
 			printk(KERN_ERR "scsi_debug_init: "
 			       "sdebug_add_shost failed k=%d\n", k);
 			break;
 		}
 	}
-	scsi_debug_add_host = k;	// number of hosts actually present
+	scsi_debug_add_host = k;        // number of hosts actually present
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) {
 		printk(KERN_INFO "scsi_debug: ... built %d host(s)\n",
@@ -1566,20 +1604,78 @@
 	int k;
 
 	for (k = MAX_NUM_HOSTS - 1; k >= 0; --k) {
-		if (scsi_debug_hosts[k]) {
-			scsi_remove_host(scsi_debug_hosts[k]);
-			scsi_unregister(scsi_debug_hosts[k]);
-			scsi_debug_hosts[k] = NULL;
+		if (scsi_debug_hosts[k].shost) {
+			sdebug_remove_shost(k);
 		}
 	}
 	stop_all_queued();
 	do_remove_driverfs_files();
-	driver_unregister(&sdebug_driverfs_driver);
+	scsi_debug_unregister_driver(&sdebug_driverfs_driver);
+	bus_unregister(&pseudo_lld_bus);
+	device_unregister(&pseudo_primary);
 
 	vfree(fake_storep);
 	if (devInfop)
 		vfree(devInfop);
 }
 
-module_init(scsi_debug_init);
+device_initcall(scsi_debug_init);
 module_exit(scsi_debug_exit);
+
+static struct device pseudo_primary = {
+	.name		= "Host/Pseudo Bridge",
+	.bus_id		= "pseudo_0",
+};
+
+static int pseudo_lld_bus_match(struct device *dev, 
+                          struct device_driver *dev_driver)
+{
+        return 1;
+}
+
+static struct bus_type pseudo_lld_bus = {
+        name: "pseudo",
+        match: pseudo_lld_bus_match,
+};
+
+int scsi_debug_register_driver(struct device_driver *dev_driver)
+{
+	dev_driver->bus = &pseudo_lld_bus;
+	driver_register(dev_driver);
+
+	return 0;
+}
+
+int scsi_debug_unregister_driver(struct device_driver *dev_driver)
+{
+	driver_unregister(dev_driver);
+	return 0;
+}
+
+static int sdebug_add_adapter(int num)
+{
+	struct device * dev;
+
+	dev = kmalloc(sizeof(*dev),GFP_KERNEL);
+	if (NULL == dev) {
+		printk(KERN_ERR "%s: out of memory\n", __FUNCTION__);
+		return 1;
+	}
+
+	memset(dev, 0, sizeof(*dev));
+	dev->bus = &pseudo_lld_bus;
+	dev->parent = &pseudo_primary;
+	sprintf(dev->name, "scsi debug adapter");
+	sprintf(dev->bus_id, "adapter%d", num);
+
+	device_register(dev);
+
+	scsi_debug_hosts[num].dev = dev;
+
+	return 0;
+}
+
+static void sdebug_remove_adapter(int num)
+{
+	device_unregister(scsi_debug_hosts[num].dev);
+}

