From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Core scsi layer crashes in 2.6.8.1
Date: Tue, 28 Sep 2004 21:03:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096401785.13936.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:5257 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S268122AbUI2ArE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 20:47:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

I've been doing some stress testing for Fedora Core 3 and lets say the
SCSI layer came apart under stress. 

First problem was a device with 256 byte sector sizes. When it probes I
get a chain of errors. If I then try and mount it then it hangs the
mount forever. If you remove the USB scsi device to try and unjam it you
get errors logged about Invalid State 256 in USB reset and it doesn't
recover.

Second problem is with the scsi handling logic for errors. If you rmmod
a scsi driver while it is error handling you get a chain of errors
starting with

	Illegal transition Cancel->Offline
	Badness is scsi_device_set_state
	path:
	scsi_device_set_state
	scsi_unjam_host
	scsi_error_handler

This is followed by a series of further errors including kobject errors
and oopses. Then the machine dies.

The set up is fairly simple. Its a a disk and two scsi cd multichangers
configured so that I can also badly terminate them. In that situation
identify works but other commands tend to fail which allows good error
stressing.


