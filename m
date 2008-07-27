From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] final SCSI pieces for 2.6.27
Date: Sun, 27 Jul 2008 10:49:10 -0400
Message-ID: <1217170150.3503.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38853 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbYG0Otj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jul 2008 10:49:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the last tranche (hopefully) for the merge window.  There are a
few new things (like data integrity DIF/DIX) but it's actually also a
lot of bug fixes.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adam Radford (1):
      3w-9xxx: add MSI support and misc fixes

Akinobu Mita (1):
      qla2xxx: use memory_read_from_buffer()

Alan Jenkins (1):
      extend the last_sector_bug flag to cover more sectors

Alan Stern (1):
      scsi_eh_prep_cmnd should save scmd->underflow

Andrew Morton (1):
      qla2xxx: suppress uninitialized-var warning

Andrew Vasquez (12):
      qla2xxx: Update version number to 8.02.01-k6.
      qla2xxx: Additional NPIV corrections.
      qla2xxx: Issue proper ISP callbacks during stop-firmware.
      qla2xxx: Update version number to 8.02.01-k5.
      qla2xxx: Don't hardcode fw_transfer_size for ISP2[45]xx parts.
      qla2xxx: Verify the RISC is not in ROM code if firmware-load is disabled.
      qla2xxx: Correct overflow during dump-processing on large-memory ISP23xx p
      qla2xxx: Skip FDMI registration on ISP21xx/22xx parts.
      qla2xxx: Swap enablement order of EFT and FCE.
      qla2xxx: Allow the user the option of disabling iIDMA.
      qla2xxx: Set an rport's dev_loss_tmo value in a consistent manner.
      qla2xxx: Correct locking during NVRAM manipulation.

Brian King (6):
      ibmvfc: Update driver version to 1.0.1
      ibmvfc: Add ADISC support
      ibmvfc: Miscellaneous fixes
      ibmvfc: Fix hang on module removal
      ibmvfc: Target refcounting fixes
      ibmvfc: Reduce unnecessary log noise

FUJITA Tomonori (1):
      ch: fix ch_remove oops

Hannes Reinecke (8):
      scsi_dh: create lookup cache
      scsi_dh: attach to hardware handler from dm-mpath
      scsi_dh: add generic SPC-3 alua handler
      scsi_dh: Update RDAC device handler
      scsi_dh: Update hp_sw hardware handler
      scsi_dh: Update EMC handler
      scsi_dh: Add 'dh_state' sysfs attribute
      scsi_dh: Implement common device table handling

Harish Zunjarrao (2):
      qla2xxx: Add LIP count to FC-transport statistics.
      qla2xxx: Track total number of ISP aborts.

Harvey Harrison (1):
      replace __FUNCTION__ with __func__

Joe Carnuccio (1):
      qla2xxx: Retrieve board serial-number and description from VPD.

Julia Lawall (1):
      scsi_scan.c: Release mutex in error handling code

Kai Makisara (2):
      st: Remove bogus memset
      st: Move buffer pointer back when data could not be written.

Martin K. Petersen (6):
      sd: Support for SCSI disk (SBC) Data Integrity Field
      sd: Identify DIF protection type and application tag ownership
      Do not retry a request whose data integrity check failed
      Support devices with protection information
      Command protection operation
      Host protection capabilities

Matthew Wilcox (1):
      Make host_no an unsigned int

Mike Anderson (1):
      sym53c8xx: free luntbl in sym_hcb_free

Mike Christie (5):
      scsi_lib: use blk_rq_tagged in scsi_request_fn
      fix shared tag map tag allocation
      stex: fix queue depth setting
      qla4xxx: fix queue depth setting
      fix shared tag map setup

Seokmann Ju (6):
      qla2xxx: Correct rport/fcport visibility-state handling during loop-resync
      qla2xxx: Correct vport management of MBA_PORT_UPDATE.
      qla2xxx: Correct fcport state-management during loss.
      qla2xxx: Always aquire the parent's hardware_lock.
      qla2xxx: Cleanup NPIV related functions
      qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io callback support.

Tejun Heo (1):
      sd: update index allocation and use ida instead of idr

and the diffstat:

 drivers/md/dm-mpath.c                       |   13 
 drivers/scsi/3w-9xxx.c                      |   40 +
 drivers/scsi/3w-9xxx.h                      |    9 
 drivers/scsi/Kconfig                        |    1 
 drivers/scsi/Makefile                       |    2 
 drivers/scsi/ch.c                           |    1 
 drivers/scsi/device_handler/Kconfig         |    8 
 drivers/scsi/device_handler/Makefile        |    1 
 drivers/scsi/device_handler/scsi_dh.c       |  446 ++++++++++++++-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  802 ++++++++++++++++++++++++++++
 drivers/scsi/device_handler/scsi_dh_emc.c   |  644 ++++++++++++++--------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  348 +++++++++---
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  262 ++++-----
 drivers/scsi/ibmvscsi/ibmvfc.c              |  204 ++++++-
 drivers/scsi/ibmvscsi/ibmvfc.h              |   40 +
 drivers/scsi/qla2xxx/qla_attr.c             |  118 ++--
 drivers/scsi/qla2xxx/qla_dbg.c              |    2 
 drivers/scsi/qla2xxx/qla_def.h              |   12 
 drivers/scsi/qla2xxx/qla_gbl.h              |    5 
 drivers/scsi/qla2xxx/qla_gs.c               |    6 
 drivers/scsi/qla2xxx/qla_init.c             |  133 ++--
 drivers/scsi/qla2xxx/qla_iocb.c             |   14 
 drivers/scsi/qla2xxx/qla_isr.c              |    4 
 drivers/scsi/qla2xxx/qla_mbx.c              |    9 
 drivers/scsi/qla2xxx/qla_mid.c              |   16 
 drivers/scsi/qla2xxx/qla_os.c               |   94 ++-
 drivers/scsi/qla2xxx/qla_sup.c              |   48 +
 drivers/scsi/qla2xxx/qla_version.h          |    2 
 drivers/scsi/qla4xxx/ql4_os.c               |    4 
 drivers/scsi/scsi.c                         |   55 +
 drivers/scsi/scsi_error.c                   |    8 
 drivers/scsi/scsi_lib.c                     |   49 +
 drivers/scsi/scsi_priv.h                    |    1 
 drivers/scsi/scsi_scan.c                    |    1 
 drivers/scsi/scsi_sysfs.c                   |    4 
 drivers/scsi/sd.c                           |  291 +++++++---
 drivers/scsi/sd.h                           |   54 +
 drivers/scsi/sd_dif.c                       |  538 ++++++++++++++++++
 drivers/scsi/st.c                           |   11 
 drivers/scsi/stex.c                         |    2 
 drivers/scsi/sym53c8xx_2/sym_hipd.c         |    2 
 include/scsi/scsi.h                         |    3 
 include/scsi/scsi_cmnd.h                    |   86 +++
 include/scsi/scsi_device.h                  |   17 
 include/scsi/scsi_dh.h                      |   11 
 include/scsi/scsi_eh.h                      |    2 
 include/scsi/scsi_host.h                    |   86 ++-
 47 files changed, 3713 insertions(+), 796 deletions(-)

James


