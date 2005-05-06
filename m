From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] implement parameter limits in the SPI transport class
Date: Fri, 06 May 2005 13:05:20 -0500
Message-ID: <1115402720.4989.43.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:53215 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261245AbVEFSFX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2005 14:05:23 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j46I5LA15847
	for <linux-scsi@vger.kernel.org>; Fri, 6 May 2005 14:05:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

There's a basic need not to have parameters go under or over certain
values when doing domain validation.  The basic ones are

max_offset, max_width and min_period

This patch makes the transport class take and enforce these three
limits.  Currently they can be set by the user, although they could
obviously be read from the HBA's on-board NVRAM area during
slave_configure (if it has one).

James

--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -35,7 +35,7 @@
 
 #define SPI_PRINTK(x, l, f, a...)	dev_printk(l, &(x)->dev, f , ##a)
 
-#define SPI_NUM_ATTRS 10	/* increase this if you add attributes */
+#define SPI_NUM_ATTRS 13	/* increase this if you add attributes */
 #define SPI_OTHER_ATTRS 1	/* Increase this if you add "always
 				 * on" attributes */
 #define SPI_HOST_ATTRS	1
@@ -219,8 +219,11 @@ static int spi_setup_transport_attrs(str
 	struct scsi_target *starget = to_scsi_target(dev);
 
 	spi_period(starget) = -1;	/* illegal value */
+	spi_min_period(starget) = 0;
 	spi_offset(starget) = 0;	/* async */
+	spi_max_offset(starget) = 255;
 	spi_width(starget) = 0;	/* narrow */
+	spi_max_width(starget) = 1;
 	spi_iu(starget) = 0;	/* no IU */
 	spi_dt(starget) = 0;	/* ST */
 	spi_qas(starget) = 0;
@@ -235,6 +238,34 @@ static int spi_setup_transport_attrs(str
 	return 0;
 }
 
+#define spi_transport_show_simple(field, format_string)			\
+									\
+static ssize_t								\
+show_spi_transport_##field(struct class_device *cdev, char *buf)	\
+{									\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct spi_transport_attrs *tp;					\
+									\
+	tp = (struct spi_transport_attrs *)&starget->starget_data;	\
+	return snprintf(buf, 20, format_string, tp->field);		\
+}
+
+#define spi_transport_store_simple(field, format_string)		\
+									\
+static ssize_t								\
+store_spi_transport_##field(struct class_device *cdev, const char *buf, \
+			    size_t count)				\
+{									\
+	int val;							\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct spi_transport_attrs *tp;					\
+									\
+	tp = (struct spi_transport_attrs *)&starget->starget_data;	\
+	val = simple_strtoul(buf, NULL, 0);				\
+	tp->field = val;						\
+	return count;							\
+}
+
 #define spi_transport_show_function(field, format_string)		\
 									\
 static ssize_t								\
@@ -261,6 +292,25 @@ store_spi_transport_##field(struct class
 	struct spi_internal *i = to_spi_internal(shost->transportt);	\
 									\
 	val = simple_strtoul(buf, NULL, 0);				\
