From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] More domain validation fixes and additions
Date: 21 Mar 2004 10:46:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079883982.2205.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:29106 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263666AbUCUPq0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Mar 2004 10:46:26 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i2LFkPa18685
	for <linux-scsi@vger.kernel.org>; Sun, 21 Mar 2004 10:46:25 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Following testing in more extreme situations, the following problems
turned up:

- The error handler can offline the device during DV (most particularly
true when transport parameters are undetectably mismatched).  Fixed by
modifying the state model to allow this and then having DV set the
device back online for the retry.

- DV needs to be serialised.  Fixed by introducing a per device
semaphore.

- Cosmetically, it's nice to trigger DV from userland, so added a
revalidate sysfs entry.

James

===== drivers/scsi/scsi_lib.c 1.124 vs edited =====
--- 1.124/drivers/scsi/scsi_lib.c	Tue Mar 16 11:02:00 2004
+++ edited/drivers/scsi/scsi_lib.c	Thu Mar 18 17:30:19 2004
@@ -1590,6 +1590,7 @@
 	case SDEV_QUIESCE:
 		switch (oldstate) {
 		case SDEV_RUNNING:
+		case SDEV_OFFLINE:
 			break;
 		default:
 			goto illegal;
@@ -1600,6 +1601,7 @@
 		switch (oldstate) {
 		case SDEV_CREATED:
 		case SDEV_RUNNING:
+		case SDEV_QUIESCE:
 			break;
 		default:
 			goto illegal;
===== drivers/scsi/scsi_transport_spi.c 1.5 vs edited =====
--- 1.5/drivers/scsi/scsi_transport_spi.c	Sat Mar 13 10:35:03 2004
+++ edited/drivers/scsi/scsi_transport_spi.c	Thu Mar 18 17:38:32 2004
@@ -38,10 +38,14 @@
 static void transport_class_release(struct class_device *class_dev);
 
 #define SPI_NUM_ATTRS 10	/* increase this if you add attributes */
+#define SPI_OTHER_ATTRS 1	/* Increase this if you add "always
+				 * on" attributes */
 
 #define SPI_MAX_ECHO_BUFFER_SIZE	4096
 
+/* Private data accessors (keep these out of the header file) */
 #define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->transport_data)->dv_pending)
+#define spi_dv_sem(x) (((struct spi_transport_attrs *)&(x)->transport_data)->dv_sem)
 
 struct spi_internal {
 	struct scsi_transport_template t;
@@ -50,7 +54,7 @@
 	struct class_device_attribute private_attrs[SPI_NUM_ATTRS];
 	/* The array of null terminated pointers to attributes 
 	 * needed by scsi_sysfs.c */
-	struct class_device_attribute *attrs[SPI_NUM_ATTRS + 1];
+	struct class_device_attribute *attrs[SPI_NUM_ATTRS + SPI_OTHER_ATTRS + 1];
 };
 
 #define to_spi_internal(tmpl)	container_of(tmpl, struct spi_internal, t)
@@ -104,6 +108,7 @@
 	spi_rti(sdev) = 0;
 	spi_pcomp_en(sdev) = 0;
 	spi_dv_pending(sdev) = 0;
+	init_MUTEX(&spi_dv_sem(sdev));
 
 	return 0;
 }
@@ -160,6 +165,16 @@
 spi_transport_rd_attr(rti, "%d\n");
 spi_transport_rd_attr(pcomp_en, "%d\n");
 
+static ssize_t
+store_spi_revalidate(struct class_device *cdev, const char *buf, size_t count)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);
+
+	spi_dv_device(sdev);
+	return count;
+}
+static CLASS_DEVICE_ATTR(revalidate, S_IWUSR, NULL, store_spi_revalidate)
+
 /* Translate the period into ns according to the current spec
  * for SDTR/PPR messages */
 static ssize_t show_spi_transport_period(struct class_device *cdev, char *buf)
@@ -246,7 +261,8 @@
 
 #define DV_LOOPS	3
 #define DV_TIMEOUT	(10*HZ)
