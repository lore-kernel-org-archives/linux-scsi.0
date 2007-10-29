From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v4 0/2] [SCSI] Asynchronous event notification
	infrastructure
Date: Mon, 29 Oct 2007 10:43:44 -0500
Message-ID: <1193672624.3383.25.camel@localhost.localdomain>
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40218 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752608AbXJ2Pnr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 11:43:47 -0400
In-Reply-To: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>, akpm@linux-foundation.org

On Mon, 2007-10-29 at 10:42 -0400, Jeff Garzik wrote:
> This is the next revision of the SCSI event notification infrastructure
> patchset, enabling SATA Asynchronous Notification ("AN") for CD/DVD
> devices that support it.
> 
> For devices that support SATA AN (only very recent ones do), this means
> that HAL and other userspace utilities no longer need to repeatedly poll
> the CD/DVD device to determine if the user has changed the media.
> 
> This revision takes into account James' comments from earlier today,
> modulo the following notes:
> 
> * I think the various event attributes should always be present,
>   for all devices at all times.  If various events are not supported,
>   the attribute will of course return zero (false, not supported).

Actually, I don't think so.  We have precedent for this in the transport
classes: if a device doesn't support a feature, we don't export the flag
for that feature through sysfs.  This allows not only feature control,
but an immediate view of the device capabilities simply by viewing the
sysfs directory.

I think this functionality is very easy to layer in, so there's no
reason not to do it.

> * I do not think this work should be blocked behind a revamp
>   of the attribute group interface.

Assuming gregkh or kay ack, it won't be.

> * I was slack and did not bother to implement the 'set' operation
>   for the attributes.  This can easily be done at a later time in a
>   separate patch.  It is not a merge stopper to have the driver
>   exclusively control the event mask, rather than driver+sysfs.

James


