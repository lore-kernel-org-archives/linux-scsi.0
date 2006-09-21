From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptspi : min_period,max_offset,max_width,incorrectlyset, resulting domain validation failing
Date: Thu, 21 Sep 2006 16:32:26 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032D3D1@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7677 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751583AbWIUWnp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 18:43:45 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Wednesday, September 20, 2006 10:00 AM, James Bottomley wrote: 

> 
> Heh, Quantum Atlas ... I should have known ...
> 
> OK, try the attached (it's a rollup of all the heuristics 
> changes we've
> been discussing).
> 

Thanks so much
That appears to fix both issues I reported on U160 and U80 drives.
Can you pls apply this to your tree for 2.6.19 push. 

> Actually, there are: there are some fujitsu devices that do 
> QAS at u160.

Didn't know.  Can you verify that it works with fusion with QAS enabled?

> > Also, another problem is you should only enable QAS when all 
> > the devices on a single bus are U320(excluding safte proc).  
> > Meaning, if you have mixed mode case, such as U160 mixed with 
> > U320, you should disable QAS for all the U320 devices.
> > The problem you will face is the U320 devices with QAS enabled
> > are going to starve the bus, and the other devices never win 
> > arbitration.  I've seen in my test bed using current
> > spi transport.  In my environment, I have two U160 devices,
> > and one U320 device. Spi transport will enable
> > QAS for the U320 device.
> 
> This is a user policy thing.  Usually you want QAS set where 
> possible to
> speed up the transport ... if you're getting starvation problems, you
> can disable it using the parameters.
> 

I just don't think that is a good idea.
I forsee support calls, for users that don't know they
can't run QAS in mixed mode, and don't know this work around
that your suggesting.   Its going happen.  
I still think back to Andrew Patterson's request that we 
have a mechnism to turn one knob to shut off QAS for entire host, 
instead of traversing each and every target.

Eric


