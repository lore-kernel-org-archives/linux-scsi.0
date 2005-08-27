From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 26 Aug 2005 21:53:54 -0400
Message-ID: <430FC7B2.7080700@pobox.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org> <20050824091230.GB26447@infradead.org> <430F398A.30200@adaptec.com> <430F6C56.1090801@pobox.com> <430F710E.7020206@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:14508 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965202AbVH0ByA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 21:54:00 -0400
In-Reply-To: <430F710E.7020206@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

Luben Tuikov wrote:
> On 08/26/05 15:24, Jeff Garzik wrote:
> 
>>Luben Tuikov wrote:
>>
>>
>>>Even simpler: the transport layer, calls SCSI Core, saying: "Hey here is
>>>a pointer to struct scsi_domain_device.  If you want, you an send REPORT
>>>LUNS and other things to it."
>>
>>
>>For the SG_IO ioctl, /dev/sg and request_queue usage, SCSI core must map 
>>an address (currently HCIL) into a scsi_domain_device pointer.  These 
> 
> 
> The request queue is associated with the LU, not the scsi_domain_device.
> When SCSI Core discovers the LU, it sets up the request queue for it,
> etc.  Again this is the role of SCSI Core, not messing up with transport
> specific stuff.
> 
> 
>>upper layer kernel elements rely on this "SCSI address", and rely on the 
>>fact that SCSI core can route from a block device straight to a SCSI 
>>LLD, using nothing more than this "SCSI address."
> 
> 
> I don't get this.

More basically...  An in-kernel C pointer, to a SCSI target device, is 
not sufficient in all cases to address a target.  This plays out most 
often in userland interfaces such as ioctls.


>>That is the heart of the routing/addressing that the SCSI core must perform.
> 
> 
> Disagree: now: scsi_device <--> request_queue, then: struct LU <--> request_queue.
> 
> The LU points to the domain_device (as its parent). The domain_device
> has a void *lldd_dev in it.  

The current SCSI code largely already has this stuff.


>>Right now the addressing is hardcoded to HCIL.  But that can be 
>>changed...  One proposal was to use (host,string) identifiers.
> 
> 
> Who? Who is proposing this? I never saw an email to SCSI Core about
> this proposal?  Is there any more information about this proposal
> and what is the justification of it?  Any specs and docs?

No specs, just a comment from IRC.

(host,string) could succeed in transporting both HCIL and non-HCIL 
target identifiers.

	Jeff


