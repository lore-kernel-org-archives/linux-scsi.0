From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 4.0+ merge window
Date: Thu, 16 Apr 2015 10:34:37 -0700
Message-ID: <1429205677.2196.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56910 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbbDPRej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2015 13:34:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the usual grab bag of driver updates (lpfc, qla2xxx, storvsc,
aacraid, ipr) plus an assortment of minor updates.  There's also a major
update to aic1542 which moves the driver into this millenium.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The Short Changelog is

Andrew Vasquez (1):
      qla2xxx: Add serdes read/write support for ISP27XX

Brian King (5):
      ipr: Driver version 2.6.1
      ipr: Re-enable write same
      ipr: Fix possible error path oops during initialization
      ipr: Reset in task context
      ipr: Reboot speed improvements

Chad Dupuis (1):
      qla2xxx: Increase the wait time for firmware to be ready for P3P.

Christoph Hellwig (3):
      scsi: proper state checking and module refcount handling in scsi_device_get
      sd: don't grab a device references from driver methods
      scsi: serialize ->rescan against ->remove

Geert Uytterhoeven (1):
      g_NCR5380: Kill compiler warning if builtin

Himanshu Madhani (8):
      qla2xxx: Update driver version to 8.07.00.18-k
      qla2xxx: Prevent multiple firmware dump collection for ISP27XX.
      qla2xxx: Disable Interrupt handshake for ISP27XX.
      qla2xxx: Add debugging info for MBX timeout.
      qla2xxx: Add udev notification to save fw dump for ISP27XX
      qla2xxx: Add message for sucessful FW dump collected for ISP27XX.
      qla2xxx: Fix crash due to wrong casting of reg for ISP27XX.
      qla2xxx: Fix warnings reported by static checker.

James Bottomley (2):
      change SCSI Maintainer email
      sd, mmc, virtio_blk, string_helpers: fix block size units

James Smart (21):
      lpfc: Update version to 10.5.0.0 for upstream patch set
      lpfc: Update copyright to 2015
      lpfc: Fix for lun discovery issue with saturn adapter.
      lpfc: Fix crash in device reset handler.
      lpfc: Fix OS crash when running loopback test in applications
      lpfc: Fix internal loopback failure.
      lpfc: Fix premature release of rpi bit in bitmask
      lpfc: Initiator sends wrong BBCredit value for either FLOGI or FLOGI_ACC
      lpfc: Fix null ndlp dereference in target_reset_handler
      lpfc: Fix FDMI Fabric support in driver for Brocade
      lpfc: Fix provide host name and OS name in RSNN-NN FC-GS command
      lpfc: Parse the new 20G, 25G and 40G link speeds in the lpfc driver
      lpfc: Add support for reporting option_rom_version on newer adapters
      lpfc: Fix setting of EQ (interrupt) delay Multiplier
      lpfc: Fix host reset escalation killing all IOs.
      lpfc: Linux lpfc driver doesn't re-establish the link after a cable pull on LPe12002
      lpfc: Fix to handle PLOGI when already logged in
      lpfc: Add new mbx cmd recognition
      lpfc: Add Lancer Temperature Event support to the lpfc driver
      lpfc: Fix the iteration count to match the 30 sec comment in the routine lpfc_pci_function_reset
      scsi_transport_fc: Add support for 25Gbit speed

K. Y. Srinivasan (7):
      scsi: storvsc: Set the tablesize based on the information given by the host
      scsi: storvsc: Don't assume that the scatterlist is not chained
      scsi: storvsc: Fix a bug in copy_from_bounce_buffer()
      scsi: storvsc: Retrieve information about the capability of the target
      scsi: storvsc: Always send on the selected outgoing channel
      scsi: storvsc: Size the queue depth based on the ringbuffer size
      scsi: storvsc: Increase the ring buffer size

