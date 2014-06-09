From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.15+ merge window
Date: Mon, 09 Jun 2014 08:02:04 -0700
Message-ID: <1402326124.2197.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53374 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbaFIPCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2014 11:02:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This patch consists of the usual driver updates (qla2xxx, qla4xxx, lpfc,
be2iscsi, fnic, ufs, NCR5380)  The NCR5380 is the addition to maintained
status of a long neglected driver for older hardware.  In addition there
are a lot of minor fixes and cleanups and some more updates to make scsi
mq ready.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is:

Adheer Chandravanshi (2):
      qla4xxx: Fix smatch warning in func qla4xxx_conn_get_param
      qla4xxx: Fix smatch warning in func qla4xxx_get_ep_param

Alexey Khoroshilov (1):
      bfa: allocate memory with GFP_ATOMIC in spinlock context

Armen Baloyan (3):
      qla2xxx: Adjust adapter reset routine to the changes in firmware specification for ISPFx00.
      qla2xxx: Decrease pci access for response queue processing for ISPFX00.
      qla2xxx: Change copyright year to 2014 in all the source files.

Atul Deshmukh (3):
      qla2xxx: IOCB data should be copied to I/O mem using memcpy_toio.
      qla2xxx: Include <delay.h> file for msleep declartion in qla_nx2.c file.
      qla2xxx: Use proper log message for flash lock failed error.

Ben Hutchings (1):
      mvsas: Recognise device/subsystem 9485/9485 as 88SE9485

Benoit Taine (2):
      qla2xxx: Use kmemdup instead of kmalloc + memcpy
      qla4xxx: Use kmemdup instead of kmalloc + memcpy

Chad Dupuis (7):
      qla2xxx: Remove wait for online from host reset handler.
      qla2xxx: Do logins from a chip reset in DPC thread instead of the error handler thread.
      qla2xxx: Reduce the time we wait for a command to complete during SCSI error handling.
      qla2xxx: Clear loop_id for ports that are marked lost during fabric scanning.
      qla2xxx: Avoid escalating the SCSI error handler if the command is not found in firmware.
      qla2xxx: Remove unnecessary printk_ratelimited from qla_nx2.c
      qla2xxx: Do not schedule reset when one is already active when receiving an invalid status handle.

Christoph Hellwig (7):
      Revert "be2iscsi: Fix processing cqe for cxn whose endpoint is freed"
      scsi_debug: simple short transfer injection
      virtio_scsi: use cmd_size
      scsi: handle command allocation failure in scsi_reset_provider
      scsi: reintroduce scsi_driver.init_command
      scsi: remove scsi_end_request
      scsi: explicitly release bidi buffers

Dan Carpenter (1):
      qla2xxx: fix incorrect debug printk

David Jeffery (1):
      sd: medium access timeout counter fails to reset

Fabian Frederick (1):
      include/scsi/osd_protocol.h: remove unnecessary __constant

Finn Thain (14):
      scsi/NCR5380: dprintk macro
      scsi/NCR5380: merge sun3_scsi_vme.c into sun3_scsi.c
      scsi/NCR5380: reduce depth of sun3_scsi nested includes
      scsi/NCR5380: remove unused macro definitions
      scsi/NCR5380: fix and standardize NDEBUG macros
      scsi/NCR5380: adopt dprintk()
      scsi/NCR5380: adopt NCR5380_dprint() and NCR5380_dprint_phase()
      scsi/NCR5380: fix dprintk macro usage and definition
      scsi/NCR5380: fix build failures when debugging is enabled
      scsi/NCR5380: use NCR5380_dprint() instead of NCR5380_print()
      scsi/NCR5380: remove old CVS keywords
      scsi/NCR5380: remove redundant HOSTS_C macro tests
      scsi/NCR5380: remove unused BOARD_NORMAL and BOARD_NCR53C400
      MAINTAINERS: add an entry for all the NCR5380 drivers

Giridhar Malavali (3):
      qla2xxx: Check for peg alive counter and clear any outstanding mailbox command.
      qla2xxx: Issue abort command for outstanding commands during cleanup when only firmware is alive.
      qla2xxx: Log when device state is moved to failed state.

Hannes Reinecke (1):
      scsi: set correct completion code in scsi_send_eh_cmnd()

Himanshu Madani (1):
      qla2xxx: Fix beacon blink logic for ISP26xx/83xx.

Himanshu Madhani (1):
      qla2xxx: Remove mapped vp index iterator macro dead code.

