From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH RFC 1/3] add fc transport events
Date: 13 Jun 2004 18:46:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087166778.10940.23.camel@mulgrave>
References: <40B597F5.2030501@cs.wisc.edu>
	<1087088793.1730.19.camel@mulgrave>  <40CCBCCA.1040302@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:57561 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261239AbUFMWqX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2004 18:46:23 -0400
In-Reply-To: <40CCBCCA.1040302@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-06-13 at 16:44, Mike Christie wrote:
> I am not adding a host and a device transport class. I am structuring 
> things so there is a single fc transport class.

I don't think that's such a good idea.  A class is supposed to represent
an interface on a device.  The host and scsi device should have separate
interfaces.  The only reason we don't have any host interfaces in the
transport classes is because no-one has yet had a reason to add one. 
However, since the loop status is definitely a host property, you
do...part of what's missing is an attribute showing the loop state.  SPI
has a similar need; the host property there is LVD or SE, and we might
be interested in transitions between them.

> The kobject I added to the scsi_device replaced the class_device (and 
> its kobject) we were previously using for the device oriented transport 
> class. I did this only because I wanted the scsi device's parent to be 
> the host. In my patch, I then added a class_device to the host becuase 
> the host's parent was the "FC Class".
> 
> There is no technical argument why they couldn't be coded the way you 
> described. My patch just has the FC Class, where under it the device, 
> host and whatever objects arise are set up as parent/children to reflect 
> how SCSI/FC and the kernel structures really were.
> 
> It does not make a difference to me. It is easier to code just having a 
> fc_host_transport_class and a fc_device_transport_class. It seemed like 
> a waste to add more classes and doing the symlinks when you can just 
> restructure things though.

Well do it as two separate classes then.  Kobjects and Ksets are a bit
of a minefield that I'd rather we didn't get into unless it's really,
really necessary.  The abstraction we care about is the interface, which
to the generic device stuff is the class.  If we stick to what we need,
we'll get broken by generic device changes less often...

James


