From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add bus signalling host attributes to spi transport class
Date: 10 Sep 2004 11:39:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094830789.1762.37.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:2975 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267516AbUIJPjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 11:39:52 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i8AFdnJ23942
	for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2004 11:39:49 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is really a simple example, but it's designed to be illustrative of
how host attributes could be added to the transport class.

The new attribute is a 'signalling' one; all it does is identify the bus
signalling protocol: SE,LVD or HVD.

James


# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/09 23:24:33-05:00 jejb@raven.il.steeleye.com 
#   Add bus signalling host attribute to spi transport class
#   
#   This is just a simple illustration of host parameters:
#   it adds a bus signalling type for LVD/SE/HVD
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# include/scsi/scsi_transport_spi.h
#   2004/09/09 23:23:45-05:00 jejb@raven.il.steeleye.com +14 -0
#   Add bus signalling host attribute to spi transport class
# 
# drivers/scsi/sym53c8xx_2/sym_glue.c
#   2004/09/09 23:23:45-05:00 jejb@raven.il.steeleye.com +23 -0
#   Add bus signalling host attribute to spi transport class
# 
# drivers/scsi/scsi_transport_spi.c
#   2004/09/09 23:23:45-05:00 jejb@raven.il.steeleye.com +107 -0
#   Add bus signalling host attribute to spi transport class
# 
# drivers/scsi/53c700.c
#   2004/09/09 23:23:45-05:00 jejb@raven.il.steeleye.com +2 -0
#   Add bus signalling host attribute to spi transport class
# 
diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c	2004-09-10 07:50:06 +00:00
+++ b/drivers/scsi/53c700.c	2004-09-10 07:50:06 +00:00
@@ -404,6 +404,8 @@
 	       (hostdata->fast ? "53c700-66" : "53c700"),
 	       hostdata->rev, hostdata->differential ?
 	       "(Differential)" : "");
+	spi_signalling(host) = hostdata->differential ? SPI_SIGNAL_HVD :
+		SPI_SIGNAL_SE;
 	/* reset the chip */
 	NCR_700_chip_reset(host);
 
diff -Nru a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c	2004-09-10 07:50:06 +00:00
+++ b/drivers/scsi/scsi_transport_spi.c	2004-09-10 07:50:06 +00:00
@@ -37,10 +37,12 @@
 #define SPI_PRINTK(x, l, f, a...)	dev_printk(l, &(x)->dev, f , ##a)
 
 static void transport_class_release(struct class_device *class_dev);
+static void host_class_release(struct class_device *class_dev);
 
 #define SPI_NUM_ATTRS 10	/* increase this if you add attributes */
 #define SPI_OTHER_ATTRS 1	/* Increase this if you add "always
 				 * on" attributes */
+#define SPI_HOST_ATTRS	1
 
 #define SPI_MAX_ECHO_BUFFER_SIZE	4096
 
@@ -56,6 +58,8 @@
 	/* The array of null terminated pointers to attributes 
 	 * needed by scsi_sysfs.c */
 	struct class_device_attribute *attrs[SPI_NUM_ATTRS + SPI_OTHER_ATTRS + 1];
+	struct class_device_attribute private_host_attrs[SPI_HOST_ATTRS];
+	struct class_device_attribute *host_attrs[SPI_HOST_ATTRS + 1];
 };
 
 #define to_spi_internal(tmpl)	container_of(tmpl, struct spi_internal, t)
@@ -81,19 +85,69 @@
  * by 4 */
 #define SPI_STATIC_PPR	0x0c
 
+static struct {
+	enum spi_signal_type	value;
+	char			*name;
+} signal_types[] = {
+	{ SPI_SIGNAL_UNKNOWN, "unknown" },
+	{ SPI_SIGNAL_SE, "SE" },
+	{ SPI_SIGNAL_LVD, "LVD" },
+	{ SPI_SIGNAL_HVD, "HVD" },
+};
+
+static inline const char *spi_signal_to_string(enum spi_signal_type type)
+{
+	int i;
+
+	for (i = 0; i < sizeof(signal_types)/sizeof(signal_types[0]); i++) {
+		if (type == signal_types[i].value)
+			return signal_types[i].name;
+	}
+	return NULL;
+}
+static inline enum spi_signal_type spi_signal_to_value(const char *name)
+{
+	int i, len;
+
+	for (i = 0; i < sizeof(signal_types)/sizeof(signal_types[0]); i++) {
+		len =  strlen(signal_types[i].name);
+		if (strncmp(name, signal_types[i].name, len) == 0 &&
+		    (name[len] == '\n' || name[len] == '\0'))
+			return signal_types[i].value;
+	}
+	return SPI_SIGNAL_UNKNOWN;
+}
+
+
 struct class spi_transport_class = {
 	.name = "spi_transport",
 	.release = transport_class_release,
 };
 
+struct class spi_host_class = {
+	.name = "spi_host",
+	.release = host_class_release,
+};
+
 static __init int spi_transport_init(void)
 {
+	int error = class_register(&spi_host_class);
+	if (error)
+		return error;
 	return class_register(&spi_transport_class);
 }
 
 static void __exit spi_transport_exit(void)
 {
 	class_unregister(&spi_transport_class);
+	class_unregister(&spi_host_class);
+}
+
+static int spi_setup_host_attrs(struct Scsi_Host *shost)
+{
+	spi_signalling(shost) = SPI_SIGNAL_UNKNOWN;
+
+	return 0;
 }
 
 static int spi_setup_transport_attrs(struct scsi_target *starget)
@@ -121,6 +175,12 @@
 	put_device(&starget->dev);
 }
 
