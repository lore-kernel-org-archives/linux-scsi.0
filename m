From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: raid1d crash at boot
Date: Tue, 22 Nov 2011 13:03:37 +0100
Message-ID: <20111122120337.GA16579@rere.qmqm.pl>
References: <20111119134139.GA30570@rere.qmqm.pl>
 <20111121123729.47c72c3b@notabene.brown>
 <1321859070.3654.7.camel@dabdike>
 <20111121192745.2c9ac9c0@notabene.brown>
 <20111122005037.GA7801@rere.qmqm.pl>
 <20111122122657.69b14108@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111122122657.69b14108@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 22, 2011 at 12:26:57PM +1100, NeilBrown wrote:
> On Tue, 22 Nov 2011 01:50:37 +0100 Micha=B3 Miros=B3aw <mirq-linux@re=
re.qmqm.pl>
> wrote:
>=20
> > On Mon, Nov 21, 2011 at 07:27:45PM +1100, NeilBrown wrote:
> > > On Mon, 21 Nov 2011 08:04:30 +0100 James Bottomley
> > > <James.Bottomley@HansenPartnership.com> wrote:
> > > > On Mon, 2011-11-21 at 12:37 +1100, NeilBrown wrote:
> > > > > Thank for the report.
> > > > > However as this crash is clearly in the SCSI layer it makes s=
ense to reported
> > > > > it to linux-scsi - so I have cc:ed this reply there.
> > > > >=20
> > > > > On Sat, 19 Nov 2011 14:41:39 +0100 Micha=B3 Miros=B3aw <mirq-=
linux@rere.qmqm.pl>
> > > > > wrote:
> > > > > > I get following BUG_ON tripped while booting, before rootfs=
 is mounted by
> > > > > > Debian's initrd. This started to happen for kernels since s=
ometime
> > > > > > during 3.1-rcX.
> > > > > >=20
> > > > > > [    6.246170] ------------[ cut here ]------------
> > > > > > [    6.246246] kernel BUG at /mnt/src-tmp/jaja/git/qmqm/dri=
vers/scsi/scsi_lib.c:1153!
> > > >=20
> > > > I can tell you what it is:
> > > >=20
> > > >         /*
> > > >          * Filesystem requests must transfer data.
> > > >          */
> > > >         BUG_ON(!req->nr_phys_segments);
> > > >=20
> > > > But the fault is in the layer above SCSI.  It means something s=
ent a
> > > > request with REQ_TYPE_FS but no actual data attached ... this i=
s
> > > > supposed to be impossible, hence the bug on.
> > >=20
> > > Thanks.... that sounds strangely familiar, but I cannot be sure a=
nd google
> > > doesn't help.
> > >=20
> > > Micha=B3: what are you using on the RAID1 - some filesystem (whic=
h one)or swap or something else?
> >=20
> > The whole stack is: ext4 over lvm over dm-crypt over md-raid1 over =
SATA
> > drives.  The boot doesn't survive to the point where the initrd scr=
ipt asks
> > for md-crypt's key password.
> >
>=20
> That gives us lots of room for pointing the finger of blame, doesn't =
it?
> I think it is -> his problem. :-)
>=20
> From the md part of the stack trace it looks most like a write reques=
t.  It
> could be a retried read, but that is extremely unlike that early in b=
oot.
>=20
> So presumably it is some sort of zero-length REQ_FLUSH or something l=
ike that.
> md/raid1 will just pass those unchanged down.=20
> My guess is that ext4 is generating this and something in the stack i=
s
> stripping the REQ_FLUSH .... though why it even tries before asking f=
or a
> password is beyond me.

I pointed finger at md because when dm-crypt is not yet set up
then only thing working is the array.  All filesystems need the
dm-crypt mapping first.

=46rom the dmesg on 3.0, I see that NCQ is enabled but FUA is not:

[    2.269487] ata1: SATA max UDMA/133 abar m2048@0xfbd25000 port 0xfbd=
25100 irq 64
[    2.588395] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.588979] ata1.00: ATA-8: KINGSTON SV100S264G, D110225a, max UDMA/=
100
[    2.589037] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 3=
1/32), AA
[    2.589321] ata1.00: configured for UDMA/100
[    2.589440] scsi 1:0:0:0: Direct-Access     ATA      KINGSTON SV100S=
2 D110 PQ: 0 ANSI: 5
[    2.631113] sd 1:0:0:0: [sda] 125045424 512-byte logical blocks: (64=
=2E0 GB/59.6 GiB)
[    2.631265] sd 1:0:0:0: [sda] Write Protect is off
[    2.631267] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.631296] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
[    2.632119] sd 1:0:0:0: [sda] Attached SCSI disk

[    2.269557] ata2: SATA max UDMA/133 abar m2048@0xfbd25000 port 0xfbd=
25180 irq 64
[    2.588916] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.628336] ata2.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    2.628396] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 3=
1/32)
[    2.630143] ata2.00: configured for UDMA/133
[    2.630238] scsi 2:0:0:0: Direct-Access     ATA      ST9500420AS    =
  0002 PQ: 0 ANSI: 5
[    2.631236] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (50=
0 GB/465 GiB)
[    2.631792] sd 2:0:0:0: [sdb] Write Protect is off
[    2.632031] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.632050] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
[    2.636038] sd 2:0:0:0: [sdb] Attached SCSI disk

There's two RAID1 array on both of the disks, and one more RAID1 (with =
second
leg missing) on sdb.

> diff --git a/block/blk-core.c b/block/blk-core.c
> index f43c8a5..59cb2ad 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1560,7 +1560,7 @@ generic_make_request_checks(struct bio *bio)
>  			goto end_io;
>  		}
>  	}
> -
> +	WARN_ON(((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && nr_sectors =3D=3D =
0);
>  	if ((bio->bi_rw & REQ_DISCARD) &&
>  	    (!blk_queue_discard(q) ||
>  	     ((bio->bi_rw & REQ_SECURE) &&

I'll try that. I hope it can be caught through netconsole.

Best Regards,
Micha=B3 Miros=B3aw
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
