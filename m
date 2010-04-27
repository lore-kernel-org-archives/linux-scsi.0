From: Hans de Goede <hdegoede@redhat.com>
Subject: Using get_last_written() in sr.c causes problems with some usb devices
 (bz.kernel.org 9668)
Date: Tue, 27 Apr 2010 11:43:15 +0200
Message-ID: <4BD6B1B3.30707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab0D0Jlz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 05:41:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org
Cc: linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, linux-usb <linux-usb@vger.kernel.org>

Hi Tejun & List,

I've been debugging a problem where Linux would not talk to the *emulated*
cdrom drive on a usb picture frame.

This picture frame comes with internal flash, and presents itself as a
cdrom device, which contains windows software to store photo's into the
internal flash (through the use of proprietary scsi commands).

I've written userspace software (part of libgphoto2) to be able to access
the internal flash under Linux. But sr.c does things to the frame
it does not like which keeps causing usb resets.

After about a day of debugging I've tracked the problem down to the
get_last_written() call done from get_sectorsize() in sr.c, which was
added by this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5915136d4d3954867cced8a2297bddd16caf36a1

Specifically the READ_DISC_INFORMATION scsi command get_last_written()
sends is the problem. If I remove the get_last_written() call from
get_sectorsize() in sr.c, or if I patch the usb-storage driver to
filter out (fail as invalid request) READ_DISC_INFORMATION scsi
commands. The problem with the frame's cdrom emulation goes away,
one can see the windows software and more importantly the continues
usb resets stop.

Notice that after a single READ_DISC_INFORMATION scsi command, the
device is fu-barred, and the usb resets do not really help, the
device continues talking to us, but reports bogus values for
various things (sector size amongst others).

Note the cdrom emulation of the device
indicates it not liking the READ_DISC_INFORMATION by responding
with a Unit Attention sense code, with additional sense values:
3A 00 (medium not present), which is all fsck-ed up.

So the above is the analysis of the problem, now the question is
how to fix this...

The first thing to notice here is that according to MMC3
READ_DISC_INFORMATION is not necessarily implemented by CD-ROM
and DVD-ROM drives, so we may want to check the drive is some sort
of recordable before calling it, not that that will help
in this case as the picture frame claims to be a CD-R <sigh>.

The only thing I can come up with to fix this is a device specific
quirk. Either in sr.c or in ubs-storage. Which is not a very
pretty solution, hence this mail in the hope someone has
a clever idea.

Regards,

Hans
