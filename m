From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Wed, 09 Apr 2003 16:53:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E948854.10007@rogers.com>
References: <20030325184530.GA1202@beaverton.ibm.com> <1048618939.1790.29.camel@mulgrave> <20030325232920.GB2692@beaverton.ibm.com> <1048779761.1789.21.camel@mulgrave> <20030328173253.A32352@one-eyed-alien.net> <1048948992.21525.1.camel@mulgrave> <20030329125302.A10565@one-eyed-alien.net> <1048974903.21704.313.camel@mulgrave> <20030329141512.B10565@one-eyed-alien.net> <1049041398.21704.1451.camel@mulgrave> <20030330102156.B19226@one-eyed-alien.net>
Reply-To: Luben Tuikov <tluben@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep03-mail.bloor.is.net.cable.rogers.com ([66.185.86.73]:7092
	"EHLO fep03-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S263800AbTDIUmH
	(for <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2003 16:42:07 -0400
In-Reply-To: <20030330102156.B19226@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Matthew Dharm wrote:
> I happen to agree with Oliver on this...
> 
> As I see it, what we need to do is support both user-initiated removal and
> hardware-initiated removal.  Refcounting should get us pretty far along for
> this.
> 
> As I see it, when either usb-storage or the userspace tells SCSI that a
> device is gone/going away, cleanup should begin.  Since everything is
> refcounted, the virtual HBA stays around only long enough for cleanup to
> occur.

A way to unifyingly achieve all this is to have an entry function
which is called when a device is being removed, in each subsystem,
a la xxx_dev_removal(dev);

Case 1: LLDD notification of device removal.
I.e. came from the interconnect (USB, Internet, Fibre) fabric.
These events (should) take place:

--->LLDD/interconnect/transport detects device removal from the fabric,
  --->xxx_dev_removal(dev) ***,
    --->scsi_dev_removal(dev),
      --->block_dev_removal(dev),
        --->sysfs_dev_removal(dev) (??? not sure),
          ---> hotplug, userspace, etc.

It then comes back to the LLDD entry.

*** "xxx" could be one of usb, fc, etc, just as a unifying point.
It may not be necessary, and may just call scsi_dev_removal().

The advantage of this intrastructure is that each function
is directly entrant, and doesn't _have_to_ be called from its
lower level equivalent.

The other advantage is (Case 2):


Case 2: Userspace initiated the removal of the device.

---> Userspace calls into kernel to remove a device,
  ---> kernel finds the device and calls xxx_dev_removal(dev).
    ---> the rest of the chain is as Case 1.

This way we get infrastructure/code reusability.


> If the request comes from userspace, then scripts should have made sure to
> umount/close/sync everything first.  If the device is just yanked, we
> simply don't have that opportunity.
> 
> Regardless of where the request comes from, the kernel needs to be able to
> handle bad user apps -- if nothing else, some app could ignore the message
> from the unplug request (regardless of where it comes from).  If the
> userspace script did everything well, there are no references and
> everything gets cleaned up.


> If some app didn't close a device, the SCSI
> layer can just DID_ERROR all commands in the mid-layer while the LLDD has
> already cleaned-up -- but this is a case that must be handled!

This is true.
 
> Forcing usb-storage to go outside of kernelspace and then back into
> kernelspace is silly and dangerous.  The potential for DoS or other evil is
> just too high.

This is true, and what is needed is only for userspace to be _notified_.

Userspace can get the same effect by using some sort of active polling.
Why should it do so, when the kernel can notify it in a nice way,
and such polling implementation (passive, i.e. intr) is much better
handled in the kernel.

I.e. we need the best of both worlds.

-- 
Luben





