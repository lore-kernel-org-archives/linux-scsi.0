From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: raid1d crash at boot
Date: Tue, 22 Nov 2011 01:50:37 +0100
Message-ID: <20111122005037.GA7801@rere.qmqm.pl>
References: <20111119134139.GA30570@rere.qmqm.pl>
 <20111121123729.47c72c3b@notabene.brown>
 <1321859070.3654.7.camel@dabdike>
 <20111121192745.2c9ac9c0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111121192745.2c9ac9c0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 21, 2011 at 07:27:45PM +1100, NeilBrown wrote:
> On Mon, 21 Nov 2011 08:04:30 +0100 James Bottomley
> <James.Bottomley@HansenPartnership.com> wrote:
> > On Mon, 2011-11-21 at 12:37 +1100, NeilBrown wrote:
> > > Thank for the report.
> > > However as this crash is clearly in the SCSI layer it makes sense=
 to reported
> > > it to linux-scsi - so I have cc:ed this reply there.
> > >=20
> > > On Sat, 19 Nov 2011 14:41:39 +0100 Micha=B3 Miros=B3aw <mirq-linu=
x@rere.qmqm.pl>
> > > wrote:
> > > > I get following BUG_ON tripped while booting, before rootfs is =
mounted by
> > > > Debian's initrd. This started to happen for kernels since somet=
ime
> > > > during 3.1-rcX.
> > > >=20
> > > > [    6.246170] ------------[ cut here ]------------
> > > > [    6.246246] kernel BUG at /mnt/src-tmp/jaja/git/qmqm/drivers=
/scsi/scsi_lib.c:1153!
> >=20
> > I can tell you what it is:
> >=20
> >         /*
> >          * Filesystem requests must transfer data.
> >          */
> >         BUG_ON(!req->nr_phys_segments);
> >=20
> > But the fault is in the layer above SCSI.  It means something sent =
a
> > request with REQ_TYPE_FS but no actual data attached ... this is
> > supposed to be impossible, hence the bug on.
>=20
> Thanks.... that sounds strangely familiar, but I cannot be sure and g=
oogle
> doesn't help.
>=20
> Micha=B3: what are you using on the RAID1 - some filesystem (which on=
e)or swap or something else?

The whole stack is: ext4 over lvm over dm-crypt over md-raid1 over SATA
drives.  The boot doesn't survive to the point where the initrd script =
asks
for md-crypt's key password.

Best Regards,
Micha=B3 Miros=B3aw
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
