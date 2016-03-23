From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 09/23] ncr5380: Adopt uniform DMA setup convention
Date: Wed, 23 Mar 2016 21:10:18 +1100
Message-ID: <20160323101011.631743026@telegraphics.com.au>
References: <20160323101009.341929635@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-dma-setup-api
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Sam Creasey <sammy@sammy.net>, Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

Standardize the DMA setup hooks so that the DMA implementation in
atari_NCR5380.c can be reconciled with pseudo DMA implementation in
NCR5380.c.

Calls to NCR5380_dma_recv_setup() and NCR5380_dma_send_setup() return
a negative value on failure, zero on PDMA transfer success and a positive
byte count for DMA setup success.

This convention is not entirely new, but is now applied consistently.

Also remove a pointless Status Register access: the *phase assignment is
redundant because after NCR5380_transfer_dma() returns control to
NCR5380_information_transfer(), that routine then returns control
to NCR5380_main(), which means *phase is dead.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---
 drivers/scsi/NCR5380.c      |   21 ++++++++++-----------
 drivers/scsi/arm/cumana_1.c |   10 ++++++++--
 drivers/scsi/arm/oak.c      |    4 ++--
 drivers/scsi/atari_scsi.c   |    3 ---
 4 files changed, 20 insertions(+), 18 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-23 21:09:37.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-23 21:09:44.000000000 +1100
@@ -1431,7 +1431,7 @@ static int NCR5380_transfer_dma(struct S
 	register unsigned char p = *phase;
 	register unsigned char *d = *data;
 	unsigned char tmp;
-	int foo;
+	int result;
 
 	if ((tmp = (NCR5380_read(STATUS_REG) & PHASE_MASK)) != p) {
 		*phase = tmp;
@@ -1505,9 +1505,9 @@ static int NCR5380_transfer_dma(struct S
  */
 
 	if (p & SR_IO) {
-		foo = NCR5380_dma_recv_setup(instance, d,
+		result = NCR5380_dma_recv_setup(instance, d,
 			hostdata->flags & FLAG_DMA_FIXUP ? c - 1 : c);
-		if (!foo && (hostdata->flags & FLAG_DMA_FIXUP)) {
+		if (!result && (hostdata->flags & FLAG_DMA_FIXUP)) {
 			/*
 			 * The workaround was to transfer fewer bytes than we
 			 * intended to with the pseudo-DMA read function, wait for
@@ -1525,19 +1525,19 @@ static int NCR5380_transfer_dma(struct S
 
 			if (NCR5380_poll_politely(instance, BUS_AND_STATUS_REG,
 			                          BASR_DRQ, BASR_DRQ, HZ) < 0) {
-				foo = -1;
+				result = -1;
 				shost_printk(KERN_ERR, instance, "PDMA read: DRQ timeout\n");
 			}
 			if (NCR5380_poll_politely(instance, STATUS_REG,
 			                          SR_REQ, 0, HZ) < 0) {
-				foo = -1;
+				result = -1;
 				shost_printk(KERN_ERR, instance, "PDMA read: !REQ timeout\n");
 			}
 			d[c - 1] = NCR5380_read(INPUT_DATA_REG);
 		}
 	} else {
-		foo = NCR5380_dma_send_setup(instance, d, c);
-		if (!foo && (hostdata->flags & FLAG_DMA_FIXUP)) {
+		result = NCR5380_dma_send_setup(instance, d, c);
+		if (!result && (hostdata->flags & FLAG_DMA_FIXUP)) {
 			/*
 			 * Wait for the last byte to be sent.  If REQ is being asserted for
 			 * the byte we're interested, we'll ACK it and it will go false.
@@ -1545,7 +1545,7 @@ static int NCR5380_transfer_dma(struct S
 			if (NCR5380_poll_politely2(instance,
 			     BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
 			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, HZ) < 0) {
-				foo = -1;
+				result = -1;
 				shost_printk(KERN_ERR, instance, "PDMA write: DRQ and phase timeout\n");
 			}
 		}
@@ -1555,8 +1555,7 @@ static int NCR5380_transfer_dma(struct S
 	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	*data = d + c;
 	*count = 0;
-	*phase = NCR5380_read(STATUS_REG) & PHASE_MASK;
-	return foo;
+	return result;
 }
 
 /*
@@ -1652,7 +1651,7 @@ static void NCR5380_information_transfer
 				if (!cmd->device->borken)
 					transfersize = NCR5380_dma_xfer_len(instance, cmd, phase);
 
-				if (transfersize) {
+				if (transfersize > 0) {
 					len = transfersize;
 					if (NCR5380_transfer_dma(instance, &phase,
 					    &len, (unsigned char **)&cmd->SCp.ptr)) {
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2016-03-23 21:09:37.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2016-03-23 21:09:44.000000000 +1100
@@ -101,7 +101,10 @@ static inline int cumanascsi_pwrite(stru
   }
 end:
   writeb(priv(host)->ctrl | 0x40, priv(host)->base + CTRL);
-  return len;
+
+	if (len)
+		return -1;
+	return 0;
 }
 
 static inline int cumanascsi_pread(struct Scsi_Host *host,
@@ -163,7 +166,10 @@ static inline int cumanascsi_pread(struc
   }
 end:
   writeb(priv(host)->ctrl | 0x40, priv(host)->base + CTRL);
-  return len;
+
+	if (len)
+		return -1;
+	return 0;
 }
 
 static unsigned char cumanascsi_read(struct Scsi_Host *host, unsigned int reg)
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2016-03-23 21:09:37.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2016-03-23 21:09:44.000000000 +1100
@@ -47,13 +47,13 @@ static inline int oakscsi_pwrite(struct
   void __iomem *base = priv(instance)->base;
 
 printk("writing %p len %d\n",addr, len);
-  if(!len) return -1;
 
   while(1)
   {
     int status;
     while (((status = readw(base + STAT)) & 0x100)==0);
   }
+  return 0;
 }
 
 static inline int oakscsi_pread(struct Scsi_Host *instance,
@@ -74,7 +74,7 @@ printk("reading %p len %d\n", addr, len)
       if(status & 0x200 || !timeout)
       {
         printk("status = %08X\n", status);
-        return 1;
+        return -1;
       }
     }
 
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2016-03-23 21:09:24.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2016-03-23 21:09:44.000000000 +1100
@@ -527,9 +527,6 @@ static unsigned long atari_scsi_dma_setu
 	 */
 	dma_cache_maintenance(addr, count, dir);
 
-	if (count == 0)
-		printk(KERN_NOTICE "SCSI warning: DMA programmed for 0 bytes !\n");
-
 	if (IS_A_TT()) {
 		tt_scsi_dma.dma_ctrl = dir;
 		SCSI_DMA_WRITE_P(dma_addr, addr);
