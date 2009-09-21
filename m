From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: mdraid causing mvsas to lockup?
Date: Mon, 21 Sep 2009 10:16:45 -0600
Message-ID: <200909211016.45679.tfjellstrom@shaw.ca>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <200909180458.22305.tfjellstrom@shaw.ca> <200909181702.46109.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909181702.46109.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri September 18 2009, Thomas Fjellstrom wrote:
> On Fri September 18 2009, Thomas Fjellstrom wrote:
> > On Thu September 17 2009, Thomas Fjellstrom wrote:
> > > On Thu September 17 2009, Kristleifur Da=F0ason wrote:
> > > > On Thu, Sep 17, 2009 at 11:02 PM, Thomas Fjellstrom
> > > > <tfjellstrom@shaw.ca>
> > >
> > > wrote:
> > > > > On Thu September 17 2009, John Bridges wrote:
> > > > >> I'm a fan of the SuperMicro AOC-SAT2-MV8, great card.
> > > > >> http://www.supermicro.com/products/accessories/addon/AOC-SAT=
2-MV8.
> > > > >>cf m
> > > > >>
> > > > >> It's an 8 port PCI-X card, works in both PCI and PCI-X slots=
=2E
> > > > >>
> > > > >> SATA2
> > > > >>
> > > > >> Drivers for Linux are stable, built in.
> > > > >
> > > > > Have you had any experience with the AOC-SASLP-MV8? I've got =
one
> > > > > and have been having no end of issues with it under linux.
> > > > >
> > > > > --
> > > > > Thomas Fjellstrom
> > > > > tfjellstrom@shaw.ca
> > > > > --
> > > >
> > > > I have,
> > > >
> > > > or rather, I've tried to get an AOC-SASLP-MV8 card going. I thi=
nk I
> > > > can safely say that at least Linux kernel 2.6.31 is a requireme=
nt.
> > > > The card was basically useless with everything up to 2.6.30, th=
en I
> > > > tried 2.6.31-rc5 on a whim and it kicked in. Built-in driver su=
pport,
> > > > that is. However it wasn't stable, it dropped disks when syncin=
g a
> > > > large array. I've been meaning to test on 2.6.31 final, and am =
pretty
> > > > optimistic.
> > >
> > > Yeah, the driver didn't appear till .30. I have 2.6.31-git4 insta=
lled
> > > right now, and no matter what I do, the controller starts spewing
> > > errors:
> > >
> > > [ 1455.698186] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc=
=3D 5
> > > [ 1455.698196] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc=
=3D 5
> > > ...
> > > [ 1424.708085] end_request: I/O error, dev sdh, sector 3072
> > > [ 1424.708106] sd 0:0:3:0: [sdh] Unhandled error code
> > > [ 1424.708111] sd 0:0:3:0: [sdh] Result: hostbyte=3DDID_OK
> > > driverbyte=3DDRIVER_TIMEOUT
> > > [ 1424.708118] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 08 00=
 00 04
> > > 00 00
> > >
> > > And thats with perfectly good disks, and with smartd/hddtemp disa=
bled
> > > (they were causing one of my disks to barf).
> > >
> > > All I have to do is start a read from any disk, and after a few
> > > minutes, the card starts erroring out, and then dies.
> > >
> > > It actually seems like it got more unstable from .30 to .31.
> > >
> > > I've been trying to get some help with it on the lkml/ide/scsi li=
sts
> > > for a while now, one person has tried to help, but thats about it=
=2E
> >
> > Very strange. I've found that reading from all 4 drives currently
> > connected to the controller at once, works. I have 4 dd commands, o=
ne
> > reading off each drive, and so far no errors, the dd commands aren'=
t
> > locking up, and they are going full speed (120MB/s per drive).
> >
> > If however I attempt to bring up the md raid0 array ontop of these =
disks,
> >  the controller locks up, and all of the disks become inaccessible.
> >
> > Maybe it has something to do with it, but just as the system is boo=
ting,
> > I get the following, maybe related, maybe not:
> >
> > ata_id[5183]: HDIO_GET_IDENTITY failed for '/dev/block/8:96'
> > ata_id[5188]: HDIO_GET_IDENTITY failed for '/dev/block/8:112'
> > ata_id[5184]: HDIO_GET_IDENTITY failed for '/dev/block/8:80'
> >
> > (those map to sdg, sdh, and sdf in that order, no report for sde, t=
he
> > first disk in the controller)
>=20
> So I've let the controller and disks sit all day after finishing a fu=
ll
>  read test (dd if=3D/dev/sd[efgh] of=3D/dev/null bs=3D8M) with all fo=
ur 1TB
>  drives going at the same time, and I've had no errors at all. All fo=
ur dd
>  commands finished without error, and went at full speed.
>=20
> If I attempt to activate an md raid0 array ontop of any disks on this
> controller the controller starts having a fit, and all disks are
>  inaccessible till a hard reset (the machine won't fully reboot, or t=
urn
>  off, as the "flushing scsi cache" or "shutting down LVM" steps will =
hang
>  waiting on drives on the wedged controller.
>=20
> I would really like to get this fixed, if there's anything more I can=
 do to
> help narrow down the problem further, I'll do my best.
>=20

Does anyone have a clue what might be wrong? Something I could check in=
to? I=20
have a couple system migrations to do, and this is blocking that. (my o=
ld=20
array has been making "click" noises for a year now, and I'm afraid it'=
ll die=20
at any time)

--=20
Thomas Fjellstrom
tfjellstrom@shaw.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
