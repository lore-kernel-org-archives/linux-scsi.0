From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: dmesg spam
Date: Mon, 4 Feb 2008 13:07:46 -0800
Message-ID: <20080204130746.065ade43.akpm@linux-foundation.org>
References: <20080203143033.cfea0501.akpm@linux-foundation.org>
	<200802041524.55700.bzolnier@gmail.com>
	<20080204120548.79f3fe57.akpm@linux-foundation.org>
	<1202156101.3096.102.camel@localhost.localdomain>
	<47A773E2.2090803@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806AbYBDVIt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 16:08:49 -0500
In-Reply-To: <47A773E2.2090803@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Mon, 04 Feb 2008 15:21:54 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> James Bottomley wrote:
> > The message comes from sr_ioctl.c:sr_do_ioctl().  Which means some user
> > level application is poking the drive with a command that's returning
> > NOT_READY.  Apparently it will shut up if quiet is set in the packet
> > command structure.
> > 
> > It could be the application is getting the wrong idea of the status from
> > sr_do_staus() which leads it to send commands which require a medium?
> > But we'll need a bit of debugging to determine this.
> 
> 
> Userland polling of the cdrom is quite normal (if unfortunately), 
> regardless of medium presence.  Probably HAL or dbus.
> 
> In theory, the userland app should (a) set quiet and (b) handle 
> not-ready condition just fine.
> 
> I presume that (b) is ok, since not-ready just means to continue polling 
> the cdrom ad infinitum, until media appears.
> 
> A useful experiment, if only to confirm the obvious, would be to insert 
> some media.
> 
> What controller and device is in use?
> 

It's the thinkpad t61p.  Currently five miles away, powered off.  It's all
new Intel stuff iirc.

http://userweb.kernel.org/~akpm/dmesg-t61p.txt has some info but not the
right info afaict.

Bisection time I guess.  That'll be a new experience.
