From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] dtc iomem annotations and isa_-ectomy
Date: Sun, 28 Nov 2004 14:10:53 +0000
Message-ID: <20041128141052.GF26051@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:53391 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261495AbUK1OKz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Nov 2004 09:10:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

	switched to ioremap() + normal iomem operations
Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC10-rc2-bk9-t128/drivers/scsi/dtc.c RC10-rc2-bk9-dtc/drivers/scsi/dtc.c
--- RC10-rc2-bk9-t128/drivers/scsi/dtc.c	Sun Nov 28 01:47:38 2004
+++ RC10-rc2-bk9-dtc/drivers/scsi/dtc.c	Sun Nov 28 02:25:38 2004
@@ -219,52 +219,58 @@
 {
 	static int current_override = 0, current_base = 0;
 	struct Scsi_Host *instance;
-	unsigned int base;
+	unsigned int addr;
+	void __iomem *base;
 	int sig, count;
 
 	tpnt->proc_name = "dtc3x80";
 	tpnt->proc_info = &dtc_proc_info;
 
 	for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
-		base = 0;
+		addr = 0;
+		base = NULL;
 
-		if (overrides[current_override].address)
-			base = overrides[current_override].address;
-		else
-			for (; !base && (current_base < NO_BASES); ++current_base) {
-				void __iomem *p;
+		if (overrides[current_override].address) {
+			addr = overrides[current_override].address;
+			base = ioremap(addr, 0x2000);
+			if (!base)
+				addr = 0;
+		} else
+			for (; !addr && (current_base < NO_BASES); ++current_base) {
 #if (DTCDEBUG & DTCDEBUG_INIT)
 				printk("scsi-dtc : probing address %08x\n", bases[current_base].address);
 #endif
 				if (bases[current_base].noauto)
 					continue;
-				p = ioremap(bases[current_base].address, 0x2000);
-				if (!p)
+				base = ioremap(bases[current_base].address, 0x2000);
+				if (!base)
 					continue;
 				for (sig = 0; sig < NO_SIGNATURES; ++sig) {
-					if (check_signature(p + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
-						base = bases[current_base].address;
+					if (check_signature(base + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
+						addr = bases[current_base].address;
 #if (DTCDEBUG & DTCDEBUG_INIT)
 						printk("scsi-dtc : detected board.\n");
 #endif
-						break;
+						goto found;
 					}
 				}
-				iounmap(p);
+				iounmap(base);
 			}
 
 #if defined(DTCDEBUG) && (DTCDEBUG & DTCDEBUG_INIT)
-		printk("scsi-dtc : base = %08x\n", base);
+		printk("scsi-dtc : base = %08x\n", addr);
 #endif
 
-		if (!base)
+		if (!addr)
 			break;
 
+found:
 		instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
 		if (instance == NULL)
 			break;
 
-		instance->base = base;
+		instance->base = addr;
+		((struct NCR5380_hostdata *)(instance)->hostdata)->base = base;
 
 		NCR5380_init(instance, 0);
 
@@ -380,7 +386,7 @@
 		while (NCR5380_read(DTC_CONTROL_REG) & CSR_HOST_BUF_NOT_RDY)
 			++i;
 		rtrc(3);
-		isa_memcpy_fromio(d, base + DTC_DATA_BUF, 128);
+		memcpy_fromio(d, base + DTC_DATA_BUF, 128);
 		d += 128;
 		len -= 128;
 		rtrc(7);
@@ -431,7 +437,7 @@
 		while (NCR5380_read(DTC_CONTROL_REG) & CSR_HOST_BUF_NOT_RDY)
 			++i;
 		rtrc(3);
-		isa_memcpy_toio(base + DTC_DATA_BUF, src, 128);
+		memcpy_toio(base + DTC_DATA_BUF, src, 128);
 		src += 128;
 		len -= 128;
 	}
@@ -457,12 +463,15 @@
 
 static int dtc_release(struct Scsi_Host *shost)
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
 
diff -urN RC10-rc2-bk9-t128/drivers/scsi/dtc.h RC10-rc2-bk9-dtc/drivers/scsi/dtc.h
--- RC10-rc2-bk9-t128/drivers/scsi/dtc.h	Mon Oct 18 17:53:21 2004
+++ RC10-rc2-bk9-dtc/drivers/scsi/dtc.h	Sun Nov 28 02:25:40 2004
@@ -46,40 +46,40 @@
 #endif
 
 #define NCR5380_implementation_fields \
-    unsigned int base
+    void __iomem *base
 
 #define NCR5380_local_declare() \
-    unsigned int base
+    void __iomem *base
 
 #define NCR5380_setup(instance) \
-    base = (unsigned int)(instance)->base
+    base = ((struct NCR5380_hostdata *)(instance)->hostdata)->base
 
 #define DTC_address(reg) (base + DTC_5380_OFFSET + reg)
 
 #define dbNCR5380_read(reg)                                              \
-    (rval=isa_readb(DTC_address(reg)), \
-     (((unsigned char) printk("DTC : read register %d at addr %08x is: %02x\n"\
-    , (reg), (int)DTC_address(reg), rval)), rval ) )
+    (rval=readb(DTC_address(reg)), \
+     (((unsigned char) printk("DTC : read register %d at addr %p is: %02x\n"\
+    , (reg), DTC_address(reg), rval)), rval ) )
 
 #define dbNCR5380_write(reg, value) do {                                  \
-    printk("DTC : write %02x to register %d at address %08x\n",         \
-            (value), (reg), (int)DTC_address(reg));     \
-    isa_writeb(value, DTC_address(reg));} while(0)
+    printk("DTC : write %02x to register %d at address %p\n",         \
+            (value), (reg), DTC_address(reg));     \
+    writeb(value, DTC_address(reg));} while(0)
 
 
 #if !(DTCDEBUG & DTCDEBUG_TRANSFER) 
-#define NCR5380_read(reg) (isa_readb(DTC_address(reg)))
-#define NCR5380_write(reg, value) (isa_writeb(value, DTC_address(reg)))
+#define NCR5380_read(reg) (readb(DTC_address(reg)))
+#define NCR5380_write(reg, value) (writeb(value, DTC_address(reg)))
 #else
-#define NCR5380_read(reg) (isa_readb(DTC_address(reg)))
+#define NCR5380_read(reg) (readb(DTC_address(reg)))
 #define xNCR5380_read(reg)						\
-    (((unsigned char) printk("DTC : read register %d at address %08x\n"\
-    , (reg), DTC_address(reg))), isa_readb(DTC_address(reg)))
+    (((unsigned char) printk("DTC : read register %d at address %p\n"\
+    , (reg), DTC_address(reg))), readb(DTC_address(reg)))
 
 #define NCR5380_write(reg, value) do {					\
-    printk("DTC : write %02x to register %d at address %08x\n", 	\
-	    (value), (reg), (int)DTC_address(reg));	\
-    isa_writeb(value, DTC_address(reg));} while(0)
+    printk("DTC : write %02x to register %d at address %p\n", 	\
+	    (value), (reg), DTC_address(reg));	\
+    writeb(value, DTC_address(reg));} while(0)
 #endif
 
 #define NCR5380_intr			dtc_intr
