From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Wed, 09 Apr 2003 16:30:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E9482FA.6060504@rogers.com>
References: <20030325100704.GC3868@beaverton.ibm.com> <20030329141512.B10565@one-eyed-alien.net> <1049041398.21704.1451.camel@mulgrave> <200303301926.17166.oliver@neukum.org>
Reply-To: tluben@rogers.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:54903
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S263710AbTDIUTV
	(for <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2003 16:19:21 -0400
In-Reply-To: <200303301926.17166.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: oliver@neukum.name
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-hotplug-devel@lists.sourceforge.net, Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
>>The way to think about this, I think, is "what would we do if the user
>>asked nicely before removing the device" (i.e. requested device ejection
>>rather than forced it).  Then the above makes perfect sense because we
>>have to start at the top and move down.  Since requested ejection is the
>>model for things like hotplug PCI busses, I'm hoping someone else is
>>thinking about this.
> 
> 
> No this is exactly the way not to ever think about this.
> You are not asked to remove a device, you are informed it's gone.
> This is the case in all but sometimes one type of bus system in the
> kernel. And that is the way information has to flow. Strictly
> from the driver closest to the hardware up.

This is correct.

> And there must be no
> undue delay and neither failure. Failure to handle a removal is a
> contradiction in terms. This means that any call to user space must not be
> waited for in the kernel and failure must not be deadly. Filesystems
> must already be ready to deal with incorrectible errors. They are not
> your problem.

We've discussed this before.

Userspace must be _notified_.  Note the choice of verb.  This doesn't
*necessarily* mean that the kernel will wait on userspace to finish
some action, but it may, but *not* necessarily -- this is to the discrection
of the hotplug system working together with the kernel -- ``to each it's own''.
I.e. for some hotplug events there maybe a userspace event involved
and for others it may not.

There are several reasons for this, one of which is that the system
administrator may want to know about the removal of a device.  So why
should userspace do some kind of polling, when the kernel can simply
_notify_ userspace.

As to usb, you can fail all commands in due time, notify
the subsystem above you (which will take over) and free your
resources, and leave others to be freed by the subsystem above
you which it registered. (ideally)

-- 
Luben
P.S. We've all discussed this before, same set of ppl, same set of mailing
lists.






