From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Sun, 21 Sep 2008 15:55:53 +0300
Message-ID: <48D64459.2010802@panasas.com>
References: <Pine.LNX.4.44L0.0809201640160.16873-100000@netrider.rowland.org> <1221944955.3152.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:24393 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751413AbYIUM4E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Sep 2008 08:56:04 -0400
In-Reply-To: <1221944955.3152.58.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Antonio Ospite <ospite@studenti.unina.it>, USB list <linux-usb@vger.kernel.org>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley wrote:
>>>
>>> In none of these cases do we want any form of requeuing, we want to kill
>>> the entire request.
>> I take your point.  Which leads to the question: Why was the code ever 
>> calling scsi_end_request(cmd, -EIO, this_count, 1) in the first place?  
>> Apparently all of these paths should be setting the last argument to 0, 
>> always.
> 
> Yes, that was the question I asked in my first reply (where I said the
> requeue looks superfluous).  I think the answer is that there's no
> point ... that's why I advocated simply eliminating scsi_end_request()
> in favour of either scsi_requeue_request/blk_run_queue or
> end_dequeued_request().
> 
> So are you happy with the simple fix proposal ... I think rearranging
> this code needs more debate and discussion.
> 
> James
> 

It looks to me that your 2-liners is a much deeper change then Alen's
original patch, with it's big code movements. So it might be a candidate
for a next release but not as a late -rc bug fix. This is because Allen's
patch is just a mechanical code change, that we can carefully follow and
verify to be equivalent code, minus the bug. Your patch changes behavior
of existing code and should be tested more carefully. What changes is your
retry behavior. I am pretty convinced of what you said, about all these retrys
been impossible/not-wanted, and I think your final deep proposal is the right
one, I wanted to clean this code up and get rid of scsi_end_request lots of
times in the passed. But for a late -rc bug fix it feels very dangerous. I have
observed more then one situation where retrys are a part of a normal IO and
I would like more time to test all the implications.

I have reviewed Allen's patch very carefully several times, and have been running
with it since he posted it. So:
 Reviewed-by: Boaz Harrosh <bharrosh@panasas.com> 
 Tested-by: Boaz Harrosh <bharrosh@panasas.com>

If you'll dig into the email-thread You'll see that I sent something
exactly like yours, at the very beginning, but Alen convinced me that it
is more dangerous, and should be in a following patch.

Thanks
Boaz
 
