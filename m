From: Dan Hollis <goemon@anime.net>
Subject: how to prevent device hotplugging from incrementing scsi bus number?
Date: Wed, 26 Jan 2005 15:24:50 -0800 (PST)
Message-ID: <Pine.LNX.4.44.0501261524350.4292-100000@sasami.anime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sasami.anime.net ([207.109.251.120]:60032 "EHLO
	sasami.anime.net") by vger.kernel.org with ESMTP id S262501AbVAZXYy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jan 2005 18:24:54 -0500
Received: from localhost (goemon@localhost)
	by sasami.anime.net (8.11.6/8.11.6) with ESMTP id j0QNOoD05088
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jan 2005 15:24:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>

*** please cc: replies in email as i'm not subscribed to the list. ***

I'm using usb and 1394 to hotplug various devices (dvd-rw, drives, etc).
kernel 2.6.9.

To unplug, I use the procedure:
unmount device (if it's mounted)
sync
echo "scsi remove-single-device <busnumber> 0 0 0" > /proc/scsi/scsi

then i cat /proc/scsi/scsi to make sure its gone, then i unplug the 
device.

problem is, every time i replug the same device back in, it increments the 
scsi bus number. eventually it ends up going over bus number 16, so that 
eg dvdrecord/etc can no longer talk to the drive.

is there a way to tell the scsi drivers to reuse unused scsi bus numbers, 
rather than always incrementing?

i've tried unloading all the scsi and firewire/usb drivers and reloading 
them and it doesn't seem to help.

-Dan

