From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI updates for 2.6.21
Date: Mon, 30 Apr 2007 11:12:28 -0500
Message-ID: <1177949549.3674.29.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34472 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423743AbXD3QNF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2007 12:13:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is an intermediate flush of my queue.  Surprisingly I got quite a
lot of updates after 2.6.21 went public, which I'll try to send in the
next week (before the merge window closes).

The update is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (4):
      aic7xxx: make functions static
      aacraid: cleanups
      dpt_i2o: remove dead code
      fusion: make mptspi_target_destroy() static

Alan Stern (1):
      sg: cap reserved_size values at max_sectors

Andrew Vasquez (5):
      qla2xxx: Update version number to 8.01.07-k6.
      qla2xxx: Allow the extended-error-logging flag to be dynamic.
      qla2xxx: Drop acquisition of hardware_lock during flash manipulations.
      qla2xxx: Add cond_resched() calls during HBA flash manipulation.
      qla2xxx: Add scan_[start|finish]() callbacks for ISP24xx HBAs.

Anton Blanchard (1):
      lpfc: fix oops when parsing dodgy VPD

Bastian Blank (1):
      tgt: fix rdma transfer bugs

Bernhard Walle (1):
      qla2xxx: Remove duplicate pci_disable_device() call

Brian King (13):
      scsi_error.c: Add EH Start Unit retry
      ipr: Driver version to 2.3.2
      ipr: Faster sg list fetch
      ipr: Return better qc_issue errors
      ipr: Disrupt device error
      ipr: Improve async error logging level control
      ipr: PCI unblock config access fix
      ipr: Fix for oops following SATA request sense
      ipr: Log error for SAS dual path switch
      ipr: Enable logging of debug error data for all devices
      ipr: Add new PCI-E IDs to device table
      ipr: Remove auto RAID create module parameter
      ipr: Make adapter operational timeout be per adapter type

Christof Schmitt (1):
      zfcp: fix initialization of FSF timer

David Miller (1):
      qla2xxx: fix regression on sparc64

Eric Moore (2):
      fusion: fix domain validation loops
      fusion: remove VMWare guest OS remounted as read only work around

FUJITA Tomonori (3):
      tgt: remove the code to build sense
      tgt: fix scsi command leak
      tgt: fix sesnse buffer problems

Heiko Carstens (1):
      zfcp: fix likely/unlikely usage

Henrik Kretzschmar (1):
      dpt: whitespace cleanup

Horms (2):
      fusion: honour return value of pci_enable_device() in mpt_resume()
      fusion: remove unnecessary code in mptscsih_resume()

James Bottomley (5):
      fix scsi_wait_scan build problem
      sd: fix up start/stop messages for new sd_printk() API
      expose eh_timed_out to the host template
      make scsi_wait_scan always modular
      sd: typo fix: sdkp_printk should be sd_printk

James Smart (1):
      fc_transport: update potential link speeds

Malahal Naineni (1):
      qla2xxx: fix RSCN handling on big-endian systems

Mark Haverkamp (7):
      aacraid: Improved error handling
      aacraid: fix srb ioctl for 64 bits
      aacraid: remove un-needed references to container id (cid)
      aacraid: Fix ioctl handling when adapter resets
      aacraid: Fix blocking issue with container probing function (cast update)
      aacraid: Fix struct element name issue
      aacraid: add restart adapter platform function

Martin K. Petersen (5):
      constants.c: Update ASC list and make it const
      sd: convert logging to new printk helpers
      sd: make printing use a common prefix
      Make error printing more verbose
      constants.c: cleanup, verbose result printing

Michael Tokarev (1):
      modalias for scsi devices

Mike Christie (8):
      tgt: rm bio hacks in scsi tgt
      iscsi_tcp: print useful error message when iscsi crc23c allocation fails
      iscsi_tcp: increase max_sectors
      libiscsi: use get_unaligned
      iscsi transport: use atomic for session_nr allocations
      iscsi: rename DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH
      libiscsi: clear mtask
      libiscsi: flush work before freeing connection

Pete Wyckoff (1):
      set resid in scsi_io_completion() even for check condition

Randy Dunlap (1):
      fusion: kernel-doc warning fixes

Richard Knutsson (1):
      eata_pio: Remove FALSE/TRUE defines

Richard Lary (1):
      qla2xxx: fix for byteswap in fc_host fabric_name

Robert Jennings (2):
      ibmvscsi: add slave_configure to allow device restart
      ibmvscsi: allow for dynamic adjustment of server request_limit

Robert P. J. Day (3):
      Remove some unused SCSI-related kernel config variables.
      pcmcia: allow drivers to be built non-modular
      pci2000: Delete unused header file.

Salyzyn, Mark (10):
      aacraid: fix aacraid not finding device
      aacraid: Correct SMC products in aacraid.txt
      aacraid: [Fastboot] Panics for AACRAID driver during 'insmod' for kexec te
      aacraid: fix print of Firmware Build Date and add TSID
      aacraid: remove unused or deprecated firmware constants
      aacraid: resolve compiler warnings using ptrdiff_t
      aacraid: Add SMC and SUN products to README
      aacraid: Add likely() and unlikely()
      aacraid: cleanup and version stamp driver
      aacraid: check buffer address in aac_internal_transfer

Tejun Heo (2):
      sd: implement START/STOP management
      sd: fix return value of sd_sync_cache()

Zachary Amsden (1):
      BusLogic: stop using check_region