-#define DV_RETRIES	5
+#define DV_RETRIES	3	/* should only need at most 
+				 * two cc/ua clears */
 

 /* This is for read/write Domain Validation:  If the device supports
@@ -307,7 +323,8 @@
 		sreq->sr_data_direction = DMA_TO_DEVICE;
 		scsi_wait_req(sreq, spi_write_buffer, buffer, len,
 			      DV_TIMEOUT, DV_RETRIES);
-		if(sreq->sr_result) {
+		if(sreq->sr_result || !scsi_device_online(sdev)) {
+			scsi_device_set_state(sdev, SDEV_QUIESCE);
 			SPI_PRINTK(sdev, KERN_ERR, "Write Buffer failure %x\n", sreq->sr_result);
 			return 0;
 		}
@@ -317,6 +334,7 @@
 		sreq->sr_data_direction = DMA_FROM_DEVICE;
 		scsi_wait_req(sreq, spi_read_buffer, ptr, len,
 			      DV_TIMEOUT, DV_RETRIES);
+		scsi_device_set_state(sdev, SDEV_QUIESCE);
 
 		if (memcmp(buffer, ptr, len) != 0)
 			return 0;
@@ -332,6 +350,7 @@
 {
 	int r;
 	const int len = sreq->sr_device->inquiry_len;
+	struct scsi_device *sdev = sreq->sr_device;
 	const char spi_inquiry[] = {
 		INQUIRY, 0, 0, 0, len, 0
 	};
@@ -344,6 +363,11 @@
 
 		scsi_wait_req(sreq, spi_inquiry, ptr, len,
 			      DV_TIMEOUT, DV_RETRIES);
+		
+		if(sreq->sr_result || !scsi_device_online(sdev)) {
+			scsi_device_set_state(sdev, SDEV_QUIESCE);
+			return 0;
+		}
 
 		/* If we don't have the inquiry data already, the
 		 * first read gets it */
@@ -536,12 +560,18 @@
 	if (unlikely(scsi_device_quiesce(sdev)))
 		goto out_free;
 
+	spi_dv_pending(sdev) = 1;
+	down(&spi_dv_sem(sdev));
+
 	SPI_PRINTK(sdev, KERN_INFO, "Beginning Domain Validation\n");
 
 	spi_dv_device_internal(sreq, buffer);
 
 	SPI_PRINTK(sdev, KERN_INFO, "Ending Domain Validation\n");
 
+	up(&spi_dv_sem(sdev));
+	spi_dv_pending(sdev) = 0;
+
 	scsi_device_resume(sdev);
 
  out_free:
@@ -593,7 +623,8 @@
 		kfree(wqw);
 		return;
 	}
-
+	/* Set pending early (dv_device doesn't check it, only sets it) */
+	spi_dv_pending(sdev) = 1;
 	if (unlikely(scsi_device_get(sdev))) {
 		kfree(wqw);
 		spi_dv_pending(sdev) = 0;
@@ -649,6 +680,8 @@
 	/* if you add an attribute but forget to increase SPI_NUM_ATTRS
 	 * this bug will trigger */
 	BUG_ON(count > SPI_NUM_ATTRS);
+
+	i->attrs[count++] = &class_device_attr_revalidate;
 
 	i->attrs[count] = NULL;
 
===== include/scsi/scsi_transport_spi.h 1.5 vs edited =====
--- 1.5/include/scsi/scsi_transport_spi.h	Sat Mar 13 10:35:02 2004
+++ edited/include/scsi/scsi_transport_spi.h	Thu Mar 18 15:00:04 2004
@@ -35,7 +35,9 @@
 	unsigned int rd_strm:1;	/* Read streaming enabled */
 	unsigned int rti:1;	/* Retain Training Information */
 	unsigned int pcomp_en:1;/* Precompensation enabled */
+	/* Private Fields */
 	unsigned int dv_pending:1; /* Internal flag */
+	struct semaphore dv_sem; /* semaphore to serialise dv */
 };
 
 /* accessor functions */

