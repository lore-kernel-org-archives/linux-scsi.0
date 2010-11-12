From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Thu, 11 Nov 2010 17:23:15 -0800
Message-ID: <20101112012315.GE17097@core.coreip.homeip.net>
References: <20101022175624.GA13640@kroah.com>
 <4CC1DAA2.7030602@vlnb.net>
 <20101022185437.GA9103@kroah.com>
 <4CD8566D.1020202@vlnb.net>
 <20101109002829.GA22633@kroah.com>
 <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com>
 <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com>
 <4CDC56F9.9040601@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56694 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab0KLBX2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 20:23:28 -0500
Content-Disposition: inline
In-Reply-To: <4CDC56F9.9040601@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

On Thu, Nov 11, 2010 at 11:50:01PM +0300, Vladislav Bolkhovitin wrote:
> Boaz Harrosh, on 11/11/2010 12:59 PM wrote:
> >> static void x_release(struct kobject *kobj)
> 
> Yes. Precisely speaking, of its kobj_type.
> 
> > This one is put on the kobj.release Right?
> > 
> >> {
> >> 	struct object_x *x;
> >> 	struct completion *c;
> >>
> >> 	x = container_of(kobj, struct object_x, kobj);
> >> 	c = x->release_completion;
> >> 	kfree(x);
> >> 	complete_all(c);
> >> }
> >>
> > 
> > I don't see the unregister of the object_x.kobj, where do
> > you do this one in x_release or del_object below?
> 
> Which unregister? Put for object_x.kobj is in del_object()
> 
> >> void del_object(struct object_x *x)
> >> {
> >> 	DECLARE_COMPLETION_ONSTACK(completion);
> >>
> >> 	...
> >> 	x->release_completion = &completion;
> >> 	kobject_put(&x->kobj);
> > 
> > This put might not be the last put on the object, IOs in flight
> > and/or open files might have extra reference on the object.
> > We release our initial ref, and below wait for all operations
> > to complete. (Is there a matter of timeout like files not closing?)
> 
> This is the last internal put. All other references are from outsiders.
> So, we are waiting for all them to put before we go on.
> 

The question is why do you need to wait here? I presume it is module
unloading path, but then it is quite bad - you can easily wedge your
subsystem if you make something to take a reference to your kobject
while module is ytying to be unloaded. Back when sysfs attributes tied
kobjects the easiest thing was to do:

	rmmod <module> < / sys/devices/..../attribute


If you are done with the kobject - just proceed with what you were doing
and let it die its own peaceful death some time later. You just need to
make sure release code sticks around to free it and your subsystem core
can be tasked with this. Use module counter to prevent unloading of the
subsystem core until all kobjects belonging to the subsystem are
destroyed.

-- 
Dmitry