Hiral Patel (5):
      qla2xxx: Check the QLA8044_CRB_DRV_ACTIVE_INDEX register when we are not the owner of the reset.
      qla2xxx: Enable fw_dump_size for ISP8044.
      qla2xxx: Introduce fw_dump_flag to track fw dump progress.
      qla2xxx: Remove unnecessary delays from fw dump code path.
      qla2xxx: Track the process when the ROM_LOCK failure happens

Hiral Shah (3):
      fnic: fnic Control Path Trace Utility
      fnic: Failing to queue aborts due to Q full cause terminate driver timeout
      fnic: NoFIP solicitation frame in NONFIP mode and changed IO Throttle count

James Smart (1):
      lpfc: Add iotag memory barrier

Jayamohan Kallickal (8):
      be2iscsi: Bump the driver version
      be2iscsi: Fix processing cqe for cxn whose endpoint is freed
      be2iscsi: Fix destroy MCC-CQ before MCC-EQ is destroyed
      be2iscsi: Fix memory corruption in MBX path
      be2iscsi: Fix TCP parameters while connection offloading.
      be2iscsi: Fix interrupt Coalescing mechanism.
      be2iscsi: Fix exposing Host in sysfs after adapter initialization is complete
      be2iscsi: Fix retrieving MCCQ_WRB in non-embedded Mbox path

Joe Carnuccio (11):
      qla2xxx: Add MBC option for fast SFP data access.
      qla2xxx: ISP27xx queue index shadow registers.
      qla2xxx: ISP27xx firmware dump template spec updates (including T274).
      qla2xxx: ISP8044 poll ipmdio bus timeout improvement.
      qla2xxx: Update entry type 270 to match spec update.
      qla2xxx: Correction to ISP27xx template entry types 256 and 258.
      qla2xxx: Add ISP8044 serdes bsg interface.
      qla2xxx: Add pci device id 0x2271.
      qla2xxx: Correct ISP83xx/ISP27xx mislogic in setting out_mb in qla25xx_init_req_que().
      qla2xxx: Allow ISP83XX and ISP27XX both to write req_q_out register.
      qla2xxx: Correct operations for ISP27xx template types 270 and 271.

Joe Handzik (5):
      hpsa: fix bad comparison of signed with unsigned in hpsa_update_scsi_devices
      hpsa: do not ignore failure of sense controller parameters command
      hpsa: fix memory leak in hpsa_hba_mode_enabled
      hpsa: add new Smart Array PCI IDs (May 2014)
      hpsa: Checking for a NULL return from a kzalloc call

Marek Vasut (1):
      esas2r: Fix comment

Mathias Krause (1):
      aic79xx: fix misuse of static variables

Matthew Wilcox (7):
      fusion: Remove use of DEF_SCSI_QCMD
      fusion: Add free msg frames to the head, not tail of list
      mpt2sas: Add free smids to the head, not tail of list
      mpt2sas: Remove use of DEF_SCSI_QCMD
      mpt2sas: Remove uses of serial_number
      mpt3sas: Remove use of DEF_SCSI_QCMD
      mpt3sas: Remove uses of serial_number

Maurizio Lombardi (3):
      bnx2fc: fix memory leak in bnx2fc_allocate_hash_table()
      bnx2fc: fix memory leak and potential NULL pointer dereference.
      bnx2fc: remove unused variable hash_table_size

Michael Schmitz (1):
      m68k/atari - atari_scsi: change abort/reset return codes

Ming Lei (1):
      virtio_scsi: remove ACCESS_ONCE() and smp_read_barrier_depends()

Nathan Fontenot (1):
      Update Maintainers for IBM Power 842, vscsi, and vfc drivers

Nilesh Javali (2):
      qla4xxx: Fix memory leak for ha->saved_acb
      qla4xxx: Export sysfs DDBs from DPC handler

Paul Bolle (1):
      acornscsi: remove linked command support

Pratik Mohanty (1):
      qla2xxx: Support of new firmware dump opcodes QLA8044_RDDFE(38), QLA8044_RDMDIO(39),QLA8044_POLLWR(40).

Quinn Tran (2):
      qla2xxx: ABTS cause double free of qla_tgt_cmd +.
      qla2xxx: T10-Dif: add T10-PI support

Saurav Kashyap (3):
      qla2xxx: Update the driver version to 8.07.00.08-k.
      qla2xxx: Allow the next firmware dump if the previous dump capture fails for ISP8044.
      qla2xxx: Wait for reset completion without lock for ISPFX00.

Sawan Chandak (1):
      qla2xxx: Delay driver unload if there is any pending activity going on.

Shlomo Pongratz (1):
      scsi/libiscsi: Fix static checker warning on bh locking

