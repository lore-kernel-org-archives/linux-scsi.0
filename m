From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl
	for	sysfs	take 2
Date: 07 Sep 2004 19:34:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094600074.2401.234.camel@mulgrave>
References: <20040907210520.0251476C56@isis.visi.com>		<413E2440.8080509@cs.wisc.edu>
	<1094592818.1716.159.camel@mulgrave> 	<413E2A17.80107@us.ibm.com>
	<1094594715.1716.169.camel@mulgrave>  <413E38DB.6040408@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:7579 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268769AbUIGXhT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 19:37:19 -0400
In-Reply-To: <413E38DB.6040408@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Scott M. Ferris" <sferris@acm.org>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-09-07 at 18:40, Mike Christie wrote:
> > Possibly, but only if the way its handled would be the same on all iscsi
> > initiator drivers.  Otherwise, if it's specific to the driver
> > implementation, it would be in hostdata. 
> 
> Yes, ok. That is what I am striving for. By us hanging things like 
> target name on the target instead of on the scsi device or scsi host 
> will help us conform to other HW iscsi drivers.

You're thinking of the qlogic one?  They have an entire network stack
onboard and they do have resource restrictions per card.  A virtual
driver doesn't.

>   Regardless, you'd still have
> > one host per one of these entities.
> 
> One host per I_T nexus/session? But I thought the only reason against 
> using a single host for all nexii (ignoring the port/channel 
> discussion), was that the driver would need its own refcounting.

It's not just refcounting, it's resource management.  It seems to me,
given that you can allocate resources per connection that per connection
is the most efficient way to manage them.

> If the target has some place for driver target data (with the common 
> iscsi code going in the appropriate transport class stucts) couldn't we 
> just do sometihng similar to how a scsi_device has the hostdata pointers 
> and drivers seem to assume when slave_destroy is called they can just 
> free what was allocated in slave_alloc. And when the driver does its 
> final scsi_host_put it assumes the hostdata will get freed when all the 
> handles are released. If the midlayer could provide any similar lifetime 
> management functionality for targets the iscsi driver would not need any 
> private structures that are refcounted internally since everything could 
> fall under the host, device, or target's managemnet.

Theoretically, I suppose.  The mid-layer really prefers to think in
terms of hosts and devices.  It doesn't really have much use for
targets.

James


