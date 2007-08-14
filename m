From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] add container release logic - update fc transport to
	utilize it
Date: Tue, 14 Aug 2007 18:27:29 +0000 (UTC)
Message-ID: <1187266579.2918.15.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63294 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884AbXHNS1U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 14:27:20 -0400
Date: Thu, 16 Aug 2007 08:16:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.scsi.org
Cc: tore@linepro.no, james.bottomley@steeleye.com

Consistent with the code in the rest of the transports, when the driver
module attached or detached to a transport, the transport ignored the
statuses from transport_container_register() and transport_container_unregister().
This was particularly bad on the unregister path, because the transport would
free the transport-internal structure that held all the attribute 
containers. Thus, if a driver was told to unload, and the unload path
completed faster than the tear down of the scsi object tree (as a sysfs attribute
was in use at the time, or whatever), you could get into ugly reuse of a freed
internal structure. 

Given that this is a module-global thing, there's no real relationship to
the create/release (or refcounting) of the device objects that eventually
bind to the structure.

I modified the container logic to potentially call back the container owner
whenever all objects on the container were freed. This allowed the release to
happen in the background to the LLDD removal.

Assuming this is how we want to handle this scenario, the other SCSI transports
need to be updated accordingly.

-- james s

This patch was cut against 2.6.23-rc3

Signed-off-by: James Smart <James.Smart@emulex.com>

