From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] avoid obsolete APIs in eata
Date: Sun, 5 Sep 2004 19:21:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040905172152.GC6685@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:3298 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266879AbUIERVz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2004 13:21:55 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.37/drivers/scsi/eata.c	2004-05-12 17:46:20 +02:00
+++ edited/drivers/scsi/eata.c	2004-09-04 16:00:19 +02:00
@@ -474,7 +474,7 @@
  *  The boards are named EATA0, EATA1,... according to the detection order.
  *
  *  In order to support multiple ISA boards in a reliable way,
- *  the driver sets host->wish_block = TRUE for all ISA boards.
+ *  the driver sets host->wish_block = 1 for all ISA boards.
  */
 
 #include <linux/config.h>
@@ -482,9 +482,6 @@
 #include <linux/kernel.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
-#include <asm/io.h>
-#include <asm/system.h>
-#include <asm/byteorder.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
@@ -493,22 +490,29 @@
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
-#include <scsi/scsicam.h>
-#include "scsi.h"
-#include <scsi/scsi_host.h>
+#include <asm/byteorder.h>
 #include <asm/dma.h>
+#include <asm/io.h>
 #include <asm/irq.h>
 
-static int eata2x_detect(Scsi_Host_Template *);
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsicam.h>
+
+static int eata2x_detect(struct scsi_host_template *);
 static int eata2x_release(struct Scsi_Host *);
-static int eata2x_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int eata2x_eh_abort(Scsi_Cmnd *);
-static int eata2x_eh_host_reset(Scsi_Cmnd *);
+static int eata2x_queuecommand(struct scsi_cmnd *,
+		void (*done)(struct scsi_cmnd *));
+static int eata2x_eh_abort(struct scsi_cmnd *);
+static int eata2x_eh_host_reset(struct scsi_cmnd *);
 static int eata2x_bios_param(struct scsi_device *, struct block_device *,
                              sector_t, int *);
-static int eata2x_slave_configure(Scsi_Device *);
+static int eata2x_slave_configure(struct scsi_device *);
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
                 .name                    = "EATA/DMA 2.0x rev. 8.10.00 ",
                 .detect                  = eata2x_detect,
                 .release                 = eata2x_release,
@@ -558,8 +562,6 @@
 #define MAX_TAGGED_CMD_PER_LUN (MAX_MAILBOXES - MAX_CMD_PER_LUN)
 
 #define SKIP ULONG_MAX
-#define FALSE 0
-#define TRUE 1
 #define FREE 0
 #define IN_USE   1
 #define LOCKED   2
@@ -766,7 +768,7 @@
    u_int32_t sense_addr; /* Address where Sense Data is DMA'ed on error */
 
    /* Additional fields begin here. */
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
 
    /* All the cp structure is zero filled by queuecommand except the
       following CP_TAIL_SIZE bytes, initialized by detect */
@@ -785,12 +787,12 @@
    char board_name[16];                 /* Name of this board */
    int in_reset;                        /* True if board is doing a reset */
    int target_to[MAX_TARGET][MAX_CHANNEL]; /* N. of timeout errors on target */
-   int target_redo[MAX_TARGET][MAX_CHANNEL]; /* If TRUE redo i/o on target */
+   int target_redo[MAX_TARGET][MAX_CHANNEL]; /* If 1 redo i/o on target */
    unsigned int retries;                /* Number of internal retries */
    unsigned long last_retried_pid;      /* Pid of last retried command */
    unsigned char subversion;            /* Bus type, either ISA or EISA/PCI */
    unsigned char protocol_rev;          /* EATA 2.0 rev., 'A' or 'B' or 'C' */
-   unsigned char is_pci;                /* TRUE is bus type is PCI */
+   unsigned char is_pci;                /* 1 is bus type is PCI */
    struct pci_dev *pdev;                /* pdev for PCI bus, NULL otherwise */
    struct mssp *sp_cpu_addr;            /* cpu addr for DMA buffer sp */
    dma_addr_t sp_dma_addr;              /* dma handle for DMA buffer sp */
@@ -842,12 +844,12 @@
 #define REG2H(x)   le16_to_cpu(x)
 
 static irqreturn_t do_interrupt_handler(int, void *, struct pt_regs *);
-static void flush_dev(Scsi_Device *, unsigned long, unsigned int, unsigned int);
-static int do_trace = FALSE;
-static int setup_done = FALSE;
+static void flush_dev(struct scsi_device *, unsigned long, unsigned int, unsigned int);
+static int do_trace = 0;
+static int setup_done = 0;
 static int link_statistics;
