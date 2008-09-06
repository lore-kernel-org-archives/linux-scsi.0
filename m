From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] block: set req->timeout in blk_add_timer
Date: Sat, 06 Sep 2008 08:34:22 -0500
Message-ID: <48C286DE.6060902@cs.wisc.edu>
References: <1220680240-27724-1-git-send-email-michaelc@cs.wisc.edu> <1220706621.3430.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60866 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYIFNet (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2008 09:34:49 -0400
In-Reply-To: <1220706621.3430.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, Mike Christie <mchristi@redhat.com>

James Bottomley wrote:
> On Sat, 2008-09-06 at 00:50 -0500, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <mchristi@redhat.com>
>>
>> To prevent a reques from running forever, scsi-ml checks if
>> a command has been running req->timeout * cmd->allowed + 1 seconds.
>> If it has, scsi-ml will fail the request. From what I can tell
>> it looks like in Jen's tree that the block layer is not setting
>> this value, so a command is failed right away a lot of times because
>> wait_for in scsi_softirq_done is zero seconds. It is only set by ioctls
>> and passthrough.
>>
>> This patch just copies the q timeout that is used, so any one
>> checking it will still be able to see it.
>>
>> For the scsi-ml req->timeout usage, I think we can move the retries and
>> the infinite retry check from the scsi layer to the block layer. I was
>> not sure if we should do that in this patch or a separate one. I can
>> cook up another patch if people want. If it would be possible to do
>> that after MikeA's patches it would probably be best though since
>> he is working on that code too.
> 
> Sure, basically move all responsibility for retries to block.  That will
> require a few other things like abstracting scsi_decide_disposition.  I
> actually had an impression from one of the storage summits that someone
> was working on this.
> 

I remember talking about at the first summit now. Maybe I was doing it 
as part of the move the command timer to the block layer patches and 
request based multipath stuff, or maybe someone else was as part of the 
request_queue groups stuff. I will look into it again. Thanks.
