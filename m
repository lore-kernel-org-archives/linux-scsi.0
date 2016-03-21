From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 22/23] mac_scsi: Fix pseudo DMA implementation
Date: Mon, 21 Mar 2016 13:32:11 +1100
Message-ID: <20160321023155.354008578@telegraphics.com.au>
References: <20160321023149.604138431@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=mac_scsi-pdma-fixes
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

Fix various issues: Comments about bus errors are incorrect. The
PDMA asm must return the size of the memory access that faulted so the
transfer count can be adjusted accordingly. A phase change may cause a
bus error but should not be treated as failure. A bus error does not
always imply a phase change and generally the transfer may continue.
Scatter/gather doesn't seem to work with PDMA due to overruns. This is
a pity because peak throughput seems to double with SG_ALL.
Tested on a Mac LC III.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---

Changed since v1:
- Set the default cmd_per_lun to 4 based on test results.

Changed since v2:
- Revert the default cmd_per_lun to 2, like in the v1 patch, because
a uniform default across all ten 5380 wrapper drivers is worth more
than a tiny improvement in one particular microbenchmark on one system.
- Add 'reviewed-by' tag.

---
 drivers/scsi/NCR5380.h  |    2 
 drivers/scsi/mac_scsi.c |  210 ++++++++++++++++++++++++++----------------------
 2 files changed, 118 insertions(+), 94 deletions(-)

Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2016-03-21 13:31:33.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2016-03-21 13:31:45.000000000 +1100
@@ -28,7 +28,8 @@
 
 /* Definitions for the core NCR5380 driver. */
 
-#define NCR5380_implementation_fields   unsigned char *pdma_base
+#define NCR5380_implementation_fields   unsigned char *pdma_base; \
+                                        int pdma_residual
 
 #define NCR5380_read(reg)               macscsi_read(instance, reg)
 #define NCR5380_write(reg, value)       macscsi_write(instance, reg, value)
@@ -37,7 +38,7 @@
         macscsi_dma_xfer_len(instance, cmd)
 #define NCR5380_dma_recv_setup          macscsi_pread
 #define NCR5380_dma_send_setup          macscsi_pwrite
-#define NCR5380_dma_residual(instance)  (0)
+#define NCR5380_dma_residual(instance)  (hostdata->pdma_residual)
 
 #define NCR5380_intr                    macscsi_intr
 #define NCR5380_queue_command           macscsi_queue_command
