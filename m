From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 08 Apr 2009 12:13:03 -0700
Message-ID: <1239217983.12451.40.camel@chandra-ubuntu>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com>
	 <1237403902.14147.25.camel@chandra-ubuntu>
	 <1237488880.26341.15.camel@chandra-ubuntu>  <49C3DF49.8050408@redhat.com>
	 <1237846429.14853.6.camel@chandra-ubuntu>
	 <1238798590.20924.0.camel@chandra-ubuntu>
	 <20090407232233.GE24591@pentland.suse.de>
	 <1239148215.14988.22.camel@chandra-ubuntu>
	 <ac3eb2510904072215g268956f7i44bd3005be64632@mail.gmail.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:41254 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811AbZDHTMx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 15:12:53 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n38JAbVl002547
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 13:10:37 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n38JCqPL197262
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 13:12:52 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n38JCoZn009197
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 13:12:52 -0600
In-Reply-To: <ac3eb2510904072215g268956f7i44bd3005be64632@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Peter Jones <pjones@redhat.com>

Hi Kay,

Thanks for looking into this.

On Tue, 2009-04-07 at 22:15 -0700, Kay Sievers wrote:
> On Tue, Apr 7, 2009 at 16:50, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> > On Wed, 2009-04-08 at 01:22 +0200, Hannes Reinecke wrote:
> >> On Fri, Apr 03, 2009 at 03:43:10PM -0700, Chandra Seetharaman wrote:
> 
> >> > If not, Can you accept the patches, please.
> >> >
> >> The problem here is that module autoloading doesn't work for
> >> device_handler. We have to have the callbacks in place _before_
> >> driver probing starts as we might need to intercept the I/O
> >> requests and/or errors. When using modalias the module loading
> >> will be too late and the hooks will only be established after
> >> the probing has already happened.
> >> (The module autoloading is an asynchronous call in device_add(),
> >> where we don't write for it to succeed. So probing will continue
> >> and we woulnd't have the callbacks in place when probing
> >> starts).
> >
> > Your analysis is correct.
> >
> > But, the chicken-n-egg problem you described exists only for the first
> > device that is probed, module will be in place for the other devices.
> >
> > The first device race is handled by acting on the bus notification for
> > the BUS_NOTIFY_BOUND_DRIVER event (patch 3/3 in my patch list).
> 
> How do you make sure, that the module is initialized when the
> BOUND_DRIVER event is happening? The userspace process loading the
> module can take any time to load, and I don't see how that is handled.
> Care to explain that in detail?

Sure.

Currently, when a scsi_dh (like scsi_dh_rdac) module is insmodded, it
sets up a notification for BUS_NOTIFY_ADD_DEVICE, and will walk thru the
bus list and attach all the devices that _are_ already configured.

With the attached patches, there are three ways that a device
can get attached to the module.
 1 scanning of the bus list by the module, if the module is inserted
   after the device is configured.
 2 by handling NOTIFY_ADD_DEVICE by the module, if the device comes
   after the module is inserted.
 3 the third case, which is the race Hannes mentioned, which is 
   mostly w.r.t the device that initiates this modalias chain of
   events, is that the device is past the NOTIFY_ADD_DEVICE point
   in the device configuration path and is still not completely 
   configured hence it is not in the bus_list (so 1 and 2 will 
   miss this). This device will be caught the BOUND_DEVICE
   notification which is just before adding the device to the 
   bus list in the device configuration path.

Hope it is clear now.
> 
> I guess, you either need to implement a "device scan" from the module
> loading routine to find all currently unhandled devices, or you need

We do that currently (without these patches) in scsi_dh. But the problem
is how do we get the module in place.

> to issue a blocking request_module() from inside the kernel and try to
> find a matching module, and then run the find again. The modalias

You mean call request_module() during device configuration ? Even if we
do that, we will not find the same devices again if we probe, so we will
have the same issue as we have in hand as of now. So not much of an
improvement.

> seems not like the right solution here.
> 
> Thanks,
> Kay

