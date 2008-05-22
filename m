From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Thu, 22 May 2008 09:14:54 +0100
Message-ID: <1211444095.3956.6.camel@localhost.localdomain>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>
	 <1210819801.21974.266.camel@chandra-ubuntu>  <482C0676.9070004@suse.de>
	 <1210964001.21974.351.camel@chandra-ubuntu>  <483154B0.7020500@suse.de>
	 <1211221247.21974.382.camel@chandra-ubuntu>  <4832C706.5040202@suse.de>
	 <1211309554.21974.427.camel@chandra-ubuntu>  <4833BEB2.1070305@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51059 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758870AbYEVXmx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2008 19:42:53 -0400
In-Reply-To: <4833BEB2.1070305@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: sekharan@us.ibm.com, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>

On Wed, 2008-05-21 at 08:18 +0200, Hannes Reinecke wrote:
> Chandra Seetharaman wrote:
> > Hi Hannes,
> > 
> > Now I see why you want this change in dm-multipath. I think I agree with
> > these changes.
> > 
> Ah. good.
> 
> > But, it brings another question: what does dh_state provide ? Help to
> > user to see which hardware handler a device is attached to ?
> > 
> And allowing to attach to a different hardware handler.
> Not everyone is running multipathing, but might be interested in the
> having the device handler nevertheless.
> 
> > I thought more about the scsi_dh_detach function (in the context of my
> > earlier comment), adding it would require more housekeeping to associate
> > one-to-one mapping between attach and detach. We can leave it the same
> > way as the module will be detached when the device disappear eventually.
> > 
> Why? You can detach with dh_state, too; just do an
> 
> echo detach > /sys/block/sdX/device/dh_state
> 
> and the hardware handler will detach.
> So no additional attribute is required.

Actually, if you're going down this route, it makes more sense to have
the device handler be a driver ... remember you were the one promising
multiple driver binding at the FS/Storage summit ...  that way we can
use all the generic driver standard interfaces for manual
binding/unbinding.  Plus we can place the attributes as driver attribute
groups.

James


