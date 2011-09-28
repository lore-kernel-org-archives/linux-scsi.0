From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: =?windows-1252?Q?Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD=92s_in_?=
	=?windows-1252?Q?scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5Ftype=29?=
Date: Wed, 28 Sep 2011 21:27:23 +0530
Message-ID: <CADDb1s3KjMugBGwLmjoPv93hJVBCjkD81o8F0CZxJXXt+-Fk2A@mail.gmail.com>
References: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Marking mail to linux-scsi.

Thanks Christoph.

Regards,
Amit Sahrawat

On Wed, Sep 28, 2011 at 9:12 PM, Amit Sahrawat
<amit.sahrawat83@gmail.com> wrote:
> When a USB HDD is connected to the device, it invokes slave_configure
> to configure the USB HDD. In this function, whenever there is a SCSI
> device of type TYPE_DISK, it sets:
> =A0 =A0 =A0 =A0/* A number of devices have problems with MODE SENSE f=
or
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * page x08, so we will skip it. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sdev->skip_ms_page_8 =3D 1;
>
> Now, as a part of SCSI device probing, in the function
> sd_revalidate_disk()-->sd_read_cache_type(), there is a condition
> if (sdp->skip_ms_page_8)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto defaults;
> which becomes always true for all the USB HDD=92s =96 the net result =
is
> that the Write Cache is never considered for USB HDD(WCE =3D 0) =96
> =93Assuming drive cache: write through=94
>
> What=92s more =96 the QUEUE ordering which is marked for WCE=3D0 is
> QUEUE_ORDERED_DRAIN, instead of QUEUE_ORDERED_DRAIN_FLUSH
> This means there is no flushing of USB HDD internal cache (although
> SYNCHRONIZE_CACHE is implemented as passed as command in
> sd_prepare_flush) =96 queue_flush()(called in function
> blk_do_ordered()-->start_ordered()) does not gets called in case of
> QUEUE_ORDERED_DRAIN.
>
> This causes a serious impact on USB HDD=92s.
>
> Please let me know in case I have missed something in my observations=
=2E
>
> Thanks & Regards,
> Amit Sahrawat
>
