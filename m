From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] use generic dma direction bits in scsi
Date: Thu, 26 Jun 2003 09:49:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030626074922.GA27638@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:24255 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265449AbTFZHfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2003 03:35:13 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Make the *_data_direction flags of type enum dma_data_direction from
the generic dma mapping API.  The SCSI_DATA_* defines are kept for
compatiblity and map to the dma mapping API values now.
scsi_to_pci_dma_dir and scsi_to_sbus_dma_dir are kept as stubs -
we define them to nothing as both the PCI and SBUS constants have
the same values as the generic dma mapping ones.  Unfortunately
we can't check anymore whether someone messes this up as the values
are enumes now and not cpp defines.


diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Wed Jun 25 11:47:15 2003
+++ b/drivers/scsi/scsi.c	Wed Jun 25 11:47:15 2003
@@ -139,7 +139,7 @@
 		sreq->sr_device = sdev;
 		sreq->sr_host = sdev->host;
 		sreq->sr_magic = SCSI_REQ_MAGIC;
-		sreq->sr_data_direction = SCSI_DATA_UNKNOWN;
+		sreq->sr_data_direction = DMA_BIDIRECTIONAL;
 	}
 
 	return sreq;
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Wed Jun 25 11:47:15 2003
+++ b/drivers/scsi/scsi.h	Wed Jun 25 11:47:15 2003
@@ -25,54 +25,6 @@
 #include <scsi/scsi.h>
 
 /*
- * These are the values that the SCpnt->sc_data_direction and 
- * SRpnt->sr_data_direction can take.  These need to be set
- * The SCSI_DATA_UNKNOWN value is essentially the default.
- * In the event that the command creator didn't bother to
- * set a value, you will see SCSI_DATA_UNKNOWN.
- */
-#define SCSI_DATA_UNKNOWN       0
-#define SCSI_DATA_WRITE         1
-#define SCSI_DATA_READ          2
-#define SCSI_DATA_NONE          3
-
-#ifdef CONFIG_PCI
-#include <linux/pci.h>
-#if ((SCSI_DATA_UNKNOWN == PCI_DMA_BIDIRECTIONAL) && (SCSI_DATA_WRITE == PCI_DMA_TODEVICE) && (SCSI_DATA_READ == PCI_DMA_FROMDEVICE) && (SCSI_DATA_NONE == PCI_DMA_NONE))
-#define scsi_to_pci_dma_dir(scsi_dir)	((int)(scsi_dir))
-#else
-extern __inline__ int scsi_to_pci_dma_dir(unsigned char scsi_dir)
-{
-        if (scsi_dir == SCSI_DATA_UNKNOWN)
-                return PCI_DMA_BIDIRECTIONAL;
-        if (scsi_dir == SCSI_DATA_WRITE)
-                return PCI_DMA_TODEVICE;
-        if (scsi_dir == SCSI_DATA_READ)
-                return PCI_DMA_FROMDEVICE;
-        return PCI_DMA_NONE;
-}
-#endif
-#endif
-
-#if defined(CONFIG_SBUS) && !defined(CONFIG_SUN3) && !defined(CONFIG_SUN3X)
-#include <asm/sbus.h>
-#if ((SCSI_DATA_UNKNOWN == SBUS_DMA_BIDIRECTIONAL) && (SCSI_DATA_WRITE == SBUS_DMA_TODEVICE) && (SCSI_DATA_READ == SBUS_DMA_FROMDEVICE) && (SCSI_DATA_NONE == SBUS_DMA_NONE))
-#define scsi_to_sbus_dma_dir(scsi_dir)	((int)(scsi_dir))
-#else
-extern __inline__ int scsi_to_sbus_dma_dir(unsigned char scsi_dir)
-{
-        if (scsi_dir == SCSI_DATA_UNKNOWN)
-                return SBUS_DMA_BIDIRECTIONAL;
-        if (scsi_dir == SCSI_DATA_WRITE)
-                return SBUS_DMA_TODEVICE;
-        if (scsi_dir == SCSI_DATA_READ)
-                return SBUS_DMA_FROMDEVICE;
-        return SBUS_DMA_NONE;
-}
-#endif
-#endif
-
-/*
  * Some defs, in case these are not defined elsewhere.
  */
 #ifndef TRUE
@@ -226,6 +178,21 @@
 					    struct device_attribute *attr);
 extern int scsi_sysfs_modify_shost_attribute(struct class_device_attribute ***class_attrs,
 					     struct class_device_attribute *attr);
