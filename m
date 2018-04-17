From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 0/6] scsi: handle special return codes for ABORTED COMMAND
Date: Wed, 18 Apr 2018 01:35:05 +0200
Message-ID: <20180417233511.6573-1-mwilck@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Here is another attempt to handle the special return codes for ABORTED COMMAND
for certain SCSI devices. Following MKP's recommendation, I've created two
new BLIST flags, simplifying the code in scsi_error.c compared to the previous
versions. Rather than using "free" bits, I increased the length of
blist_flag_t to 64 bit, and used previously unused bits. I also added checking
for obsolete and unused bits.

For the blist_flag_t size increase, I used sparse to try and avoid regressions;
that necessitated fixing sparse's errors for the current code first.

Martin Wilck (6):
  ilog2: create truly constant version for sparse
  scsi: use const_ilog2 for array indices
  scsi: devinfo: change blist_flag_t to 64bit
  scsi: devinfo: warn on undefined blist flags
  scsi: devinfo: add BLIST_RETRY_ITF for EMC Symmetrix
  scsi: devinfo: BLIST_RETRY_ASC_C1 for Fujitsu ETERNUS

 drivers/scsi/Makefile       |  2 +-
 drivers/scsi/scsi_debugfs.c |  2 +-
 drivers/scsi/scsi_devinfo.c | 28 +++++++++++++----
 drivers/scsi/scsi_error.c   |  7 +++++
 drivers/scsi/scsi_sysfs.c   |  2 +-
 include/linux/log2.h        | 35 ++++++++++++++-------
 include/scsi/scsi_device.h  |  2 +-
 include/scsi/scsi_devinfo.h | 75 ++++++++++++++++++++++++++++++---------------
 8 files changed, 107 insertions(+), 46 deletions(-)

-- 
2.16.1
