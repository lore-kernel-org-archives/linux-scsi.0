From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] Add Domain Validation to the SPI transport class
Date: 12 Mar 2004 21:00:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079143228.1756.53.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:63911 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262977AbUCMCAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 21:00:32 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i2D20Ua12504
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2004 21:00:30 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Domain Validation is a fairly essential element to the SCSI Parallel
Interface (although if you look very few drivers actually do it).  The
premise is that the Parallel Bus, being a transmission line, might not
be correctly tuned to the transfers you want do perform.  DV probes the
parameters of the transport until it finds a setting that works (for the
interested, see http://www.t10.org/ftp/t10/drafts/sdv/sdv-r08b.pdf)

The current code employs rather simplistic DV heuristics, although those
can be improved over time.  The change in scsi_scan.c is so that DV may
be done easily from the slave_configure routine, which is the most
natural place to begin.

James

diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Fri Mar 12 19:53:58 2004
+++ b/drivers/scsi/scsi_scan.c	Fri Mar 12 19:53:58 2004
@@ -643,6 +643,10 @@
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
 
+	/* set the device running here so that slave configure
+	 * may do I/O */
+	scsi_device_set_state(sdev, SDEV_RUNNING);
+
 	if(sdev->host->hostt->slave_configure)
 		sdev->host->hostt->slave_configure(sdev);
 
diff -Nru a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c	Fri Mar 12 19:53:58 2004
+++ b/drivers/scsi/scsi_transport_spi.c	Fri Mar 12 19:53:58 2004
@@ -19,15 +19,30 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/mm.h>
+#include <linux/workqueue.h>
+#include <asm/scatterlist.h>
+#include <asm/io.h>
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_request.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
 
+#define SPI_PRINTK(x, l, f, a...)	printk(l "scsi(%d:%d:%d:%d): " f, (x)->host->host_no, (x)->channel, (x)->id, (x)->lun, ##a)
+
 static void transport_class_release(struct class_device *class_dev);
 
 #define SPI_NUM_ATTRS 10	/* increase this if you add attributes */
 
+#define SPI_MAX_ECHO_BUFFER_SIZE	4096
+
+#define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->transport_data)->dv_pending)
+
 struct spi_internal {
 	struct scsi_transport_template t;
 	struct spi_function_template *f;
@@ -88,6 +103,7 @@
 	spi_rd_strm(sdev) = 0;
 	spi_rti(sdev) = 0;
 	spi_pcomp_en(sdev) = 0;
+	spi_dv_pending(sdev) = 0;
 
 	return 0;
 }
@@ -107,7 +123,7 @@
 	struct spi_transport_attrs *tp;					\
 	struct spi_internal *i = to_spi_internal(sdev->host->transportt); \
 	tp = (struct spi_transport_attrs *)&sdev->transport_data;	\
-	if(i->f->get_##field)						\
+	if (i->f->get_##field)						\
 		i->f->get_##field(sdev);				\
 	return snprintf(buf, 20, format_string, tp->field);		\
 }
@@ -156,7 +172,7 @@
 
 	tp = (struct spi_transport_attrs *)&sdev->transport_data;
 
-	if(i->f->get_period)
+	if (i->f->get_period)
 		i->f->get_period(sdev);
 
 	switch(tp->period) {
@@ -185,7 +201,7 @@
 	struct spi_internal *i = to_spi_internal(sdev->host->transportt);
 	int j, period = -1;
 
-	for(j = 0; j < SPI_STATIC_PPR; j++) {
+	for (j = 0; j < SPI_STATIC_PPR; j++) {
 		int len;
 
 		if(ppr_to_ns[j] == NULL)
@@ -203,7 +219,7 @@
 		break;
 	}
 
-	if(period == -1) {
+	if (period == -1) {
 		int val = simple_strtoul(buf, NULL, 0);
 

@@ -212,7 +228,7 @@
 		period = val/4;
 	}
 
-	if(period > 0xff)
+	if (period > 0xff)
 		period = 0xff;
 
 	i->f->set_period(sdev, period);
@@ -224,14 +240,381 @@
 			 show_spi_transport_period,
 			 store_spi_transport_period);
 
+#define DV_SET(x, y)			\
+	if(i->f->set_##x)		\
+		i->f->set_##x(sdev, y)
+
+#define DV_LOOPS	3
+#define DV_TIMEOUT	(10*HZ)
+#define DV_RETRIES	5
+
+
+/* This is for read/write Domain Validation:  If the device supports
+ * an echo buffer, we do read/write tests to it */
+static int
+spi_dv_device_echo_buffer(struct scsi_request *sreq, u8 *buffer,
+			  u8 *ptr, const int retries)
+{
+	struct scsi_device *sdev = sreq->sr_device;
+	int len = ptr - buffer;
+	int j, k, r;
+	unsigned int pattern = 0x0000ffff;
+
+	const char spi_write_buffer[] = {
+		WRITE_BUFFER, 0x0a, 0, 0, 0, 0, 0, len >> 8, len & 0xff, 0
+	};
+	const char spi_read_buffer[] = {
+		READ_BUFFER, 0x0a, 0, 0, 0, 0, 0, len >> 8, len & 0xff, 0
+	};
+
+	/* set up the pattern buffer.  Doesn't matter if we spill
+	 * slightly beyond since that's where the read buffer is */
+	for (j = 0; j < len; ) {
+
+		/* fill the buffer with counting (test a) */
+		for ( ; j < min(len, 32); j++)
+			buffer[j] = j;
+		k = j;
+		/* fill the buffer with alternating words of 0x0 and
+		 * 0xffff (test b) */
+		for ( ; j < min(len, k + 32); j += 2) {
+			u16 *word = (u16 *)&buffer[j];
+			
+			*word = (j & 0x02) ? 0x0000 : 0xffff;
+		}
+		k = j;
+		/* fill with crosstalk (alternating 0x5555 0xaaa)
+                 * (test c) */
+		for ( ; j < min(len, k + 32); j += 2) {
+			u16 *word = (u16 *)&buffer[j];
+
+			*word = (j & 0x02) ? 0x5555 : 0xaaaa;
+		}
+		k = j;
+		/* fill with shifting bits (test d) */
+		for ( ; j < min(len, k + 32); j += 4) {
+			u32 *word = (unsigned int *)&buffer[j];
+			u32 roll = (pattern & 0x80000000) ? 1 : 0;
+			
+			*word = pattern;
+			pattern = (pattern << 1) | roll;
+		}
+		/* don't bother with random data (test e) */
+	}
+
+	for (r = 0; r < retries; r++) {
+		sreq->sr_cmd_len = 0;	/* wait_req to fill in */
+		sreq->sr_data_direction = DMA_TO_DEVICE;
+		scsi_wait_req(sreq, spi_write_buffer, buffer, len,
+			      DV_TIMEOUT, DV_RETRIES);
+		if(sreq->sr_result) {
+			SPI_PRINTK(sdev, KERN_ERR, "Write Buffer failure %x\n", sreq->sr_result);
+			return 0;
+		}
+
+		memset(ptr, 0, len);
+		sreq->sr_cmd_len = 0;	/* wait_req to fill in */
+		sreq->sr_data_direction = DMA_FROM_DEVICE;
+		scsi_wait_req(sreq, spi_read_buffer, ptr, len,
+			      DV_TIMEOUT, DV_RETRIES);
+
+		if (memcmp(buffer, ptr, len) != 0)
+			return 0;
+	}
+	return 1;
+}
+
+/* This is for the simplest form of Domain Validation: a read test
+ * on the inquiry data from the device */
+static int
+spi_dv_device_compare_inquiry(struct scsi_request *sreq, u8 *buffer,
+			      u8 *ptr, const int retries)
+{
+	int r;
+	const int len = sreq->sr_device->inquiry_len;
+	const char spi_inquiry[] = {
+		INQUIRY, 0, 0, 0, len, 0
+	};
+
+	for (r = 0; r < retries; r++) {
+		sreq->sr_cmd_len = 0;	/* wait_req to fill in */
+		sreq->sr_data_direction = DMA_FROM_DEVICE;
+
+		memset(ptr, 0, len);
+
+		scsi_wait_req(sreq, spi_inquiry, ptr, len,
+			      DV_TIMEOUT, DV_RETRIES);
+
+		/* If we don't have the inquiry data already, the
+		 * first read gets it */
+		if (ptr == buffer) {
+			ptr += len;
+			--r;
+			continue;
+		}
+
+		if (memcmp(buffer, ptr, len) != 0)
+			/* failure */
+			return 0;
+	}
+	return 1;
+}
+
+static int
+spi_dv_retrain(struct scsi_request *sreq, u8 *buffer, u8 *ptr,
+	       int (*compare_fn)(struct scsi_request *, u8 *, u8 *, int))
+{
+	struct spi_internal *i = to_spi_internal(sreq->sr_host->transportt);
+	struct scsi_device *sdev = sreq->sr_device;
+	int period, prevperiod = 0; 
+
+
+	for (;;) {
+		if (compare_fn(sreq, buffer, ptr, DV_LOOPS))
+			/* Successful DV */
+			break;
+
+		/* OK, retrain, fallback */
+		if (i->f->get_period)
+			i->f->get_period(sdev);
+		period = spi_period(sdev);
+		if (period < 0x0d)
+			period++;
+		else
+			period += period >> 1;
+
+		if (unlikely(period > 0xff || period == prevperiod)) {
+			/* Total failure; set to async and return */
+			SPI_PRINTK(sdev, KERN_ERR, "Domain Validation Failure, dropping back to Asynchronous\n");
+			DV_SET(offset, 0);
+			return 0;
+		}
+		SPI_PRINTK(sdev, KERN_ERR, "Domain Validation detected failure, dropping back\n");
+		DV_SET(period, period);
+		prevperiod = period;
+	}
+	return 1;
+}
+
+static int
+spi_dv_device_get_echo_buffer(struct scsi_request *sreq, u8 *buffer)
+{
+	int l;
+
+	/* first off do a test unit ready.  This can error out 
+	 * because of reservations or some other reason.  If it
+	 * fails, the device won't let us write to the echo buffer
+	 * so just return failure */
+	
+	const char spi_test_unit_ready[] = {
+		TEST_UNIT_READY, 0, 0, 0, 0, 0
+	};
+
+	const char spi_read_buffer_descriptor[] = {
+		READ_BUFFER, 0x0b, 0, 0, 0, 0, 0, 0, 4, 0
+	};
+
+	
+	sreq->sr_cmd_len = 0;
+	sreq->sr_data_direction = DMA_NONE;
+
+	/* We send a set of three TURs to clear any outstanding 
+	 * unit attention conditions if they exist (Otherwise the
+	 * buffer tests won't be happy).  If the TUR still fails
+	 * (reservation conflict, device not ready, etc) just
+	 * skip the write tests */
+	for (l = 0; ; l++) {
+		scsi_wait_req(sreq, spi_test_unit_ready, NULL, 0,
+			      DV_TIMEOUT, DV_RETRIES);
+
+		if(sreq->sr_result) {
+			if(l >= 3)
+				return 0;
+		} else {
+			/* TUR succeeded */
+			break;
+		}
+	}
+
+	sreq->sr_cmd_len = 0;
+	sreq->sr_data_direction = DMA_FROM_DEVICE;
+
+	scsi_wait_req(sreq, spi_read_buffer_descriptor, buffer, 4,
+		      DV_TIMEOUT, DV_RETRIES);
+
+	if (sreq->sr_result)
+		/* Device has no echo buffer */
+		return 0;
+
+	return buffer[3] + ((buffer[2] & 0x1f) << 8);
+}
+
+static void
+spi_dv_device_internal(struct scsi_request *sreq, u8 *buffer)
+{
+	struct spi_internal *i = to_spi_internal(sreq->sr_host->transportt);
+	struct scsi_device *sdev = sreq->sr_device;
+	int len = sdev->inquiry_len;
+	/* first set us up for narrow async */
+	DV_SET(offset, 0);
+	DV_SET(width, 0);
+	
+	if (!spi_dv_device_compare_inquiry(sreq, buffer, buffer, DV_LOOPS)) {
+		SPI_PRINTK(sdev, KERN_ERR, "Domain Validation Initial Inquiry Failed\n");
+		/* FIXME: should probably offline the device here? */
+		return;
+	}
+
+	/* test width */
+	if (i->f->set_width) {
+		i->f->set_width(sdev, 1);
+
+		if (!spi_dv_device_compare_inquiry(sreq, buffer,
+						   buffer + len,
+						   DV_LOOPS)) {
+			SPI_PRINTK(sdev, KERN_ERR, "Wide Transfers Fail\n");
+			i->f->set_width(sdev, 0);
+		}
+	}
+
+	if (!i->f->set_period)
+		return;
+
+	/* now set up to the maximum */
+	DV_SET(offset, 255);
+	DV_SET(period, 1);
+	if (!spi_dv_retrain(sreq, buffer, buffer + len,
+			    spi_dv_device_compare_inquiry))
+		return;
+
+	/* OK, now we have our initial speed set by the read only inquiry
+	 * test, now try an echo buffer test (if the device allows it) */
+
+	if ((len = spi_dv_device_get_echo_buffer(sreq, buffer)) == 0) {
+		SPI_PRINTK(sdev, KERN_INFO, "Domain Validation skipping write tests\n");
+		return;
+	}
+	if (len > SPI_MAX_ECHO_BUFFER_SIZE) {
+		SPI_PRINTK(sdev, KERN_WARNING, "Echo buffer size %d is too big, trimming to %d\n", len, SPI_MAX_ECHO_BUFFER_SIZE);
+		len = SPI_MAX_ECHO_BUFFER_SIZE;
+	}
+
+	spi_dv_retrain(sreq, buffer, buffer + len,
+		       spi_dv_device_echo_buffer);
+}
+
+
+/**	spi_dv_device - Do Domain Validation on the device
+ *	@sdev:		scsi device to validate
+ *
+ *	Performs the domain validation on the given device in the
+ *	current execution thread.  Since DV operations may sleep,
+ *	the current thread must have user context.  Also no SCSI
+ *	related locks that would deadlock I/O issued by the DV may
+ *	be held.
+ */
+void
+spi_dv_device(struct scsi_device *sdev)
+{
+	struct scsi_request *sreq = scsi_allocate_request(sdev, GFP_KERNEL);
+	u8 *buffer;
+	const int len = SPI_MAX_ECHO_BUFFER_SIZE*2;
+
+	if (unlikely(!sreq))
+		return;
+
+	if (unlikely(scsi_device_get(sdev)))
+		goto out_free_req;
+
+	buffer = kmalloc(len, GFP_KERNEL);
+
+	if (unlikely(!buffer))
+		goto out_put;
+
+	memset(buffer, 0, len);
+
+	if (unlikely(scsi_device_quiesce(sdev)))
+		goto out_free;
+
+	SPI_PRINTK(sdev, KERN_INFO, "Beginning Domain Validation\n");
+
+	spi_dv_device_internal(sreq, buffer);
+
+	SPI_PRINTK(sdev, KERN_INFO, "Ending Domain Validation\n");
+
+	scsi_device_resume(sdev);
+
+ out_free:
+	kfree(buffer);
+ out_put:
+	scsi_device_put(sdev);
+ out_free_req:
+	scsi_release_request(sreq);
+}
+EXPORT_SYMBOL(spi_dv_device);
+
+struct work_queue_wrapper {
+	struct work_struct	work;
+	struct scsi_device	*sdev;
+};
+
+static void
+spi_dv_device_work_wrapper(void *data)
+{
+	struct work_queue_wrapper *wqw = (struct work_queue_wrapper *)data;
+	struct scsi_device *sdev = wqw->sdev;
+
+	kfree(wqw);
+	spi_dv_device(sdev);
+	spi_dv_pending(sdev) = 0;
+	scsi_device_put(sdev);
+}
+
+
+/**
+ *	spi_schedule_dv_device - schedule domain validation to occur on the device
+ *	@sdev:	The device to validate
+ *
+ *	Identical to spi_dv_device() above, except that the DV will be
+ *	scheduled to occur in a workqueue later.  All memory allocations
+ *	are atomic, so may be called from any context including those holding
+ *	SCSI locks.
+ */
+void
+spi_schedule_dv_device(struct scsi_device *sdev)
+{
+	struct work_queue_wrapper *wqw =
+		kmalloc(sizeof(struct work_queue_wrapper), GFP_ATOMIC);
+
+	if (unlikely(!wqw))
+		return;
+
+	if (unlikely(spi_dv_pending(sdev))) {
+		kfree(wqw);
+		return;
+	}
+
+	if (unlikely(scsi_device_get(sdev))) {
+		kfree(wqw);
+		spi_dv_pending(sdev) = 0;
+		return;
+	}
+
+	INIT_WORK(&wqw->work, spi_dv_device_work_wrapper, wqw);
+	wqw->sdev = sdev;
+
+	schedule_work(&wqw->work);
+}
+EXPORT_SYMBOL(spi_schedule_dv_device);
+
 #define SETUP_ATTRIBUTE(field)						\
 	i->private_attrs[count] = class_device_attr_##field;		\
-	if(!i->f->set_##field) {					\
+	if (!i->f->set_##field) {					\
 		i->private_attrs[count].attr.mode = S_IRUGO;		\
 		i->private_attrs[count].store = NULL;			\
 	}								\
 	i->attrs[count] = &i->private_attrs[count];			\
-	if(i->f->show_##field)						\
+	if (i->f->show_##field)						\
 		count++
 
 struct scsi_transport_template *
@@ -240,7 +623,7 @@
 	struct spi_internal *i = kmalloc(sizeof(struct spi_internal),
 					 GFP_KERNEL);
 	int count = 0;
-	if(!i)
+	if (unlikely(!i))
 		return NULL;
 
 	memset(i, 0, sizeof(struct spi_internal));
diff -Nru a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
--- a/include/scsi/scsi_transport_spi.h	Fri Mar 12 19:53:58 2004
+++ b/include/scsi/scsi_transport_spi.h	Fri Mar 12 19:53:58 2004
@@ -35,6 +35,7 @@
 	unsigned int rd_strm:1;	/* Read streaming enabled */
 	unsigned int rti:1;	/* Retain Training Information */
 	unsigned int pcomp_en:1;/* Precompensation enabled */
+	unsigned int dv_pending:1; /* Internal flag */
 };
 
 /* accessor functions */
@@ -89,5 +90,7 @@
 
 struct scsi_transport_template *spi_attach_transport(struct spi_function_template *);
 void spi_release_transport(struct scsi_transport_template *);
+void spi_schedule_dv_device(struct scsi_device *);
+void spi_dv_device(struct scsi_device *);
 
 #endif /* SCSI_TRANSPORT_SPI_H */



