From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] implement the SPI transport attributes as target instead of
	device ones
Date: 07 Sep 2004 13:29:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094578174.2069.124.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:38048 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268322AbUIGR3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 13:29:40 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i87HTXJ15516
	for <linux-scsi@vger.kernel.org>; Tue, 7 Sep 2004 13:29:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This simply lifts them up from device to target.  I've tested the
implementation with a multi-lun array and it seems to work fine.

Note that for this I needed a target quiesce in addition to the device
quiesce.  The implementation turns out to be quite simple...

I've also converted all of the consumers of the SPI transport over to
this interface.

One of the things I now don't like is that using transport_class as the
struct name in scsi_device, scsi_target and scsi_host just lost me type
safety in the spi_...(x) macros.  I'll fix this one up later.

James


===== drivers/scsi/53c700.c 1.54 vs edited =====
--- 1.54/drivers/scsi/53c700.c	2004-07-26 16:21:16 -05:00
+++ edited/drivers/scsi/53c700.c	2004-09-07 11:13:32 -05:00
@@ -287,8 +287,9 @@
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
 
-	return NCR_700_offset_period_to_sxfer(hostdata, spi_offset(SDp),
-					      spi_period(SDp));
+	return NCR_700_offset_period_to_sxfer(hostdata,
+					      spi_offset(SDp->sdev_target),
+					      spi_period(SDp->sdev_target));
 }
 
 struct Scsi_Host *
@@ -803,7 +804,7 @@
 			}
 			
 			if(NCR_700_is_flag_set(SCp->device, NCR_700_DEV_PRINT_SYNC_NEGOTIATION)) {
-				if(spi_offset(SCp->device) != 0)
+				if(spi_offset(SCp->device->sdev_target) != 0)
 					printk(KERN_INFO "scsi%d: (%d:%d) Synchronous at offset %d, period %dns\n",
 					       host->host_no, pun, lun,
 					       offset, period*4);
@@ -813,8 +814,8 @@
 				NCR_700_clear_flag(SCp->device, NCR_700_DEV_PRINT_SYNC_NEGOTIATION);
 			}
 				
-			spi_offset(SCp->device) = offset;
-			spi_period(SCp->device) = period;
+			spi_offset(SCp->device->sdev_target) = offset;
+			spi_period(SCp->device->sdev_target) = period;
 			
 
 			NCR_700_set_flag(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC);
@@ -894,7 +895,8 @@
 	case A_REJECT_MSG:
 		if(SCp != NULL && NCR_700_is_flag_set(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION)) {
 			/* Rejected our sync negotiation attempt */
-			spi_period(SCp->device) = spi_offset(SCp->device) = 0;
+			spi_period(SCp->device->sdev_target) =
+				spi_offset(SCp->device->sdev_target) = 0;
 			NCR_700_set_flag(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC);
 			NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 		} else if(SCp != NULL && NCR_700_is_flag_set(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING)) {
@@ -1420,8 +1422,8 @@
 	   NCR_700_is_flag_clear(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC)) {
 		memcpy(&hostdata->msgout[count], NCR_700_SDTR_msg,
 		       sizeof(NCR_700_SDTR_msg));
-		hostdata->msgout[count+3] = spi_period(SCp->device);
-		hostdata->msgout[count+4] = spi_offset(SCp->device);
+		hostdata->msgout[count+3] = spi_period(SCp->device->sdev_target);
+		hostdata->msgout[count+4] = spi_offset(SCp->device->sdev_target);
 		count += sizeof(NCR_700_SDTR_msg);
 		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 	}
@@ -1999,10 +2001,11 @@
 }
 
 STATIC void
