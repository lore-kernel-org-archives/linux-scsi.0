From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] Make SPI transport attributes mutable
Date: 07 Mar 2004 15:16:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078690563.2080.36.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:4030 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262317AbUCGUQJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Mar 2004 15:16:09 -0500
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This adds the final missing piece to the transport attributes:  A
published API by which they can be set and retrieved (SPI attributes
only).  The sysfs field only appears writeable if the driver supplied a
set method in the attribute template, so unsettable attributes show up
as read only.

The consequence now is that the spi transport attribute class is no
longer a simple exported structure: the driver has to attach to the spi
transport class at module initialisation.

This is the type of thing I'd like to see us doing for the FC ioctls in
the FC transport class (obviously, there's one drawback in that the
classes are per-device at the moment, but expanding that to be per-host
as well should be farily trivial).

James

===== drivers/scsi/scsi_transport_spi.c 1.2 vs edited =====
--- 1.2/drivers/scsi/scsi_transport_spi.c	Fri Mar  5 12:43:30 2004
+++ edited/drivers/scsi/scsi_transport_spi.c	Sun Mar  7 14:06:44 2004
@@ -26,6 +26,41 @@
 
 static void transport_class_release(struct class_device *class_dev);
 
+#define SPI_NUM_ATTRS 10	/* increase this if you add attributes */
+
+struct spi_internal {
+	struct scsi_transport_template t;
+	struct spi_function_template *f;
+	/* The actual attributes */
+	struct class_device_attribute private_attrs[SPI_NUM_ATTRS];
+	/* The array of null terminated pointers to attributes 
+	 * needed by scsi_sysfs.c */
+	struct class_device_attribute *attrs[SPI_NUM_ATTRS + 1];
+};
+
+#define to_spi_internal(tmpl)	container_of(tmpl, struct spi_internal, t)
+
+static const char *const ppr_to_ns[] = {
+	/* The PPR values 0-6 are reserved, fill them in when
+	 * the committee defines them */
+	NULL,			/* 0x00 */
+	NULL,			/* 0x01 */
+	NULL,			/* 0x02 */
+	NULL,			/* 0x03 */
+	NULL,			/* 0x04 */
+	NULL,			/* 0x05 */
+	NULL,			/* 0x06 */
+	"3.125",		/* 0x07 */
+	"6.25",			/* 0x08 */
+	"12.5",			/* 0x09 */
+	"25",			/* 0x0a */
+	"30.3",			/* 0x0b */
+	"50",			/* 0x0c */
+};
+/* The PPR values at which you calculate the period in ns by multiplying
+ * by 4 */
+#define SPI_STATIC_PPR	0x0c
+
 struct class spi_transport_class = {
 	.name = "spi_transport",
 	.release = transport_class_release,
@@ -63,19 +98,40 @@
 	put_device(&sdev->sdev_gendev);
 }
 
