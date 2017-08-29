From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 0/5] Fixup blacklist handling
Date: Tue, 29 Aug 2017 10:49:19 +0200
Message-ID: <1503996564-110464-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46767 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751667AbdH2Itf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Aug 2017 04:49:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Alan@suse.de, "Stern <stern"@rowland.harvard.edu, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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

Changed to v3:
- Add reviews from Alan Stern
- Generate blacklist flag definitions
- Include reviews from Martin Petersen

Hannes Reinecke (5):
  scsi_debug: allow to specify inquiry vendor and model
  scsi: Export blacklist flags to sysfs
  scsi_devinfo: Reformat blacklist flags
  scsi_devinfo: Whitespace fixes
  scsi_devinfo: fixup string compare

 drivers/scsi/Makefile       |  8 +++++
 drivers/scsi/mktbl.pl       | 26 ++++++++++++++++
 drivers/scsi/scsi_debug.c   | 25 ++++++++++-----
 drivers/scsi/scsi_devinfo.c | 67 ++++++++++++++++++++-------------------
 drivers/scsi/scsi_scan.c    |  1 +
 drivers/scsi/scsi_sysfs.c   | 60 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_devinfo.h | 76 +++++++++++++++++++++++++++++----------------
 7 files changed, 197 insertions(+), 66 deletions(-)
 create mode 100644 drivers/scsi/mktbl.pl

-- 
1.8.5.6
