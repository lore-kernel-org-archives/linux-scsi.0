From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Mon, 18 Jul 2011 09:59:46 -0700
Message-ID: <CAA9_cmcPhkA5myxeR5aJWBQ=-C3VuG_M9Appp5WyrLoU5fnw2w@mail.gmail.com>
References: <20110702181146.GM23059@one.firstfloor.org>
	<Pine.LNX.4.44L0.1107021544550.16190-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1107021544550.16190-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>, axboe@kernel.dk, James Bottomley <James.Bottomley@hansenpartnership.com>, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 2, 2011 at 12:59 PM, Alan Stern <stern@rowland.harvard.edu>=
 wrote:
> On Sat, 2 Jul 2011, Andi Kleen wrote:
>
>> > The problem is that blk_peek_request() calls scsi_prep_fn(), which
>> > does this:
>> >
>> > =A0 =A0 struct scsi_device *sdev =3D q->queuedata;
>> > =A0 =A0 int ret =3D BLKPREP_KILL;
>> >
>> > =A0 =A0 if (req->cmd_type =3D=3D REQ_TYPE_BLOCK_PC)
>> > =A0 =A0 =A0 =A0 =A0 =A0 ret =3D scsi_setup_blk_pc_cmnd(sdev, req);
>> > =A0 =A0 return scsi_prep_return(q, req, ret);
>> >
>> > It doesn't check to see if sdev is NULL, nor does
>> > scsi_setup_blk_pc_cmnd(). =A0That accounts for this error:
>>
>> I actually added a NULL check in scsi_setup_blk_pc_cmnd early on,
>> but that just caused RCU CPU stalls afterwards and then eventually
>> a hung system.
>
> The RCU problem is likely to be a separate issue. =A0It might even be=
 a
> result of the use-after-free problem with the elevator.
>
> At any rate, it's clear that the crash in the refcounting log you
> posted occurred because scsi_setup_blk_pc_cmnd() called
> scsi_prep_state_check(), which tried to dereference the NULL pointer.
>
> Would you like to try this patch to see if it fixes the problem? =A0A=
s I
> said before, I'm not certain it's the best thing to do, but it worked
> on my system.
>
> Alan Stern
>
>
>
>
> Index: usb-3.0/drivers/scsi/scsi_lib.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-3.0.orig/drivers/scsi/scsi_lib.c
> +++ usb-3.0/drivers/scsi/scsi_lib.c
> @@ -1247,6 +1247,8 @@ int scsi_prep_fn(struct request_queue *q
> =A0 =A0 =A0 =A0struct scsi_device *sdev =3D q->queuedata;
> =A0 =A0 =A0 =A0int ret =3D BLKPREP_KILL;
>
> + =A0 =A0 =A0 if (!sdev)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> =A0 =A0 =A0 =A0if (req->cmd_type =3D=3D REQ_TYPE_BLOCK_PC)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D scsi_setup_blk_pc_cmnd(sdev, r=
eq);
> =A0 =A0 =A0 =A0return scsi_prep_return(q, req, ret);
> Index: usb-3.0/drivers/scsi/scsi_sysfs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-3.0.orig/drivers/scsi/scsi_sysfs.c
> +++ usb-3.0/drivers/scsi/scsi_sysfs.c
> @@ -322,6 +322,8 @@ static void scsi_device_dev_release_user
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(evt);
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 /* Freeing the queue signals to block that we're done *=
/
> + =A0 =A0 =A0 scsi_free_queue(sdev->request_queue);
> =A0 =A0 =A0 =A0blk_put_queue(sdev->request_queue);
> =A0 =A0 =A0 =A0/* NULL queue means the device can't be used */
> =A0 =A0 =A0 =A0sdev->request_queue =3D NULL;
> @@ -936,8 +938,6 @@ void __scsi_remove_device(struct scsi_de
> =A0 =A0 =A0 =A0/* cause the request function to reject all I/O reques=
ts */
> =A0 =A0 =A0 =A0sdev->request_queue->queuedata =3D NULL;
>
> - =A0 =A0 =A0 /* Freeing the queue signals to block that we're done *=
/
> - =A0 =A0 =A0 scsi_free_queue(sdev->request_queue);
> =A0 =A0 =A0 =A0put_device(dev);
> =A0}

This patch seems to resolve the block/scsi null-ptr de-references in
our libsas/isci environment, we have yet to try James' alternative
[1].  Do we potentially need both?

Commit 86cbfb56 moved scsi_free_queue to __scsi_remove_device() but it
seems only the "sdev->request_queue->queuedata =3D NULL" needed to be
moved?

The conversation appeared to be awaiting test results...

[1]: http://marc.info/?l=3Dlinux-scsi&m=3D131007155700831&w=3D2

--
Dan
