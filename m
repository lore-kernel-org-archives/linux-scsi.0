From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: raid1d crash at boot
Date: Mon, 21 Nov 2011 08:04:30 +0100
Message-ID: <1321859070.3654.7.camel@dabdike>
References: <20111119134139.GA30570@rere.qmqm.pl>
	 <20111121123729.47c72c3b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111121123729.47c72c3b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-11-21 at 12:37 +1100, NeilBrown wrote:
> Thank for the report.
> However as this crash is clearly in the SCSI layer it makes sense to =
reported
> it to linux-scsi - so I have cc:ed this reply there.
>=20
> NeilBrown
>=20
>=20
> On Sat, 19 Nov 2011 14:41:39 +0100 Micha=C5=82 Miros=C5=82aw <mirq-li=
nux@rere.qmqm.pl>
> wrote:
>=20
> > I get following BUG_ON tripped while booting, before rootfs is moun=
ted by
> > Debian's initrd. This started to happen for kernels since sometime
> > during 3.1-rcX.
> >=20
> > [    6.246170] ------------[ cut here ]------------
> > [    6.246246] kernel BUG at /mnt/src-tmp/jaja/git/qmqm/drivers/scs=
i/scsi_lib.c:1153!

I can tell you what it is:

        /*
         * Filesystem requests must transfer data.
         */
        BUG_ON(!req->nr_phys_segments);

But the fault is in the layer above SCSI.  It means something sent a
request with REQ_TYPE_FS but no actual data attached ... this is
supposed to be impossible, hence the bug on.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
