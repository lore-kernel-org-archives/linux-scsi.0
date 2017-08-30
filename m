From: "Carnuccio, Joe" <Joe.Carnuccio@cavium.com>
Subject: RE: [PATCH v2] scsi: qla2xxx: Fix an integer overflow in sysfs code
Date: Wed, 30 Aug 2017 17:08:43 +0000
Message-ID: <BY2PR07MB23426AD1AC3C646124E8FBBE939C0@BY2PR07MB2342.namprd07.prod.outlook.com>
References: <CANn89iJBtAFJjz7wY2=2pO5SdNGhJx8M8_V-dEq81NhsFHeAUA@mail.gmail.com>
 <20170830133035.nbkiled5hhdt26ui@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0053.outbound.protection.outlook.com ([104.47.42.53]:15680
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751333AbdH3RIp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Aug 2017 13:08:45 -0400
In-Reply-To: <20170830133035.nbkiled5hhdt26ui@mwanda>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, shqking <shqking@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "security@kernel.org" <security@kernel.org>

good catch, thanks; I'll propagate this to our various OOB drivers.


-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com]=20
Sent: Wednesday, August 30, 2017 6:31 AM
To: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>; shqking <shqki=
ng@gmail.com>; Carnuccio, Joe <Joe.Carnuccio@cavium.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen <mar=
tin.petersen@oracle.com>; linux-scsi@vger.kernel.org; security@kernel.org
Subject: [PATCH v2] scsi: qla2xxx: Fix an integer overflow in sysfs code

The value of "size" comes from the user.  When we add "start + size"
it could lead to an integer overflow bug.

It means we vmalloc() a lot more memory than we had intended.  I believe th=
at on 64 bit systems vmalloc() can succeed even if we ask it to allocate hu=
ge 4GB buffers.  So we would get memory corruption and likely a crash when =
we call ha->isp_ops->write_optrom() and ->read_optrom().

Only root can trigger this bug.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D194061

Cc: stable@vger.kernel.org
Fixes: b7cc176c9eb3 ("[SCSI] qla2xxx: Allow region-based flash-part accesse=
s.")
Reported-by: shqking <shqking@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Add stable and the URL for bugzila

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_att=
r.c index 75c4b312645e..9ce28c4f9812 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -318,6 +318,8 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struc=
t kobject *kobj,
 		return -EINVAL;
 	if (start > ha->optrom_size)
 		return -EINVAL;
+	if (size > ha->optrom_size - start)
+		size =3D ha->optrom_size - start;
=20
 	mutex_lock(&ha->optrom_mutex);
 	switch (val) {
@@ -343,8 +345,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struc=
t kobject *kobj,
 		}
=20
 		ha->optrom_region_start =3D start;
-		ha->optrom_region_size =3D start + size > ha->optrom_size ?
-		    ha->optrom_size - start : size;
+		ha->optrom_region_size =3D start + size;
=20
 		ha->optrom_state =3D QLA_SREADING;
 		ha->optrom_buffer =3D vmalloc(ha->optrom_region_size); @@ -417,8 +418,7 =
@@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		}
=20
 		ha->optrom_region_start =3D start;
-		ha->optrom_region_size =3D start + size > ha->optrom_size ?
-		    ha->optrom_size - start : size;
+		ha->optrom_region_size =3D start + size;
=20
 		ha->optrom_state =3D QLA_SWRITING;
 		ha->optrom_buffer =3D vmalloc(ha->optrom_region_size);
