From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/1] 3ware 9000 driver fix for 2.6.16-rc3
Date: Sun, 5 Feb 2006 14:51:43 -0800
Message-ID: <b1bc6a000602051451i15be56c0k5bb7928cb81077f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_21154_5619979.1139179903508"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uproxy.gmail.com ([66.249.92.200]:63828 "EHLO uproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750770AbWBEWvp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Feb 2006 17:51:45 -0500
Received: by uproxy.gmail.com with SMTP id h2so556511ugf
        for <linux-scsi@vger.kernel.org>; Sun, 05 Feb 2006 14:51:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, akpm@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

------=_Part_21154_5619979.1139179903508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

The attached patch fixes a bug in the 3ware 9000 series driver:

- Fix use_sg =3D=3D 0 mapping on systems with 4GB or higher.

  This fixes REPORT_LUNS (0xa0) failing with 3ware 9000 controllers on syst=
ems
  with lots of ram, mentioned in bugzilla # 6009:

      http://bugzilla.kernel.org/show_bug.cgi?id=3D6009

Signed-off-by: Adam Radford <linuxraid@amcc.com>

James, Please apply

Thanks!

Note: The patch is attached as an attachment, and also included
in-line below.   The below may have line-wrap issues since I'm pasting
into gmail.

diff -Naur linux-2.6.16-rc2/drivers/scsi/3w-9xxx.c
linux-2.6.16-rc3/drivers/scsi/3w-9xxx.c
--- linux-2.6.16-rc2/drivers/scsi/3w-9xxx.c=092006-02-05 14:30:13.000000000=
 -0800
+++ linux-2.6.16-rc3/drivers/scsi/3w-9xxx.c=092006-02-05 14:36:40.000000000=
 -0800
@@ -61,6 +61,7 @@
                  Add support for embedded firmware error strings.
    2.26.02.003 - Correctly handle single sgl's with use_sg=3D1.
    2.26.02.004 - Add support for 9550SX controllers.
+   2.26.02.005 - Fix use_sg =3D=3D 0 mapping on systems with 4GB or higher=
.
 */

 #include <linux/module.h>
@@ -84,7 +85,7 @@
 #include "3w-9xxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.004"
+#define TW_DRIVER_VERSION "2.26.02.005"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major =3D -1;
@@ -1408,7 +1409,7 @@
 =09dma_addr_t mapping;
 =09struct scsi_cmnd *cmd =3D tw_dev->srb[request_id];
 =09struct pci_dev *pdev =3D tw_dev->tw_pci_dev;
-=09int retval =3D 0;
+=09dma_addr_t retval =3D 0;

 =09if (cmd->request_bufflen =3D=3D 0) {
 =09=09retval =3D 0;
@@ -1798,7 +1799,7 @@
 =09int i, sg_count;
 =09struct scsi_cmnd *srb =3D NULL;
 =09struct scatterlist *sglist =3D NULL;
-=09u32 buffaddr =3D 0x0;
+=09dma_addr_t buffaddr =3D 0x0;
 =09int retval =3D 1;

 =09if (tw_dev->srb[request_id]) {

------=_Part_21154_5619979.1139179903508
Content-Type: text/x-patch; name=3ware_fix_2.6.16-rc3.patch;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Attachment-Id: f_ejby7y1p
Content-Disposition: attachment; filename="3ware_fix_2.6.16-rc3.patch"

diff -Naur linux-2.6.16-rc2/drivers/scsi/3w-9xxx.c linux-2.6.16-rc3/drivers/scsi/3w-9xxx.c
--- linux-2.6.16-rc2/drivers/scsi/3w-9xxx.c	2006-02-05 14:30:13.000000000 -0800
+++ linux-2.6.16-rc3/drivers/scsi/3w-9xxx.c	2006-02-05 14:36:40.000000000 -0800
@@ -61,6 +61,7 @@
                  Add support for embedded firmware error strings.
    2.26.02.003 - Correctly handle single sgl's with use_sg=1.
    2.26.02.004 - Add support for 9550SX controllers.
+   2.26.02.005 - Fix use_sg == 0 mapping on systems with 4GB or higher.
 */
 
 #include <linux/module.h>
@@ -84,7 +85,7 @@
 #include "3w-9xxx.h"
 
 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.004"
+#define TW_DRIVER_VERSION "2.26.02.005"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -1408,7 +1409,7 @@
 	dma_addr_t mapping;
 	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
 	struct pci_dev *pdev = tw_dev->tw_pci_dev;
-	int retval = 0;
+	dma_addr_t retval = 0;
 
 	if (cmd->request_bufflen == 0) {
 		retval = 0;
@@ -1798,7 +1799,7 @@
 	int i, sg_count;
 	struct scsi_cmnd *srb = NULL;
 	struct scatterlist *sglist = NULL;
-	u32 buffaddr = 0x0;
+	dma_addr_t buffaddr = 0x0;
 	int retval = 1;
 
 	if (tw_dev->srb[request_id]) {

------=_Part_21154_5619979.1139179903508--
