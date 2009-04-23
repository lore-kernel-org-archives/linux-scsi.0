From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2 of 8] block: Export I/O topology for block devices and  partitions
Date: Thu, 23 Apr 2009 05:49:59 -0600
Message-ID: <20090423114959.GL1926@parisc-linux.org>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <cbdae69a14895dab8ba7.1240464569@sermon.lab.mkp.net> <20090423105145.GW4593@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48687 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbZDWLuA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2009 07:50:00 -0400
Content-Disposition: inline
In-Reply-To: <20090423105145.GW4593@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 23, 2009 at 12:51:45PM +0200, Jens Axboe wrote:
> > +/**
> > + * blk_queue_alignment - set alignment for the queue
> > + * @q:  the request queue for the device
> > + * @alignment:  alignment offset in bytes
> > + *
> > + * Description:
> > + *   Some devices are naturally misaligned to compensate for things like
> > + *   the legacy DOS partition table 63-sector offset.  Low-level drivers
> > + *   should call this function for devices whose first sector is not
> > + *   naturally aligned.
> > + */
> > +void blk_queue_alignment(struct request_queue *q, unsigned int alignment)
> > +{
> > +	q->alignment = alignment & (q->granularity - 1);
> > +	clear_bit(QUEUE_FLAG_MISALIGNED, &q->queue_flags);
> > +}
> > +EXPORT_SYMBOL(blk_queue_alignment);
> 
> How would low-level drivers know?

ATA reports this in the INQUIRY data.  SCSI reports it in READ CAPACITY 16.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
