From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Repost] [PATCH scsi-rc-fixes-2.6] Re-enable FC Transport Host
	Statistics
Date: Fri, 11 Feb 2005 17:06:25 -0500
Message-ID: <1108159585.5773.42.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C12EB54@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:61112 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262360AbVBKWGe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 17:06:34 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EB54@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-02-09 at 13:06 -0500, James.Smart@Emulex.Com wrote:
> The patch contained in the original message had a mixed up diff line...
> 
> Here's the corrected patch.

Well, no, not this way.  attribute containers are supposed to be pure
abstractions, so we can't put statistics in them.  The statistics belong
in the generic transport class.  Unfortunately, this exposes the fact
that I didn't abstract sufficiently (there's no intermediate
transport_container entity).  Can you try the attached, which corrects
the abstraction to add this.

Thanks,

James

===== drivers/base/transport_class.c 1.2 vs edited =====
--- 1.2/drivers/base/transport_class.c	2005-02-01 11:48:03 -05:00
+++ edited/drivers/base/transport_class.c	2005-02-11 16:14:03 -05:00
@@ -145,6 +145,20 @@
 }
 EXPORT_SYMBOL_GPL(transport_setup_device);
 
+static int transport_add_class_device(struct attribute_container *cont,
+				      struct device *dev,
+				      struct class_device *classdev)
+{
+	int error = attribute_container_add_class_device(classdev);
+	struct transport_container *tcont = 
+		attribute_container_to_transport_container(cont);
+
+	if (!error && tcont->statistics)
+		error = sysfs_create_group(&classdev->kobj, tcont->statistics);
+
+	return error;
+}
+
 
 /**
  * transport_add_device - declare a new dev for transport class association
@@ -159,8 +173,7 @@
 
 void transport_add_device(struct device *dev)
 {
-	attribute_container_device_trigger(dev,
-			   attribute_container_add_class_device_adapter);
+	attribute_container_device_trigger(dev, transport_add_class_device);
 }
 EXPORT_SYMBOL_GPL(transport_add_device);
 
@@ -197,13 +210,18 @@
 				     struct device *dev,
 				     struct class_device *classdev)
 {
+	struct transport_container *tcont = 
+		attribute_container_to_transport_container(cont);
 	struct transport_class *tclass = class_to_transport_class(cont->class);
 
 	if (tclass->remove)
 		tclass->remove(dev);
 
-	if (tclass->remove != anon_transport_dummy_function)
+	if (tclass->remove != anon_transport_dummy_function) {
+		if (tcont->statistics)
+			sysfs_remove_group(&classdev->kobj, tcont->statistics);
 		attribute_container_class_device_del(classdev);
+	}
 
 	return 0;
 }
===== drivers/scsi/scsi_sysfs.c 1.64 vs edited =====
--- 1.64/drivers/scsi/scsi_sysfs.c	2005-01-18 14:15:07 -05:00
+++ edited/drivers/scsi/scsi_sysfs.c	2005-02-11 16:30:16 -05:00
@@ -833,4 +833,4 @@
 
 /* A blank transport template that is used in drivers that don't
  * yet implement Transport Attributes */
-struct scsi_transport_template blank_transport_template = { NULL, };
+struct scsi_transport_template blank_transport_template = { { { {0, }, }, }, };
===== drivers/scsi/scsi_transport_fc.c 1.16 vs edited =====
--- 1.16/drivers/scsi/scsi_transport_fc.c	2005-02-01 15:54:44 -05:00
+++ edited/drivers/scsi/scsi_transport_fc.c	2005-02-11 16:21:57 -05:00
@@ -734,13 +734,13 @@
 		return 0;
 
 	shost = dev_to_shost(dev);
-	if (!shost->transportt  || shost->transportt->host_attrs.class
+	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
 	    != &fc_host_class.class)
 		return 0;
 
 	i = to_fc_internal(shost->transportt);
 	
-	return &i->t.host_attrs == cont;
+	return &i->t.host_attrs.ac == cont;
 }
 
 static int fc_target_match(struct attribute_container *cont,
@@ -753,13 +753,13 @@
 		return 0;
 
 	shost = dev_to_shost(dev->parent);
-	if (!shost->transportt  || shost->transportt->host_attrs.class
+	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
 	    != &fc_host_class.class)
 		return 0;
 
 	i = to_fc_internal(shost->transportt);
 	
-	return &i->t.target_attrs == cont;
+	return &i->t.target_attrs.ac == cont;
 }
 
 
@@ -775,20 +775,21 @@
 
 	memset(i, 0, sizeof(struct fc_internal));
 
