From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for the 3.11+ merge window
Date: Sun, 15 Sep 2013 13:25:41 -0700
Message-ID: <1379276741.3315.23.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42659 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab3IOUZp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Sep 2013 16:25:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This patch set is a set of driver updates (megaraid_sas, fnic, lpfc,
ufs, hpsa) we also have a couple of bug fixes (sd out of bounds and
ibmvfc error handling) and the first round of esas2r checker fixes and
finally the much anticipated big endian additions for megaraid_sas.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adam Radford (2):
      megaraid_sas: Version and Changelog update
      megaraid_sas: Add High Availability clustering support using shared Logical Disks

Alan Stern (1):
      sd: Fix potential out-of-bounds access

Anton Blanchard (1):
      ibmvscsi: Fix little endian issues

Bradley Grove (6):
      esas2r: Remove null test for stack allocated fw_coredump_buffer
      esas2r: coccinelle - Replace memcpy with struct assignment
      esas2r: smatch - Remove test for impossible condition (uint8 > 255)
      esas2r: smatch - Fix overrun due to sprintf appending NULL
      esas2r: smatch - Fix dereference that occurs prior to check
      esas2r: smatch - Use biwise rather than logical AND for checking if any bit set

Brian King (1):
      ibmvfc: Fix for offlining devices during error recovery

Brian Uchino (1):
      fnic: On system with >1.1TB RAM, VIC fails multipath after boot up

Dave Jones (1):
      aic7xxx: fix swapped arguments in ahc_find_pci_device

Greg Kroah-Hartman (1):
      Allow MPT Fusion SAS 3.0 driver to be built into the kernel

Hiral Patel (1):
      fnic: fnic Driver Tuneables Exposed through CLI

James Smart (18):
      lpfc 8.3.42: Update lpfc version to driver version 8.3.42
      lpfc 8.3.42: Fixed issue of task management commands having a fixed timeout
      lpfc 8.3.42: Fixed inconsistent spin lock usage.
      lpfc 8.3.42: Fix driver's abort loop functionality to skip IOs already getting aborted
      lpfc 8.3.42: Fixed failure to allocate SCSI buffer on PPC64 platform for SLI4 devices
      lpfc 8.3.42: Fix WARN_ON when driver unloads
      lpfc 8.3.42: Avoided making pci bar ioremap call during dual-chute WQ/RQ pci bar selection
      lpfc 8.3.42: Fixed driver iocbq structure's iocb_flag field running out of space
      lpfc 8.3.42: Fix crash on driver load due to cpu affinity logic
      lpfc 8.3.42: Fixed logging format of setting driver sysfs attributes hard to interpret
      lpfc 8.3.42: Fixed back to back RSCNs discovery failure.
      lpfc 8.3.42: Fixed race condition between BSG I/O dispatch and timeout handling
      lpfc 8.3.42: Fixed function mode field defined too small for not recognizing dual-chute mode
      lpfc 8.3.42: Back out data count,(residual fcfi_parm) fix for bad target.
      lpfc 8.3.42: Fixed mailbox memory leak.
      lpfc 8.3.42: Fix random errors using first burst
      lpfc 8.3.42: Fixed not able to log informational messages at early stage of driver init time
      lpfc 8.3.42: Fixed using unsafe linked list macro for walking and deleting linked list

Mike Miller (4):
      hpsa: bump driver version to reflect changes
      hpsa: housekeeping patch for device_id and product arrays
      hpsa: add HP Smart Array Gen8 names
      hpsa: add HP Smart Array Gen9 PCI ID's

Narsimhulu Musini (1):
      fnic: FC stat param seconds_since_last_reset not getting updated

Sesidhar Beddel (2):
      fnic: Kernel panic while running sh/nosh with max lun cfg
      fnic: Hitting BUG_ON(io_req->abts_done) in fnic_rport_exch_reset

Seungwon Jeon (5):
      ufs: configure the attribute for power mode
      ufs: add operation for the uic power mode change
      ufs: add dme configuration primitives
      ufs: fix the setting interrupt aggregation counter
      ufs: find out sense data over scsi status values

Suma Ramars (1):
      fnic: Remove QUEUE_FULL handling code

Sumit.Saxena@lsi.com (1):
      megaraid_sas: addded support for big endian architecture

And the diffstat:

 Documentation/scsi/ChangeLog.megaraid_sas   |  10 +
 drivers/scsi/aic7xxx/aic7xxx_pci.c          |   2 +-
 drivers/scsi/esas2r/esas2r_flash.c          |  11 +-
 drivers/scsi/esas2r/esas2r_init.c           |   8 +-
 drivers/scsi/esas2r/esas2r_ioctl.c          |   2 +-
 drivers/scsi/esas2r/esas2r_vda.c            |   7 +-
 drivers/scsi/fnic/fnic.h                    |   8 +
 drivers/scsi/fnic/fnic_main.c               | 145 +++++++++-
 drivers/scsi/fnic/fnic_scsi.c               | 141 +++++-----
 drivers/scsi/fnic/vnic_scsi.h               |   4 +-
 drivers/scsi/hpsa.c                         |  54 +++-
 drivers/scsi/ibmvscsi/ibmvfc.c              |  15 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            | 154 +++++-----
 drivers/scsi/ibmvscsi/viosrp.h              |  46 +--
 drivers/scsi/lpfc/lpfc.h                    |   1 +
 drivers/scsi/lpfc/lpfc_attr.c               |  19 +-
 drivers/scsi/lpfc/lpfc_bsg.c                |  90 ++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c            |  11 +-
 drivers/scsi/lpfc/lpfc_init.c               |  92 +++---
 drivers/scsi/lpfc/lpfc_scsi.c               |  55 ++--
 drivers/scsi/lpfc/lpfc_sli.c                |  33 +--
 drivers/scsi/lpfc/lpfc_sli.h                |   4 +-
 drivers/scsi/lpfc/lpfc_sli4.h               |   2 +-
 drivers/scsi/lpfc/lpfc_version.h            |   2 +-
 drivers/scsi/megaraid/megaraid_sas.h        | 117 ++++++--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 417 ++++++++++++++++++----------
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 145 +++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 200 ++++++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  31 ++-
 drivers/scsi/mpt3sas/Makefile               |   2 +-
 drivers/scsi/sd.c                           |  11 +-
 drivers/scsi/ufs/ufs.h                      |   1 +
 drivers/scsi/ufs/ufshcd.c                   | 328 ++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h                   |  54 ++++
 drivers/scsi/ufs/ufshci.h                   |  22 +-
 drivers/scsi/ufs/unipro.h                   | 151 ++++++++++
 include/linux/pci_ids.h                     |   1 +
 37 files changed, 1718 insertions(+), 678 deletions(-)
 create mode 100644 drivers/scsi/ufs/unipro.h

James


