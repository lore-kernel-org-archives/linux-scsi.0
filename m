From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] finally fix 53c700 to use the generic iomem infrastructure
Date: Sat, 02 Apr 2005 14:52:14 -0600
Message-ID: <1112475134.5786.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:61636 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261278AbVDBUwQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Apr 2005 15:52:16 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j32KqFA29935
	for <linux-scsi@vger.kernel.org>; Sat, 2 Apr 2005 15:52:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This driver has had it's own different infrastructure for doing this for
ages, but it's time it used the common one.


James

===== drivers/scsi/53c700.c 1.64 vs edited =====
--- 1.64/drivers/scsi/53c700.c	2005-03-20 21:04:31 -06:00
+++ edited/drivers/scsi/53c700.c	2005-04-02 14:15:04 -06:00
@@ -389,8 +389,7 @@
 	host->max_lun = NCR_700_MAX_LUNS;
 	BUG_ON(NCR_700_transport_template == NULL);
 	host->transportt = NCR_700_transport_template;
-	host->unique_id = hostdata->base;
-	host->base = hostdata->base;
+	host->unique_id = (unsigned long)hostdata->base;
 	hostdata->eh_complete = NULL;
 	host->hostdata[0] = (unsigned long)hostdata;
 	/* kick the chip */
===== drivers/scsi/53c700.h 1.23 vs edited =====
--- 1.23/drivers/scsi/53c700.h	2005-03-20 21:04:31 -06:00
+++ edited/drivers/scsi/53c700.h	2005-04-02 14:23:33 -06:00
@@ -14,10 +14,6 @@
 #include <scsi/scsi_device.h>
 
 
-#if defined(CONFIG_53C700_MEM_MAPPED) && defined(CONFIG_53C700_IO_MAPPED)
-#define CONFIG_53C700_BOTH_MAPPED
-#endif
-
 /* Turn on for general debugging---too verbose for normal use */
 #undef	NCR_700_DEBUG
 /* Debug the tag queues, checking hash queue allocation and deallocation
@@ -49,13 +45,6 @@
 /* magic byte identifying an internally generated REQUEST_SENSE command */
 #define NCR_700_INTERNAL_SENSE_MAGIC	0x42
 
-/* WARNING: Leave this in for now: the dependency preprocessor doesn't
- * pick up file specific flags, so must define here if they are not
- * set */
-#if !defined(CONFIG_53C700_IO_MAPPED) && !defined(CONFIG_53C700_MEM_MAPPED)
-#error "Config.in must define either CONFIG_53C700_IO_MAPPED or CONFIG_53C700_MEM_MAPPED to use this scsi core."
-#endif
-
 struct NCR_700_Host_Parameters;
 
 /* These are the externally used routines */
