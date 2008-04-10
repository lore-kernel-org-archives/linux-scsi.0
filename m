From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] block: move the padding adjustment to blk_rq_map_sg
Date: Thu, 10 Apr 2008 10:54:55 +0900
Message-ID: <47FD736F.9020404@gmail.com>
References: <47FA2090.4040005@gmail.com>	<20080408083526P.fujita.tomonori@lab.ntt.co.jp>	<47FACF22.4010104@gmail.com> <20080408113732B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:15553 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbYDJBzC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2008 21:55:02 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2394321wah.23
        for <linux-scsi@vger.kernel.org>; Wed, 09 Apr 2008 18:55:02 -0700 (PDT)
In-Reply-To: <20080408113732B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com

Hello, FUJITA.

FUJITA Tomonori wrote:
>>>>> The current code does padding only for requests that we call
>>>>> __blk_rq_map_user (bio_copy_user) for. You meant that if we create a
>>>>> new flag like REQ_NEED_PADDING and set it in blk_rq_map_user,
>>>>> blk_rq_map_sg can do padding only when it was set.
>>>> Yeap, that's what I meant.
>>> Thanks, I see. Then, I have one question: blk_rq_map_user_iov doesn't
>>> padding, thus libata still needs to adjust scatter list, right?
>> Yes but it doesn't, so blk_rq_map_user_iov() path is essentially broken 
>> regarding padding at the moment.  :-(
> 
> I see. So we need to use bounce buffers for blk_rq_map_user_iov like
> bio_copy_user does for blk_rq_map_user?

Yeap.  I think so.  It would be great if we can do it where all the PC 
commands pass through so that blk_rq_map_useR_iov() and 
blk_rq_map_user() don't have to do it separately and as in your earlier 
patch it's probably best to move sg manipulation close to drain handling.

Thanks.

-- 
tejun