+static void host_class_release(struct class_device *class_dev)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(class_dev);
+	put_device(&shost->shost_gendev);
+}
+
 #define spi_transport_show_function(field, format_string)		\
 									\
 static ssize_t								\
@@ -266,6 +326,33 @@
 			 show_spi_transport_period,
 			 store_spi_transport_period);
 
+static ssize_t show_spi_host_signalling(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct spi_internal *i = to_spi_internal(shost->transportt);
+
+	if (i->f->get_signalling)
+		i->f->get_signalling(shost);
+
+	return sprintf(buf, "%s\n", spi_signal_to_string(spi_signalling(shost)));
+}
+static ssize_t store_spi_host_signalling(struct class_device *cdev,
+					 const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct spi_internal *i = to_spi_internal(shost->transportt);
+	enum spi_signal_type type = spi_signal_to_value(buf);
+
+	if (type != SPI_SIGNAL_UNKNOWN)
+		return count;
+
+	i->f->set_signalling(shost, type);
+	return count;
+}
+static CLASS_DEVICE_ATTR(signalling, S_IRUGO | S_IWUSR,
+			 show_spi_host_signalling,
+			 store_spi_host_signalling);
+
 #define DV_SET(x, y)			\
 	if(i->f->set_##x)		\
 		i->f->set_##x(sdev->sdev_target, y)
@@ -672,6 +759,15 @@
 	if (i->f->show_##field)						\
 		count++
 
+#define SETUP_HOST_ATTRIBUTE(field)					\
+	i->private_host_attrs[count] = class_device_attr_##field;	\
+	if (!i->f->set_##field) {					\
+		i->private_host_attrs[count].attr.mode = S_IRUGO;	\
+		i->private_host_attrs[count].store = NULL;		\
+	}								\
+	i->host_attrs[count] = &i->private_host_attrs[count];		\
+	count++
+
 struct scsi_transport_template *
 spi_attach_transport(struct spi_function_template *ft)
 {
@@ -688,6 +784,10 @@
 	i->t.target_class = &spi_transport_class;
 	i->t.target_setup = &spi_setup_transport_attrs;
 	i->t.target_size = sizeof(struct spi_transport_attrs);
+	i->t.host_attrs = &i->host_attrs[0];
+	i->t.host_class = &spi_host_class;
+	i->t.host_setup = &spi_setup_host_attrs;
+	i->t.host_size = sizeof(struct spi_host_attrs);
 	i->f = ft;
 
 	SETUP_ATTRIBUTE(period);
@@ -706,6 +806,13 @@
 	BUG_ON(count > SPI_NUM_ATTRS);
 
 	i->attrs[count++] = &class_device_attr_revalidate;
+
+	i->attrs[count] = NULL;
+
+	count = 0;
+	SETUP_HOST_ATTRIBUTE(signalling);
+
+	BUG_ON(count > SPI_HOST_ATTRS);
 
 	i->attrs[count] = NULL;
 
diff -Nru a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-09-10 07:50:06 +00:00
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-09-10 07:50:06 +00:00
@@ -2305,6 +2305,28 @@
 	attach_count--;
 }
 
+static void sym2_get_signalling(struct Scsi_Host *shost)
+{
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	enum spi_signal_type type;
+
+	switch (np->scsi_mode) {
+	case SMODE_SE:
+		type =  SPI_SIGNAL_SE;
+		break;
+	case SMODE_LVD:
+		type = SPI_SIGNAL_LVD;
+		break;
+	case SMODE_HVD:
+		type = SPI_SIGNAL_HVD;
+		break;
+	default:
+		type = SPI_SIGNAL_UNKNOWN;
+		break;
+	}
+	spi_signalling(shost) = type;
+}
+
 static void sym2_get_offset(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2403,6 +2425,7 @@
 	.get_dt		= sym2_get_dt,
 	.set_dt		= sym2_set_dt,
 	.show_dt	= 1,
+	.get_signalling	= sym2_get_signalling,
 };
 
 static struct pci_device_id sym2_id_table[] __devinitdata = {
diff -Nru a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
--- a/include/scsi/scsi_transport_spi.h	2004-09-10 07:50:06 +00:00
+++ b/include/scsi/scsi_transport_spi.h	2004-09-10 07:50:06 +00:00
@@ -42,6 +42,17 @@
 	struct semaphore dv_sem; /* semaphore to serialise dv */
 };
 
+enum spi_signal_type {
+	SPI_SIGNAL_UNKNOWN = 1,
+	SPI_SIGNAL_SE,
+	SPI_SIGNAL_LVD,
+	SPI_SIGNAL_HVD,
+};
+
+struct spi_host_attrs {
+	enum spi_signal_type signalling;
+};
+
 /* accessor functions */
 #define spi_period(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->period)
 #define spi_offset(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->offset)
@@ -55,6 +66,7 @@
 #define spi_pcomp_en(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->pcomp_en)
 #define spi_initial_dv(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->initial_dv)
 #define spi_flags(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->flags)
+#define spi_signalling(h)	(((struct spi_host_attrs *)&(h)->shost_data)->signalling)
 
 /* The functions by which the transport class and the driver communicate */
 struct spi_function_template {
@@ -78,6 +90,8 @@
 	void	(*set_rti)(struct scsi_target *, int);
 	void	(*get_pcomp_en)(struct scsi_target *);
 	void	(*set_pcomp_en)(struct scsi_target *, int);
+	void	(*get_signalling)(struct Scsi_Host *);
+	void	(*set_signalling)(struct Scsi_Host *, enum spi_signal_type);
 	/* The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
 	 * is not set, the attribute will be private to the transport

