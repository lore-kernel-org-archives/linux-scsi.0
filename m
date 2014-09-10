From: Jens Axboe <axboe@kernel.dk>
Subject: Re: lk 3.17-rc4 blk_mq large write problems
Date: Wed, 10 Sep 2014 10:47:49 -0600
Message-ID: <541080B5.8080505@kernel.dk>
References: <540FCB96.8000606@interlog.com> <20140910154144.GA22296@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34819 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaIJQrx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 12:47:53 -0400
Received: by mail-pa0-f42.google.com with SMTP id lj1so6697319pab.29
        for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2014 09:47:53 -0700 (PDT)
In-Reply-To: <20140910154144.GA22296@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On 2014-09-10 09:41, Christoph Hellwig wrote:
> While it might not help with a blown stack, can you give the patch below
> a try?  I tries to solve a problem where the timeout handler hits
> before we've fully set up a command.  While I'd like to understand the
> root cause of why we're hitting it as well, I'd also really to fix that
> race. It would also be good to get a gdb listing of the exact area in
> scsi_times_out listed in the oops.

It's a really long window, but it does exist. I'd be curious if the 
patch makes a difference for this weird case. I have not seen anything 
like it here.

BTW, please don't mix up the REQ_END and ->queue_rq() changes with the 
changed start_request API.

-- 
Jens Axboe

