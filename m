From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Tue, 25 Aug 2009 22:01:20 +0200
Message-ID: <200908252201.20797.a.miskiewicz@gmail.com>
References: <200908252124.22562.a.miskiewicz@gmail.com> <200908252144.11155.a.miskiewicz@gmail.com> <1251229652.7539.10.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53656 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZHYUBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2009 16:01:24 -0400
Received: by bwz19 with SMTP id 19so2129726bwz.37
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2009 13:01:25 -0700 (PDT)
In-Reply-To: <1251229652.7539.10.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Tuesday 25 of August 2009, you wrote:
> On Tue, 2009-08-25 at 21:44 +0200, Arkadiusz Miskiewicz wrote:
> > On Tuesday 25 of August 2009, James Bottomley wrote:
> > > On Tue, 2009-08-25 at 21:24 +0200, Arkadiusz Miskiewicz wrote:
> > > > What could be the reason for scsi_wait_scan not waiting untill =
all
> > > > disks are found?
> > > >
> > > > I'm testing 2.6.30.5 on hardware with LSI Logic / Symbios Logic
> > > > MegaRAID 530 SCSI 320-0X RAID controller and modprobe scsi_wait=
_scan
> > > > finishes earlier than disks are found.
> > > >
> > > > My initrd (romfs) does:
> > > > insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_mod.k=
o
> > > > insmod
> > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megaraid=
_mm.ko
> > > > insmod
> > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megaraid=
_mbox.
> > > >ko insmod /lib/modules/2.6.30.5-0.3/kernel/lib/crc-t10dif.ko
> > > > insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/sd_mod.ko
> > > > insmod
> > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_wait_scan.ko
> > > > insmod /lib/modules/2.6.30.5-0.3/kernel/fs/exportfs/exportfs.ko
> > > > insmod /lib/modules/2.6.30.5-0.3/kernel/fs/xfs/xfs.ko
> > > > if [ "${ROOT##/dev/}" !=3D "${ROOT}" ]; then
> > > > rootnr=3D"$(busybox awk -v rootnode=3D"${ROOT##/dev/}" '$4 =3D=3D=
 rootnode {
> > > > print 256 * $1 + $2 }' /proc/partitions)"
> > > > if [ -n "$rootnr" ]; then
> > > > echo "$rootnr" > /proc/sys/kernel/real-root-dev
> > > > fi
> > > >
> > > >
> > > > Now if I add sleep few seconds or /bin/sh at the end of this in=
itrd,
> > > > then boot and then disks are detected properly and rootfs is mo=
unted
> > > > properly (after I exit from sh in case when /bin/sh is used).
> > > >
> > > > The question remains - why scsi_wait_scan doesn't wait?
> > >
> > > It's caused by the sd async patches.  What's happening is wait_sc=
an is
> > > waiting until all the scans are complete, but now sd attachment m=
ay not
> > > be completed by the time that happens.  So, although you have a s=
canned
> > > disk, you can't mount it without and attached sd driver.
> > >
> > > Hopefully when
> > > all initrds are configured to wait until root appears, this probl=
em
> > > will go away.
> >
> > Uh, ugly. I'll disable SCSI_SCAN_ASYNC here then.
>
> That won't actually help: the sd async scan is a separate mechanism n=
ot
> tied to that variable

I assume there is no configurable way to disable this?

>
> > Anyway what's the point of scsi_wait_scan module if initrd is still
> > required to wait until root appears? (unless current behaviour is b=
roken
> > behaviour meant to be fixed?)
>
> It was supposed to be an interim measure until the ditributions got
> their act together for initrd booting by waiting for the root disk to
> appear.  It's just been "interim" for a bit longer than expected.

Isn't kernel better place for this?

Handling that in userspace is very complicated for such setups like fs =
on top=20
of software raid where raid is assembled by UUID of devices etc, etc.=20
Userspace will need to handle all weird cases to figure out what device=
s are=20
needed (eg. parse mdadm config) to be able to wait for thsese and then =
go into=20
next step.

Are major distros actually handling this well?

> James

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
