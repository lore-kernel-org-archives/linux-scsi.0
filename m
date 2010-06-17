From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH resend 0/2] sr / usb-storage Add new no_read_disc_info quirk
Date: Thu, 17 Jun 2010 12:20:44 +0200
Message-ID: <1276770046-18868-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.versatel.nl ([62.58.50.96]:36348 "EHLO smtp5.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab0FQKS2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 06:18:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org


Hi All,

Some USB devices emulate a usb-mass-storage attached (scsi) cdrom device,
usually this fake cdrom contains the windows software for the device.
While working on supporting Appotech ax3003 based photoframes, which do
this I discovered that they will go of into lala land when ever they
see a READ_DISC_INFO scsi command.

I discussed this with Tejun (who did the commit which causes the cdrom
driver to always do the READ_DISC_INFO), and he said the best fix for
this would be using a device specific quirk.

So about a month ago I send a patch which added a new usb-storage quirk
for this and based on this quirk filtered out the READ_DISC_INFO scsi
cmd at the usb-storage level. Alan rightfully said this filtering
should be done at a higher level. So I wrote a 2 patch patchset adding
a scsi_dev flag for this, and doing the filtering in sr.c .

This is a resend of said patch set which I send to the linux-scsi and
linux-usb lists a month ago, which so far has gotten no response. I
hope that one of you has the time to review it.

Thanks & Regards,

Hans
