From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 13:01:40 -0500
Message-ID: <1205604100.6767.43.camel@localhost.localdomain>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
	 <1205590788.6767.12.camel@localhost.localdomain>
	 <1205594256.3109.53.camel@lov.site>
	 <1205597776.6767.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39596 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbYCOSBo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2008 14:01:44 -0400
In-Reply-To: <1205597776.6767.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Sat, 2008-03-15 at 11:16 -0500, James Bottomley wrote:
> On Sat, 2008-03-15 at 16:17 +0100, Kay Sievers wrote:
> > We just need to create something like a "contains" link from the
> > component to the scsi device, and a "enclosure" link at the scsi device
> > back to the component, right?
> 
> Assuming you're moving to the single tree model, then I can easily do
> this:
> 
> <real enclosure device>/<enclosure>/<enclosure component>/device -> link
> to component device
> 
> with a back link in the component device pointing to the enclosure
> component.
> 
> The way components work, probably blowing away enclosure_component_class
> makes the most sense anyway.

OK, so this is the patch doing the above; is this what you had in mind?
We're now managing all the links.

James

---

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index fafb57f..0736cff 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -31,7 +31,6 @@
 static LIST_HEAD(container_list);
 static DEFINE_MUTEX(container_list_lock);
 static struct class enclosure_class;
-static struct class enclosure_component_class;
 
 /**
  * enclosure_find - find an enclosure given a device
@@ -166,6 +165,40 @@ void enclosure_unregister(struct enclosure_device *edev)
 }
 EXPORT_SYMBOL_GPL(enclosure_unregister);
 
+#define ENCLOSURE_NAME_SIZE	64
+
+static void enclosure_link_name(struct enclosure_component *cdev, char *name)
+{
+	strcpy(name, "enclosure_device:");
+	strcat(name, cdev->cdev.bus_id);
+}
+
+static void enclosure_remove_links(struct enclosure_component *cdev)
+{
+	char name[ENCLOSURE_NAME_SIZE];
+
+	enclosure_link_name(cdev, name);
+	sysfs_remove_link(&cdev->dev->kobj, name);
+	sysfs_remove_link(&cdev->cdev.kobj, "device");
+}
+
+static int enclosure_add_links(struct enclosure_component *cdev)
+{
+	int error;
+	char name[ENCLOSURE_NAME_SIZE];
+
+	error = sysfs_create_link(&cdev->cdev.kobj, &cdev->dev->kobj, "device");
+	if (error)
+		return error;
+
+	enclosure_link_name(cdev, name);
+	error = sysfs_create_link(&cdev->dev->kobj, &cdev->cdev.kobj, name);
+	if (error)
+		sysfs_remove_link(&cdev->cdev.kobj, "device");
+
+	return error;
+}
+
 static void enclosure_release(struct device *cdev)
 {
 	struct enclosure_device *edev = to_enclosure_device(cdev);
@@ -178,10 +211,15 @@ static void enclosure_component_release(struct device *dev)
 {
 	struct enclosure_component *cdev = to_enclosure_component(dev);
 
-	put_device(cdev->dev);
+	if (cdev->dev) {
+		enclosure_remove_links(cdev);
+		put_device(cdev->dev);
+	}
 	put_device(dev->parent);
 }
 
+static struct attribute_group *enclosure_groups[];
+
 /**
  * enclosure_component_register - add a particular component to an enclosure
  * @edev:	the enclosure to add the component
@@ -217,12 +255,14 @@ enclosure_component_register(struct enclosure_device *edev,
 	ecomp->number = number;
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
-	cdev->class = &enclosure_component_class;
 	if (name)
 		snprintf(cdev->bus_id, BUS_ID_SIZE, "%s", name);
 	else
 		snprintf(cdev->bus_id, BUS_ID_SIZE, "%u", number);
 
+	cdev->release = enclosure_component_release;
+	cdev->groups = enclosure_groups;
+
 	err = device_register(cdev);
 	if (err)
 		ERR_PTR(err);
@@ -255,10 +295,12 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
 
 	cdev = &edev->component[component];
 
-	device_del(&cdev->cdev);
+	if (cdev->dev)
+		enclosure_remove_links(cdev);
+
 	put_device(cdev->dev);
 	cdev->dev = get_device(dev);
-	return device_add(&cdev->cdev);
+	return enclosure_add_links(cdev);
 }
 EXPORT_SYMBOL_GPL(enclosure_add_device);
 
@@ -442,24 +484,32 @@ static ssize_t get_component_type(struct device *cdev,
 }
 
 
-static struct device_attribute enclosure_component_attrs[] = {
-	__ATTR(fault, S_IRUGO | S_IWUSR, get_component_fault,
-	       set_component_fault),
-	__ATTR(status, S_IRUGO | S_IWUSR, get_component_status,
-	       set_component_status),
-	__ATTR(active, S_IRUGO | S_IWUSR, get_component_active,
-	       set_component_active),
-	__ATTR(locate, S_IRUGO | S_IWUSR, get_component_locate,
-	       set_component_locate),
-	__ATTR(type, S_IRUGO, get_component_type, NULL),
-	__ATTR_NULL
+static DEVICE_ATTR(fault, S_IRUGO | S_IWUSR, get_component_fault,
+		    set_component_fault);
+static DEVICE_ATTR(status, S_IRUGO | S_IWUSR, get_component_status,
+		   set_component_status);
+static DEVICE_ATTR(active, S_IRUGO | S_IWUSR, get_component_active,
+		   set_component_active);
+static DEVICE_ATTR(locate, S_IRUGO | S_IWUSR, get_component_locate,
+		   set_component_locate);
+static DEVICE_ATTR(type, S_IRUGO, get_component_type, NULL);
+
+static struct attribute *enclosure_component_attrs[] = {
+	&dev_attr_fault.attr,
+	&dev_attr_status.attr,
+	&dev_attr_active.attr,
+	&dev_attr_locate.attr,
+	&dev_attr_type.attr,
+	NULL
 };
 
-static struct class enclosure_component_class =  {
-	.name			= "enclosure_component",
-	.owner			= THIS_MODULE,
-	.dev_attrs	= enclosure_component_attrs,
-	.dev_release		= enclosure_component_release,
+static struct attribute_group enclosure_group = {
+	.attrs = enclosure_component_attrs,
+};
+
+static struct attribute_group *enclosure_groups[] = {
+	&enclosure_group,
+	NULL
 };
 
 static int __init enclosure_init(void)
@@ -469,20 +519,12 @@ static int __init enclosure_init(void)
 	err = class_register(&enclosure_class);
 	if (err)
 		return err;
-	err = class_register(&enclosure_component_class);
-	if (err)
-		goto err_out;
 
 	return 0;
- err_out:
-	class_unregister(&enclosure_class);
-
-	return err;
 }
 
 static void __exit enclosure_exit(void)
 {
-	class_unregister(&enclosure_component_class);
 	class_unregister(&enclosure_class);
 }
 


