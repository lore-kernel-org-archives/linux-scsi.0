From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [SCSI] ses: fix memory leaks
Date: Sun, 10 Feb 2008 23:25:25 -0800
Message-ID: <200802102325.26538.yinghai.lu@sun.com>
References: <200802090413.53275.yinghai.lu@sun.com>
 <200802091515.48076.yinghai.lu@sun.com>
 <1202704118.3136.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <1202704118.3136.79.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com
List-Id: linux-scsi@vger.kernel.org

please check it...

---

=46rom: Yinghai Lu <yinghai.lu@sun.com>

[SCSI] ses: fix memory leaks

fix leaking with scomp leaking when failing. Also free page10 on
driver removal =C2=A0and remove one extra space.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---

 drivers/scsi/ses.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/scsi/ses.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/drivers/scsi/ses.c
+++ linux-2.6/drivers/scsi/ses.c
@@ -416,11 +416,11 @@ static int ses_intf_add(struct class_dev
 	int i, j, types, len, components =3D 0;
 	int err =3D -ENOMEM;
 	struct enclosure_device *edev;
-	struct ses_component *scomp;
+	struct ses_component *scomp =3D NULL;
=20
 	if (!scsi_device_enclosure(sdev)) {
 		/* not an enclosure, but might be in one */
-		edev =3D 	enclosure_find(&sdev->host->shost_gendev);
+		edev =3D enclosure_find(&sdev->host->shost_gendev);
 		if (edev) {
 			ses_match_to_enclosure(edev, sdev);
 			class_device_put(&edev->cdev);
@@ -456,9 +456,6 @@ static int ses_intf_add(struct class_dev
 	if (!buf)
 		goto err_free;
=20
-	ses_dev->page1 =3D buf;
-	ses_dev->page1_len =3D len;
-
 	result =3D ses_recv_diag(sdev, 1, buf, len);
 	if (result)
 		goto recv_failed;
@@ -473,6 +470,9 @@ static int ses_intf_add(struct class_dev
 		    type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_ARRAY_DEVICE)
 			components +=3D type_ptr[1];
 	}
+	ses_dev->page1 =3D buf;
+	ses_dev->page1_len =3D len;
+	buf =3D NULL;
=20
 	result =3D ses_recv_diag(sdev, 2, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
@@ -489,6 +489,7 @@ static int ses_intf_add(struct class_dev
 		goto recv_failed;
 	ses_dev->page2 =3D buf;
 	ses_dev->page2_len =3D len;
+	buf =3D NULL;
=20
 	/* The additional information page --- allows us
 	 * to match up the devices */
@@ -506,11 +507,12 @@ static int ses_intf_add(struct class_dev
 		goto recv_failed;
 	ses_dev->page10 =3D buf;
 	ses_dev->page10_len =3D len;
+	buf =3D NULL;
=20
  no_page10:
-	scomp =3D kmalloc(sizeof(struct ses_component) * components, GFP_KERN=
EL);
+	scomp =3D kzalloc(sizeof(struct ses_component) * components, GFP_KERN=
EL);
 	if (!scomp)
-		goto  err_free;
+		goto err_free;
=20
 	edev =3D enclosure_register(cdev->dev, sdev->sdev_gendev.bus_id,
 				  components, &ses_enclosure_callbacks);
@@ -521,10 +523,9 @@ static int ses_intf_add(struct class_dev
=20
 	edev->scratch =3D ses_dev;
 	for (i =3D 0; i < components; i++)
-		edev->component[i].scratch =3D scomp++;
+		edev->component[i].scratch =3D scomp + i;
=20
 	/* Page 7 for the descriptors is optional */
-	buf =3D NULL;
 	result =3D ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
 		goto simple_populate;
@@ -532,6 +533,8 @@ static int ses_intf_add(struct class_dev
 	len =3D (hdr_buf[2] << 8) + hdr_buf[3] + 4;
 	/* add 1 for trailing '\0' we'll use */
 	buf =3D kzalloc(len + 1, GFP_KERNEL);
+	if (!buf)
+		goto simple_polulate;
 	result =3D ses_recv_diag(sdev, 7, buf, len);
 	if (result) {
  simple_populate:
@@ -598,6 +601,7 @@ static int ses_intf_add(struct class_dev
 	err =3D -ENODEV;
  err_free:
 	kfree(buf);
+	kfree(scomp);
 	kfree(ses_dev->page10);
 	kfree(ses_dev->page2);
 	kfree(ses_dev->page1);
@@ -630,6 +634,7 @@ static void ses_intf_remove(struct class
 	ses_dev =3D edev->scratch;
 	edev->scratch =3D NULL;
=20
+	kfree(ses_dev->page10);
 	kfree(ses_dev->page1);
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
