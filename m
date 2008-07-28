From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: SCSI device rescan, detection of disconnected device, or switched
 devices.
Date: Mon, 28 Jul 2008 15:10:52 +0200
Message-ID: <488DC55C.2050603@s5r6.in-berlin.de>
References: <1217248348.4133.51.camel@galr-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:32872 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYG1NLk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 09:11:40 -0400
In-Reply-To: <1217248348.4133.51.camel@galr-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gal Rosen <galr@storwize.com>
Cc: linux-scsi@vger.kernel.org

Gal Rosen wrote:
> =EF=BB=BF=EF=BB=BFI know that when adding new device there is no prob=
lem;
> by echo "- - -" >/sys/class/scsi_host/hostX/scan the SCSI subsystem w=
ill
> recognize the new device and new /dev/sgX device will be created, but=
 if
> someone remove a device, scan will only recognize that the report lun=
s
> has changed, but it will not remove the /dev/sgX device.
> If now someone add new device it will mapped to the /dev/sgX that
> previously mapped to the device that just removed.
>=20
> 1. Why the SCSI subsystem doesn't release devices that removed ?

Because somewhere someone still holds a reference on the device (for a
good reason, or due to a bug).

> 2. In the situation that I described above someone can switched devic=
es
> without notifying the application that use those devices. The
> notification will come only when the next SCSI command will return wi=
th
> unit attention saying "Power on, reset, or bus device reset occured",=
 or
> if device just removed without adding new device it will return
> "Reported luns data has changed".
> If I have an application that control SCSI devices using sg driver an=
d I
> would like to have the ability to change configuration online, what i=
s
> the preferred way to rescan the bus and update the application that s=
gX
> that previously controls device Y is now controlling device Z ?
> In other words, what is the best way for the application to identify
> that device has been removed or changed ?

Hmm, I too am curious what the answer to this would be.

> 3. I am using Qlogic firmware ability to create virtual ports, and I
> notice that on disconnect and then reconnect the FC cable, the sg
> mapping can changed. If on module load the physical port got sg0, and=
 on
> creating vport it got sg1, now the SCSI subsystem scans the vport fir=
st
> and mapped it to sg0 and the physical port gets sg1.
> Is there a way to control the mapping (scanning) ?

There is currently one canonical way:  The low-level userspace (udev,
hal, or even your application) looks at the device representation in
sysfs and fetches persistent and unique properties of the target and
logical unit from there.  The target identifier and logical unit
identifier come first to mind as suitable properties.  Then the
low-level userspace can for example create symlinks.  Most distribution=
s
contain udev scripts which do this for sd devices; see /dev/disk/by-id/=
=2E

Alas there is no standard place where to look for target identifier and
logical unit identifier.  At least at the last time when I looked for
them, the paths to respective sysfs attributes are so far implementatio=
n
details of the various transport-layer drivers or so-called transport
classes (FC, SAS, iSCSI, SBP-2...).
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D--- -=3D=3D=3D =3D=3D=3D--
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