And the diffstat:

 b/Documentation/scsi/aacraid.txt               |    7 
 b/Documentation/scsi/ncr53c8xx.txt             |    5 
 b/block/ll_rw_blk.c                            |    2 
 b/block/scsi_ioctl.c                           |    4 
 b/drivers/infiniband/ulp/iser/iser_initiator.c |    2 
 b/drivers/message/fusion/mptbase.c             |   27 -
 b/drivers/message/fusion/mptbase.h             |    1 
 b/drivers/message/fusion/mptscsih.c            |   35 --
 b/drivers/message/fusion/mptspi.c              |   36 +-
 b/drivers/s390/scsi/zfcp_erp.c                 |    2 
 b/drivers/s390/scsi/zfcp_fsf.c                 |   10 
 b/drivers/scsi/BusLogic.c                      |   73 ++--
 b/drivers/scsi/Kconfig                         |   22 -
 b/drivers/scsi/Makefile                        |    2 
 b/drivers/scsi/aacraid/aachba.c                |  402 ++++++++++++++----------
 b/drivers/scsi/aacraid/aacraid.h               |   76 +---
 b/drivers/scsi/aacraid/commctrl.c              |  286 ++++++++++-------
 b/drivers/scsi/aacraid/comminit.c              |    4 
 b/drivers/scsi/aacraid/commsup.c               |  112 ++----
 b/drivers/scsi/aacraid/dpcsup.c                |   35 +-
 b/drivers/scsi/aacraid/linit.c                 |   65 +++-
 b/drivers/scsi/aacraid/nark.c                  |    3 
 b/drivers/scsi/aacraid/rkt.c                   |    3 
 b/drivers/scsi/aacraid/rx.c                    |  115 ++++---
 b/drivers/scsi/aic7xxx/Kconfig.aic79xx         |   12 
 b/drivers/scsi/aic7xxx/Kconfig.aic7xxx         |   10 
 b/drivers/scsi/aic7xxx/aic79xx_osm.c           |    6 
 b/drivers/scsi/aic7xxx/aic79xx_osm.h           |    2 
 b/drivers/scsi/aic7xxx/aic7xxx.h               |    5 
 b/drivers/scsi/aic7xxx/aic7xxx_core.c          |    2 
 b/drivers/scsi/constants.c                     |  274 +++++++++-------
 b/drivers/scsi/dpt/dpti_i2o.h                  |   48 +-
 b/drivers/scsi/dpt/dpti_ioctl.h                |    2 
 b/drivers/scsi/dpt/dptsig.h                    |    4 
 b/drivers/scsi/dpt_i2o.c                       |    2 
 b/drivers/scsi/eata_generic.h                  |    7 
 b/drivers/scsi/ibmvscsi/ibmvscsi.c             |   80 +++-
 b/drivers/scsi/ibmvscsi/ibmvscsi.h             |    2 
 b/drivers/scsi/ibmvscsi/ibmvstgt.c             |   37 --
 b/drivers/scsi/ipr.c                           |  290 ++++++++++-------
 b/drivers/scsi/ipr.h                           |   45 +-
 b/drivers/scsi/iscsi_tcp.c                     |   21 -
 b/drivers/scsi/libiscsi.c                      |   29 -
 b/drivers/scsi/libsrp.c                        |   12 
 b/drivers/scsi/lpfc/lpfc_init.c                |    2 
 b/drivers/scsi/osst.c                          |    1 
 b/drivers/scsi/pcmcia/Kconfig                  |    9 
 b/drivers/scsi/qla2xxx/qla_def.h               |   13 
 b/drivers/scsi/qla2xxx/qla_init.c              |  177 ++++++++++
 b/drivers/scsi/qla2xxx/qla_mbx.c               |   16 
 b/drivers/scsi/qla2xxx/qla_os.c                |    7 
 b/drivers/scsi/qla2xxx/qla_sup.c               |   11 
 b/drivers/scsi/qla2xxx/qla_version.h           |    2 
 b/drivers/scsi/scsi.c                          |   47 +-
 b/drivers/scsi/scsi_error.c                    |   19 -
 b/drivers/scsi/scsi_lib.c                      |    8 
 b/drivers/scsi/scsi_scan.c                     |    2 
 b/drivers/scsi/scsi_sysfs.c                    |   54 +++
 b/drivers/scsi/scsi_tgt_if.c                   |    6 
 b/drivers/scsi/scsi_tgt_lib.c                  |  261 ++++------------
 b/drivers/scsi/scsi_tgt_priv.h                 |    5 
 b/drivers/scsi/scsi_transport_fc.c             |    2 
 b/drivers/scsi/scsi_transport_iscsi.c          |    6 
 b/drivers/scsi/sd.c                            |  405 +++++++++++++------------
 b/drivers/scsi/sg.c                            |   13 
 b/drivers/scsi/sr.c                            |    2 
 b/drivers/scsi/st.c                            |    1 
 b/include/scsi/iscsi_proto.h                   |   12 
 b/include/scsi/scsi.h                          |    1 
 b/include/scsi/scsi_cmnd.h                     |    3 
 b/include/scsi/scsi_dbg.h                      |   10 
 b/include/scsi/scsi_device.h                   |   14 
 b/include/scsi/scsi_host.h                     |   32 +
 b/include/scsi/scsi_tgt_if.h                   |    6 
 b/include/scsi/scsi_transport_fc.h             |    2 
 b/include/scsi/sd.h                            |   72 ++++
 drivers/scsi/pci2000.h                         |  197 ------------
 77 files changed, 1984 insertions(+), 1653 deletions(-)

James


