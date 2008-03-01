From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Sat, 01 Mar 2008 15:17:32 +0900
Message-ID: <47C8F4FC.1040505@gmail.com>
References: <20080226150845.2196bc1a.akpm@linux-foundation.org> <1204079075.26640.8.camel@homer.simson.net> <1204092010.9934.31.camel@homer.simson.net> <1204096025.1623.9.camel@homer.simson.net> <47C6661E.9010504@gmail.com> <1204186800.7362.7.camel@homer.simson.net> <47C675C6.8000904@gmail.com> <20080228153542.GZ6704@kernel.dk> <47C6D73E.4030302@gmail.com> <1204303656.4003.19.camel@localhost.localdomain> <20080229201123.GK6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:58798 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbYCAGRl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Mar 2008 01:17:41 -0500
Received: by wa-out-1112.google.com with SMTP id v27so5227032wah.23
        for <linux-scsi@vger.kernel.org>; Fri, 29 Feb 2008 22:17:40 -0800 (PST)
In-Reply-To: <20080229201123.GK6704@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>

Hello, Jens, James.

Jens Axboe wrote:
>> With the original patch, I have to run through the whole of libsas and
>> scsi_transport_sas doing
>>
>> s/data_len/raw_data_len/
>>
>> With your update it looks like I have to run through them all doing
>>
>> s/data_len/data_len - extra_len/

blk_rq_raw_data_len() should do.

>> which is even worse.  Can't we put things back to a point where data_len
>> means exactly that and extra_len means how much we have spare on the
>> end, so you know you can DMA up to data_len + extra_len if need be?
>>
>> That way we don't have to sweep through every block driver altering the
>> way it uses data_len.

If SMP is broken because it needs start address alignment but not
padding to align the size, what should be done is to make that exact
requirement visible to the block layer.  Say,
blk_queue_dma_start_alignment() or maybe change
blk_queue_dma_alignment() such that it only indicates start address
alignment and add blk_queue_dma_size_alignment() for drivers which
require size to be aligned too.  I think those are few.

I think the decision which value rq->data_len represents comes down to
which size is used more in low level drivers because no matter which way
we choose we'll have to update some of the drivers which expects the
other thing from rq->data_len.

blk_rq_raw_data_len() is needed iff a driver needs dummy buffers
attached at the end and still needs to know the original request size
which isn't the common case.

> Fully agree. The reason why I think it's so ugly is that you have to
> keep these two seperate variables in sync. The burning was just one bug,
> there will be others...

The posted modification isn't too bad as the maintenance of the two
variables is at places where the nasty things happen.  I think what
rq->data_len should represent when seen from LLDs is more important and
please note that if SMP is broken because it simply doesn't require
512byte size alignment, it's a different issue.

As long as both raw_data_len and data_len are accessible, I'm okay
either way.  My biggest reluctance is against breaking sum(sg) ==
rq->data_len.  I think this can lead to much more subtle problems such
as programming the controller w/ wrong bytes count and wrapped-around
resid calculation.

Thanks.

-- 
tejun
