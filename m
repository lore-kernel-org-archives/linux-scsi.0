From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH 2 of 8] block: Export I/O topology for block devices
	and  partitions
Date: Thu, 23 Apr 2009 14:13:12 -0400
Message-ID: <20090423181312.GA8768@mars.virtualiron.com>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <cbdae69a14895dab8ba7.1240464569@sermon.lab.mkp.net> <20090423105145.GW4593@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-216-57-134-2.customer.veroxity.net ([216.57.134.2]:61659
	"EHLO mars.virtualiron.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756866AbZDWSQF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 14:16:05 -0400
Content-Disposition: inline
In-Reply-To: <20090423105145.GW4593@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

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

Should there be a comment/Documentation blurb on how to remediate a
misaligment? Such as how to modify the partition tables and what to look
for in the BIOS (if anything) to take advantage of 4K sectors?

Is there a corresponding patch for fdisk that understands 4K sectors? Or
is that already covered by it doing ioctl calls on the block device?