@@ -184,7 +173,7 @@
 struct NCR_700_Host_Parameters {
 	/* These must be filled in by the calling driver */
 	int	clock;			/* board clock speed in MHz */
-	unsigned long	base;		/* the base for the port (copied to host) */
+	void __iomem	*base;		/* the base for the port (copied to host) */
 	struct device	*dev;
 	__u32	dmode_extra;	/* adjustable bus settings */
 	__u32	differential:1;	/* if we are differential */
@@ -199,9 +188,6 @@
 	/* NOTHING BELOW HERE NEEDS ALTERING */
 	__u32	fast:1;		/* if we can alter the SCSI bus clock
                                    speed (so can negiotiate sync) */
-#ifdef CONFIG_53C700_BOTH_MAPPED
-	__u32	mem_mapped;	/* set if memory mapped */
-#endif
 	int	sync_clock;	/* The speed of the SYNC core */
 
 	__u32	*script;		/* pointer to script location */
@@ -246,12 +232,18 @@
 #ifdef CONFIG_53C700_LE_ON_BE
 #define bE	(hostdata->force_le_on_be ? 0 : 3)
 #define	bSWAP	(hostdata->force_le_on_be)
+/* This is terrible, but there's no raw version of ioread32.  That means
+ * that on a be board we swap twice (once in ioread32 and once again to 
+ * get the value correct) */
+#define bS_to_io(x)	((hostdata->force_le_on_be) ? (x) : cpu_to_le32(x))
 #elif defined(__BIG_ENDIAN)
 #define bE	3
 #define bSWAP	0
+#define bS_to_io(x)	(x)
 #elif defined(__LITTLE_ENDIAN)
 #define bE	0
 #define bSWAP	0
+#define bS_to_io(x)	(x)
 #else
 #error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined, did you include byteorder.h?"
 #endif
@@ -455,91 +447,42 @@
 
 
 static inline __u8
-NCR_700_mem_readb(struct Scsi_Host *host, __u32 reg)
-{
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
-		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
-
-	return readb(host->base + (reg^bE));
-}
-
-static inline __u32
-NCR_700_mem_readl(struct Scsi_Host *host, __u32 reg)
-{
-	__u32 value = __raw_readl(host->base + reg);
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
-		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
-#if 1
-	/* sanity check the register */
-	if((reg & 0x3) != 0)
-		BUG();
-#endif
-
-	return bS_to_cpu(value);
-}
-
-static inline void
-NCR_700_mem_writeb(__u8 value, struct Scsi_Host *host, __u32 reg)
-{
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
-		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
-
-	writeb(value, host->base + (reg^bE));
-}
-
-static inline void
-NCR_700_mem_writel(__u32 value, struct Scsi_Host *host, __u32 reg)
-{
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
-		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
-
-#if 1
-	/* sanity check the register */
-	if((reg & 0x3) != 0)
-		BUG();
-#endif
-
-	__raw_writel(bS_to_host(value), host->base + reg);
-}
-
-static inline __u8
-NCR_700_io_readb(struct Scsi_Host *host, __u32 reg)
+NCR_700_readb(struct Scsi_Host *host, __u32 reg)
 {
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
+	const struct NCR_700_Host_Parameters *hostdata
 		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
 
-	return inb(host->base + (reg^bE));
+	return ioread8(hostdata->base + (reg^bE));
 }
 
 static inline __u32
-NCR_700_io_readl(struct Scsi_Host *host, __u32 reg)
+NCR_700_readl(struct Scsi_Host *host, __u32 reg)
 {
-	__u32 value = inl(host->base + reg);
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
+	const struct NCR_700_Host_Parameters *hostdata
 		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
-
+	__u32 value = ioread32(hostdata->base + reg);
 #if 1
 	/* sanity check the register */
 	if((reg & 0x3) != 0)
 		BUG();
 #endif
 
-	return bS_to_cpu(value);
+	return bS_to_io(value);
 }
 
 static inline void
-NCR_700_io_writeb(__u8 value, struct Scsi_Host *host, __u32 reg)
+NCR_700_writeb(__u8 value, struct Scsi_Host *host, __u32 reg)
 {
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
+	const struct NCR_700_Host_Parameters *hostdata
 		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
 
-	outb(value, host->base + (reg^bE));
+	iowrite8(value, hostdata->base + (reg^bE));
 }
 
 static inline void
-NCR_700_io_writel(__u32 value, struct Scsi_Host *host, __u32 reg)
+NCR_700_writel(__u32 value, struct Scsi_Host *host, __u32 reg)
 {
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
+	const struct NCR_700_Host_Parameters *hostdata
 		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
 
 #if 1
@@ -548,102 +491,7 @@
 		BUG();
 #endif
 
-	outl(bS_to_host(value), host->base + reg);
-}
-
-#ifdef CONFIG_53C700_BOTH_MAPPED
-
-static inline __u8
-NCR_700_readb(struct Scsi_Host *host, __u32 reg)
-{
-	__u8 val;
-
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
-		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
-
-	if(hostdata->mem_mapped)
-		val = NCR_700_mem_readb(host, reg);
-	else
-		val = NCR_700_io_readb(host, reg);
-
-	return val;
-}
-
-static inline __u32
-NCR_700_readl(struct Scsi_Host *host, __u32 reg)
-{
-	__u32 val;
-
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
-		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
-
-	if(hostdata->mem_mapped)
-		val = NCR_700_mem_readl(host, reg);
-	else
-		val = NCR_700_io_readl(host, reg);
-
-	return val;
-}
-
-static inline void
-NCR_700_writeb(__u8 value, struct Scsi_Host *host, __u32 reg)
-{
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
-		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
-
-	if(hostdata->mem_mapped)
-		NCR_700_mem_writeb(value, host, reg);
-	else
-		NCR_700_io_writeb(value, host, reg);
-}
-
-static inline void
-NCR_700_writel(__u32 value, struct Scsi_Host *host, __u32 reg)
-{
-	const struct NCR_700_Host_Parameters *hostdata __attribute__((unused))
-		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
-
-	if(hostdata->mem_mapped)
-		NCR_700_mem_writel(value, host, reg);
-	else
-		NCR_700_io_writel(value, host, reg);
-}
-
-static inline void
-NCR_700_set_mem_mapped(struct NCR_700_Host_Parameters *hostdata)
-{
-	hostdata->mem_mapped = 1;
-}
-
-static inline void
-NCR_700_set_io_mapped(struct NCR_700_Host_Parameters *hostdata)
-{
-	hostdata->mem_mapped = 0;
+	iowrite32(bS_to_io(value), hostdata->base + reg);
 }
-
-
-#elif defined(CONFIG_53C700_IO_MAPPED)
-
-#define NCR_700_readb NCR_700_io_readb
-#define NCR_700_readl NCR_700_io_readl
-#define NCR_700_writeb NCR_700_io_writeb
-#define NCR_700_writel NCR_700_io_writel
-
-#define NCR_700_set_io_mapped(x)
-#define NCR_700_set_mem_mapped(x)	error I/O mapped only
-
-#elif defined(CONFIG_53C700_MEM_MAPPED)
-
-#define NCR_700_readb NCR_700_mem_readb
-#define NCR_700_readl NCR_700_mem_readl
-#define NCR_700_writeb NCR_700_mem_writeb
-#define NCR_700_writel NCR_700_mem_writel
-
-#define NCR_700_set_io_mapped(x)	error MEM mapped only
-#define NCR_700_set_mem_mapped(x)
-
-#else
-#error neither CONFIG_53C700_MEM_MAPPED nor CONFIG_53C700_IO_MAPPED is set
-#endif
 
 #endif
===== drivers/scsi/NCR_D700.c 1.24 vs edited =====
--- 1.24/drivers/scsi/NCR_D700.c	2005-03-20 21:04:31 -06:00
+++ edited/drivers/scsi/NCR_D700.c	2005-04-02 14:16:55 -06:00
@@ -197,12 +197,10 @@
 	}
 		
 	/* Fill in the three required pieces of hostdata */
