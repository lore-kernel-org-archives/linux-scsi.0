From: Mike Christie <michaelc@cs.wisc.edu>
Subject: does sym53c8xx_2 hardware support hotplug
Date: Wed, 23 Apr 2008 15:10:06 -0500
Message-ID: <480F979E.5060302@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57295 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYDWUKO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2008 16:10:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, matthew@wil.cx

Hi,

Does the hardware sym53c8xx_2 works with support removing and adding 
devices?

When using sym53c8xx_2 if we find storage, remove the device using the 
sysfs/proc interface, then physically remove the device, everything goes 
well. However, if we physically plug the disk back in and try to readd 
it through the sysfs/proc scanning interfaces, it looks like 
scsi_scan.c's inquiry will time out. This causes the sym error handler 
to run, which works great and we end up doing a BUS RESET (BDR failed so 
we got escalated), and after that the inqiury is retried and we find the 
device and it works fine.

Is the inquiry timing out expected? Does the hardware even support 
hotplug? Or does it support it partially support it (support it with 
some help), and we are we supposed to be manually resetting the bus, 
with something like a sg_reset, after we have physically plug the disk 
back in?

Thanks for any info,

Mike
