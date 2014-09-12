From: Song Liu <songliubraving@fb.com>
Subject: RE: [PATCH 5/5] SES: Add power_status to SES enclosure component
Date: Fri, 12 Sep 2014 21:08:31 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBC5B094@PRN-MBX02-4.TheFacebook.com>
References: <1408987546-2418-1-git-send-email-songliubraving@fb.com>
 <1408987546-2418-6-git-send-email-songliubraving@fb.com>
 <C709E4D363AAB64590BFAC54D4C478AAEBC4ABD3@PRN-MBX02-4.TheFacebook.com>
 <54081BAA.1070304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62896 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032AbaILVIh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 17:08:37 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@fb.com>

=46rom 53549716d9f965e59f3a84feb5ebae9d18232b52 Mon Sep 17 00:00:00 200=
1
=46rom: Song Liu <songliubraving@fb.com>
Date: Tue, 19 Aug 2014 23:58:58 -0700
Subject: [PATCH 5/5] SES: Add power_status to SES enclosure component

Add power_status to SES enclosure component, so we can power on/off the
HDDs behind the enclosure.

Check firmware status in ses_set_* before sending control pages to
firmware.

Signed-off-by: Song Liu <songliubraving@fb.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/misc/enclosure.c  | 38 ++++++++++++++++++
 drivers/scsi/ses.c        | 98 +++++++++++++++++++++++++++++++++++++++=