-	hostdata->base = region;
+	hostdata->base = ioport_map(region, 64);
 	hostdata->differential = (((1<<siop) & differential) != 0);
 	hostdata->clock = NCR_D700_CLOCK_MHZ;
 
-	NCR_700_set_io_mapped(hostdata);
-
 	/* and register the siop */
 	host = NCR_700_detect(&NCR_D700_driver_template, hostdata, p->dev);
 	if (!host) {
@@ -214,6 +212,7 @@
 	/* FIXME: read this from SUS */
 	host->this_id = id_array[slot * 2 + siop];
 	host->irq = irq;
+	host->base = region;
 	scsi_scan_host(host);
 
 	return 0;
===== drivers/scsi/lasi700.c 1.25 vs edited =====
--- 1.25/drivers/scsi/lasi700.c	2005-03-20 21:04:31 -06:00
+++ edited/drivers/scsi/lasi700.c	2005-04-02 14:38:36 -06:00
@@ -131,6 +131,7 @@
 	if (!host)
 		goto out_kfree;
 	host->this_id = 7;
+	host->base = base;
 	host->irq = dev->irq;
 	if(request_irq(dev->irq, NCR_700_intr, SA_SHIRQ, "lasi700", host)) {
 		printk(KERN_ERR "lasi700: request_irq failed!\n");
===== drivers/scsi/sim710.c 1.27 vs edited =====
--- 1.27/drivers/scsi/sim710.c	2005-03-20 21:04:31 -06:00
+++ edited/drivers/scsi/sim710.c	2005-04-02 14:21:06 -06:00
@@ -120,11 +120,10 @@
 	}
 
 	/* Fill in the three required pieces of hostdata */
-	hostdata->base = base_addr;
+	hostdata->base = ioport_map(base_addr, 64);
 	hostdata->differential = differential;
 	hostdata->clock = clock;
 	hostdata->chip710 = 1;
-	NCR_700_set_io_mapped(hostdata);
 
 	/* and register the chip */
 	if((host = NCR_700_detect(&sim710_driver_template, hostdata, dev))
@@ -133,6 +132,7 @@
 		goto out_release;
 	}
 	host->this_id = scsi_id;
+	host->base = base_addr;
 	host->irq = irq;
 	if (request_irq(irq, NCR_700_intr, SA_SHIRQ, "sim710", host)) {
 		printk(KERN_ERR "sim710: request_irq failed\n");
@@ -164,6 +164,7 @@
 	NCR_700_release(host);
 	kfree(hostdata);
 	free_irq(host->irq, host);
+	release_region(host->base, 64);
 	return 0;
 }
 