diff -upNr a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c	2007-08-16 02:59:50.000000000 -0400
+++ b/drivers/base/attribute_container.c	2007-08-16 07:27:23.000000000 -0400
@@ -97,6 +97,8 @@ attribute_container_unregister(struct at
 	int retval = -EBUSY;
 	mutex_lock(&attribute_container_mutex);
 	spin_lock(&cont->containers.k_lock);
+	if (cont->release)
+		cont->flags |= ATTRIBUTE_CONTAINER_RELEASE_PENDING;
 	if (!list_empty(&cont->containers.k_list))
 		goto out;
 	retval = 0;
@@ -104,6 +106,8 @@ attribute_container_unregister(struct at
  out:
 	spin_unlock(&cont->containers.k_lock);
 	mutex_unlock(&attribute_container_mutex);
+	if ((retval == 0) && (cont->release))
+		cont->release(cont->release_arg, cont);
 	return retval;
 		
 }
@@ -212,6 +216,7 @@ attribute_container_remove_device(struct
 {
 	struct attribute_container *cont;
 
+rmv_restart:
 	mutex_lock(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
 		struct internal_container *ic;
@@ -234,6 +239,13 @@ attribute_container_remove_device(struct
 				class_device_unregister(&ic->classdev);
 			}
 		}
+
+		if ((cont->flags & ATTRIBUTE_CONTAINER_RELEASE_PENDING)
+		    && list_empty(&cont->containers.k_list)) {
+			mutex_unlock(&attribute_container_mutex);
+			cont->release(cont->release_arg, cont);
+			goto rmv_restart;
+		}
 	}
 	mutex_unlock(&attribute_container_mutex);
 }
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2007-08-16 03:00:03.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2007-08-16 07:29:03.000000000 -0400
@@ -314,6 +314,11 @@ static void fc_scsi_scan_rport(struct wo
 struct fc_internal {
 	struct scsi_transport_template t;
 	struct fc_function_template *f;
+#define FCI_STARGET_CONTAINER		0x01
+#define FCI_SHOST_CONTAINER		0x02
+#define FCI_RPORT_CONTAINER		0x04
+#define FCI_VPORT_CONTAINER		0x08
+	u32 active_containers;
 
 	/*
 	 * For attributes : each object has :
@@ -1956,10 +1961,31 @@ static int fc_user_scan(struct Scsi_Host
 	return 0;
 }
 
+void
+fc_transport_container_release(void *arg, struct attribute_container *cont)
+{
+	struct fc_internal *i = arg;
+
+	if (cont == &i->t.target_attrs.ac)
+		i->active_containers &= ~FCI_STARGET_CONTAINER;
+
+	if (cont == &i->t.host_attrs.ac)
+		i->active_containers &= ~FCI_SHOST_CONTAINER;
+
+	if (cont == &i->rport_attr_cont.ac)
+		i->active_containers &= ~FCI_RPORT_CONTAINER;
+
+	if (cont == &i->vport_attr_cont.ac)
+		i->active_containers &= ~FCI_VPORT_CONTAINER;
+
+	if (i->active_containers == 0)
+		kfree(i);
+}
+
 struct scsi_transport_template *
 fc_attach_transport(struct fc_function_template *ft)
 {
-	int count;
+	int count, err;
 	struct fc_internal *i = kzalloc(sizeof(struct fc_internal),
 					GFP_KERNEL);
 
@@ -1969,26 +1995,58 @@ fc_attach_transport(struct fc_function_t
 	i->t.target_attrs.ac.attrs = &i->starget_attrs[0];
 	i->t.target_attrs.ac.class = &fc_transport_class.class;
 	i->t.target_attrs.ac.match = fc_target_match;
+	i->t.target_attrs.ac.release = fc_transport_container_release;
+	i->t.target_attrs.ac.release_arg = i;
 	i->t.target_size = sizeof(struct fc_starget_attrs);
-	transport_container_register(&i->t.target_attrs);
+	err = transport_container_register(&i->t.target_attrs);
+	if (err)
+		printk(KERN_WARNING
+			"%s: Unable to register Target attribute container"
+			" - err %d\n", __FUNCTION__, err);
+	else
+		i->active_containers |= FCI_STARGET_CONTAINER;
 
 	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
 	i->t.host_attrs.ac.class = &fc_host_class.class;
 	i->t.host_attrs.ac.match = fc_host_match;
+	i->t.host_attrs.ac.release = fc_transport_container_release;
+	i->t.host_attrs.ac.release_arg = i;
 	i->t.host_size = sizeof(struct fc_host_attrs);
 	if (ft->get_fc_host_stats)
 		i->t.host_attrs.statistics = &fc_statistics_group;
-	transport_container_register(&i->t.host_attrs);
+	err = transport_container_register(&i->t.host_attrs);
+	if (err)
+		printk(KERN_WARNING
+			"%s: Unable to register shost attribute container"
+			" - err %d\n", __FUNCTION__, err);
+	else
+		i->active_containers |= FCI_SHOST_CONTAINER;
 
 	i->rport_attr_cont.ac.attrs = &i->rport_attrs[0];
 	i->rport_attr_cont.ac.class = &fc_rport_class.class;
 	i->rport_attr_cont.ac.match = fc_rport_match;
-	transport_container_register(&i->rport_attr_cont);
+	i->rport_attr_cont.ac.release = fc_transport_container_release;
+	i->rport_attr_cont.ac.release_arg = i;
+	err = transport_container_register(&i->rport_attr_cont);
+	if (err)
+		printk(KERN_WARNING
+			"%s: Unable to register Rport attribute container"
+			" - err %d\n", __FUNCTION__, err);
+	else
+		i->active_containers |= FCI_RPORT_CONTAINER;
 
 	i->vport_attr_cont.ac.attrs = &i->vport_attrs[0];
 	i->vport_attr_cont.ac.class = &fc_vport_class.class;
 	i->vport_attr_cont.ac.match = fc_vport_match;
-	transport_container_register(&i->vport_attr_cont);
+	i->vport_attr_cont.ac.release = fc_transport_container_release;
+	i->vport_attr_cont.ac.release_arg = i;
+	err = transport_container_register(&i->vport_attr_cont);
+	if (err)
+		printk(KERN_WARNING
+			"%s: Unable to register Vport attribute container"
+			" - err %d\n", __FUNCTION__, err);
+	else
+		i->active_containers |= FCI_VPORT_CONTAINER;
 
 	i->f = ft;
 
@@ -2102,7 +2160,12 @@ void fc_release_transport(struct scsi_tr
 	transport_container_unregister(&i->rport_attr_cont);
 	transport_container_unregister(&i->vport_attr_cont);
 
-	kfree(i);
+	/*
+	 * The fc_internal struct will be freed after the last
+	 * attribute container gets freed. Containers may stick
+	 * around if they are in use at the time we release the
+	 * transport.
+	 */
 }
 EXPORT_SYMBOL(fc_release_transport);
 
diff -upNr a/include/linux/attribute_container.h b/include/linux/attribute_container.h
--- a/include/linux/attribute_container.h	2007-08-16 03:00:10.000000000 -0400
+++ b/include/linux/attribute_container.h	2007-08-16 06:12:42.000000000 -0400
@@ -19,7 +19,10 @@ struct attribute_container {
 	struct class		*class;
 	struct class_device_attribute **attrs;
 	int (*match)(struct attribute_container *, struct device *);
+	void (*release)(void *, struct attribute_container *);
+	void *release_arg;
 #define	ATTRIBUTE_CONTAINER_NO_CLASSDEVS	0x01
+#define	ATTRIBUTE_CONTAINER_RELEASE_PENDING	0x02
 	unsigned long		flags;
 };
 


