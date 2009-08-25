From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Tue, 25 Aug 2009 23:22:51 +0200
Message-ID: <200908252322.51810.a.miskiewicz@gmail.com>
References: <200908252124.22562.a.miskiewicz@gmail.com> <1251229652.7539.10.camel@mulgrave.site> <200908252201.20797.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59636 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbZHYVW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2009 17:22:56 -0400
Received: by bwz19 with SMTP id 19so2175333bwz.37
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2009 14:22:57 -0700 (PDT)
In-Reply-To: <200908252201.20797.a.miskiewicz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>, Alan Stern <stern@rowland.harvard.edu>

On Tuesday 25 of August 2009, Arkadiusz Miskiewicz wrote:
> On Tuesday 25 of August 2009, you wrote:
> > On Tue, 2009-08-25 at 21:44 +0200, Arkadiusz Miskiewicz wrote:
> > > On Tuesday 25 of August 2009, James Bottomley wrote:
> > > > On Tue, 2009-08-25 at 21:24 +0200, Arkadiusz Miskiewicz wrote:
> > > > > What could be the reason for scsi_wait_scan not waiting until=
l all
> > > > > disks are found?
> > > > >
> > > > > I'm testing 2.6.30.5 on hardware with LSI Logic / Symbios Log=
ic
> > > > > MegaRAID 530 SCSI 320-0X RAID controller and modprobe
> > > > > scsi_wait_scan finishes earlier than disks are found.
> > > > >
> > > > > My initrd (romfs) does:
> > > > > insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_mod=
=2Eko
> > > > > insmod
> > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megara=
id_mm.
> > > > >ko insmod
> > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megara=
id_mbo
> > > > >x. ko insmod /lib/modules/2.6.30.5-0.3/kernel/lib/crc-t10dif.k=
o
> > > > > insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/sd_mod.k=
o
> > > > > insmod
> > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_wait_scan.=
ko
> > > > > insmod /lib/modules/2.6.30.5-0.3/kernel/fs/exportfs/exportfs.=
ko
> > > > > insmod /lib/modules/2.6.30.5-0.3/kernel/fs/xfs/xfs.ko
> > > > > if [ "${ROOT##/dev/}" !=3D "${ROOT}" ]; then
> > > > > rootnr=3D"$(busybox awk -v rootnode=3D"${ROOT##/dev/}" '$4 =3D=
=3D rootnode
> > > > > { print 256 * $1 + $2 }' /proc/partitions)"
> > > > > if [ -n "$rootnr" ]; then
> > > > > echo "$rootnr" > /proc/sys/kernel/real-root-dev
> > > > > fi
> > > > >
> > > > >
> > > > > Now if I add sleep few seconds or /bin/sh at the end of this
> > > > > initrd, then boot and then disks are detected properly and ro=
otfs
> > > > > is mounted properly (after I exit from sh in case when /bin/s=
h is
> > > > > used).
> > > > >
> > > > > The question remains - why scsi_wait_scan doesn't wait?
> > > >
> > > > It's caused by the sd async patches.  What's happening is wait_=
scan
> > > > is waiting until all the scans are complete, but now sd attachm=
ent
> > > > may not be completed by the time that happens.  So, although yo=
u have
> > > > a scanned disk, you can't mount it without and attached sd driv=
er.
> > > >
> > > > Hopefully when
> > > > all initrds are configured to wait until root appears, this pro=
blem
> > > > will go away.
> > >
> > > Uh, ugly. I'll disable SCSI_SCAN_ASYNC here then.
> >
> > That won't actually help: the sd async scan is a separate mechanism=
 not
> > tied to that variable
>
> I assume there is no configurable way to disable this?

I found this patch

http://marc.info/?l=3Dlinux-scsi&m=3D124388639906873&w=3D2

but it doesn't work on 30.5 (it's still not waiting untill everything i=
s=20
discovered)


--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