Mahesh Rajashekhara (11):
      aacraid: driver version change
      aacraid: AIF raw device remove support
      aacraid: performance improvement changes
      aacraid: IOCTL fix
      aacraid: IOP RESET command handling changes
      aacraid: 240 simple volume support
      aacraid: vpd page code 0x83 support
      aacraid: MSI-x support
      aacraid: 4KB sector support
      aacraid: IOCTL pass-through command fix
      aacraid: AIF support for SES device add/remove

Michael Opdenacker (1):
      aic7xxx: replace kmalloc/memset by kzalloc

Nicholas Mc Guire (1):
      ncr5380: Harmonize jiffies conversion with msecs_to_jiffies

Nigel Kirkland (1):
      qla2xxx: Fix beacon blink for ISP27XX.

Ondrej Zary (36):
      aha1542: remove loop from aha1542_outb
      aha1542: Fix bus reset
      aha1542: rework locking
      aha1542: Don't reduce functionality with DEBUG enabled
      aha1542: Use print_hex_dump_bytes in debug code
      aha1542: remove DEB macro and simplify debug code
      aha1542: Use shost_printk instead of printk
      aha1542: Change aha1542_set_bus_times parameters
      aha1542: Pass struct Scsi_Host * to functions
      aha1542: cleanup includes
      aha1542: remove useless changelog
      aha1542: fix include guard and remove useless changelog
      aha1542: Always name Scsi_Host variables sh
      aha1524: Use struct scsi_cmnd
      aha1542: clean up cmd variables
      aha1542: Simplify aha1542_biosparam
      aha1542: rework configuration parameters
      aha1542: rework hw_init
      aha1542: Call wait_mask from aha1542_out
      aha1542: split out code from aha1542_hw_init
      aha1542: Merge aha1542_host_reset and aha1542_bus_reset
      aha1542: Remove aha1542_restart
      aha1542: remove useless code from aha1542_test_port
      aha1542: Remove unneeded gotos
      aha1542: Split aha1542_out
      aha1542: Unify aha1542_in and aha1542_in1
      aha1542: Remove WAIT and WAITd macros
      aha1542: Use BIT() macro
      aha1542: remove empty aha1542_stat
      aha1542: Reorder functions to remove forward declarations
      aha1542: Use u8 instead of unchar
      aha1542: Convert aha1542_intr_reset to function
      aha1542: Remove HOSTDATA macro
      aha1542: Remove SCSI_BUF_PA, SCSI_SG_PA, AHA1542_SCATTER and AHA1542_CMDLUN
      aha1542: remove dead code
      aha1542: Stop using scsi_module.c

Sawan Chandak (3):
      qla2xxx: Restore physical port WWPN only, when port down detected for FA-WWPN port.
      qla2xxx: Fix virtual port configuration, when switch port is disabled/enabled.
      qla2xxx: Add support to load firmware from file for ISP 26XX/27XX.

Wen Xiong (1):
      ipr: AF DASD raw mode implementation in ipr driver

Wolfram Sang (1):
      ncr5380: Drop owner assignment from platform_drivers

Yaniv Gardi (2):
      ufs: add support to allow non standard behaviours (quirks)
      ufs-qcom: save controller revision info in internal structure

