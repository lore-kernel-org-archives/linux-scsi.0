From: torvalds@transmeta.com (Linus Torvalds)
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 16 Jan 2003 20:10:18 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <b073ja$12i$1@penguin.transmeta.com>
References: <10426732153816@kroah.com> <20030116173539.GA31235@kroah.com> <20030116114323.C29001@one-eyed-alien.net> <20030116195306.GA32697@kroah.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by neon-gw.transmeta.com (8.9.3/8.9.3) id MAA16759
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2003 12:10:54 -0800
Received: from palladium.transmeta.com (palladium.transmeta.com [10.1.1.46])
	by deepthought.transmeta.com (8.11.6/8.11.6) with ESMTP id h0GKAa327948
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2003 12:10:36 -0800 (PST)
Received: (from mail@localhost)
	by palladium.transmeta.com (8.9.3/8.9.3) id MAA02257
	for linux-scsi@vger.kernel.org; Thu, 16 Jan 2003 12:10:36 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In article <20030116195306.GA32697@kroah.com>, Greg KH  <greg@kroah.com> wrote:
>On Thu, Jan 16, 2003 at 11:43:23AM -0800, Matthew Dharm wrote:
>> Well, we only create the host when the device is first attached.  After
>> that, if it goes away and comes back, we re-connect it to the old SCSI
>> host.
>
>Ick, so when the device is gone, where does the SCSI host go?  Is it
>still represented in sysfs and in the SCSI core properly?

This is pure and utter USB storage stupidity, and nothing else.

When the USB storage device is unplugged, the device should be
unregistered.  It should be _gone_.  It isn't sleeping, it's dead.  It's
an ex-device. 

The fact that USB storage still keeps track of devices that do not exist
is WRONG. It has resulted in problems in real life multiple times with
devices that get re-attached and have a new serial number (quite common
as far as I can tell in cheap flash readers), where the _stupid_ rule of
trying to keep track of what has been attached results in the device
moving from /dev/sda to sdb to sdc as it is unplugged and re-plugged.

>> Something like this would proabably make sense if the hot-unplugging code
>> for SCSI hosts was really stable -- then we could unregister the host when
>> the device went away, and this relation would be disconnected
>> automatically.
>
>Well, push back on the SCSI people to fix this then, hot-unplug should
>work properly on the SCSI layer too :)

IT IS NOT A SCSI LAYER PROBLEM! It's purely a USB problem.

		Linus