-	i->t.target_attrs.attrs = &i->starget_attrs[0];
-	i->t.target_attrs.class = &fc_transport_class.class;
-	i->t.target_attrs.match = fc_target_match;
-	attribute_container_register(&i->t.target_attrs);
+	i->t.target_attrs.ac.attrs = &i->starget_attrs[0];
+	i->t.target_attrs.ac.class = &fc_transport_class.class;
+	i->t.target_attrs.ac.match = fc_target_match;
+	transport_container_register(&i->t.target_attrs);
 	i->t.target_size = sizeof(struct fc_starget_attrs);
 
-	i->t.host_attrs.attrs = &i->host_attrs[0];
-	i->t.host_attrs.class = &fc_host_class.class;
-	i->t.host_attrs.match = fc_host_match;
-	attribute_container_register(&i->t.host_attrs);
+	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
+	i->t.host_attrs.ac.class = &fc_host_class.class;
+	i->t.host_attrs.ac.match = fc_host_match;
 	i->t.host_size = sizeof(struct fc_host_attrs);
 
 	if (ft->get_fc_host_stats)
-		i->t.host_statistics = &fc_statistics_group;
+		i->t.host_attrs.statistics = &fc_statistics_group;
+
+	transport_container_register(&i->t.host_attrs);
 
 	i->f = ft;
 
@@ -847,8 +848,8 @@
 {
 	struct fc_internal *i = to_fc_internal(t);
 
-	attribute_container_unregister(&i->t.target_attrs);
-	attribute_container_unregister(&i->t.host_attrs);
+	transport_container_unregister(&i->t.target_attrs);
+	transport_container_unregister(&i->t.host_attrs);
 
 	kfree(i);
 }
===== drivers/scsi/scsi_transport_iscsi.c 1.4 vs edited =====
--- 1.4/drivers/scsi/scsi_transport_iscsi.c	2005-02-01 15:54:44 -05:00
+++ edited/drivers/scsi/scsi_transport_iscsi.c	2005-02-11 16:33:57 -05:00
@@ -264,13 +264,13 @@
 		return 0;
 
 	shost = dev_to_shost(dev);
-	if (!shost->transportt  || shost->transportt->host_attrs.class
+	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
 	    != &iscsi_host_class.class)
 		return 0;
 
 	i = to_iscsi_internal(shost->transportt);
 	
-	return &i->t.host_attrs == cont;
+	return &i->t.host_attrs.ac == cont;
 }
 
 static int iscsi_target_match(struct attribute_container *cont,
@@ -283,13 +283,13 @@
 		return 0;
 
 	shost = dev_to_shost(dev->parent);
-	if (!shost->transportt  || shost->transportt->host_attrs.class
+	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
 	    != &iscsi_host_class.class)
 		return 0;
 
 	i = to_iscsi_internal(shost->transportt);
 	
-	return &i->t.target_attrs == cont;
+	return &i->t.target_attrs.ac == cont;
 }
 
 struct scsi_transport_template *
@@ -305,10 +305,10 @@
 	memset(i, 0, sizeof(struct iscsi_internal));
 	i->fnt = fnt;
 
-	i->t.target_attrs.attrs = &i->session_attrs[0];
-	i->t.target_attrs.class = &iscsi_transport_class.class;
-	i->t.target_attrs.match = iscsi_target_match;
-	attribute_container_register(&i->t.target_attrs);
+	i->t.target_attrs.ac.attrs = &i->session_attrs[0];
+	i->t.target_attrs.ac.class = &iscsi_transport_class.class;
+	i->t.target_attrs.ac.match = iscsi_target_match;
+	transport_container_register(&i->t.target_attrs);
 	i->t.target_size = sizeof(struct iscsi_class_session);
 
 	SETUP_SESSION_RD_ATTR(tsih);
@@ -335,10 +335,10 @@
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
 	i->session_attrs[count] = NULL;
 
-	i->t.host_attrs.attrs = &i->host_attrs[0];
-	i->t.host_attrs.class = &iscsi_host_class.class;
-	i->t.host_attrs.match = iscsi_host_match;
-	attribute_container_register(&i->t.host_attrs);
+	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
+	i->t.host_attrs.ac.class = &iscsi_host_class.class;
+	i->t.host_attrs.ac.match = iscsi_host_match;
+	transport_container_register(&i->t.host_attrs);
 	i->t.host_size = 0;
 
 	count = 0;
@@ -357,8 +357,8 @@
 {
 	struct iscsi_internal *i = to_iscsi_internal(t);
 
-	attribute_container_unregister(&i->t.target_attrs);
-	attribute_container_unregister(&i->t.host_attrs);
+	transport_container_unregister(&i->t.target_attrs);
+	transport_container_unregister(&i->t.host_attrs);
 
 	kfree(i);
 }
===== drivers/scsi/scsi_transport_spi.c 1.25 vs edited =====
--- 1.25/drivers/scsi/scsi_transport_spi.c	2005-02-01 15:54:44 -05:00
+++ edited/drivers/scsi/scsi_transport_spi.c	2005-02-11 16:19:01 -05:00
@@ -142,13 +142,13 @@
 		return 0;
 
 	shost = dev_to_shost(dev);
