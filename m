From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Add attribute container to the generic device model
Date: Tue, 11 Jan 2005 23:08:02 -0800
Message-ID: <20050112070802.GB2085@kroah.com>
References: <1105506370.10378.26.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:43448 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S263027AbVALHIK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 02:08:10 -0500
Content-Disposition: inline
In-Reply-To: <1105506370.10378.26.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, Jan 11, 2005 at 11:06:10PM -0600, James Bottomley wrote:
> Attribute containers allows a single device to belong to an arbitrary
> number of classes, each with an arbitrary number of attributes.

But classes could always have an arbitrary number of attributes, right?

> This will be used as the basis for a generic transport class, but I did
> it like this in case anyone found the abstraction useful.

Hm, I like the idea, but we already allow devices belonging to arbitrary
number of classes (through class_device) today.  What makes this
different?

And how does this change, if at all, sysfs representations of devices
that use this?

Some minor comments about the code:

> +EXPORT_SYMBOL(attribute_container_classdev_to_container);

Can these all be EXPORT_SYMBOL_GPL?  It's your choice, as you wrote the
code, but we're trying to keep the driver model stuff all GPL explicit,
as there's no way someone can say it's a "derived work" from long ago
that's using these new functions.

> +/**
> + * attribute_container_add_device - see if any container is interested in dev
> + *
> + * @dev: device to add attributes to
> + * @fn:	 function to trigger addition of class device.
> + *
> + * If no fn is provided, the code will simply register the class
> + * device via class_device_add.

You mean the class_device of the "container", right?

The code looks sane, if not a bit confusing as there's no user of it :)

thanks,

greg k-h
