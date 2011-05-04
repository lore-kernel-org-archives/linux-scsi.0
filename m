From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.39-rc6: cdrecord oops
Date: Wed, 4 May 2011 22:45:56 +0300
Message-ID: <20110504194555.GA4492@p183>
References: <20110504190707.GA4521@p183>
 <BANLkTi=-Qv4eUbhS0QGdyX9Q8oQ8VYcD5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39591 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1EDTqB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2011 15:46:01 -0400
Received: by bwz15 with SMTP id 15so1270786bwz.19
        for <linux-scsi@vger.kernel.org>; Wed, 04 May 2011 12:46:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <BANLkTi=-Qv4eUbhS0QGdyX9Q8oQ8VYcD5A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk

On Wed, May 04, 2011 at 12:32:50PM -0700, Linus Torvalds wrote:
> On Wed, May 4, 2011 at 12:07 PM, Alexey Dobriyan <adobriyan@gmail.com=
> wrote:
> > Got one at the very end of burning session (haven't tried to reprod=
uce yet).
> > Apparently happened when cdrecord tried to open the door.
> >
> > =A0 =A0 =A0 =A0__lock_acquire
> > =A0 =A0 =A0 =A0lock_acquire
> > =A0 =A0 =A0 =A0_raw_spin_lock_irq
> > =A0 =A0 =A0 =A0blk_get_request
>=20
> Hmm. That would be the
>=20
>   spin_lock_irq(q->queue_lock);
>=20
> in there, I'm not seeing any other spinlock.
>=20
> > =A0 =A0 =A0 =A0scsi_execute
> > =A0 =A0 =A0 =A0scsi_set_medium_removal
> > =A0 =A0 =A0 =A0sr_lock_door
> > =A0 =A0 =A0 =A0cdrom_release
> > =A0 =A0 =A0 =A0sr_block_release
> > =A0 =A0 =A0 =A0__blk_dev_put
> > =A0 =A0 =A0 =A0blkdev_put
> > =A0 =A0 =A0 =A0blkdev_close
> > =A0 =A0 =A0 =A0fput
> > =A0 =A0 =A0 =A0filp_close
> > =A0 =A0 =A0 =A0sys_close
> >
> > comm: cdrecord
> > RAX was small number like 0x46(?)
> > RBX 6b6b6b6b6b6b6b83
> > RDI 6b6b6b6b6b6b6b83
>=20
> And that implies that 'q' has been free'd before it's used, and you
> have SLUB-debugging turned on.
>=20
> > This model is USB device.
>=20
> Hmm. It looks a bit odd that cdrom_release() does the ->release call
> before it does the ->tray_move thing, but I don't think that's it.
>=20
> Jens/James: What's the sequence to blk_cleanup_queue() for a SCSI
> CD-ROM? It really does look like we're releasing the queue before
> we're done with it.

Second time, burning finished to the end successfully.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
