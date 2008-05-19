From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Mon, 19 May 2008 11:20:47 -0700
Message-ID: <1211221247.21974.382.camel@chandra-ubuntu>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>
	 <1210819801.21974.266.camel@chandra-ubuntu>  <482C0676.9070004@suse.de>
	 <1210964001.21974.351.camel@chandra-ubuntu>  <483154B0.7020500@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37529 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbYESSTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2008 14:19:11 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4JILBmS029005
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2008 14:21:12 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4JIIoJu113740
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2008 14:18:50 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4JIInL2000304
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2008 14:18:49 -0400
In-Reply-To: <483154B0.7020500@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>


On Mon, 2008-05-19 at 12:21 +0200, Hannes Reinecke wrote:
> Hi Chandra,
> 
> Chandra Seetharaman wrote:
> > On Thu, 2008-05-15 at 11:46 +0200, Hannes Reinecke wrote:
> >> Hi Chandra,
> >>
> >> Chandra Seetharaman wrote:
> >>> What is the purpose of this feature ?
> >>>
> >>> With dh_state functionality, one could associate a handler to a new
> >>> device and then if one does "multipath", the hardware handler would be
> >>> associated with the multipath device. What are we achieving by this ?
> >>>
> >> This allows multipath to override the device tables build into
> >> the device handler. Reason here is that multipath has a configuration
> >> file which allows the user to override the build-in defaults.
> >> And this includes the hardware handler, so we need to make sure that
> >> the hardware handler is indeed attached.
> > 
> > Hardware handler's existence is currently been verified during parsing
> > (by doing a request_module() followed by scsi_dh_handler_exist() in
> > parse_hw_handler()).
> > 
> Yes, but this only verifies that the _handler_ exist, not that it is
> attached to this sdev

Agreed. And it works properly with the original design.

Here is my thinking on how it would work with the new feature (ability
to attach any device using dh_state) you added:
 - User adds a new device
 - User knows which scsi hardware handler their device can attach to,
   lets say, "mydev".
 - User attaches the device with scsi hardware handler (writing "mydev"
   to "dh_state").
   Device is now attached to "mydev"
 - User updates his/her multipath.conf file with "mydev" for the
   specific device.
 - User invokes multipath, which checks for the existence of "mydev"
   and allows the table insertion.
 - When pg_init was required in the future, multipath calls "activate"
   for "mydev" correctly.

Wouldn't this work ?

Note: In the absence of this patch (7/7) only.

> 
> > Hardware handler module is attached to the device itself (thru
> > try_module_get() in attach), so, the module will exist as long as the
> > device exists.
> > 
> Not quite. It's only attached automatically if the device map has
> an entry for this module.
> However, given this patchset we can now easily manually attach any
> device to the device handler. Or at least try to do so.
> It's then up to the device handler to refuse binding if none of
> the necessary pages/information etc. was found.

Doesn't dh_state solve this issue ?

> 
> > Hence, there is no need to attach it again from the multipath layer.
> > 
> Yes, you do. The user might have it's own custom configuration file,
> covering new/unknown/unhandled/testing devices, which out of necessity
> are _not_ hardcoded in the device table of the device handler.
> So multipath has to have a way of attaching device handler to those
> devices, too.

dh_state allows the user to do this, in which case why do we need to do
this in multipath layer ?

> 
> Cheers,
> 
> Hannes