Sujit Reddy Thumma (6):
      scsi: ufs: Improve UFS fatal error handling
      scsi: ufs: Fix device and host reset methods
      scsi: ufs: Fix hardware race conditions while aborting a command
      scsi: ufs: Fix broken task management command implementation
      scsi: ufs: make undeclared functions static
      scsi: ufs: fix endianness sparse warnings

Suresh Thiagarajan (1):
      pm80xx : Fix missing NULL pointer checks and memory leaks

Tej Parkash (6):
      qla4xxx: Disable INTx interrupt for ISP82XX
      qla4xxx: Added PEX DMA Support for ISP8022 Adapter
      qla4xxx: Added new opcodes for 84XX Minidump template
      qla4xxx: Add support of 0xFF capture mask for minidump
      qla4xxx: Change default capture to firmware defined capture mask
      qla4xxx: Do not wait for IO completion, after issuing stop_firmware

Tej Prakash (1):
      qla2xxx: Don't check for firmware hung during the reset context for ISP82XX.

Tomas Henzl (2):
      mptfusion: fix msgContext in mptctl_hp_hostinfo
      megaraid_sas: fix a small problem when reading state value from hw

Vikas Chaudhary (6):
      qla4xxx: Update driver version to 5.04.00-k6
      qla4xxx: Update driver version to 5.04.00-k5
      qla4xxx: Fix memory leak in func qla4_84xx_config_acb()
      qla4xxx: Initialize hardware queue for ISP40XX
      qla4xxx: Check for correct return status
      qla4xxx: qla4xxx: Move qla4_8xxx_ms_mem_write_128b to ql4_nx.c

