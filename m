From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv6 0/5] scsi: Fixup blacklist handling
Date: Mon,  2 Oct 2017 16:26:32 +0200
Message-ID: <1506954397-2237-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59165 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751355AbdJBOix (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Oct 2017 10:38:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

the SCSI blacklist handling seems to be rather tricky issue;
everytime a fix is included it tends to break other devices.
This patchset attempt to simplify the devlist handling yet again,
but this time implementing the framework for regression testing, too.
A patch adding a regression test to the blktest suite will follow.

As usual, comments and reviews are welcome.

Changes to v1:
- Implement exact match for vendor string as suggested by Bart
- Straigten out issues pointed out by Alan Stern
- Reshuffle patches

Changes to v2:
- Simplify code as indicated by Alan Stern
- Display blacklist flags verbatim
- Reformat blacklist flags definition for better readability

Changes to v3:
- Add reviews from Alan Stern
- Generate blacklist flag definitions
- Include reviews from Martin Petersen

Changes to v4:
- Add reviews from Bart
- Rework blacklist flag string generation

Changes to v5:
- Add bounds checking for sysfs attribute
- Add review from Doug Gilbert

Hannes Reinecke (5):
  scsi_debug: allow to specify inquiry vendor and model
  scsi: Export blacklist flags to sysfs
  scsi_devinfo: Reformat blacklist flags
  scsi_devinfo: Whitespace fixes
  scsi_devinfo: fixup string compare

 drivers/scsi/Makefile       |  8 +++++
 drivers/scsi/scsi_debug.c   | 25 ++++++++++-----
 drivers/scsi/scsi_devinfo.c | 67 ++++++++++++++++++++-------------------
 drivers/scsi/scsi_scan.c    |  1 +
 drivers/scsi/scsi_sysfs.c   | 37 ++++++++++++++++++++++
 include/scsi/scsi_devinfo.h | 76 +++++++++++++++++++++++++++++----------------
 6 files changed, 148 insertions(+), 66 deletions(-)

-- 
1.8.5.6
