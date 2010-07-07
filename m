From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Tue, 06 Jul 2010 21:39:27 -0400
Message-ID: <yq1ocek6pf4.fsf@sermon.lab.mkp.net>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
	<20100706213136.GA21246@redhat.com> <4C33BEDF.7050602@interlog.com>
	<20100707004748.GA3068@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:61880 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0GGBml (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2010 21:42:41 -0400
In-Reply-To: <20100707004748.GA3068@redhat.com> (Mike Snitzer's message of
	"Tue, 6 Jul 2010 20:47:48 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> That is 0x7fffff (over 8 million) blocks (4 GB) being unmapped in one
>> operation! That may exceed the "maximum unmap lba count" field in the
>> Block Limits VPD page.  The latest SBC draft (sbc3r22.pdf) says that
>> field applies to the SCSI UNMAP command and does not mention the
>> WRITE SAME (16) command but that is probably an oversight.

Maximum Unmap LBA Count > 0 (in combination with the descriptor count)
are what indicate that the device server supports UNMAP.

You could argue, then, that a Maximum Unmap LBA Count > 0 but a Maximum
Unmap Descriptor Count of 0 would provide means to indicate the maximum
range for WRITE SAME.  But the T10 people I have talked to all agree
that the LBA count for WRITE SAME is gated by the command's LBA count
and nothing else.  So no special casing for when the UNMAP bit is set.
I.e. the max for WRITE SAME(16) is 32-bits times logical_block_size.


Mike> # cat /sys/block/sda/queue/discard_granularity
Mike> 512
Mike> # cat /sys/block/sda/queue/discard_max_bytes
Mike> 4294966784

Mike> I'll look to understand why 'discard_max_bytes' is so large for
Mike> this LUN despite the standard Block limits VPD page not reflecting
Mike> this.

discard_max_bytes is 0xFFFFFFFF for WRITE SAME(16).

-- 
Martin K. Petersen	Oracle Linux Engineering
