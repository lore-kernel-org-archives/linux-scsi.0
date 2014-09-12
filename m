From: Song Liu <songliubraving@fb.com>
Subject: RE: [PATCH 3/5] SES: add enclosure logical id
Date: Fri, 12 Sep 2014 21:04:16 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBC5B03F@PRN-MBX02-4.TheFacebook.com>
References: <1408987546-2418-1-git-send-email-songliubraving@fb.com>
 <1408987546-2418-4-git-send-email-songliubraving@fb.com>
 <C709E4D363AAB64590BFAC54D4C478AAEBC4ABC4@PRN-MBX02-4.TheFacebook.com>
 <54081ABD.9080104@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25825 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbaILVEW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 17:04:22 -0400
In-Reply-To: <54081ABD.9080104@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@fb.com>

=46rom 849dd255bdd2158cb621697e41448cf6b230d2f4 Mon Sep 17 00:00:00 200=
1
=46rom: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Aug 2014 11:43:24 -0700
Subject: [PATCH 3/5] SES: add enclosure logical id

Export the NAA logical id for the enclosure.  This is optionally
available from the sas_transport_class, but it is really a property of
the enclosure.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/misc/enclosure.c  | 13 +++++++++++++
 drivers/scsi/ses.c        |  9 +++++++++
 include/linux/enclosure.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 15faf61..18b87de 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -395,8 +395,21 @@ static ssize_t components_show(struct device *cdev=
,
 }
 static DEVICE_ATTR_RO(components);
=20
+static ssize_t id_show(struct device *cdev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct enclosure_device *edev =3D to_enclosure_device(cdev);
+
+	if (edev->cb->show_id)
+		return edev->cb->show_id(edev, buf);
+	return -EINVAL;
+}
+static DEVICE_ATTR_RO(id);
+
 static struct attribute *enclosure_class_attrs[] =3D {
 	&dev_attr_components.attr,
+	&dev_attr_id.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(enclosure_class);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 87cf970b..696d5d8 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -258,6 +258,14 @@ static int ses_set_active(struct enclosure_device =
*edev,
 	return ses_set_page2_descriptor(edev, ecomp, desc);
 }
=20
+static int ses_show_id(struct enclosure_device *edev, char *buf)
+{
+	struct ses_device *ses_dev =3D edev->scratch;
+	unsigned long long id =3D get_unaligned_be64(ses_dev->page1+8+4);
+
+	return sprintf(buf, "%#llx\n", id);
+}
+
 static struct enclosure_component_callbacks ses_enclosure_callbacks =3D=
 {
 	.get_fault		=3D ses_get_fault,
 	.set_fault		=3D ses_set_fault,
@@ -265,6 +273,7 @@ static struct enclosure_component_callbacks ses_enc=
losure_callbacks =3D {
 	.get_locate		=3D ses_get_locate,
 	.set_locate		=3D ses_set_locate,
 	.set_active		=3D ses_set_active,
+	.show_id		=3D ses_show_id,
 };
=20
 struct ses_host_edev {
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index a835d33..807622b 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -79,6 +79,7 @@ struct enclosure_component_callbacks {
 	int (*set_locate)(struct enclosure_device *,
 			  struct enclosure_component *,
 			  enum enclosure_component_setting);
+	int (*show_id)(struct enclosure_device *, char *buf);
 };
=20
=20
--=20
1.8.1


> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, September 4, 2014 12:55 AM
> To: Song Liu; linux-scsi@vger.kernel.org
> Cc: Dan Williams; Jens Axboe
> Subject: Re: [PATCH 3/5] SES: add enclosure logical id
>=20
> On 08/25/2014 07:34 PM, Song Liu wrote:
> > From: Song Liu [mailto:songliubraving@fb.com]
> > Sent: Monday, August 25, 2014 10:26 AM
> > To: Song Liu
> > Cc: Dan Williams; Hannes Reinecke
> > Subject: [PATCH 3/5] SES: add enclosure logical id
> >
> > From: Dan Williams <dan.j.williams@intel.com>
> >
> > Export the NAA logical id for the enclosure.  This is optionally av=
ailable
> from the sas_transport_class, but it is really a property of the encl=
osure.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > Reviewed-by: Jens Axboe <axboe@fb.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > ---
> >  drivers/misc/enclosure.c  | 13 +++++++++++++
> >  drivers/scsi/ses.c        |  9 +++++++++
> >  include/linux/enclosure.h |  1 +
> >  3 files changed, 23 insertions(+)
> >
> > diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c in=
dex
> > 15faf61..646068a 100644
> > --- a/drivers/misc/enclosure.c
> > +++ b/drivers/misc/enclosure.c
> > @@ -395,8 +395,21 @@ static ssize_t components_show(struct device
> > *cdev,  }  static DEVICE_ATTR_RO(components);
> >
> > +static ssize_t id_show(struct device *cdev,
> > +				 struct device_attribute *attr,
> > +				 char *buf)
> > +{
> > +	struct enclosure_device *edev =3D to_enclosure_device(cdev);
> > +
> > +	if (edev->cb->show_id)
> > +		return edev->cb->show_id(edev, buf);
> > +	return 0;
> > +}
> > +static DEVICE_ATTR_RO(id);
> > +
> >  static struct attribute *enclosure_class_attrs[] =3D {
> >  	&dev_attr_components.attr,
> > +	&dev_attr_id.attr,
> >  	NULL,
> >  };
> >  ATTRIBUTE_GROUPS(enclosure_class);
>=20
> Maybe you should return -EINVAL or something here; '0' would mean an
> enclosure id of length '0', which is a different meaning from 'enclos=
ure id not
> available'.
>=20
> > diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index
> > 8f0a62a..61deb4e 100644
> > --- a/drivers/scsi/ses.c
> > +++ b/drivers/scsi/ses.c
> > @@ -258,6 +258,14 @@ static int ses_set_active(struct enclosure_dev=
ice
> *edev,
> >  	return ses_set_page2_descriptor(edev, ecomp, desc);  }
> >
> > +static int ses_show_id(struct enclosure_device *edev, char *buf) {
> > +	struct ses_device *ses_dev =3D edev->scratch;
> > +	unsigned long long id =3D get_unaligned_be64(ses_dev->page1+8+4);
> > +
> > +	return sprintf(buf, "%#llx\n", id);
> > +}
> > +
> >  static struct enclosure_component_callbacks ses_enclosure_callback=
s =3D {
> >  	.get_fault		=3D ses_get_fault,
> >  	.set_fault		=3D ses_set_fault,
> > @@ -265,6 +273,7 @@ static struct enclosure_component_callbacks
> ses_enclosure_callbacks =3D {
> >  	.get_locate		=3D ses_get_locate,
> >  	.set_locate		=3D ses_set_locate,
> >  	.set_active		=3D ses_set_active,
> > +	.show_id		=3D ses_show_id,
> >  };
> >
> >  struct ses_host_edev {
> > diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
> > index a835d33..807622b 100644
> > --- a/include/linux/enclosure.h
> > +++ b/include/linux/enclosure.h
> > @@ -79,6 +79,7 @@ struct enclosure_component_callbacks {
> >  	int (*set_locate)(struct enclosure_device *,
> >  			  struct enclosure_component *,
> >  			  enum enclosure_component_setting);
> > +	int (*show_id)(struct enclosure_device *, char *buf);
> >  };
> >
> >
> > --
> > 1.8.1
> >
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