And the diffstat:

 MAINTAINERS                         |    6 +-
 drivers/block/virtio_blk.c          |    9 +-
 drivers/mmc/card/block.c            |    4 +-
 drivers/scsi/NCR5380.c              |   10 +-
 drivers/scsi/aacraid/aachba.c       |  410 +++++++--
 drivers/scsi/aacraid/aacraid.h      |  106 ++-
 drivers/scsi/aacraid/commctrl.c     |   10 +-
 drivers/scsi/aacraid/comminit.c     |  106 ++-
 drivers/scsi/aacraid/commsup.c      |   96 +-
 drivers/scsi/aacraid/dpcsup.c       |   13 +-
 drivers/scsi/aacraid/linit.c        |   61 +-
 drivers/scsi/aacraid/rx.c           |   14 +-
 drivers/scsi/aacraid/src.c          |  438 ++++++---
 drivers/scsi/aha1542.c              | 1687 +++++++++++------------------------
 drivers/scsi/aha1542.h              |  136 +--
 drivers/scsi/aic7xxx/aic79xx_core.c |    3 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c  |    3 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c |   10 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c  |    3 +-
 drivers/scsi/atari_NCR5380.c        |    2 +-
 drivers/scsi/atari_scsi.c           |    1 -
 drivers/scsi/g_NCR5380.c            |    8 +-
 drivers/scsi/ipr.c                  |  319 ++++++-
 drivers/scsi/ipr.h                  |   15 +-
 drivers/scsi/lpfc/lpfc.h            |    5 +-
 drivers/scsi/lpfc/lpfc_attr.c       |   25 +-
 drivers/scsi/lpfc/lpfc_bsg.c        |    4 +-
 drivers/scsi/lpfc/lpfc_bsg.h        |    3 +-
 drivers/scsi/lpfc/lpfc_crtn.h       |    4 +-
 drivers/scsi/lpfc/lpfc_ct.c         |  738 +++++++++++----
 drivers/scsi/lpfc/lpfc_debugfs.c    |    2 +-
 drivers/scsi/lpfc/lpfc_els.c        |   19 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c    |   74 +-
 drivers/scsi/lpfc/lpfc_hw.h         |  208 ++---
 drivers/scsi/lpfc/lpfc_hw4.h        |    8 +-
 drivers/scsi/lpfc/lpfc_init.c       |  264 ++++--
 drivers/scsi/lpfc/lpfc_mbox.c       |    2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c  |   29 +-
 drivers/scsi/lpfc/lpfc_scsi.c       |   83 +-
 drivers/scsi/lpfc/lpfc_scsi.h       |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c        |   72 +-
 drivers/scsi/lpfc/lpfc_sli.h        |    3 +-
 drivers/scsi/lpfc/lpfc_sli4.h       |    4 +-
 drivers/scsi/lpfc/lpfc_version.h    |    6 +-
 drivers/scsi/mac_scsi.c             |    1 -
 drivers/scsi/qla2xxx/Kconfig        |    3 +
 drivers/scsi/qla2xxx/qla_dbg.c      |    6 +-
 drivers/scsi/qla2xxx/qla_def.h      |   16 +-
 drivers/scsi/qla2xxx/qla_init.c     |   75 +-
 drivers/scsi/qla2xxx/qla_isr.c      |   17 +-
 drivers/scsi/qla2xxx/qla_mbx.c      |   31 +-
 drivers/scsi/qla2xxx/qla_mid.c      |   22 +-
 drivers/scsi/qla2xxx/qla_os.c       |    3 +
 drivers/scsi/qla2xxx/qla_sup.c      |   11 +-
 drivers/scsi/qla2xxx/qla_tmpl.c     |   15 +-
 drivers/scsi/qla2xxx/qla_version.h  |    2 +-
 drivers/scsi/scsi.c                 |   20 +-
 drivers/scsi/scsi_scan.c            |    7 +-
 drivers/scsi/scsi_transport_fc.c    |    1 +
 drivers/scsi/sd.c                   |   63 +-
 drivers/scsi/storvsc_drv.c          |  232 +++--
 drivers/scsi/sun3_scsi.c            |    1 -
 drivers/scsi/ufs/ufs-qcom.c         |   36 +-
 drivers/scsi/ufs/ufs-qcom.h         |   26 +
 drivers/scsi/ufs/ufshcd.c           |   35 +
 drivers/scsi/ufs/ufshcd.h           |    9 +
 include/linux/string_helpers.h      |    2 +-
 include/scsi/scsi_transport_fc.h    |    1 +
 lib/string_helpers.c                |   68 +-
 69 files changed, 3509 insertions(+), 2219 deletions(-)

James