@@ -104,18 +105,9 @@ static int __init mac_scsi_setup(char *s
 __setup("mac5380=", mac_scsi_setup);
 #endif /* !MODULE */
 
-/* 
-   Pseudo-DMA: (Ove Edlund)
-   The code attempts to catch bus errors that occur if one for example
-   "trips over the cable".
-   XXX: Since bus errors in the PDMA routines never happen on my 
-   computer, the bus error code is untested. 
-   If the code works as intended, a bus error results in Pseudo-DMA 
-   being disabled, meaning that the driver switches to slow handshake.
-   If bus errors are NOT extremely rare, this has to be changed. 
-*/
+/* Pseudo DMA asm originally by Ove Edlund */
 
-#define CP_IO_TO_MEM(s,d,len)				\
+#define CP_IO_TO_MEM(s,d,n)				\
 __asm__ __volatile__					\
     ("    cmp.w  #4,%2\n"				\
      "    bls    8f\n"					\
@@ -152,61 +144,73 @@ __asm__ __volatile__					\
      " 9: \n"						\
      ".section .fixup,\"ax\"\n"				\
      "    .even\n"					\
-     "90: moveq.l #1, %2\n"				\
+     "91: moveq.l #1, %2\n"				\
+     "    jra 9b\n"					\
+     "94: moveq.l #4, %2\n"				\
      "    jra 9b\n"					\
      ".previous\n"					\
      ".section __ex_table,\"a\"\n"			\
      "   .align 4\n"					\
-     "   .long  1b,90b\n"				\
-     "   .long  3b,90b\n"				\
-     "   .long 31b,90b\n"				\
-     "   .long 32b,90b\n"				\
-     "   .long 33b,90b\n"				\
-     "   .long 34b,90b\n"				\
-     "   .long 35b,90b\n"				\
-     "   .long 36b,90b\n"				\
-     "   .long 37b,90b\n"				\
-     "   .long  5b,90b\n"				\
-     "   .long  7b,90b\n"				\
+     "   .long  1b,91b\n"				\
+     "   .long  3b,94b\n"				\
+     "   .long 31b,94b\n"				\
+     "   .long 32b,94b\n"				\
+     "   .long 33b,94b\n"				\
+     "   .long 34b,94b\n"				\
+     "   .long 35b,94b\n"				\
+     "   .long 36b,94b\n"				\
+     "   .long 37b,94b\n"				\
+     "   .long  5b,94b\n"				\
+     "   .long  7b,91b\n"				\
      ".previous"					\
-     : "=a"(s), "=a"(d), "=d"(len)			\
-     : "0"(s), "1"(d), "2"(len)				\
+     : "=a"(s), "=a"(d), "=d"(n)			\
+     : "0"(s), "1"(d), "2"(n)				\
      : "d0")
 
 static int macscsi_pread(struct Scsi_Host *instance,
                          unsigned char *dst, int len)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	unsigned char *d;
-	unsigned char *s;
-
-	s = hostdata->pdma_base + (INPUT_DATA_REG << 4);
-	d = dst;
-
-	/* These conditions are derived from MacOS */
-
-	while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
-	       !(NCR5380_read(STATUS_REG) & SR_REQ))
-		;
-
-	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
-	    (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
-		pr_err("Error in macscsi_pread\n");
-		return -1;
-	}
-
-	CP_IO_TO_MEM(s, d, len);
-
-	if (len != 0) {
-		pr_notice("Bus error in macscsi_pread\n");
-		return -1;
+	unsigned char *s = hostdata->pdma_base + (INPUT_DATA_REG << 4);
+	unsigned char *d = dst;
+	int n = len;
+	int transferred;
+
+	while (!NCR5380_poll_politely(instance, BUS_AND_STATUS_REG,
+	                              BASR_DRQ | BASR_PHASE_MATCH,
+	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
+		CP_IO_TO_MEM(s, d, n);
+
+		transferred = d - dst - n;
+		hostdata->pdma_residual = len - transferred;
+
+		/* No bus error. */
+		if (n == 0)
+			return 0;
+
+		/* Target changed phase early? */
+		if (NCR5380_poll_politely2(instance, STATUS_REG, SR_REQ, SR_REQ,
+		                           BUS_AND_STATUS_REG, BASR_ACK, BASR_ACK, HZ / 64) < 0)
+			scmd_printk(KERN_ERR, hostdata->connected,
+			            "%s: !REQ and !ACK\n", __func__);
+		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
+			return 0;
+
+		dsprintk(NDEBUG_PSEUDO_DMA, instance,
+		         "%s: bus error (%d/%d)\n", __func__, transferred, len);
+		NCR5380_dprint(NDEBUG_PSEUDO_DMA, instance);
+		d = dst + transferred;
+		n = len - transferred;
 	}
 
-	return 0;
+	scmd_printk(KERN_ERR, hostdata->connected,
+	            "%s: phase mismatch or !DRQ\n", __func__);
+	NCR5380_dprint(NDEBUG_PSEUDO_DMA, instance);
+	return -1;
 }
 
 
-#define CP_MEM_TO_IO(s,d,len)				\
+#define CP_MEM_TO_IO(s,d,n)				\
 __asm__ __volatile__					\
     ("    cmp.w  #4,%2\n"				\
      "    bls    8f\n"					\
@@ -243,57 +247,76 @@ __asm__ __volatile__					\
      " 9: \n"						\
      ".section .fixup,\"ax\"\n"				\
      "    .even\n"					\
-     "90: moveq.l #1, %2\n"				\
+     "91: moveq.l #1, %2\n"				\
+     "    jra 9b\n"					\
+     "94: moveq.l #4, %2\n"				\
      "    jra 9b\n"					\
      ".previous\n"					\
      ".section __ex_table,\"a\"\n"			\
      "   .align 4\n"					\
-     "   .long  1b,90b\n"				\
-     "   .long  3b,90b\n"				\
-     "   .long 31b,90b\n"				\
-     "   .long 32b,90b\n"				\
-     "   .long 33b,90b\n"				\
-     "   .long 34b,90b\n"				\
-     "   .long 35b,90b\n"				\
-     "   .long 36b,90b\n"				\
-     "   .long 37b,90b\n"				\
-     "   .long  5b,90b\n"				\
-     "   .long  7b,90b\n"				\
+     "   .long  1b,91b\n"				\
+     "   .long  3b,94b\n"				\
+     "   .long 31b,94b\n"				\
+     "   .long 32b,94b\n"				\
+     "   .long 33b,94b\n"				\
+     "   .long 34b,94b\n"				\
+     "   .long 35b,94b\n"				\
+     "   .long 36b,94b\n"				\
+     "   .long 37b,94b\n"				\
+     "   .long  5b,94b\n"				\
+     "   .long  7b,91b\n"				\
      ".previous"					\
-     : "=a"(s), "=a"(d), "=d"(len)			\
-     : "0"(s), "1"(d), "2"(len)				\
+     : "=a"(s), "=a"(d), "=d"(n)			\
+     : "0"(s), "1"(d), "2"(n)				\
      : "d0")
 
 static int macscsi_pwrite(struct Scsi_Host *instance,
                           unsigned char *src, int len)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	unsigned char *s;
-	unsigned char *d;
-
-	s = src;
-	d = hostdata->pdma_base + (OUTPUT_DATA_REG << 4);
-
-	/* These conditions are derived from MacOS */
-
-	while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
-	       (!(NCR5380_read(STATUS_REG) & SR_REQ) ||
-	        (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)))
-		;
-
-	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ)) {
-		pr_err("Error in macscsi_pwrite\n");
-		return -1;
+	unsigned char *s = src;
+	unsigned char *d = hostdata->pdma_base + (OUTPUT_DATA_REG << 4);
+	int n = len;
+	int transferred;
+
+	while (!NCR5380_poll_politely(instance, BUS_AND_STATUS_REG,
+	                              BASR_DRQ | BASR_PHASE_MATCH,
+	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
+		CP_MEM_TO_IO(s, d, n);
+
+		transferred = s - src - n;
+		hostdata->pdma_residual = len - transferred;
+
+		/* Target changed phase early? */
+		if (NCR5380_poll_politely2(instance, STATUS_REG, SR_REQ, SR_REQ,
+		                           BUS_AND_STATUS_REG, BASR_ACK, BASR_ACK, HZ / 64) < 0)
+			scmd_printk(KERN_ERR, hostdata->connected,
+			            "%s: !REQ and !ACK\n", __func__);
+		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
+			return 0;
+
+		/* No bus error. */
+		if (n == 0) {
+			if (NCR5380_poll_politely(instance, TARGET_COMMAND_REG,
+			                          TCR_LAST_BYTE_SENT,
+			                          TCR_LAST_BYTE_SENT, HZ / 64) < 0)
+				scmd_printk(KERN_ERR, hostdata->connected,
+				            "%s: Last Byte Sent timeout\n", __func__);
+			return 0;
+		}
+
+		dsprintk(NDEBUG_PSEUDO_DMA, instance,
+		         "%s: bus error (%d/%d)\n", __func__, transferred, len);
+		NCR5380_dprint(NDEBUG_PSEUDO_DMA, instance);
+		s = src + transferred;
+		n = len - transferred;
 	}
 
-	CP_MEM_TO_IO(s, d, len);
-
-	if (len != 0) {
-		pr_notice("Bus error in macscsi_pwrite\n");
-		return -1;
-	}
+	scmd_printk(KERN_ERR, hostdata->connected,
+	            "%s: phase mismatch or !DRQ\n", __func__);
+	NCR5380_dprint(NDEBUG_PSEUDO_DMA, instance);
 
-	return 0;
+	return -1;
 }
 
 static int macscsi_dma_xfer_len(struct Scsi_Host *instance,
@@ -301,10 +324,11 @@ static int macscsi_dma_xfer_len(struct S
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
-	if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
+	if (hostdata->flags & FLAG_NO_PSEUDO_DMA ||
+	    cmd->SCp.this_residual < 16)
 		return 0;
 
-	return cmd->transfersize;
+	return cmd->SCp.this_residual;
 }
 
 #include "NCR5380.c"
@@ -322,7 +346,7 @@ static struct scsi_host_template mac_scs
 	.eh_bus_reset_handler	= macscsi_bus_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= 1,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
@@ -358,8 +382,6 @@ static int __init mac_scsi_probe(struct
 		mac_scsi_template.sg_tablesize = setup_sg_tablesize;
 	if (setup_hostid >= 0)
 		mac_scsi_template.this_id = setup_hostid & 7;
-	if (setup_use_pdma < 0)
-		setup_use_pdma = 0;
 
 	instance = scsi_host_alloc(&mac_scsi_template,
 	                           sizeof(struct NCR5380_hostdata));
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-03-21 13:31:40.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-03-21 13:31:45.000000000 +1100
@@ -292,6 +292,8 @@ static void NCR5380_reselect(struct Scsi
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
+static int NCR5380_poll_politely(struct Scsi_Host *, int, int, int, int);
+static int NCR5380_poll_politely2(struct Scsi_Host *, int, int, int, int, int, int, int);
 
 #endif				/* __KERNEL__ */
 #endif				/* NCR5380_H */
