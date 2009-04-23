From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2 of 8] block: Export I/O topology for block devices	and
  partitions
Date: Thu, 23 Apr 2009 14:26:21 -0400
Message-ID: <49F0B2CD.2020706@redhat.com>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <cbdae69a14895dab8ba7.1240464569@sermon.lab.mkp.net> <20090423105145.GW4593@kernel.dk> <20090423181312.GA8768@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbZDWS3X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 14:29:23 -0400
In-Reply-To: <20090423181312.GA8768@mars.virtualiron.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Konrad Rzeszutek wrote:
>>> + * blk_queue_alignment - set alignment for the queue
>>> + * @q:  the request queue for the device
>>> + * @alignment:  alignment offset in bytes
>>> + *
>>> + * Description:
>>> + *   Some devices are naturally misaligned to compensate for things like
>>> + *   the legacy DOS partition table 63-sector offset.  Low-level drivers
>>> + *   should call this function for devices whose first sector is not
>>> + *   naturally aligned.
>>> + */
>>> +void blk_queue_alignment(struct request_queue *q, unsigned int alignment)
>>> +{
>>> +	q->alignment = alignment & (q->granularity - 1);
>>> +	clear_bit(QUEUE_FLAG_MISALIGNED, &q->queue_flags);
>>> +}
>>> +EXPORT_SYMBOL(blk_queue_alignment);
>> How would low-level drivers know?
> 
> Should there be a comment/Documentation blurb on how to remediate a
> misaligment? Such as how to modify the partition tables and what to look
> for in the BIOS (if anything) to take advantage of 4K sectors?
> 
> Is there a corresponding patch for fdisk that understands 4K sectors? Or
> is that already covered by it doing ioctl calls on the block device?

We need to update the various tools to deal with this data and prevent 
misalignment, some of which is going on already.

I am afraid that if you are misaligned, the only remedy would be to tar up your 
data, recreate an aligned device and then restore :-)

ric

