From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] WARN_ON if blk_put_request leaks BIOs
Date: Sun, 22 Mar 2009 10:51:21 +0200
Message-ID: <49C5FC09.7050502@panasas.com>
References: <49C21C5A.6030105@panasas.com> <20090319113343.GF27476@kernel.dk> <49C272CE.1070408@panasas.com> <20090320204543.GE27476@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:13039 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850AbZCVIwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2009 04:52:45 -0400
In-Reply-To: <20090320204543.GE27476@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>

Jens Axboe wrote:
> On Thu, Mar 19 2009, Boaz Harrosh wrote:
>> Put a WARN_ON in __blk_put_request if it is about to
>> leak bio(s). This is a serious bug that can happen in error
>> handling code paths.
>>
>> For this to work I have fixed a couple of places in block/ where
>> request->bio != NULL ownership was not honored. And a small cleanup
>> at sg_io() while at it.
> 
> Ho humm, not sure what to do about this. Honestly, in all the time that
> I have been doing this, this would have found about zero bugs. And now
> enforces a rule that ->bio must be cleared. Normal bio completion does
> that automatically, so it's not a problem there, but it's still a new
> rule just to satisfy this questionable debug mechanism.
> 
> But what the hell, it's simple enough. Kill the totally unrelated
> scsi_ioctl.c change, and I'll toss it in for a spin.
> 

The scsi_ioctl.c is related. It sets req->bio back from some internal
held value just to carry it across a static function call, all the while
when the function is not needed, totally bogus in the error handling check
of an hard-coded 0, and a call sight that is bigger then the actual function.
So it was better to fix it then, go around the problem of the code putting
some private data on req->bio.

I thought the all patch is worth it just for that bit

Thanks
Boaz
