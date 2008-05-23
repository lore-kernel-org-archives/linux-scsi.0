From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Fri, 23 May 2008 09:06:21 -0500
Message-ID: <1211551581.11477.10.camel@localhost.localdomain>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>
	 <1210819801.21974.266.camel@chandra-ubuntu> <482C0676.9070004@suse.de>
	 <1210964001.21974.351.camel@chandra-ubuntu> <483154B0.7020500@suse.de>
	 <1211221247.21974.382.camel@chandra-ubuntu> <4832C706.5040202@suse.de>
	 <1211309554.21974.427.camel@chandra-ubuntu> <4833BEB2.1070305@suse.de>
	 <1211444095.3956.6.camel@localhost.localdomain>
	 <20080523114008.GG380@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60600 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733AbYEWOGZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2008 10:06:25 -0400
In-Reply-To: <20080523114008.GG380@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2008-05-23 at 13:40 +0200, Hannes Reinecke wrote:
> On Thu, May 22, 2008 at 09:14:54AM +0100, James Bottomley wrote:
> > On Wed, 2008-05-21 at 08:18 +0200, Hannes Reinecke wrote:
> [ .. ]
> > > Why? You can detach with dh_state, too; just do an
> > > 
> > > echo detach > /sys/block/sdX/device/dh_state
> > > 
> > > and the hardware handler will detach.
> > > So no additional attribute is required.
> > 
> > Actually, if you're going down this route, it makes more sense to have
> > the device handler be a driver ... remember you were the one promising
> > multiple driver binding at the FS/Storage summit ...  that way we can
> > use all the generic driver standard interfaces for manual
> > binding/unbinding.  Plus we can place the attributes as driver attribute
> > groups.
> > 
> Hmm. Actually this very discussion I had with Kay Sievers earlier this
> week when we tried to make bsg useable for udev.
> The problem here is that we really want the device_handler to kick in
> _before_ any of the 'normal' SCSI ULD starts it's probing, as we might
> want to suppress I/O on this channel.

That's easily doable provided there's some type of trigger for
registration.  At the moment, it's just a binding free for all since
drivers bind either when they appear (for existing devices) or when the
device appears (for existing drivers).  For the new multiple driver
binding code, I could see a good case for either strictly controlling
the ordering (for binding a new device to existing drivers) or even
making the bindings classification driven.

> If we were to use the normal driver binding for this we'd be called
> at the same level with the normal ULDs, making it unpredictable at which
> time we're called.

Depends how it's done.  Right at the moment with only a single driver
there's no concept of ordering ... if it's list based, then it would be
in list order, but there's no reason the order can't be dictated by the
bus.

> And it was actually Greg KH which promised the multiple driver binding,
> but seems that he's not getting around doing this anytime soon.

Well, since we have the use case, the rules of open source would tend to
dictate that we have the impetus to do it.  Particularly when there's
tricky questions like binding order to be answered.

> Hmm; maybe I can convince Kay on doing it ...
> But want we really want to do is _not_ having these 'special' handlers
> called at any time during bus probing, but having a fixed order like:
> 
> sdev probing
>  - (optional) device handler attach
>  - bsg attach
>  - SCSI ULD probing
> 
> We would like to have bsg available before ULD probing, as then we could
> use the bsg device nodes in general in udev (like calling scsi_id on it).
> It _might_ be possible to handle these cases with multiple driver binding,
> but seeing that there's no-one currently working on it I'd like to stick
> with the current approach.

I think a simple priority based scheme would cope with that.  Say a
single integer in the bus for max priority and then it loops from zero
to max binding all drivers equal to that priority.  We could use 3 (zero
for device handler, one for bsg and 2 for ULD).  We should probably use
1 as the default for everything, giving the ability to bind either
before or after the default (using zero or 2).

James


