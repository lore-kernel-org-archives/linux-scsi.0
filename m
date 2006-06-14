From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Wed, 14 Jun 2006 11:18:47 -0500
Message-ID: <449036E7.5050208@cs.wisc.edu>
References: <448DF5DA.3070800@sgi.com>	 <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com>	 <448EDCEB.50702@sgi.com>	 <1150221599.3441.54.camel@mulgrave.il.steeleye.com>	 <448F1403.6090903@sgi.com> <1150228960.3441.72.camel@mulgrave.il.steeleye.com> <448F31B0.5000104@sgi.com> <448FB8FB.7040300@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37534 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965029AbWFNQTM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 12:19:12 -0400
In-Reply-To: <448FB8FB.7040300@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Michael Reed <mdr@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>, James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

Hannes Reinecke wrote:
> Michael Reed wrote:
>> James Bottomley wrote:
>>> Since the rest of
>>> our infrastructure is already event driven, or migrating that way, I
>>> really don't see value in introducing an anomaly like this purely for
>>> fibre channel.
>> It's tough on fibre channel, being first.  :)
>>
>> Among the benefits of this patch is the purchase of time.  With the fc
>> infrastructure the way it is, you're assured of forcing developers to
>> "publish or perish".  That may be the intended desire.  It just doesn't
>> seem fair to the users who have to deal with this.  It makes sense to
>> me to implement the event driven infrastructure in such a way that
>> it's more complete when released.  If infrastructure is going to be
>> removed, then "applications" have to be adjusted to accommodate this.
>> It shouldn't be, oh by the way, your driver/app is now broken, hurry up
>> and fix it or your users will complain.  [End Of Rant].  My patch
>> buys time.  Change the default so that the remove on disconnect has
>> to be consciously overridden.  Remove the variable when the supporting
>> infrastructure is in place.  Put out a message indicating that the
>> option of not removing the infrastructure is "going away" in a future
>> release.  Provide an orderly transition.  Insure domestic tranquility.
>> Promote the general welfare.  :)  I'm happy to adjust the patch
>> to accommodate any of these suggestions if they are deemed acceptable.
>>
> And I can only _strongly_ agree with Mike here.
> Yes, the infrastructure is moving towards dynamic device configuration.
> But no, we're not there yet. Not by a long way.
> Neither of the current volume managers (ie LVM2, EVMS, and even md to
> some extend) are capable of dynamic reconfiguration.


I do not think DM based volume manager will work at all if all devices
in a DM table are removed at the same time temporarily. For dm-multipath
we would end up with no dm device and then the user will have to remount
the FS.

Does the kobject_uevent use also have problems? I guess GFP_KERNEL
allocations will not fail, but if all the devices are dm-multipath
devices is there the possibility that the GFP_KERNEL allocation will
wait forever or is there a way for it work eventually? Is this one of
those things we are waiting for the VM guys to fix, or do modify the
uevent code or just not get into it by never removing and readding the
devices?
