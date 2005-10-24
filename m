From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 0/6] marginalize HCIL a bit
Date: Mon, 24 Oct 2005 11:50:27 -0500
Message-ID: <1130172627.3325.57.camel@mulgrave>
References: <20051023013618.GA18201@havoc.gtf.org>
	 <1130081372.3437.33.camel@mulgrave>  <435D0283.40505@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45741 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751154AbVJXQuc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 12:50:32 -0400
In-Reply-To: <435D0283.40505@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Mon, 2005-10-24 at 11:49 -0400, Luben Tuikov wrote:
> On 10/23/05 11:29, James Bottomley wrote:
> > There's an unaddressed lifetime problem in all of this:  Originally the
> > target object exists solely internally and has its lifetime managed by
> > the mid-layer (it actually exists only as long as there are LUNs on it).
> 
> And this has always been wrong and I objected to this back when it
> was introduced a few years ago.

Only in your opinion.  The reason it was done this way was to protect
drivers from lifetime management, as I explained when it was done.

> > In your code cleanups, you keep the scsi_target_reap() function (which
> > is what checks the children and tries to destroy the device if it
> > doesn't find any) private (well, unexported).  So, on return from your
> > new scsi_scan_target(), the target pointer might be invalid (already
> > freed) if you didn't take a reference to starget->dev.  That's counter
> > to the way lifetime management of objects usually works.
> > 
> > I think the choices are
> > 
> > 1. Make the target an explicit object (like it's peers scsi_device and
> > scsi_host), so the layer creating it is responsible for managing it.
> 
> Which is exactly what I've been proposing: struct scsi_domain_device { };
> similarly to how it is done in the SAS Transport Layer/Stack in the link
> of my signature.
> 
> The new struct scsi_domain_device { } would be a logial (not imposed)
> superclass around the transport's domain device representation.
> The Transport Layer _registers_ a struct scsi_domain_device { };
> and then SCSI Core scans for LUs and does LU bookkeeping.

That's what scsi_scan_target() does.

> LUs -> SCSI Core
> SCSI Domain Targets -> Transport Layer around its own domain device
> representation:
> 
> struct scsi_domain_device {
> 	void *domain_device;    /* opaque to SCSI Core */
> 	
> 	struct list_head LU_list;
> 	...
> };
> 
> All of this functionality and infrastructure is present in the
> SAS Stack and could be taken almost as is.

Amazingly enough, it's also already present in the transport classes
(see vanilla linux kernel source code).

If you look at your domain device with all the sas pieces removed,
you'll see that scsi_target actually covers all the remaining bits
(there are one or two pieces covered by struct generic_device which you
have to have extra components for because you implemented kobjects
instead of a generic device).  scsi_target contains a variable space for
the transport classes to use for their transport specific pieces (which
is where you could have put all the sas specific bits).

The only real difference is that under the current infrastructure scsi
targets aren't designed to stack.  Realistically, the way you have it
implemented, you have several different devices lumped into your domain
device (end, edge, fanout, sata) with different initialisations and
behaviours, so scsi_target maps exactly to end devices.  I'm really not
a huge fan of object type overloading unless there's a good reason for
it, so in the generic device world, you'd probably have different
structures for the other device types (although nothing precludes
implementation as an overloaded type).

James


