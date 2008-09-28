From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: How many retries to allow?
Date: Sun, 28 Sep 2008 19:16:08 +0300
Message-ID: <48DFADC8.1060303@panasas.com>
References: <Pine.LNX.4.44L0.0809281134550.12081-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:24653 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYI1QQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Sep 2008 12:16:15 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1411328muf.1
        for <linux-scsi@vger.kernel.org>; Sun, 28 Sep 2008 09:16:13 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.0809281134550.12081-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Sun, 28 Sep 2008, Boaz Harrosh wrote:
> 
>> Alan Stern wrote:
>>> James and Boaz:
>>>
>>> Here's a question.  Suppose a device returns NOT READY sense key 
>>> repeatedly.  How long should the request be retried before we give up?  
>>> If we never give up then the request will never finish, so the caller 
>>> will hang.
>>>
>>> Alan Stern
>>>
>> I always thought  request->retries was for that. Perhaps I misunderstood.
> 
> Maybe it is intended for that purpose, but it isn't being used as far 
> as I can tell.  req->retries is never decremented; instead 
> scmd->allowed is initialized to req->retries when the request is 
> prepped.  But when a command fails and scsi_requeue_command() is 
> called, the request is un-prepped and put back on the queue.  Then it 
> is prepped again and a new scmd is created -- with the same number of 
> retries as before.  Thus we will never run out of retries.
> 

This sounds like a bug to me. It should be fixed. Perhaps it's there since 
the 2.6.18 changes when direct scsi_cmnd requeuing was eliminated. A test
would be most welcome. It should be easy to prove. I would if you don't bit
me to it. (Am pretty busy)

>> I think there should be one user settable global counter that will limit
>> all retries of any kind.
> 
> You're missing a major point.  Suppose for example that the device
> returns NOT READY because a new medium is being loaded, a procedure
> that takes a couple of seconds.  But the SCSI core doesn't wait between
> retries; a new command is sent as soon as the old one fails.  A retry
> limit of 10 could easily be used up in a fraction of a second, and then
> the request would fail.
> 
> Is this how it's supposed to work?  Would it be better to invoke the 
> error handler for this sort of thing?
> 

I always think of that as: timeout been the inner loop and retries on top
of that so 2-second-timeout, 5-retries, means 10 seconds. But now that you point
it out I can see how for some errors this breaks. A test with scsi_debug error
injection should be devised, to make sure things are fixed and don't regress in
the future.

I believe there are lots of theoretical catastrophes in current code, but
not too many in practice. Though, I agree that a pragmatic programing mindset
was practiced, over a more generalized one.

> Alan Stern
> 
> --

Sorry, I will not have time to conduct any tests in the near future, so you're on
your own. But I'll review anything you can post in the matter.

Thanks
Boaz
