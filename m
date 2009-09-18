From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: mdraid causing mvsas to lockup? (was: Re: recommended 4port SATA controller ?)
Date: Fri, 18 Sep 2009 17:02:46 -0600
Message-ID: <200909181702.46109.tfjellstrom@shaw.ca>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <200909171759.49606.tfjellstrom@shaw.ca> <200909180458.22305.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909180458.22305.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri September 18 2009, Thomas Fjellstrom wrote:
> On Thu September 17 2009, Thomas Fjellstrom wrote:
> > On Thu September 17 2009, Kristleifur Da=F0ason wrote:
> > > On Thu, Sep 17, 2009 at 11:02 PM, Thomas Fjellstrom
> > > <tfjellstrom@shaw.ca>
> >
> > wrote:
> > > > On Thu September 17 2009, John Bridges wrote:
> > > >> I'm a fan of the SuperMicro AOC-SAT2-MV8, great card.
> > > >> http://www.supermicro.com/products/accessories/addon/AOC-SAT2-=
MV8.cf
> > > >>m
> > > >>
> > > >> It's an 8 port PCI-X card, works in both PCI and PCI-X slots.
> > > >>
> > > >> SATA2
> > > >>
> > > >> Drivers for Linux are stable, built in.
> > > >
> > > > Have you had any experience with the AOC-SASLP-MV8? I've got on=
e and
> > > > have been having no end of issues with it under linux.
> > > >
> > > > --
> > > > Thomas Fjellstrom
> > > > tfjellstrom@shaw.ca
> > > > --
> > >
> > > I have,
> > >
> > > or rather, I've tried to get an AOC-SASLP-MV8 card going. I think=
 I
> > > can safely say that at least Linux kernel 2.6.31 is a requirement=
=2E The
> > > card was basically useless with everything up to 2.6.30, then I t=
ried
> > > 2.6.31-rc5 on a whim and it kicked in. Built-in driver support, t=
hat
> > > is. However it wasn't stable, it dropped disks when syncing a lar=
ge
> > > array. I've been meaning to test on 2.6.31 final, and am pretty
> > > optimistic.
> >
> > Yeah, the driver didn't appear till .30. I have 2.6.31-git4 install=
ed
> > right now, and no matter what I do, the controller starts spewing e=
rrors:
> >
> > [ 1455.698186] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc=3D=
 5
> > [ 1455.698196] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc=3D=
 5
> > ...
> > [ 1424.708085] end_request: I/O error, dev sdh, sector 3072
> > [ 1424.708106] sd 0:0:3:0: [sdh] Unhandled error code
> > [ 1424.708111] sd 0:0:3:0: [sdh] Result: hostbyte=3DDID_OK
> > driverbyte=3DDRIVER_TIMEOUT
> > [ 1424.708118] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 08 00 0=
0 04
> > 00 00
> >
> > And thats with perfectly good disks, and with smartd/hddtemp disabl=
ed
> > (they were causing one of my disks to barf).
> >
> > All I have to do is start a read from any disk, and after a few min=
utes,
> >  the card starts erroring out, and then dies.
> >
> > It actually seems like it got more unstable from .30 to .31.
> >
> > I've been trying to get some help with it on the lkml/ide/scsi list=
s for
> > a while now, one person has tried to help, but thats about it.
>=20
> Very strange. I've found that reading from all 4 drives currently con=
nected
>  to the controller at once, works. I have 4 dd commands, one reading =
off
>  each drive, and so far no errors, the dd commands aren't locking up,=
 and
>  they are going full speed (120MB/s per drive).
>=20
> If however I attempt to bring up the md raid0 array ontop of these di=
sks,
>  the controller locks up, and all of the disks become inaccessible.
>=20
> Maybe it has something to do with it, but just as the system is booti=
ng, I
>  get the following, maybe related, maybe not:
>=20
> ata_id[5183]: HDIO_GET_IDENTITY failed for '/dev/block/8:96'
> ata_id[5188]: HDIO_GET_IDENTITY failed for '/dev/block/8:112'
> ata_id[5184]: HDIO_GET_IDENTITY failed for '/dev/block/8:80'
>=20
> (those map to sdg, sdh, and sdf in that order, no report for sde, the=
 first
> disk in the controller)
>=20

So I've let the controller and disks sit all day after finishing a full=
 read=20
test (dd if=3D/dev/sd[efgh] of=3D/dev/null bs=3D8M) with all four 1TB d=
rives going=20
at the same time, and I've had no errors at all. All four dd commands f=
inished=20
without error, and went at full speed.

If I attempt to activate an md raid0 array ontop of any disks on this=20
controller the controller starts having a fit, and all disks are inacce=
ssible=20
till a hard reset (the machine won't fully reboot, or turn off, as the=20
"flushing scsi cache" or "shutting down LVM" steps will hang waiting on=
 drives=20
on the wedged controller.

I would really like to get this fixed, if there's anything more I can d=
o to=20
help narrow down the problem further, I'll do my best.

--=20
Thomas Fjellstrom
tfjellstrom@shaw.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
