From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] implement settable transport attributes for 53c700
Date: 07 Mar 2004 15:24:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078691050.2080.45.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:20414 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262328AbUCGUYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Mar 2004 15:24:12 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i27KORa16288
	for <linux-scsi@vger.kernel.org>; Sun, 7 Mar 2004 15:24:27 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The 53c700 is a nice driver, being narrow and only going up to FAST-10,
it only allows control of the offset and period.

This patch moves the internal storage of the offset and period to the
transport class and adds methods to set them (there's no need for a get
method since the value in the transport class is exactly what the driver
believes the transport agreement to be).

You can see how this type of use of the transport class is supposed to
work: the driver now has init and exit routines attaching and releasing
the transport class (that's the reason for the Makefile perturbation
because it has to init before its users).  The correct attributes are
set up in slave_configure() for negotiation and we now export the period
and offset setting functions.

James

===== drivers/scsi/53c700.c 1.46 vs edited =====
--- 1.46/drivers/scsi/53c700.c	Mon Feb 23 15:07:38 2004
+++ edited/drivers/scsi/53c700.c	Sun Mar  7 13:53:59 2004
@@ -137,6 +137,9 @@
 #include "scsi.h"
 #include "hosts.h"
 
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
 #include "53c700.h"
 
 /* NOTE: For 64 bit drivers there are points in the code where we use
@@ -173,6 +176,8 @@
 
 STATIC struct device_attribute *NCR_700_dev_attrs[];
 
+STATIC struct scsi_transport_template *NCR_700_transport_template = NULL;
+
 static char *NCR_700_phase[] = {
 	"",
 	"after selection",
@@ -236,6 +241,53 @@
 	NCR_700_MAX_OFFSET
 };
 
+/* This translates the SDTR message offset and period to a value
+ * which can be loaded into the SXFER_REG.
+ *
+ * NOTE: According to SCSI-2, the true transfer period (in ns) is
+ *       actually four times this period value */
+static inline __u8
+NCR_700_offset_period_to_sxfer(struct NCR_700_Host_Parameters *hostdata,
+			       __u8 offset, __u8 period)
+{
+	int XFERP;
+
+	__u8 min_xferp = (hostdata->chip710
+			  ? NCR_710_MIN_XFERP : NCR_700_MIN_XFERP);
+	__u8 max_offset = (hostdata->chip710
+			   ? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET);
+
+	if(offset == 0)
+		return 0;
+
+	if(period < hostdata->min_period) {
+		printk(KERN_WARNING "53c700: Period %dns is less than this chip's minimum, setting to %d\n", period*4, NCR_700_SDTR_msg[3]*4);
+		period = hostdata->min_period;
+	}
+	XFERP = (period*4 * hostdata->sync_clock)/1000 - 4;
+	if(offset > max_offset) {
+		printk(KERN_WARNING "53c700: Offset %d exceeds chip maximum, setting to %d\n",
+		       offset, max_offset);
+		offset = max_offset;
+	}
+	if(XFERP < min_xferp) {
+		printk(KERN_WARNING "53c700: XFERP %d is less than minium, setting to %d\n",
+		       XFERP,  min_xferp);
+		XFERP =  min_xferp;
+	}
+	return (offset & 0x0f) | (XFERP & 0x07)<<4;
+}
+
+static inline __u8
+NCR_700_get_SXFER(Scsi_Device *SDp)
+{
+	struct NCR_700_Host_Parameters *hostdata = 
+		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+
+	return NCR_700_offset_period_to_sxfer(hostdata, spi_offset(SDp),
+					      spi_period(SDp));
+}
+
 struct Scsi_Host *
 NCR_700_detect(Scsi_Host_Template *tpnt,
 	       struct NCR_700_Host_Parameters *hostdata)
@@ -326,6 +378,8 @@
 	hostdata->cmd = NULL;
 	host->max_id = 7;
 	host->max_lun = NCR_700_MAX_LUNS;
+	BUG_ON(NCR_700_transport_template == NULL);
+	host->transportt = NCR_700_transport_template;
 	host->unique_id = hostdata->base;
 	host->base = hostdata->base;
 	hostdata->eh_complete = NULL;
@@ -520,40 +574,6 @@
 	hostdata->cmd = NULL;
 }
 
