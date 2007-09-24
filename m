From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on flushing buffers and spinning down disk
Date: Mon, 24 Sep 2007 11:34:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709241128520.4920-100000@iolanthe.rowland.org>
References: <200709241721.50887.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60775 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756230AbXIXPee (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 11:34:34 -0400
In-Reply-To: <200709241721.50887.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Mon, 24 Sep 2007, Oliver Neukum wrote:

> > suspend.  The PM and driver cores don't include _any_ provision for
> > runtime suspend; it has to be managed separately by each subsystem.
> 
> There we have a problem. We'd have to solve it for each subsystem transition.
> Storage has this type of children, other devices will have to care for other
> types of child devices. If we have a device tree, we should use it.

It sounds like you want to add the equivalent of
usb_autopm_get/set_device() and usb_autopm_get/set_interface() into the
driver model.  But it would not be appropriate, since other subsystems
don't have the same kinds of runtime power levels as USB does.

There may be no way of getting around the need for specialized 
communication methods between subsystems for runtime PM.

Alan Stern

