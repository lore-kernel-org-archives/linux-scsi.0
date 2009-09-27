From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: mdraid causing mvsas to lockup?
Date: Sat, 26 Sep 2009 21:34:13 -0600
Message-ID: <200909262134.13267.tfjellstrom@shaw.ca>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <200909181702.46109.tfjellstrom@shaw.ca> <200909211016.45679.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909211016.45679.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon September 21 2009, Thomas Fjellstrom wrote:
> On Fri September 18 2009, Thomas Fjellstrom wrote:
> > On Fri September 18 2009, Thomas Fjellstrom wrote:
> > > On Thu September 17 2009, Thomas Fjellstrom wrote:
> > > > On Thu September 17 2009, Kristleifur Da=F0ason wrote:
> > > > > On Thu, Sep 17, 2009 at 11:02 PM, Thomas Fjellstrom
> > > > > <tfjellstrom@shaw.ca>
> > > >
> > > > wrote:
> > > > > > On Thu September 17 2009, John Bridges wrote:
> > > > > >> I'm a fan of the SuperMicro AOC-SAT2-MV8, great card.
> > > > > >> http://www.supermicro.com/products/accessories/addon/AOC-S=
AT2-MV
> > > > > >>8. cf m
> > > > > >>
> > > > > >> It's an 8 port PCI-X card, works in both PCI and PCI-X slo=
ts.
> > > > > >>
> > > > > >> SATA2
> > > > > >>
> > > > > >> Drivers for Linux are stable, built in.
> > > > > >
> > > > > > Have you had any experience with the AOC-SASLP-MV8? I've go=
t one
> > > > > > and have been having no end of issues with it under linux.
> > > > > >
> > > > > > --
> > > > > > Thomas Fjellstrom
> > > > > > tfjellstrom@shaw.ca
> > > > > > --
> > > > >
> > > > > I have,
> > > > >
> > > > > or rather, I've tried to get an AOC-SASLP-MV8 card going. I t=
hink I
> > > > > can safely say that at least Linux kernel 2.6.31 is a require=
ment.
> > > > > The card was basically useless with everything up to 2.6.30, =
then I
> > > > > tried 2.6.31-rc5 on a whim and it kicked in. Built-in driver
> > > > > support, that is. However it wasn't stable, it dropped disks =
when
> > > > > syncing a large array. I've been meaning to test on 2.6.31 fi=
nal,
> > > > > and am pretty optimistic.
> > > >
> > > > Yeah, the driver didn't appear till .30. I have 2.6.31-git4 ins=
talled
> > > > right now, and no matter what I do, the controller starts spewi=
ng
> > > > errors:
> > > >
> > > > [ 1455.698186] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:=
rc=3D 5
> > > > [ 1455.698196] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:=
rc=3D 5
> > > > ...
> > > > [ 1424.708085] end_request: I/O error, dev sdh, sector 3072
> > > > [ 1424.708106] sd 0:0:3:0: [sdh] Unhandled error code
> > > > [ 1424.708111] sd 0:0:3:0: [sdh] Result: hostbyte=3DDID_OK
> > > > driverbyte=3DDRIVER_TIMEOUT
> > > > [ 1424.708118] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 08 =
00 00
> > > > 04 00 00
> > > >
> > > > And thats with perfectly good disks, and with smartd/hddtemp di=
sabled
> > > > (they were causing one of my disks to barf).
> > > >
> > > > All I have to do is start a read from any disk, and after a few
> > > > minutes, the card starts erroring out, and then dies.
> > > >
> > > > It actually seems like it got more unstable from .30 to .31.
> > > >
> > > > I've been trying to get some help with it on the lkml/ide/scsi =
lists
> > > > for a while now, one person has tried to help, but thats about =
it.
> > >
> > > Very strange. I've found that reading from all 4 drives currently
> > > connected to the controller at once, works. I have 4 dd commands,=
 one
