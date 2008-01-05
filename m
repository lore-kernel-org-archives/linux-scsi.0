From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi_transport_spi: convert to attribute groups
Date: Sat, 05 Jan 2008 10:18:27 -0600
Message-ID: <1199549907.3399.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39962 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426AbYAEQSe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 11:18:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>

This conversion makes full use of the is_visible() callback on attribute
groups.  Now, each device appears only with its capability flags in the
transport class directory.  Previously each device appeared with the
capability of the host, so this is a functionality improvement.
Converting to attribute groups allows us to sweep away most of the home
grown #defines that were effectively doing the same thing.

James

---

This depends on:

[PATCH] sysfs: add filter function to groups
[PATCH] fix the sysfs_add_file_to_group interfaces
[PATCH] attribute_container: update to use the group interface
[PATCH] add missing transport configure points for target and host

Greg and Kay, there's a nasty point in the code where I'd like to use
the -EEXIST return of sysfs_add_file_to_group() to indicate the file is
already there, however, this also dumps a stack trace and would frighten
users ... can we get rid of the printk and the WARN_ON(1)?

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 4df21c9..1fb6031 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -52,13 +52,6 @@
 struct spi_internal {
 	struct scsi_transport_template t;
 	struct spi_function_template *f;
-	/* The actual attributes */
-	struct class_device_attribute private_attrs[SPI_NUM_ATTRS];
-	/* The array of null terminated pointers to attributes 
-	 * needed by scsi_sysfs.c */
-	struct class_device_attribute *attrs[SPI_NUM_ATTRS + SPI_OTHER_ATTRS + 1];
-	struct class_device_attribute private_host_attrs[SPI_HOST_ATTRS];
-	struct class_device_attribute *host_attrs[SPI_HOST_ATTRS + 1];
 };
 
 #define to_spi_internal(tmpl)	container_of(tmpl, struct spi_internal, t)
@@ -174,17 +167,20 @@ static int spi_host_setup(struct transport_container *tc, struct device *dev,
 	return 0;
 }
 
+static int spi_host_configure(struct transport_container *tc,
+			      struct device *dev,
+			      struct class_device *cdev);
+
 static DECLARE_TRANSPORT_CLASS(spi_host_class,
 			       "spi_host",
 			       spi_host_setup,
 			       NULL,
-			       NULL);
+			       spi_host_configure);
 
 static int spi_host_match(struct attribute_container *cont,
 			  struct device *dev)
 {
 	struct Scsi_Host *shost;
-	struct spi_internal *i;
 
 	if (!scsi_is_host_device(dev))
 		return 0;
@@ -194,11 +190,13 @@ static int spi_host_match(struct attribute_container *cont,
 	    != &spi_host_class.class)
 		return 0;
 
-	i = to_spi_internal(shost->transportt);
-	
-	return &i->t.host_attrs.ac == cont;
+	return &shost->transportt->host_attrs.ac == cont;
 }
 
+static int spi_target_configure(struct transport_container *tc,
+				struct device *dev,
+				struct class_device *cdev);
+
 static int spi_device_configure(struct transport_container *tc,
 				struct device *dev,
 				struct class_device *cdev)
@@ -300,8 +298,10 @@ store_spi_transport_##field(struct class_device *cdev, const char *buf, \
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
 	struct spi_internal *i = to_spi_internal(shost->transportt);	\
 									\
+	if (!i->f->set_##field)						\
+		return -EINVAL;						\
 	val = simple_strtoul(buf, NULL, 0);				\
-	i->f->set_##field(starget, val);			\
+	i->f->set_##field(starget, val);				\
 	return count;							\
 }
 
@@ -317,6 +317,8 @@ store_spi_transport_##field(struct class_device *cdev, const char *buf, \
 	struct spi_transport_attrs *tp					\
 		= (struct spi_transport_attrs *)&starget->starget_data;	\
 									\
