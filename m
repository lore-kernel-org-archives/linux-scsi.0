From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] t128 iomem annotations and isa_-ectomy
Date: Sun, 28 Nov 2004 14:09:43 +0000
Message-ID: <20041128140943.GE26051@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:48527 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261490AbUK1OJp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Nov 2004 09:09:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

	switched to ioremap() + normal iomem primitives.
Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC10-rc2-bk9-sent1/drivers/scsi/t128.c RC10-rc2-bk9-t128/drivers/scsi/t128.c
--- RC10-rc2-bk9-sent1/drivers/scsi/t128.c	Sun Nov 28 01:47:38 2004
+++ RC10-rc2-bk9-t128/drivers/scsi/t128.c	Sun Nov 28 02:05:54 2004
@@ -199,6 +199,7 @@
     static int current_override = 0, current_base = 0;
     struct Scsi_Host *instance;
     unsigned long base;
+    void __iomem *p;
     int sig, count;
 
     tpnt->proc_name = "t128";
@@ -206,12 +207,15 @@
 
     for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
 	base = 0;
+	p = NULL;
 
-	if (overrides[current_override].address)
+	if (overrides[current_override].address) {
 	    base = overrides[current_override].address;
-	else 
+	    p = ioremap(bases[current_base].address, 0x2000);
+	    if (!p)
+		base = 0;
+	} else 
 	    for (; !base && (current_base < NO_BASES); ++current_base) {
-		void __iomem *p;
 #if (TDEBUG & TDEBUG_INIT)
     printk("scsi-t128 : probing address %08x\n", bases[current_base].address);
 #endif
@@ -228,7 +232,7 @@
 #if (TDEBUG & TDEBUG_INIT)
 			printk("scsi-t128 : detected board.\n");
 #endif
-			break;
+			goto found;
 		    }
 		iounmap(p);
 	    }
@@ -240,11 +244,13 @@
 	if (!base)
 	    break;
 
+found:
 	instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
 	if(instance == NULL)
 		break;
 		
 	instance->base = base;
+	((struct NCR5380_hostdata *)instance->hostdata)->base = p;
 
 	NCR5380_init(instance, 0);
 
@@ -287,12 +293,15 @@
 
 static int t128_release(struct Scsi_Host *shost)
 {
+	NCR5380_local_declare();
+	NCR5380_setup(shost);
 	if (shost->irq)
 		free_irq(shost->irq, NULL);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 	scsi_unregister(shost);
+	iounmap(base);
 	return 0;
 }
 
@@ -340,28 +349,30 @@
 
 static inline int NCR5380_pread (struct Scsi_Host *instance, unsigned char *dst,
     int len) {
-    unsigned long reg = instance->base + T_DATA_REG_OFFSET;
+    NCR5380_local_declare();
+    void __iomem *reg;
     unsigned char *d = dst;
     register int i = len;
 
+    NCR5380_setup(instance);
+    reg = base + T_DATA_REG_OFFSET;
 
 #if 0
     for (; i; --i) {
-	while (!(isa_readb(instance->base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
+	while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
 #else
-    while (!(isa_readb(instance->base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
+    while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
     for (; i; --i) {
 #endif
-	*d++ = isa_readb(reg);
+	*d++ = readb(reg);
     }
 
-    if (isa_readb(instance->base + T_STATUS_REG_OFFSET) & T_ST_TIM) {
+    if (readb(base + T_STATUS_REG_OFFSET) & T_ST_TIM) {
 	unsigned char tmp;
-	unsigned long foo;
-	foo = instance->base + T_CONTROL_REG_OFFSET;
-	tmp = isa_readb(foo);
-	isa_writeb(tmp | T_CR_CT, foo);
-	isa_writeb(tmp, foo);
+	void __iomem *foo = base + T_CONTROL_REG_OFFSET;
+	tmp = readb(foo);
+	writeb(tmp | T_CR_CT, foo);
+	writeb(tmp, foo);
 	printk("scsi%d : watchdog timer fired in NCR5380_pread()\n",
 	    instance->host_no);
 	return -1;
@@ -384,27 +395,30 @@
 
 static inline int NCR5380_pwrite (struct Scsi_Host *instance, unsigned char *src,
     int len) {
-    unsigned long reg = instance->base + T_DATA_REG_OFFSET;
+    NCR5380_local_declare();
+    void __iomem *reg;
     unsigned char *s = src;
     register int i = len;
 
+    NCR5380_setup(instance);
+    reg = base + T_DATA_REG_OFFSET;
+
 #if 0
     for (; i; --i) {
-	while (!(isa_readb(instance->base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
+	while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
 #else
-    while (!(isa_readb(instance->base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
+    while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
     for (; i; --i) {
 #endif
-	isa_writeb(*s++, reg);
+	writeb(*s++, reg);
     }
 
-    if (isa_readb(instance->base + T_STATUS_REG_OFFSET) & T_ST_TIM) {
+    if (readb(base + T_STATUS_REG_OFFSET) & T_ST_TIM) {
 	unsigned char tmp;
-	unsigned long foo;
-	foo = instance->base + T_CONTROL_REG_OFFSET;
-	tmp = isa_readb(foo);
-	isa_writeb(tmp | T_CR_CT, foo);
-	isa_writeb(tmp, foo);
+	void __iomem *foo = base + T_CONTROL_REG_OFFSET;
+	tmp = readb(foo);
+	writeb(tmp | T_CR_CT, foo);
+	writeb(tmp, foo);
 	printk("scsi%d : watchdog timer fired in NCR5380_pwrite()\n",
 	    instance->host_no);
 	return -1;
diff -urN RC10-rc2-bk9-sent1/drivers/scsi/t128.h RC10-rc2-bk9-t128/drivers/scsi/t128.h
--- RC10-rc2-bk9-sent1/drivers/scsi/t128.h	Mon Oct 18 17:53:44 2004
+++ RC10-rc2-bk9-t128/drivers/scsi/t128.h	Sun Nov 28 02:05:57 2004
@@ -111,28 +111,28 @@
 #ifndef HOSTS_C
 
 #define NCR5380_implementation_fields \
-    unsigned long base
+    void __iomem *base
 
 #define NCR5380_local_declare() \
-    unsigned long base
+    void __iomem *base
 
 #define NCR5380_setup(instance) \
-    base = (instance)->base
+    base = ((struct NCR5380_hostdata *)(instance->hostdata))->base
 
 #define T128_address(reg) (base + T_5380_OFFSET + ((reg) * 0x20))
 
 #if !(TDEBUG & TDEBUG_TRANSFER) 
-#define NCR5380_read(reg) isa_readb(T128_address(reg))
-#define NCR5380_write(reg, value) isa_writeb((value),(T128_address(reg)))
+#define NCR5380_read(reg) readb(T128_address(reg))
+#define NCR5380_write(reg, value) writeb((value),(T128_address(reg)))
 #else
 #define NCR5380_read(reg)						\
     (((unsigned char) printk("scsi%d : read register %d at address %08x\n"\
-    , instance->hostno, (reg), T128_address(reg))), isa_readb(T128_address(reg)))
+    , instance->hostno, (reg), T128_address(reg))), readb(T128_address(reg)))
 
 #define NCR5380_write(reg, value) {					\
     printk("scsi%d : write %02x to register %d at address %08x\n", 	\
 	    instance->hostno, (value), (reg), T128_address(reg));	\
-    isa_writeb((value), (T128_address(reg)));				\
+    writeb((value), (T128_address(reg)));				\
 }
 #endif
 
