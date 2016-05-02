From: Petros Koutoupis <petros@petroskoutoupis.com>
Subject: hpsa: Fix type ZBC conditional checks
Date: Mon, 02 May 2016 11:39:12 -0500
Message-ID: <1462207152.5718.6.camel@petroskoutoupis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:53566 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbcEBQjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 12:39:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@microsemi.com
Cc: petros@petroskoutoupis.com, linux-scsi@vger.kernel.org, iss_storagedev@hp.com, esc.storagedev@microsemi.com

The device ID obtained from the inquiry can only be of a single type. T=
he original
code places a check for TYPE_ZBC right after the check for TYPE_DISK. L=
ogically,
if the first if statement sees a device of a TYPE_DISK and moves on to =
the second
statement checking if not TYPE_ZBC, it will always hit the continue.

--- linux/drivers/scsi/hpsa.c.orig	2016-04-27 21:43:44.463140419 -0500
+++ linux/drivers/scsi/hpsa.c	2016-04-27 22:45:31.015140419 -0500
@@ -1637,9 +1637,8 @@ static void hpsa_figure_phys_disk_ptrs(s
=C2=A0		for (j =3D 0; j < ndevices; j++) {
=C2=A0			if (dev[j] =3D=3D NULL)
=C2=A0				continue;
-			if (dev[j]->devtype !=3D TYPE_DISK)
-				continue;
-			if (dev[j]->devtype !=3D TYPE_ZBC)
+			if ((dev[j]->devtype !=3D TYPE_DISK) &&
+			=C2=A0=C2=A0=C2=A0=C2=A0(dev[j]->devtype !=3D TYPE_ZBC))
=C2=A0				continue;
=C2=A0			if (is_logical_device(dev[j]))
=C2=A0				continue;
@@ -1684,9 +1683,8 @@ static void hpsa_update_log_drive_phys_d
=C2=A0	for (i =3D 0; i < ndevices; i++) {
=C2=A0		if (dev[i] =3D=3D NULL)
=C2=A0			continue;
-		if (dev[i]->devtype !=3D TYPE_DISK)
-			continue;
-		if (dev[i]->devtype !=3D TYPE_ZBC)
+		if ((dev[i]->devtype !=3D TYPE_DISK) &&
+		=C2=A0=C2=A0=C2=A0=C2=A0(dev[i]->devtype !=3D TYPE_ZBC))
=C2=A0			continue;
=C2=A0		if (!is_logical_device(dev[i]))
=C2=A0			continue;
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
