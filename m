From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.39-rc6: cdrecord oops
Date: Wed, 4 May 2011 12:32:50 -0700
Message-ID: <BANLkTi=-Qv4eUbhS0QGdyX9Q8oQ8VYcD5A@mail.gmail.com>
References: <20110504190707.GA4521@p183>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999Ab1EDTdo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2011 15:33:44 -0400
Received: from mail-vx0-f174.google.com (mail-vx0-f174.google.com [209.85.220.174])
	(authenticated bits=0)
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p44JXCR7025659
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 4 May 2011 12:33:12 -0700
Received: by vxi39 with SMTP id 39so1488325vxi.19
        for <linux-scsi@vger.kernel.org>; Wed, 04 May 2011 12:33:10 -0700 (PDT)
In-Reply-To: <20110504190707.GA4521@p183>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk

On Wed, May 4, 2011 at 12:07 PM, Alexey Dobriyan <adobriyan@gmail.com> =
wrote:
> Got one at the very end of burning session (haven't tried to reproduc=
e yet).
> Apparently happened when cdrecord tried to open the door.
>
> =A0 =A0 =A0 =A0__lock_acquire
> =A0 =A0 =A0 =A0lock_acquire
> =A0 =A0 =A0 =A0_raw_spin_lock_irq
> =A0 =A0 =A0 =A0blk_get_request

Hmm. That would be the

  spin_lock_irq(q->queue_lock);

in there, I'm not seeing any other spinlock.

> =A0 =A0 =A0 =A0scsi_execute
> =A0 =A0 =A0 =A0scsi_set_medium_removal
> =A0 =A0 =A0 =A0sr_lock_door
> =A0 =A0 =A0 =A0cdrom_release
> =A0 =A0 =A0 =A0sr_block_release
> =A0 =A0 =A0 =A0__blk_dev_put
> =A0 =A0 =A0 =A0blkdev_put
> =A0 =A0 =A0 =A0blkdev_close
> =A0 =A0 =A0 =A0fput
> =A0 =A0 =A0 =A0filp_close
> =A0 =A0 =A0 =A0sys_close
>
> comm: cdrecord
> RAX was small number like 0x46(?)
> RBX 6b6b6b6b6b6b6b83
> RDI 6b6b6b6b6b6b6b83

And that implies that 'q' has been free'd before it's used, and you
have SLUB-debugging turned on.

> This model is USB device.

Hmm. It looks a bit odd that cdrom_release() does the ->release call
before it does the ->tray_move thing, but I don't think that's it.

Jens/James: What's the sequence to blk_cleanup_queue() for a SCSI
CD-ROM? It really does look like we're releasing the queue before
we're done with it.

                      Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
