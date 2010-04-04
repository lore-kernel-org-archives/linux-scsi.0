From: Hans de Goede <hdegoede@redhat.com>
Subject: Add US_FL_NO_ULD_ATTACH usb mass storage unusal dev flag ?
Date: Sun, 04 Apr 2010 16:52:47 +0200
Message-ID: <4BB8A7BF.6090908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab0DDOvW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Apr 2010 10:51:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>

Hi All,

First let me introduce the buggy device in question I'm trying to
get to work. I've been putting a lot of work in making cheap picture frames
work with Linux. These are usual keychain models with a 1.1", 1.5", 1.8"
or 2.4" display, using a proprietary USB protocol to put pictures on them.

I've succeeded in getting models with the Appotech ax203 (2 usb-id's), ax206
(1 usb-id) and Sitronix st2205 chips (1 usb id many different models) working,
libgphoto2 svn now has code to upload pictures to these devices.

But there are still some loose ends to tie up wrt to the Appotech devices.
All 3 variants of these devices present themselves as a USB mass storage
attached cdrom. And in all 3 the cdrom emulation is buggy. Although they work
they are showing repeated usb resets, causing delays accessing the device,
related to commands send to the cdrom. I've managed to make the usb resets
largely go away by telling hal to not probe them for media changes (hal-info
patch send upstream).

But one of the variants (usb id 1908:1320) still hits a usb-reset when
drivers/scsi/sr.c does a READ_CAPACITY from get_sector_size(). After the initial
READ_CAPACITY failure and the usb reset, the second READ_CAPACITY succeeds.

This device bug causes a circa 5 second long delay between plugging in the device
and being able to use it. I've been looking at fixing this and the most elegant
solutions seems to be to use the scsi blacklist BLIST_NO_ULD_ATTACH flag. This will
stop the sr driver from connecting at all (which means one cannot access the
windows software on the emulated cdrom under Linux, which I believe is not
any loss).

There are 3 ways to get this flag set:

1) Add these devices to the static blacklist in
    drivers/scsi/scsi_devinfo.c

    Reading the comments there, this does not seem to be something which is
    wanted.

2) Introduce a new US_FL_NO_ULD_ATTACH flag for drivers/usb/storage/unusal_devs.h
    which will set the scsi blacklist flag (I have not checked yet if this
    is possible, but I think it will).

3) Use a udev rule to dynamically add an entry to the blacklist in
    drivers/scsi/scsi_devinfo.c

    Reading the comment in drivers/scsi/scsi_devinfo.c, the maintainers of this
    file want to move the keeping of the blacklist to userspace and this would
    match that.

Note that an alternative solution would be to simply live with the 5 second delay,
with as added bonus that the windows software can be accessed under Linux.

In case it wasn't clear I'm looking for input on how to best handle this. Please keep
me CC-ed as I'm not subscribed to either list.

Regards,

Hans

