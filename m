From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] eata_pio updates
Date: Thu, 20 Feb 2003 20:44:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030220204425.C19476@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

(1) don't include eata_dma_proc.h - it's gone and we don't need it
(2) remove eata_pio_proc.c - it's #included in the main source file,
    so the functions can be there aswell
(3) move host template away from eata_pio.h


+++ edited/drivers/scsi/eata_pio.c	Thu Feb 20 17:57:04 2003
@@ -46,10 +46,7 @@
  *  last change: 2002/11/02               OS: Linux 2.5.45  *
  ************************************************************/
 
-/* Look in eata_pio.h for configuration information */
-
 #include <linux/module.h>
-
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/string.h>
@@ -59,15 +56,19 @@
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
-#include <asm/io.h>
-#include "eata_pio.h"
-#include "eata_dma_proc.h"
-#include "scsi.h"
-
 #include <linux/stat.h>
-#include <linux/config.h>	/* for CONFIG_PCI */
+#include <linux/config.h>
 #include <linux/blk.h>
 #include <linux/spinlock.h>
+#include <asm/io.h>
+
+#include "scsi.h"
+#include "hosts.h"
+#include <scsi/scsicam.h>
+
+#include "eata_generic.h"
+#include "eata_pio.h"
+
 
 static uint ISAbases[MAXISA] =	{
 	 0x1F0, 0x170, 0x330, 0x230
@@ -82,16 +83,106 @@
 	1, 1, 1, 1, 1, 1, 1, 1 
 };
 
-static uint registered_HBAs = 0;
+static uint registered_HBAs;
 static struct Scsi_Host *last_HBA;
 static struct Scsi_Host *first_HBA;
-static unsigned char reg_IRQ[];
-static unsigned char reg_IRQL[];
+static unsigned char reg_IRQ[16];
+static unsigned char reg_IRQL[16];
+static unsigned long int_counter;
+static unsigned long queue_counter;
 
-static unsigned long int_counter = 0;
-static unsigned long queue_counter = 0;
+/*
+ * eata_proc_info
+ * inout : decides on the direction of the dataflow and the meaning of the 
+ *         variables
+ * buffer: If inout==FALSE data is being written to it else read from it
+ * *start: If inout==FALSE start of the valid data in the buffer
+ * offset: If inout==FALSE offset from the beginning of the imaginary file 
+ *         from which we start writing into the buffer
+ * length: If inout==FALSE max number of bytes to be written into the buffer 
+ *         else number of bytes in the buffer
+ */
+static int eata_pio_proc_info(char *buffer, char **start, off_t offset,
+			      int length, int hostno, int rw)
+{
+    struct Scsi_Host *shost;
+    struct scsi_device *sdev;
+    static u8 buff[512];
+    int size, len = 0;
+    off_t begin = 0, pos = 0;
+
+    if (rw)
+    	return -ENOSYS;
+    shost = scsi_host_hn_get(hostno);
+    if (!shost)
+    	return -EINVAL;
 
-#include "eata_pio_proc.c"
+    if (offset == 0)
+	memset(buff, 0, sizeof(buff));
+
+    size = sprintf(buffer+len, "EATA (Extended Attachment) PIO driver version: "
+		   "%d.%d%s\n",VER_MAJOR, VER_MINOR, VER_SUB);
+    len += size; pos = begin + len;
+    size = sprintf(buffer + len, "queued commands:     %10ld\n"
+		   "processed interrupts:%10ld\n", queue_counter, int_counter);
+    len += size; pos = begin + len;
+    
+    size = sprintf(buffer + len, "\nscsi%-2d: HBA %.10s\n",
+		   shost->host_no, SD(shost)->name);
+    len += size; 
+    pos = begin + len;
+    size = sprintf(buffer + len, "Firmware revision: v%s\n", 
+		   SD(shost)->revision);
+    len += size;
+    pos = begin + len;
+    size = sprintf(buffer + len, "IO: PIO\n");
+    len += size; 
+    pos = begin + len;
+    size = sprintf(buffer + len, "Base IO : %#.4x\n", (u32) shost->base);
+    len += size; 
+    pos = begin + len;
+    size = sprintf(buffer + len, "Host Bus: %s\n", 
+		   (SD(shost)->bustype == 'P')?"PCI ":
+		   (SD(shost)->bustype == 'E')?"EISA":"ISA ");
+    
+    len += size; 
+    pos = begin + len;
+    
+    if (pos < offset) {
+	len = 0;
+	begin = pos;
+    }
+    if (pos > offset + length)
+	goto stop_output;
+    
+    size = sprintf(buffer+len,"Attached devices: %s\n", 
+		   (!list_empty(&shost->my_devices))?"":"none");
+    len += size; 
+    pos = begin + len;
+    
+    list_for_each_entry(sdev, &shost->my_devices, siblings) {
+	    proc_print_scsidevice(sdev, buffer, &size, len);
+	    len += size; 
+	    pos = begin + len;
+	    
+	    if (pos < offset) {
+		len = 0;
+		begin = pos;
+	    }
+	    if (pos > offset + length)
+		goto stop_output;
+    }
+    
+ stop_output:
+    DBG(DBG_PROC, printk("2pos: %ld offset: %ld len: %d\n", pos, offset, len));
+    *start=buffer+(offset-begin);   /* Start of wanted data */
+    len-=(offset-begin);            /* Start slop */
+    if(len>length)
+	len = length;               /* Ending slop */
+    DBG(DBG_PROC, printk("3pos: %ld offset: %ld len: %d\n", pos, offset, len));
+    
+    return (len);     
+}
 
 static int eata_pio_release(struct Scsi_Host *sh)
 {
@@ -895,27 +986,19 @@
 	return (registered_HBAs);
 }
 
