From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Fri, 21 Mar 2003 15:48:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7B7A9A.6030007@splentec.com>
References: <20030319182755.A9535@beaverton.ibm.com> <3E7A1EF5.3050501@splentec.com> <20030320203912.A18471@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> Okay, the comments are not clear, and don't match the code, I'll remove
> them rather than try to get something terse and meaningful.

No, please -- you don't have to go from one extreme to the other.

Comments are good, please put some, just make sure that they don't tell
things which can already be determined like int a; /* integer counter */,
but something like int a; /* number of customers served */, i.e. portray
the meaning.

>>Why don't you *first* hit the ``q'' queue and unlock it and then, i.e. afterwards,
>>go over starved_list.
>>
>>Or you can do it the other way around, i.e. assume prioritization, which I strongly
>>advise *against* -- the _caller_ may have handled prioritization already.
> 
> 
> I'm trying to give priority to scsi_devices that have not been able to
> send IO. If we call __blk_run_queue(q) first, one busy scsi_device could
> starve all other scsi_devices on an adapter.

Ok, then go over the list of starved scsi devices FIRST, hit their queues,
and THEN after this, get the lock for the queue and hit it.

I.e. keep the queue lock for the shortest amount of time.

> I don't see how the caller can have a priority (across scsi_devices), as
> there is no priorizitation across different request queues. The blk layer
> should already have prioritized/sorted the request (per request queue).

What I meant is: all this is happening inside scsi_queue_next_request().
Now, since this function takes as an argument a request queue, it is possible
though unlikely, that the caller is calling this function for a set of
request queues in order of giver criterium.

In this respect I said that it could have already been prioritized.

-- 
Luben


