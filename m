From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl	for	sysfs	take
 2
Date: Wed, 08 Sep 2004 02:19:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413ECEAD.3050409@us.ibm.com>
References: <20040907210520.0251476C56@isis.visi.com>		<413E2440.8080509@cs.wisc.edu>	<1094592818.1716.159.camel@mulgrave> 	<413E2A17.80107@us.ibm.com>	<1094594715.1716.169.camel@mulgrave>  <413E38DB.6040408@us.ibm.com> <1094600074.2401.234.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:39360 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269048AbUIHJZm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2004 05:25:42 -0400
In-Reply-To: <1094600074.2401.234.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Scott M. Ferris" <sferris@acm.org>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Tue, 2004-09-07 at 18:40, Mike Christie wrote:
> 
>>>Possibly, but only if the way its handled would be the same on all iscsi
>>>initiator drivers.  Otherwise, if it's specific to the driver
>>>implementation, it would be in hostdata. 
>>
>>Yes, ok. That is what I am striving for. By us hanging things like 
>>target name on the target instead of on the scsi device or scsi host 
>>will help us conform to other HW iscsi drivers.
> 
> 
> You're thinking of the qlogic one?  They have an entire network stack
> onboard and they do have resource restrictions per card.  A virtual
> driver doesn't.
> 

I just meant that I am trying to get the iscsi transport class to have 
common code across virtual and non virtual drivers. I was not striving 
for virtual and non-virtual to alloc hosts alike. I was the one that 
converted the iscsi driver to host per session and caused this mess :(

The reason I kept asking below is becuase I misunderstood the resource 
comment, and was unsure if I did the right thing and was supposed to 
convert the driver back to a single host.

>>  Regardless, you'd still have
>>
>>>one host per one of these entities.
>>
>>One host per I_T nexus/session? But I thought the only reason against 
>>using a single host for all nexii (ignoring the port/channel 
>>discussion), was that the driver would need its own refcounting.
> 
> 
> It's not just refcounting, it's resource management.  It seems to me,
> given that you can allocate resources per connection that per connection
> is the most efficient way to manage them.
> 
>>If the target has some place for driver target data (with the common 
>>iscsi code going in the appropriate transport class stucts) couldn't we 
>>just do sometihng similar to how a scsi_device has the hostdata pointers 
>>and drivers seem to assume when slave_destroy is called they can just 
>>free what was allocated in slave_alloc. And when the driver does its 
>>final scsi_host_put it assumes the hostdata will get freed when all the 
>>handles are released. If the midlayer could provide any similar lifetime 
>>management functionality for targets the iscsi driver would not need any 
>>private structures that are refcounted internally since everything could 
>>fall under the host, device, or target's managemnet.
> 
> 
> Theoretically, I suppose.  The mid-layer really prefers to think in
> terms of hosts and devices.  It doesn't really have much use for
> targets.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

