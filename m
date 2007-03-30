From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 12:58:21 -0500
Message-ID: <1175277501.3760.32.camel@mulgrave.il.steeleye.com>
References: <460CDBA6.5030608@gmail.com>
	 <1175257751.3760.19.camel@mulgrave.il.steeleye.com>
	 <d120d5000703300615y7b367d82hb42f1c58ca8a6328@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58248 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752008AbXC3R6o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 13:58:44 -0400
In-Reply-To: <d120d5000703300615y7b367d82hb42f1c58ca8a6328@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2007-03-30 at 09:15 -0400, Dmitry Torokhov wrote:
> If you want to manage lifetime rules independently you might want to
> not embed struct device into you subsystems objects but attach them
> via pointers and use device_create(). Now that we orphan sysfs access
> upon unregistering device this will severe all ties from driver core
> to your system once you start teardown of a device and you should be
> in clear.

But that wouldn't really help ... all objects have lifetimes.  What
Tejun is pointing out is that we have two different lifetime
requirements:  driver internal (and subsystem) objects and sysfs
objects ... we still need something embedded in the driver objects, so
it may as well be struct device ... trying to manage struct device
outside of the driver objects would turn into another nasty refcounting
problem.  The struct device is usually the generic abstraction of the
specific structure it's embedded in, so I think it really does make
sense to keep these pieces together.

> However there are simpler subsystems (input, serio, etc.) where there
> is only one core module which provides services to device drivers and
> handles registration and deregistration. For such substustems it makes
> sense to embed struct devices and manage lifetime for all components
> at once.

James