-	if (!shost->transportt  || shost->transportt->host_attrs.class
+	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
 	    != &spi_host_class.class)
 		return 0;
 
 	i = to_spi_internal(shost->transportt);
 	
-	return &i->t.host_attrs == cont;
+	return &i->t.host_attrs.ac == cont;
 }
 
 static int spi_device_configure(struct device *dev)
@@ -825,7 +825,7 @@
 
 	sdev = to_scsi_device(dev);
 	shost = sdev->host;
-	if (!shost->transportt  || shost->transportt->host_attrs.class
+	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
 	    != &spi_host_class.class)
 		return 0;
 	/* Note: this class has no device attributes, so it has
@@ -844,13 +844,13 @@
 		return 0;
 
 	shost = dev_to_shost(dev->parent);
-	if (!shost->transportt  || shost->transportt->host_attrs.class
+	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
 	    != &spi_host_class.class)
 		return 0;
 
 	i = to_spi_internal(shost->transportt);
 	
-	return &i->t.target_attrs == cont;
+	return &i->t.target_attrs.ac == cont;
 }
 
 static DECLARE_TRANSPORT_CLASS(spi_transport_class,
@@ -875,15 +875,15 @@
 	memset(i, 0, sizeof(struct spi_internal));
 
 
-	i->t.target_attrs.class = &spi_transport_class.class;
-	i->t.target_attrs.attrs = &i->attrs[0];
-	i->t.target_attrs.match = spi_target_match;
-	attribute_container_register(&i->t.target_attrs);
+	i->t.target_attrs.ac.class = &spi_transport_class.class;
+	i->t.target_attrs.ac.attrs = &i->attrs[0];
+	i->t.target_attrs.ac.match = spi_target_match;
+	transport_container_register(&i->t.target_attrs);
 	i->t.target_size = sizeof(struct spi_transport_attrs);
-	i->t.host_attrs.class = &spi_host_class.class;
-	i->t.host_attrs.attrs = &i->host_attrs[0];
-	i->t.host_attrs.match = spi_host_match;
-	attribute_container_register(&i->t.host_attrs);
+	i->t.host_attrs.ac.class = &spi_host_class.class;
+	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
+	i->t.host_attrs.ac.match = spi_host_match;
+	transport_container_register(&i->t.host_attrs);
 	i->t.host_size = sizeof(struct spi_host_attrs);
 	i->f = ft;
 
@@ -921,8 +921,8 @@
 {
 	struct spi_internal *i = to_spi_internal(t);
 
-	attribute_container_unregister(&i->t.target_attrs);
-	attribute_container_unregister(&i->t.host_attrs);
+	transport_container_unregister(&i->t.target_attrs);
+	transport_container_unregister(&i->t.host_attrs);
 
 	kfree(i);
 }
===== include/linux/transport_class.h 1.1 vs edited =====
--- 1.1/include/linux/transport_class.h	2005-01-18 14:03:33 -05:00
+++ edited/include/linux/transport_class.h	2005-02-11 16:10:39 -05:00
@@ -48,6 +48,14 @@
 #define class_to_transport_class(x) \
 	container_of(x, struct transport_class, class)
 
+struct transport_container {
+	struct attribute_container ac;
+	struct attribute_group *statistics;
+};
+
+#define attribute_container_to_transport_container(x) \
+	container_of(x, struct transport_container, ac)
+
 void transport_remove_device(struct device *);
 void transport_add_device(struct device *);
 void transport_setup_device(struct device *);
@@ -66,6 +74,16 @@
 {
 	transport_remove_device(dev);
 	transport_destroy_device(dev);
+}
+
+static inline int transport_container_register(struct transport_container *tc)
+{
+	return attribute_container_register(&tc->ac);
+}
+
+static inline int transport_container_unregister(struct transport_container *tc)
+{
+	return attribute_container_unregister(&tc->ac);
 }
 
 int transport_class_register(struct transport_class *);
===== include/scsi/scsi_transport.h 1.6 vs edited =====
--- 1.6/include/scsi/scsi_transport.h	2005-01-18 14:15:07 -05:00
+++ edited/include/scsi/scsi_transport.h	2005-02-11 15:56:02 -05:00
@@ -23,13 +23,10 @@
 #include <linux/transport_class.h>
 
 struct scsi_transport_template {
-	/* The statistics attached to the host class only */
-	struct attribute_group *host_statistics;
-
 	/* the attribute containers */
-	struct attribute_container host_attrs;
-	struct attribute_container target_attrs;
-	struct attribute_container device_attrs;
+	struct transport_container host_attrs;
+	struct transport_container target_attrs;
+	struct transport_container device_attrs;
 
 	/* The size of the specific transport attribute structure (a
 	 * space of this size will be left at the end of the


