From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6/7] mpt2sas: store scsi io tracker data in the scsi command
 / request
Date: Tue, 07 Apr 2015 13:22:38 -0600
Message-ID: <55242E7E.1080705@kernel.dk>
References: <1428076703-31014-1-git-send-email-axboe@fb.com> <1428076703-31014-7-git-send-email-axboe@fb.com> <20150405160359.GD28173@lst.de> <55240223.4070205@kernel.dk> <20150407161823.GA19547@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35726 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbbDGTWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:22:40 -0400
Received: by iggg4 with SMTP id g4so21407730igg.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2015 12:22:39 -0700 (PDT)
In-Reply-To: <20150407161823.GA19547@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 04/07/2015 10:18 AM, Christoph Hellwig wrote:
> On Tue, Apr 07, 2015 at 10:13:23AM -0600, Jens Axboe wrote:
>>> The mq case will also work for the !mq case when you call
>>> scsi_host_find_tag and scsi_cmd_priv.   In general all the mq-specific
>>> codepathes you add should become the default and only one, even if this
>>> requires a lit bit of additional core work.
>>
>> For the core code, I definitely agree. But for this case, in scsi-mq mode,
>> we know that tag == smid - 1. That's not the case if we are not using
>> scsi-mq.
>
> It is if you use the old block tagging code with host-wide tags.
> I guess you'll need to tell mpt2 and mpt3 to use that firs, though.

Yup

>> In general, it'd be great if we could "convert" drivers and not have to
>> support both scsi-mq and legacy mode. Then I could just rip the old code.
>
> Well, the whole point is that you should be able to write a driver like
> your mq version and it should just work. Even better would be if we

It'd be nice to have a host template flag that says "I only run 
scsi-mq", so we didn't have to cater to both cases. Or maybe that 
already exists and I just didn't look hard enough.

> could get rid of the old case entirely for scsi, but for that we need
> a I/O scheduler for blk-mq first :)

I hear ya :)

-- 
Jens Axboe

