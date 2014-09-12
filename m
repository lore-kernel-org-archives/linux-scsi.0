From: Song Liu <songliubraving@fb.com>
Subject: RE: [PATCH 1/5] SES: close potential registration race
Date: Fri, 12 Sep 2014 21:02:37 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBC5B00B@PRN-MBX02-4.TheFacebook.com>
References: <C709E4D363AAB64590BFAC54D4C478AAEBC4ABB1@PRN-MBX02-4.TheFacebook.com>
 <540819F9.8030701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44214 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbaILVCo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 17:02:44 -0400
In-Reply-To: <540819F9.8030701@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@fb.com>

=46rom 22d9dbcd783b315aaf59ad3eb928addaf0fba5fa Mon Sep 17 00:00:00 200=
1
=46rom: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Aug 2014 11:42:46 -0700
Subject: [PATCH 1/5] SES: close potential registration race

The slot and address fields have a small window of instability when
userspace can read them before initialization. Separate
enclosure_component
allocation from registration.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/misc/enclosure.c  | 36 +++++++++++++++++++++++++-----------
 drivers/scsi/ses.c        | 21 ++++++++++++++-------
 include/linux/enclosure.h |  5 +++--
 3 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 2cf2bbc..15faf61 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -249,27 +249,25 @@ static void enclosure_component_release(struct de=
vice *dev)
 static const struct attribute_group *enclosure_component_groups[];
=20
 /**
- * enclosure_component_register - add a particular component to an enc=
losure
+ * enclosure_component_alloc - prepare a new enclosure component
  * @edev:	the enclosure to add the component
  * @num:	the device number
  * @type:	the type of component being added
  * @name:	an optional name to appear in sysfs (leave NULL if none)
  *
- * Registers the component.  The name is optional for enclosures that
- * give their components a unique name.  If not, leave the field NULL
- * and a name will be assigned.
+ * The name is optional for enclosures that give their components a un=
ique
+ * name.  If not, leave the field NULL and a name will be assigned.
  *
  * Returns a pointer to the enclosure component or an error.
  */
 struct enclosure_component *
-enclosure_component_register(struct enclosure_device *edev,
-			     unsigned int number,
-			     enum enclosure_component_type type,
-			     const char *name)
+enclosure_component_alloc(struct enclosure_device *edev,
+			  unsigned int number,
+			  enum enclosure_component_type type,
+			  const char *name)
 {
 	struct enclosure_component *ecomp;
 	struct device *cdev;
-	int err;
=20
 	if (number >=3D edev->components)
 		return ERR_PTR(-EINVAL);
@@ -291,14 +289,30 @@ enclosure_component_register(struct enclosure_dev=
ice *edev,
 	cdev->release =3D enclosure_component_release;
 	cdev->groups =3D enclosure_component_groups;
=20
+	return ecomp;
+}
+EXPORT_SYMBOL_GPL(enclosure_component_alloc);
+
+/**
+ * enclosure_component_register - publishes an initialized enclosure c=
omponent
+ * @ecomp:	component to add
+ *
+ * Returns 0 on successful registration, releases the component otherw=
ise
+ */
+int enclosure_component_register(struct enclosure_component *ecomp)
+{
+	struct device *cdev;
+	int err;
+
+	cdev =3D &ecomp->cdev;
 	err =3D device_register(cdev);
 	if (err) {
 		ecomp->number =3D -1;
 		put_device(cdev);
-		return ERR_PTR(err);
+		return err;
 	}
=20
-	return ecomp;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(enclosure_component_register);
=20
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 80bfece..c52fd98 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -423,16 +423,23 @@ static void ses_enclosure_data_process(struct enc=
losure_device *edev,
 			    type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_ARRAY_DEVICE) {
=20
 				if (create)
-					ecomp =3D	enclosure_component_register(edev,
-									     components++,
-									     type_ptr[0],
-									     name);
+					ecomp =3D	enclosure_component_alloc(
+						edev,
+						components++,
+						type_ptr[0],
+						name);
 				else
 					ecomp =3D &edev->component[components++];
=20
-				if (!IS_ERR(ecomp) && addl_desc_ptr)
-					ses_process_descriptor(ecomp,
-							       addl_desc_ptr);
+				if (!IS_ERR(ecomp)) {
+					if (addl_desc_ptr)
+						ses_process_descriptor(
+							ecomp,
+							addl_desc_ptr);
+					if (create)
+						enclosure_component_register(
+							ecomp);
+				}
 			}
 			if (desc_ptr)
 				desc_ptr +=3D len;
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index 9a33c5f..a835d33 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -120,8 +120,9 @@ enclosure_register(struct device *, const char *, i=
nt,
 		   struct enclosure_component_callbacks *);
 void enclosure_unregister(struct enclosure_device *);
 struct enclosure_component *
-enclosure_component_register(struct enclosure_device *, unsigned int,
-				 enum enclosure_component_type, const char *);
+enclosure_component_alloc(struct enclosure_device *, unsigned int,
+			  enum enclosure_component_type, const char *);
+int enclosure_component_register(struct enclosure_component *);
 int enclosure_add_device(struct enclosure_device *enclosure, int compo=
nent,
 			 struct device *dev);
 int enclosure_remove_device(struct enclosure_device *, struct device *=
);
--=20
1.8.1


Thanks,
Song

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, September 4, 2014 12:51 AM
> To: Song Liu; linux-scsi@vger.kernel.org
> Cc: Dan Williams; Jens Axboe
> Subject: Re: [PATCH 1/5] SES: close potential registration race
>=20
> On 08/25/2014 07:34 PM, Song Liu wrote:
> > From: Song Liu [mailto:songliubraving@fb.com]
> > Sent: Monday, August 25, 2014 10:26 AM
> > To: Song Liu
> > Cc: Dan Williams; Hannes Reinecke
> > Subject: [PATCH 1/5] SES: close potential registration race
> >
> > From: Dan Williams <dan.j.williams@intel.com>
> >
> > The slot and address fields have a small window of instability when=
 userspace
> can read them before initialization. Separate enclosure_component all=
ocation
> from registration.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > Reviewed-by: Jens Axboe <axboe@fb.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> Please run the patch against checkpatch.pl.
> It does have quite some coding-style issues.
>=20
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
