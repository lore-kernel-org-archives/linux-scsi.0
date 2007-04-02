From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SMP pass through interface via bsg
Date: Mon, 02 Apr 2007 12:10:58 -0500
Message-ID: <1175533858.3680.36.camel@mulgrave.il.steeleye.com>
References: <20070402110125U.fujita.tomonori@lab.ntt.co.jp>
	 <1175486263.27675.11.camel@mulgrave.il.steeleye.com>
	 <461108E1.9070405@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60023 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933741AbXDBRLa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 13:11:30 -0400
In-Reply-To: <461108E1.9070405@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hch@infradead.org, dougg@torque.net, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Mon, 2007-04-02 at 09:45 -0400, James Smart wrote:
> 
> James Bottomley wrote:
> >> -- each SAS object (host, device, expander, etc) has the own bsg
> >> device
> > 
> > I think so; probably attached via the transport class.
> 
> FYI - I understand the idea of a bsg device per object, but really, for
> something that is used rarely, it's a bunch of overhead.

It's some overhead, yes ... although rarely do the control elements
(switches, expanders, etc.) outnumber the actual end devices
significantly, so it's only a fractional increase in most configurations

>  Objects, data
> structures, etc - more udev/kobject mgmt.... 

This I'm prepared to trade for usability ... also, in our current sysfs
layout, we already have most of these objects.  Fundamentally, it's
easier just to use something that already exists in your hierarchy to do
the mapping, so /sys/class/bsg/expander-2:0 in tomo's example.

However, I realise this could be hidden by the tools as well in the
single tap, so it's a weak argument.

>  I believe I prefer the
> approach of a shared distribution point - e.g. one bsg device at the
> transport globally, or perhaps one at the host (actually the outbound
> port aka host/channel) supporting the transport - followed by headers
> in the messages that direct flow after that. This kinda follows the
> model we have today for I/O - w/ queuecommand for the host, and
> addressing in the SCSI command.

> Additionally, I've always had some concern that we had to create an
> object for everything in the SAN (every phy!), and have that view replicated
> per host (for multi-initiator/multi-path SANs). I always believed there
> was some sets of things that you would want to talk to that just doesn't
> justify a new object (for example - do we start talking to process associators
> in FC ?).  Another reason to move toward a transport-specific addressing
> header.

Well, that's a generic problem with sysfs and the device model.  We can
shortcircuit it by removing irrelevant objects ... so we don't actually
see phys in the FC tree, do we?  but for relevant objects, yes we do
show and allocate them.

> My other concern with using bsg and the i/o path for transport management
> functions is they compete with i/o for things like the can_queue values.
> Should they ? Should they have higher priority ?
> 
> > I'd really rather not go this route unless the one device per object
> > approach becomes untenable.
> 
> Understood, but building things until they topple is not a great idea
> as there will be back-ward compatibility issues w/ user-space/sysfs and
> the tools built around it. If you start with the shared distribution
> point, you can always support both (eventually) if its a good idea.
> Harder to do that in the reverse if it's toppling.

True ... but the one tap per relevant object approach won't explode over
what we currently have (i.e. if it's going to fall over, it will anyway
regardless of this issue ...)

> >> The patch adds a hook into sas transport class. sas_host_setup calls
> >> bsg_register_queue. Then, the request_fn calls smp_execute_task to
> >> send a smp request and get the response. It doesn't look good to link
> >> the sas transport class with libsas. In addition, the mpt driver
> >> handles smp request/response in a very different way.
> >>
> >> Any suggestion to bind SMP pass through via bsg to aic94xx and mpt
> >> cleanly?
> > 
> > bind in the transport class, not the driver ...
> 
> Agree - the trick for libsas is to get an interface into the driver that
> both drivers can support.
> 
> -- james s

James


