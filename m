From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH RFC 1/3] add fc transport events
Date: Sun, 13 Jun 2004 14:23:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CCC5BC.3000305@us.ibm.com>
References: <40B597F5.2030501@cs.wisc.edu> <1087088793.1730.19.camel@mulgrave> <40CCBCCA.1040302@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:38355 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261179AbUFMVZK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2004 17:25:10 -0400
In-Reply-To: <40CCBCCA.1040302@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:

> James Bottomley wrote:
> 
>> On Thu, 2004-05-27 at 03:25, Mike Christie wrote:
>>
>>> 01-add-host-transport-classdev.patch - adds the transport 
>>> class_device to
>>> the scsi_host structure.
>>
>>
>>
>> I've been thinking about this quite a bit, and I like the general idea,
>> I just have a quibble with the implementation.
>>
>> The main problem is the adding of a kobject to complement your host
>> transport class (and the device transport class).  I don't think we need
> 
> 
> I am not adding a host and a device transport class. I am structuring 
> things so there is a single fc transport class.
> 
>> to do this since, like the transport classes fall into either host or
>> device objects, so the events are similarly divided; thus, we should be
>> able to trigger the hotplug events through the host or device kobject
>> (that come with the embedded struct device) rather than adding another
>> kobject for the purpose.
> 
> 
> The kobject I added to the scsi_device replaced the class_device (and 
> its kobject) we were previously using for the device oriented transport 
> class. I did this only because I wanted the scsi device's parent to be 
> the host. In my patch, I then added a class_device to the host becuase 
> the host's parent was the "FC Class".

Oh yeah, with this type of setup the host and device hotplug events were 
all coming through the single FC class. Host events can be distinguished 
from device events by their DEVPATH (one ends in scsiN the other ends 
with W:X:Y:Z and has the scsiN prefixed to it).

> There is no technical argument why they couldn't be coded the way you 
> described. My patch just has the FC Class, where under it the device, 
> host and whatever objects arise are set up as parent/children to reflect 
> how SCSI/FC and the kernel structures really were.
> 
> It does not make a difference to me. It is easier to code just having a 
> fc_host_transport_class and a fc_device_transport_class. It seemed like 
> a waste to add more classes and doing the symlinks when you can just 
> restructure things though.
> 
> 
> Mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