-NCR_700_set_period(struct scsi_device *SDp, int period)
+NCR_700_set_period(struct scsi_target *STp, int period)
 {
+	struct Scsi_Host *SHp = dev_to_shost(STp->dev.parent);
 	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+		(struct NCR_700_Host_Parameters *)SHp->hostdata[0];
 	
 	if(!hostdata->fast)
 		return;
@@ -2010,17 +2013,18 @@
 	if(period < hostdata->min_period)
 		period = hostdata->min_period;
 
-	spi_period(SDp) = period;
-	NCR_700_clear_flag(SDp, NCR_700_DEV_NEGOTIATED_SYNC);
-	NCR_700_clear_flag(SDp, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
-	NCR_700_set_flag(SDp, NCR_700_DEV_PRINT_SYNC_NEGOTIATION);
+	spi_period(STp) = period;
+	spi_flags(STp) &= ~(NCR_700_DEV_NEGOTIATED_SYNC |
+			    NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
+	spi_flags(STp) |= NCR_700_DEV_PRINT_SYNC_NEGOTIATION;
 }
 
 STATIC void
-NCR_700_set_offset(struct scsi_device *SDp, int offset)
+NCR_700_set_offset(struct scsi_target *STp, int offset)
 {
+	struct Scsi_Host *SHp = dev_to_shost(STp->dev.parent);
 	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+		(struct NCR_700_Host_Parameters *)SHp->hostdata[0];
 	int max_offset = hostdata->chip710
 		? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET;
 	
@@ -2031,14 +2035,14 @@
 		offset = max_offset;
 
 	/* if we're currently async, make sure the period is reasonable */
-	if(spi_offset(SDp) == 0 && (spi_period(SDp) < hostdata->min_period ||
-				    spi_period(SDp) > 0xff))
-		spi_period(SDp) = hostdata->min_period;
-
-	spi_offset(SDp) = offset;
-	NCR_700_clear_flag(SDp, NCR_700_DEV_NEGOTIATED_SYNC);
-	NCR_700_clear_flag(SDp, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
-	NCR_700_set_flag(SDp, NCR_700_DEV_PRINT_SYNC_NEGOTIATION);
+	if(spi_offset(STp) == 0 && (spi_period(STp) < hostdata->min_period ||
+				    spi_period(STp) > 0xff))
+		spi_period(STp) = hostdata->min_period;
+
+	spi_offset(STp) = offset;
+	spi_flags(STp) &= ~(NCR_700_DEV_NEGOTIATED_SYNC |
+			    NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
+	spi_flags(STp) |= NCR_700_DEV_PRINT_SYNC_NEGOTIATION;
 }
 

@@ -2058,7 +2062,8 @@
 	}
 	if(hostdata->fast) {
 		/* Find the correct offset and period via domain validation */
-		spi_dv_device(SDp);
+		if (!spi_initial_dv(SDp->sdev_target))
+			spi_dv_device(SDp);
 	} else {
 		spi_offset(SDp) = 0;
 		spi_period(SDp) = 0;
===== drivers/scsi/53c700.h 1.17 vs edited =====
--- 1.17/drivers/scsi/53c700.h	2004-06-04 06:43:36 -05:00
+++ edited/drivers/scsi/53c700.h	2004-09-07 11:13:33 -05:00
@@ -121,22 +121,22 @@
 static inline int
 NCR_700_is_flag_set(struct scsi_device *SDp, __u32 flag)
 {
-	return (((unsigned long)SDp->hostdata) & flag) == flag;
+	return (spi_flags(SDp->sdev_target) & flag) == flag;
 }
 static inline int
 NCR_700_is_flag_clear(struct scsi_device *SDp, __u32 flag)
 {
-	return (((unsigned long)SDp->hostdata) & flag) == 0;
+	return (spi_flags(SDp->sdev_target) & flag) == 0;
 }
 static inline void
 NCR_700_set_flag(struct scsi_device *SDp, __u32 flag)
 {
-	SDp->hostdata = (void *)((long)SDp->hostdata | (flag & 0xffff0000));
+	spi_flags(SDp->sdev_target) |= flag;
 }
 static inline void
 NCR_700_clear_flag(struct scsi_device *SDp, __u32 flag)
 {
-	SDp->hostdata = (void *)((long)SDp->hostdata & ~(flag & 0xffff0000));
+	spi_flags(SDp->sdev_target) &= ~flag;
 }
 
 struct NCR_700_command_slot {
===== drivers/scsi/NCR_D700.c 1.19 vs edited =====
--- 1.19/drivers/scsi/NCR_D700.c	2004-06-04 06:45:28 -05:00
+++ edited/drivers/scsi/NCR_D700.c	2004-09-07 11:13:34 -05:00
@@ -99,6 +99,9 @@
 #include <linux/mca.h>
 #include <asm/io.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 
 #include "53c700.h"
 #include "NCR_D700.h"
===== drivers/scsi/lasi700.c 1.21 vs edited =====
--- 1.21/drivers/scsi/lasi700.c	2004-07-08 16:17:08 -05:00
+++ edited/drivers/scsi/lasi700.c	2004-09-07 11:23:02 -05:00
@@ -50,6 +50,9 @@
 #include <asm/delay.h>
 
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 
 #include "lasi700.h"
 #include "53c700.h"
===== drivers/scsi/scsi_lib.c 1.132 vs edited =====
--- 1.132/drivers/scsi/scsi_lib.c	2004-09-07 10:31:32 -05:00
+++ edited/drivers/scsi/scsi_lib.c	2004-09-07 11:13:34 -05:00
@@ -1739,3 +1739,30 @@
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
+static int
+device_quiesce_fn(struct device *dev, void *data)
+{
+	scsi_device_quiesce(to_scsi_device(dev));
+	return 0;
+}
+
+void
+scsi_target_quiesce(struct scsi_target *starget)
+{
+	device_for_each_child(&starget->dev, NULL, device_quiesce_fn);
+}
+EXPORT_SYMBOL(scsi_target_quiesce);
+
+static int
+device_resume_fn(struct device *dev, void *data)
+{
+	scsi_device_resume(to_scsi_device(dev));
+	return 0;
+}
+
+void
+scsi_target_resume(struct scsi_target *starget)
+{
+	device_for_each_child(&starget->dev, NULL, device_resume_fn);
+}
+EXPORT_SYMBOL(scsi_target_resume);
===== drivers/scsi/scsi_transport_spi.c 1.15 vs edited =====
--- 1.15/drivers/scsi/scsi_transport_spi.c	2004-09-07 11:02:40 -05:00
+++ edited/drivers/scsi/scsi_transport_spi.c	2004-09-07 11:13:35 -05:00
@@ -27,13 +27,14 @@
 #include <asm/scatterlist.h>
 #include <asm/io.h>
 #include <scsi/scsi.h>
+#include "scsi_priv.h"
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_request.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
 
-#define SPI_PRINTK(x, l, f, a...)	printk(l "scsi(%d:%d:%d:%d): " f, (x)->host->host_no, (x)->channel, (x)->id, (x)->lun , ##a)
+#define SPI_PRINTK(x, l, f, a...)	dev_printk(l, &(x)->dev, f , ##a)
 
 static void transport_class_release(struct class_device *class_dev);
 
@@ -95,28 +96,29 @@
 	class_unregister(&spi_transport_class);
 }
 
-static int spi_setup_transport_attrs(struct scsi_device *sdev)
+static int spi_setup_transport_attrs(struct scsi_target *starget)
 {
-	spi_period(sdev) = -1;	/* illegal value */
-	spi_offset(sdev) = 0;	/* async */
-	spi_width(sdev) = 0;	/* narrow */
-	spi_iu(sdev) = 0;	/* no IU */
-	spi_dt(sdev) = 0;	/* ST */
-	spi_qas(sdev) = 0;
-	spi_wr_flow(sdev) = 0;
-	spi_rd_strm(sdev) = 0;
-	spi_rti(sdev) = 0;
-	spi_pcomp_en(sdev) = 0;
-	spi_dv_pending(sdev) = 0;
-	init_MUTEX(&spi_dv_sem(sdev));
+	spi_period(starget) = -1;	/* illegal value */
+	spi_offset(starget) = 0;	/* async */
+	spi_width(starget) = 0;	/* narrow */
+	spi_iu(starget) = 0;	/* no IU */
+	spi_dt(starget) = 0;	/* ST */
+	spi_qas(starget) = 0;
+	spi_wr_flow(starget) = 0;
+	spi_rd_strm(starget) = 0;
+	spi_rti(starget) = 0;
+	spi_pcomp_en(starget) = 0;
+	spi_dv_pending(starget) = 0;
+	spi_initial_dv(starget) = 0;
+	init_MUTEX(&spi_dv_sem(starget));
 
 	return 0;
 }
 
 static void transport_class_release(struct class_device *class_dev)
 {
-	struct scsi_device *sdev = transport_class_to_sdev(class_dev);
-	put_device(&sdev->sdev_gendev);
+	struct scsi_target *starget = transport_class_to_starget(class_dev);
+	put_device(&starget->dev);
 }
 
 #define spi_transport_show_function(field, format_string)		\
@@ -124,12 +126,13 @@
 static ssize_t								\
 show_spi_transport_##field(struct class_device *cdev, char *buf)	\
 {									\
-	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
 	struct spi_transport_attrs *tp;					\
-	struct spi_internal *i = to_spi_internal(sdev->host->transportt); \
-	tp = (struct spi_transport_attrs *)&sdev->transport_data;	\
+	struct spi_internal *i = to_spi_internal(shost->transportt);	\
+	tp = (struct spi_transport_attrs *)&starget->transport_data;	\
 	if (i->f->get_##field)						\
-		i->f->get_##field(sdev);				\
+		i->f->get_##field(starget);				\
 	return snprintf(buf, 20, format_string, tp->field);		\
 }
 
@@ -139,11 +142,12 @@
 			    size_t count)				\
 {									\
 	int val;							\
-	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
-	struct spi_internal *i = to_spi_internal(sdev->host->transportt); \
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct spi_internal *i = to_spi_internal(shost->transportt);	\
 									\
 	val = simple_strtoul(buf, NULL, 0);				\
-	i->f->set_##field(sdev, val);					\
+	i->f->set_##field(starget, val);				\
 	return count;							\
 }
 
@@ -168,8 +172,13 @@
 static ssize_t
 store_spi_revalidate(struct class_device *cdev, const char *buf, size_t count)
 {
-	struct scsi_device *sdev = transport_class_to_sdev(cdev);
+	struct scsi_target *starget = transport_class_to_starget(cdev);
 
+	/* FIXME: we're relying on an awful lot of device internals
+	 * here.  We really need a function to get the first available
+	 * child */
+	struct device *dev = container_of(starget->dev.children.next, struct device, node);
+	struct scsi_device *sdev = to_scsi_device(dev);
 	spi_dv_device(sdev);
 	return count;
 }
@@ -180,15 +189,16 @@
 static ssize_t show_spi_transport_period(struct class_device *cdev, char *buf)
 
 {
-	struct scsi_device *sdev = transport_class_to_sdev(cdev);
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct spi_transport_attrs *tp;
 	const char *str;
-	struct spi_internal *i = to_spi_internal(sdev->host->transportt);
+	struct spi_internal *i = to_spi_internal(shost->transportt);
 
-	tp = (struct spi_transport_attrs *)&sdev->transport_data;
+	tp = (struct spi_transport_attrs *)&starget->transport_data;
 
 	if (i->f->get_period)
-		i->f->get_period(sdev);
+		i->f->get_period(starget);
 
 	switch(tp->period) {
 
@@ -212,8 +222,9 @@
 store_spi_transport_period(struct class_device *cdev, const char *buf,
 			    size_t count)
 {
-	struct scsi_device *sdev = transport_class_to_sdev(cdev);
-	struct spi_internal *i = to_spi_internal(sdev->host->transportt);
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct spi_internal *i = to_spi_internal(shost->transportt);
 	int j, period = -1;
 
 	for (j = 0; j < SPI_STATIC_PPR; j++) {
@@ -246,7 +257,7 @@
 	if (period > 0xff)
 		period = 0xff;
 
-	i->f->set_period(sdev, period);
+	i->f->set_period(starget, period);
 
 	return count;
 }
@@ -257,7 +268,7 @@
 
 #define DV_SET(x, y)			\
 	if(i->f->set_##x)		\
-		i->f->set_##x(sdev, y)
+		i->f->set_##x(sdev->sdev_target, y)
 
 #define DV_LOOPS	3
 #define DV_TIMEOUT	(10*HZ)
@@ -325,7 +336,7 @@
 			      DV_TIMEOUT, DV_RETRIES);
 		if(sreq->sr_result || !scsi_device_online(sdev)) {
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			SPI_PRINTK(sdev, KERN_ERR, "Write Buffer failure %x\n", sreq->sr_result);
+			SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Write Buffer failure %x\n", sreq->sr_result);
 			return 0;
 		}
 
@@ -401,8 +412,8 @@
 
 		/* OK, retrain, fallback */
 		if (i->f->get_period)
-			i->f->get_period(sdev);
-		newperiod = spi_period(sdev);
+			i->f->get_period(sdev->sdev_target);
+		newperiod = spi_period(sdev->sdev_target);
 		period = newperiod > period ? newperiod : period;
 		if (period < 0x0d)
 			period++;
@@ -411,11 +422,11 @@
 
 		if (unlikely(period > 0xff || period == prevperiod)) {
 			/* Total failure; set to async and return */
-			SPI_PRINTK(sdev, KERN_ERR, "Domain Validation Failure, dropping back to Asynchronous\n");
+			SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Domain Validation Failure, dropping back to Asynchronous\n");
 			DV_SET(offset, 0);
 			return 0;
 		}
-		SPI_PRINTK(sdev, KERN_ERR, "Domain Validation detected failure, dropping back\n");
+		SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Domain Validation detected failure, dropping back\n");
 		DV_SET(period, period);
 		prevperiod = period;
 	}
@@ -486,20 +497,20 @@
 	DV_SET(width, 0);
 	
 	if (!spi_dv_device_compare_inquiry(sreq, buffer, buffer, DV_LOOPS)) {
-		SPI_PRINTK(sdev, KERN_ERR, "Domain Validation Initial Inquiry Failed\n");
+		SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Domain Validation Initial Inquiry Failed\n");
 		/* FIXME: should probably offline the device here? */
 		return;
 	}
 
 	/* test width */
 	if (i->f->set_width && sdev->wdtr) {
-		i->f->set_width(sdev, 1);
+		i->f->set_width(sdev->sdev_target, 1);
 
 		if (!spi_dv_device_compare_inquiry(sreq, buffer,
 						   buffer + len,
 						   DV_LOOPS)) {
-			SPI_PRINTK(sdev, KERN_ERR, "Wide Transfers Fail\n");
-			i->f->set_width(sdev, 0);
+			SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Wide Transfers Fail\n");
+			i->f->set_width(sdev->sdev_target, 0);
 		}
 	}
 
@@ -521,11 +532,11 @@
 	 * test, now try an echo buffer test (if the device allows it) */
 
 	if ((len = spi_dv_device_get_echo_buffer(sreq, buffer)) == 0) {
-		SPI_PRINTK(sdev, KERN_INFO, "Domain Validation skipping write tests\n");
+		SPI_PRINTK(sdev->sdev_target, KERN_INFO, "Domain Validation skipping write tests\n");
 		return;
 	}
 	if (len > SPI_MAX_ECHO_BUFFER_SIZE) {
-		SPI_PRINTK(sdev, KERN_WARNING, "Echo buffer size %d is too big, trimming to %d\n", len, SPI_MAX_ECHO_BUFFER_SIZE);
+		SPI_PRINTK(sdev->sdev_target, KERN_WARNING, "Echo buffer size %d is too big, trimming to %d\n", len, SPI_MAX_ECHO_BUFFER_SIZE);
 		len = SPI_MAX_ECHO_BUFFER_SIZE;
 	}
 
@@ -547,6 +558,7 @@
 spi_dv_device(struct scsi_device *sdev)
 {
 	struct scsi_request *sreq = scsi_allocate_request(sdev, GFP_KERNEL);
+	struct scsi_target *starget = sdev->sdev_target;
 	u8 *buffer;
 	const int len = SPI_MAX_ECHO_BUFFER_SIZE*2;
 
@@ -563,22 +575,28 @@
 
 	memset(buffer, 0, len);
 
+	/* We need to verify that the actual device will quiesce; the
+	 * later target quiesce is just a nice to have */
 	if (unlikely(scsi_device_quiesce(sdev)))
 		goto out_free;
 
-	spi_dv_pending(sdev) = 1;
-	down(&spi_dv_sem(sdev));
+	scsi_target_quiesce(starget);
 
-	SPI_PRINTK(sdev, KERN_INFO, "Beginning Domain Validation\n");
+	spi_dv_pending(starget) = 1;
+	down(&spi_dv_sem(starget));
+
+	SPI_PRINTK(starget, KERN_INFO, "Beginning Domain Validation\n");
 
 	spi_dv_device_internal(sreq, buffer);
 
-	SPI_PRINTK(sdev, KERN_INFO, "Ending Domain Validation\n");
+	SPI_PRINTK(starget, KERN_INFO, "Ending Domain Validation\n");
+
+	up(&spi_dv_sem(starget));
+	spi_dv_pending(starget) = 0;
 
-	up(&spi_dv_sem(sdev));
-	spi_dv_pending(sdev) = 0;
+	scsi_target_resume(starget);
 
-	scsi_device_resume(sdev);
+	spi_initial_dv(starget) = 1;
 
  out_free:
 	kfree(buffer);
@@ -602,7 +620,7 @@
 
 	kfree(wqw);
 	spi_dv_device(sdev);
-	spi_dv_pending(sdev) = 0;
+	spi_dv_pending(sdev->sdev_target) = 0;
 	scsi_device_put(sdev);
 }
 
@@ -625,15 +643,15 @@
 	if (unlikely(!wqw))
 		return;
 
-	if (unlikely(spi_dv_pending(sdev))) {
+	if (unlikely(spi_dv_pending(sdev->sdev_target))) {
 		kfree(wqw);
 		return;
 	}
 	/* Set pending early (dv_device doesn't check it, only sets it) */
-	spi_dv_pending(sdev) = 1;
+	spi_dv_pending(sdev->sdev_target) = 1;
 	if (unlikely(scsi_device_get(sdev))) {
 		kfree(wqw);
-		spi_dv_pending(sdev) = 0;
+		spi_dv_pending(sdev->sdev_target) = 0;
 		return;
 	}
 
@@ -666,10 +684,10 @@
 	memset(i, 0, sizeof(struct spi_internal));
 

-	i->t.device_attrs = &i->attrs[0];
-	i->t.device_class = &spi_transport_class;
-	i->t.device_setup = &spi_setup_transport_attrs;
-	i->t.device_size = sizeof(struct spi_transport_attrs);
+	i->t.target_attrs = &i->attrs[0];
+	i->t.target_class = &spi_transport_class;
+	i->t.target_setup = &spi_setup_transport_attrs;
+	i->t.target_size = sizeof(struct spi_transport_attrs);
 	i->f = ft;
 
 	SETUP_ATTRIBUTE(period);
===== drivers/scsi/sim710.c 1.22 vs edited =====
--- 1.22/drivers/scsi/sim710.c	2004-06-04 05:53:02 -05:00
+++ edited/drivers/scsi/sim710.c	2004-09-07 11:13:36 -05:00
@@ -36,6 +36,9 @@
 #include <linux/eisa.h>
 #include <linux/interrupt.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 
 #include "53c700.h"
 
===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.46 vs edited =====
--- 1.46/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-08-29 10:06:02 -05:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-09-07 11:48:40 -05:00
@@ -1096,7 +1096,8 @@
 	lp->s.scdev_depth = depth_to_use;
 	sym_tune_dev_queuing(np, device->id, device->lun, reqtags);
 
-	spi_dv_device(device);
+	if (!spi_initial_dv(device->sdev_target))
+		spi_dv_device(device);
 
 	return 0;
 }
@@ -2304,35 +2305,39 @@
 	attach_count--;
 }
 
-static void sym2_get_offset(struct scsi_device *sdev)
+static void sym2_get_offset(struct scsi_target *starget)
 {
-	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
-	struct sym_tcb *tp = &np->target[sdev->id];
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
 
-	spi_offset(sdev) = tp->tinfo.curr.offset;
+	spi_offset(starget) = tp->tinfo.curr.offset;
 }
 
-static void sym2_set_offset(struct scsi_device *sdev, int offset)
+static void sym2_set_offset(struct scsi_target *starget, int offset)
 {
-	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
-	struct sym_tcb *tp = &np->target[sdev->id];
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
 
 	tp->tinfo.goal.offset = offset;
 }
 

-static void sym2_get_period(struct scsi_device *sdev)
+static void sym2_get_period(struct scsi_target *starget)
 {
-	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
-	struct sym_tcb *tp = &np->target[sdev->id];
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
 
-	spi_period(sdev) = tp->tinfo.curr.period;
+	spi_period(starget) = tp->tinfo.curr.period;
 }
 
-static void sym2_set_period(struct scsi_device *sdev, int period)
+static void sym2_set_period(struct scsi_target *starget, int period)
 {
-	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
-	struct sym_tcb *tp = &np->target[sdev->id];
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
 
 	/* have to have DT for these transfers */
 	if (period <= np->minsync)
@@ -2341,18 +2346,20 @@
 	tp->tinfo.goal.period = period;
 }
 
-static void sym2_get_width(struct scsi_device *sdev)
+static void sym2_get_width(struct scsi_target *starget)
 {
-	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
-	struct sym_tcb *tp = &np->target[sdev->id];
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
 
-	spi_width(sdev) = tp->tinfo.curr.width ? 1 : 0;
+	spi_width(starget) = tp->tinfo.curr.width ? 1 : 0;
 }
 
-static void sym2_set_width(struct scsi_device *sdev, int width)
+static void sym2_set_width(struct scsi_target *starget, int width)
 {
-	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
-	struct sym_tcb *tp = &np->target[sdev->id];
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
 
 	/* It is illegal to have DT set on narrow transfers */
 	if (width == 0)
@@ -2361,18 +2368,20 @@
 	tp->tinfo.goal.width = width;
 }
 
-static void sym2_get_dt(struct scsi_device *sdev)
+static void sym2_get_dt(struct scsi_target *starget)
 {
-	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
-	struct sym_tcb *tp = &np->target[sdev->id];
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
 
-	spi_dt(sdev) = (tp->tinfo.curr.options & PPR_OPT_DT) ? 1 : 0;
+	spi_dt(starget) = (tp->tinfo.curr.options & PPR_OPT_DT) ? 1 : 0;
 }
 
-static void sym2_set_dt(struct scsi_device *sdev, int dt)
+static void sym2_set_dt(struct scsi_target *starget, int dt)
 {
-	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
-	struct sym_tcb *tp = &np->target[sdev->id];
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
 
 	if (dt)
 		tp->tinfo.goal.options |= PPR_OPT_DT;
===== include/scsi/scsi_transport_spi.h 1.6 vs edited =====
--- 1.6/include/scsi/scsi_transport_spi.h	2004-03-18 09:00:04 -06:00
+++ edited/include/scsi/scsi_transport_spi.h	2004-09-07 11:13:36 -05:00
@@ -35,6 +35,8 @@
 	unsigned int rd_strm:1;	/* Read streaming enabled */
 	unsigned int rti:1;	/* Retain Training Information */
 	unsigned int pcomp_en:1;/* Precompensation enabled */
+	unsigned int initial_dv:1; /* DV done to this target yet  */
+	unsigned long flags;	/* flags field for drivers to use */
 	/* Private Fields */
 	unsigned int dv_pending:1; /* Internal flag */
 	struct semaphore dv_sem; /* semaphore to serialise dv */
@@ -51,29 +53,31 @@
 #define spi_rd_strm(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->rd_strm)
 #define spi_rti(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->rti)
 #define spi_pcomp_en(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->pcomp_en)
+#define spi_initial_dv(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->initial_dv)
+#define spi_flags(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->flags)
 
 /* The functions by which the transport class and the driver communicate */
 struct spi_function_template {
-	void	(*get_period)(struct scsi_device *);
-	void	(*set_period)(struct scsi_device *, int);
-	void	(*get_offset)(struct scsi_device *);
-	void	(*set_offset)(struct scsi_device *, int);
-	void	(*get_width)(struct scsi_device *);
-	void	(*set_width)(struct scsi_device *, int);
-	void	(*get_iu)(struct scsi_device *);
-	void	(*set_iu)(struct scsi_device *, int);
-	void	(*get_dt)(struct scsi_device *);
-	void	(*set_dt)(struct scsi_device *, int);
-	void	(*get_qas)(struct scsi_device *);
-	void	(*set_qas)(struct scsi_device *, int);
-	void	(*get_wr_flow)(struct scsi_device *);
-	void	(*set_wr_flow)(struct scsi_device *, int);
-	void	(*get_rd_strm)(struct scsi_device *);
-	void	(*set_rd_strm)(struct scsi_device *, int);
-	void	(*get_rti)(struct scsi_device *);
-	void	(*set_rti)(struct scsi_device *, int);
-	void	(*get_pcomp_en)(struct scsi_device *);
-	void	(*set_pcomp_en)(struct scsi_device *, int);
+	void	(*get_period)(struct scsi_target *);
+	void	(*set_period)(struct scsi_target *, int);
+	void	(*get_offset)(struct scsi_target *);
+	void	(*set_offset)(struct scsi_target *, int);
+	void	(*get_width)(struct scsi_target *);
+	void	(*set_width)(struct scsi_target *, int);
+	void	(*get_iu)(struct scsi_target *);
+	void	(*set_iu)(struct scsi_target *, int);
+	void	(*get_dt)(struct scsi_target *);
+	void	(*set_dt)(struct scsi_target *, int);
+	void	(*get_qas)(struct scsi_target *);
+	void	(*set_qas)(struct scsi_target *, int);
+	void	(*get_wr_flow)(struct scsi_target *);
+	void	(*set_wr_flow)(struct scsi_target *, int);
+	void	(*get_rd_strm)(struct scsi_target *);
+	void	(*set_rd_strm)(struct scsi_target *, int);
+	void	(*get_rti)(struct scsi_target *);
+	void	(*set_rti)(struct scsi_target *, int);
+	void	(*get_pcomp_en)(struct scsi_target *);
+	void	(*set_pcomp_en)(struct scsi_target *, int);
 	/* The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
 	 * is not set, the attribute will be private to the transport

