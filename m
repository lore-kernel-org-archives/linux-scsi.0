From: "Saeed Bishara" <saeed@marvell.com>
Subject: bad refcount of the sdev when using scsi_device_add
Date: Sun, 16 Oct 2005 10:28:48 +0200
Message-ID: <B9FFC3F97441D04093A504CEA31B7C41591BB7@msilexch01.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shoshil.marvell.com ([199.203.130.250]:37929 "EHLO
	il.marvell.com") by vger.kernel.org with ESMTP id S1751314AbVJPI2u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Oct 2005 04:28:50 -0400
Received: from msilexch01.marvell.com (msilexch01.il.marvell.com [10.4.5.104])
	by il.marvell.com (8.13.1/8.13.1) with ESMTP id j9G8SmIZ001945
	for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2005 11:28:48 +0300 (IST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Saeed Bishara <saeed@marvell.com>

Hi,=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 My driver calles scsi_add_device for =
adding single scsi device, and the following flow for removing device:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sdev =3D scsi_device_lookup(host, 0, =
target, 0);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sdev !=3D NULL)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 //=A0=A0=A0 scsi_device_cancel(sdev, =
0);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_remove_device(sdev);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_device_put(sdev);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }


=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 But I see that after doing several ho=
tplugs for the scsi device, the scsi device entry under /sys/bus/scsi/d=
evices will remain even if the hotplug ends with unconnected device.
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Adding and removing single device usi=
ng echo =93add/remove =85.=94 > /proc/scsi/scsi works fine.
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 I found that the flow of adding devic=
e using scsi_scan_target ends with different refcount of the sdev than =
using the scsi_add_device, in the former one the refcount is less by 1.=
 the scsi_scan_target calls scsi_device_put, but there is no analogous =
put in the scsi_add_device function. Now, when I add scsi_device_put af=
ter scsi_add_device, the issue get fixed.

=A0Is it a bug in the scsi_device_add? Is there any problem with my wor=
karound?
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
Saeed Bishara

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
