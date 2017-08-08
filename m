From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] Fixup blacklist handling
Date: Tue,  8 Aug 2017 16:36:53 +0200
Message-ID: <1502203017-101403-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60634 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752527AbdHHOhE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 10:37:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>

Hi all,

the SCSI blacklist handling seems to be rather tricky issue;
everytime a fix is included it tends to break other devices.
This patchset attempt to simplify the devlist handling yet again,
but this time implementing the framework for regression testing, too.
So with this patchset we can implement a regression testing in
blocktests and validate any future fixes.

To implement blocktests one simply has to do:

modprobe scsi_debug inq_vendor="Inateck" inq_product="        "
cat /sys/block/sdX/device/blacklist

(which recreates the issue triggering commit b704f70ce2003)
and check if the blacklist value is correct.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  scsi: whitespace fixes in scsi_devinfo.c
  scsi_devinfo: fixup string compare
  scsi_debug: allow to specify inquiry vendor and model
  scsi: Export blacklist flags to sysfs

 drivers/scsi/scsi_debug.c   | 25 +++++++++++------
 drivers/scsi/scsi_devinfo.c | 68 +++++++++++++++++++++++++--------------------
 drivers/scsi/scsi_scan.c    |  1 +
 drivers/scsi/scsi_sysfs.c   | 11 ++++++++
 4 files changed, 67 insertions(+), 38 deletions(-)

-- 
1.8.5.6
