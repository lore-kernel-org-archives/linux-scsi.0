From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Tue, 05 Feb 2008 20:57:22 -0600
Message-ID: <1202266642.3133.97.camel@localhost.localdomain>
References: <1202074856.3318.111.camel@localhost.localdomain>
	 <20080203220348.GH2648@uranus.ravnborg.org>
	 <1202084211.3318.129.camel@localhost.localdomain>
	 <20080205161218.70af0ff9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44180 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbYBFC52 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 21:57:28 -0500
In-Reply-To: <20080205161218.70af0ff9.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sam@ravnborg.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com

On Tue, 2008-02-05 at 16:12 -0800, Andrew Morton wrote:
> On Sun, 03 Feb 2008 18:16:51 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > 
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date: Sun, 3 Feb 2008 15:40:56 -0600
> > Subject: [SCSI] enclosure: add support for enclosure services
> > 
> > The enclosure misc device is really just a library providing sysfs
> > support for physical enclosure devices and their components.
> > 
> 
> Thanks for sending it out for review.
> 
> > +struct enclosure_device *enclosure_find(struct device *dev)
> > +{
> > +	struct enclosure_device *edev = NULL;
> > +
> > +	mutex_lock(&container_list_lock);
> > +	list_for_each_entry(edev, &container_list, node) {
> > +		if (edev->cdev.dev == dev) {
> > +			mutex_unlock(&container_list_lock);
> > +			return edev;
> > +		}
> > +	}
> > +	mutex_unlock(&container_list_lock);
> > +
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(enclosure_find);
> 
> This looks a little odd.  We don't take a ref on the object after looking
> it up, so what prevents some other thread of control from freeing or
> otherwise altering the returned object while the caller is playing with it?

The use case is for enclosure destruction, so the free should never
happen, but I take the point; I've added a class_device_get().

> > +/**
> > + * enclosure_for_each_device - calls a function for each enclosure
> > + * @fn:		the function to call
> > + * @data:	the data to pass to each call
> > + *
> > + * Loops over all the enclosures calling the function.
> > + *
> > + * Note, this function uses a mutex which will be held across calls to
> > + * @fn, so it must have user context, and @fn should not sleep or
> 
> Probably "non atomic context" would be more accurate.
> 
> fn() actually _can_ sleep.

"should" to me means you don't have to do this but ought to. I'll add a
may (but should not).

> > +	if (!cb) {
> > +		kfree(edev);
> > +		return ERR_PTR(-EINVAL);
> > +	}
> 
> It would be less fuss if this were to test cb before doing the kzalloc().
> 
> Can cb==NULL actually and legitimately happen?

Not really ... I'll make it a BUG_ON.

> > +void enclosure_unregister(struct enclosure_device *edev)
> > +{
> > +	int i;
> > +
> > +	if (!edev)
> > +		return;
> 
> Is this legal?

No ... it'll oops on the null deref later ... I'll remove this.

> > +	mutex_lock(&container_list_lock);
> > +	list_del(&edev->node);
> > +	mutex_unlock(&container_list_lock);
> 
> See, right now, someone who found this enclosure_device via
> enclosure_find() could still be playing with it?

Yes, fixed.

> > +	if (!edev || number >= edev->components)
> > +		return ERR_PTR(-EINVAL);
> 
> Is !edev possible and legitimate?

It shouldn't be, no ... I can remove it.

> > +		snprintf(cdev->class_id, BUS_ID_SIZE, "%d", number);
> 
> %u :)

Nitpicker!

> > +	return snprintf(buf, 40, "%d\n", edev->components);
> > +}
> 
> "40"?

I just followed precedence ;-P

There doesn't seem to be a define for this maximum length, so 40 is the
most commonly picked constant.

> > +static char *enclosure_type [] = {
> > +	[ENCLOSURE_COMPONENT_DEVICE] = "device",
> > +	[ENCLOSURE_COMPONENT_ARRAY_DEVICE] = "array device",
> > +};
> 
> One could play with const here, if sufficiently keen.

One will try to summon up the enthusiasm.

> > +static ssize_t set_component_fault(struct class_device *cdev, const char *buf,
> > +				   size_t count)
> > +{
> > +	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
> > +	struct enclosure_component *ecomp = to_enclosure_component(cdev);
> > +	int val = simple_strtoul(buf, NULL, 0);
> 
> hrm, we do this conversion about 1e99 times in the kernel and we have to go
> and pass three args where only one was needed. katoi()?

Yes ... I'll add it to the todo list.

> > +	for (i = 0; enclosure_status[i]; i++) {
> > +		if (strncmp(buf, enclosure_status[i],
> > +			    strlen(enclosure_status[i])) == 0 &&
> > +		    buf[strlen(enclosure_status[i])] == '\n')
> > +			break;
> > +	}
> 
> So if an application does
> 
> 	write(fd, "foo", 3)
> 
> it won't work?  Thye have to do
> 
> 	write(fd, "foo\n", 4)
> 
> ?

No ... it's designed for echo; however, I'll add a check for '\0' which
will catch the write case.

> > +#define to_enclosure_device(x) container_of((x), struct enclosure_device, cdev)
> > +#define to_enclosure_component(x) container_of((x), struct enclosure_component, cdev)
> 
> These could be C functions...

OK ... I was just following precedence again, but I can make them
inlines.

> Nice looking driver.

Thanks,

James

---

Here's the incremental diff.

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 42e6e43..6fcb0e9 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -39,7 +39,8 @@ static struct class enclosure_component_class;
  *
  * Looks through the list of registered enclosures to see
  * if it can find a match for a device.  Returns NULL if no
- * enclosure is found.
+ * enclosure is found. Obtains a reference to the enclosure class
+ * device which must be released with class_device_put().
  */
 struct enclosure_device *enclosure_find(struct device *dev)
 {
@@ -48,6 +49,7 @@ struct enclosure_device *enclosure_find(struct device *dev)
 	mutex_lock(&container_list_lock);
 	list_for_each_entry(edev, &container_list, node) {
 		if (edev->cdev.dev == dev) {
+			class_device_get(&edev->cdev);
 			mutex_unlock(&container_list_lock);
 			return edev;
 		}
@@ -66,8 +68,9 @@ EXPORT_SYMBOL_GPL(enclosure_find);
  * Loops over all the enclosures calling the function.
  *
  * Note, this function uses a mutex which will be held across calls to
- * @fn, so it must have user context, and @fn should not sleep or
- * otherwise cause the mutex to be held for indefinite periods
+ * @fn, so it must have non atomic context, and @fn may (although it
+ * should not) sleep or otherwise cause the mutex to be held for
+ * indefinite periods
  */
 int enclosure_for_each_device(int (*fn)(struct enclosure_device *, void *),
 			      void *data)
@@ -107,14 +110,11 @@ enclosure_register(struct device *dev, const char *name, int components,
 			GFP_KERNEL);
 	int err, i;
 
+	BUG_ON(!cb);
+
 	if (!edev)
 		return ERR_PTR(-ENOMEM);
 
-	if (!cb) {
-		kfree(edev);
-		return ERR_PTR(-EINVAL);
-	}
-
 	edev->components = components;
 
 	edev->cdev.class = &enclosure_class;
@@ -152,9 +152,6 @@ void enclosure_unregister(struct enclosure_device *edev)
 {
 	int i;
 
-	if (!edev)
-		return;
-
 	mutex_lock(&container_list_lock);
 	list_del(&edev->node);
 	mutex_unlock(&container_list_lock);
@@ -207,7 +204,7 @@ enclosure_component_register(struct enclosure_device *edev,
 	struct class_device *cdev;
 	int err;
 
-	if (!edev || number >= edev->components)
+	if (number >= edev->components)
 		return ERR_PTR(-EINVAL);
 
 	ecomp = &edev->component[number];
@@ -223,7 +220,7 @@ enclosure_component_register(struct enclosure_device *edev,
 	if (name)
 		snprintf(cdev->class_id, BUS_ID_SIZE, "%s", name);
 	else
-		snprintf(cdev->class_id, BUS_ID_SIZE, "%d", number);
+		snprintf(cdev->class_id, BUS_ID_SIZE, "%u", number);
 
 	err = class_device_register(cdev);
 	if (err)
@@ -313,7 +310,7 @@ static struct class enclosure_class = {
 	.class_dev_attrs	= enclosure_attrs,
 };
 
-static char *enclosure_status [] = {
+static const char *const enclosure_status [] = {
 	[ENCLOSURE_STATUS_UNSUPPORTED] = "unsupported",
 	[ENCLOSURE_STATUS_OK] = "OK",
 	[ENCLOSURE_STATUS_CRITICAL] = "critical",
@@ -324,7 +321,7 @@ static char *enclosure_status [] = {
 	[ENCLOSURE_STATUS_UNAVAILABLE] = "unavailable",
 };
 
-static char *enclosure_type [] = {
+static const char *const enclosure_type [] = {
 	[ENCLOSURE_COMPONENT_DEVICE] = "device",
 	[ENCLOSURE_COMPONENT_ARRAY_DEVICE] = "array device",
 };
@@ -371,7 +368,8 @@ static ssize_t set_component_status(struct class_device *cdev, const char *buf,
 	for (i = 0; enclosure_status[i]; i++) {
 		if (strncmp(buf, enclosure_status[i],
 			    strlen(enclosure_status[i])) == 0 &&
-		    buf[strlen(enclosure_status[i])] == '\n')
+		    (buf[strlen(enclosure_status[i])] == '\n' ||
+		     buf[strlen(enclosure_status[i])] == '\0'))
 			break;
 	}
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 2565584..54afb80 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -420,9 +420,11 @@ static int ses_intf_add(struct class_device *cdev,
 
 	if (!scsi_device_enclosure(sdev)) {
 		/* not an enclosure, but might be in one */
-		edev = 	enclosure_find(&sdev->host->shost_gendev);
-		if (edev)
+		edev = 	enclosure_find(&sdev->host->shost_gendev); 
+		if (edev) {
 			ses_match_to_enclosure(edev, sdev);
+			class_device_put(&edev->cdev);
+		}
 		return -ENODEV;
 	}
 
@@ -634,6 +636,7 @@ static void ses_intf_remove(struct class_device *cdev,
 
 	kfree(edev->component[0].scratch);
 
+	class_device_put(&edev->cdev);
 	enclosure_unregister(edev);
 }
 
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index 622177a..a5978f1 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -100,8 +100,17 @@ struct enclosure_device {
 	struct enclosure_component component[0];
 };
 
-#define to_enclosure_device(x) container_of((x), struct enclosure_device, cdev)
-#define to_enclosure_component(x) container_of((x), struct enclosure_component, cdev)
+static inline struct enclosure_device *
+to_enclosure_device(struct class_device *dev)
+{
+	return container_of(dev, struct enclosure_device, cdev);
+}
+
+static inline struct enclosure_component *
+to_enclosure_component(struct class_device *dev)
+{
+	return container_of(dev, struct enclosure_component, cdev);
+}
 
 struct enclosure_device *
 enclosure_register(struct device *, const char *, int,


