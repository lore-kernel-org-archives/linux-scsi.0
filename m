From: Jens Axboe <axboe@kernel.dk>
Subject: Re: lk 3.17-rc4 blk_mq large write problems
Date: Wed, 10 Sep 2014 12:42:09 -0600
Message-ID: <54109B81.5040302@kernel.dk>
References: <540FCB96.8000606@interlog.com> <20140910154144.GA22296@infradead.org> <541080B5.8080505@kernel.dk> <20140910180957.GA17495@infradead.org> <541097F1.8030808@kernel.dk> <20140910184004.GA14286@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:37760 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaIJSmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 14:42:01 -0400
Received: by mail-pd0-f179.google.com with SMTP id g10so12807727pdj.38
        for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2014 11:42:01 -0700 (PDT)
In-Reply-To: <20140910184004.GA14286@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 09/10/2014 12:40 PM, Christoph Hellwig wrote:
> On Wed, Sep 10, 2014 at 12:26:57PM -0600, Jens Axboe wrote:
>>> I have to.  It's set by start_request, so we need to pass down the last
>>> argument to keep the old behavior.  And once we pass the argument we
>>> can just it directly.
>>
>> It could still be done in the caller, but arguably, you'd have to do it
>> twice unless the ->queue_rq() call was rolled into a function.
> 
> At which point we'd better do it the right way and just pass the flag
> instead of wasting a request flag for it.  The other benefit is that
> there is a clear compile time API break for ->queue_rq that reminds
> people that need to start using blk_mq_start_request.

Yeah that's a good point, hopefully they will look up the commit and
figure out what to do. I'm not adverse to doing these two things at
once, but it should at least have a good mention of it in the changelog.
It's not even mentioned.

> Anyway, still waiting for test reports of the people that can reproduce
> the timeouts.  By the time I'll submit the patch it should have a much
> better changelog.

Thanks, sounds good.

-- 
Jens Axboe