-static int ext_tran = FALSE;
-static int rev_scan = TRUE;
+static int ext_tran = 0;
+static int rev_scan = 1;
 
 #if defined(CONFIG_SCSI_EATA_TAGGED_QUEUE)
 static int tag_mode = TAG_SIMPLE;
@@ -856,9 +858,9 @@
 #endif
 
 #if defined(CONFIG_SCSI_EATA_LINKED_COMMANDS)
-static int linked_comm = TRUE;
+static int linked_comm = 1;
 #else
-static int linked_comm = FALSE;
+static int linked_comm = 0;
 #endif
 
 #if defined(CONFIG_SCSI_EATA_MAX_TAGS)
@@ -868,21 +870,21 @@
 #endif
 
 #if defined(CONFIG_ISA)
-static int isa_probe = TRUE;
+static int isa_probe = 1;
 #else
-static int isa_probe = FALSE;
+static int isa_probe = 0;
 #endif
 
 #if defined(CONFIG_EISA)
-static int eisa_probe = TRUE;
+static int eisa_probe = 1;
 #else
-static int eisa_probe = FALSE;
+static int eisa_probe = 0;
 #endif
 
 #if defined(CONFIG_PCI)
-static int pci_probe = TRUE;
+static int pci_probe = 1;
 #else
-static int pci_probe = FALSE;
+static int pci_probe = 0;
 #endif
 
 #define MAX_INT_PARAM 10
@@ -902,7 +904,7 @@
 
 #endif
 
-static int eata2x_slave_configure(Scsi_Device *dev) {
+static int eata2x_slave_configure(struct scsi_device *dev) {
    int j, tqd, utqd;
    char *tag_suffix, *link_suffix;
    struct Scsi_Host *host = dev->host;
@@ -948,24 +950,24 @@
           BN(j), host->host_no, dev->channel, dev->id, dev->lun,
           dev->queue_depth, link_suffix, tag_suffix);
 
-   return FALSE;
+   return 0;
 }
 
 static int wait_on_busy(unsigned long iobase, unsigned int loop) {
 
    while (inb(iobase + REG_AUX_STATUS) & ABSY_ASSERTED) {
       udelay(1L);
-      if (--loop == 0) return TRUE;
+      if (--loop == 0) return 1;
       }
 
-   return FALSE;
+   return 0;
 }
 
 static int do_dma(unsigned long iobase, unsigned long addr, unchar cmd) {
    unsigned char *byaddr;
    unsigned long devaddr;
 
-   if (wait_on_busy(iobase, (addr ? MAXLOOP * 100 : MAXLOOP))) return TRUE;
+   if (wait_on_busy(iobase, (addr ? MAXLOOP * 100 : MAXLOOP))) return 1;
 
    if (addr) {
       devaddr = H2DEV(addr);
@@ -977,7 +979,7 @@
       }
 
    outb(cmd, iobase + REG_CMD);
-   return FALSE;
+   return 0;
 }
 
 static int read_pio(unsigned long iobase, ushort *start, ushort *end) {
@@ -988,14 +990,14 @@
 
       while (!(inb(iobase + REG_STATUS) & DRQ_ASSERTED)) {
          udelay(1L);
-         if (--loop == 0) return TRUE;
+         if (--loop == 0) return 1;
          }
 
       loop = MAXLOOP;
       *p = REG2H(inw(iobase));
       }
 
-   return FALSE;
+   return 0;
 }
 
 static struct pci_dev *get_pci_dev(unsigned long port_base) {
@@ -1043,8 +1045,8 @@
 }
 
 static int port_detect \