and the diffstat

 Documentation/scsi/LICENSE.qla2xxx        |   2 +-
 MAINTAINERS                               |  38 +-
 drivers/message/fusion/mptbase.c          |   2 +-
 drivers/message/fusion/mptctl.c           |   6 +-
 drivers/message/fusion/mptfc.c            |  12 +-
 drivers/message/fusion/mptsas.c           |  10 +-
 drivers/message/fusion/mptscsih.c         |   8 +-
 drivers/message/fusion/mptscsih.h         |   2 +-
 drivers/message/fusion/mptspi.c           |  12 +-
 drivers/scsi/NCR5380.c                    | 137 +++---
 drivers/scsi/NCR5380.h                    |  32 +-
 drivers/scsi/aic7xxx/aic79xx_pci.c        |  18 +-
 drivers/scsi/arm/acornscsi.c              |  53 ---
 drivers/scsi/arm/cumana_1.c               |   3 -
 drivers/scsi/arm/oak.c                    |   3 -
 drivers/scsi/atari_NCR5380.c              | 193 ++++----
 drivers/scsi/atari_scsi.c                 |  24 +-
 drivers/scsi/atari_scsi.h                 | 119 -----
 drivers/scsi/be2iscsi/be.h                |  11 +
 drivers/scsi/be2iscsi/be_cmds.h           |  31 +-
 drivers/scsi/be2iscsi/be_iscsi.c          |  12 +-
 drivers/scsi/be2iscsi/be_main.c           |  82 +++-
 drivers/scsi/be2iscsi/be_main.h           |   7 +-
 drivers/scsi/be2iscsi/be_mgmt.c           |  64 ++-
 drivers/scsi/be2iscsi/be_mgmt.h           |   2 +
 drivers/scsi/bfa/bfad.c                   |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c          |  64 +--
 drivers/scsi/dtc.c                        |   2 -
 drivers/scsi/esas2r/esas2r_main.c         |   2 +-
 drivers/scsi/fnic/fnic.h                  |   5 +-
 drivers/scsi/fnic/fnic_debugfs.c          | 238 ++++++++--
 drivers/scsi/fnic/fnic_fcs.c              |  61 ++-
 drivers/scsi/fnic/fnic_main.c             |  23 +-
 drivers/scsi/fnic/fnic_scsi.c             |  13 +-
 drivers/scsi/fnic/fnic_trace.c            | 326 +++++++++++++-
 drivers/scsi/fnic/fnic_trace.h            |  38 ++
 drivers/scsi/g_NCR5380.c                  |   4 -
 drivers/scsi/g_NCR5380.h                  |   7 -
 drivers/scsi/hpsa.c                       |  31 +-
 drivers/scsi/hpsa.h                       |   1 +
 drivers/scsi/libiscsi.c                   |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c              |  21 +
 drivers/scsi/mac_scsi.c                   |  10 -
 drivers/scsi/mac_scsi.h                   |  10 -
 drivers/scsi/megaraid/megaraid_sas_base.c |  15 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c       |   8 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h       |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c        |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |  24 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h       |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  24 +-
 drivers/scsi/mvsas/mv_init.c              |   9 +
 drivers/scsi/pas16.h                      |   3 -
 drivers/scsi/pm8001/pm8001_ctl.c          |   3 +
 drivers/scsi/qla2xxx/qla_attr.c           |   6 +-
 drivers/scsi/qla2xxx/qla_bsg.c            |  49 +-
 drivers/scsi/qla2xxx/qla_bsg.h            |   9 +-
 drivers/scsi/qla2xxx/qla_dbg.c            | 127 +++---
 drivers/scsi/qla2xxx/qla_dbg.h            |   5 +-
 drivers/scsi/qla2xxx/qla_def.h            |  44 +-
 drivers/scsi/qla2xxx/qla_dfs.c            |   2 +-
 drivers/scsi/qla2xxx/qla_fw.h             |  14 +-
 drivers/scsi/qla2xxx/qla_gbl.h            |  14 +-
 drivers/scsi/qla2xxx/qla_gs.c             |   2 +-
 drivers/scsi/qla2xxx/qla_init.c           |  53 +--
 drivers/scsi/qla2xxx/qla_inline.h         |  15 +-
 drivers/scsi/qla2xxx/qla_iocb.c           | 148 ++++--
 drivers/scsi/qla2xxx/qla_isr.c            |  23 +-
 drivers/scsi/qla2xxx/qla_mbx.c            |  96 +++-
 drivers/scsi/qla2xxx/qla_mid.c            |   2 +-
 drivers/scsi/qla2xxx/qla_mr.c             |  64 ++-
 drivers/scsi/qla2xxx/qla_mr.h             |   3 +-
 drivers/scsi/qla2xxx/qla_nx.c             |  87 ++--
 drivers/scsi/qla2xxx/qla_nx.h             |   6 +-
 drivers/scsi/qla2xxx/qla_nx2.c            | 510 +++++++++++++++++----
 drivers/scsi/qla2xxx/qla_nx2.h            |  50 ++-
 drivers/scsi/qla2xxx/qla_os.c             | 105 +++--
 drivers/scsi/qla2xxx/qla_settings.h       |   2 +-
 drivers/scsi/qla2xxx/qla_sup.c            |   9 +-
 drivers/scsi/qla2xxx/qla_target.c         | 650 +++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.h         |  84 +++-
 drivers/scsi/qla2xxx/qla_tmpl.c           |  91 +++-
 drivers/scsi/qla2xxx/qla_tmpl.h           |  17 +-
 drivers/scsi/qla2xxx/qla_version.h        |   4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c        |  41 +-
 drivers/scsi/qla4xxx/ql4_83xx.c           | 106 +----
 drivers/scsi/qla4xxx/ql4_83xx.h           |  44 ++
 drivers/scsi/qla4xxx/ql4_def.h            |   1 +
 drivers/scsi/qla4xxx/ql4_fw.h             |   4 +
 drivers/scsi/qla4xxx/ql4_glbl.h           |   3 +-
 drivers/scsi/qla4xxx/ql4_init.c           |  32 +-
 drivers/scsi/qla4xxx/ql4_isr.c            |  12 +-
 drivers/scsi/qla4xxx/ql4_mbx.c            |   8 +-
 drivers/scsi/qla4xxx/ql4_nx.c             | 458 ++++++++++++++++++-
 drivers/scsi/qla4xxx/ql4_nx.h             |   3 +
 drivers/scsi/qla4xxx/ql4_os.c             |  41 +-
 drivers/scsi/qla4xxx/ql4_version.h        |   2 +-
 drivers/scsi/scsi_debug.c                 |   8 +
 drivers/scsi/scsi_error.c                 |   7 +
 drivers/scsi/scsi_lib.c                   | 225 ++++------
 drivers/scsi/sd.c                         |  48 +-
 drivers/scsi/sr.c                         |  19 +-
 drivers/scsi/sun3_NCR5380.c               | 195 ++++----
 drivers/scsi/sun3_scsi.c                  | 241 +++++++---
 drivers/scsi/sun3_scsi.h                  | 199 +-------
 drivers/scsi/sun3_scsi_vme.c              | 588 +-----------------------
 drivers/scsi/t128.c                       |   4 -
 drivers/scsi/t128.h                       |   7 -
 drivers/scsi/ufs/ufs.h                    |  36 +-
 drivers/scsi/ufs/ufshcd.c                 | 722 ++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h                 |  22 +-
 drivers/scsi/ufs/ufshci.h                 |  32 +-
 drivers/scsi/virtio_scsi.c                |  78 +---
 include/scsi/osd_protocol.h               |  10 +-
 include/scsi/scsi_cmnd.h                  |   9 +
 include/scsi/scsi_driver.h                |   9 +-
 117 files changed, 4635 insertions(+), 2709 deletions(-)

James