-/* Eventually this will go into an include file, but this will be later */
-static Scsi_Host_Template driver_template = EATA_PIO;
+static Scsi_Host_Template driver_template = {
+	.proc_info         	= eata_pio_proc_info,
+	.name              	= "EATA (Extended Attachment) PIO driver",
+	.detect            	= eata_pio_detect,
+	.release           	= eata_pio_release,
+	.queuecommand      	= eata_pio_queue,
+	.eh_abort_handler  	= eata_pio_abort,
+	.eh_host_reset_handler	= eata_pio_host_reset,
+	.use_clustering    	= ENABLE_CLUSTERING,
+};
 
-#include "scsi_module.c"
+MODULE_AUTHOR("Michael Neuffer, Alfred Arnold");
+MODULE_DESCRIPTION("EATA SCSI PIO driver");
 MODULE_LICENSE("GPL");
 
-/*
- * Overrides for Emacs so that we almost follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
+#include "scsi_module.c"
===== drivers/scsi/eata_pio.h 1.4 vs edited =====
--- 1.4/drivers/scsi/eata_pio.h	Tue Dec 10 21:28:35 2002
+++ edited/drivers/scsi/eata_pio.h	Thu Feb 20 17:57:04 2003
@@ -9,13 +9,6 @@
 #ifndef _EATA_PIO_H
 #define _EATA_PIO_H
 
-#include <linux/blk.h>
-#include "scsi.h"
-#include "hosts.h"
-#include <scsi/scsicam.h>
-
-#include "eata_generic.h"
-
 #define VER_MAJOR 0
 #define VER_MINOR 0
 #define VER_SUB	  "1b"
@@ -56,23 +49,5 @@
 #else
 #define DBG(x, y)
 #endif
-
-static int eata_pio_detect(Scsi_Host_Template *);
-static int eata_pio_queue(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
-static int eata_pio_abort(Scsi_Cmnd *);
-static int eata_pio_host_reset(Scsi_Cmnd *);
-static int eata_pio_proc_info(char *, char **, off_t, int, int, int);
-static int eata_pio_release(struct Scsi_Host *);
-
-#define EATA_PIO {							\
-	.proc_info         	= eata_pio_proc_info, /* procinfo	  */	\
-	.name              	= "EATA (Extended Attachment) PIO driver",\
-	.detect            	= eata_pio_detect,			\
-	.release           	= eata_pio_release,			\
-	.queuecommand      	= eata_pio_queue,				\
-	.eh_abort_handler  	= eata_pio_abort,				\
-	.eh_host_reset_handler	= eata_pio_host_reset,			\
-	.use_clustering    	= ENABLE_CLUSTERING 			\
-}
 
 #endif				/* _EATA_PIO_H */
