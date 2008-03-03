From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Mon, 03 Mar 2008 22:55:56 +0900
Message-ID: <47CC036C.2060902@gmail.com>
References: <47CBC309.7090106@gmail.com>	<20080303211727P.tomof@acm.org>	<47CBFF6F.4060301@gmail.com> <20080303225024J.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.231]:42193 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbYCCN4F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 08:56:05 -0500
Received: by qb-out-0506.google.com with SMTP id e11so7849209qbe.15
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2008 05:56:04 -0800 (PST)
In-Reply-To: <20080303225024J.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com

FUJITA Tomonori wrote:
>>>> FUJITA Tomonori wrote:
>>>>>>> I can't see what changing the meaning of rq->data_len (and
>>>>>>> investigating all the block drivers) gives us.
>>>>>> No matter which way you go, you change the meaning of rq->data_len and
>>>>>> you MUST inspect rq->data_len usage whichever way you go.
>>>>> The patch doens't change that rq->data_len means the true data
>>>>> length. But yeah, it breaks rq->data_len == sum(sg). So it might break
>>>>> some drivers.
>>>> Yeah, that's what I was saying.  You end up breaking one of the two
>>>> assumptions.  As sglist is getting modified for any driver if it has DMA
>>>> alignment set, whether rq->data_len is adjusted together or not, sglist
>>>> and data_len usages have to be audited.
>>> My patch (well, James' original approach) doesn't affect drivers that
>>> don't use drain buffer. rq->data_len still means the true data length
>>> and rq->data_len is equal to sum(sg) for them. So right now we need to
>>> audit only libata.
>> Your patch does change sglist for any driver which sets DMA alignment.
> 
> I overlook it. Where does it changes sglist?

At the end of blk_rq_map_user() together with data_len / extra_len
mangling or were you talking about James' original patch?

-- 
tejun
