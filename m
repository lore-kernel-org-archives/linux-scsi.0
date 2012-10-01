From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [SCSI PATCH] sd: max-retries becomes configurable
Date: Mon, 01 Oct 2012 13:13:26 +0530
Message-ID: <5069499E.6000006@gmail.com>
References: <20120924210049.GA18527@havoc.gtf.org>  <1348546019.2457.3.camel@dabdike> <50613F72.4000302@pobox.com> <1348569508.2457.28.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348569508.2457.28.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/25/2012 04:08 PM, James Bottomley wrote:
> On Tue, 2012-09-25 at 01:21 -0400, Jeff Garzik wrote:
>> On 09/25/2012 12:06 AM, James Bottomley wrote:
>>> On Mon, 2012-09-24 at 17:00 -0400, Jeff Garzik wrote:
>>>>    drivers/scsi/sd.c |    4 ++++
>>>>    drivers/scsi/sd.h |    2 +-
>>>>    2 files changed, 5 insertions(+), 1 deletion(-)
>>> I'm not opposed in principle to doing this (except that it should be a
>>> sysfs parameter like all our other controls), but what's the reasoning
>>> behind needing it changed?
>> <vendor hat on>
>>
>> Periodically turns up as a useful field sledgehammer for solving
>> problems, until the real problem is found and fixed.  Got tired of a
>> very similar patch manually bouncing around the "hey, pssst, this worked
>> for me" backchannel IT network.
>>
>> </red hat>
> I'm asking because the general consensus from the device guys is that we
> should never retry unless the device or the transport tells us to (and
> then we shouldn't count the retries).  A long time ago we used to get
> spurious command failures from retry exhaustion on QUEUE_FULL or BUSY,
> but since we switched those to being purely timeout based, I thought the
> problem had gone away and I'm curious to know what guise it resurfaced
> in.

I think that is still very much a true statement. By the time normal disks 
return an error, they have retried *many* times in firmware. There are some 
exceptions of course - vibrations and so on might make this useful.

Back when my day job often involved recovering data from dead drives, we 
actually normally wanted to cut retries down to zero since various part of the 
stack retried for us so much that each bad sector had to be timed out multiple 
times!

I don't object to making this a tunable, but we should default to not retrying.

Also would be very interesting to seeing if this actually is useful in the real 
world, not just "word on the street" world :)

Ric

>
>> Can you be more specific about sysfs location?  A runtime-writable (via
>> sysfs!) module parameter for a module-wide default seemed appropriate.
> Well, if it's really important, the same thing should happen with
> retries as happened with timeout (it became a request_queue property),
> but it could be hacked as a struct scsi_disk one with a corresponding
> entry in sd_dis_attrs.
>
> James
>
>
