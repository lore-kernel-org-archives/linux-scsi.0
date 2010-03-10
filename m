From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: mptscsih errors talking to Areca based SCSI-attached unit
Date: Wed, 10 Mar 2010 21:05:29 +1100
Message-ID: <20100310100529.GA2919@brong.net>
References: <20100226125514.GA6649@brong.net>
 <1C9608B8A4CD534FB19C7C7543CBB249020E1A7BCD@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from forward1.smtp.messagingengine.com ([66.111.4.223]:33216 "EHLO
	forward1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab0CJKFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2010 05:05:32 -0500
Content-Disposition: inline
In-Reply-To: <1C9608B8A4CD534FB19C7C7543CBB249020E1A7BCD@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Bron Gondwana <brong@fastmail.fm>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Mar 10, 2010 at 02:19:53PM +0530, Desai, Kashyap wrote:
> Bron,
> 
> See
> https://bugzilla.novell.com/show_bug.cgi?id=554152
> 
> From first look they might be similar issue or may be of same type of issue.

Yes, it does look very similar.  Basically it's a timeout error on the
drive (or block device as exported by an external unit in our case).  It's
frustrating that it can't abort just the one block device's IO and reset
that device rather than having to re-negotiate with every device.
 
> Some information I have shared with you which I have already received for novell bugzilla.
> 
> Can you do one experiment? 
> Immediate after this issue do HBA reset using sg_reset and please share result of the experiment.

I can't do that - because I don't usually know about the error immediately.
I could probably have something check dmesg every second and run sg_reset
when it found a new one, but that's pretty complex!

These are production boxes as well.

Is there much point?  It's pretty clear from the debug logs that the driver
is doing at least a bus reset each time, and I'm guessing a host reset when
it does the full re-negotiate of line speeds.

> Which OS version and driver version this issue has been introduce?
> I am interested to know is there any regression from driver point of view?

We're running Linux kernel 2.6.32.9 with one very small patch to add some
SIGKILL debugging (not necessary now, we solved that issue, but I haven't
pulled the patch from our production machines yet).  The issue has certainly
existed in earlier kernels, I'm pretty sure back to the 2.6.27 kernels which
we're still running on some machines that haven't been restarted for a while.

However - it's looking like a firmware upgrade on the drives inside the
unit has solved the issue.

> > My question (if you've read this far!  Thanks) is what's triggering
> > this complete flush of ALL IO to the device, and also triggering a
> > complete SCSI renegotiation the first time it happens (lost in the
> > mists of dmesg now) - not only on this device but on the other unit
> > which is attached to the other channel on the card.

Is there a reason that a timeout on one device is causing a bus or
host reset?  It seems that if the bus reset doesn't unstick it the
host reset is going to be pointless.

The underlying problem seems to be chained timeouts not adding up.  In
particular the RAID controller and disk timeouts weren't matching up.
I'm still harassing the vendor about why this isn't causing anything to
be logged in the THEIR debug logs.  There's no evidence on the RAID unit
that anything has gone wrong until it gets a bus reset.  It logs that.

> > Is this likely to be related to the 127 outstanding items (queue full)
> > there?  I notice sd 1:0:0:0: (sdb) has a full 64 items in the queue as
> > well, which is the maximum queue size according to the code.

Obviously not at all, because later debugging managed to get one that only
had 6 outstanding IO requests.  It looks like the external unit was still
servicing IO requests to all the other RAIDsets just fine - it was the the
30 second wait on one channel that caused the failure.

I also have a suspicion that the way we've configured things (multiple
virtual "volumes" on a single RAIDset) is likely to confuse the queues
on the Linux end.  If the RAIDset is timing out responding to one request
it will cause requests on all the volumes to back up.

Regards,

Bron.
