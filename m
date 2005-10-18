From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Adaptec SAS integration notes
Date: Tue, 18 Oct 2005 16:51:48 -0400
Message-ID: <43556064.20104@pobox.com>
References: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com> <43552650.2090104@pobox.com> <43555CC1.8040200@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:29850 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932092AbVJRUvy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2005 16:51:54 -0400
In-Reply-To: <43555CC1.8040200@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, ltuikov@yahoo.com, Mike Anderson <andmike@us.ibm.com>, Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>

Stefan Richter wrote:
> All transports implement HCIL mappings. (SPI drivers enjoy the easiest 
> mapping, hcil<->HCIL.) They are all faced with the necessity of mapping 
> and solve it in different ways, for different reasons. Why stop at FC + 
> SAS and try to find a unified solution for just those two? Also, when 
> you are working out how FC and SAS could interface to a common HCIL 
> mapping library (or HCIL mapping layer?), you are effectively designing 
> aspects of how an interface between FC|SAS and SCSI core should look 
> like. Or, why not provide the HCIL mapping helpers in the core and 
> subsequently make users of this new interface completely unaware of the 
> existence of HCIL...?

Ignoring some legacy ioctls and bits of existing code...   The only 
mapping that's _really_ required is an internal C pointer, used by the 
device class to send messages to the transport class.

Adaptec's code does a bit of that on the transport side, but we'd need 
to update all the existing device classes (sd, sr, st, ...) before they 
had been converted to a purely using pointers to connect the transport 
to the device.

Getting to the point where device classes need only to do

	transport_instance->send_message(scsi command | TMF)

and where the transport class replies with

	device_instance->send_message(scsi response | TMF response)

may be a long term goal.  Depends on where evolution takes us...


> Moreover, HCIL mapping is but one aspect of a common problem. As an 
> example, I think yet another aspect of the same problem is that device 
> properties like target names and LUNs get lost below the 
> transport<->core interface. We want to present these device properties 
> to userspace in a unified manner. Here it becomes even more clear: 
> Neither is it a problem for FC and SAS alone, nor are transport-level 
> helpers a good solution to the problem.

Target names are already in the generic device.  Luben has a good point, 
though, that there may be multiple "labels" for the same addressible object.


> I freely admit that I don't have a picture of where the real 
> difficulties lie; I am far too unfamiliar with the innards of scsi core. 
> But time spent on transport-level helpers which are meant to ease 
> symptoms of the transport<->core difficulties seems to be spent rather 
> ineffectively to me. More concrete, what is the ratio of benefit to cost 
> of HCIL mapping code sharing between SAS and FC? Especially since that 
> mapping is deemed obsolete already (in the long term or perhaps even mid 
> term). And to completely go back to the subject: Will attempts on code 
> sharing between FC layer and SAS layer bring things forward in the 
> short-term goal of SAS integration?

HCIL mapping is a simple and very small part of this task :)  There are 
a bunch of line items to tackle, including SMP and SDI details, all 
bundled up in this.

	Jeff


