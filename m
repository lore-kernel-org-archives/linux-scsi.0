From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] Re: sleeping in scsi EH
Date: Fri, 27 May 2005 11:01:01 -0400
Message-ID: <4297362D.6040504@adaptec.com>
References: <42968560.7020608@pobox.com> <20050527070954.GA27256@infradead.org> <4296DC49.5020907@pobox.com> <20050527084220.GA29352@infradead.org> <4296FA61.4010003@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:33943 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261788AbVE0PBI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 11:01:08 -0400
In-Reply-To: <4296FA61.4010003@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 05/27/05 06:45, Jeff Garzik wrote:
> Christoph Hellwig wrote:
> 
>>On Fri, May 27, 2005 at 04:37:29AM -0400, Jeff Garzik wrote:
>>
>>
>>>Christoph Hellwig wrote:
>>>
>>>
>>>>You can sleep in them.  You must however release the host lock and enable
>>>>irqs first and reverse that before returning.  The error handlers don't
>>>>need the host lock, but we're stuck with the unfortunate calling convention
>>>>for now.
>>>
>>>Why are we stuck with this calling convention, when everyone who cares 
>>>circumvents it?
>>
>>
>>Because no one found the time to do a full transition yet.  If you want to
>>update all scsi drivers feel free.  One patch per method please.
> 
> 
> Something like the attached?

I like it very, _very_ much.

That is, what is the point to have EH in the first place (from a
kernel thread) when a lock is held and irqs are off? (no sleeping)
Might as well go back to abort()... ;-)  The whole point of
EH is so that LLDD can sleep waiting possible for TMFs to return.

In general I don't like to see SCSI Core imposed locking onto the
LLDDs.  LLDDs should take care of their own locking as should SCSI Core.

Next: off with the host_lock. ;-)

>   *      Returns SUCCESS if command aborted else FAILED
>   *
> - *      Locks: struct Scsi_Host::host_lock held (with irqsave) on entry 
> - *      and assumed to be held on return.
> + *      Locks: None held.  EH context.
>   *
>   *      Calling context: kernel thread

Is it possible to mention explicitly that sleeping is allowed
and encouraged while waiting for TMFs to return and
to change "LLD", "Low Level Driver" -- I've seen those
on the streets, either drunks or bad drivers, --
to "LLDD", "Low Level _Device_ Drivers"?

	Luben
