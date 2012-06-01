From: scameron@beardog.cce.hp.com
Subject: Adding disks that are not ready, format in progress.
Date: Fri, 1 Jun 2012 17:00:48 -0500
Message-ID: <20120601220048.GD14761@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:41320 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933654Ab2FAWAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2012 18:00:49 -0400
Received: from g5t0030.atlanta.hp.com (g5t0030.atlanta.hp.com [16.228.8.142])
	by g6t0187.atlanta.hp.com (Postfix) with ESMTP id D653D28193
	for <linux-scsi@vger.kernel.org>; Fri,  1 Jun 2012 22:00:48 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g5t0030.atlanta.hp.com (Postfix) with ESMTP id 9FDFC141E7
	for <linux-scsi@vger.kernel.org>; Fri,  1 Jun 2012 22:00:48 +0000 (UTC)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scameron@beardog.cce.hp.com


I'm seeing some odd behavior when adding a disk
to the system that is undergoing some low level formatting
operations preventing i/os.  Until the format operation is
complete on this device, it returns a sense key 0x02, ASC: 0x04
ASCQ: 0x04, which I think means NOT READY, FORMAT IN PROGRESS.

I see the kernel hitting the device with this CDB
over and over and over at a rate of about 160Hz.

28 00 00 00 00 00 00 00 80 00 00 00 00 00 00 00

I'm guessing it's trying to read the partition table.

It doesn't back off, but just keeps on trying.

Eventually (after ~20 mins, but maybe longer depending 
on device size) the format on the device completes, and then
the i/o's proceed, the disk is added, and all is happiness.

During all this time, the process which initiated the device
rescan is blocked.

Is what's described above expected behavior?

-- steve