-#define spi_transport_show_function(field, format_string)			\
-static ssize_t									\
-show_spi_transport_##field (struct class_device *cdev, char *buf)		\
-{										\
-	struct scsi_device *sdev = transport_class_to_sdev(cdev);		\
-	struct spi_transport_attrs *tp;						\
-	tp = (struct spi_transport_attrs *)&sdev->transport_data;		\
-	return snprintf(buf, 20, format_string, tp->field);			\
+#define spi_transport_show_function(field, format_string)		\
+									\
+static ssize_t								\
+show_spi_transport_##field(struct class_device *cdev, char *buf)	\
+{									\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
+	struct spi_transport_attrs *tp;					\
+	struct spi_internal *i = to_spi_internal(sdev->host->transportt); \
+	tp = (struct spi_transport_attrs *)&sdev->transport_data;	\
+	if(i->f->get_##field)						\
+		i->f->get_##field(sdev);				\
+	return snprintf(buf, 20, format_string, tp->field);		\
 }
 
-#define spi_transport_rd_attr(field, format_string)				\
-	spi_transport_show_function(field, format_string)			\
-static CLASS_DEVICE_ATTR( field, S_IRUGO, show_spi_transport_##field, NULL)
+#define spi_transport_store_function(field, format_string)		\
+static ssize_t								\
+store_spi_transport_##field(struct class_device *cdev, const char *buf, \
+			    size_t count)				\
+{									\
+	int val;							\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
+	struct spi_internal *i = to_spi_internal(sdev->host->transportt); \
+									\
+	val = simple_strtoul(buf, NULL, 0);				\
+	i->f->set_##field(sdev, val);					\
+	return count;							\
+}
+
+#define spi_transport_rd_attr(field, format_string)			\
+	spi_transport_show_function(field, format_string)		\
+	spi_transport_store_function(field, format_string)		\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+			 show_spi_transport_##field,			\
+			 store_spi_transport_##field)
 
 /* The Parallel SCSI Tranport Attributes: */
 spi_transport_rd_attr(offset, "%d\n");
@@ -95,72 +151,148 @@
 {
 	struct scsi_device *sdev = transport_class_to_sdev(cdev);
 	struct spi_transport_attrs *tp;
-	char *str;
+	const char *str;
+	struct spi_internal *i = to_spi_internal(sdev->host->transportt);
 
 	tp = (struct spi_transport_attrs *)&sdev->transport_data;
 
+	if(i->f->get_period)
+		i->f->get_period(sdev);
+
 	switch(tp->period) {
-	case 0x00 ... 0x06:
-		str =  "reserved";
-		break;
 
-	case 0x07:
-		str = "3.125";
+	case 0x07 ... SPI_STATIC_PPR:
+		str = ppr_to_ns[tp->period];
+		if(!str)
+			str = "reserved";
 		break;
 
-	case 0x08:
-		str = "6.25";
-		break;
 
-	case 0x09:
-		str = "12.5";
-		break;
+	case (SPI_STATIC_PPR+1) ... 0xff:
+		return sprintf(buf, "%d\n", tp->period * 4);
 
-	case 0x0a:
-		str = "25";
-		break;
+	default:
+		str = "unknown";
+	}
+	return sprintf(buf, "%s\n", str);
+}
+
+static ssize_t
+store_spi_transport_period(struct class_device *cdev, const char *buf,
+			    size_t count)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);
+	struct spi_internal *i = to_spi_internal(sdev->host->transportt);
+	int j, period = -1;
+
+	for(j = 0; j < SPI_STATIC_PPR; j++) {
+		int len;
+
+		if(ppr_to_ns[j] == NULL)
+			continue;
 
-	case 0x0b:
-		str = "30.3";
+		len = strlen(ppr_to_ns[j]);
+
+		if(strncmp(ppr_to_ns[j], buf, len) != 0)
+			continue;
+
+		if(buf[len] != '\n')
+			continue;
+		
+		period = j;
 		break;
+	}
 
-	case 0x0c:
-		str = "50";
+	if(period == -1) {
+		 int val = simple_strtoul(buf, NULL, 0);
 
-	case 0x0d ... 0xff:
-		return sprintf(buf, "%d\n", tp->period * 4);
+		 
+		 if(val >= (SPI_STATIC_PPR + 1)*4)
+			  period = val/4;
 
-	default:
-		str = "unknown";
 	}
-	return sprintf(buf, "%s\n", str);
+
+	if(period == -1 || period > 0xff)
+		 return -EINVAL;
+
+	i->f->set_period(sdev, period);
+
+	return count;
 }
+	
 
-static CLASS_DEVICE_ATTR(period, S_IRUGO, show_spi_transport_period, NULL);
+	
+		 
 

-struct class_device_attribute *spi_transport_attrs[] = {
-	&class_device_attr_period,
-	&class_device_attr_offset,
-	&class_device_attr_width,
-	&class_device_attr_iu,
-	&class_device_attr_dt,
-	&class_device_attr_qas,
-	&class_device_attr_wr_flow,
-	&class_device_attr_rd_strm,
-	&class_device_attr_rti,
-	&class_device_attr_pcomp_en,
-	NULL
-};
+static CLASS_DEVICE_ATTR(period, S_IRUGO | S_IWUSR, 
+			 show_spi_transport_period,
+			 store_spi_transport_period);
+
 
 struct scsi_transport_template spi_transport_template = {
-	.attrs = spi_transport_attrs,
 	.class = &spi_transport_class,
 	.setup = &spi_setup_transport_attrs,
 	.cleanup = NULL,
 	.size = sizeof(struct spi_transport_attrs) - sizeof(unsigned long),
 };
