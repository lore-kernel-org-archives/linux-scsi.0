From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 00/10]  mpt3sas driver Enhancements and
Date: Thu, 20 Oct 2016 17:50:08 +0530
Message-ID: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Here is the change list:
Posting 10 patches for mpt3sas driver enhancements and few fixes.
  * Added Device ID's for SAS35 devices and updated MPI Header.
  * Support "EEDP Escape flag" for SAS35 devices.
  * fixed improper printk statement.
  * Regardless of whether RDPQ disabled card is enumerated
    first or RDPQ enabled card is enumerated first, MSIX vectors
    depends on the cards capability.
  * device_remove_in_progress bit check has been added in IOCTL path. If
    bit is set, then IOCTL will be failed printing failure message.
  * Started using the Atomic Request Descriptors for
    SAS35 devices.
  * For SAS35 devices MSIX vectors are inceased to 128 from 96.
  * Fixing Endianness issue.
  * Updated driver version to 14.100.00.00

Suganath Prabu S (10):
  mpt3sas: Fix for improper info displayed in var log,      while
    blocking or  unblocking the device.
  mpt3sas: Fix for incorrect numbers for MSIX vectors      enabled when 
    non RDPQ card is enumerated first.
  mpt3sas: Implement device_remove_in_progress check in      IOCTL path
  mpt3sas: Removing unused macro "MPT_DEVICE_TLR_ON"
  mpt3sas: Bump driver version as "14.100.00.00"
  mpt3sas: Added Device ID's for SAS35 devices and      updated MPI
    header.
  mpt3sas: Increased/Additional MSIX support for SAS35      devices.
  mpt3sas: set EEDP-escape-flags for SAS35 devices.
  mpt3sas: Use the new MPI 2.6 32-bit Atomic Request      Descriptors
    for SAS35 devices.
  mpt3sas: Fix for Endianness issue.

 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     |   7 ++
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 186 ++++++++++++++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  37 +++---
 drivers/scsi/mpt3sas/mpt3sas_config.c    |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  69 +++++++++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.h       |   1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 113 +++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_transport.c |   8 +-
 8 files changed, 333 insertions(+), 90 deletions(-)

Thanks,
Suganath prabu S 
-- 
1.8.3.1
