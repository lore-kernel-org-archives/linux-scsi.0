From: Gal Rosen <galr@storwize.com>
Subject: Re: SCSI device rescan, detection of disconnected device, or
	switched devices.
Date: Thu, 31 Jul 2008 09:57:14 +0300
Message-ID: <1217487434.25491.34.camel@galr-linux>
References: <1217248348.4133.51.camel@galr-linux>
	 <488DC55C.2050603@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:58398 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752132AbYGaG52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 02:57:28 -0400
In-Reply-To: <488DC55C.2050603@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

Hi,

I will try to make my question more clear.
I would like to put a box between the client and the storage, and to be
fully transparent against the host. All changes on the storage
(add/remove/extend devices) should be present automatically to the
client. In a direct connection between client and storage the
administrator will coordinate between the client and storage before
making any changes, in my configuration I do not want to add
administration work on my box that stands between the client and the
storage.
Addition is simple, the application on my box can once in a while scan
the SCSI BUS, and then the Linux system will create new sg devices.
In removal of a device the Linux system will not remove sg devices afte=
r
scan. In that case again I can do it from my application, such when I
get attention on SCSI command, I can decide to remove the device by
echoing to the /sys file system.

What do you think ? is this enough or there is better way ?

Thanks,
Gal.

On Mon, 2008-07-28 at 15:10 +0200, Stefan Richter wrote:
> Gal Rosen wrote:
> > =EF=BB=BF=EF=BB=BFI know that when adding new device there is no pr=
oblem;
> > by echo "- - -" >/sys/class/scsi_host/hostX/scan the SCSI subsystem=
 will
> > recognize the new device and new /dev/sgX device will be created, b=
ut if
> > someone remove a device, scan will only recognize that the report l=
uns
> > has changed, but it will not remove the /dev/sgX device.
> > If now someone add new device it will mapped to the /dev/sgX that
> > previously mapped to the device that just removed.
> >=20
> > 1. Why the SCSI subsystem doesn't release devices that removed ?
>=20
> Because somewhere someone still holds a reference on the device (for =
a
> good reason, or due to a bug).
>=20
> > 2. In the situation that I described above someone can switched dev=
ices
> > without notifying the application that use those devices. The
> > notification will come only when the next SCSI command will return =
with
> > unit attention saying "Power on, reset, or bus device reset occured=
", or
> > if device just removed without adding new device it will return
> > "Reported luns data has changed".
> > If I have an application that control SCSI devices using sg driver =
and I
> > would like to have the ability to change configuration online, what=
 is
> > the preferred way to rescan the bus and update the application that=
 sgX
> > that previously controls device Y is now controlling device Z ?
> > In other words, what is the best way for the application to identif=
y
> > that device has been removed or changed ?
>=20
> Hmm, I too am curious what the answer to this would be.
>=20
> > 3. I am using Qlogic firmware ability to create virtual ports, and =
I
> > notice that on disconnect and then reconnect the FC cable, the sg
> > mapping can changed. If on module load the physical port got sg0, a=
nd on
> > creating vport it got sg1, now the SCSI subsystem scans the vport f=
irst
> > and mapped it to sg0 and the physical port gets sg1.
> > Is there a way to control the mapping (scanning) ?
>=20
> There is currently one canonical way:  The low-level userspace (udev,
> hal, or even your application) looks at the device representation in
> sysfs and fetches persistent and unique properties of the target and
> logical unit from there.  The target identifier and logical unit
> identifier come first to mind as suitable properties.  Then the
> low-level userspace can for example create symlinks.  Most distributi=
ons
> contain udev scripts which do this for sd devices; see /dev/disk/by-i=
d/.
>=20
> Alas there is no standard place where to look for target identifier a=
nd
> logical unit identifier.  At least at the last time when I looked for
> them, the paths to respective sysfs attributes are so far implementat=
ion
> details of the various transport-layer drivers or so-called transport
> classes (FC, SAS, iSCSI, SBP-2...).
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