+
+/*
+ * Legacy dma direction interfaces.
+ *
+ * This assumes the pci/sbus dma mapping flags have the same numercial
+ * values as the generic dma-mapping ones.  Currently they have but there's
+ * no way to check.  Better don't use these interfaces!
+ */
+#define SCSI_DATA_UNKNOWN	(DMA_BIDIRECTIONAL)
+#define SCSI_DATA_WRITE		(DMA_TO_DEVICE)
+#define SCSI_DATA_READ		(DMA_FROM_DEVICE)
+#define SCSI_DATA_NONE		(DMA_NONE)
+
+#define scsi_to_pci_dma_dir(scsi_dir)	((int)(scsi_dir))
+#define scsi_to_sbus_dma_dir(scsi_dir)	((int)(scsi_dir))
 
 /*
  * This is the crap from the old error handling code.  We have it in a special
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Wed Jun 25 11:47:15 2003
+++ b/drivers/scsi/scsi_error.c	Wed Jun 25 11:47:15 2003
@@ -562,7 +562,7 @@
 	scmd->request_bufflen = 254;
 	scmd->use_sg = 0;
 	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
-	scmd->sc_data_direction = SCSI_DATA_READ;
+	scmd->sc_data_direction = DMA_FROM_DEVICE;
 	scmd->underflow = 0;
 
 	rtn = scsi_send_eh_cmnd(scmd, SENSE_TIMEOUT);
@@ -742,7 +742,7 @@
 	scmd->use_sg = 0;
 	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 	scmd->underflow = 0;
-	scmd->sc_data_direction = SCSI_DATA_NONE;
+	scmd->sc_data_direction = DMA_NONE;
 
 	rtn = scsi_send_eh_cmnd(scmd, SENSE_TIMEOUT);
 
@@ -1348,7 +1348,7 @@
 	sreq->sr_cmnd[3] = 0;
 	sreq->sr_cmnd[4] = SCSI_REMOVAL_PREVENT;
 	sreq->sr_cmnd[5] = 0;
-	sreq->sr_data_direction = SCSI_DATA_NONE;
+	sreq->sr_data_direction = DMA_NONE;
 	sreq->sr_bufflen = 0;
 	sreq->sr_buffer = NULL;
 	sreq->sr_allowed = 5;
@@ -1723,7 +1723,7 @@
 
 	scmd->cmd_len			= 0;
 
-	scmd->sc_data_direction	= SCSI_DATA_UNKNOWN;
+	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
 	scmd->sc_request		= NULL;
 	scmd->sc_magic			= SCSI_CMND_MAGIC;
 
diff -Nru a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c	Wed Jun 25 11:47:15 2003
+++ b/drivers/scsi/scsi_ioctl.c	Wed Jun 25 11:47:15 2003
@@ -104,7 +104,7 @@
 		return -ENOMEM;
 	}
 
-	sreq->sr_data_direction = SCSI_DATA_NONE;
+	sreq->sr_data_direction = DMA_NONE;
         scsi_wait_req(sreq, cmd, NULL, 0, timeout, retries);
 
 	SCSI_LOG_IOCTL(2, printk("Ioctl returned  0x%x\n", sreq->sr_result));
@@ -258,19 +258,19 @@
 			return -ENOMEM;
 		memset(buf, 0, buf_needed);
 		if (inlen == 0) {
-			data_direction = SCSI_DATA_READ;
+			data_direction = DMA_FROM_DEVICE;
 		} else if (outlen == 0 ) {
-			data_direction = SCSI_DATA_WRITE;
+			data_direction = DMA_TO_DEVICE;
 		} else {
 			/*
 			 * Can this ever happen?
 			 */
-			data_direction = SCSI_DATA_UNKNOWN;
+			data_direction = DMA_BIDIRECTIONAL;
 		}
 
 	} else {
 		buf = NULL;
-		data_direction = SCSI_DATA_NONE;
+		data_direction = DMA_NONE;
 	}
 
 	/*
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Wed Jun 25 11:47:15 2003
+++ b/drivers/scsi/scsi_scan.c	Wed Jun 25 11:47:15 2003
@@ -117,7 +117,7 @@
 	scsi_cmd[4] = 0x2a;	/* size */
 	scsi_cmd[5] = 0;
 	sreq->sr_cmd_len = 0;
-	sreq->sr_data_direction = SCSI_DATA_READ;
+	sreq->sr_data_direction = DMA_FROM_DEVICE;
 	scsi_wait_req(sreq, scsi_cmd, result, 0x2a /* size */, SCSI_TIMEOUT, 3);
 }
 
@@ -334,7 +334,7 @@
 	scsi_cmd[0] = INQUIRY;
 	scsi_cmd[4] = 36;	/* issue conservative alloc_length */
 	sreq->sr_cmd_len = 0;
-	sreq->sr_data_direction = SCSI_DATA_READ;
+	sreq->sr_data_direction = DMA_FROM_DEVICE;
 
 	memset(inq_result, 0, 36);
 	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) inq_result, 36,
@@ -380,7 +380,7 @@
 		scsi_cmd[0] = INQUIRY;
 		scsi_cmd[4] = (unsigned char) possible_inq_resp_len;
 		sreq->sr_cmd_len = 0;
-		sreq->sr_data_direction = SCSI_DATA_READ;
+		sreq->sr_data_direction = DMA_FROM_DEVICE;
 		/*
 		 * re-zero inq_result just to be safe.
 		 */
@@ -936,7 +936,7 @@
 	scsi_cmd[10] = 0;	/* reserved */
 	scsi_cmd[11] = 0;	/* control */
 	sreq->sr_cmd_len = 0;
