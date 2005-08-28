From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sun, 28 Aug 2005 18:27:11 -0400
Message-ID: <43123A3F.7050503@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org> <20050824091230.GB26447@infradead.org> <430F398A.30200@adaptec.com> <430F6C56.1090801@pobox.com> <430F710E.7020206@adaptec.com> <430FC7B2.7080700@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:39817 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751030AbVH2Ana (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Aug 2005 20:43:30 -0400
In-Reply-To: <430FC7B2.7080700@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 08/26/05 21:53, Jeff Garzik wrote:
> Luben Tuikov wrote:
> 
>>On 08/26/05 15:24, Jeff Garzik wrote:
>>
>>
>>>Luben Tuikov wrote:
>>>
>>>
>>>
>>>>Even simpler: the transport layer, calls SCSI Core, saying: "Hey here is
>>>>a pointer to struct scsi_domain_device.  If you want, you an send REPORT
>>>>LUNS and other things to it."
>>>
>>>
>>>For the SG_IO ioctl, /dev/sg and request_queue usage, SCSI core must map 
>>>an address (currently HCIL) into a scsi_domain_device pointer.  These 
>>
>>
>>The request queue is associated with the LU, not the scsi_domain_device.
>>When SCSI Core discovers the LU, it sets up the request queue for it,
>>etc.  Again this is the role of SCSI Core, not messing up with transport
>>specific stuff.
>>
>>
>>
>>>upper layer kernel elements rely on this "SCSI address", and rely on the 
>>>fact that SCSI core can route from a block device straight to a SCSI 
>>>LLD, using nothing more than this "SCSI address."
>>
>>
>>I don't get this.
> 
> 
> More basically...  An in-kernel C pointer, to a SCSI target device, is 
> not sufficient in all cases to address a target.  This plays out most 
> often in userland interfaces such as ioctls.

1. Why do I care about this stuff, when I'm so low in the layering
   infra?
2. I thought ioctls are bad.
3. So you're saying that there's an ioctl which addresses a "SCSI target
   device" by HCIL?  Which one is it please?
 
>>>That is the heart of the routing/addressing that the SCSI core must perform.
>>
>>
>>Disagree: now: scsi_device <--> request_queue, then: struct LU <--> request_queue.
>>
>>The LU points to the domain_device (as its parent). The domain_device
>>has a void *lldd_dev in it.  
> 
> 
> The current SCSI code largely already has this stuff.

No, it has no concept of those things.  I mean, look at how
scsi_target is treated and implemented...

Before one start writing code about something (scsi_target)
one should ask themselves "what is that something (scsi_target)?",
and "how does it play with the rest of the objects I want to
represent?".

You can search the archives of linux-scsi and you'll see how many
times I've asked about true "scsi_target" representation, and how many
times I've been rejected by the SCSI maintainers.

Now the need for such an object is even more dire, when you have
_one_more_ SCSI transport.

It started with iSCSI...

> No specs, just a comment from IRC.

Oh, I see... this was one of those IRC sessions you had with James B,
which you talked about before.

I'd suggest sitting down with a fresh copy of SAM and SPC, reading them
20 times, then looking at this picture:
http://www.t10.org/scsi-3.gif
and then "seeing" how _a_ SCSI Core should behave.

> (host,string) could succeed in transporting both HCIL and non-HCIL 
> target identifiers.

Broken.

BTW, none of what I'm saying here has changed for the last 5 years.
It's all the same old stuff.  Now its SAS, back then it was iSCSI.

What the maintainers here fail to see is that it is all SAM and
they fail to see how it all plays together with the transports and
then with the interconnects.

The reason we don't see eye to eye is that we don't come off the
same base.  Some people here re-read every revision of SAM, SPC, etc,
when it comes out, others do not.

	Luben




