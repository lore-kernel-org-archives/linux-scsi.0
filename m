From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: failover does not work with rdac device handler
Date: Tue, 7 Oct 2008 14:26:11 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BBBD21A@cosmail01.lsi.com>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BB4E86E@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BBBC908@cosmail01.lsi.com>
	,<1223081419.14830.585.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BB949D3@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BBBCCF2@cosmail01.lsi.com>
	<1223322817.14830.593.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BBBCD31@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BBBCE37@cosmail01.lsi.com>
	<1223345074.14830.601.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BBBD142@cosmail01.lsi.com>
	<1223407146.14830.617.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1223407146.14830.617.camel@chandra-ubuntu>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "sekharan@us.ibm.com" <sekharan@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Chandra,

Yes.  It works fine now.  I tested failover/failback few times and it wor=
ks as expected. Thanks you very much for helping me to resolve this probl=
em. Please let us know when this change is available in upstream kernel.

Thanks
Babu Moger

-----Original Message-----
From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
Sent: Tuesday, October 07, 2008 2:19 PM
To: Moger, Babu
Cc: device-mapper development; linux-scsi@vger.kernel.org
Subject: RE: [dm-devel] failover does not work with rdac device handler


Sorry, I sent an imcomplete patch. Here is the correct one.

BTW, The panic you saw is caused by the line (one of the lines you
added):

dev =3D container_of(&scsi_dh_data, struct scsi_device, scsi_dh_data);

in scsi_dh_release(). We cannot use pointer in a structure to get the
parent structure.

chandra

Keep a reference count of attaches, so that same number of detaches are a=
llowed.
-----------

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.27-rc8-git5/drivers/scsi/device_handler/scsi_dh.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc8-git5.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.27-rc8-git5/drivers/scsi/device_handler/scsi_dh.c
@@ -153,12 +153,28 @@ static int scsi_dh_handler_attach(struct
        if (sdev->scsi_dh_data) {
                if (sdev->scsi_dh_data->scsi_dh !=3D scsi_dh)
                        err =3D -EBUSY;
-       } else if (scsi_dh->attach)
+               else
+                       kref_get(&sdev->scsi_dh_data->kref);
+       } else if (scsi_dh->attach) {
                err =3D scsi_dh->attach(sdev);
+               if (!err) {
+                       kref_init(&sdev->scsi_dh_data->kref);
+                       sdev->scsi_dh_data->sdev =3D sdev;
+               }
+       }

        return err;
 }

+static void scsi_dh_release(struct kref *kref)
+{
+       struct scsi_dh_data *scsi_dh_data;
+       scsi_dh_data =3D container_of(kref, struct scsi_dh_data, kref);
+
+       if (scsi_dh_data->scsi_dh && scsi_dh_data->scsi_dh->detach)
+               scsi_dh_data->scsi_dh->detach(scsi_dh_data->sdev);
+}
+
 /*
  * scsi_dh_handler_detach - Detach a device handler from a device
  * @sdev - SCSI device the device handler should be detached from
@@ -176,11 +192,7 @@ static void scsi_dh_handler_detach(struc
        if (scsi_dh && scsi_dh !=3D sdev->scsi_dh_data->scsi_dh)
                return;

-       if (!scsi_dh)
-               scsi_dh =3D sdev->scsi_dh_data->scsi_dh;
-
-       if (scsi_dh && scsi_dh->detach)
-               scsi_dh->detach(sdev);
+       kref_put(&sdev->scsi_dh_data->kref, scsi_dh_release);
 }

 /*
Index: linux-2.6.27-rc8-git5/include/scsi/scsi_device.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc8-git5.orig/include/scsi/scsi_device.h
+++ linux-2.6.27-rc8-git5/include/scsi/scsi_device.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
+#include <linux/kref.h>
 #include <scsi/scsi.h>
 #include <asm/atomic.h>

@@ -191,6 +192,8 @@ struct scsi_device_handler {

 struct scsi_dh_data {
        struct scsi_device_handler *scsi_dh;
+       struct kref kref;
+       struct scsi_device *sdev; /* back reference */
        char buf[0];
 };