-	sreq->sr_data_direction = SCSI_DATA_READ;
+	sreq->sr_data_direction = DMA_FROM_DEVICE;
 
 	/*
 	 * We can get a UNIT ATTENTION, for example a power on/reset, so
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Wed Jun 25 11:47:15 2003
+++ b/drivers/scsi/sd.c	Wed Jun 25 11:47:15 2003
@@ -163,11 +163,11 @@
 
 		memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
 		if (rq_data_dir(rq) == WRITE)
-			SCpnt->sc_data_direction = SCSI_DATA_WRITE;
+			SCpnt->sc_data_direction = DMA_TO_DEVICE;
 		else if (rq->data_len)
-			SCpnt->sc_data_direction = SCSI_DATA_READ;
+			SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 		else
-			SCpnt->sc_data_direction = SCSI_DATA_NONE;
+			SCpnt->sc_data_direction = DMA_NONE;
 
 		this_count = rq->data_len;
 		if (rq->timeout)
@@ -253,10 +253,10 @@
 			return 0;
 		}
 		SCpnt->cmnd[0] = WRITE_6;
-		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
+		SCpnt->sc_data_direction = DMA_TO_DEVICE;
 	} else if (rq_data_dir(SCpnt->request) == READ) {
 		SCpnt->cmnd[0] = READ_6;
-		SCpnt->sc_data_direction = SCSI_DATA_READ;
+		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
 		printk(KERN_ERR "sd: Unknown command %lx\n", 
 		       SCpnt->request->flags);
@@ -792,7 +792,7 @@
 			SRpnt->sr_cmd_len = 0;
 			SRpnt->sr_sense_buffer[0] = 0;
 			SRpnt->sr_sense_buffer[2] = 0;
-			SRpnt->sr_data_direction = SCSI_DATA_NONE;
+			SRpnt->sr_data_direction = DMA_NONE;
 
 			scsi_wait_req (SRpnt, (void *) cmd, (void *) buffer,
 				       0/*512*/, SD_TIMEOUT, SD_MAX_RETRIES);
@@ -852,7 +852,7 @@
 				SRpnt->sr_sense_buffer[0] = 0;
 				SRpnt->sr_sense_buffer[2] = 0;
 
-				SRpnt->sr_data_direction = SCSI_DATA_NONE;
+				SRpnt->sr_data_direction = DMA_NONE;
 				scsi_wait_req(SRpnt, (void *)cmd, 
 					      (void *) buffer, 0/*512*/, 
 					      SD_TIMEOUT, SD_MAX_RETRIES);
@@ -917,7 +917,7 @@
 		SRpnt->sr_cmd_len = 0;
 		SRpnt->sr_sense_buffer[0] = 0;
 		SRpnt->sr_sense_buffer[2] = 0;
-		SRpnt->sr_data_direction = SCSI_DATA_READ;
+		SRpnt->sr_data_direction = DMA_FROM_DEVICE;
 
 		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
 			      longrc ? 12 : 8, SD_TIMEOUT, SD_MAX_RETRIES);
@@ -1090,7 +1090,7 @@
 	SRpnt->sr_cmd_len = 0;
 	SRpnt->sr_sense_buffer[0] = 0;
 	SRpnt->sr_sense_buffer[2] = 0;
-	SRpnt->sr_data_direction = SCSI_DATA_READ;
+	SRpnt->sr_data_direction = DMA_FROM_DEVICE;
 
 	memset((void *) buffer, 0, len);
 
@@ -1419,7 +1419,7 @@
 		return;
 	}
 
-	sreq->sr_data_direction = SCSI_DATA_NONE;
+	sreq->sr_data_direction = DMA_NONE;
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[10] = { 0 };
 
diff -Nru a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h	Wed Jun 25 11:47:15 2003
+++ b/include/scsi/scsi_cmnd.h	Wed Jun 25 11:47:15 2003
@@ -1,6 +1,7 @@
 #ifndef _SCSI_SCSI_CMND_H
 #define _SCSI_SCSI_CMND_H
 
+#include <linux/dma-mapping.h>
 #include <linux/list.h>
 #include <linux/types.h>
 
@@ -71,8 +72,8 @@
 
 	unsigned char cmd_len;
 	unsigned char old_cmd_len;
-	unsigned char sc_data_direction;
-	unsigned char sc_old_data_direction;
+	enum dma_data_direction sc_data_direction;
+	enum dma_data_direction sc_old_data_direction;
 
 	/* These elements define the operation we are about to perform */
 #define MAX_COMMAND_SIZE	16
diff -Nru a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
--- a/include/scsi/scsi_request.h	Wed Jun 25 11:47:15 2003
+++ b/include/scsi/scsi_request.h	Wed Jun 25 11:47:15 2003
@@ -32,7 +32,7 @@
 	unsigned sr_bufflen;	/* Size of data buffer */
 	void *sr_buffer;		/* Data buffer */
 	int sr_allowed;
-	unsigned char sr_data_direction;
+	enum dma_data_direction sr_data_direction;
 	unsigned char sr_cmd_len;
 	unsigned char sr_cmnd[MAX_COMMAND_SIZE];
 	void (*sr_done) (struct scsi_cmnd *);	/* Mid-level done function */
