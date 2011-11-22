From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: raid1d crash at boot
Date: Tue, 22 Nov 2011 13:10:41 +0100
Message-ID: <20111122121041.GB16579@rere.qmqm.pl>
References: <20111119134139.GA30570@rere.qmqm.pl>
 <20111121123729.47c72c3b@notabene.brown>
 <1321859070.3654.7.camel@dabdike>
 <20111121192745.2c9ac9c0@notabene.brown>
 <20111122005037.GA7801@rere.qmqm.pl>
 <20111122122657.69b14108@notabene.brown>
 <20111122120337.GA16579@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([89.167.52.164]:44020 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab1KVMKm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Nov 2011 07:10:42 -0500
Content-Disposition: inline
In-Reply-To: <20111122120337.GA16579@rere.qmqm.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>

On Tue, Nov 22, 2011 at 01:03:37PM +0100, Micha=B3 Miros=B3aw wrote:
> On Tue, Nov 22, 2011 at 12:26:57PM +1100, NeilBrown wrote:
> > On Tue, 22 Nov 2011 01:50:37 +0100 Micha=B3 Miros=B3aw <mirq-linux@=
rere.qmqm.pl>
> > wrote:
> >=20
> > > On Mon, Nov 21, 2011 at 07:27:45PM +1100, NeilBrown wrote:
> > > > On Mon, 21 Nov 2011 08:04:30 +0100 James Bottomley
> > > > <James.Bottomley@HansenPartnership.com> wrote:
> > > > > On Mon, 2011-11-21 at 12:37 +1100, NeilBrown wrote:
> > > > > > Thank for the report.
> > > > > > However as this crash is clearly in the SCSI layer it makes=
 sense to reported
> > > > > > it to linux-scsi - so I have cc:ed this reply there.
> > > > > >=20
> > > > > > On Sat, 19 Nov 2011 14:41:39 +0100 Micha=B3 Miros=B3aw <mir=
q-linux@rere.qmqm.pl>
> > > > > > wrote:
> > > > > > > I get following BUG_ON tripped while booting, before root=
fs is mounted by
> > > > > > > Debian's initrd. This started to happen for kernels since=
 sometime
> > > > > > > during 3.1-rcX.
> > > > > > >=20
> > > > > > > [    6.246170] ------------[ cut here ]------------
> > > > > > > [    6.246246] kernel BUG at /mnt/src-tmp/jaja/git/qmqm/d=
rivers/scsi/scsi_lib.c:1153!
> > > > >=20
> > > > > I can tell you what it is:
> > > > >=20
> > > > >         /*
> > > > >          * Filesystem requests must transfer data.
> > > > >          */
> > > > >         BUG_ON(!req->nr_phys_segments);
> > > > >=20
> > > > > But the fault is in the layer above SCSI.  It means something=
 sent a
> > > > > request with REQ_TYPE_FS but no actual data attached ... this=
 is
> > > > > supposed to be impossible, hence the bug on.
> > > >=20
> > > > Thanks.... that sounds strangely familiar, but I cannot be sure=
 and google
> > > > doesn't help.
> > > >=20
> > > > Micha=B3: what are you using on the RAID1 - some filesystem (wh=
ich one)or swap or something else?
> > >=20
> > > The whole stack is: ext4 over lvm over dm-crypt over md-raid1 ove=
r SATA
> > > drives.  The boot doesn't survive to the point where the initrd s=
cript asks
> > > for md-crypt's key password.
> > >
> >=20
> > That gives us lots of room for pointing the finger of blame, doesn'=
t it?
> > I think it is -> his problem. :-)
> >=20
> > From the md part of the stack trace it looks most like a write requ=
est.  It
> > could be a retried read, but that is extremely unlike that early in=
 boot.
> >=20
> > So presumably it is some sort of zero-length REQ_FLUSH or something=
 like that.
> > md/raid1 will just pass those unchanged down.=20
> > My guess is that ext4 is generating this and something in the stack=
 is
> > stripping the REQ_FLUSH .... though why it even tries before asking=
 for a
> > password is beyond me.
>=20
> I pointed finger at md because when dm-crypt is not yet set up
> then only thing working is the array.  All filesystems need the
> dm-crypt mapping first.
>=20
> From the dmesg on 3.0, I see that NCQ is enabled but FUA is not:
>=20
> [    2.269487] ata1: SATA max UDMA/133 abar m2048@0xfbd25000 port 0xf=
bd25100 irq 64
> [    2.588395] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.588979] ata1.00: ATA-8: KINGSTON SV100S264G, D110225a, max UDM=
A/100
> [    2.589037] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth=
 31/32), AA
> [    2.589321] ata1.00: configured for UDMA/100
> [    2.589440] scsi 1:0:0:0: Direct-Access     ATA      KINGSTON SV10=
0S2 D110 PQ: 0 ANSI: 5
> [    2.631113] sd 1:0:0:0: [sda] 125045424 512-byte logical blocks: (=
64.0 GB/59.6 GiB)
> [    2.631265] sd 1:0:0:0: [sda] Write Protect is off
> [    2.631267] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.631296] sd 1:0:0:0: [sda] Write cache: enabled, read cache: en=
abled, doesn't support DPO or FUA
> [    2.632119] sd 1:0:0:0: [sda] Attached SCSI disk
>=20
> [    2.269557] ata2: SATA max UDMA/133 abar m2048@0xfbd25000 port 0xf=
bd25180 irq 64
> [    2.588916] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.628336] ata2.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
> [    2.628396] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth=
 31/32)
> [    2.630143] ata2.00: configured for UDMA/133
> [    2.630238] scsi 2:0:0:0: Direct-Access     ATA      ST9500420AS  =
    0002 PQ: 0 ANSI: 5
> [    2.631236] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (=
500 GB/465 GiB)
> [    2.631792] sd 2:0:0:0: [sdb] Write Protect is off
> [    2.632031] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    2.632050] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: en=
abled, doesn't support DPO or FUA
> [    2.636038] sd 2:0:0:0: [sdb] Attached SCSI disk
>=20
> There's two RAID1 array on both of the disks, and one more RAID1 (wit=
h second
> leg missing) on sdb.

I just remembered that the sdb leg of the main array has write-mostly f=
lag
set. I checked /proc/mdstat from running system and it turns out that n=
ow
I have both legs marked so. Does this ring a bell?

cat /proc/mdstat
Personalities : [raid1]
md2 : active (auto-read-only) raid1 sdb3[0]
      425862712 blocks super 1.2 [2/1] [U_]

md1 : active raid1 sda2[3](W) sdb2[2](W)
      62396688 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sda1[0] sdb1[1]
      123892 blocks super 1.2 [2/2] [UU]

unused devices: <none>

Best Regards,
Micha=B3 Miros=B3aw
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
