From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] Hidden scsi devices
Date: Thu, 22 Jan 2004 16:57:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF8847A70B.4AA684AE-ONC1256E23.00571E7C-C1256E23.0058163C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:1429 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S266078AbUAVP5O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 10:57:14 -0500
Received: from d12relay02.megacenter.de.ibm.com (d12relay02.megacenter.de.ibm.com [9.149.165.196])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id i0MFvBRT132694
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2004 15:57:11 GMT
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org


Brian,

why should a LLDD need to bother about device characteristics?
I tend to say that it is completely up to upper layer drivers to
handle such device specialties.
How does a LLDD know about that r/w protection feature anyway?

Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Brian King <brking@us.ibm.com>@vger.kernel.org on 22/01/2004 16:21:23

Sent by:    linux-scsi-owner@vger.kernel.org


To:    linux-scsi@vger.kernel.org
cc:
Subject:    [PATCH] Hidden scsi devices


Here is a patch that adds a flag to struct scsi_device which prevents
upper layer drivers from binding to it. This flag can be set by LLDs
in their slave_configure routine. I plan to use this in the ipr driver
so I can have scsi disks that are in RAID arrays show up in sysfs and
have sg devices created for them, but prevent sd devices from being
created since these devices will fail reads and writes with data protec=
t
errors. I tested this out with the ipr driver it worked as expected.



--
Brian King
eServer Storage I/O
IBM Linux Technology Center
diff -Naur linux-2.6.1/drivers/scsi/scsi_sysfs.c
linux-2.6.1-hidden/drivers/scsi/scsi_sysfs.c
--- linux-2.6.1/drivers/scsi/scsi_sysfs.c        Fri Jan  9 00:59:10 20=
04
+++ linux-2.6.1-hidden/drivers/scsi/scsi_sysfs.c             Thu Jan 22
08:54:39 2004
@@ -149,7 +149,13 @@
 /* all probing is done in the individual ->probe routines */
 static int scsi_bus_match(struct device *dev, struct device_driver
*gendrv)
 {
-            return 1;
+            struct scsi_device *sdev;
+            sdev =3D to_scsi_device(dev);
+
+            if (sdev->hidden)
+                        return 0;
+            else
+                        return 1;
 }

 struct bus_type scsi_bus_type =3D {
diff -Naur linux-2.6.1/include/scsi/scsi_device.h
linux-2.6.1-hidden/include/scsi/scsi_device.h
--- linux-2.6.1/include/scsi/scsi_device.h             Fri Jan  9 00:59=
:06
2004
+++ linux-2.6.1-hidden/include/scsi/scsi_device.h            Thu Jan 22
08:50:33 2004
@@ -94,6 +94,7 @@
             unsigned skip_ms_page_8:1;          /* do not use MODE SEN=
SE
page 0x08 */
             unsigned skip_ms_page_3f:1;         /* do not use MODE SEN=
SE
page 0x3f */
             unsigned no_start_on_add:1;         /* do not issue start =
on
add */
+            unsigned hidden:1;            /* do not bind to upper leve=
l
driver */

             unsigned int device_blocked;        /* Device returned
QUEUE_FULL. */





-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
