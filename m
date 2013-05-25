From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] scsi_transport_fc: FC timeout handler
Date: Sat, 25 May 2013 11:55:58 +0200
Message-ID: <51A08AAE.1060501@suse.de>
References: <1369389050-118628-1-git-send-email-hare@suse.de> <1369389050-118628-5-git-send-email-hare@suse.de> <20130525050842.GA6973@infradead.org> <51A086AF.5050609@suse.de> <20130525084222.GA27576@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab3EYI4D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 May 2013 04:56:03 -0400
In-Reply-To: <20130525084222.GA27576@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>

On 05/25/2013 10:42 AM, Christoph Hellwig wrote:
> On Sat, May 25, 2013 at 11:38:55AM +0200, Hannes Reinecke wrote:
>> On 05/25/2013 07:08 AM, Christoph Hellwig wrote:
>>> This looks like a good start, but why would we make this FC specific?
>>>
>> Because James B. said so :-)
>
> I can't remember that at all, but I'll happily let him speak.
>
>> No, seriously:
>> You would need to revisit the good old SCSI parallel LLDDs to figure
>> out if this approach works for them.
>> Eg aic7xxx basically has to stop the entire HBA even for an abort as
>> it has to look through its internal queues etc to locate the
>> command.
>> So for them it wouldn't make much difference.
>> Plus no-one has the knowledge nor the equipment to check _all_ SPI
>> LLDDs to ensure this will work for them.
>
> This is not what I suggested.  But by making the new code a common
> library we can also make other modern transports like SAS or iSCSI
> benefit from the saner error handling.   With motivated enough
> maintainers even modern SPI adapters - basically make it the same kind
> of transition from the old "old" EH to the current "new" EH back in the
> 2.2 days.
>
> With a bit of luck 10 years down the road all drivers requiring current
> EH will have faded away.
>
It should be possible to move the code into scsi_lib and just have small 
hooks for the individual transports to use this.

The main reason I didn't do this atm is that I'm still working on the 
remaining bits:
- Use 'ABORT TASK SET' instead of 'LUN RESET'
- Do not stop the host when issuing 'ABORT TASK SET'; it should be
   sufficient to set the sdev to 'QUIESCE' and let the other LUNs
   unaffected.
- Use 'reset I_T nexus' instead of 'TARGET RESET'
- Similarly, do not stop the host when running 'reset I_T nexus',
   but use existing transport mechanisms (eg setting the rport
   to 'BLOCKED' for FC) to block I/O to the affected target.

So the plan is to implement the above for FC, then see how much can be 
leveraged for other transports, and then move these bits to the common 
layer.

Cheers,

Hannes

