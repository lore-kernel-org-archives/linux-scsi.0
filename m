From: "adam radford" <aradford@gmail.com>
Subject: [PATCH 1/1] 3ware 9000 disable local irqs during kmap_atomic
Date: Tue, 11 Apr 2006 11:25:09 -0700
Message-ID: <b1bc6a000604111125s74a95319m39e23598ed4755a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_4727_25753915.1144779909285"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nproxy.gmail.com ([64.233.182.185]:35498 "EHLO nproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750824AbWDKSZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 14:25:11 -0400
Received: by nproxy.gmail.com with SMTP id g2so877728nfe
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2006 11:25:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

------=_Part_4727_25753915.1144779909285
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

The attached patch for 2.6.17-rc2 updates the 3ware 9000 driver:

- Disable local interrupts during kmap/unmap_atomic().

Signed-off-by: Adam Radford <linuxraid@amcc.com>

James, Please apply

Thanks!

-Adam

Note: The patch is attached as an attachment, and also included
in-line below.   The below may have line-wrap issues since I'm pasting
into gmail.

diff -Naur linux-2.6.17-rc1/drivers/scsi/3w-9xxx.c
linux-2.6.17-rc2/drivers/scsi/3w-9xxx.c
--- linux-2.6.17-rc1/drivers/scsi/3w-9xxx.c=092006-04-10 15:50:35.000000000=
 -0700
+++ linux-2.6.17-rc2/drivers/scsi/3w-9xxx.c=092006-04-11 11:13:02.000000000=
 -0700
@@ -65,6 +65,7 @@
    2.26.02.005 - Fix use_sg =3D=3D 0 mapping on systems with 4GB or higher=
.
    2.26.02.006 - Fix 9550SX pchip reset timeout.
                  Add big endian support.
+   2.26.02.007 - Disable local interrupts during kmap/unmap_atomic().
 */

 #include <linux/module.h>
@@ -88,7 +89,7 @@
 #include "3w-9xxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.006"
+#define TW_DRIVER_VERSION "2.26.02.007"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major =3D -1;
@@ -1942,9 +1943,13 @@
 =09=09}
 =09=09if (tw_dev->srb[request_id]->use_sg =3D=3D 1) {
 =09=09=09struct scatterlist *sg =3D (struct scatterlist
*)tw_dev->srb[request_id]->request_buffer;
-=09=09=09char *buf =3D kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+=09=09=09char *buf;
+=09=09=09unsigned long flags =3D 0;
+=09=09=09local_irq_save(flags);
+=09=09=09buf =3D kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
 =09=09=09memcpy(buf, tw_dev->generic_buffer_virt[request_id], sg->length);
 =09=09=09kunmap_atomic(buf - sg->offset, KM_IRQ0);
+=09=09=09local_irq_restore(flags);
 =09=09}
 =09}
 } /* End twa_scsiop_execute_scsi_complete() */

------=_Part_4727_25753915.1144779909285
Content-Type: text/x-patch; name=3ware_linux_2.6.17-rc2.patch;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Attachment-Id: f_elwkc92e
Content-Disposition: attachment; filename="3ware_linux_2.6.17-rc2.patch"

diff -Naur linux-2.6.17-rc1/drivers/scsi/3w-9xxx.c linux-2.6.17-rc2/drivers/scsi/3w-9xxx.c
--- linux-2.6.17-rc1/drivers/scsi/3w-9xxx.c	2006-04-10 15:50:35.000000000 -0700
+++ linux-2.6.17-rc2/drivers/scsi/3w-9xxx.c	2006-04-11 11:13:02.000000000 -0700
@@ -65,6 +65,7 @@
    2.26.02.005 - Fix use_sg == 0 mapping on systems with 4GB or higher.
    2.26.02.006 - Fix 9550SX pchip reset timeout.
                  Add big endian support.
+   2.26.02.007 - Disable local interrupts during kmap/unmap_atomic().
 */
 
 #include <linux/module.h>
@@ -88,7 +89,7 @@
 #include "3w-9xxx.h"
 
 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.006"
+#define TW_DRIVER_VERSION "2.26.02.007"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -1942,9 +1943,13 @@
 		}
 		if (tw_dev->srb[request_id]->use_sg == 1) {
 			struct scatterlist *sg = (struct scatterlist *)tw_dev->srb[request_id]->request_buffer;
-			char *buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+			char *buf;
+			unsigned long flags = 0;
+			local_irq_save(flags);
+			buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
 			memcpy(buf, tw_dev->generic_buffer_virt[request_id], sg->length);
 			kunmap_atomic(buf - sg->offset, KM_IRQ0);
+			local_irq_restore(flags);
 		}
 	}
 } /* End twa_scsiop_execute_scsi_complete() */

------=_Part_4727_25753915.1144779909285--
