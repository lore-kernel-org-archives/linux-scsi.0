From: Ondrej Zary <linux@zary.sk>
Subject: [RFC PATCH 3/2] fdomain: Use SCSI host private data instead of global variables
Date: Mon,  8 Apr 2019 21:35:22 +0200
Message-ID: <20190408193522.16621-1-linux@zary.sk>
References: <20190407185617.8467-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190407185617.8467-1-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik Faith <faith@cs.unc.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Move global variables into SCSI host private data in order to support
multiple cards.

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/scsi/fdomain.c | 593 +++++++++++++++++++++++++------------------------
 1 file changed, 307 insertions(+), 286 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index fe9e373c27a8..83294cf6b668 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -384,29 +384,32 @@ enum out_port_type {
 
 /* .bss will zero all the static variables below */
 static int               port_base;
-static unsigned long     bios_base;
-static void __iomem *    bios_mem;
-static int               bios_major;
-static int               bios_minor;
-static int               PCI_bus;
-#ifdef CONFIG_PCI
-static struct pci_dev	*PCI_dev;
-#endif
-static int               Quantum;	/* Quantum board variant */
 static int               interrupt_level;
-static volatile int      in_command;
-static struct scsi_cmnd  *current_SC;
-static enum chip_type    chip              = unknown;
-static int               adapter_mask;
 static int               this_id;
 static int               setup_called;
 
+struct fdomain {
+	int port_base;
+	unsigned long bios_base;
+	void __iomem *bios_mem;
+	int bios_major;
+	int bios_minor;
+	int PCI_bus;
+#ifdef CONFIG_PCI
+	struct pci_dev *PCI_dev;
+#endif
+	int Quantum;	/* Quantum board variant */
+	int interrupt_level;
+	volatile int in_command;
+	struct scsi_cmnd *current_SC;
+	enum chip_type chip;
+	int adapter_mask;
+	int this_id;
 #if DEBUG_RACE
-static volatile int      in_interrupt_flag;
+	volatile int in_interrupt_flag;
 #endif
-
-static int               FIFO_Size = 0x2000; /* 8k FIFO for
-						pre-tmc18c30 chips */
+	int FIFO_Size;
+};
 
 static irqreturn_t       do_fdomain_16x0_intr( int irq, void *dev_id );
 /* Allow insmod parameters to be like LILO parameters.  For example:
@@ -518,22 +521,22 @@ static struct signature {
 
 static void print_banner( struct Scsi_Host *shpnt )
 {
-   if (!shpnt) return;		/* This won't ever happen */
+	struct fdomain *fd = shost_priv(shpnt);
 
-   if (bios_major < 0 && bios_minor < 0) {
+   if (fd->bios_major < 0 && fd->bios_minor < 0) {
       printk(KERN_INFO "scsi%d: <fdomain> No BIOS; using scsi id %d\n",
 	      shpnt->host_no, shpnt->this_id);
    } else {
       printk(KERN_INFO "scsi%d: <fdomain> BIOS version ", shpnt->host_no);
 
-      if (bios_major >= 0) printk("%d.", bios_major);
+      if (fd->bios_major >= 0) printk("%d.", fd->bios_major);
       else                 printk("?.");
 
-      if (bios_minor >= 0) printk("%d", bios_minor);
+      if (fd->bios_minor >= 0) printk("%d", fd->bios_minor);
       else                 printk("?.");
 
       printk( " at 0x%lx using scsi id %d\n",
-	      bios_base, shpnt->this_id );
+	      fd->bios_base, shpnt->this_id );
    }
 
 				/* If this driver works for later FD PCI
@@ -542,11 +545,11 @@ static void print_banner( struct Scsi_Host *shpnt )
 				   it's PCI it's a TMC-3260 - JTM */
    printk(KERN_INFO "scsi%d: <fdomain> %s chip at 0x%x irq ",
 	   shpnt->host_no,
-	   chip == tmc1800 ? "TMC-1800" : (chip == tmc18c50 ? "TMC-18C50" : (chip == tmc18c30 ? (PCI_bus ? "TMC-36C70 (PCI bus)" : "TMC-18C30") : "Unknown")),
-	   port_base);
+	   fd->chip == tmc1800 ? "TMC-1800" : (fd->chip == tmc18c50 ? "TMC-18C50" : (fd->chip == tmc18c30 ? (fd->PCI_bus ? "TMC-36C70 (PCI bus)" : "TMC-18C30") : "Unknown")),
+	   fd->port_base);
 
-   if (interrupt_level)
-   	printk("%d", interrupt_level);
+   if (fd->interrupt_level)
+	printk("%d", fd->interrupt_level);
    else
         printk("<none>");
 
@@ -568,8 +571,7 @@ int fdomain_setup(char *str)
 	port_base       = ints[0] >= 1 ? ints[1] : 0;
 	interrupt_level = ints[0] >= 2 ? ints[2] : 0;
 	this_id         = ints[0] >= 3 ? ints[3] : 0;
-   
-	bios_major = bios_minor = -1; /* Use geometry for BIOS version >= 3.4 */
+
 	++setup_called;
 	return 1;
 }
@@ -582,22 +584,24 @@ static void do_pause(unsigned amount)	/* Pause for amount*10 milliseconds */
 	mdelay(10*amount);
 }
 
-static inline void fdomain_make_bus_idle( void )
+static inline void fdomain_make_bus_idle(struct fdomain *fd)
 {
-   outb(0, port_base + SCSI_Cntl);
-   outb(0, port_base + SCSI_Mode_Cntl);
-   if (chip == tmc18c50 || chip == tmc18c30)
-	 outb(0x21 | PARITY_MASK, port_base + TMC_Cntl); /* Clear forced intr. */
+   outb(0, fd->port_base + SCSI_Cntl);
+   outb(0, fd->port_base + SCSI_Mode_Cntl);
+   if (fd->chip == tmc18c50 || fd->chip == tmc18c30)
+	 outb(0x21 | PARITY_MASK, fd->port_base + TMC_Cntl); /* Clear forced intr. */
    else
-	 outb(0x01 | PARITY_MASK, port_base + TMC_Cntl);
+	 outb(0x01 | PARITY_MASK, fd->port_base + TMC_Cntl);
 }
 
-static int fdomain_is_valid_port( int port )
+static int fdomain_is_valid_port(struct fdomain *fd, int port)
 {
 #if DEBUG_DETECT 
    printk( " (%x%x),",
 	   inb( port + MSB_ID_Code ), inb( port + LSB_ID_Code ) );
 #endif
+	fd->chip = unknown;
+	fd->FIFO_Size = 0x2000; /* 8k FIFO for pre-tmc18c30 chips */
 
    /* The MCA ID is a unique id for each MCA compatible board.  We
       are using ISA boards, but Future Domain provides the MCA ID
@@ -608,10 +612,10 @@ static int fdomain_is_valid_port( int port )
    if (inb( port + LSB_ID_Code ) != 0xe9) { /* test for 0x6127 id */
       if (inb( port + LSB_ID_Code ) != 0x27) return 0;
       if (inb( port + MSB_ID_Code ) != 0x61) return 0;
-      chip = tmc1800;
+      fd->chip = tmc1800;
    } else {				    /* test for 0xe960 id */
       if (inb( port + MSB_ID_Code ) != 0x60) return 0;
-      chip = tmc18c50;
+      fd->chip = tmc18c50;
 
 				/* Try to toggle 32-bit mode.  This only
 				   works on an 18c30 chip.  (User reports
@@ -622,8 +626,8 @@ static int fdomain_is_valid_port( int port )
       if ((inb( port + Configuration2 ) & 0x80) == 0x80) {
 	 outb( 0x00, port + IO_Control );
 	 if ((inb( port + Configuration2 ) & 0x80) == 0x00) {
-	    chip = tmc18c30;
-	    FIFO_Size = 0x800;	/* 2k FIFO */
+	    fd->chip = tmc18c30;
+	    fd->FIFO_Size = 0x800;	/* 2k FIFO */
 	 }
       }
 				/* If that failed, we are an 18c50. */
