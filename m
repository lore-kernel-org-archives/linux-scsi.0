From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BUG in kernel: Wrong Handling of USB =?UTF-8?Q?HDD=E2=80=99s?=
 in scsiglue(slave_configure) and scsi/sd(sd_read_cache_type)
Date: Wed, 28 Sep 2011 16:29:43 -0500
Message-ID: <1317245383.22022.23.camel@dabdike.hansenpartnership.com>
References: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
	 <CADDb1s3KjMugBGwLmjoPv93hJVBCjkD81o8F0CZxJXXt+-Fk2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s3KjMugBGwLmjoPv93hJVBCjkD81o8F0CZxJXXt+-Fk2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-09-28 at 21:27 +0530, Amit Sahrawat wrote:
> Marking mail to linux-scsi.
>=20
> Thanks Christoph.
>=20
> Regards,
> Amit Sahrawat
>=20
> On Wed, Sep 28, 2011 at 9:12 PM, Amit Sahrawat
> <amit.sahrawat83@gmail.com> wrote:
> > When a USB HDD is connected to the device, it invokes slave_configu=
re
> > to configure the USB HDD. In this function, whenever there is a SCS=
I
> > device of type TYPE_DISK, it sets:
> >        /* A number of devices have problems with MODE SENSE for
> >                 * page x08, so we will skip it. */
> >                sdev->skip_ms_page_8 =3D 1;
> >
> > Now, as a part of SCSI device probing, in the function
> > sd_revalidate_disk()-->sd_read_cache_type(), there is a condition
> > if (sdp->skip_ms_page_8)
> >                goto defaults;
> > which becomes always true for all the USB HDD=E2=80=99s =E2=80=93 t=
he net result is
> > that the Write Cache is never considered for USB HDD(WCE =3D 0) =E2=
=80=93
> > =E2=80=9CAssuming drive cache: write through=E2=80=9D
> >
> > What=E2=80=99s more =E2=80=93 the QUEUE ordering which is marked fo=
r WCE=3D0 is
> > QUEUE_ORDERED_DRAIN, instead of QUEUE_ORDERED_DRAIN_FLUSH
> > This means there is no flushing of USB HDD internal cache (although
> > SYNCHRONIZE_CACHE is implemented as passed as command in
> > sd_prepare_flush) =E2=80=93 queue_flush()(called in function
> > blk_do_ordered()-->start_ordered()) does not gets called in case of
> > QUEUE_ORDERED_DRAIN.
> >
> > This causes a serious impact on USB HDD=E2=80=99s.
> >
> > Please let me know in case I have missed something in my observatio=
ns.

This should be working in 3.0 ... what version of the kernel are you
testing.  The actual patch that relaxes the caching mode page check is
this one:

commit 0bcaa11154f07502e68375617e5650173eea8e50
Author: Luben Tuikov <ltuikov@yahoo.com>
Date:   Thu May 19 00:00:58 2011 -0700

    [SCSI] Retrieve the Caching mode page (version 2)

James
