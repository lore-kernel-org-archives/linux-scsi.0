From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2][RESEND] scsi_transport_fc: LUN masking
Date: Mon, 22 Feb 2016 08:51:00 +0100
Message-ID: <1456127462-2817-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbcBVHvV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2016 02:51:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

having been subjected to the pain of trying to bootstrap a really
large machine with systemd I decided to implement LUN masking in
scsi_transport_fc.
The principle is simple: disallow the automated LUN scanning when
discovering a rport, and create udev rules which selectively
enable individual LUNs by echoing the relevant values in the 'scan'
attribute of the SCSI host.
With that I'm able to boot an arbitrary large machine without
running into any udev or systemd imposed timeout.
To _disable_ LUN masking and restoring the original behaviour
I've noticed that the 'scan' sysfs attribute is actually synchronous,
ie the calling process will be blocked until the entire LUN scan
is completed.
So I've added another module parameter 'async_user_scan' to
move the scanning onto the existing scan workqueue, and unblock
the calling process.

As usual, comments and reviews are welcome.

Hannes Reinecke (2):
  scsi_transport_fc: implement 'disable_target_scan' module parameter
  scsi_transport_fc: Implement 'async_user_scan' module parameter

 drivers/scsi/scsi_transport_fc.c | 47 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

-- 
2.6.2