+	i->f->set_##field(starget, val);			\
+	return count;							\
+}
+
+#define spi_transport_store_max(field, format_string)			\
+static ssize_t								\
+store_spi_transport_##field(struct class_device *cdev, const char *buf, \
+			    size_t count)				\
+{									\
+	int val;							\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct spi_internal *i = to_spi_internal(shost->transportt);	\
+	struct spi_transport_attrs *tp					\
+		= (struct spi_transport_attrs *)&starget->starget_data;	\
+									\
+	val = simple_strtoul(buf, NULL, 0);				\
+	if (val > tp->max_##field)					\
+		val = tp->max_##field;					\
 	i->f->set_##field(starget, val);				\
 	return count;							\
 }
@@ -272,9 +322,24 @@ static CLASS_DEVICE_ATTR(field, S_IRUGO 
 			 show_spi_transport_##field,			\
 			 store_spi_transport_##field);
 
+#define spi_transport_simple_attr(field, format_string)			\
+	spi_transport_show_simple(field, format_string)			\
+	spi_transport_store_simple(field, format_string)		\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+			 show_spi_transport_##field,			\
+			 store_spi_transport_##field);
+
+#define spi_transport_max_attr(field, format_string)			\
+	spi_transport_show_function(field, format_string)		\
+	spi_transport_store_max(field, format_string)			\
+	spi_transport_simple_attr(max_##field, format_string)		\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+			 show_spi_transport_##field,			\
+			 store_spi_transport_##field);
+
 /* The Parallel SCSI Tranport Attributes: */
-spi_transport_rd_attr(offset, "%d\n");
-spi_transport_rd_attr(width, "%d\n");
+spi_transport_max_attr(offset, "%d\n");
+spi_transport_max_attr(width, "%d\n");
 spi_transport_rd_attr(iu, "%d\n");
 spi_transport_rd_attr(dt, "%d\n");
 spi_transport_rd_attr(qas, "%d\n");
@@ -300,26 +365,18 @@ static CLASS_DEVICE_ATTR(revalidate, S_I
 
 /* Translate the period into ns according to the current spec
  * for SDTR/PPR messages */
-static ssize_t show_spi_transport_period(struct class_device *cdev, char *buf)
-
+static ssize_t
+show_spi_transport_period_helper(struct class_device *cdev, char *buf,
+				 int period)
 {
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct spi_transport_attrs *tp;
 	int len, picosec;
-	struct spi_internal *i = to_spi_internal(shost->transportt);
-
-	tp = (struct spi_transport_attrs *)&starget->starget_data;
-
-	if (i->f->get_period)
-		i->f->get_period(starget);
 
-	if (tp->period < 0 || tp->period > 0xff) {
+	if (period < 0 || period > 0xff) {
 		picosec = -1;
-	} else if (tp->period <= SPI_STATIC_PPR) {
-		picosec = ppr_to_ps[tp->period];
+	} else if (period <= SPI_STATIC_PPR) {
+		picosec = ppr_to_ps[period];
 	} else {
-		picosec = tp->period * 4000;
+		picosec = period * 4000;
 	}
 
 	if (picosec == -1) {
@@ -334,12 +391,9 @@ static ssize_t show_spi_transport_period
 }
 
 static ssize_t
-store_spi_transport_period(struct class_device *cdev, const char *buf,
-			    size_t count)
+store_spi_transport_period_helper(struct class_device *cdev, const char *buf,
+				  size_t count, int *periodp)
 {
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct spi_internal *i = to_spi_internal(shost->transportt);
 	int j, picosec, period = -1;
 	char *endp;
 
@@ -368,15 +422,79 @@ store_spi_transport_period(struct class_
 	if (period > 0xff)
 		period = 0xff;
 
-	i->f->set_period(starget, period);
+	*periodp = period;
 
 	return count;
 }
 
+static ssize_t
+show_spi_transport_period(struct class_device *cdev, char *buf)
+{
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct spi_internal *i = to_spi_internal(shost->transportt);
+	struct spi_transport_attrs *tp =
+		(struct spi_transport_attrs *)&starget->starget_data;
+
+	if (i->f->get_period)
+		i->f->get_period(starget);
+
+	return show_spi_transport_period_helper(cdev, buf, tp->period);
+}
+
+static ssize_t
+store_spi_transport_period(struct class_device *cdev, const char *buf,
+			    size_t count)
+{
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct spi_internal *i = to_spi_internal(shost->transportt);
+	struct spi_transport_attrs *tp =
+		(struct spi_transport_attrs *)&starget->starget_data;
+	int period, retval;
+
+	retval = store_spi_transport_period_helper(cdev, buf, count, &period);
+
+	if (period < tp->min_period)
+		period = tp->min_period;
+
+	i->f->set_period(starget, period);
+
+	return retval;
+}
+
 static CLASS_DEVICE_ATTR(period, S_IRUGO | S_IWUSR, 
 			 show_spi_transport_period,
 			 store_spi_transport_period);
 
+static ssize_t
+show_spi_transport_min_period(struct class_device *cdev, char *buf)
+{
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct spi_transport_attrs *tp =
+		(struct spi_transport_attrs *)&starget->starget_data;
+
+	return show_spi_transport_period_helper(cdev, buf, tp->min_period);
+}
+
+static ssize_t
+store_spi_transport_min_period(struct class_device *cdev, const char *buf,
+			    size_t count)
+{
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct spi_transport_attrs *tp =
+		(struct spi_transport_attrs *)&starget->starget_data;
+
+	return store_spi_transport_period_helper(cdev, buf, count,
+						 &tp->min_period);
+}
+
+
+static CLASS_DEVICE_ATTR(min_period, S_IRUGO | S_IWUSR, 
+			 show_spi_transport_min_period,
+			 store_spi_transport_min_period);
+
+
 static ssize_t show_spi_host_signalling(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *shost = transport_class_to_shost(cdev);
@@ -642,6 +760,7 @@ spi_dv_device_internal(struct scsi_reque
 {
 	struct spi_internal *i = to_spi_internal(sreq->sr_host->transportt);
 	struct scsi_device *sdev = sreq->sr_device;
+	struct scsi_target *starget = sdev->sdev_target;
 	int len = sdev->inquiry_len;
 	/* first set us up for narrow async */
 	DV_SET(offset, 0);
@@ -655,9 +774,11 @@ spi_dv_device_internal(struct scsi_reque
 	}
 
 	/* test width */
-	if (i->f->set_width && sdev->wdtr) {
+	if (i->f->set_width && spi_max_width(starget) && sdev->wdtr) {
 		i->f->set_width(sdev->sdev_target, 1);
 
+		printk("WIDTH IS %d\n", spi_max_width(starget));
+
 		if (spi_dv_device_compare_inquiry(sreq, buffer,
 						   buffer + len,
 						   DV_LOOPS)
@@ -684,8 +805,8 @@ spi_dv_device_internal(struct scsi_reque
  retry:
 
 	/* now set up to the maximum */
-	DV_SET(offset, 255);
-	DV_SET(period, 1);
+	DV_SET(offset, spi_max_offset(starget));
+	DV_SET(period, spi_min_period(starget));
 
 	if (len == 0) {
 		SPI_PRINTK(sdev->sdev_target, KERN_INFO, "Domain Validation skipping write tests\n");
@@ -892,6 +1013,16 @@ EXPORT_SYMBOL(spi_display_xfer_agreement
 	if (i->f->show_##field)						\
 		count++
 
+#define SETUP_RELATED_ATTRIBUTE(field, rel_field)			\
+	i->private_attrs[count] = class_device_attr_##field;		\
+	if (!i->f->set_##rel_field) {					\
+		i->private_attrs[count].attr.mode = S_IRUGO;		\
+		i->private_attrs[count].store = NULL;			\
+	}								\
+	i->attrs[count] = &i->private_attrs[count];			\
+	if (i->f->show_##rel_field)					\
+		count++
+
 #define SETUP_HOST_ATTRIBUTE(field)					\
 	i->private_host_attrs[count] = class_device_attr_##field;	\
 	if (!i->f->set_##field) {					\
@@ -975,8 +1106,11 @@ spi_attach_transport(struct spi_function
 	i->f = ft;
 
 	SETUP_ATTRIBUTE(period);
+	SETUP_RELATED_ATTRIBUTE(min_period, period);
 	SETUP_ATTRIBUTE(offset);
+	SETUP_RELATED_ATTRIBUTE(max_offset, offset);
 	SETUP_ATTRIBUTE(width);
+	SETUP_RELATED_ATTRIBUTE(max_width, width);
 	SETUP_ATTRIBUTE(iu);
 	SETUP_ATTRIBUTE(dt);
 	SETUP_ATTRIBUTE(qas);
--- a/include/scsi/scsi_transport_spi.h
+++ b/include/scsi/scsi_transport_spi.h
@@ -27,8 +27,11 @@ struct scsi_transport_template;
 
 struct spi_transport_attrs {
 	int period;		/* value in the PPR/SDTR command */
+	int min_period;
 	int offset;
+	int max_offset;
 	unsigned int width:1;	/* 0 - narrow, 1 - wide */
+	unsigned int max_width:1;
 	unsigned int iu:1;	/* Information Units enabled */
 	unsigned int dt:1;	/* DT clocking enabled */
 	unsigned int qas:1;	/* Quick Arbitration and Selection enabled */
@@ -63,8 +66,11 @@ struct spi_host_attrs {
 
 /* accessor functions */
 #define spi_period(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->period)
+#define spi_min_period(x) (((struct spi_transport_attrs *)&(x)->starget_data)->min_period)
 #define spi_offset(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->offset)
+#define spi_max_offset(x) (((struct spi_transport_attrs *)&(x)->starget_data)->max_offset)
 #define spi_width(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->width)
+#define spi_max_width(x) (((struct spi_transport_attrs *)&(x)->starget_data)->max_width)
 #define spi_iu(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->iu)
 #define spi_dt(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->dt)
 #define spi_qas(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->qas)


