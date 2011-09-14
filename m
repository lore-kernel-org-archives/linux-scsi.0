From: "Sampathkumar, Kishore" <Kishore.SampathKumar@lsi.com>
Subject: question on hot plug removal and addition of a USB disk
Date: Wed, 14 Sep 2011 19:47:01 +0530
Message-ID: <E4D7778E36CF944ABD2F7E18D2DB96660CA26D8EC0@inbmail02.lsi.com>
References: <S932680Ab1INNeE/20110914133404Z+1759@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:59289 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828Ab1INORK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2011 10:17:10 -0400
In-Reply-To: <S932680Ab1INNeE/20110914133404Z+1759@vger.kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Scenario: I have a file system on a USB SCSI disk /dev/sdb mounted on /mnt.
I perform Action 1 below, and after some time, perform Action 2 below.

Action 1: removal (unplug) of a USB disk

At the time of removal of the USB disk, since the file system was mounted, is the reference to kobject corresponding (now orphaned) sdb still maintained in the kernel, although /dev/sdb is gone due to disk removal?

Is it that the old scsi_disk (sdb) still persists, but, the underlying scsi_dev is removed? Where should I start to trace the hotplug removal of the USB disk? What are the specific processing steps involved in the kernel to handle this (in terms of main routines handling this)?

Action 2: (hot) plug addition of the same USB SCSI disk

On plugging in the same USB SCSI disk, does the sd layer in scsi subsystem grab the first available 'free' sdX device (say sdp), given that sdb is still being referenced by the mounted file system?

Again, in terms of code, does this correspond to:
-	a new scsi_dev being allocated
-	a corresponding scsi_disk for sdp being allocated by the sd layer in scsi subsystem as part of 'probe' for the added SCSI device

Does the hot plugging work the same way for SAS disks attached behind a FC switch?

Thanks,
-	Kishore
