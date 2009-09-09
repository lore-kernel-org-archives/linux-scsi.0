From: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
Date: Wed, 09 Sep 2009 17:12:26 -0500
Message-ID: <4AA8284A.3010908@codemonkey.ws>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>	 <4AA8177A.2020606@codemonkey.ws> <1252533093.24633.40.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:55618 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZIIWM0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2009 18:12:26 -0400
In-Reply-To: <1252533093.24633.40.camel@ank32.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akataria@vmware.com
Cc: James Bottomley <James.Bottomley@suse.de>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Brian King <brking@linux.vnet.ibm.com>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, virtualization <virtualization@lists.linux-foundation.org>

Alok Kataria wrote:
> I see your point, but the ring logic or the ABI that we use to
> communicate between the hypervisor and guest is not shared between our
> storage and network drivers. As a result, I don't see any benefit of
> separating out this ring handling mechanism, on the contrary it might
> just add some overhead of translating between various layers for our
> SCSI driver.
>   

But if you separate out the ring logic, it allows the scsi logic to be 
shared by other paravirtual device drivers.  This is significant and 
important from a Linux point of view.

There is almost nothing vmware specific about the vast majority of your 
code.  If you split out the scsi logic, then you will receive help 
debugging, adding future features, and improving performance from other 
folks interested in this.  In the long term, it will make your life 
much, much easier by making the driver relevant to a wider audience :-)

> Having said that, I will like to add that yes if in some future
> iteration of our paravirtualized drivers, if we decide to share this
> ring mechanism for our various device drivers this might be an
> interesting proposition. 
>   

I am certainly not the block subsystem maintainer, but I'd hate to see 
this merged without any attempt at making the code more reusable.  If 
adding the virtio layering is going to somehow hurt performance, break 
your ABI, or in some way limit you, then that's something to certainly 
discuss and would be valid concerns.  That said, I don't think it's a 
huge change to your current patch and I don't see any obvious problems 
it would cause.

Regards,

Anthony Liguori
