From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: UAS hangs khubd on USB disconnect
Date: Thu, 12 Dec 2013 14:13:21 +0100
Message-ID: <52A9B671.8090004@redhat.com>
References: <20131212000715.GA3181@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab3LLNN1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Dec 2013 08:13:27 -0500
In-Reply-To: <20131212000715.GA3181@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

Hi,

On 12/12/2013 01:07 AM, Sarah Sharp wrote:
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
>
> If I plug in the device again, the uas driver loads and sdb is
> recognized, but the partitions aren't mounted.  If I disconnect the
> device, the USB core hub thread (khubd) tries to unbind the interface,
> and the uas driver's disconnect function hangs.  At that point, USB
> device hotplug on any ports (including EHCI ports) are not recognized,
> because khub is hung.  Submitting and completing URBs still work, since
> that doesn't involve khubd.
>
> The end result is that disconnecting the UAS device causes USB hotplug
> to be lost on unrelated ports, while other USB devices that were
> attached at the time of the disconnect still work.
>
> I can reproduce this behavior when the UAS device is attached to the
> EHCI port only, so it's not an xHCI specific bug.
>
> If I use the "no UAS" quirk to make the usb-storage driver bind to the
> device, I can trigger the oops from the SCSI layer, but the partitions
> are always mounted and khubd doesn't hang.

Hmm, interesting I myself have experienced a similar bug during testing,
see: http://www.spinics.net/lists/linux-scsi/msg70002.html

On which I've not received any useful reply myself yet.

It seems that the scsi subsys and/or sd driver has some issues with
not tearing things down in the proper order when a disk is in use
while the scsi-host it is attached to gets removed.

As you can see in the reproduction instructions in my mail, the BUG
does not happen until I cd out of the mountpoint, at which point
the kernel tries to clean things up, and the clean up at that
point happens in a different order then it happens when unplugging
the disk while the mountpoint is not busy.

Regards,

Hans
