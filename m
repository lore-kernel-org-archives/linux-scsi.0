From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Wed, 09 Apr 2003 18:59:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E94A5DB.2020007@rogers.com>
References: <20030325100704.GC3868@beaverton.ibm.com> <200303301926.17166.oliver@neukum.org> <3E9482FA.6060504@rogers.com> <200304100032.11400.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep04-mail.bloor.is.net.cable.rogers.com ([66.185.86.74]:49078
	"EHLO fep04-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S263954AbTDIWsG
	(for <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2003 18:48:06 -0400
In-Reply-To: <200304100032.11400.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: oliver@neukum.name
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-hotplug-devel@lists.sourceforge.net, Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
> 
> Please explain yourself further. We cannot deal with wait sometimes.

No need to -- we agree.

> Either we may wait or we may not wait. If we may wait,
> we must always deal with it like we will wait and deal with results,
> which is impossible, as the only result we can deal with is success.
> 
> Notification is absolutely no problem. _Requiring_ the kernel
> to wait for user space to act so that the process of removal
> can be completed as far as the the low level driver is concerned
> is a major problem.

No, a LLDD will not be required to wait on userspace.  No one wants
this and the fault in this is quite evident that no one would want it.

The only point is notification, and we seem to agree on this.
 
> All is well if a low level driver can consider a device gone for good
> as soon as "/sbin/hotplug" is spawned. The key here is spawned
> , not doing something or finish, but spawned.

Ideally:

You can assume even better than that: as soon as your interconnect
tells you that the device is gone, a LLDD (== transport portal) does this:
---> calls xxx_dev_removal(dev) (marks device as gone in this subsystem),
(and which in turn:
  ---> calls scsi_device_removal(dev) (mark dev as gone in this subsys),
    ... (see my other posting))
(none of which blocks, more work/discussion is needed here, but this is
different topic)

and then the LLDD can free *its* resources which it allocated on the
device.

*But*, the _important__point_ is that the LLDD must be able to handle
requests (queuecommand()) to non-existant (== just removed) devices,
and not oops, or whatever.

So, in effect, you just call usb_dev_removal(dev) (to be written),
and free _your_ resources on the device. (note important point above)

> We have indeed discussed this before and the need to notify
> user space was never questioned, as far as I recall.
> The point of contention always was whether the notification
> had to do specific things for the process of unplugging to finish
> as far as it concerns the low level driver.

Right.  As far as I can see, those subsystem entries, xxx_dev_removal(dev),
would do things which do not block, like flip a bit, flags, integer,
wake up a thread, etc, call the above subsystem's xxx_dev_removal(dev),
and return immediately. (as per my other posting)
(this needs more thinking though)

-- 
Luben


