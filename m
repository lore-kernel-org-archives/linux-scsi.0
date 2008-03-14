From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Fri, 14 Mar 2008 16:20:19 -0500
Message-ID: <1205529619.2904.87.camel@localhost.localdomain>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48906 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759282AbYCNVUY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2008 17:20:24 -0400
In-Reply-To: <1205514958.2904.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>

On Fri, 2008-03-14 at 12:15 -0500, James Bottomley wrote:
> On Thu, 2008-03-13 at 14:06 -0700, Greg KH wrote:
> > Here's a huge patch from Tony and Kay that converts the scsi layer to
> > use struct device instead of class_device.
> > 
> > It doesn't seem like it could be split up any smaller due to the
> > interconectedness of the whole mess, if you have any suggestions
> > otherwise, it would be appreciated.
> > 
> > If you want, I can take this through my tree as it does depend on a
> > previous IB patch to make that portion of the patch much smaller.
> > 
> > After this, all of the class_device code is now finally gone from the
> > kernel!
> 
> Actually, I have it built and running (actually 2.6.25-rc5-mc5 which
> includes all the changes in your tree).  Amazingly it's pretty much
> fully functional, except ses which seems to have suffered a breakdown in
> the way its model works.  I'll see if I can fix it up.

OK, I looked at converting ses and enclosure, but it looks impossible
given the way you've set all of this up (and at the moment it's almost
non functional).

What it wants is for the enclosure and component devices to be arranged
hierarchically under the enclosure class and then the device link of the
components to be populated if they're actually present (which they might
not be).

Given the fact that you've chosen to have dev->parent point to the
device the original class_device->dev was pointing to, there's almost no
way left to express this relationship.  We can do it by having
kobj->parent point to the enclosure and dev->parent point to the
enclosed device, but I can't encapsulate that information into a struct
device alone.

>From an interface point of view, this dual use of the parent pointer
looks a bit nasty ... and you have some fun code to prove the point in
drivers/base/core.c:get_device_parent()

How about just adding a struct device *peer; entry to struct device and
using it to express the former class relationship?  That way we can do
all the parenting stuff correctly.

Otherwise, I'm going to need something like a device_add_class_parent()
API that allows me to add these former class devices and set up the
kobject parent correctly.

James


