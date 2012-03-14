From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [LSF/MM TOPIC] [ATTEND] SR-IOV Management
Date: Wed, 14 Mar 2012 14:07:34 -0400
Message-ID: <alpine.WNT.2.00.1203141337330.3968@N5102REMCQXM4BS.qlogic.org>
References: <alpine.WNT.2.00.1201311356390.3392@N5102REMCQXM4BS.qlogic.org> <4F29058B.6020904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:29318
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755831Ab2CNSHm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2012 14:07:42 -0400
In-Reply-To: <4F29058B.6020904@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Wed, 1 Feb 2012, Hannes Reinecke wrote:

> On 01/31/2012 08:02 PM, Chad Dupuis wrote:
>> With more and more storage controller hardware supporting SR-IOV in
>> next
>> couple of years it seems to make sense at this point to discuss, from a
>> storage stack perspective, managing how we instantiate and manage
>> SR-IOV
>> virtual functions (VFs).  Currently for hardware that does support
>> SR-IOV,
>> the management of that functionality is managed entirely by the
>> hardware
>> device driver.  However, a more dynamic management to how VFs are
>> created
>> and destroyed (assuming the hardware supports it) may be more desirable
>> since the most common use case, assigning VFs to virtual guests, also
>> tends to be very dynamic and fluid.  We also need to consider how VFs
>> interact with complimentary technology such as NPIV in Fibre Channel.
>>
>> I'd like to propose that we discuss the following issues to see if a
>> consensus can be reached about how to deal with them:
>>
>> * VF instantiation
>> * VF/NPIV port pairing
>> * Namespace management
>> * LUN presentation
>>
> Actually, SR-IOV on FC should be easy to handle; it maps quite
> easily on NPIV (which probably was the intention :-).

I would bet it's not a coincidence ;-)  The question I had was do we
represent this relationship at the transport level, such as the FC
transport in this case, or do we let the low-leve driver take care of the
mapping? In other words, do we have a low level driver create the vport when
it is instantiating a VF or do we add an option to say fc_vport_create so
that a VF is created along with a vport.

Given that a lot of drivers reserve resources for their VFs during
initialization that the pendulum  it would fall on letting the low-level
driver manage the creation and mapping of the NPIV<->VF relationship.

>
> However, for SAS things get really tricky, as we don't have virtual
> SAS IDs. Some vendor was actually planning on doing ACLs in firmware
> (shudder).

Each protocol will be different which means if there is any common
encapsulation is would probably be at the transport level (FC, iSCSI, SAS,
etc.)

>
> And then there is the pci-stub mess.

I presume you'd want to get rid of pci-stub?  What would be the
alternative; just directly unbinding the assignment of the device from
the hypervisor to the virtual guest as it is coming up?

>
> So yes, definitely something to discuss here.
>
> Cheers,
>
> Hannes
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

