From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Tue, 06 Jul 2010 23:35:53 -0400
Message-ID: <4C33F619.4010302@interlog.com>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>	<20100706213136.GA21246@redhat.com> <4C33BEDF.7050602@interlog.com>	<20100707004748.GA3068@redhat.com> <yq1ocek6pf4.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54715 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab0GGDgE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2010 23:36:04 -0400
In-Reply-To: <yq1ocek6pf4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

On 10-07-06 09:39 PM, Martin K. Petersen wrote:
>>>>>> "Mike" == Mike Snitzer<snitzer@redhat.com>  writes:
>
>>> That is 0x7fffff (over 8 million) blocks (4 GB) being unmapped in one
>>> operation! That may exceed the "maximum unmap lba count" field in the
>>> Block Limits VPD page.  The latest SBC draft (sbc3r22.pdf) says that
>>> field applies to the SCSI UNMAP command and does not mention the
>>> WRITE SAME (16) command but that is probably an oversight.
>
> Maximum Unmap LBA Count>  0 (in combination with the descriptor count)
> are what indicate that the device server supports UNMAP.

That has been superseded by the TPU and TPWS bits
in the Thin provisioning VPD page (B2h) in sbc3r22.
TPU and TPWS indicate support for the UNMAP and WRITE
SAME (16) with UNMAP bit ** commands respectively.

> You could argue, then, that a Maximum Unmap LBA Count>  0 but a Maximum
> Unmap Descriptor Count of 0 would provide means to indicate the maximum
> range for WRITE SAME.  But the T10 people I have talked to all agree
> that the LBA count for WRITE SAME is gated by the command's LBA count
> and nothing else.  So no special casing for when the UNMAP bit is set.
> I.e. the max for WRITE SAME(16) is 32-bits times logical_block_size.

I think sbc3r22 is just flaky in that area and will
be cleaned up soon. As the words stand now, in the
Block limits VPD page "maximum unmap lba count" only
applies to the UNMAP command while "optimal unmap
granularity" applies to both the UNMAP command and
the WRITE SAME(16) command. Inconsistent.
And "maximum unmap lba count"==0 implying no UNMAP
command is pointless given the TPU bit.

> Mike>  # cat /sys/block/sda/queue/discard_granularity
> Mike>  512
> Mike>  # cat /sys/block/sda/queue/discard_max_bytes
> Mike>  4294966784
>
> Mike>  I'll look to understand why 'discard_max_bytes' is so large for
> Mike>  this LUN despite the standard Block limits VPD page not reflecting
> Mike>  this.
>
> discard_max_bytes is 0xFFFFFFFF for WRITE SAME(16).

FORMAT UNIT has several associated mechanisms (e.g
IMMED bit and REQUEST SENSE polling) that let it
run for a long time. WRITE SAME has no such mechanisms.
There was a proposal put to t10 to place an upper limit
on WRITE SAME's lba count but I think that has been
dropped. IMO if we want to give large block counts to
UNMAP or WRITE SAME in the absence of guidance from the
block limits VPD page, then we need to cope with
device saying "nope".

Whatever device Mike has it seems to be failing the
WRITE SAME(16) command due to the huge lba block count.
Does the device work with a smaller lba block count?
For example:
    sg_write_same --unmap --lba 0 --num 1024 /dev/sda



** WRITE SAME (32) also has an UNMAP bit.

Doug Gilbert