+++-----
 include/linux/enclosure.h |  6 +++
 3 files changed, 133 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 2e3eafa..819f2f2 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -148,6 +148,7 @@ enclosure_register(struct device *dev, const char *=
name, int components,
 	for (i =3D 0; i < components; i++) {
 		edev->component[i].number =3D -1;
 		edev->component[i].slot =3D -1;
+		edev->component[i].power_status =3D 1;
 	}
=20
 	mutex_lock(&container_list_lock);
@@ -546,6 +547,40 @@ static ssize_t set_component_locate(struct device =
*cdev,
 	return count;
 }
=20
+static ssize_t get_component_power_status(struct device *cdev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct enclosure_device *edev =3D to_enclosure_device(cdev->parent);
+	struct enclosure_component *ecomp =3D to_enclosure_component(cdev);
+
+	if (edev->cb->get_power_status)
+		edev->cb->get_power_status(edev, ecomp);
+	return snprintf(buf, 40, "%s\n", ecomp->power_status ? "on" : "off");
+}
+
+static ssize_t set_component_power_status(struct device *cdev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct enclosure_device *edev =3D to_enclosure_device(cdev->parent);
+	struct enclosure_component *ecomp =3D to_enclosure_component(cdev);
+	int val;
+
+	if (strncmp(buf, "on", 2) =3D=3D 0 &&
+	    (buf[2] =3D=3D '\n' || buf[2] =3D=3D '\0'))
+		val =3D 1;
+	else if (strncmp(buf, "off", 3) =3D=3D 0 &&
+	    (buf[3] =3D=3D '\n' || buf[3] =3D=3D '\0'))
+		val =3D 0;
+	else
+		return -EINVAL;
+
+	if (edev->cb->set_power_status)
+		edev->cb->set_power_status(edev, ecomp, val);
+	return count;
+}
+
 static ssize_t get_component_type(struct device *cdev,
 				  struct device_attribute *attr, char *buf)
 {
@@ -577,6 +612,8 @@ static DEVICE_ATTR(active, S_IRUGO | S_IWUSR, get_c=
omponent_active,
 		   set_component_active);
 static DEVICE_ATTR(locate, S_IRUGO | S_IWUSR, get_component_locate,
 		   set_component_locate);
+static DEVICE_ATTR(power_status, S_IRUGO | S_IWUSR, get_component_powe=
r_status,
+		   set_component_power_status);
 static DEVICE_ATTR(type, S_IRUGO, get_component_type, NULL);
 static DEVICE_ATTR(slot, S_IRUGO, get_component_slot, NULL);
=20
@@ -585,6 +622,7 @@ static struct attribute *enclosure_component_attrs[=
] =3D {
 	&dev_attr_status.attr,
 	&dev_attr_active.attr,
 	&dev_attr_locate.attr,
+	&dev_attr_power_status.attr,
 	&dev_attr_type.attr,
 	&dev_attr_slot.attr,
 	NULL
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 3e59a5d..8ba3c78 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -67,6 +67,20 @@ static int ses_probe(struct device *dev)
 #define SES_TIMEOUT (30 * HZ)
 #define SES_RETRIES 3
=20
+static void init_device_slot_control(unsigned char *dest_desc,
+				     struct enclosure_component *ecomp,
+				     unsigned char *status)
+{
+	memcpy(dest_desc, status, 4);
+	dest_desc[0] =3D 0;
+	/* only clear byte 1 for ENCLOSURE_COMPONENT_DEVICE */
+	if (ecomp->type =3D=3D ENCLOSURE_COMPONENT_DEVICE)
+		dest_desc[1] =3D 0;
+	dest_desc[2] &=3D 0xde;
+	dest_desc[3] &=3D 0x3c;
+}
+
+
 static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
@@ -178,14 +192,22 @@ static int ses_set_fault(struct enclosure_device =
*edev,
 			  struct enclosure_component *ecomp,
 			 enum enclosure_component_setting val)
 {
-	unsigned char desc[4] =3D {0 };
+	unsigned char desc[4];
+	unsigned char *desc_ptr;
+
+	desc_ptr =3D ses_get_page2_descriptor(edev, ecomp);
+
+	if (!desc_ptr)
+		return -EIO;
+
+	init_device_slot_control(desc, ecomp, desc_ptr);
=20
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
-		/* zero is disabled */
+		desc[3] &=3D 0xdf;
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[3] =3D 0x20;
+		desc[3] |=3D 0x20;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */
@@ -219,14 +241,22 @@ static int ses_set_locate(struct enclosure_device=
 *edev,
 			  struct enclosure_component *ecomp,
 			  enum enclosure_component_setting val)
 {
-	unsigned char desc[4] =3D {0 };
+	unsigned char desc[4];
+	unsigned char *desc_ptr;
+
+	desc_ptr =3D ses_get_page2_descriptor(edev, ecomp);
+
+	if (!desc_ptr)
+		return -EIO;
+
+	init_device_slot_control(desc, ecomp, desc_ptr);
=20
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
-		/* zero is disabled */
+		desc[2] &=3D 0xfd;
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] =3D 0x02;
+		desc[2] |=3D 0x02;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */
@@ -239,15 +269,23 @@ static int ses_set_active(struct enclosure_device=
 *edev,
 			  struct enclosure_component *ecomp,
 			  enum enclosure_component_setting val)
 {
-	unsigned char desc[4] =3D {0 };
+	unsigned char desc[4];
+	unsigned char *desc_ptr;
+
+	desc_ptr =3D ses_get_page2_descriptor(edev, ecomp);
+
+	if (!desc_ptr)
+		return -EIO;
+
+	init_device_slot_control(desc, ecomp, desc_ptr);
=20
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
-		/* zero is disabled */
+		desc[2] &=3D 0x7f;
 		ecomp->active =3D 0;
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] =3D 0x80;
+		desc[2] |=3D 0x80;
 		ecomp->active =3D 1;
 		break;
 	default:
@@ -265,12 +303,53 @@ static int ses_show_id(struct enclosure_device *e=
dev, char *buf)
 	return sprintf(buf, "%#llx\n", id);
 }
=20
+static void ses_get_power_status(struct enclosure_device *edev,
+				 struct enclosure_component *ecomp)
+{
+	unsigned char *desc;
+
+	desc =3D ses_get_page2_descriptor(edev, ecomp);
+	if (desc)
+		ecomp->power_status =3D (desc[3] & 0x10) ? 0 : 1;
+}
+
+static int ses_set_power_status(struct enclosure_device *edev,
+				struct enclosure_component *ecomp,
+				int val)
+{
+	unsigned char desc[4];
+	unsigned char *desc_ptr;
+
+	desc_ptr =3D ses_get_page2_descriptor(edev, ecomp);
+
+	if (!desc_ptr)
+		return -EIO;
+
+	init_device_slot_control(desc, ecomp, desc_ptr);
+
+	switch (val) {
+	/* power =3D 1 is device_off =3D 0 and vice versa */
+	case 0:
+		desc[3] |=3D 0x10;
+		break;
+	case 1:
+		desc[3] &=3D 0xef;
+		break;
+	default:
+		return -EINVAL;
+	}
+	ecomp->power_status =3D val;
+	return ses_set_page2_descriptor(edev, ecomp, desc);
+}
+
 static struct enclosure_component_callbacks ses_enclosure_callbacks =3D=
 {
 	.get_fault		=3D ses_get_fault,
 	.set_fault		=3D ses_set_fault,
 	.get_status		=3D ses_get_status,
 	.get_locate		=3D ses_get_locate,
 	.set_locate		=3D ses_set_locate,
+	.get_power_status	=3D ses_get_power_status,
+	.set_power_status	=3D ses_set_power_status,
 	.set_active		=3D ses_set_active,
 	.show_id		=3D ses_show_id,
 };
@@ -449,6 +528,7 @@ static void ses_enclosure_data_process(struct enclo=
sure_device *edev,
 					ecomp =3D &edev->component[components++];
=20
 				if (!IS_ERR(ecomp)) {
+					ses_get_power_status(edev, ecomp);
 					if (addl_desc_ptr)
 						ses_process_descriptor(
 							ecomp,
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index 0f826c1..7be22da 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -79,6 +79,11 @@ struct enclosure_component_callbacks {
 	int (*set_locate)(struct enclosure_device *,
 			  struct enclosure_component *,
 			  enum enclosure_component_setting);
+	void (*get_power_status)(struct enclosure_device *,
+				 struct enclosure_component *);
+	int (*set_power_status)(struct enclosure_device *,
+				struct enclosure_component *,
+				int);
 	int (*show_id)(struct enclosure_device *, char *buf);
 };
=20
@@ -94,6 +99,7 @@ struct enclosure_component {
 	int locate;
 	int slot;
 	enum enclosure_status status;
+	int power_status;
 };
=20
 struct enclosure_device {
--=20
1.8.1

> -----Original Message-----
> From: Song Liu
> Sent: Friday, September 12, 2014 2:08 PM
> To: 'Hannes Reinecke'; linux-scsi@vger.kernel.org
> Cc: Dan Williams; Jens Axboe
> Subject: RE: [PATCH 5/5] SES: Add power_status to SES enclosure compo=
nent
>=20
> New patch in next email...
>=20
> Change to let power_status show "on" or "off"
>=20
> Initialization of desc was removed because it will be initialized in
> init_device_slot_control, so no need to initialize at define.
>=20
> Thanks,
> Song
>=20
> > -----Original Message-----
> > From: Hannes Reinecke [mailto:hare@suse.de]
> > Sent: Thursday, September 4, 2014 12:59 AM
> > To: Song Liu; linux-scsi@vger.kernel.org
> > Cc: Dan Williams; Jens Axboe
> > Subject: Re: [PATCH 5/5] SES: Add power_status to SES enclosure
> > component
> >
> > On 08/25/2014 07:34 PM, Song Liu wrote:
> > > From: Song Liu [mailto:songliubraving@fb.com]
> > > Sent: Monday, August 25, 2014 10:26 AM
> > > To: Song Liu
> > > Cc: Hannes Reinecke
> > > Subject: [PATCH 5/5] SES: Add power_status to SES enclosure
> > > component
> > >
> > > Add power_status to SES enclosure component, so we can power on/o=
ff
> > the HDDs behind the enclosure.
> > >
> > > Check firmware status in ses_set_* before sending control pages t=
o
> > firmware.
> > >
> > > Signed-off-by: Song Liu <songliubraving@fb.com>
> > > Acked-by: Dan Williams <dan.j.williams@intel.com>
> > > Reviewed-by: Jens Axboe <axboe@fb.com>
> > > Cc: Hannes Reinecke <hare@suse.de>
> > > ---
> > >  drivers/misc/enclosure.c  | 29 ++++++++++++++
> > >  drivers/scsi/ses.c        | 98
> > ++++++++++++++++++++++++++++++++++++++++++-----
> > >  include/linux/enclosure.h |  6 +++
> > >  3 files changed, 124 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> > > index de335bc..0331dfe 100644
> > > --- a/drivers/misc/enclosure.c
> > > +++ b/drivers/misc/enclosure.c
> > > @@ -148,6 +148,7 @@ enclosure_register(struct device *dev, const
> > > char
> > *name, int components,
> > >  	for (i =3D 0; i < components; i++) {
> > >  		edev->component[i].number =3D -1;
> > >  		edev->component[i].slot =3D -1;
> > > +		edev->component[i].power_status =3D 1;
> > >  	}
> > >
> > >  	mutex_lock(&container_list_lock);
> > > @@ -546,6 +547,31 @@ static ssize_t set_component_locate(struct
> > device *cdev,
> > >  	return count;
> > >  }
> > >
> > > +static ssize_t get_component_power_status(struct device *cdev,
> > > +					  struct device_attribute *attr,
> > > +					  char *buf)
> > > +{
> > > +	struct enclosure_device *edev =3D to_enclosure_device(cdev->par=
ent);
> > > +	struct enclosure_component *ecomp =3D
> > to_enclosure_component(cdev);
> > > +
> > > +	if (edev->cb->get_power_status)
> > > +		edev->cb->get_power_status(edev, ecomp);
> > > +	return snprintf(buf, 40, "%d\n", ecomp->power_status); }
> > > +
> > > +static ssize_t set_component_power_status(struct device *cdev,
> > > +					  struct device_attribute *attr,
> > > +					  const char *buf, size_t count) {
> > > +	struct enclosure_device *edev =3D to_enclosure_device(cdev->par=
ent);
> > > +	struct enclosure_component *ecomp =3D
> > to_enclosure_component(cdev);
> > > +	int val =3D simple_strtoul(buf, NULL, 0);
> > > +
> > > +	if (edev->cb->set_power_status)
> > > +		edev->cb->set_power_status(edev, ecomp, val);
> > > +	return count;
> > > +}
> > > +
> > Just using a number here doesn't seem to be very instructive; what =
is
> > this number? Can't we have a decode setting here to allow even the
> > uninitiated to do some sensible decisions here?
> >
> > >  static ssize_t get_component_type(struct device *cdev,
> > >  				  struct device_attribute *attr, char *buf)
> > { @@ -577,6 +603,8 @@ static DEVICE_ATTR(active, S_IRUGO | S_IWUSR,
> > get_component_active,
> > >  		   set_component_active);
> > >  static DEVICE_ATTR(locate, S_IRUGO | S_IWUSR,
> get_component_locate,
> > >  		   set_component_locate);
> > > +static DEVICE_ATTR(power_status, S_IRUGO | S_IWUSR,
> > get_component_power_status,
> > > +		   set_component_power_status);
> > >  static DEVICE_ATTR(type, S_IRUGO, get_component_type, NULL);
> > > static DEVICE_ATTR(slot, S_IRUGO, get_component_slot, NULL);
> > >
> > > @@ -585,6 +613,7 @@ static struct attribute
> > *enclosure_component_attrs[] =3D {
> > >  	&dev_attr_status.attr,
> > >  	&dev_attr_active.attr,
> > >  	&dev_attr_locate.attr,
> > > +	&dev_attr_power_status.attr,
> > >  	&dev_attr_type.attr,
> > >  	&dev_attr_slot.attr,
> > >  	NULL
> > > diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index
> > > bafa301..ea6b262 100644
> > > --- a/drivers/scsi/ses.c
> > > +++ b/drivers/scsi/ses.c
> > > @@ -67,6 +67,20 @@ static int ses_probe(struct device *dev)  #def=
ine
> > > SES_TIMEOUT (30 * HZ)  #define SES_RETRIES 3
> > >
> > > +static void init_device_slot_control(unsigned char *dest_desc,
> > > +				     struct enclosure_component *ecomp,
> > > +				     unsigned char *status)
> > > +{
> > > +	memcpy(dest_desc, status, 4);
> > > +	dest_desc[0] =3D 0;
> > > +	/* only clear byte 1 for ENCLOSURE_COMPONENT_DEVICE */
> > > +	if (ecomp->type =3D=3D ENCLOSURE_COMPONENT_DEVICE)
> > > +		dest_desc[1] =3D 0;
> > > +	dest_desc[2] &=3D 0xde;
> > > +	dest_desc[3] &=3D 0x3c;
> > > +}
> > > +
> > > +
> > >  static int ses_recv_diag(struct scsi_device *sdev, int page_code=
,
> > >  			 void *buf, int bufflen)
> > >  {
> > > @@ -178,14 +192,22 @@ static int ses_set_fault(struct
> > > enclosure_device
> > *edev,
> > >  			  struct enclosure_component *ecomp,
> > >  			 enum enclosure_component_setting val)  {
> > > -	unsigned char desc[4] =3D {0 };
> > > +	unsigned char desc[4];
> > > +	unsigned char *desc_ptr;
> > > +
> > > +	desc_ptr =3D ses_get_page2_descriptor(edev, ecomp);
> > > +
> > > +	if (!desc_ptr)
> > > +		return -EIO;
> > > +
> > > +	init_device_slot_control(desc, ecomp, desc_ptr);
> > >
> > >  	switch (val) {
> > >  	case ENCLOSURE_SETTING_DISABLED:
> > > -		/* zero is disabled */
> > > +		desc[3] &=3D 0xdf;
> > >  		break;
> > >  	case ENCLOSURE_SETTING_ENABLED:
> > > -		desc[3] =3D 0x20;
> > > +		desc[3] |=3D 0x20;
> > >  		break;
> > >  	default:
> > >  		/* SES doesn't do the SGPIO blink settings */ @@ -219,14
> > +241,22 @@
> > > static int ses_set_locate(struct enclosure_device *edev,
> > Hmm? Garbled patch?
> >
> > >  			  struct enclosure_component *ecomp,
> > >  			  enum enclosure_component_setting val)  {
> > > -	unsigned char desc[4] =3D {0 };
> > > +	unsigned char desc[4];
> > Why did you remove the initialisation here?
> >
> > > +	unsigned char *desc_ptr;
> > > +
> > > +	desc_ptr =3D ses_get_page2_descriptor(edev, ecomp);
> > > +
> > > +	if (!desc_ptr)
> > > +		return -EIO;
> > > +
> > > +	init_device_slot_control(desc, ecomp, desc_ptr);
> > >
> > >  	switch (val) {
> > >  	case ENCLOSURE_SETTING_DISABLED:
> > > -		/* zero is disabled */
> > > +		desc[2] &=3D 0xfd;
> > >  		break;
> > >  	case ENCLOSURE_SETTING_ENABLED:
> > > -		desc[2] =3D 0x02;
> > > +		desc[2] |=3D 0x02;
> > >  		break;
> > >  	default:
> > >  		/* SES doesn't do the SGPIO blink settings */ @@ -239,15
> > +269,23 @@ static int ses_set_active(struct enclosure_device *edev,
> > >  			  struct enclosure_component *ecomp,
> > >  			  enum enclosure_component_setting val)  {
> > > -	unsigned char desc[4] =3D {0 };
> > > +	unsigned char desc[4];
> > > +	unsigned char *desc_ptr;
> > > +
> > > +	desc_ptr =3D ses_get_page2_descriptor(edev, ecomp);
> > > +
> > > +	if (!desc_ptr)
> > > +		return -EIO;
> > > +
> > > +	init_device_slot_control(desc, ecomp, desc_ptr);
> > >
> > >  	switch (val) {
> > >  	case ENCLOSURE_SETTING_DISABLED:
> > > -		/* zero is disabled */
> > > +		desc[2] &=3D 0x7f;
> > >  		ecomp->active =3D 0;
> > >  		break;
> > >  	case ENCLOSURE_SETTING_ENABLED:
> > > -		desc[2] =3D 0x80;
> > > +		desc[2] |=3D 0x80;
> > >  		ecomp->active =3D 1;
> > >  		break;
> > >  	default:
> > > @@ -265,12 +303,53 @@ static int ses_show_id(struct enclosure_dev=
ice
> > *edev, char *buf)
> > >  	return sprintf(buf, "%#llx\n", id);  }
> > >
> > > +static void ses_get_power_status(struct enclosure_device *edev,
> > > +				 struct enclosure_component *ecomp) {
> > > +	unsigned char *desc;
> > > +
> > > +	desc =3D ses_get_page2_descriptor(edev, ecomp);
> > > +	if (desc)
> > > +		ecomp->power_status =3D (desc[3] & 0x10) ? 0 : 1; }
> > > +
> > > +static int ses_set_power_status(struct enclosure_device *edev,
> > > +				struct enclosure_component *ecomp,
> > > +				int val)
> > > +{
> > > +	unsigned char desc[4];
> > > +	unsigned char *desc_ptr;
> > > +
> > > +	desc_ptr =3D ses_get_page2_descriptor(edev, ecomp);
> > > +
> > > +	if (!desc_ptr)
> > > +		return -EIO;
> > > +
> > > +	init_device_slot_control(desc, ecomp, desc_ptr);
> > > +
> > > +	switch (val) {
> > > +	/* power =3D 1 is device_off =3D 0 and vice versa */
> > > +	case 0:
> > > +		desc[3] |=3D 0x10;
> > > +		break;
> > > +	case 1:
> > > +		desc[3] &=3D 0xef;
> > > +		break;
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +	ecomp->power_status =3D val;
> > > +	return ses_set_page2_descriptor(edev, ecomp, desc); }
> > > +
> > >  static struct enclosure_component_callbacks ses_enclosure_callba=
cks =3D
> {
> > >  	.get_fault		=3D ses_get_fault,
> > >  	.set_fault		=3D ses_set_fault,
> > >  	.get_status		=3D ses_get_status,
> > >  	.get_locate		=3D ses_get_locate,
> > >  	.set_locate		=3D ses_set_locate,
> > > +	.get_power_status	=3D ses_get_power_status,
> > > +	.set_power_status	=3D ses_set_power_status,
> > >  	.set_active		=3D ses_set_active,
> > >  	.show_id		=3D ses_show_id,
> > >  };
> > > @@ -448,6 +527,7 @@ static void ses_enclosure_data_process(struct
> > enclosure_device *edev,
> > >  					ecomp =3D &edev-
> > >component[components++];
> > >
> > >  				if (!IS_ERR(ecomp)) {
> > > +					ses_get_power_status(edev, ecomp);
> > >  					if (addl_desc_ptr)
> > >
> > 	ses_process_descriptor(ecomp,
> > >
> > addl_desc_ptr);
> > > diff --git a/include/linux/enclosure.h b/include/linux/enclosure.=
h
> > > index 0f826c1..7be22da 100644
> > > --- a/include/linux/enclosure.h
> > > +++ b/include/linux/enclosure.h
> > > @@ -79,6 +79,11 @@ struct enclosure_component_callbacks {
> > >  	int (*set_locate)(struct enclosure_device *,
> > >  			  struct enclosure_component *,
> > >  			  enum enclosure_component_setting);
> > > +	void (*get_power_status)(struct enclosure_device *,
> > > +				 struct enclosure_component *);
> > > +	int (*set_power_status)(struct enclosure_device *,
> > > +				struct enclosure_component *,
> > > +				int);
> > >  	int (*show_id)(struct enclosure_device *, char *buf);  };
> > >
> > > @@ -94,6 +99,7 @@ struct enclosure_component {
> > >  	int locate;
> > >  	int slot;
> > >  	enum enclosure_status status;
> > > +	int power_status;
> > >  };
> > >
> > >  struct enclosure_device {
> > > --
> > > 1.8.1
> > >
> > Cheers,
> >
> > Hannes
> > --
> > Dr. Hannes Reinecke		      zSeries & Storage
> > hare@suse.de			      +49 911 74053 688
> > SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> > GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