+	if (i->f->set_##field)						\
+		return -EINVAL;						\
 	val = simple_strtoul(buf, NULL, 0);				\
 	if (val > tp->max_##field)					\
 		val = tp->max_##field;					\
@@ -327,14 +329,14 @@ store_spi_transport_##field(struct class_device *cdev, const char *buf, \
 #define spi_transport_rd_attr(field, format_string)			\
 	spi_transport_show_function(field, format_string)		\
 	spi_transport_store_function(field, format_string)		\
-static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+static CLASS_DEVICE_ATTR(field, S_IRUGO,				\
 			 show_spi_transport_##field,			\
 			 store_spi_transport_##field);
 
 #define spi_transport_simple_attr(field, format_string)			\
 	spi_transport_show_simple(field, format_string)			\
 	spi_transport_store_simple(field, format_string)		\
-static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+static CLASS_DEVICE_ATTR(field, S_IRUGO,				\
 			 show_spi_transport_##field,			\
 			 store_spi_transport_##field);
 
@@ -342,7 +344,7 @@ static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
 	spi_transport_show_function(field, format_string)		\
 	spi_transport_store_max(field, format_string)			\
 	spi_transport_simple_attr(max_##field, format_string)		\
-static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+static CLASS_DEVICE_ATTR(field, S_IRUGO,				\
 			 show_spi_transport_##field,			\
 			 store_spi_transport_##field);
 
@@ -472,6 +474,9 @@ store_spi_transport_period(struct class_device *cdev, const char *buf,
 		(struct spi_transport_attrs *)&starget->starget_data;
 	int period, retval;
 
+	if (!i->f->set_period)
+		return -EINVAL;
+
 	retval = store_spi_transport_period_helper(cdev, buf, count, &period);
 
 	if (period < tp->min_period)
@@ -482,7 +487,7 @@ store_spi_transport_period(struct class_device *cdev, const char *buf,
 	return retval;
 }
 
-static CLASS_DEVICE_ATTR(period, S_IRUGO | S_IWUSR, 
+static CLASS_DEVICE_ATTR(period, S_IRUGO,
 			 show_spi_transport_period,
 			 store_spi_transport_period);
 
@@ -490,9 +495,14 @@ static ssize_t
 show_spi_transport_min_period(struct class_device *cdev, char *buf)
 {
 	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct spi_internal *i = to_spi_internal(shost->transportt);
 	struct spi_transport_attrs *tp =
 		(struct spi_transport_attrs *)&starget->starget_data;
 
+	if (!i->f->set_period)
+		return -EINVAL;
+
 	return show_spi_transport_period_helper(buf, tp->min_period);
 }
 
@@ -509,7 +519,7 @@ store_spi_transport_min_period(struct class_device *cdev, const char *buf,
 }
 
 
-static CLASS_DEVICE_ATTR(min_period, S_IRUGO | S_IWUSR, 
+static CLASS_DEVICE_ATTR(min_period, S_IRUGO,
 			 show_spi_transport_min_period,
 			 store_spi_transport_min_period);
 
@@ -531,12 +541,15 @@ static ssize_t store_spi_host_signalling(struct class_device *cdev,
 	struct spi_internal *i = to_spi_internal(shost->transportt);
 	enum spi_signal_type type = spi_signal_to_value(buf);
 
+	if (!i->f->set_signalling)
+		return -EINVAL;
+
 	if (type != SPI_SIGNAL_UNKNOWN)
 		i->f->set_signalling(shost, type);
 
 	return count;
 }
-static CLASS_DEVICE_ATTR(signalling, S_IRUGO | S_IWUSR,
+static CLASS_DEVICE_ATTR(signalling, S_IRUGO,
 			 show_spi_host_signalling,
 			 store_spi_host_signalling);
 
@@ -1262,35 +1275,6 @@ int spi_print_msg(const unsigned char *msg)
 EXPORT_SYMBOL(spi_print_msg);
 #endif /* ! CONFIG_SCSI_CONSTANTS */
 
-#define SETUP_ATTRIBUTE(field)						\
-	i->private_attrs[count] = class_device_attr_##field;		\
-	if (!i->f->set_##field) {					\
-		i->private_attrs[count].attr.mode = S_IRUGO;		\
-		i->private_attrs[count].store = NULL;			\
-	}								\
-	i->attrs[count] = &i->private_attrs[count];			\
-	if (i->f->show_##field)						\
-		count++
-
-#define SETUP_RELATED_ATTRIBUTE(field, rel_field)			\
-	i->private_attrs[count] = class_device_attr_##field;		\
-	if (!i->f->set_##rel_field) {					\
-		i->private_attrs[count].attr.mode = S_IRUGO;		\
-		i->private_attrs[count].store = NULL;			\
-	}								\
-	i->attrs[count] = &i->private_attrs[count];			\
-	if (i->f->show_##rel_field)					\
-		count++
-
-#define SETUP_HOST_ATTRIBUTE(field)					\
-	i->private_host_attrs[count] = class_device_attr_##field;	\
-	if (!i->f->set_##field) {					\
-		i->private_host_attrs[count].attr.mode = S_IRUGO;	\
-		i->private_host_attrs[count].store = NULL;		\
-	}								\
-	i->host_attrs[count] = &i->private_host_attrs[count];		\
-	count++
-
 static int spi_device_match(struct attribute_container *cont,
 			    struct device *dev)
 {
@@ -1343,16 +1327,156 @@ static DECLARE_TRANSPORT_CLASS(spi_transport_class,
 			       "spi_transport",
 			       spi_setup_transport_attrs,
 			       NULL,
-			       NULL);
+			       spi_target_configure);
 
 static DECLARE_ANON_TRANSPORT_CLASS(spi_device_class,
 				    spi_device_match,
 				    spi_device_configure);
 
+static struct attribute *host_attributes[] = {
+	&class_device_attr_signalling.attr,
+	NULL
+};
+
+static struct attribute_group host_attribute_group = {
+	.attrs = host_attributes,
+};
+
+static int spi_host_configure(struct transport_container *tc,
+			      struct device *dev,
+			      struct class_device *cdev)
+{
+	struct kobject *kobj = &cdev->kobj;
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct spi_internal *si = to_spi_internal(shost->transportt);
+	struct attribute *attr = &class_device_attr_signalling.attr;
+	int rc = 0;
+
+	if (si->f->set_signalling)
+		rc = sysfs_chmod_file(kobj, attr, attr->mode | S_IWUSR);
+
+	return rc;
+}
+
+/* returns true if we should be showing the variable.  Also
+ * overloads the return by setting 1<<1 if the attribute should
+ * be writeable */
+#define TARGET_ATTRIBUTE_HELPER(name) \
+	(si->f->show_##name ? 1 : 0) + \
+	(si->f->set_##name ? 2 : 0)
+
+static int target_attribute_is_visible(struct kobject *kobj,
+				       struct attribute *attr, int i)
+{
+	struct class_device *cdev =
+		container_of(kobj, struct class_device, kobj);
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct spi_internal *si = to_spi_internal(shost->transportt);
+
+	if (attr == &class_device_attr_period.attr &&
+	    spi_support_sync(starget))
+		return TARGET_ATTRIBUTE_HELPER(period);
+	else if (attr == &class_device_attr_min_period.attr &&
+		 spi_support_sync(starget))
+		return TARGET_ATTRIBUTE_HELPER(period);
+	else if (attr == &class_device_attr_offset.attr &&
+		 spi_support_sync(starget))
+		return TARGET_ATTRIBUTE_HELPER(offset);
+	else if (attr == &class_device_attr_max_offset.attr &&
+		 spi_support_sync(starget))
+		return TARGET_ATTRIBUTE_HELPER(offset);
+	else if (attr == &class_device_attr_width.attr &&
+		 spi_support_wide(starget))
+		return TARGET_ATTRIBUTE_HELPER(width);
+	else if (attr == &class_device_attr_max_width.attr &&
+		 spi_support_wide(starget))
+		return TARGET_ATTRIBUTE_HELPER(width);
+	else if (attr == &class_device_attr_iu.attr &&
+		 spi_support_ius(starget))
+		return TARGET_ATTRIBUTE_HELPER(iu);
+	else if (attr == &class_device_attr_dt.attr &&
+		 spi_support_dt(starget))
+		return TARGET_ATTRIBUTE_HELPER(dt);
+	else if (attr == &class_device_attr_qas.attr &&
+		 spi_support_qas(starget))
+		return TARGET_ATTRIBUTE_HELPER(qas);
+	else if (attr == &class_device_attr_wr_flow.attr &&
+		 spi_support_ius(starget))
+		return TARGET_ATTRIBUTE_HELPER(wr_flow);
+	else if (attr == &class_device_attr_rd_strm.attr &&
+		 spi_support_ius(starget))
+		return TARGET_ATTRIBUTE_HELPER(rd_strm);
+	else if (attr == &class_device_attr_rti.attr &&
+		 spi_support_ius(starget))
+		return TARGET_ATTRIBUTE_HELPER(rti);
+	else if (attr == &class_device_attr_pcomp_en.attr &&
+		 spi_support_ius(starget))
+		return TARGET_ATTRIBUTE_HELPER(pcomp_en);
+	else if (attr == &class_device_attr_hold_mcs.attr &&
+		 spi_support_ius(starget))
+		return TARGET_ATTRIBUTE_HELPER(hold_mcs);
+	else if (attr == &class_device_attr_revalidate.attr)
+		return 1;
+
+	return 0;
+}
+
+static struct attribute *target_attributes[] = {
+	&class_device_attr_period.attr,
+	&class_device_attr_min_period.attr,
+	&class_device_attr_offset.attr,
+	&class_device_attr_max_offset.attr,
+	&class_device_attr_width.attr,
+	&class_device_attr_max_width.attr,
+	&class_device_attr_iu.attr,
+	&class_device_attr_dt.attr,
+	&class_device_attr_qas.attr,
+	&class_device_attr_wr_flow.attr,
+	&class_device_attr_rd_strm.attr,
+	&class_device_attr_rti.attr,
+	&class_device_attr_pcomp_en.attr,
+	&class_device_attr_hold_mcs.attr,
+	&class_device_attr_revalidate.attr,
+	NULL
+};
+
+static struct attribute_group target_attribute_group = {
+	.attrs = target_attributes,
+	.is_visible = target_attribute_is_visible,
+};
+
+static int spi_target_configure(struct transport_container *tc,
+				struct device *dev,
+				struct class_device *cdev)
+{
+	struct kobject *kobj = &cdev->kobj;
+	int i;
+	struct attribute *attr;
+	int rc;
+
+	for (i = 0; (attr = target_attributes[i]) != NULL; i++) {
+		int j = target_attribute_group.is_visible(kobj, attr, i);
+
+		/* FIXME: as well as returning -EEXIST, which we'd like
+		 * to ignore, sysfs also does a WARN_ON and dumps a trace,
+		 * which is bad, so temporarily, skip attributes that are
+		 * already visible (the revalidate one) */
+		if (j && attr != &class_device_attr_revalidate.attr)
+			rc = sysfs_add_file_to_group(kobj, attr,
+						target_attribute_group.name);
+		/* and make the attribute writeable if we have a set
+		 * function */
+		if ((j & 1))
+			rc = sysfs_chmod_file(kobj, attr, attr->mode | S_IWUSR);
+	}
+
+	return 0;
+}
+
 struct scsi_transport_template *
 spi_attach_transport(struct spi_function_template *ft)
 {
-	int count = 0;
 	struct spi_internal *i = kzalloc(sizeof(struct spi_internal),
 					 GFP_KERNEL);
 
@@ -1360,47 +1484,17 @@ spi_attach_transport(struct spi_function_template *ft)
 		return NULL;
 
 	i->t.target_attrs.ac.class = &spi_transport_class.class;
-	i->t.target_attrs.ac.attrs = &i->attrs[0];
+	i->t.target_attrs.ac.grp = &target_attribute_group;
 	i->t.target_attrs.ac.match = spi_target_match;
 	transport_container_register(&i->t.target_attrs);
 	i->t.target_size = sizeof(struct spi_transport_attrs);
 	i->t.host_attrs.ac.class = &spi_host_class.class;
-	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
+	i->t.host_attrs.ac.grp = &host_attribute_group;
 	i->t.host_attrs.ac.match = spi_host_match;
 	transport_container_register(&i->t.host_attrs);
 	i->t.host_size = sizeof(struct spi_host_attrs);
 	i->f = ft;
 
-	SETUP_ATTRIBUTE(period);
-	SETUP_RELATED_ATTRIBUTE(min_period, period);
-	SETUP_ATTRIBUTE(offset);
-	SETUP_RELATED_ATTRIBUTE(max_offset, offset);
-	SETUP_ATTRIBUTE(width);
-	SETUP_RELATED_ATTRIBUTE(max_width, width);
-	SETUP_ATTRIBUTE(iu);
-	SETUP_ATTRIBUTE(dt);
-	SETUP_ATTRIBUTE(qas);
-	SETUP_ATTRIBUTE(wr_flow);
-	SETUP_ATTRIBUTE(rd_strm);
-	SETUP_ATTRIBUTE(rti);
-	SETUP_ATTRIBUTE(pcomp_en);
-	SETUP_ATTRIBUTE(hold_mcs);
-
-	/* if you add an attribute but forget to increase SPI_NUM_ATTRS
-	 * this bug will trigger */
-	BUG_ON(count > SPI_NUM_ATTRS);
-
-	i->attrs[count++] = &class_device_attr_revalidate;
-
-	i->attrs[count] = NULL;
-
-	count = 0;
-	SETUP_HOST_ATTRIBUTE(signalling);
-
-	BUG_ON(count > SPI_HOST_ATTRS);
-
-	i->host_attrs[count] = NULL;
-
 	return &i->t;
 }
 EXPORT_SYMBOL(spi_attach_transport);


