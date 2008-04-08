From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] block: move the padding adjustment to blk_rq_map_sg
Date: Tue, 08 Apr 2008 10:49:22 +0900
Message-ID: <47FACF22.4010104@gmail.com>
References: <47FA061A.8000107@gmail.com>	<20080407221103Y.tomof@acm.org>	<47FA2090.4040005@gmail.com> <20080408083526P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:39294 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYDHBta (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 21:49:30 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1741172wff.4
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2008 18:49:29 -0700 (PDT)
In-Reply-To: <20080408083526P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com

Hello,

FUJITA Tomonori wrote:
>>> The current code does padding only for requests that we call
>>> __blk_rq_map_user (bio_copy_user) for. You meant that if we create a
>>> new flag like REQ_NEED_PADDING and set it in blk_rq_map_user,
>>> blk_rq_map_sg can do padding only when it was set.
>> Yeap, that's what I meant.
> 
> Thanks, I see. Then, I have one question: blk_rq_map_user_iov doesn't
> padding, thus libata still needs to adjust scatter list, right?

Yes but it doesn't, so blk_rq_map_user_iov() path is essentially broken 
regarding padding at the moment.  :-(

-- 
tejun
