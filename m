From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Tue, 25 Aug 2009 21:44:10 +0200
Message-ID: <200908252144.11155.a.miskiewicz@gmail.com>
References: <200908252124.22562.a.miskiewicz@gmail.com> <1251228529.7539.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50710 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025AbZHYToP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2009 15:44:15 -0400
Received: by fxm17 with SMTP id 17so2418809fxm.37
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2009 12:44:16 -0700 (PDT)
In-Reply-To: <1251228529.7539.8.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Tuesday 25 of August 2009, James Bottomley wrote:
> On Tue, 2009-08-25 at 21:24 +0200, Arkadiusz Miskiewicz wrote:
> > What could be the reason for scsi_wait_scan not waiting untill all =
disks
> > are found?
> >
> > I'm testing 2.6.30.5 on hardware with LSI Logic / Symbios Logic Meg=
aRAID
> > 530 SCSI 320-0X RAID controller and modprobe scsi_wait_scan finishe=
s
> > earlier than disks are found.
> >
> > My initrd (romfs) does:
> > insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_mod.ko
> > insmod
> > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megaraid_mm.=
ko
> > insmod
> > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/megaraid_mbo=
x.ko
> > insmod /lib/modules/2.6.30.5-0.3/kernel/lib/crc-t10dif.ko
> > insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/sd_mod.ko
> > insmod /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_wait_scan=
=2Eko
> > insmod /lib/modules/2.6.30.5-0.3/kernel/fs/exportfs/exportfs.ko
> > insmod /lib/modules/2.6.30.5-0.3/kernel/fs/xfs/xfs.ko
> > if [ "${ROOT##/dev/}" !=3D "${ROOT}" ]; then
> > rootnr=3D"$(busybox awk -v rootnode=3D"${ROOT##/dev/}" '$4 =3D=3D r=
ootnode {
> > print 256 * $1 + $2 }' /proc/partitions)"
> > if [ -n "$rootnr" ]; then
> > echo "$rootnr" > /proc/sys/kernel/real-root-dev
> > fi
> >
> >
> > Now if I add sleep few seconds or /bin/sh at the end of this initrd=
, then
> > boot and then disks are detected properly and rootfs is mounted pro=
perly
> > (after I exit from sh in case when /bin/sh is used).
> >
> > The question remains - why scsi_wait_scan doesn't wait?
>
> It's caused by the sd async patches.  What's happening is wait_scan i=
s
> waiting until all the scans are complete, but now sd attachment may n=
ot
> be completed by the time that happens.  So, although you have a scann=
ed
> disk, you can't mount it without and attached sd driver.=20

> Hopefully when
> all initrds are configured to wait until root appears, this problem w=
ill
> go away.

Uh, ugly. I'll disable SCSI_SCAN_ASYNC here then.

Anyway what's the point of scsi_wait_scan module if initrd is still req=
uired=20
to wait until root appears? (unless current behaviour is broken behavio=
ur=20
meant to be fixed?)

Thanks!

> James

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