-/* This translates the SDTR message offset and period to a value
- * which can be loaded into the SXFER_REG.
- *
- * NOTE: According to SCSI-2, the true transfer period (in ns) is
- *       actually four times this period value */
-STATIC inline __u8
-NCR_700_offset_period_to_sxfer(struct NCR_700_Host_Parameters *hostdata,
-			       __u8 offset, __u8 period)
-{
-	int XFERP;
-	__u8 min_xferp = (hostdata->chip710
-			  ? NCR_710_MIN_XFERP : NCR_700_MIN_XFERP);
-	__u8 max_offset = (hostdata->chip710
-			   ? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET);
-	/* NOTE: NCR_700_SDTR_msg[3] contains our offer of the minimum
-	 * period.  It is set in NCR_700_chip_setup() */
-	if(period < NCR_700_SDTR_msg[3]) {
-		printk(KERN_WARNING "53c700: Period %dns is less than this chip's minimum, setting to %d\n", period*4, NCR_700_SDTR_msg[3]*4);
-		period = NCR_700_SDTR_msg[3];
-	}
-	XFERP = (period*4 * hostdata->sync_clock)/1000 - 4;
-	if(offset > max_offset) {
-		printk(KERN_WARNING "53c700: Offset %d exceeds chip maximum, setting to %d\n",
-		       offset, max_offset);
-		offset = max_offset;
-	}
-	if(XFERP < min_xferp) {
-		printk(KERN_WARNING "53c700: XFERP %d is less than minium, setting to %d\n",
-		       XFERP,  min_xferp);
-		XFERP =  min_xferp;
-	}
-	return (offset & 0x0f) | (XFERP & 0x07)<<4;
-}
-
 STATIC inline void
 NCR_700_unmap(struct NCR_700_Host_Parameters *hostdata, Scsi_Cmnd *SCp,
 	      struct NCR_700_command_slot *slot)
@@ -724,11 +744,9 @@
 	 * exact details of this calculation which is based on a
 	 * setting of the SXFER register */
 	min_period = 1000*(4+min_xferp)/(4*hostdata->sync_clock);
-	if(min_period > NCR_700_MIN_PERIOD) {
-		NCR_700_SDTR_msg[3] = min_period;
-	}
-	if(hostdata->chip710)
-		NCR_700_SDTR_msg[4] = NCR_710_MAX_OFFSET;
+	hostdata->min_period = NCR_700_MIN_PERIOD;
+	if(min_period > NCR_700_MIN_PERIOD)
+		hostdata->min_period = min_period;
 }
 
 STATIC void
