From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Thu, 12 Dec 2013 17:04:31 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312121632470.849-100000@iolanthe.rowland.org>
References: <20131212000715.GA3181@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58698 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751092Ab3LLWEc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2013 17:04:32 -0500
In-Reply-To: <20131212000715.GA3181@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Wed, 11 Dec 2013, Sarah Sharp wrote:

> Hi Hans,
> 
> I've been testing the UAS code you sent a pull request for against
> 3.13-rc1, and I've run into a rather nasty issue with USB disconnect.
> 
> I ran some tests with a USB 3.0 storage device under xHCI.  The disk has
> three 10GB partitions: ext3 (sdb1), ext4 (sdb2), and fat32 (sdb4).
> There was a btrfs partition on sdb3, but I deleted it.
> 
> If I start to play a movie on the ext4 partition, and then yank the USB
> cable, the uas driver is unbound from the device.  It looks like
> something goes wrong in the SCSI layer shortly after that, causing an
> oops in sysfs_remove_group().

I did a little testing.  It turns out this WARN (not an oops) is the 
result of recent changes to sysfs, combined with the peculiar way the 
SCSI layer handles targets.

In the new kernel, when you call device_del for some object, the 
object's directory and everything beneath it get removed from sysfs.  
This wasn't true in the past.

When a USB drive is unplugged, almost everything below it gets
unregistered.  But not the SCSI target -- it remains registered until
the number of "reap references" drops to 0.  This doesn't happen until
all the devices beneath it are released, which happens when all the
open file references are closed and the filesystem is unmounted.

So scsi_target_reap_usercontext ends up calling device_del for the
target after everything else has been removed from sysfs.  As part of
normal device_del processing, attribute groups get removed.  In
particular the power/ subdirectory is removed from the target's sysfs
directory.  But the sysfs directories are long gone by this time, so
sysfs_remove_group complains that it was asked to remove a non-existent
subdirectory.

Given the way things work now, I suspect these warnings are truly 
harmless.  We could simply get rid of the WARN in sysfs_remove_group.

The alternative is to call device_del for SCSI targets earlier on, such 
as when their hosts are unregistered.  I don't know how James would 
feel about this approach.  It would be difficult because targets use 
their own reference counts instead of relying on the usual device 
refcounting mechanism.

Alan Stern