> > > reading off each drive, and so far no errors, the dd commands are=
n't
> > > locking up, and they are going full speed (120MB/s per drive).
> > >
> > > If however I attempt to bring up the md raid0 array ontop of thes=
e
> > > disks, the controller locks up, and all of the disks become
> > > inaccessible.
> > >
> > > Maybe it has something to do with it, but just as the system is
> > > booting, I get the following, maybe related, maybe not:
> > >
> > > ata_id[5183]: HDIO_GET_IDENTITY failed for '/dev/block/8:96'
> > > ata_id[5188]: HDIO_GET_IDENTITY failed for '/dev/block/8:112'
> > > ata_id[5184]: HDIO_GET_IDENTITY failed for '/dev/block/8:80'
> > >
> > > (those map to sdg, sdh, and sdf in that order, no report for sde,=
 the
> > > first disk in the controller)
> >
> > So I've let the controller and disks sit all day after finishing a =
full
> >  read test (dd if=3D/dev/sd[efgh] of=3D/dev/null bs=3D8M) with all =
four 1TB
> >  drives going at the same time, and I've had no errors at all. All =
four
> > dd commands finished without error, and went at full speed.
> >
> > If I attempt to activate an md raid0 array ontop of any disks on th=
is
> > controller the controller starts having a fit, and all disks are
> >  inaccessible till a hard reset (the machine won't fully reboot, or=
 turn
> >  off, as the "flushing scsi cache" or "shutting down LVM" steps wil=
l hang
> >  waiting on drives on the wedged controller.
> >
> > I would really like to get this fixed, if there's anything more I c=
an do
> > to help narrow down the problem further, I'll do my best.
>=20
> Does anyone have a clue what might be wrong? Something I could check =
into?
>  I have a couple system migrations to do, and this is blocking that. =
(my
>  old array has been making "click" noises for a year now, and I'm afr=
aid
>  it'll die at any time)
>=20

After trying to get an array up on this card, it locked up again. (the =
array=20
that is:)

[ 1762.705866] sd 0:0:0:0: [sdc] Unhandled error code
[ 1762.705873] sd 0:0:0:0: [sdc] Result: hostbyte=3DDID_OK=20
driverbyte=3DDRIVER_TIMEOUT
[ 1762.705882] sd 0:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 01 77 00 02=
 c8 00
[ 1947.698246] sd 0:0:0:0: [sdc] Unhandled error code
[ 1947.698268] sd 0:0:0:0: [sdc] Result: hostbyte=3DDID_OK=20
driverbyte=3DDRIVER_TIMEOUT
[ 1947.698277] sd 0:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 02 3f 00 00=
 08 00
[ 1947.698308] __ratelimit: 79 callbacks suppressed

[13470.701276] sd 0:0:0:0: [sdc] Unhandled error code
[13470.701283] sd 0:0:0:0: [sdc] Result: hostbyte=3DDID_OK=20
driverbyte=3DDRIVER_TIMEOUT
[13470.701292] sd 0:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 00 00 00 00=
 20 00
[13470.701381] sd 0:0:1:0: [sdd] Unhandled error code
[13470.701385] sd 0:0:1:0: [sdd] Result: hostbyte=3DDID_OK=20
driverbyte=3DDRIVER_TIMEOUT
[13470.701393] sd 0:0:1:0: [sdd] CDB: Read(10): 28 00 00 00 00 00 00 00=
 20 00
[13470.701458] sd 0:0:2:0: [sde] Unhandled error code
[13470.701463] sd 0:0:2:0: [sde] Result: hostbyte=3DDID_OK=20
driverbyte=3DDRIVER_TIMEOUT
[13470.701470] sd 0:0:2:0: [sde] CDB: Read(10): 28 00 00 00 00 00 00 00=
 20 00
[13470.701523] sd 0:0:3:0: [sdf] Unhandled error code
[13470.701527] sd 0:0:3:0: [sdf] Result: hostbyte=3DDID_OK=20
driverbyte=3DDRIVER_TIMEOUT
[13470.701535] sd 0:0:3:0: [sdf] CDB: Read(10): 28 00 00 00 00 00 00 00=
 20 00

then as the fan in my hot swap bay is failing, I decided to remove the =
drives=20
to get the unit to stop the fan. Then the entire system locked up hard,=
=20
keyboard LEDs blinking and everything.

--=20
Thomas Fjellstrom
tfjellstrom@shaw.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