@@ -632,14 +636,14 @@ static int fdomain_is_valid_port( int port )
    return 1;
 }
 
-static int fdomain_test_loopback( void )
+static int fdomain_test_loopback(int port_base)
 {
    int i;
    int result;
 
    for (i = 0; i < 255; i++) {
-      outb( i, port_base + Write_Loopback );
-      result = inb( port_base + Read_Loopback );
+      outb(i, port_base + Write_Loopback);
+      result = inb(port_base + Read_Loopback);
       if (i != result)
 	    return 1;
    }
@@ -662,7 +666,7 @@ static int fdomain_test_loopback( void )
    configure a PCI system so that one of these IRQs will be used by the
    Future Domain card. */
 
-static int fdomain_get_irq( int base )
+static int fdomain_get_irq(struct fdomain *fd, int base)
 {
    int options = inb(base + Configuration1);
 
@@ -675,12 +679,12 @@ static int fdomain_get_irq( int base )
       boards on the PCI bus, so just assume we
       have the right board. */
 
-   if (chip != tmc18c30 && !PCI_bus && addresses[(options & 0xc0) >> 6 ] != bios_base)
+   if (fd->chip != tmc18c30 && !fd->PCI_bus && addresses[(options & 0xc0) >> 6 ] != fd->bios_base)
    	return 0;
    return ints[(options & 0x0e) >> 1];
 }
 
-static int fdomain_isa_detect( int *irq, int *iobase )
+static int fdomain_isa_detect(struct fdomain *fd)
 {
    int i, j;
    int base = 0xdeadbeef;
@@ -695,18 +699,18 @@ static int fdomain_isa_detect( int *irq, int *iobase )
       if (!p)
 	continue;
 #if DEBUG_DETECT
-      printk( " %lx(%lx),", addresses[i], bios_base );
+      printk( " %lx(%lx),", addresses[i], fd->bios_base );
 #endif
       for (j = 0; j < SIGNATURE_COUNT; j++) {
 	 if (check_signature(p + signatures[j].sig_offset,
 			     signatures[j].signature,
 			     signatures[j].sig_length )) {
-	    bios_major = signatures[j].major_bios_version;
-	    bios_minor = signatures[j].minor_bios_version;
-	    PCI_bus    = (signatures[j].flag == 1);
-	    Quantum    = (signatures[j].flag > 1) ? signatures[j].flag : 0;
-	    bios_base  = addresses[i];
-	    bios_mem   = p;
+	    fd->bios_major = signatures[j].major_bios_version;
+	    fd->bios_minor = signatures[j].minor_bios_version;
+	    fd->PCI_bus    = (signatures[j].flag == 1);
+	    fd->Quantum    = (signatures[j].flag > 1) ? signatures[j].flag : 0;
+	    fd->bios_base  = addresses[i];
+	    fd->bios_mem   = p;
 	    goto found;
 	 }
       }
@@ -714,7 +718,7 @@ static int fdomain_isa_detect( int *irq, int *iobase )
    }
  
 found:
-   if (bios_major == 2) {
+   if (fd->bios_major == 2) {
       /* The TMC-1660/TMC-1680 has a RAM area just after the BIOS ROM.
 	 Assuming the ROM is enabled (otherwise we wouldn't have been
 	 able to read the ROM signature :-), then the ROM sets up the
@@ -723,16 +727,16 @@ static int fdomain_isa_detect( int *irq, int *iobase )
 	 DOS (this geometry has nothing to do with physical geometry).
        */
 
-      switch (Quantum) {
+      switch (fd->Quantum) {
       case 2:			/* ISA_200S */
       case 3:			/* ISA_250MG */
-	 base = readb(bios_mem + 0x1fa2) + (readb(bios_mem + 0x1fa3) << 8);
+	 base = readb(fd->bios_mem + 0x1fa2) + (readb(fd->bios_mem + 0x1fa3) << 8);
 	 break;
       case 4:			/* ISA_200S (another one) */
-	 base = readb(bios_mem + 0x1fa3) + (readb(bios_mem + 0x1fa4) << 8);
+	 base = readb(fd->bios_mem + 0x1fa3) + (readb(fd->bios_mem + 0x1fa4) << 8);
 	 break;
       default:
-	 base = readb(bios_mem + 0x1fcc) + (readb(bios_mem + 0x1fcd) << 8);
+	 base = readb(fd->bios_mem + 0x1fcc) + (readb(fd->bios_mem + 0x1fcd) << 8);
 	 break;
       }
    
@@ -744,12 +748,12 @@ static int fdomain_isa_detect( int *irq, int *iobase )
 	if (base == ports[i]) {
 		if (!request_region(base, 0x10, "fdomain"))
 			break;
-		if (!fdomain_is_valid_port(base)) {
+		if (!fdomain_is_valid_port(fd, base)) {
 			release_region(base, 0x10);
 			break;
 		}
-		*irq    = fdomain_get_irq( base );
-		*iobase = base;
+		fd->interrupt_level    = fdomain_get_irq(fd, base);
+		fd->port_base = base;
 		return 1;
 	}
       }
@@ -783,7 +787,7 @@ static int fdomain_isa_detect( int *irq, int *iobase )
 #if DEBUG_DETECT
       printk( " %x,", base );
 #endif
-      flag = fdomain_is_valid_port(base);
+      flag = fdomain_is_valid_port(fd, base);
       if (flag)
 	break;
       release_region(base, 0x10);
@@ -796,20 +800,18 @@ static int fdomain_isa_detect( int *irq, int *iobase )
 
    if (!flag) return 0;		/* iobase not found */
 
-   *irq    = fdomain_get_irq( base );
-   *iobase = base;
+   fd->interrupt_level    = fdomain_get_irq(fd, base);
+   fd->port_base = base;
 
    return 1;			/* success */
 }
 
 #else /* PCMCIA */
 
-static int fdomain_isa_detect( int *irq, int *iobase )
+static int fdomain_isa_detect(struct fdomain *fd)
 {
-	if (irq)
-		*irq = 0;
-	if (iobase)
-		*iobase = 0;
+	fd->interrupt_level = 0;
+	fd->port_base = 0;
 	return 0;
 }
 
@@ -821,7 +823,7 @@ static int fdomain_isa_detect( int *irq, int *iobase )
    the PCI configuration registers. */
 
 #ifdef CONFIG_PCI
-static int fdomain_pci_bios_detect( int *irq, int *iobase, struct pci_dev **ret_pdev )
+static int fdomain_pci_bios_detect(struct fdomain *fd)
 {
    unsigned int     pci_irq;                /* PCI interrupt line */
    unsigned long    pci_base;               /* PCI I/O base address */
@@ -863,27 +865,26 @@ static int fdomain_pci_bios_detect( int *irq, int *iobase, struct pci_dev **ret_
    /* Now we have the I/O base address and interrupt from the PCI
       configuration registers. */
 
-   *irq    = pci_irq;
-   *iobase = pci_base;
-   *ret_pdev = pdev;
+   fd->interrupt_level    = pci_irq;
+   fd->port_base = pci_base;
 
 #if DEBUG_DETECT
    printk( "scsi: <fdomain> TMC-3260 detect:"
-	   " IRQ = %d, I/O base = 0x%x [0x%lx]\n", *irq, *iobase, pci_base );
+	   " IRQ = %d, I/O base = 0x%x [0x%lx]\n", fd->interrupt_level, fd->port_base, pci_base );
 #endif
 
-   if (!fdomain_is_valid_port(pci_base)) {
+   if (!fdomain_is_valid_port(fd, pci_base)) {
       printk(KERN_ERR "scsi: <fdomain> PCI card detected, but driver not loaded (invalid port)\n" );
       release_region(pci_base, 0x10);
       goto fail;
    }
 
 				/* Fill in a few global variables.  Ugh. */
-   bios_major = bios_minor = -1;
-   PCI_bus    = 1;
-   PCI_dev    = pdev;
-   Quantum    = 0;
-   bios_base  = 0;
+   fd->bios_major = fd->bios_minor = -1;
+   fd->PCI_bus    = 1;
+   fd->PCI_dev    = pdev;
+   fd->Quantum    = 0;
+   fd->bios_base  = 0;
    
    return 1;
 fail:
@@ -893,12 +894,24 @@ static int fdomain_pci_bios_detect( int *irq, int *iobase, struct pci_dev **ret_
 
 #endif
 
+void fdomain_16x0_reset(int port_base)
+{
+   outb(1, port_base + SCSI_Cntl);
+   do_pause( 2 );
+   outb(0, port_base + SCSI_Cntl);
+   do_pause( 115 );
+   outb(0, port_base + SCSI_Mode_Cntl);
+   outb(PARITY_MASK, port_base + TMC_Cntl);
+}
+
 struct Scsi_Host *__fdomain_16x0_detect(struct scsi_host_template *tpnt )
 {
    int              retcode;
    struct Scsi_Host *shpnt;
-   struct pci_dev *pdev = NULL;
+   struct fdomain fd_tmp;
+   struct fdomain *fd;
 
+   memset(&fd_tmp, 0, sizeof(struct fdomain));
    if (setup_called) {
 #if DEBUG_DETECT
       printk( "scsi: <fdomain> No BIOS, using port_base = 0x%x, irq = %d\n",
@@ -909,23 +922,27 @@ struct Scsi_Host *__fdomain_16x0_detect(struct scsi_host_template *tpnt )
 	 printk( "scsi: <fdomain> Bad LILO/INSMOD parameters?\n" );
 	 return NULL;
       }
-      if (!fdomain_is_valid_port( port_base )) {
+      if (!fdomain_is_valid_port(&fd_tmp, port_base)) {
 	 printk( "scsi: <fdomain> Cannot locate chip at port base 0x%x\n",
 		 port_base );
 	 printk( "scsi: <fdomain> Bad LILO/INSMOD parameters?\n" );
 	 release_region(port_base, 0x10);
 	 return NULL;
       }
+      fd_tmp.port_base = port_base;
+      fd_tmp.interrupt_level = interrupt_level;
+      fd_tmp.this_id = this_id;
+      fd_tmp.bios_major = fd_tmp.bios_minor = -1; /* Use geometry for BIOS version >= 3.4 */
    } else {
       int flag = 0;
 
 #ifdef CONFIG_PCI
 				/* Try PCI detection first */
-      flag = fdomain_pci_bios_detect( &interrupt_level, &port_base, &pdev );
+      flag = fdomain_pci_bios_detect(&fd_tmp);
 #endif
       if (!flag) {
 				/* Then try ISA bus detection */
-	 flag = fdomain_isa_detect( &interrupt_level, &port_base );
+	 flag = fdomain_isa_detect(&fd_tmp);
 
 	 if (!flag) {
 	    printk( "scsi: <fdomain> Detection failed (no card)\n" );
@@ -934,62 +951,64 @@ struct Scsi_Host *__fdomain_16x0_detect(struct scsi_host_template *tpnt )
       }
    }
 
-   fdomain_16x0_host_reset(NULL);
+   fdomain_16x0_reset(fd_tmp.port_base);
 
-   if (fdomain_test_loopback()) {
-      printk(KERN_ERR  "scsi: <fdomain> Detection failed (loopback test failed at port base 0x%x)\n", port_base);
+   if (fdomain_test_loopback(fd_tmp.port_base)) {
+      printk(KERN_ERR  "scsi: <fdomain> Detection failed (loopback test failed at port base 0x%x)\n", fd_tmp.port_base);
       if (setup_called) {
 	 printk(KERN_ERR "scsi: <fdomain> Bad LILO/INSMOD parameters?\n");
       }
       goto fail;
    }
 
-   if (this_id) {
-      tpnt->this_id = (this_id & 0x07);
-      adapter_mask  = (1 << tpnt->this_id);
+   if (fd_tmp.this_id) {
+      tpnt->this_id = (fd_tmp.this_id & 0x07);
+      fd_tmp.adapter_mask  = (1 << tpnt->this_id);
    } else {
-      if (PCI_bus || (bios_major == 3 && bios_minor >= 2) || bios_major < 0) {
+      if (fd_tmp.PCI_bus || (fd_tmp.bios_major == 3 && fd_tmp.bios_minor >= 2) || fd_tmp.bios_major < 0) {
 	 tpnt->this_id = 7;
-	 adapter_mask  = 0x80;
+	 fd_tmp.adapter_mask  = 0x80;
       } else {
 	 tpnt->this_id = 6;
-	 adapter_mask  = 0x40;
+	 fd_tmp.adapter_mask  = 0x40;
       }
    }
 
 /* Print out a banner here in case we can't
    get resources.  */
 
-   shpnt = scsi_host_alloc( tpnt, 0 );
+   shpnt = scsi_host_alloc(tpnt, sizeof(struct fdomain));
    if(shpnt == NULL) {
-	release_region(port_base, 0x10);
+	release_region(fd_tmp.port_base, 0x10);
    	return NULL;
    }
-   shpnt->irq = interrupt_level;
-   shpnt->io_port = port_base;
+   fd = shost_priv(shpnt);
+   memcpy(fd, &fd_tmp, sizeof(struct fdomain));
+   shpnt->irq = fd->interrupt_level;
+   shpnt->io_port = fd->port_base;
    shpnt->n_io_port = 0x10;
    print_banner( shpnt );
 
    /* Log IRQ with kernel */   
-   if (!interrupt_level) {
+   if (!fd->interrupt_level) {
       printk(KERN_ERR "scsi: <fdomain> Card Detected, but driver not loaded (no IRQ)\n" );
       goto fail;
    } else {
       /* Register the IRQ with the kernel */
 
-      retcode = request_irq( interrupt_level,
-			     do_fdomain_16x0_intr, pdev?IRQF_SHARED:0, "fdomain", shpnt);
+      retcode = request_irq(fd->interrupt_level,
+			     do_fdomain_16x0_intr, fd->PCI_dev?IRQF_SHARED:0, "fdomain", fd);
 
       if (retcode < 0) {
 	 if (retcode == -EINVAL) {
-	    printk(KERN_ERR "scsi: <fdomain> IRQ %d is bad!\n", interrupt_level );
+	    printk(KERN_ERR "scsi: <fdomain> IRQ %d is bad!\n", fd->interrupt_level);
 	    printk(KERN_ERR "                This shouldn't happen!\n" );
 	    printk(KERN_ERR "                Send mail to faith@acm.org\n" );
 	 } else if (retcode == -EBUSY) {
-	    printk(KERN_ERR "scsi: <fdomain> IRQ %d is already in use!\n", interrupt_level );
+	    printk(KERN_ERR "scsi: <fdomain> IRQ %d is already in use!\n", fd->interrupt_level);
 	    printk(KERN_ERR "                Please use another IRQ!\n" );
 	 } else {
-	    printk(KERN_ERR "scsi: <fdomain> Error getting IRQ %d\n", interrupt_level );
+	    printk(KERN_ERR "scsi: <fdomain> Error getting IRQ %d\n", fd->interrupt_level);
 	    printk(KERN_ERR "                This shouldn't happen!\n" );
 	    printk(KERN_ERR "                Send mail to faith@acm.org\n" );
 	 }
@@ -999,8 +1018,8 @@ struct Scsi_Host *__fdomain_16x0_detect(struct scsi_host_template *tpnt )
    }
    return shpnt;
 fail:
-   pci_dev_put(pdev);
-   release_region(port_base, 0x10);
+   pci_dev_put(fd->PCI_dev);
+   release_region(fd->port_base, 0x10);
    return NULL;
 }
 
@@ -1036,7 +1055,7 @@ static int fdomain_arbitrate( void )
 #endif
    
    outb(0x00, port_base + SCSI_Cntl);              /* Disable data drivers */
-   outb(adapter_mask, port_base + SCSI_Data_NoACK); /* Set our id bit */
+   outb(fd->adapter_mask, port_base + SCSI_Data_NoACK); /* Set our id bit */
    outb(0x04 | PARITY_MASK, port_base + TMC_Cntl); /* Start arbitration */
 
    timeout = 500;
@@ -1048,7 +1067,7 @@ static int fdomain_arbitrate( void )
    } while (--timeout);
 
    /* Make bus idle */
-   fdomain_make_bus_idle();
+   fdomain_make_bus_idle(fd);
 
 #if EVERY_ACCESS
    printk( "Arbitration failed, status = %x\n", status );
@@ -1060,7 +1079,7 @@ static int fdomain_arbitrate( void )
 }
 #endif
 
-static int fdomain_select( int target )
+static int fdomain_select(struct fdomain *fd, int target)
 {
    int           status;
    unsigned long timeout;
@@ -1068,25 +1087,25 @@ static int fdomain_select( int target )
    static int    flag = 0;
 #endif
 
-   outb(0x82, port_base + SCSI_Cntl); /* Bus Enable + Select */
-   outb(adapter_mask | (1 << target), port_base + SCSI_Data_NoACK);
+   outb(0x82, fd->port_base + SCSI_Cntl); /* Bus Enable + Select */
+   outb(fd->adapter_mask | (1 << target), fd->port_base + SCSI_Data_NoACK);
 
    /* Stop arbitration and enable parity */
-   outb(PARITY_MASK, port_base + TMC_Cntl); 
+   outb(PARITY_MASK, fd->port_base + TMC_Cntl); 
 
    timeout = 350;			/* 350 msec */
 
    do {
-      status = inb(port_base + SCSI_Status); /* Read adapter status */
+      status = inb(fd->port_base + SCSI_Status); /* Read adapter status */
       if (status & 1) {			/* Busy asserted */
 	 /* Enable SCSI Bus (on error, should make bus idle with 0) */
-	 outb(0x80, port_base + SCSI_Cntl);
+	 outb(0x80,fd-> port_base + SCSI_Cntl);
 	 return 0;
       }
       mdelay(1);			/* wait one msec */
    } while (--timeout);
    /* Make bus idle */
-   fdomain_make_bus_idle();
+   fdomain_make_bus_idle(fd);
 #if EVERY_ACCESS
    if (!target) printk( "Selection failed\n" );
 #endif
@@ -1101,26 +1120,27 @@ static int fdomain_select( int target )
    return 1;
 }
 
-static void my_done(int error)
+static void my_done(struct fdomain *fd, int error)
 {
-   if (in_command) {
-      in_command = 0;
-      outb(0x00, port_base + Interrupt_Cntl);
-      fdomain_make_bus_idle();
-      current_SC->result = error;
-      if (current_SC->scsi_done)
-	    current_SC->scsi_done( current_SC );
+   if (fd->in_command) {
+      fd->in_command = 0;
+      outb(0x00, fd->port_base + Interrupt_Cntl);
+      fdomain_make_bus_idle(fd);
+      fd->current_SC->result = error;
+      if (fd->current_SC->scsi_done)
+	    fd->current_SC->scsi_done(fd->current_SC);
       else panic( "scsi: <fdomain> current_SC->scsi_done() == NULL" );
    } else {
       panic( "scsi: <fdomain> my_done() called outside of command\n" );
    }
 #if DEBUG_RACE
-   in_interrupt_flag = 0;
+   fd->in_interrupt_flag = 0;
 #endif
 }
 
 static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
 {
+   struct fdomain *fd = dev_id;
    unsigned long flags;
    int      status;
    int      done = 0;
@@ -1133,23 +1153,23 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
 				   running. */
 
    /* Check for other IRQ sources */
-   if ((inb(port_base + TMC_Status) & 0x01) == 0)
+   if ((inb(fd->port_base + TMC_Status) & 0x01) == 0)
    	return IRQ_NONE;
 
    /* It is our IRQ */   	
-   outb(0x00, port_base + Interrupt_Cntl);
+   outb(0x00, fd->port_base + Interrupt_Cntl);
 
    /* We usually have one spurious interrupt after each command.  Ignore it. */
-   if (!in_command || !current_SC) {	/* Spurious interrupt */
+   if (!fd->in_command || !fd->current_SC) {	/* Spurious interrupt */
 #if EVERY_ACCESS
       printk( "Spurious interrupt, in_command = %d, current_SC = %x\n",
-	      in_command, current_SC );
+	      fd->in_command, fd->current_SC);
 #endif
       return IRQ_NONE;
    }
 
    /* Abort calls my_done, so we do nothing here. */
-   if (current_SC->SCp.phase & aborted) {
+   if (fd->current_SC->SCp.phase & aborted) {
 #if DEBUG_ABORT
       printk( "scsi: <fdomain> Interrupt after abort, ignoring\n" );
 #endif
@@ -1158,212 +1178,212 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
    }
 
 #if DEBUG_RACE
-   ++in_interrupt_flag;
+   ++fd->in_interrupt_flag;
 #endif
 
-   if (current_SC->SCp.phase & in_arbitration) {
-      status = inb(port_base + TMC_Status);        /* Read adapter status */
+   if (fd->current_SC->SCp.phase & in_arbitration) {
+      status = inb(fd->port_base + TMC_Status);        /* Read adapter status */
       if (!(status & 0x02)) {
 #if EVERY_ACCESS
 	 printk( " AFAIL " );
 #endif
-         spin_lock_irqsave(current_SC->device->host->host_lock, flags);
-	 my_done( DID_BUS_BUSY << 16 );
-         spin_unlock_irqrestore(current_SC->device->host->host_lock, flags);
+         spin_lock_irqsave(fd->current_SC->device->host->host_lock, flags);
+	 my_done(fd, DID_BUS_BUSY << 16);
+         spin_unlock_irqrestore(fd->current_SC->device->host->host_lock, flags);
 	 return IRQ_HANDLED;
       }
-      current_SC->SCp.phase = in_selection;
+      fd->current_SC->SCp.phase = in_selection;
       
-      outb(0x40 | FIFO_COUNT, port_base + Interrupt_Cntl);
+      outb(0x40 | FIFO_COUNT, fd->port_base + Interrupt_Cntl);
 
-      outb(0x82, port_base + SCSI_Cntl); /* Bus Enable + Select */
-      outb(adapter_mask | (1 << scmd_id(current_SC)), port_base + SCSI_Data_NoACK);
+      outb(0x82, fd->port_base + SCSI_Cntl); /* Bus Enable + Select */
+      outb(fd->adapter_mask | (1 << scmd_id(fd->current_SC)), fd->port_base + SCSI_Data_NoACK);
       
       /* Stop arbitration and enable parity */
-      outb(0x10 | PARITY_MASK, port_base + TMC_Cntl);
+      outb(0x10 | PARITY_MASK, fd->port_base + TMC_Cntl);
 #if DEBUG_RACE
-      in_interrupt_flag = 0;
+      fd->in_interrupt_flag = 0;
 #endif
       return IRQ_HANDLED;
-   } else if (current_SC->SCp.phase & in_selection) {
-      status = inb(port_base + SCSI_Status);
+   } else if (fd->current_SC->SCp.phase & in_selection) {
+      status = inb(fd->port_base + SCSI_Status);
       if (!(status & 0x01)) {
 	 /* Try again, for slow devices */
-	 if (fdomain_select( scmd_id(current_SC) )) {
+	 if (fdomain_select(fd,scmd_id(fd->current_SC))) {
 #if EVERY_ACCESS
 	    printk( " SFAIL " );
 #endif
-            spin_lock_irqsave(current_SC->device->host->host_lock, flags);
-	    my_done( DID_NO_CONNECT << 16 );
-            spin_unlock_irqrestore(current_SC->device->host->host_lock, flags);
+            spin_lock_irqsave(fd->current_SC->device->host->host_lock, flags);
+	    my_done(fd, DID_NO_CONNECT << 16);
+            spin_unlock_irqrestore(fd->current_SC->device->host->host_lock, flags);
 	    return IRQ_HANDLED;
 	 } else {
 #if EVERY_ACCESS
 	    printk( " AltSel " );
 #endif
 	    /* Stop arbitration and enable parity */
-	    outb(0x10 | PARITY_MASK, port_base + TMC_Cntl);
+	    outb(0x10 | PARITY_MASK, fd->port_base + TMC_Cntl);
 	 }
       }
-      current_SC->SCp.phase = in_other;
-      outb(0x90 | FIFO_COUNT, port_base + Interrupt_Cntl);
-      outb(0x80, port_base + SCSI_Cntl);
+      fd->current_SC->SCp.phase = in_other;
+      outb(0x90 | FIFO_COUNT, fd->port_base + Interrupt_Cntl);
+      outb(0x80, fd->port_base + SCSI_Cntl);
 #if DEBUG_RACE
-      in_interrupt_flag = 0;
+      fd->in_interrupt_flag = 0;
 #endif
       return IRQ_HANDLED;
    }
    
    /* current_SC->SCp.phase == in_other: this is the body of the routine */
    
-   status = inb(port_base + SCSI_Status);
+   status = inb(fd->port_base + SCSI_Status);
    
    if (status & 0x10) {	/* REQ */
       
       switch (status & 0x0e) {
        
       case 0x08:		/* COMMAND OUT */
-	 outb(current_SC->cmnd[current_SC->SCp.sent_command++],
-	      port_base + Write_SCSI_Data);
+	 outb(fd->current_SC->cmnd[fd->current_SC->SCp.sent_command++],
+	      fd->port_base + Write_SCSI_Data);
 #if EVERY_ACCESS
 	 printk( "CMD = %x,",
-		 current_SC->cmnd[ current_SC->SCp.sent_command - 1] );
+		 fd->current_SC->cmnd[fd->current_SC->SCp.sent_command - 1]);
 #endif
 	 break;
       case 0x00:		/* DATA OUT -- tmc18c50/tmc18c30 only */
-	 if (chip != tmc1800 && !current_SC->SCp.have_data_in) {
-	    current_SC->SCp.have_data_in = -1;
-	    outb(0xd0 | PARITY_MASK, port_base + TMC_Cntl);
+	 if (fd->chip != tmc1800 && !fd->current_SC->SCp.have_data_in) {
+	    fd->current_SC->SCp.have_data_in = -1;
+	    outb(0xd0 | PARITY_MASK, fd->port_base + TMC_Cntl);
 	 }
 	 break;
       case 0x04:		/* DATA IN -- tmc18c50/tmc18c30 only */
-	 if (chip != tmc1800 && !current_SC->SCp.have_data_in) {
-	    current_SC->SCp.have_data_in = 1;
-	    outb(0x90 | PARITY_MASK, port_base + TMC_Cntl);
+	 if (fd->chip != tmc1800 && !fd->current_SC->SCp.have_data_in) {
+	    fd->current_SC->SCp.have_data_in = 1;
+	    outb(0x90 | PARITY_MASK, fd->port_base + TMC_Cntl);
 	 }
 	 break;
       case 0x0c:		/* STATUS IN */
-	 current_SC->SCp.Status = inb(port_base + Read_SCSI_Data);
+	 fd->current_SC->SCp.Status = inb(fd->port_base + Read_SCSI_Data);
 #if EVERY_ACCESS
-	 printk( "Status = %x, ", current_SC->SCp.Status );
+	 printk( "Status = %x, ", fd->current_SC->SCp.Status );
 #endif
 #if ERRORS_ONLY
-	 if (current_SC->SCp.Status
-	     && current_SC->SCp.Status != 2
-	     && current_SC->SCp.Status != 8) {
+	 if (fd->current_SC->SCp.Status
+	     && fd->current_SC->SCp.Status != 2
+	     && fd->current_SC->SCp.Status != 8) {
 	    printk( "scsi: <fdomain> target = %d, command = %x, status = %x\n",
-		    current_SC->device->id,
-		    current_SC->cmnd[0],
-		    current_SC->SCp.Status );
+		    fd->current_SC->device->id,
+		    fd->current_SC->cmnd[0],
+		    fd->current_SC->SCp.Status );
 	 }
 #endif
 	       break;
       case 0x0a:		/* MESSAGE OUT */
-	 outb(MESSAGE_REJECT, port_base + Write_SCSI_Data); /* Reject */
+	 outb(MESSAGE_REJECT, fd->port_base + Write_SCSI_Data); /* Reject */
 	 break;
       case 0x0e:		/* MESSAGE IN */
-	 current_SC->SCp.Message = inb(port_base + Read_SCSI_Data);
+	 fd->current_SC->SCp.Message = inb(fd->port_base + Read_SCSI_Data);
 #if EVERY_ACCESS
-	 printk( "Message = %x, ", current_SC->SCp.Message );
+	 printk( "Message = %x, ", fd->current_SC->SCp.Message );
 #endif
-	 if (!current_SC->SCp.Message) ++done;
+	 if (!fd->current_SC->SCp.Message) ++done;
 #if DEBUG_MESSAGES || EVERY_ACCESS
-	 if (current_SC->SCp.Message) {
+	 if (fd->current_SC->SCp.Message) {
 	    printk( "scsi: <fdomain> message = %x\n",
-		    current_SC->SCp.Message );
+		    fd->current_SC->SCp.Message );
 	 }
 #endif
 	 break;
       }
    }
 
-   if (chip == tmc1800 && !current_SC->SCp.have_data_in
-       && (current_SC->SCp.sent_command >= current_SC->cmd_len)) {
+   if (fd->chip == tmc1800 && !fd->current_SC->SCp.have_data_in
+       && (fd->current_SC->SCp.sent_command >= fd->current_SC->cmd_len)) {
       
-      if(current_SC->sc_data_direction == DMA_TO_DEVICE)
+      if (fd->current_SC->sc_data_direction == DMA_TO_DEVICE)
       {
-	 current_SC->SCp.have_data_in = -1;
-	 outb(0xd0 | PARITY_MASK, port_base + TMC_Cntl);
+	 fd->current_SC->SCp.have_data_in = -1;
+	 outb(0xd0 | PARITY_MASK, fd->port_base + TMC_Cntl);
       }
       else
       {
-	 current_SC->SCp.have_data_in = 1;
-	 outb(0x90 | PARITY_MASK, port_base + TMC_Cntl);
+	 fd->current_SC->SCp.have_data_in = 1;
+	 outb(0x90 | PARITY_MASK, fd->port_base + TMC_Cntl);
       }
    }
 
-   if (current_SC->SCp.have_data_in == -1) { /* DATA OUT */
-      while ((data_count = FIFO_Size - inw(port_base + FIFO_Data_Count)) > 512) {
+   if (fd->current_SC->SCp.have_data_in == -1) { /* DATA OUT */
+      while ((data_count = fd->FIFO_Size - inw(fd->port_base + FIFO_Data_Count)) > 512) {
 #if EVERY_ACCESS
 	 printk( "DC=%d, ", data_count ) ;
 #endif
-	 if (data_count > current_SC->SCp.this_residual)
-	       data_count = current_SC->SCp.this_residual;
+	 if (data_count > fd->current_SC->SCp.this_residual)
+	       data_count = fd->current_SC->SCp.this_residual;
 	 if (data_count > 0) {
 #if EVERY_ACCESS
 	    printk( "%d OUT, ", data_count );
 #endif
 	    if (data_count == 1) {
-	       outb(*current_SC->SCp.ptr++, port_base + Write_FIFO);
-	       --current_SC->SCp.this_residual;
+	       outb(*fd->current_SC->SCp.ptr++, fd->port_base + Write_FIFO);
+	       --fd->current_SC->SCp.this_residual;
 	    } else {
 	       data_count >>= 1;
-	       outsw(port_base + Write_FIFO, current_SC->SCp.ptr, data_count);
-	       current_SC->SCp.ptr += 2 * data_count;
-	       current_SC->SCp.this_residual -= 2 * data_count;
+	       outsw(fd->port_base + Write_FIFO, fd->current_SC->SCp.ptr, data_count);
+	       fd->current_SC->SCp.ptr += 2 * data_count;
+	       fd->current_SC->SCp.this_residual -= 2 * data_count;
 	    }
 	 }
-	 if (!current_SC->SCp.this_residual) {
-	    if (current_SC->SCp.buffers_residual) {
-	       --current_SC->SCp.buffers_residual;
-	       ++current_SC->SCp.buffer;
-	       current_SC->SCp.ptr = sg_virt(current_SC->SCp.buffer);
-	       current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
+	 if (!fd->current_SC->SCp.this_residual) {
+	    if (fd->current_SC->SCp.buffers_residual) {
+	       --fd->current_SC->SCp.buffers_residual;
+	       ++fd->current_SC->SCp.buffer;
+	       fd->current_SC->SCp.ptr = sg_virt(fd->current_SC->SCp.buffer);
+	       fd->current_SC->SCp.this_residual = fd->current_SC->SCp.buffer->length;
 	    } else
 		  break;
 	 }
       }
    }
    
-   if (current_SC->SCp.have_data_in == 1) { /* DATA IN */
-      while ((data_count = inw(port_base + FIFO_Data_Count)) > 0) {
+   if (fd->current_SC->SCp.have_data_in == 1) { /* DATA IN */
+      while ((data_count = inw(fd->port_base + FIFO_Data_Count)) > 0) {
 #if EVERY_ACCESS
 	 printk( "DC=%d, ", data_count );
 #endif
-	 if (data_count > current_SC->SCp.this_residual)
-	       data_count = current_SC->SCp.this_residual;
+	 if (data_count > fd->current_SC->SCp.this_residual)
+	       data_count = fd->current_SC->SCp.this_residual;
 	 if (data_count) {
 #if EVERY_ACCESS
 	    printk( "%d IN, ", data_count );
 #endif
 	    if (data_count == 1) {
-	       *current_SC->SCp.ptr++ = inb(port_base + Read_FIFO);
-	       --current_SC->SCp.this_residual;
+	       *fd->current_SC->SCp.ptr++ = inb(fd->port_base + Read_FIFO);
+	       --fd->current_SC->SCp.this_residual;
 	    } else {
 	       data_count >>= 1; /* Number of words */
-	       insw(port_base + Read_FIFO, current_SC->SCp.ptr, data_count);
-	       current_SC->SCp.ptr += 2 * data_count;
-	       current_SC->SCp.this_residual -= 2 * data_count;
+	       insw(fd->port_base + Read_FIFO, fd->current_SC->SCp.ptr, data_count);
+	       fd->current_SC->SCp.ptr += 2 * data_count;
+	       fd->current_SC->SCp.this_residual -= 2 * data_count;
 	    }
 	 }
-	 if (!current_SC->SCp.this_residual
-	     && current_SC->SCp.buffers_residual) {
-	    --current_SC->SCp.buffers_residual;
-	    ++current_SC->SCp.buffer;
-	    current_SC->SCp.ptr = sg_virt(current_SC->SCp.buffer);
-	    current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
+	 if (!fd->current_SC->SCp.this_residual
+	     && fd->current_SC->SCp.buffers_residual) {
+	    --fd->current_SC->SCp.buffers_residual;
+	    ++fd->current_SC->SCp.buffer;
+	    fd->current_SC->SCp.ptr = sg_virt(fd->current_SC->SCp.buffer);
+	    fd->current_SC->SCp.this_residual = fd->current_SC->SCp.buffer->length;
 	 }
       }
    }
    
    if (done) {
 #if EVERY_ACCESS
-      printk( " ** IN DONE %d ** ", current_SC->SCp.have_data_in );
+      printk( " ** IN DONE %d ** ", fd->current_SC->SCp.have_data_in );
 #endif
 
 #if ERRORS_ONLY
-      if (current_SC->cmnd[0] == REQUEST_SENSE && !current_SC->SCp.Status) {
-	      char *buf = scsi_sglist(current_SC);
+      if (fd->current_SC->cmnd[0] == REQUEST_SENSE && !fd->current_SC->SCp.Status) {
+	      char *buf = scsi_sglist(fd->current_SC);
 	 if ((unsigned char)(*(buf + 2)) & 0x0f) {
 	    unsigned char key;
 	    unsigned char code;
@@ -1390,24 +1410,24 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
 #if EVERY_ACCESS
       printk( "BEFORE MY_DONE. . ." );
 #endif
-      spin_lock_irqsave(current_SC->device->host->host_lock, flags);
-      my_done( (current_SC->SCp.Status & 0xff)
-	       | ((current_SC->SCp.Message & 0xff) << 8) | (DID_OK << 16) );
-      spin_unlock_irqrestore(current_SC->device->host->host_lock, flags);
+      spin_lock_irqsave(fd->current_SC->device->host->host_lock, flags);
+      my_done(fd, (fd->current_SC->SCp.Status & 0xff)
+	       | ((fd->current_SC->SCp.Message & 0xff) << 8) | (DID_OK << 16) );
+      spin_unlock_irqrestore(fd->current_SC->device->host->host_lock, flags);
 #if EVERY_ACCESS
       printk( "RETURNING.\n" );
 #endif
       
    } else {
-      if (current_SC->SCp.phase & disconnect) {
-	 outb(0xd0 | FIFO_COUNT, port_base + Interrupt_Cntl);
-	 outb(0x00, port_base + SCSI_Cntl);
+      if (fd->current_SC->SCp.phase & disconnect) {
+	 outb(0xd0 | FIFO_COUNT, fd->port_base + Interrupt_Cntl);
+	 outb(0x00, fd->port_base + SCSI_Cntl);
       } else {
-	 outb(0x90 | FIFO_COUNT, port_base + Interrupt_Cntl);
+	 outb(0x90 | FIFO_COUNT, fd->port_base + Interrupt_Cntl);
       }
    }
 #if DEBUG_RACE
-   in_interrupt_flag = 0;
+   fd->in_interrupt_flag = 0;
 #endif
    return IRQ_HANDLED;
 }
@@ -1415,7 +1435,9 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
 static int fdomain_16x0_queue_lck(struct scsi_cmnd *SCpnt,
 		void (*done)(struct scsi_cmnd *))
 {
-   if (in_command) {
+	struct fdomain *fd = shost_priv(SCpnt->device->host);
+
+   if (fd->in_command) {
       panic( "scsi: <fdomain> fdomain_16x0_queue() NOT REENTRANT!\n" );
    }
 #if EVERY_ACCESS
@@ -1426,38 +1448,38 @@ static int fdomain_16x0_queue_lck(struct scsi_cmnd *SCpnt,
 	   scsi_bufflen(SCpnt));
 #endif
 
-   fdomain_make_bus_idle();
+   fdomain_make_bus_idle(fd);
 
-   current_SC            = SCpnt; /* Save this for the done function */
-   current_SC->scsi_done = done;
+   fd->current_SC            = SCpnt; /* Save this for the done function */
+   fd->current_SC->scsi_done = done;
 
    /* Initialize static data */
 
-   if (scsi_sg_count(current_SC)) {
-	   current_SC->SCp.buffer = scsi_sglist(current_SC);
-	   current_SC->SCp.ptr = sg_virt(current_SC->SCp.buffer);
-	   current_SC->SCp.this_residual    = current_SC->SCp.buffer->length;
-	   current_SC->SCp.buffers_residual = scsi_sg_count(current_SC) - 1;
+   if (scsi_sg_count(fd->current_SC)) {
+	   fd->current_SC->SCp.buffer = scsi_sglist(fd->current_SC);
+	   fd->current_SC->SCp.ptr = sg_virt(fd->current_SC->SCp.buffer);
+	   fd->current_SC->SCp.this_residual    = fd->current_SC->SCp.buffer->length;
+	   fd->current_SC->SCp.buffers_residual = scsi_sg_count(fd->current_SC) - 1;
    } else {
-	   current_SC->SCp.ptr              = NULL;
-	   current_SC->SCp.this_residual    = 0;
-	   current_SC->SCp.buffer           = NULL;
-	   current_SC->SCp.buffers_residual = 0;
+	   fd->current_SC->SCp.ptr              = NULL;
+	   fd->current_SC->SCp.this_residual    = 0;
+	   fd->current_SC->SCp.buffer           = NULL;
+	   fd->current_SC->SCp.buffers_residual = 0;
    }
 
-   current_SC->SCp.Status              = 0;
-   current_SC->SCp.Message             = 0;
-   current_SC->SCp.have_data_in        = 0;
-   current_SC->SCp.sent_command        = 0;
-   current_SC->SCp.phase               = in_arbitration;
+   fd->current_SC->SCp.Status              = 0;
+   fd->current_SC->SCp.Message             = 0;
+   fd->current_SC->SCp.have_data_in        = 0;
+   fd->current_SC->SCp.sent_command        = 0;
+   fd->current_SC->SCp.phase               = in_arbitration;
 
    /* Start arbitration */
-   outb(0x00, port_base + Interrupt_Cntl);
-   outb(0x00, port_base + SCSI_Cntl);              /* Disable data drivers */
-   outb(adapter_mask, port_base + SCSI_Data_NoACK); /* Set our id bit */
-   ++in_command;
-   outb(0x20, port_base + Interrupt_Cntl);
-   outb(0x14 | PARITY_MASK, port_base + TMC_Cntl); /* Start arbitration */
+   outb(0x00, fd->port_base + Interrupt_Cntl);
+   outb(0x00, fd->port_base + SCSI_Cntl);              /* Disable data drivers */
+   outb(fd->adapter_mask, fd->port_base + SCSI_Data_NoACK); /* Set our id bit */
+   ++fd->in_command;
+   outb(0x20, fd->port_base + Interrupt_Cntl);
+   outb(0x14 | PARITY_MASK, fd->port_base + TMC_Cntl); /* Start arbitration */
 
    return 0;
 }
@@ -1470,18 +1492,20 @@ static void print_info(struct scsi_cmnd *SCpnt)
    unsigned int imr;
    unsigned int irr;
    unsigned int isr;
+	struct fdomain *fd;
 
    if (!SCpnt || !SCpnt->device || !SCpnt->device->host) {
       printk(KERN_WARNING "scsi: <fdomain> Cannot provide detailed information\n");
       return;
    }
+   fd = shost_priv(SCpnt->device->host);
    
    printk(KERN_INFO "%s\n", fdomain_16x0_info( SCpnt->device->host ) );
    print_banner(SCpnt->device->host);
    switch (SCpnt->SCp.phase) {
-   case in_arbitration: printk("arbitration"); break;
-   case in_selection:   printk("selection");   break;
-   case in_other:       printk("other");       break;
+   case fd->in_arbitration: printk("arbitration"); break;
+   case fd->in_selection:   printk("selection");   break;
+   case fd->in_other:       printk("other");       break;
    default:             printk("unknown");     break;
    }
 
@@ -1496,7 +1520,7 @@ static void print_info(struct scsi_cmnd *SCpnt)
 	   SCpnt->SCp.have_data_in,
 	   SCpnt->timeout );
 #if DEBUG_RACE
-   printk( "in_interrupt_flag = %d\n", in_interrupt_flag );
+   printk( "in_interrupt_flag = %d\n", fd->in_interrupt_flag );
 #endif
 
    imr = (inb( 0x0a1 ) << 8) + inb( 0x21 );
@@ -1511,38 +1535,39 @@ static void print_info(struct scsi_cmnd *SCpnt)
 
 				/* Print out interesting information */
    printk( "IMR = 0x%04x", imr );
-   if (imr & (1 << interrupt_level))
+   if (imr & (1 << fd->interrupt_level))
 	 printk( " (masked)" );
    printk( ", IRR = 0x%04x, ISR = 0x%04x\n", irr, isr );
 
-   printk( "SCSI Status      = 0x%02x\n", inb(port_base + SCSI_Status));
-   printk( "TMC Status       = 0x%02x", inb(port_base + TMC_Status));
-   if (inb((port_base + TMC_Status) & 1))
+   printk( "SCSI Status      = 0x%02x\n", inb(fd->port_base + SCSI_Status));
+   printk( "TMC Status       = 0x%02x", inb(fd->port_base + TMC_Status));
+   if (inb((fd->port_base + TMC_Status) & 1))
 	 printk( " (interrupt)" );
    printk( "\n" );
-   printk("Interrupt Status = 0x%02x", inb(port_base + Interrupt_Status));
-   if (inb(port_base + Interrupt_Status) & 0x08)
+   printk("Interrupt Status = 0x%02x", inb(fd->port_base + Interrupt_Status));
+   if (inb(fd->port_base + Interrupt_Status) & 0x08)
 	 printk( " (enabled)" );
    printk( "\n" );
-   if (chip == tmc18c50 || chip == tmc18c30) {
-      printk("FIFO Status      = 0x%02x\n", inb(port_base + FIFO_Status));
+   if (fd->chip == tmc18c50 || fd->chip == tmc18c30) {
+      printk("FIFO Status      = 0x%02x\n", inb(fd->port_base + FIFO_Status));
       printk( "Int. Condition   = 0x%02x\n",
-	      inb( port_base + Interrupt_Cond ) );
+	      inb(fd->port_base + Interrupt_Cond));
    }
-   printk( "Configuration 1  = 0x%02x\n", inb( port_base + Configuration1 ) );
-   if (chip == tmc18c50 || chip == tmc18c30)
+   printk("Configuration 1  = 0x%02x\n", inb(fd->port_base + Configuration1));
+   if (fd->chip == tmc18c50 || fd->chip == tmc18c30)
 	 printk( "Configuration 2  = 0x%02x\n",
-		 inb( port_base + Configuration2 ) );
+		 inb(fd->port_base + Configuration2));
 }
 #endif
 
 static int fdomain_16x0_abort(struct scsi_cmnd *SCpnt)
 {
+	struct fdomain *fd = shost_priv(SCpnt->device->host);
 #if EVERY_ACCESS || ERRORS_ONLY || DEBUG_ABORT
    printk( "scsi: <fdomain> abort " );
 #endif
 
-   if (!in_command) {
+   if (!fd->in_command) {
 #if EVERY_ACCESS || ERRORS_ONLY
       printk( " (not in command)\n" );
 #endif
@@ -1553,28 +1578,22 @@ static int fdomain_16x0_abort(struct scsi_cmnd *SCpnt)
    print_info( SCpnt );
 #endif
 
-   fdomain_make_bus_idle();
-   current_SC->SCp.phase |= aborted;
-   current_SC->result = DID_ABORT << 16;
+   fdomain_make_bus_idle(fd);
+   fd->current_SC->SCp.phase |= aborted;
+   fd->current_SC->result = DID_ABORT << 16;
    
    /* Aborts are not done well. . . */
-   my_done(DID_ABORT << 16);
+   my_done(fd, DID_ABORT << 16);
    return SUCCESS;
 }
 
 int fdomain_16x0_host_reset(struct scsi_cmnd *SCpnt)
 {
+	struct fdomain *fd = shost_priv(SCpnt->device->host);
    unsigned long flags;
 
    local_irq_save(flags);
-
-   outb(1, port_base + SCSI_Cntl);
-   do_pause( 2 );
-   outb(0, port_base + SCSI_Cntl);
-   do_pause( 115 );
-   outb(0, port_base + SCSI_Mode_Cntl);
-   outb(PARITY_MASK, port_base + TMC_Cntl);
-
+   fdomain_16x0_reset(fd->port_base);
    local_irq_restore(flags);
    return SUCCESS;
 }
@@ -1591,6 +1610,7 @@ static int fdomain_16x0_biosparam(struct scsi_device *sdev,
       unsigned char  heads;
       unsigned char  sectors;
    } i;
+	struct fdomain *fd = shost_priv(sdev->host);
    
    /* NOTES:
       The RAM area starts at 0x1f00 from the bios_base address.
@@ -1641,8 +1661,8 @@ static int fdomain_16x0_biosparam(struct scsi_device *sdev,
    }
    drive = MINOR(bdev->bd_dev) >> 4;
 
-   if (bios_major == 2) {
-      switch (Quantum) {
+   if (fd->bios_major == 2) {
+      switch (fd->Quantum) {
       case 2:			/* ISA_200S */
 				/* The value of 25 has never been verified.
 				   It should probably be 15. */
@@ -1658,14 +1678,14 @@ static int fdomain_16x0_biosparam(struct scsi_device *sdev,
 	 offset = 0x1f31 + drive * 25;
 	 break;
       }
-      memcpy_fromio( &i, bios_mem + offset, sizeof( struct drive_info ) );
+      memcpy_fromio( &i, fd->bios_mem + offset, sizeof( struct drive_info ) );
       info_array[0] = i.heads;
       info_array[1] = i.sectors;
       info_array[2] = i.cylinders;
-   } else if (bios_major == 3
-	      && bios_minor >= 0
-	      && bios_minor < 4) { /* 3.0 and 3.2 BIOS */
-      memcpy_fromio( &i, bios_mem + 0x1f71 + drive * 10,
+   } else if (fd->bios_major == 3
+	      && fd->bios_minor >= 0
+	      && fd->bios_minor < 4) { /* 3.0 and 3.2 BIOS */
+      memcpy_fromio( &i, fd->bios_mem + 0x1f71 + drive * 10,
 		     sizeof( struct drive_info ) );
       info_array[0] = i.heads + 1;
       info_array[1] = i.sectors;
@@ -1736,12 +1756,13 @@ static int fdomain_16x0_biosparam(struct scsi_device *sdev,
 #ifndef PCMCIA
 static int fdomain_16x0_release(struct Scsi_Host *shpnt)
 {
+	struct fdomain *fd = shost_priv(shpnt);
 	if (shpnt->irq)
-		free_irq(shpnt->irq, shpnt);
+		free_irq(shpnt->irq, fd);
 	if (shpnt->io_port && shpnt->n_io_port)
 		release_region(shpnt->io_port, shpnt->n_io_port);
-	if (PCI_bus)
-		pci_dev_put(PCI_dev);
+	if (fd->PCI_bus)
+		pci_dev_put(fd->PCI_dev);
 	return 0;
 }
 #endif
-- 
Ondrej Zary
