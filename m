From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fdomain: reduce usage of global variables
Date: Sun, 10 Oct 2004 15:08:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041010130820.GA2728@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:18347 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268299AbUJJNIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Oct 2004 09:08:25 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

preparation for supporting more than HBA instance


--- 1.30/drivers/scsi/fdomain.c	2004-08-26 03:50:07 +02:00
+++ edited/drivers/scsi/fdomain.c	2004-10-09 17:30:27 +02:00
@@ -400,20 +400,6 @@
 static volatile int      in_interrupt_flag;
 #endif
 
-static int               SCSI_Mode_Cntl_port;
-static int               FIFO_Data_Count_port;
-static int               Interrupt_Cntl_port;
-static int               Interrupt_Status_port;
-static int               Read_FIFO_port;
-static int               Read_SCSI_Data_port;
-static int               SCSI_Cntl_port;
-static int               SCSI_Data_NoACK_port;
-static int               SCSI_Status_port;
-static int               TMC_Cntl_port;
-static int               TMC_Status_port;
-static int               Write_FIFO_port;
-static int               Write_SCSI_Data_port;
-
 static int               FIFO_Size = 0x2000; /* 8k FIFO for
 						pre-tmc18c30 chips */
 
@@ -585,12 +571,12 @@
 
 inline static void fdomain_make_bus_idle( void )
 {
-   outb( 0, SCSI_Cntl_port );
-   outb( 0, SCSI_Mode_Cntl_port );
+   outb(0, port_base + SCSI_Cntl);
+   outb(0, port_base + SCSI_Mode_Cntl);
    if (chip == tmc18c50 || chip == tmc18c30)
-	 outb( 0x21 | PARITY_MASK, TMC_Cntl_port ); /* Clear forced intr. */
+	 outb(0x21 | PARITY_MASK, port_base + TMC_Cntl); /* Clear forced intr. */
    else
-	 outb( 0x01 | PARITY_MASK, TMC_Cntl_port );
+	 outb(0x01 | PARITY_MASK, port_base + TMC_Cntl);
 }
 
 static int fdomain_is_valid_port( int port )
@@ -910,20 +896,6 @@
       }
    }
 