-EXPORT_SYMBOL(spi_transport_template);
+
+#define SETUP_ATTRIBUTE(field)						\
+	i->private_attrs[count] = class_device_attr_##field;		\
+	if(!i->f->set_##field) {					\
+		i->private_attrs[count].attr.mode = S_IRUGO;		\
+		i->private_attrs[count].store = NULL;			\
+	}								\
+	i->attrs[count] = &i->private_attrs[count];			\
+	count++
+
+struct scsi_transport_template *
+spi_attach_transport(struct spi_function_template *ft)
+{
+	struct spi_internal *i = kmalloc(sizeof(struct spi_internal),
+					 GFP_KERNEL);
+	int count = 0;
+	if(!i)
+		return NULL;
+
+	memset(i, 0, sizeof(struct spi_internal));
+
+
+	i->t.attrs = &i->attrs[0];
+	i->t.class = &spi_transport_class;
+	i->t.setup = &spi_setup_transport_attrs;
+	i->t.size = sizeof(struct spi_transport_attrs) - sizeof(unsigned long);
+	i->f = ft;
+
+	SETUP_ATTRIBUTE(period);
+	SETUP_ATTRIBUTE(offset);
+	SETUP_ATTRIBUTE(width);
+	SETUP_ATTRIBUTE(iu);
+	SETUP_ATTRIBUTE(dt);
+	SETUP_ATTRIBUTE(qas);
+	SETUP_ATTRIBUTE(wr_flow);
+	SETUP_ATTRIBUTE(rd_strm);
+	SETUP_ATTRIBUTE(rti);
+	SETUP_ATTRIBUTE(pcomp_en);
+
+	/* if you add an attribute but forget to increase SPI_NUM_ATTRS
+	 * this bug will trigger */
+	BUG_ON(count != SPI_NUM_ATTRS);
+
+	i->attrs[count] = NULL;
+
+	return &i->t;
+}
+EXPORT_SYMBOL(spi_attach_transport);
+
+void spi_release_transport(struct scsi_transport_template *t)
+{
+	struct spi_internal *i = to_spi_internal(t);
+
+	kfree(i);
+}
+EXPORT_SYMBOL(spi_release_transport);
+
 
 MODULE_AUTHOR("Martin Hicks");
 MODULE_DESCRIPTION("SPI Transport Attributes");
===== include/scsi/scsi_transport_spi.h 1.2 vs edited =====
--- 1.2/include/scsi/scsi_transport_spi.h	Fri Mar  5 12:17:53 2004
+++ edited/include/scsi/scsi_transport_spi.h	Sun Mar  7 12:29:10 2004
@@ -48,6 +48,32 @@
 #define spi_rd_strm(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->rd_strm)
 #define spi_rti(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->rti)
 #define spi_pcomp_en(x)	(((struct spi_transport_attrs *)&(x)->transport_data)->pcomp_en)
-extern struct scsi_transport_template spi_transport_template;
+
+/* The functions by which the transport class and the driver communicate */
+struct spi_function_template {
+	void	(*get_period)(struct scsi_device *);
+	void	(*set_period)(struct scsi_device *, int);
+	void	(*get_offset)(struct scsi_device *);
+	void	(*set_offset)(struct scsi_device *, int);
+	void	(*get_width)(struct scsi_device *);
+	void	(*set_width)(struct scsi_device *, int);
+	void	(*get_iu)(struct scsi_device *);
+	void	(*set_iu)(struct scsi_device *, int);
+	void	(*get_dt)(struct scsi_device *);
+	void	(*set_dt)(struct scsi_device *, int);
+	void	(*get_qas)(struct scsi_device *);
+	void	(*set_qas)(struct scsi_device *, int);
+	void	(*get_wr_flow)(struct scsi_device *);
+	void	(*set_wr_flow)(struct scsi_device *, int);
+	void	(*get_rd_strm)(struct scsi_device *);
+	void	(*set_rd_strm)(struct scsi_device *, int);
+	void	(*get_rti)(struct scsi_device *);
+	void	(*set_rti)(struct scsi_device *, int);
+	void	(*get_pcomp_en)(struct scsi_device *);
+	void	(*set_pcomp_en)(struct scsi_device *, int);
+};
+
+struct scsi_transport_template *spi_attach_transport(struct spi_function_template *);
+void spi_release_transport(struct scsi_transport_template *);
 
 #endif /* SCSI_TRANSPORT_SPI_H */



