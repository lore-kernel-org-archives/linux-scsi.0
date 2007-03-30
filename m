From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 08:29:10 -0400
Message-ID: <1175257751.3760.19.camel__6645.44823016531$1175295505$gmane$org@mulgrave.il.steeleye.com>
References: <460CDBA6.5030608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55458 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992AbXC3M3o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 08:29:44 -0400
In-Reply-To: <460CDBA6.5030608@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2007-03-30 at 18:43 +0900, Tejun Heo wrote:
> Orphaning sysfs nodes on unregistration is a big step in this
> direction.  With sysfs reference counting out of the picture,
> implementing 'disconnect immediate' interface only on a few components
> (including request_queue) should suffice for most block device
> drivers.  I'm not familiar with other drivers but I don't think
> they'll be very different.

I agree with this statement.  The big question in my mind is how do we
do it?

The essential problem, and the reason why the lifetime rules are
entangled is that fundamentally, sysfs entries are managed by kobjects.
The things the device drivers are interested in is struct device, which
is usually embedded in driver data structures.  Unfortunately, the
required kobject is usually embedded in struct device meaning that the
relevant driver structure cannot be freed while the sysfs entry still
exists.

It seems to me that the only way to Orphan the sysfs entries is to
separate the kobject and the struct device so their lifetime rules are
no longer entangled.  Then we can free the driver structure with the
embedded struct device while still keeping the necessary kobject around
to perform orphaned sysfs operations.

So it seems to me that what we need to do is to give struct device its
own kref and a pointer to a kobject.  Then we can manage the separate
lifetimes independently.  The device would basically allocate and take a
reference to the kobject on device_add() and relinquish it again (and
null out the kobject pointer) on device_del().  The complexity here is
that we now have to allocate the kobject somewhere else ... probably in
device_add() (it doesn't come for free with the device structures).

James


