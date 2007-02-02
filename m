From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Thu, 01 Feb 2007 21:48:27 -0500
Message-ID: <45C2A67B.7090907@rtr.ca>
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>	 <45C2474E.9030306@rtr.ca> <1170366920.3388.62.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1170366920.3388.62.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2007-02-01 at 15:02 -0500, Mark Lord wrote:
>..
>> One thing that could be even better than the patch below,
>> would be to have it perhaps skip the entire bio that includes
>> the failed sector, rather than only the bad sector itself.
> 
> Er ... define "skip over the bio".  A bio is simply a block
> representation for a bunch of sg elements coming in to the elevator.

Exactly.  Or rather, a block of sg_elements from a single point
of request, is it not?

> Mostly what we see in SCSI is a single bio per request, so skipping the
> bio is really the current behaviour (to fail the rest of the request).

Very good.  That's what it's supposed to do.

But if each request contained only a single bio, then all of Jens'
work on IO scheduling would be for nothing, n'est-ce pas?

In the case where a request consists of multiple bio's
which have been merged under a single request struct,
we really should give at least one attempt to each bio.

This way, in most cases, only the process that requested the
failed sector(s) will see an error, not the innocent victims
that happened to get merged onto the end.  Which could be very
critical stuff (or not -- it could be quite random).

So the time factor works out to one disk I/O timeout per failed bio.
That's what would have happened with the NOP scheduler anyway.

On the sytems I'm working with, I don't see huge numbers of bad sectors.
What they tend to show is just one or two bad sectors, widely scattered.

So:
>> I think doing that might address most concerns expressed here.
>> Have you got an alternate suggestion, James?

Cheers
