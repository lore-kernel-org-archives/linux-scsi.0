From: Nathan Bryant <nbryant@optonline.net>
Subject: [PATCH] SCSI midlayer power management
Date: Tue, 10 Aug 2004 19:56:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <411960C3.5090107@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.5.69]:65330 "EHLO
	mta3.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S267831AbUHJX6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 19:58:03 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@steeleye.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, jgarzik@pobox.com


Hi,

This proposed patch implements enough power-management support within 
the SCSI midlayer to get ACPI S3 working on my system. Changes as follows:

* Add generic_scsi_{suspend,resume} methods to scsi.c
* Add suspend and resume callbacks to the scsi_driver structure, and 
implement those callbacks in sd.c
* In sd.c, we call sd_shutdown on suspend, in order to synchronize the 
write-back cache.
* In sd.c, we call sd_rescan from sd_resume in order to ensure that 
drives have spun up and avoid passing not ready errors back to the block 
layer.
* In generic_scsi_suspend, we call scsi_device_quiesce before calling 
the scsi_driver suspend callback. We resume from quiesce state in 
reverse order in generic_scsi_resume.

ACPI S1 and S4/swsusp are untested, but I think there should be no 
regressions with S1. To do S1 properly, we probably need to tell the 
drive to spin down, and I don't know what the SCSI command is for 
that... For S4, the call to scsi_device_quiesce might pose a problem for 
the subsequent state dump to disk. But I'm not sure swsusp ever worked 
for SCSI.

This might help SATA drives, too, but I seem to remember that the SATA 
layer doesn't properly emulate the SYNCHRONIZE_CACHE command.

Comments, anybody? Can this be applied upstream? I think it's a step in 
the right direction.

Applies to scsi-misc-2.6

Nathan
