From: Erik Andersen <andersen@codepoet.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 14:37:49 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014203749.GA24904@codepoet.org>
References: <andersen@codepoet.org> <20021014054035.GA10686@codepoet.org> <200210141557.g9EFvLw02517@localhost.localdomain>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210141557.g9EFvLw02517@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Mon Oct 14, 2002 at 08:57:21AM -0700, James Bottomley wrote:
> andersen@codepoet.org said:
> > Anyone have any objections to such a patch?  For 2.4.x?  Comments?
> 
> The patch looks fine per se.
> 
> However, I thought that the whole spirit of hotplug was that this type of 
> problem should be solved in user space to which SCSI currently exposes a 
> perfectly adequate interface.

If the user space interface were perfectly adequate, I would not
have written this patch.  User space does not have sufficient
information to know _which_ devices must to be added or removed.
The best we can do from user space is a full rescan of _all_ scsi
host adaptors (http://www.garloff.de/kurt/linux/rescan-scsi-bus.sh) 
using something like
    echo "scsi remove-single-device 0 0 0 0" > /proc/scsi/scsi
    echo "scsi add-single-device 0 0 0 0" > /proc/scsi/scsi
for each and every SCSI device on your system.

That works just fine if all you are doing is (unwisely) powering
up a SCSI tape drive that is already connected to your Adaptec
29160.  If you have a firewire RAID array system (like I do) and
you are hotswapping drive 3 of the RAID array, you really don't
want to disconnect and reconnect each and every device.

> Needing kernel hooks in a different subsystem to solve a hotplug problem looks 
> slightly wrong to me.  Usually when this type of thing comes up its because 
> we're missing a hotplug event (or a hotplug event doesn't carry the right 
> information).  Could you elaborate more on the actual problem you're trying to 
> solve?

A detailed description of the sbp2 problem is here: 
    http://sourceforge.net/mailarchive/forum.php?thread_id=1151203&forum_id=5389

The executive summary:  Without this patch (and another patch I
posted to the linux-1394 mailing list to make sbp2.c to use this
scsi hotplug patch), hotplugging firewire drives will register
the drives with the 1394 layer, but will not register the drives
with the SCSI subsystem.  Unplugging firewire drives leaves the
(now absent) drives still registered with the SCSI subsystem.
This makes _very_ bad things happed to my RAID array when I
hotswap drives.

This patch allows SBP-2 devices to properly hook into and unhook
themselves from the SCSI subsystem when hotplugged.

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
