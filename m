From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Thu, 10 Apr 2003 00:32:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200304100032.11400.oliver@neukum.org>
References: <20030325100704.GC3868@beaverton.ibm.com> <200303301926.17166.oliver@neukum.org> <3E9482FA.6060504@rogers.com>
Reply-To: oliver@neukum.name
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.KONTENT.De ([81.88.34.36]:60899 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S263947AbTDIWUg (for <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2003 18:20:36 -0400
In-Reply-To: <3E9482FA.6060504@rogers.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: tluben@rogers.com
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-hotplug-devel@lists.sourceforge.net, Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>


> > No this is exactly the way not to ever think about this.
> > You are not asked to remove a device, you are informed it's gone.
> > This is the case in all but sometimes one type of bus system in the
> > kernel. And that is the way information has to flow. Strictly
> > from the driver closest to the hardware up.
>
> This is correct.

Good.

> > And there must be no
> > undue delay and neither failure. Failure to handle a removal is a
> > contradiction in terms. This means that any call to user space must not
> > be waited for in the kernel and failure must not be deadly. Filesystems
> > must already be ready to deal with incorrectible errors. They are not
> > your problem.
>
> We've discussed this before.
>
> Userspace must be _notified_.  Note the choice of verb.  This doesn't
> *necessarily* mean that the kernel will wait on userspace to finish
> some action, but it may, but *not* necessarily -- this is to the
> discrection of the hotplug system working together with the kernel -- ``to
> each it's own''. I.e. for some hotplug events there maybe a userspace event
> involved and for others it may not.

Please explain yourself further. We cannot deal with wait sometimes.
Either we may wait or we may not wait. If we may wait,
we must always deal with it like we will wait and deal with results,
which is impossible, as the only result we can deal with is success.

Notification is absolutely no problem. _Requiring_ the kernel
to wait for user space to act so that the process of removal
can be completed as far as the the low level driver is concerned
is a major problem.

All is well if a low level driver can consider a device gone for good
as soon as "/sbin/hotplug" is spawned. The key here is spawned
, not doing something or finish, but spawned.

We have indeed discussed this before and the need to notify
user space was never questioned, as far as I recall.
The point of contention always was whether the notification
had to do specific things for the process of unplugging to finish
as far as it concerns the low level driver.

> There are several reasons for this, one of which is that the system
> administrator may want to know about the removal of a device.  So why
> should userspace do some kind of polling, when the kernel can simply
> _notify_ userspace.

Oh absolutely, sure.

> As to usb, you can fail all commands in due time, notify
> the subsystem above you (which will take over) and free your
> resources, and leave others to be freed by the subsystem above
> you which it registered. (ideally)

That is what we hope for.

	Regards
		Oliver