===== drivers/scsi/eata_pio_proc.c 1.3 vs edited =====
--- 1.3/drivers/scsi/eata_pio_proc.c	Sun Dec  1 15:32:50 2002
+++ edited/drivers/scsi/eata_pio_proc.c	Thu Feb 20 17:57:04 2003
@@ -1,128 +0,0 @@
-/*
- * eata_set_info
- * buffer : pointer to the data that has been written to the hostfile
- * length : number of bytes written to the hostfile
- * HBA_ptr: pointer to the Scsi_Host struct
- */
-int eata_pio_set_info(char *buffer, int length, struct Scsi_Host *HBA_ptr)
-{
-    DBG(DBG_PROC_WRITE, printk("%s\n", buffer));
-    return(-ENOSYS);  /* Currently this is a no-op */
-}
-
-/*
- * eata_proc_info
- * inout : decides on the direction of the dataflow and the meaning of the 
- *         variables
- * buffer: If inout==FALSE data is being written to it else read from it
- * *start: If inout==FALSE start of the valid data in the buffer
- * offset: If inout==FALSE offset from the beginning of the imaginary file 
- *         from which we start writing into the buffer
- * length: If inout==FALSE max number of bytes to be written into the buffer 
- *         else number of bytes in the buffer
- */
-int eata_pio_proc_info(char *buffer, char **start, off_t offset, int length, 
-		       int hostno, int inout)
-{
-    Scsi_Device *scd;
-    struct Scsi_Host *HBA_ptr;
-    static u8 buff[512];
-    int i; 
-    int   size, len = 0;
-    off_t begin = 0;
-    off_t pos = 0;
-
-    HBA_ptr = first_HBA;
-    for (i = 1; i <= registered_HBAs; i++) {
-	if (HBA_ptr->host_no == hostno)
-	    break;
-	HBA_ptr = SD(HBA_ptr)->next;
-    }        
-
-    if(inout == TRUE) /* Has data been written to the file ? */ 
-	return(eata_pio_set_info(buffer, length, HBA_ptr));
-
-    if (offset == 0)
-	memset(buff, 0, sizeof(buff));
-
-    size = sprintf(buffer+len, "EATA (Extended Attachment) PIO driver version: "
-		   "%d.%d%s\n",VER_MAJOR, VER_MINOR, VER_SUB);
-    len += size; pos = begin + len;
-    size = sprintf(buffer + len, "queued commands:     %10ld\n"
-		   "processed interrupts:%10ld\n", queue_counter, int_counter);
-    len += size; pos = begin + len;
-    
-    size = sprintf(buffer + len, "\nscsi%-2d: HBA %.10s\n",
-		   HBA_ptr->host_no, SD(HBA_ptr)->name);
-    len += size; 
-    pos = begin + len;
-    size = sprintf(buffer + len, "Firmware revision: v%s\n", 
-		   SD(HBA_ptr)->revision);
-    len += size;
-    pos = begin + len;
-    size = sprintf(buffer + len, "IO: PIO\n");
-    len += size; 
-    pos = begin + len;
-    size = sprintf(buffer + len, "Base IO : %#.4x\n", (u32) HBA_ptr->base);
-    len += size; 
-    pos = begin + len;
-    size = sprintf(buffer + len, "Host Bus: %s\n", 
-		   (SD(HBA_ptr)->bustype == 'P')?"PCI ":
-		   (SD(HBA_ptr)->bustype == 'E')?"EISA":"ISA ");
-    
-    len += size; 
-    pos = begin + len;
-    
-    if (pos < offset) {
-	len = 0;
-	begin = pos;
-    }
-    if (pos > offset + length)
-	goto stop_output;
-    
-    size = sprintf(buffer+len,"Attached devices: %s\n", 
-		   (!list_empty(&HBA_ptr->my_devices))?"":"none");
-    len += size; 
-    pos = begin + len;
-    
-    list_for_each_entry(scd, &HBA_ptr->my_devices, siblings) {
-	    proc_print_scsidevice(scd, buffer, &size, len);
-	    len += size; 
-	    pos = begin + len;
-	    
-	    if (pos < offset) {
-		len = 0;
-		begin = pos;
-	    }
-	    if (pos > offset + length)
-		goto stop_output;
-    }
-    
- stop_output:
-    DBG(DBG_PROC, printk("2pos: %ld offset: %ld len: %d\n", pos, offset, len));
-    *start=buffer+(offset-begin);   /* Start of wanted data */
-    len-=(offset-begin);            /* Start slop */
-    if(len>length)
-	len = length;               /* Ending slop */
-    DBG(DBG_PROC, printk("3pos: %ld offset: %ld len: %d\n", pos, offset, len));
-    
-    return (len);     
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * tab-width: 8
- * End:
- */
