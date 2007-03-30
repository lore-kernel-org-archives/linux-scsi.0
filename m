From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 13:19:34 -0500
Message-ID: <1175278774.3760.44.camel@mulgrave.il.steeleye.com>
References: <460CDBA6.5030608@gmail.com>
	 <1175257751.3760.19.camel@mulgrave.il.steeleye.com>
	 <460D12B8.6050101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58452 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750726AbXC3SUb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 14:20:31 -0400
In-Reply-To: <460D12B8.6050101@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2007-03-30 at 22:38 +0900, Tejun Heo wrote:
> My plan was to make sysfs more independent from struct device/kobject.
> e.g. Something like the following.

That's sort of what I was reaching for too ... it just looks to me that
all the sysfs glue is in kobject, so they make a good candidate for the
pure sysfs objects.  Whatever we do, there has to be breakable cross
linking between the driver's tree and the sysfs representation ... of
course, nasty things like ksets get in the way of considering the
objects as separate, sigh.

> * kobject_get() on attr/symlink creation
> * open() doesn't need extra kobject reference
> * deleting a node makes it release the kobject reference and the kobject
> pointer is nullified.

To do this, you'll have to move at least the dentry out of the kobject,
I think.

> This way the sysfs reference counting can be put completely out of
> picture without impacting the rest of code.  Handling symlink and
> suicidal attributes might need some extra attention but I think they can
> be done.

True ... but you'll also have to implement something within sysfs to do
refcounting ... it needs to know how long to keep its nodes around.

> In the long term, I think sysfs should be independent from driver model
> and kobject such that an entity which wants to use sysfs but is not a
> device doesn't have to dance with kobject just to use sysfs.

I agree ... the question is just how to do it.

I'd favour trying to separate kobject and struct device for this ...
move all the sysfs stuff into kobject and device only stuff into struct
device ... but that would get us into disentangling the ksets, which, on
balance, isn't going to be fun ...

James