@@ -777,20 +795,25 @@
 		if(SCp != NULL && NCR_700_is_flag_set(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION)) {
 			__u8 period = hostdata->msgin[3];
 			__u8 offset = hostdata->msgin[4];
-			__u8 sxfer;
 
-			if(offset != 0 && period != 0)
-				sxfer = NCR_700_offset_period_to_sxfer(hostdata, offset, period);
-			else 
-				sxfer = 0;
+			if(offset == 0 || period == 0) {
+				offset = 0;
+				period = 0;
+			}
 			
-			if(sxfer != NCR_700_get_SXFER(SCp->device)) {
-				printk(KERN_INFO "scsi%d: (%d:%d) Synchronous at offset %d, period %dns\n",
-				       host->host_no, pun, lun,
-				       offset, period*4);
-				
-				NCR_700_set_SXFER(SCp->device, sxfer);
+			if(NCR_700_is_flag_set(SCp->device, NCR_700_DEV_PRINT_SYNC_NEGOTIATION)) {
+				if(spi_offset(SCp->device) != 0)
+					printk(KERN_INFO "scsi%d: (%d:%d) Synchronous at offset %d, period %dns\n",
+					       host->host_no, pun, lun,
+					       offset, period*4);
+				else
+					printk(KERN_INFO "scsi%d: (%d:%d) Asynchronous\n",
+					       host->host_no, pun, lun);
+				NCR_700_clear_flag(SCp->device, NCR_700_DEV_PRINT_SYNC_NEGOTIATION);
 			}
+				
+			spi_offset(SCp->device) = offset;
+			spi_period(SCp->device) = period;
 			
 
 			NCR_700_set_flag(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC);
@@ -870,7 +893,7 @@
 	case A_REJECT_MSG:
 		if(SCp != NULL && NCR_700_is_flag_set(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION)) {
 			/* Rejected our sync negotiation attempt */
-			NCR_700_set_SXFER(SCp->device, 0);
+			spi_period(SCp->device) = spi_offset(SCp->device) = 0;
 			NCR_700_set_flag(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC);
 			NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 		} else if(SCp != NULL && NCR_700_is_flag_set(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING)) {
@@ -1396,6 +1419,8 @@
 	   NCR_700_is_flag_clear(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC)) {
 		memcpy(&hostdata->msgout[count], NCR_700_SDTR_msg,
 		       sizeof(NCR_700_SDTR_msg));
+		hostdata->msgout[count+3] = spi_period(SCp->device);
+		hostdata->msgout[count+4] = spi_offset(SCp->device);
 		count += sizeof(NCR_700_SDTR_msg);
 		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 	}
@@ -1967,9 +1992,51 @@
 	return SUCCESS;
 }
 
+STATIC void
+NCR_700_set_period(struct scsi_device *SDp, int period)
+{
+	struct NCR_700_Host_Parameters *hostdata = 
+		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+	
+	if(!hostdata->fast || period < hostdata->min_period)
+		return;
+
+	spi_period(SDp) = period;
+	NCR_700_clear_flag(SDp, NCR_700_DEV_NEGOTIATED_SYNC);
+	NCR_700_clear_flag(SDp, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
+	NCR_700_set_flag(SDp, NCR_700_DEV_PRINT_SYNC_NEGOTIATION);
+}
+
+STATIC void
+NCR_700_set_offset(struct scsi_device *SDp, int offset)
+{
+	struct NCR_700_Host_Parameters *hostdata = 
+		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+	
+	if(!hostdata->fast ||
+	   offset > (hostdata->chip710
+		     ? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET))
+		return;
+
+	/* if we're currently async, make sure the period is reasonable */
+	if(spi_offset(SDp) == 0 && (spi_period(SDp) < hostdata->min_period ||
+				    spi_period(SDp) > 0xff))
+		spi_period(SDp) = hostdata->min_period;
+
+	spi_offset(SDp) = offset;
+	NCR_700_clear_flag(SDp, NCR_700_DEV_NEGOTIATED_SYNC);
+	NCR_700_clear_flag(SDp, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
+	NCR_700_set_flag(SDp, NCR_700_DEV_PRINT_SYNC_NEGOTIATION);
+}
+
+
+
 STATIC int
 NCR_700_slave_configure(Scsi_Device *SDp)
 {
+	struct NCR_700_Host_Parameters *hostdata = 
+		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+
 	/* to do here: allocate memory; build a queue_full list */
 	if(SDp->tagged_supported) {
 		/* do TCQ stuff here */
@@ -1977,6 +2044,11 @@
 		/* initialise to default depth */
 		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
 	}
+	if(hostdata->fast) {
+		NCR_700_set_period(SDp, hostdata->min_period);
+		NCR_700_set_offset(SDp, hostdata->chip710
+				   ? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET);
+	}
 	return 0;
 }
 
@@ -2033,3 +2105,25 @@
 EXPORT_SYMBOL(NCR_700_detect);
 EXPORT_SYMBOL(NCR_700_release);
 EXPORT_SYMBOL(NCR_700_intr);
+
+static struct spi_function_template NCR_700_transport_functions =  {
+	.set_period = NCR_700_set_period,
+	.set_offset = NCR_700_set_offset,
+};
+
+static int __init NCR_700_init(void)
+{
+	NCR_700_transport_template = spi_attach_transport(&NCR_700_transport_functions);
+	if(!NCR_700_transport_template)
+		return -ENODEV;
+	return 0;
+}
+
+static void __exit NCR_700_exit(void)
+{
+	spi_release_transport(NCR_700_transport_template);
+}
+
+module_init(NCR_700_init);
+module_exit(NCR_700_exit);
+
===== drivers/scsi/53c700.h 1.15 vs edited =====
--- 1.15/drivers/scsi/53c700.h	Mon Feb 23 15:07:38 2004
+++ edited/drivers/scsi/53c700.h	Sun Mar  7 12:29:07 2004
@@ -99,19 +99,9 @@
 #define NCR_700_DEV_NEGOTIATED_SYNC	(1<<16)
 #define NCR_700_DEV_BEGIN_SYNC_NEGOTIATION	(1<<17)
 #define NCR_700_DEV_BEGIN_TAG_QUEUEING	(1<<18)
-#define NCR_700_DEV_TAG_STARVATION_WARNED (1<<19)
+#define NCR_700_DEV_PRINT_SYNC_NEGOTIATION (1<<19)
 
 static inline void
-NCR_700_set_SXFER(Scsi_Device *SDp, __u8 sxfer)
-{
-	SDp->hostdata = (void *)(((long)SDp->hostdata & 0xffffff00) |
-				(sxfer & 0xff));
-}
-static inline __u8 NCR_700_get_SXFER(Scsi_Device *SDp)
-{
-	return (((unsigned long)SDp->hostdata) & 0xff);
-}
-static inline void
 NCR_700_set_depth(Scsi_Device *SDp, __u8 depth)
 {
 	long l = (long)SDp->hostdata;
@@ -215,6 +205,7 @@
 	__u8	tag_negotiated;
 	__u8	rev;
 	__u8	reselection_id;
+	__u8	min_period;
 
 	/* Free list, singly linked by ITL_forw elements */
 	struct NCR_700_command_slot *free_list;
@@ -438,6 +429,7 @@
 		       #symbol, A_##symbol##_used[i], val)); \
 	} \
 }
+
 
 static inline __u8
 NCR_700_mem_readb(struct Scsi_Host *host, __u32 reg)
===== drivers/scsi/Makefile 1.55 vs edited =====
--- 1.55/drivers/scsi/Makefile	Thu Mar  4 16:29:02 2004
+++ edited/drivers/scsi/Makefile	Sun Mar  7 12:29:08 2004
@@ -49,7 +49,7 @@
 obj-$(CONFIG_SUN3_SCSI)		+= sun3_scsi.o  sun3_scsi_vme.o
 obj-$(CONFIG_MVME16x_SCSI)	+= mvme16x.o	53c7xx.o
 obj-$(CONFIG_BVME6000_SCSI)	+= bvme6000.o	53c7xx.o
-obj-$(CONFIG_SCSI_SIM710)	+= sim710.o	53c700.o
+obj-$(CONFIG_SCSI_SIM710)	+= 53c700.o	sim710.o
 obj-$(CONFIG_SCSI_ADVANSYS)	+= advansys.o
 obj-$(CONFIG_SCSI_PCI2000)	+= pci2000.o
 obj-$(CONFIG_SCSI_PCI2220I)	+= pci2220i.o
@@ -72,7 +72,7 @@
 obj-$(CONFIG_SCSI_GENERIC_NCR5380) += g_NCR5380.o
 obj-$(CONFIG_SCSI_GENERIC_NCR5380_MMIO) += g_NCR5380_mmio.o
 obj-$(CONFIG_SCSI_NCR53C406A)	+= NCR53c406a.o
-obj-$(CONFIG_SCSI_NCR_D700)	+= NCR_D700.o 53c700.o
+obj-$(CONFIG_SCSI_NCR_D700)	+= 53c700.o NCR_D700.o
 obj-$(CONFIG_SCSI_NCR_Q720)	+= NCR_Q720_mod.o
 obj-$(CONFIG_SCSI_SYM53C416)	+= sym53c416.o
 obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicfas.o
@@ -115,7 +115,7 @@
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 obj-$(CONFIG_SCSI_FCAL)		+= fcal.o
 obj-$(CONFIG_SCSI_CPQFCTS)	+= cpqfc.o
-obj-$(CONFIG_SCSI_LASI700)	+= lasi700.o 53c700.o
+obj-$(CONFIG_SCSI_LASI700)	+= 53c700.o lasi700.o
 obj-$(CONFIG_SCSI_NSP32)	+= nsp32.o
 obj-$(CONFIG_SCSI_SATA_SVW)	+= libata.o sata_svw.o
 obj-$(CONFIG_SCSI_ATA_PIIX)	+= libata.o ata_piix.o