-      (unsigned long port_base, unsigned int j, Scsi_Host_Template *tpnt) {
-   unsigned char irq, dma_channel, subversion, i, is_pci = FALSE;
+      (unsigned long port_base, unsigned int j, struct scsi_host_template *tpnt) {
+   unsigned char irq, dma_channel, subversion, i, is_pci = 0;
    unsigned char protocol_rev;
    struct eata_info info;
    char *bus_type, dma_name[16];
@@ -1112,12 +1114,12 @@
    if (protocol_rev != 'A' && info.forcaddr) {
       printk("%s: warning, port address has been forced.\n", name);
       bus_type = "PCI";
-      is_pci = TRUE;
+      is_pci = 1;
       subversion = ESA;
       }
    else if (port_base > MAX_EISA_ADDR || (protocol_rev == 'C' && info.pci)) {
       bus_type = "PCI";
-      is_pci = TRUE;
+      is_pci = 1;
       subversion = ESA;
       }
    else if (port_base >= MIN_EISA_ADDR || (protocol_rev == 'C' && info.eisa)) {
@@ -1130,7 +1132,7 @@
       }
    else if (port_base > MAX_ISA_ADDR) {
       bus_type = "PCI";
-      is_pci = TRUE;
+      is_pci = 1;
       subversion = ESA;
       }
    else {
@@ -1212,7 +1214,7 @@
    /* Set board configuration */
    memset((char *)cf, 0, sizeof(struct eata_config));
    cf->len = (ushort) H2DEV16((ushort)510);
-   cf->ocena = TRUE;
+   cf->ocena = 1;
 
    if (do_dma(port_base, cf_dma_addr, SET_CONFIG_DMA)) {
       printk("%s: busy timeout sending configuration, detaching.\n", name);
@@ -1249,10 +1251,10 @@
    HD(j)->board_number = j;
 
    if (HD(j)->subversion == ESA)
-      sh[j]->unchecked_isa_dma = FALSE;
+      sh[j]->unchecked_isa_dma = 0;
    else {
       unsigned long flags;
-      sh[j]->unchecked_isa_dma = TRUE;
+      sh[j]->unchecked_isa_dma = 1;
 
       flags=claim_dma_lock();
       disable_dma(dma_channel);
@@ -1373,7 +1375,7 @@
          printk("%s: warning, pci_set_dma_mask failed.\n", BN(j));
       }
 
-   return TRUE;
+   return 1;
 
 freedma:
    if (subversion == ISA) free_dma(dma_channel);
@@ -1383,11 +1385,11 @@
    spin_unlock_irq(&driver_lock);
    release_region(port_base, REGION_SIZE);
 fail:
-   return FALSE;
+   return 0;
 
 release:
    eata2x_release(sh[j]);
-   return FALSE;
+   return 0;
 }
 
 static void internal_setup(char *str, int *ints) {
@@ -1401,14 +1403,14 @@
       for (i = 0; i < argc; i++) io_port[i] = ints[i + 1];
 
       io_port[i] = 0;
-      setup_done = TRUE;
+      setup_done = 1;
       }
 
    while (cur && (pc = strchr(cur, ':'))) {
       int val = 0, c = *++pc;
 
-      if (c == 'n' || c == 'N') val = FALSE;
-      else if (c == 'y' || c == 'Y') val = TRUE;
+      if (c == 'n' || c == 'N') val = 0;
+      else if (c == 'y' || c == 'Y') val = 1;
       else val = (int) simple_strtoul(pc, NULL, 0);
 
       if (!strncmp(cur, "lc:", 3)) linked_comm = val;
@@ -1483,7 +1485,7 @@
    return;
 }
 
-static int eata2x_detect(Scsi_Host_Template *tpnt) {
+static int eata2x_detect(struct scsi_host_template *tpnt) {
    unsigned int j = 0, k;
 
    tpnt->proc_name = "eata2x";
@@ -1493,7 +1495,7 @@
 #if defined(MODULE)
    /* io_port could have been modified when loading as a module */
    if(io_port[0] != SKIP) {
-      setup_done = TRUE;
+      setup_done = 1;
       io_port[MAX_INT_PARAM] = 0;
       }
 #endif
@@ -1529,10 +1531,10 @@
    unsigned int k, count, pci_dir;
    struct scatterlist *sgpnt;
    struct mscp *cpp;
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
 
    cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
-   pci_dir = scsi_to_pci_dma_dir(SCpnt->sc_data_direction);
+   pci_dir = SCpnt->sc_data_direction;
 
    if (SCpnt->sense_buffer)
       cpp->sense_addr = H2DEV(pci_map_single(HD(j)->pdev, SCpnt->sense_buffer,
@@ -1561,7 +1563,7 @@
       cpp->sglist[k].num_bytes = H2DEV(sg_dma_len(&sgpnt[k]));
       }
 
-   cpp->sg = TRUE;
+   cpp->sg = 1;
    cpp->data_address = H2DEV(pci_map_single(HD(j)->pdev, cpp->sglist,
                              SCpnt->use_sg * sizeof(struct sg_list), pci_dir));
    cpp->data_len = H2DEV((SCpnt->use_sg * sizeof(struct sg_list)));
@@ -1570,10 +1572,10 @@
 static void unmap_dma(unsigned int i, unsigned int j) {
    unsigned int pci_dir;
    struct mscp *cpp;
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
 
    cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
-   pci_dir = scsi_to_pci_dma_dir(SCpnt->sc_data_direction);
+   pci_dir = SCpnt->sc_data_direction;
 
    if (DEV2H(cpp->sense_addr))
       pci_unmap_single(HD(j)->pdev, DEV2H(cpp->sense_addr),
@@ -1592,10 +1594,10 @@
 static void sync_dma(unsigned int i, unsigned int j) {
    unsigned int pci_dir;
    struct mscp *cpp;
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
 
    cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
-   pci_dir = scsi_to_pci_dma_dir(SCpnt->sc_data_direction);
+   pci_dir = SCpnt->sc_data_direction;
 
    if (DEV2H(cpp->sense_addr))
       pci_dma_sync_single_for_cpu(HD(j)->pdev, DEV2H(cpp->sense_addr),
@@ -1628,45 +1630,45 @@
       };
 
    struct mscp *cpp;
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
 
    cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
 
-   if (SCpnt->sc_data_direction == SCSI_DATA_READ) {
-      cpp->din  = TRUE;
-      cpp->dout = FALSE;
+   if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
+      cpp->din  = 1;
+      cpp->dout = 0;
       return;
       }
-   else if (SCpnt->sc_data_direction == SCSI_DATA_WRITE) {
-      cpp->din  = FALSE;
-      cpp->dout = TRUE;
+   else if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
+      cpp->din  = 0;
+      cpp->dout = 1;
       return;
       }
-   else if (SCpnt->sc_data_direction == SCSI_DATA_NONE) {
-      cpp->din  = FALSE;
-      cpp->dout = FALSE;
+   else if (SCpnt->sc_data_direction == DMA_NONE) {
+      cpp->din  = 0;
+      cpp->dout = 0;
       return;
       }
 
-   if (SCpnt->sc_data_direction != SCSI_DATA_UNKNOWN)
+   if (SCpnt->sc_data_direction != DMA_BIDIRECTIONAL)
       panic("%s: qcomm, invalid SCpnt->sc_data_direction.\n", BN(j));
 
    for (k = 0; k < ARRAY_SIZE(data_out_cmds); k++)
       if (SCpnt->cmnd[0] == data_out_cmds[k]) {
-         cpp->dout = TRUE;
+         cpp->dout = 1;
          break;
          }
 
    if ((cpp->din = !cpp->dout))
       for (k = 0; k < ARRAY_SIZE(data_none_cmds); k++)
          if (SCpnt->cmnd[0] == data_none_cmds[k]) {
-            cpp->din = FALSE;
+            cpp->din = 0;
             break;
             }
 
 }
 
-static int eata2x_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *)) {
+static int eata2x_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *)) {
    unsigned int i, j, k;
    struct mscp *cpp;
 
@@ -1712,12 +1714,12 @@
                         BN(j), i, SCpnt->device->channel, SCpnt->device->id,
                         SCpnt->device->lun, SCpnt->pid);
 
-   cpp->reqsen = TRUE;
-   cpp->dispri = TRUE;
+   cpp->reqsen = 1;
+   cpp->dispri = 1;
 #if 0
-   if (SCpnt->device->type == TYPE_TAPE) cpp->hbaci = TRUE;
+   if (SCpnt->device->type == TYPE_TAPE) cpp->hbaci = 1;
 #endif
-   cpp->one = TRUE;
+   cpp->one = 1;
    cpp->channel = SCpnt->device->channel;
    cpp->target = SCpnt->device->id;
    cpp->lun = SCpnt->device->lun;
@@ -1733,7 +1735,7 @@
    if (linked_comm && SCpnt->device->queue_depth > 2
                                      && TLDEV(SCpnt->device->type)) {
       HD(j)->cp_stat[i] = READY;
-      flush_dev(SCpnt->device, SCpnt->request->sector, j, FALSE);
+      flush_dev(SCpnt->device, SCpnt->request->sector, j, 0);
       return 0;
       }
 
@@ -1750,7 +1752,7 @@
    return 0;
 }
 
-static int eata2x_eh_abort(Scsi_Cmnd *SCarg) {
+static int eata2x_eh_abort(struct scsi_cmnd *SCarg) {
    unsigned int i, j;
 
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
@@ -1824,10 +1826,10 @@
    panic("%s: abort, mbox %d, invalid cp_stat.\n", BN(j), i);
 }
 
-static int eata2x_eh_host_reset(Scsi_Cmnd *SCarg) {
+static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg) {
    unsigned int i, j, time, k, c, limit = 0;
-   int arg_done = FALSE;
-   Scsi_Cmnd *SCpnt;
+   int arg_done = 0;
+   struct scsi_cmnd *SCpnt;
 
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
    printk("%s: reset, enter, target %d.%d:%d, pid %ld.\n",
@@ -1850,7 +1852,7 @@
 
    for (c = 0; c <= sh[j]->max_channel; c++)
       for (k = 0; k < sh[j]->max_id; k++) {
-         HD(j)->target_redo[k][c] = TRUE;
+         HD(j)->target_redo[k][c] = 1;
          HD(j)->target_to[k][c] = 0;
          }
 
@@ -1888,7 +1890,7 @@
       if (SCpnt->scsi_done == NULL)
          panic("%s: reset, mbox %d, SCpnt->scsi_done == NULL.\n", BN(j), i);
 
-      if (SCpnt == SCarg) arg_done = TRUE;
+      if (SCpnt == SCarg) arg_done = 1;
       }
 
    if (do_dma(sh[j]->io_port, 0, RESET_PIO)) {
@@ -1899,10 +1901,10 @@
    printk("%s: reset, board reset done, enabling interrupts.\n", BN(j));
 
 #if defined(DEBUG_RESET)
-   do_trace = TRUE;
+   do_trace = 1;
 #endif
 
-   HD(j)->in_reset = TRUE;
+   HD(j)->in_reset = 1;
 
    spin_unlock_irq(sh[j]->host_lock);
    time = jiffies;
@@ -1947,8 +1949,8 @@
       SCpnt->scsi_done(SCpnt);
       }
 
-   HD(j)->in_reset = FALSE;
-   do_trace = FALSE;
+   HD(j)->in_reset = 0;
+   do_trace = 0;
 
    if (arg_done) printk("%s: reset, exit, pid %ld done.\n", BN(j), SCarg->pid);
    else          printk("%s: reset, exit.\n", BN(j));
@@ -1971,7 +1973,7 @@
            dkinfo[0], dkinfo[1], dkinfo[2]);
 #endif
 
-   return FALSE;
+   return 0;
 }
 
 static void sort(unsigned long sk[], unsigned int da[], unsigned int n,
@@ -2001,11 +2003,11 @@
 
 static int reorder(unsigned int j, unsigned long cursec,
                  unsigned int ihdlr, unsigned int il[], unsigned int n_ready) {
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
    struct mscp *cpp;
    unsigned int k, n;
-   unsigned int rev = FALSE, s = TRUE, r = TRUE;
-   unsigned int input_only = TRUE, overlap = FALSE;
+   unsigned int rev = 0, s = 1, r = 1;
+   unsigned int input_only = 1, overlap = 0;
    unsigned long sl[n_ready], pl[n_ready], ll[n_ready];
    unsigned long maxsec = 0, minsec = ULONG_MAX, seek = 0, iseek = 0;
    unsigned long ioseek = 0;
@@ -2022,12 +2024,12 @@
              seeknosort / (readycount + 1),
              seeksorted / (readycount + 1));
 
-   if (n_ready <= 1) return FALSE;
+   if (n_ready <= 1) return 0;
 
    for (n = 0; n < n_ready; n++) {
       k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
 
-      if (!cpp->din) input_only = FALSE;
+      if (!cpp->din) input_only = 0;
 
       if (SCpnt->request->sector < minsec) minsec = SCpnt->request->sector;
       if (SCpnt->request->sector > maxsec) maxsec = SCpnt->request->sector;
@@ -2037,8 +2039,8 @@
 
       if (!n) continue;
 
-      if (sl[n] < sl[n - 1]) s = FALSE;
-      if (sl[n] > sl[n - 1]) r = FALSE;
+      if (sl[n] < sl[n - 1]) s = 0;
+      if (sl[n] > sl[n - 1]) r = 0;
 
       if (link_statistics) {
          if (sl[n] > sl[n - 1])
@@ -2053,9 +2055,9 @@
       if (cursec > sl[0]) seek += cursec - sl[0]; else seek += sl[0] - cursec;
       }
 
-   if (cursec > ((maxsec + minsec) / 2)) rev = TRUE;
+   if (cursec > ((maxsec + minsec) / 2)) rev = 1;
 
-   if (ioseek > ((maxsec - minsec) / 2)) rev = FALSE;
+   if (ioseek > ((maxsec - minsec) / 2)) rev = 0;
 
    if (!((rev && r) || (!rev && s))) sort(sl, il, n_ready, rev);
 
@@ -2066,10 +2068,10 @@
       if (!n) continue;
 
       if ((sl[n] == sl[n - 1]) || (!rev && ((sl[n - 1] + ll[n - 1]) > sl[n]))
-          || (rev && ((sl[n] + ll[n]) > sl[n - 1]))) overlap = TRUE;
+          || (rev && ((sl[n] + ll[n]) > sl[n - 1]))) overlap = 1;
       }
 
-   if (overlap) sort(pl, il, n_ready, FALSE);
+   if (overlap) sort(pl, il, n_ready, 0);
 
    if (link_statistics) {
       if (cursec > sl[0]) iseek = cursec - sl[0]; else iseek = sl[0] - cursec;
@@ -2097,9 +2099,9 @@
    return overlap;
 }
 
-static void flush_dev(Scsi_Device *dev, unsigned long cursec, unsigned int j,
+static void flush_dev(struct scsi_device *dev, unsigned long cursec, unsigned int j,
                       unsigned int ihdlr) {
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
    struct mscp *cpp;
    unsigned int k, n, n_ready = 0, il[MAX_MAILBOXES];
 
@@ -2135,7 +2137,7 @@
 }
 
 static irqreturn_t ihdlr(int irq, unsigned int j) {
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
    unsigned int i, k, c, status, tstatus, reg;
    struct mssp *spp;
    struct mscp *cpp;
@@ -2184,13 +2186,13 @@
 #endif
 
    /* Reject any sp with supspect data */
-   if (spp->eoc == FALSE && HD(j)->iocount > 1)
-      printk("%s: ihdlr, spp->eoc == FALSE, irq %d, reg 0x%x, count %d.\n",
+   if (spp->eoc == 0 && HD(j)->iocount > 1)
+      printk("%s: ihdlr, spp->eoc == 0, irq %d, reg 0x%x, count %d.\n",
              BN(j), irq, reg, HD(j)->iocount);
    if (spp->cpp_index < 0 || spp->cpp_index >= sh[j]->can_queue)
       printk("%s: ihdlr, bad spp->cpp_index %d, irq %d, reg 0x%x, count %d.\n",
              BN(j), spp->cpp_index, irq, reg, HD(j)->iocount);
-   if (spp->eoc == FALSE || spp->cpp_index < 0
+   if (spp->eoc == 0 || spp->cpp_index < 0
                          || spp->cpp_index >= sh[j]->can_queue) goto handled;
 
    /* Find the mailbox to be serviced on this board */
@@ -2240,7 +2242,7 @@
 
    if (linked_comm && SCpnt->device->queue_depth > 2
                                      && TLDEV(SCpnt->device->type))
-      flush_dev(SCpnt->device, SCpnt->request->sector, j, TRUE);
+      flush_dev(SCpnt->device, SCpnt->request->sector, j, 1);
 
    tstatus = status_byte(spp->target_status);
 
@@ -2271,7 +2273,7 @@
             status = DID_OK << 16;
 
          if (tstatus == GOOD)
-            HD(j)->target_redo[SCpnt->device->id][SCpnt->device->channel] = FALSE;
+            HD(j)->target_redo[SCpnt->device->id][SCpnt->device->channel] = 0;
 
          if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
              (!(tstatus == CHECK_CONDITION && HD(j)->iocount <= 1000 &&
@@ -2305,7 +2307,7 @@
 
          for (c = 0; c <= sh[j]->max_channel; c++)
             for (k = 0; k < sh[j]->max_id; k++)
-               HD(j)->target_redo[k][c] = TRUE;
+               HD(j)->target_redo[k][c] = 1;
 
          if (SCpnt->device->type != TYPE_TAPE
              && HD(j)->retries < MAX_INTERNAL_RETRIES) {
@@ -2408,7 +2410,7 @@
 
    release_region(sh[j]->io_port, sh[j]->n_io_port);
    scsi_unregister(sh[j]);
-   return FALSE;
+   return 0;
 }
 
 #include "scsi_module.c"
===== drivers/scsi/ide-scsi.c 1.43 vs edited =====
