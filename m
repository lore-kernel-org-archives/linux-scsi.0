From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH RFC 1/3] add fc transport events
Date: Sun, 13 Jun 2004 16:17:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CCE09F.9040206@us.ibm.com>
References: <40B597F5.2030501@cs.wisc.edu>	<1087088793.1730.19.camel@mulgrave>  <40CCBCCA.1040302@us.ibm.com> <1087166778.10940.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:58501 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261389AbUFMXTy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2004 19:19:54 -0400
In-Reply-To: <1087166778.10940.23.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:

> On Sun, 2004-06-13 at 16:44, Mike Christie wrote:
> 
>>I am not adding a host and a device transport class. I am structuring 
>>things so there is a single fc transport class.
> 
> 
> I don't think that's such a good idea.  A class is supposed to represent
> an interface on a device.

Ok. I saw the class as representing a "thingy" not necessarily a device, 
becuase at one point the mainatiner had taken out the coupling of the 
"struct device" to the class_device which I thought this was for. For 
example the io scheduler or request queue could and probably should be a 
class if you wanted to abe able to hot swap the schedluer. In my case I 
was representing the transport itself as a class (the class_device 
should have gone into the fc_transport object and a transport_kobject 
should have been placed into the host though).

   The host and scsi device should have separate
> interfaces.  The only reason we don't have any host interfaces in the
> transport classes is because no-one has yet had a reason to add one. 
> However, since the loop status is definitely a host property, you
> do...part of what's missing is an attribute showing the loop state.  SPI
> has a similar need; the host property there is LVD or SE, and we might
> be interested in transitions between them.
> 
> 
>>The kobject I added to the scsi_device replaced the class_device (and 
>>its kobject) we were previously using for the device oriented transport 
>>class. I did this only because I wanted the scsi device's parent to be 
>>the host. In my patch, I then added a class_device to the host becuase 
>>the host's parent was the "FC Class".
>>
>>There is no technical argument why they couldn't be coded the way you 
>>described. My patch just has the FC Class, where under it the device, 
>>host and whatever objects arise are set up as parent/children to reflect 
>>how SCSI/FC and the kernel structures really were.
>>
>>It does not make a difference to me. It is easier to code just having a 
>>fc_host_transport_class and a fc_device_transport_class. It seemed like 
>>a waste to add more classes and doing the symlinks when you can just 
>>restructure things though.
> 
> 
> Well do it as two separate classes then.  Kobjects and Ksets are a bit
> of a minefield that I'd rather we didn't get into unless it's really,
> really necessary.  The abstraction we care about is the interface, which
> to the generic device stuff is the class.  If we stick to what we need,
> we'll get broken by generic device changes less often...
> 

Ok then.

Will this mean we will end up with device and host specific error 
handler issues that the classes will have to coordinate? For example, if 
I got a link down I know that cmds are going to be timing out for every 
device on the host, but depending on the setup if just the device's port 
went down I will not get a link down and may want to do something 
different. Or maybe not?

Mike
