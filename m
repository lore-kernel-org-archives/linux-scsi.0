From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: [PATCH] osd_uld: Check scsi_device_get() return value
Date: Thu, 30 Mar 2017 17:17:17 +0000
Message-ID: <1D08B61A9CF0974AA09887BE32D889DA12E934@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:41231 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932582AbdC3RR1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2017 13:17:27 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

scsi_device_get() can fail. Hence check its return value.=0A=
=0A=
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>=0A=
Cc: Boaz Harrosh <bharrosh@panasas.com>=0A=
---=0A=
 drivers/scsi/osd/osd_uld.c | 8 +++++---=0A=
 1 file changed, 5 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c=0A=
index e0ce5d2fd14d..1dea4244dd0c 100644=0A=
--- a/drivers/scsi/osd/osd_uld.c=0A=
+++ b/drivers/scsi/osd/osd_uld.c=0A=
@@ -464,14 +464,15 @@ static int osd_probe(struct device *dev)=0A=
 	/* hold one more reference to the scsi_device that will get released=0A=
 	 * in __release, in case a logout is happening while fs is mounted=0A=
 	 */=0A=
-	scsi_device_get(scsi_device);=0A=
+	if (scsi_device_get(scsi_device))=0A=
+		goto err_put_disk;=0A=
 	osd_dev_init(&oud->od, scsi_device);=0A=
 =0A=
 	/* Detect the OSD Version */=0A=
 	error =3D __detect_osd(oud);=0A=
 	if (error) {=0A=
 		OSD_ERR("osd detection failed, non-compatible OSD device\n");=0A=
-		goto err_put_disk;=0A=
+		goto err_put_sdev;=0A=
 	}=0A=
 =0A=
 	/* init the char-device for communication with user-mode */=0A=
@@ -508,8 +509,9 @@ static int osd_probe(struct device *dev)=0A=
 =0A=
 err_put_cdev:=0A=
 	cdev_del(&oud->cdev);=0A=
-err_put_disk:=0A=
+err_put_sdev:=0A=
 	scsi_device_put(scsi_device);=0A=
+err_put_disk:=0A=
 	put_disk(disk);=0A=
 err_free_osd:=0A=
 	dev_set_drvdata(dev, NULL);=0A=
-- =0A=
2.12.0=0A=
=0A=
