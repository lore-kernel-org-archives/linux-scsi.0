From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Wed, 14 Jun 2006 01:13:02 +0200
Message-ID: <448F467E.90805@s5r6.in-berlin.de>
References: <448DF5DA.3070800@sgi.com> <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com> <448EDCEB.50702@sgi.com> <448EF4D4.4090402@s5r6.in-berlin.de> <448F13B0.20803@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:59568 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932340AbWFMXQh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 19:16:37 -0400
In-Reply-To: <448F13B0.20803@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

Michael Reed wrote:
> Stefan Richter wrote:
[...]
>>I think the 2nd parameter does not help anyone. What you rather seem to
>>need is
>> a) the existing dev_loss_tmo parameter but without the kernel
>>    enforcing an upper limit for it [the admin sets the policy, not
>>    the kernel], and
>> b) the transport layer or the SCSI core taking care that no SCSI
>>    command times out during the tolerated absence of a target.
> 
> Actually, I do not want this.  The limit on the dev_loss_tmo parameter
> is there to allow error notification to eventually pass up the stack.
> This is important in path failover situations.  An infinite value here
> would imply that commands do not time out.

Wouldn't be path failover simply mean that the transport returns the 
target from "absent" to "available" when the alternative path kicks in? 
This should happen much earlier than after 'infinite' time.

[...]
> The transport currently holds off commands with a combination of DID_IMM_RETRY,
> blocking the target so that no new commands are issued, and holding off
> error recovery until the dev loss timer expires.

Ah, I didn't know that yet. Still, people should think about moving this 
or similar behaviour (IOW, the notion of "temporarily absent" state of 
targets or units) up into SCSI core. Then the remaining responsibility 
of the transport is to determine _when_ to report which connection state 
transitions (based on hardware events, user-configurable timers, sysfs 
events etc.), not _how_ to handle tasks for these targets or units in 
the various states.

> This is the behavior that is desired.
> 
> What I want is to have the device, when it returns, reconnect to it's
> existing infrastructure.  This allows previously connected "users"
> to reconnect.

Yes, clearly.
-- 
Stefan Richter
-=====-=-==- -==- -===-
http://arcgraph.de/sr/
