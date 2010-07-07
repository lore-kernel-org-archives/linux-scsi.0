From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Tue, 6 Jul 2010 22:19:43 -0400
Message-ID: <20100707021943.GA13044@redhat.com>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
 <20100706213136.GA21246@redhat.com>
 <4C33BEDF.7050602@interlog.com>
 <20100707004748.GA3068@redhat.com>
 <yq1ocek6pf4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0GGCUG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2010 22:20:06 -0400
Content-Disposition: inline
In-Reply-To: <yq1ocek6pf4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

On Tue, Jul 06 2010 at  9:39pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> >> That is 0x7fffff (over 8 million) blocks (4 GB) being unmapped in one
> >> operation! That may exceed the "maximum unmap lba count" field in the
> >> Block Limits VPD page.  The latest SBC draft (sbc3r22.pdf) says that
> >> field applies to the SCSI UNMAP command and does not mention the
> >> WRITE SAME (16) command but that is probably an oversight.
> 
> Maximum Unmap LBA Count > 0 (in combination with the descriptor count)
> are what indicate that the device server supports UNMAP.
> 
> You could argue, then, that a Maximum Unmap LBA Count > 0 but a Maximum
> Unmap Descriptor Count of 0 would provide means to indicate the maximum
> range for WRITE SAME.  But the T10 people I have talked to all agree
> that the LBA count for WRITE SAME is gated by the command's LBA count
> and nothing else.  So no special casing for when the UNMAP bit is set.
> I.e. the max for WRITE SAME(16) is 32-bits times logical_block_size.

Ah, yes completely missed that fact that we're talking WRITE SAME(16)
yet I was looking at UNMAP limits.

> 
> Mike> # cat /sys/block/sda/queue/discard_granularity
> Mike> 512
> Mike> # cat /sys/block/sda/queue/discard_max_bytes
> Mike> 4294966784
> 
> Mike> I'll look to understand why 'discard_max_bytes' is so large for
> Mike> this LUN despite the standard Block limits VPD page not reflecting
> Mike> this.
> 
> discard_max_bytes is 0xFFFFFFFF for WRITE SAME(16).

Seems discard_max_bytes = 0x7fffff * 512 = 4294966784

So mkfs.ext4's BLKDISCARD ioctl first issues a discard of
discard_max_bytes (via blkdev_issue_discard's loop) and it fails. 

Question becomes: why did the request fail if the LUN supports WRITE
SAME(16) and its max is 0xFFFFFFFF?

Likely a question for the vendor but I'd first like to make sure it is
reasonable to expect this command to succeed.

Thanks,
Mike
