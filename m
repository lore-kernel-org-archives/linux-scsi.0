From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] t128: Indent and add printk levels
Date: Thu, 26 Jul 2007 18:50:44 +0100
Message-ID: <20070726185044.76b17661@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [81.2.110.250] ([81.2.110.250]:39306 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S934600AbXGZRno (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 13:43:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, akpm@osdl.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/drivers/scsi/t128.c linux-2.6.23rc1-mm1/drivers/scsi/t128.c
--- linux.vanilla-2.6.23rc1-mm1/drivers/scsi/t128.c	2007-07-26 15:01:46.000000000 +0100
+++ linux-2.6.23rc1-mm1/drivers/scsi/t128.c	2007-07-26 15:29:47.000000000 +0100
@@ -101,7 +101,7 @@
  * 14 10-12
  * 15 9-11
  */
- 
+
 /*
  * $Log: t128.c,v $
  */
@@ -123,33 +123,40 @@
 #include "NCR5380.h"
 
 static struct override {
-    unsigned long address;
-    int irq;
+	unsigned long address;
+	int irq;
 } overrides
 #ifdef T128_OVERRIDE
-    [] __initdata = T128_OVERRIDE;
+[] __initdata = T128_OVERRIDE;
 #else
-    [4] __initdata = {{0, IRQ_AUTO}, {0, IRQ_AUTO},
-        {0 ,IRQ_AUTO}, {0, IRQ_AUTO}};
+[4] __initdata = { {
+0, IRQ_AUTO}, {
+0, IRQ_AUTO}, {
+0, IRQ_AUTO}, {
+0, IRQ_AUTO}};
 #endif
 
 #define NO_OVERRIDES ARRAY_SIZE(overrides)
 
 static struct base {
-    unsigned int address;
-    int noauto;
+	unsigned int address;
+	int noauto;
 } bases[] __initdata = {
-    { 0xcc000, 0}, { 0xc8000, 0}, { 0xdc000, 0}, { 0xd8000, 0}
+	{
+	0xcc000, 0}, {
+	0xc8000, 0}, {
+	0xdc000, 0}, {
+	0xd8000, 0}
 };
 
 #define NO_BASES ARRAY_SIZE(bases)
 
 static struct signature {
-    const char *string;
-    int offset;
+	const char *string;
+	int offset;
 } signatures[] __initdata = {
-{"TSROM: SCSI BIOS, Version 1.12", 0x36},
-};
+	{
+"TSROM: SCSI BIOS, Version 1.12", 0x36},};
 
 #define NO_SIGNATURES ARRAY_SIZE(signatures)
 
@@ -163,21 +170,21 @@
  *
  */
 
-void __init t128_setup(char *str, int *ints){
-    static int commandline_current = 0;
-    int i;
-    if (ints[0] != 2) 
-	printk("t128_setup : usage t128=address,irq\n");
-    else 
-	if (commandline_current < NO_OVERRIDES) {
-	    overrides[commandline_current].address = ints[1];
-	    overrides[commandline_current].irq = ints[2];
-	    for (i = 0; i < NO_BASES; ++i)
-		if (bases[i].address == ints[1]) {
-		    bases[i].noauto = 1;
-		    break;
-		}
-	    ++commandline_current;
+void __init t128_setup(char *str, int *ints)
+{
+	static int commandline_current = 0;
+	int i;
+	if (ints[0] != 2)
+		printk("t128_setup : usage t128=address,irq\n");
+	else if (commandline_current < NO_OVERRIDES) {
+		overrides[commandline_current].address = ints[1];
+		overrides[commandline_current].irq = ints[2];
+		for (i = 0; i < NO_BASES; ++i)
+			if (bases[i].address == ints[1]) {
+				bases[i].noauto = 1;
+				break;
+			}
+		++commandline_current;
 	}
 }
 
@@ -194,100 +201,96 @@
  *
  */
 
-int __init t128_detect(struct scsi_host_template * tpnt){
-    static int current_override = 0, current_base = 0;
-    struct Scsi_Host *instance;
-    unsigned long base;
-    void __iomem *p;
-    int sig, count;
-
-    tpnt->proc_name = "t128";
-    tpnt->proc_info = &t128_proc_info;
-
-    for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
-	base = 0;
-	p = NULL;
-
-	if (overrides[current_override].address) {
-	    base = overrides[current_override].address;
-	    p = ioremap(bases[current_base].address, 0x2000);
-	    if (!p)
+int __init t128_detect(struct scsi_host_template *tpnt)
+{
+	static int current_override = 0, current_base = 0;
+	struct Scsi_Host *instance;
+	unsigned long base;
+	void __iomem *p;
+	int sig, count;
+
+	tpnt->proc_name = "t128";
+	tpnt->proc_info = &t128_proc_info;
+
+	for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
 		base = 0;
-	} else 
-	    for (; !base && (current_base < NO_BASES); ++current_base) {
+		p = NULL;
+
+		if (overrides[current_override].address) {
+			base = overrides[current_override].address;
+			p = ioremap(bases[current_base].address, 0x2000);
+			if (!p)
+				base = 0;
+		} else
+			for (; !base && (current_base < NO_BASES); ++current_base) {
 #if (TDEBUG & TDEBUG_INIT)
-    printk("scsi-t128 : probing address %08x\n", bases[current_base].address);
+				printk(KERN_DEBUG "scsi-t128 : probing address %08x\n", bases[current_base].address);
 #endif
-		if (bases[current_base].noauto)
-			continue;
-		p = ioremap(bases[current_base].address, 0x2000);
-		if (!p)
-			continue;
-		for (sig = 0; sig < NO_SIGNATURES; ++sig) 
-		    if (check_signature(p + signatures[sig].offset,
-					signatures[sig].string,
-					strlen(signatures[sig].string))) {
-			base = bases[current_base].address;
+				if (bases[current_base].noauto)
+					continue;
+				p = ioremap(bases[current_base].address, 0x2000);
+				if (!p)
+					continue;
+				for (sig = 0; sig < NO_SIGNATURES; ++sig)
+					if (check_signature(p + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
+						base = bases[current_base].address;
 #if (TDEBUG & TDEBUG_INIT)
-			printk("scsi-t128 : detected board.\n");
+						printk(KERN_DEBUG "scsi-t128 : detected board.\n");
 #endif
-			goto found;
-		    }
-		iounmap(p);
-	    }
+						goto found;
+					}
+				iounmap(p);
+			}
 
 #if defined(TDEBUG) && (TDEBUG & TDEBUG_INIT)
-	printk("scsi-t128 : base = %08x\n", (unsigned int) base);
+		printk("scsi-t128 : base = %08x\n", (unsigned int) base);
 #endif
 
-	if (!base)
-	    break;
+		if (!base)
+			break;
 
 found:
-	instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
-	if(instance == NULL)
-		break;
-		
-	instance->base = base;
-	((struct NCR5380_hostdata *)instance->hostdata)->base = p;
-
-	NCR5380_init(instance, 0);
-
-	if (overrides[current_override].irq != IRQ_AUTO)
-	    instance->irq = overrides[current_override].irq;
-	else 
-	    instance->irq = NCR5380_probe_irq(instance, T128_IRQS);
-
-	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, t128_intr, IRQF_DISABLED, "t128", instance)) {
-		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
-		    instance->host_no, instance->irq);
-		instance->irq = SCSI_IRQ_NONE;
-	    } 
-
-	if (instance->irq == SCSI_IRQ_NONE) {
-	    printk("scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
-	    printk("scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
-	}
-
+		instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
+		if (instance == NULL)
+			break;
+
+		instance->base = base;
+		((struct NCR5380_hostdata *) instance->hostdata)->base = p;
+
+		NCR5380_init(instance, 0);
+
+		if (overrides[current_override].irq != IRQ_AUTO)
+			instance->irq = overrides[current_override].irq;
+		else
+			instance->irq = NCR5380_probe_irq(instance, T128_IRQS);
+
+		if (instance->irq != SCSI_IRQ_NONE)
+			if (request_irq(instance->irq, t128_intr, IRQF_DISABLED, "t128", instance)) {
+				printk(KERN_ERR "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
+				instance->irq = SCSI_IRQ_NONE;
+			}
+
+		if (instance->irq == SCSI_IRQ_NONE) {
+			printk(KERN_INFO "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
+			printk(KERN_INFO "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
+		}
 #if defined(TDEBUG) && (TDEBUG & TDEBUG_INIT)
-	printk("scsi%d : irq = %d\n", instance->host_no, instance->irq);
+		printk(KERN_DEBUG "scsi%d : irq = %d\n", instance->host_no, instance->irq);
 #endif
 
-	printk("scsi%d : at 0x%08lx", instance->host_no, instance->base);
-	if (instance->irq == SCSI_IRQ_NONE)
-	    printk (" interrupts disabled");
-	else 
-	    printk (" irq %d", instance->irq);
-	printk(" options CAN_QUEUE=%d  CMD_PER_LUN=%d release=%d",
-	    CAN_QUEUE, CMD_PER_LUN, T128_PUBLIC_RELEASE);
-	NCR5380_print_options(instance);
-	printk("\n");
-
-	++current_override;
-	++count;
-    }
-    return count;
+		printk(KERN_INFO "scsi%d : at 0x%08lx", instance->host_no, instance->base);
+		if (instance->irq == SCSI_IRQ_NONE)
+			printk(" interrupts disabled");
+		else
+			printk(" irq %d", instance->irq);
+		printk(" options CAN_QUEUE=%d  CMD_PER_LUN=%d release=%d", CAN_QUEUE, CMD_PER_LUN, T128_PUBLIC_RELEASE);
+		NCR5380_print_options(instance);
+		printk("\n");
+
+		++current_override;
+		++count;
+	}
+	return count;
 }
 
 static int t128_release(struct Scsi_Host *shost)
@@ -324,13 +327,12 @@
  * and matching the H_C_S coordinates to what DOS uses.
  */
 
-int t128_biosparam(struct scsi_device *sdev, struct block_device *bdev,
-		sector_t capacity, int * ip)
+int t128_biosparam(struct scsi_device *sdev, struct block_device *bdev, sector_t capacity, int *ip)
 {
-  ip[0] = 64;
-  ip[1] = 32;
-  ip[2] = capacity >> 11;
-  return 0;
+	ip[0] = 64;
+	ip[1] = 32;
+	ip[2] = capacity >> 11;
+	return 0;
 }
 
 /*
@@ -346,37 +348,32 @@
  * 	timeout.
  */
 
-static inline int NCR5380_pread (struct Scsi_Host *instance, unsigned char *dst,
-    int len) {
-    NCR5380_local_declare();
-    void __iomem *reg;
-    unsigned char *d = dst;
-    register int i = len;
-
-    NCR5380_setup(instance);
-    reg = base + T_DATA_REG_OFFSET;
-
-#if 0
-    for (; i; --i) {
-	while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
-#else
-    while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
-    for (; i; --i) {
-#endif
-	*d++ = readb(reg);
-    }
+static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst, int len)
+{
+	NCR5380_local_declare();
+	void __iomem *reg;
+	unsigned char *d = dst;
+	register int i = len;
 
-    if (readb(base + T_STATUS_REG_OFFSET) & T_ST_TIM) {
-	unsigned char tmp;
-	void __iomem *foo = base + T_CONTROL_REG_OFFSET;
-	tmp = readb(foo);
-	writeb(tmp | T_CR_CT, foo);
-	writeb(tmp, foo);
-	printk("scsi%d : watchdog timer fired in NCR5380_pread()\n",
-	    instance->host_no);
-	return -1;
-    } else
-	return 0;
+	NCR5380_setup(instance);
+	reg = base + T_DATA_REG_OFFSET;
+
+	while (!(readb(base + T_STATUS_REG_OFFSET) & T_ST_RDY))
+		cpu_relax();
+		
+	for (; i; --i)
+		*d++ = readb(reg);
+
+	if (readb(base + T_STATUS_REG_OFFSET) & T_ST_TIM) {
+		unsigned char tmp;
+		void __iomem *foo = base + T_CONTROL_REG_OFFSET;
+		tmp = readb(foo);
+		writeb(tmp | T_CR_CT, foo);
+		writeb(tmp, foo);
+		printk(KERN_WARNING "scsi%d : watchdog timer fired in NCR5380_pread()\n", instance->host_no);
+		return -1;
+	} else
+		return 0;
 }
 
 /*
@@ -392,37 +389,32 @@
  * 	timeout.
  */
 
-static inline int NCR5380_pwrite (struct Scsi_Host *instance, unsigned char *src,
-    int len) {
-    NCR5380_local_declare();
-    void __iomem *reg;
-    unsigned char *s = src;
-    register int i = len;
-
-    NCR5380_setup(instance);
-    reg = base + T_DATA_REG_OFFSET;
-
-#if 0
-    for (; i; --i) {
-	while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
-#else
-    while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
-    for (; i; --i) {
-#endif
-	writeb(*s++, reg);
-    }
-
-    if (readb(base + T_STATUS_REG_OFFSET) & T_ST_TIM) {
-	unsigned char tmp;
-	void __iomem *foo = base + T_CONTROL_REG_OFFSET;
-	tmp = readb(foo);
-	writeb(tmp | T_CR_CT, foo);
-	writeb(tmp, foo);
-	printk("scsi%d : watchdog timer fired in NCR5380_pwrite()\n",
-	    instance->host_no);
-	return -1;
-    } else 
-	return 0;
+static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src, int len)
+{
+	NCR5380_local_declare();
+	void __iomem *reg;
+	unsigned char *s = src;
+	register int i = len;
+
+	NCR5380_setup(instance);
+	reg = base + T_DATA_REG_OFFSET;
+
+	while (!(readb(base + T_STATUS_REG_OFFSET) & T_ST_RDY))
+		cpu_relax();
+
+	for (; i; --i)
+		writeb(*s++, reg);
+
+	if (readb(base + T_STATUS_REG_OFFSET) & T_ST_TIM) {
+		unsigned char tmp;
+		void __iomem *foo = base + T_CONTROL_REG_OFFSET;
+		tmp = readb(foo);
+		writeb(tmp | T_CR_CT, foo);
+		writeb(tmp, foo);
+		printk(KERN_WARNING "scsi%d : watchdog timer fired in NCR5380_pwrite()\n", instance->host_no);
+		return -1;
+	} else
+		return 0;
 }
 
 MODULE_LICENSE("GPL");
@@ -430,17 +422,18 @@
 #include "NCR5380.c"
 
 static struct scsi_host_template driver_template = {
-	.name           = "Trantor T128/T128F/T228",
-	.detect         = t128_detect,
-	.release        = t128_release,
-	.queuecommand   = t128_queue_command,
-	.eh_abort_handler = t128_abort,
-	.eh_bus_reset_handler    = t128_bus_reset,
-	.bios_param     = t128_biosparam,
-	.can_queue      = CAN_QUEUE,
-        .this_id        = 7,
-	.sg_tablesize   = SG_ALL,
-	.cmd_per_lun    = CMD_PER_LUN,
-	.use_clustering = DISABLE_CLUSTERING,
+	.name			= "Trantor T128/T128F/T228",
+	.detect 		= t128_detect,
+	.release		= t128_release,
+	.queuecommand 		= t128_queue_command,
+	.eh_abort_handler	= t128_abort,
+	.eh_bus_reset_handler	= t128_bus_reset,
+	.bios_param		= t128_biosparam,
+	.can_queue		= CAN_QUEUE,
+	.this_id		= 7,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= CMD_PER_LUN,
+	.use_clustering		= DISABLE_CLUSTERING,
 };
+
 #include "scsi_module.c"