-   SCSI_Mode_Cntl_port   = port_base + SCSI_Mode_Cntl;
-   FIFO_Data_Count_port  = port_base + FIFO_Data_Count;
-   Interrupt_Cntl_port   = port_base + Interrupt_Cntl;
-   Interrupt_Status_port = port_base + Interrupt_Status;
-   Read_FIFO_port        = port_base + Read_FIFO;
-   Read_SCSI_Data_port   = port_base + Read_SCSI_Data;
-   SCSI_Cntl_port        = port_base + SCSI_Cntl;
-   SCSI_Data_NoACK_port  = port_base + SCSI_Data_NoACK;
-   SCSI_Status_port      = port_base + SCSI_Status;
-   TMC_Cntl_port         = port_base + TMC_Cntl;
-   TMC_Status_port       = port_base + TMC_Status;
-   Write_FIFO_port       = port_base + Write_FIFO;
-   Write_SCSI_Data_port  = port_base + Write_SCSI_Data;
-
    fdomain_16x0_bus_reset(NULL);
 
    if (fdomain_test_loopback()) {
@@ -1032,13 +1004,13 @@
    printk( "fdomain_arbitrate()\n" );
 #endif
    
-   outb( 0x00, SCSI_Cntl_port );              /* Disable data drivers */
-   outb( adapter_mask, port_base + SCSI_Data_NoACK ); /* Set our id bit */
-   outb( 0x04 | PARITY_MASK, TMC_Cntl_port ); /* Start arbitration */
+   outb(0x00, port_base + SCSI_Cntl);              /* Disable data drivers */
+   outb(adapter_mask, port_base + SCSI_Data_NoACK); /* Set our id bit */
+   outb(0x04 | PARITY_MASK, port_base + TMC_Cntl); /* Start arbitration */
 
    timeout = 500;
    do {
-      status = inb( TMC_Status_port );        /* Read adapter status */
+      status = inb(port_base + TMC_Status);        /* Read adapter status */
       if (status & 0x02)		      /* Arbitration complete */
 	    return 0;
       mdelay(1);			/* Wait one millisecond */
@@ -1065,19 +1037,19 @@
    static int    flag = 0;
 #endif
 
-   outb( 0x82, SCSI_Cntl_port ); /* Bus Enable + Select */
-   outb( adapter_mask | (1 << target), SCSI_Data_NoACK_port );
+   outb(0x82, port_base + SCSI_Cntl); /* Bus Enable + Select */
+   outb(adapter_mask | (1 << target), port_base + SCSI_Data_NoACK);
 
    /* Stop arbitration and enable parity */
-   outb( PARITY_MASK, TMC_Cntl_port ); 
+   outb(PARITY_MASK, port_base + TMC_Cntl); 
 
    timeout = 350;			/* 350 msec */
 
    do {
-      status = inb( SCSI_Status_port ); /* Read adapter status */
+      status = inb(port_base + SCSI_Status); /* Read adapter status */
       if (status & 1) {			/* Busy asserted */
 	 /* Enable SCSI Bus (on error, should make bus idle with 0) */
-	 outb( 0x80, SCSI_Cntl_port );
+	 outb(0x80, port_base + SCSI_Cntl);
 	 return 0;
       }
       mdelay(1);			/* wait one msec */
@@ -1102,7 +1074,7 @@
 {
    if (in_command) {
       in_command = 0;
-      outb( 0x00, Interrupt_Cntl_port );
+      outb(0x00, port_base + Interrupt_Cntl);
       fdomain_make_bus_idle();
       current_SC->result = error;
       if (current_SC->scsi_done)
@@ -1131,11 +1103,11 @@
 				   running. */
 
    /* Check for other IRQ sources */
-   if((inb(TMC_Status_port)&0x01)==0)   
+   if ((inb(port_base + TMC_Status) & 0x01) == 0)
    	return IRQ_NONE;
 
    /* It is our IRQ */   	
-   outb( 0x00, Interrupt_Cntl_port );
+   outb(0x00, port_base + Interrupt_Cntl);
 
    /* We usually have one spurious interrupt after each command.  Ignore it. */
    if (!in_command || !current_SC) {	/* Spurious interrupt */
@@ -1160,7 +1132,7 @@
 #endif
 
    if (current_SC->SCp.phase & in_arbitration) {
-      status = inb( TMC_Status_port );        /* Read adapter status */
+      status = inb(port_base + TMC_Status);        /* Read adapter status */
       if (!(status & 0x02)) {
 #if EVERY_ACCESS
 	 printk( " AFAIL " );
@@ -1172,19 +1144,19 @@
       }
       current_SC->SCp.phase = in_selection;
       
-      outb( 0x40 | FIFO_COUNT, Interrupt_Cntl_port );
+      outb(0x40 | FIFO_COUNT, port_base + Interrupt_Cntl);
 
-      outb( 0x82, SCSI_Cntl_port ); /* Bus Enable + Select */
-      outb( adapter_mask | (1 << current_SC->device->id), SCSI_Data_NoACK_port );
+      outb(0x82, port_base + SCSI_Cntl); /* Bus Enable + Select */
+      outb(adapter_mask | (1 << current_SC->device->id), port_base + SCSI_Data_NoACK);
       
       /* Stop arbitration and enable parity */
-      outb( 0x10 | PARITY_MASK, TMC_Cntl_port );
+      outb(0x10 | PARITY_MASK, port_base + TMC_Cntl);
 #if DEBUG_RACE
       in_interrupt_flag = 0;
 #endif
       return IRQ_HANDLED;
    } else if (current_SC->SCp.phase & in_selection) {
-      status = inb( SCSI_Status_port );
+      status = inb(port_base + SCSI_Status);
       if (!(status & 0x01)) {
 	 /* Try again, for slow devices */
 	 if (fdomain_select( current_SC->device->id )) {
@@ -1200,12 +1172,12 @@
 	    printk( " AltSel " );
 #endif
 	    /* Stop arbitration and enable parity */
-	    outb( 0x10 | PARITY_MASK, TMC_Cntl_port );
+	    outb(0x10 | PARITY_MASK, port_base + TMC_Cntl);
 	 }
       }
       current_SC->SCp.phase = in_other;
-      outb( 0x90 | FIFO_COUNT, Interrupt_Cntl_port );
-      outb( 0x80, SCSI_Cntl_port );
+      outb(0x90 | FIFO_COUNT, port_base + Interrupt_Cntl);
+      outb(0x80, port_base + SCSI_Cntl);
 #if DEBUG_RACE
       in_interrupt_flag = 0;
 #endif
@@ -1214,15 +1186,15 @@
    
    /* current_SC->SCp.phase == in_other: this is the body of the routine */
    
-   status = inb( SCSI_Status_port );
+   status = inb(port_base + SCSI_Status);
    
    if (status & 0x10) {	/* REQ */
       
       switch (status & 0x0e) {
        
       case 0x08:		/* COMMAND OUT */
-	 outb( current_SC->cmnd[current_SC->SCp.sent_command++],
-	       Write_SCSI_Data_port );
+	 outb(current_SC->cmnd[current_SC->SCp.sent_command++],
+	      port_base + Write_SCSI_Data);
 #if EVERY_ACCESS
 	 printk( "CMD = %x,",
 		 current_SC->cmnd[ current_SC->SCp.sent_command - 1] );
@@ -1231,17 +1203,17 @@
       case 0x00:		/* DATA OUT -- tmc18c50/tmc18c30 only */
 	 if (chip != tmc1800 && !current_SC->SCp.have_data_in) {
 	    current_SC->SCp.have_data_in = -1;
-	    outb( 0xd0 | PARITY_MASK, TMC_Cntl_port );
+	    outb(0xd0 | PARITY_MASK, port_base + TMC_Cntl);
 	 }
 	 break;
       case 0x04:		/* DATA IN -- tmc18c50/tmc18c30 only */
 	 if (chip != tmc1800 && !current_SC->SCp.have_data_in) {
 	    current_SC->SCp.have_data_in = 1;
-	    outb( 0x90 | PARITY_MASK, TMC_Cntl_port );
+	    outb(0x90 | PARITY_MASK, port_base + TMC_Cntl);
 	 }
 	 break;
       case 0x0c:		/* STATUS IN */
-	 current_SC->SCp.Status = inb( Read_SCSI_Data_port );
+	 current_SC->SCp.Status = inb(port_base + Read_SCSI_Data);
 #if EVERY_ACCESS
 	 printk( "Status = %x, ", current_SC->SCp.Status );
 #endif
@@ -1257,10 +1229,10 @@
 #endif
 	       break;
       case 0x0a:		/* MESSAGE OUT */
-	 outb( MESSAGE_REJECT, Write_SCSI_Data_port ); /* Reject */
+	 outb(MESSAGE_REJECT, port_base + Write_SCSI_Data); /* Reject */
 	 break;
       case 0x0e:		/* MESSAGE IN */
-	 current_SC->SCp.Message = inb( Read_SCSI_Data_port );
+	 current_SC->SCp.Message = inb(port_base + Read_SCSI_Data);
 #if EVERY_ACCESS
 	 printk( "Message = %x, ", current_SC->SCp.Message );
 #endif
@@ -1281,17 +1253,17 @@
       if(current_SC->sc_data_direction == DMA_TO_DEVICE)
       {
 	 current_SC->SCp.have_data_in = -1;
-	 outb( 0xd0 | PARITY_MASK, TMC_Cntl_port );
+	 outb(0xd0 | PARITY_MASK, port_base + TMC_Cntl);
       }
       else
       {
 	 current_SC->SCp.have_data_in = 1;
-	 outb( 0x90 | PARITY_MASK, TMC_Cntl_port );
+	 outb(0x90 | PARITY_MASK, port_base + TMC_Cntl);
       }
    }
 
    if (current_SC->SCp.have_data_in == -1) { /* DATA OUT */
-      while ( (data_count = FIFO_Size - inw( FIFO_Data_Count_port )) > 512 ) {
+      while ((data_count = FIFO_Size - inw(port_base + FIFO_Data_Count)) > 512) {
 #if EVERY_ACCESS
 	 printk( "DC=%d, ", data_count ) ;
 #endif
@@ -1302,11 +1274,11 @@
 	    printk( "%d OUT, ", data_count );
 #endif
 	    if (data_count == 1) {
-	       outb( *current_SC->SCp.ptr++, Write_FIFO_port );
+	       outb(*current_SC->SCp.ptr++, port_base + Write_FIFO);
 	       --current_SC->SCp.this_residual;
 	    } else {
 	       data_count >>= 1;
-	       outsw( Write_FIFO_port, current_SC->SCp.ptr, data_count );
+	       outsw(port_base + Write_FIFO, current_SC->SCp.ptr, data_count);
 	       current_SC->SCp.ptr += 2 * data_count;
 	       current_SC->SCp.this_residual -= 2 * data_count;
 	    }
@@ -1324,7 +1296,7 @@
    }
    
    if (current_SC->SCp.have_data_in == 1) { /* DATA IN */
-      while ((data_count = inw( FIFO_Data_Count_port )) > 0) {
+      while ((data_count = inw(port_base + FIFO_Data_Count)) > 0) {
 #if EVERY_ACCESS
 	 printk( "DC=%d, ", data_count );
 #endif
@@ -1335,11 +1307,11 @@
 	    printk( "%d IN, ", data_count );
 #endif
 	    if (data_count == 1) {
-	       *current_SC->SCp.ptr++ = inb( Read_FIFO_port );
+	       *current_SC->SCp.ptr++ = inb(port_base + Read_FIFO);
 	       --current_SC->SCp.this_residual;
 	    } else {
 	       data_count >>= 1; /* Number of words */
-	       insw( Read_FIFO_port, current_SC->SCp.ptr, data_count );
+	       insw(port_base + Read_FIFO, current_SC->SCp.ptr, data_count);
 	       current_SC->SCp.ptr += 2 * data_count;
 	       current_SC->SCp.this_residual -= 2 * data_count;
 	    }
@@ -1399,10 +1371,10 @@
       
    } else {
       if (current_SC->SCp.phase & disconnect) {
-	 outb( 0xd0 | FIFO_COUNT, Interrupt_Cntl_port );
-	 outb( 0x00, SCSI_Cntl_port );
+	 outb(0xd0 | FIFO_COUNT, port_base + Interrupt_Cntl);
+	 outb(0x00, port_base + SCSI_Cntl);
       } else {
-	 outb( 0x90 | FIFO_COUNT, Interrupt_Cntl_port );
+	 outb(0x90 | FIFO_COUNT, port_base + Interrupt_Cntl);
       }
    }
 #if DEBUG_RACE
@@ -1453,12 +1425,12 @@
    current_SC->SCp.phase               = in_arbitration;
 
    /* Start arbitration */
-   outb( 0x00, Interrupt_Cntl_port );
-   outb( 0x00, SCSI_Cntl_port );              /* Disable data drivers */
-   outb( adapter_mask, SCSI_Data_NoACK_port ); /* Set our id bit */
+   outb(0x00, port_base + Interrupt_Cntl);
+   outb(0x00, port_base + SCSI_Cntl);              /* Disable data drivers */
+   outb(adapter_mask, port_base + SCSI_Data_NoACK); /* Set our id bit */
    ++in_command;
-   outb( 0x20, Interrupt_Cntl_port );
-   outb( 0x14 | PARITY_MASK, TMC_Cntl_port ); /* Start arbitration */
+   outb(0x20, port_base + Interrupt_Cntl);
+   outb(0x14 | PARITY_MASK, port_base + TMC_Cntl); /* Start arbitration */
 
    return 0;
 }
@@ -1514,17 +1486,17 @@
 	 printk( " (masked)" );
    printk( ", IRR = 0x%04x, ISR = 0x%04x\n", irr, isr );
 
-   printk( "SCSI Status      = 0x%02x\n", inb( SCSI_Status_port ) );
-   printk( "TMC Status       = 0x%02x", inb( TMC_Status_port ) );
-   if (inb( TMC_Status_port & 1))
+   printk( "SCSI Status      = 0x%02x\n", inb(port_base + SCSI_Status));
+   printk( "TMC Status       = 0x%02x", inb(port_base + TMC_Status));
+   if (inb((port_base + TMC_Status) & 1))
 	 printk( " (interrupt)" );
    printk( "\n" );
-   printk( "Interrupt Status = 0x%02x", inb( Interrupt_Status_port ) );
-   if (inb( Interrupt_Status_port ) & 0x08)
+   printk("Interrupt Status = 0x%02x", inb(port_base + Interrupt_Status));
+   if (inb(port_base + Interrupt_Status) & 0x08)
 	 printk( " (enabled)" );
    printk( "\n" );
    if (chip == tmc18c50 || chip == tmc18c30) {
-      printk( "FIFO Status      = 0x%02x\n", inb( port_base + FIFO_Status ) );
+      printk("FIFO Status      = 0x%02x\n", inb(port_base + FIFO_Status));
       printk( "Int. Condition   = 0x%02x\n",
 	      inb( port_base + Interrupt_Cond ) );
    }
@@ -1563,12 +1535,12 @@
 
 int fdomain_16x0_bus_reset(struct scsi_cmnd *SCpnt)
 {
-   outb( 1, SCSI_Cntl_port );
+   outb(1, port_base + SCSI_Cntl);
    do_pause( 2 );
-   outb( 0, SCSI_Cntl_port );
+   outb(0, port_base + SCSI_Cntl);
    do_pause( 115 );
-   outb( 0, SCSI_Mode_Cntl_port );
-   outb( PARITY_MASK, TMC_Cntl_port );
+   outb(0, port_base + SCSI_Mode_Cntl);
+   outb(PARITY_MASK, port_base + TMC_Cntl);
    return SUCCESS;
 }
 
