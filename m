From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of obsolete APIs in u14-34f
Date: Sun, 3 Oct 2004 13:50:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041003115000.GA32463@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:16565 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267818AbUJCLuD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2004 07:50:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.32/drivers/scsi/u14-34f.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/u14-34f.c	2004-10-02 15:29:44 +02:00
@@ -421,22 +421,26 @@
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
-#include <scsi/scsicam.h>
-#include "scsi.h"
-#include <scsi/scsi_host.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 
-static int u14_34f_detect(Scsi_Host_Template *);
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsicam.h>
+
+static int u14_34f_detect(struct scsi_host_template *);
 static int u14_34f_release(struct Scsi_Host *);
-static int u14_34f_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int u14_34f_eh_abort(Scsi_Cmnd *);
-static int u14_34f_eh_host_reset(Scsi_Cmnd *);
+static int u14_34f_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int u14_34f_eh_abort(struct scsi_cmnd *);
+static int u14_34f_eh_host_reset(struct scsi_cmnd *);
 static int u14_34f_bios_param(struct scsi_device *, struct block_device *,
                               sector_t, int *);
-static int u14_34f_slave_configure(Scsi_Device *);
+static int u14_34f_slave_configure(struct scsi_device *);
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
                 .name                    = "UltraStor 14F/34F rev. 8.10.00 ",
                 .detect                  = u14_34f_detect,
                 .release                 = u14_34f_release,
@@ -575,7 +579,7 @@
    unsigned int sense_addr PACKED;
 
    /* Additional fields begin here. */
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
    unsigned int cpp_index;              /* cp index */
 
    /* All the cp structure is zero filled by queuecommand except the
@@ -634,7 +638,7 @@
 #define DEV2H(x) le32_to_cpu(x)
 
 static irqreturn_t do_interrupt_handler(int, void *, struct pt_regs *);
-static void flush_dev(Scsi_Device *, unsigned long, unsigned int, unsigned int);
+static void flush_dev(struct scsi_device *, unsigned long, unsigned int, unsigned int);
 static int do_trace = FALSE;
 static int setup_done = FALSE;
 static int link_statistics;
@@ -682,7 +686,7 @@
 
 #endif
 
-static int u14_34f_slave_configure(Scsi_Device *dev) {
+static int u14_34f_slave_configure(struct scsi_device *dev) {
    int j, tqd, utqd;
    char *tag_suffix, *link_suffix;
    struct Scsi_Host *host = dev->host;
@@ -794,7 +798,7 @@
 }
 
 static int port_detect \
-      (unsigned long port_base, unsigned int j, Scsi_Host_Template *tpnt) {
+      (unsigned long port_base, unsigned int j, struct scsi_host_template *tpnt) {
    unsigned char irq, dma_channel, subversion, i;
    unsigned char in_byte;
    char *bus_type, dma_name[16];
@@ -1080,7 +1084,7 @@
    return 1;
 }
 
-static int u14_34f_detect(Scsi_Host_Template *tpnt) {
+static int u14_34f_detect(struct scsi_host_template *tpnt) {
    unsigned int j = 0, k;
 
    tpnt->proc_name = "u14-34f";
@@ -1113,10 +1117,10 @@
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
@@ -1156,10 +1160,10 @@
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
@@ -1178,10 +1182,10 @@
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
@@ -1214,24 +1218,24 @@
       };
 
    struct mscp *cpp;
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
 
    cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
 
-   if (SCpnt->sc_data_direction == SCSI_DATA_READ) {
+   if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
       cpp->xdir = DTD_IN;
       return;
       }
-   else if (SCpnt->sc_data_direction == SCSI_DATA_WRITE) {
+   else if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
       cpp->xdir = DTD_OUT;
       return;
       }
-   else if (SCpnt->sc_data_direction == SCSI_DATA_NONE) {
+   else if (SCpnt->sc_data_direction == DMA_NONE) {
       cpp->xdir = DTD_NONE;
       return;
       }
 
-   if (SCpnt->sc_data_direction != SCSI_DATA_UNKNOWN)
+   if (SCpnt->sc_data_direction != DMA_BIDIRECTIONAL)
       panic("%s: qcomm, invalid SCpnt->sc_data_direction.\n", BN(j));
 
    cpp->xdir = DTD_IN;
@@ -1251,7 +1255,7 @@
 
 }
 
-static int u14_34f_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *)) {
+static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *)) {
    unsigned int i, j, k;
    struct mscp *cpp;
 
@@ -1332,7 +1336,7 @@
    return 0;
 }
 
-static int u14_34f_eh_abort(Scsi_Cmnd *SCarg) {
+static int u14_34f_eh_abort(struct scsi_cmnd *SCarg) {
    unsigned int i, j;
 
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
@@ -1406,10 +1410,10 @@
    panic("%s: abort, mbox %d, invalid cp_stat.\n", BN(j), i);
 }
 
-static int u14_34f_eh_host_reset(Scsi_Cmnd *SCarg) {
+static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
    unsigned int i, j, time, k, c, limit = 0;
    int arg_done = FALSE;
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
 
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
    printk("%s: reset, enter, target %d.%d:%d, pid %ld.\n",
@@ -1589,7 +1593,7 @@
 
 static int reorder(unsigned int j, unsigned long cursec,
                  unsigned int ihdlr, unsigned int il[], unsigned int n_ready) {
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
    struct mscp *cpp;
    unsigned int k, n;
    unsigned int rev = FALSE, s = TRUE, r = TRUE;
@@ -1685,9 +1689,9 @@
    return overlap;
 }
 
-static void flush_dev(Scsi_Device *dev, unsigned long cursec, unsigned int j,
+static void flush_dev(struct scsi_device *dev, unsigned long cursec, unsigned int j,
                       unsigned int ihdlr) {
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
    struct mscp *cpp;
    unsigned int k, n, n_ready = 0, il[MAX_MAILBOXES];
 
@@ -1725,7 +1729,7 @@
 }
 
 static irqreturn_t ihdlr(int irq, unsigned int j) {
-   Scsi_Cmnd *SCpnt;
+   struct scsi_cmnd *SCpnt;
    unsigned int i, k, c, status, tstatus, reg, ret;
    struct mscp *spp, *cpp;
 
