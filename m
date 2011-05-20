From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for 2.6.39 merge window
Date: Fri, 20 May 2011 14:41:58 +0400
Message-ID: <1305888118.2571.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This represents the usual round of driver updates (fcoe, lpfc, qla2xxx,
bnx2i, mpt2sas/fusion, iscsi, bnx2fc, be2iscsi, mvsas and hpsa) plus a
new fc module for the in-kernel target infrastructure and final removal
of the SCSI serial number, which served only to bounce lock cache lines
in the critical path.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Andrew Vasquez (10):
      qla2xxx: Clear complete initialization control block.
      qla2xxx: Allow an override of the registered maximum LUN.
      qla2xxx: Properly set the dsd_list_len for dsd_chaining in cmd type 6.
      qla2xxx: Verify login-state has transitioned to PRLI-completed.
      qla2xxx: Update copyright banner.
      qla2xxx: Free firmware PCB on logout request.
      qla2xxx: Remove extraneous setting of FCF_ASYNC_SENT during login-done completion.
      qla2xxx: Check for a match before attempting to set FCP-priority information.
      qla2xxx: Correct calling contexts of qla2x00_mark_device_lost() in async paths.
      qla2xxx: Display PortID information during FCP command-status handling.

Anton Blanchard (1):
      ipr: Rate limit DMA mapping errors

Arun Easi (2):
      qla2xxx: Fix hang during driver unload when vport is active.
      qla2xxx: Fix vport delete hang when logins are outstanding.

Borislav Petkov (1):
      mptsas: Fix annoying warning

Brian King (1):
      ibmvscsi: Improve CRQ reset reliability

Chad Dupuis (3):
      qla2xxx: Add qla82xx_rom_unlock() function.
      qla2xxx: Log if qla82xx firmware fails to load from flash.
      qla2xxx: Log fcport state transitions when debug messages are enabled.

Christoph Hellwig (4):
      fusion: do not check serial_number in the abort handler
      mpt2sas: do not check serial_number in the abort handler
      usb-storage: do not increment cmd->serial_number
      remove cmd->serial_number litter

Giridhar Malavali (6):
      qla2xxx: Limit the logs in case device state does not change for ISP82xx.
      qla2xxx: Add the ql2xdontresethba module_param.
      qla2xxx: Display hardware/firmware registers to get more information about the error for ISP82xx.
      qla2xxx: Perform FCoE context reset before trying adapter reset for ISP82xx.
      qla2xxx: Remove extra call to qla82xx_check_fw_alive().
      qla2xxx: Updated the reset sequence for ISP82xx.

James Smart (5):
      lpfc 8.3.23: Update driver version to 8.3.23
      lpfc 8.3.23: BSG additions and fixes
      lpfc 8.3.23: Fixes related to new hardware
      lpfc 8.3.23: Miscellaneous fixes
      lpfc 8.3.23: Debugfs enhancements

Jayamohan Kallickal (8):
      be2iscsi: update version
      be2iscsi: fix chip cleanup
      be2iscsi: fix boot hang due to interrupts not getting rearmed
      be2iscsi: Fix for proper setting of FW
      be2iscsi: check boot_kset is created before destroying it
      be2iscsi: Set a timeout to FW
      be2iscsi: Modifying Maintainer's emailid
      be2iscsi: change in copyright notice

Jeff Mahoney (1):
      iterate over devices individually for /proc/scsi/scsi

Jing Huang (1):
      bfa: firmware download fix

Joe Carnuccio (5):
      qla2xxx: Refactor call to qla2xxx_read_sfp for thermal temperature.
      qla2xxx: Unify the read/write sfp mailbox command routines.
      qla2xxx: Correctly read sfp single byte mailbox register.
      qla2xxx: Correct buffer start in edc sysfs debug print.
      qla2xxx: Add test for valid loop id to qla2x00_relogin().

Joe Perches (1):
      hpsa: Change memset using sizeof(ptr) to sizeof(*ptr)

Julia Lawall (1):
      bnx2fc: introduce missing kfree

Kashyap, Desai (4):
      mptfusion: Bump version 3.4.19
      mptfusion: Adding inline data padding support for TAPE drive.
      mptfusion: Remove debug print from mptscsih_qcmd()
      mpt2sas : WarpDrive New product SSS6200 support added

Kiran Patil (1):
      tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE target (TCM - target core) support

Kirill A. Shutemov (1):
      esp, scsi_tgt_lib, fcoe: use list_move() instead of list_del()/list_add() combination

Kleber Sacilotto de Souza (2):
      ipr: Driver version 2.5.2
      ipr: increase the dump size for 64 bit adapters

Krishna Gudipati (1):
      bfa: Move debugfs initialization before bfa init.

Madhuranath Iyengar (3):
      qla2xxx: Use passed in host to initialize local scsi_qla_host in queuecommand function
      qla2xxx: Update version number to 8.03.07.03-k.
      qla2xxx: Update License file.

Martin George (1):
      scsi_dh_alua: Attach to UNAVAILABLE/OFFLINE AAS devices

Mike Hernandez (1):
      qla2xxx: Include request queue ID in the upper 16-bits of the I/O handle for Abort I/O IOCBs.

Moger, Babu (3):
      scsi_dh_rdac : decide whether to send mode select based on operating mode
      scsi_dh_rdac : Detect the different RDAC operating modes
      scsi_dh_rdac : Add definitions for different RDAC operating modes

Nithin Nayak Sujir (5):
      bnx2fc: increase cleanup wait time
      bnx2fc: Do not use HBA_DBG macro when lport is not available
      bnx2fc: call scsi_done if session goes to not ready from ready
      bnx2fc: Release the reference to hba only after the interface is destroyed
      scsi_transport_fc: Fix deadlock during fc_remove_host

Robert Love (3):
      libfc: Move host_lock usage into ramp_up/down routines
      fcoe: Remove mutex_trylock/restart_syscall checks
      libfcoe: Remove mutex_trylock/restart_syscall checks

Saurav Kashyap (3):
      qla2xxx: Add host number in reset and quiescent message logs.
      qla2xxx: Update firmware version after flash update for ISP82xx.
      qla2xxx: Fix virtual port failing to login after chip reset.

Shyam Iyer (1):
      Log thin provisioning threshold event

Stephen M. Cameron (16):
      hpsa: add P2000 to list of shared SAS devices
      hpsa: do not attempt PCI power management reset method if we know it won't work.
      hpsa: remove superfluous sleeps around reset code
      hpsa: do soft reset if hard reset is broken
      hpsa: use new doorbell-bit-5 reset method
      hpsa: remove atrophied hpsa_scsi_setup function
      hpsa: clarify messages around reset behavior
      hpsa: increase time to wait for board reset
      hpsa: factor out irq request code
      hpsa: factor out cmd pool allocation functions
      hpsa: wait longer for no-op to complete after resetting controller
      hpsa: do a better job of detecting controller reset failure
      hpsa: delete old unused padding garbage
      hpsa: remove unused parameter from hpsa_complete_scsi_command()
      hpsa: add readl after writel in interrupt mask setting code
      hpsa: do readl after writel in main i/o path to ensure commands don't get lost.

Tomas Henzl (2):
      arcmsr: simplify assumptions in dma_alloc_coherent()
      arcmsr: simplify some double loops in sleeping functions

Vasu Dev (4):
      bnx2fc: setup em for npiv port
      fcoe: have fcoe log off and lport destroy before ndo_fcoe_disable
      libfc: rec tov value and REC_TOV_CONST units usages is incorrect
      libfc: remove duplicate ema_list init

Wayne Boyer (3):
      ipr: improve interrupt service routine performance
      ipr: remove unneeded volatile declarations
      ipr: fix synchronous request flags for better performance

Xiangliang Yu (2):
      mvsas: add support for Task collector mode and fixed relative bugs
      mvsas: add support for Marvell 88SE9445/88SE9485

Yi Zou (4):
      libfcoe: fix wrong comment in fcoe_transport_detach
      libfcoe: fix possible buffer overflow in fcoe_transport_show
      libfcoe: clean up netdev mapping properly when the transport goes away
      fcoe: remove unnecessary module state check


And the diffstat:

 Documentation/scsi/LICENSE.qla2xxx         |  292 +++++++++-
 MAINTAINERS                                |    4 +-
 drivers/message/fusion/mptbase.h           |    4 +-
 drivers/message/fusion/mptsas.c            |    4 +-
 drivers/message/fusion/mptscsih.c          |   13 +-
 drivers/message/fusion/mptspi.c            |   22 +
 drivers/message/i2o/i2o_scsi.c             |    4 +-
 drivers/scsi/arcmsr/arcmsr_hba.c           |  138 ++---
 drivers/scsi/be2iscsi/be.h                 |   10 +-
 drivers/scsi/be2iscsi/be_cmds.c            |   11 +-
 drivers/scsi/be2iscsi/be_cmds.h            |   10 +-
 drivers/scsi/be2iscsi/be_iscsi.c           |   13 +-
 drivers/scsi/be2iscsi/be_iscsi.h           |   13 +-
 drivers/scsi/be2iscsi/be_main.c            |   51 +-
 drivers/scsi/be2iscsi/be_main.h            |   15 +-
 drivers/scsi/be2iscsi/be_mgmt.c            |   17 +-
 drivers/scsi/be2iscsi/be_mgmt.h            |   13 +-
 drivers/scsi/bfa/bfad.c                    |   61 ++-
 drivers/scsi/bfa/bfad_debugfs.c            |   33 +-
 drivers/scsi/bfa/bfad_im.h                 |   25 -
 drivers/scsi/bnx2fc/bnx2fc.h               |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c          |   35 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c           |    3 +
 drivers/scsi/bnx2fc/bnx2fc_io.c            |    6 +
 drivers/scsi/constants.c                   |    1 +
 drivers/scsi/dc395x.c                      |  193 +++---
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c |   72 ++-
 drivers/scsi/dpt_i2o.c                     |    6 +-
 drivers/scsi/eata.c                        |   66 +-
 drivers/scsi/eata_pio.c                    |   19 +-
 drivers/scsi/esp_scsi.c                    |    6 +-
 drivers/scsi/fcoe/fcoe.c                   |  202 ++----
 drivers/scsi/fcoe/fcoe_ctlr.c              |    6 +-
 drivers/scsi/fcoe/fcoe_transport.c         |   56 +-
 drivers/scsi/hpsa.c                        |  496 ++++++++++++---
 drivers/scsi/hpsa.h                        |   15 +-
 drivers/scsi/hpsa_cmd.h                    |   11 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c           |    3 +-
 drivers/scsi/in2000.c                      |   29 +-
 drivers/scsi/ipr.c                         |  158 ++++--
 drivers/scsi/ipr.h                         |   22 +-
 drivers/scsi/libfc/fc_fcp.c                |   57 +-
 drivers/scsi/libfc/fc_lport.c              |    1 -
 drivers/scsi/lpfc/lpfc.h                   |    2 +
 drivers/scsi/lpfc/lpfc_bsg.c               |   59 +-
 drivers/scsi/lpfc/lpfc_bsg.h               |  130 ++++
 drivers/scsi/lpfc/lpfc_debugfs.c           |  931 +++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_debugfs.h           |   48 ++-
 drivers/scsi/lpfc/lpfc_els.c               |   44 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c           |    6 +-
 drivers/scsi/lpfc/lpfc_hw4.h               |   18 +-
 drivers/scsi/lpfc/lpfc_init.c              |   19 +-
 drivers/scsi/lpfc/lpfc_mbox.c              |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c              |   14 +-
 drivers/scsi/lpfc/lpfc_sli.c               |   32 +-
 drivers/scsi/lpfc/lpfc_version.h           |    2 +-
 drivers/scsi/megaraid.c                    |   20 +-
 drivers/scsi/megaraid/megaraid_mbox.c      |   37 +-
 drivers/scsi/megaraid/megaraid_sas_base.c  |   13 +-
 drivers/scsi/mesh.c                        |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c        |   42 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h        |   49 ++-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c         |    5 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h         |    1 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c       |  617 +++++++++++++++++--
 drivers/scsi/mvsas/Kconfig                 |    1 +
 drivers/scsi/mvsas/Makefile                |    1 +
 drivers/scsi/mvsas/mv_64xx.c               |    1 +
 drivers/scsi/mvsas/mv_64xx.h               |    1 +
 drivers/scsi/mvsas/mv_94xx.c               |    1 +
 drivers/scsi/mvsas/mv_94xx.h               |    1 +
 drivers/scsi/mvsas/mv_chips.h              |    1 +
 drivers/scsi/mvsas/mv_defs.h               |    3 +
 drivers/scsi/mvsas/mv_init.c               |   67 ++-
 drivers/scsi/mvsas/mv_sas.c                |  385 ++++++++----
 drivers/scsi/mvsas/mv_sas.h                |    8 +
 drivers/scsi/ncr53c8xx.c                   |    2 +-
 drivers/scsi/qla1280.c                     |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c            |   23 +-
 drivers/scsi/qla2xxx/qla_bsg.c             |    2 +-
 drivers/scsi/qla2xxx/qla_bsg.h             |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c             |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.h             |    2 +-
 drivers/scsi/qla2xxx/qla_def.h             |   10 +-
 drivers/scsi/qla2xxx/qla_dfs.c             |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h              |    5 +-
 drivers/scsi/qla2xxx/qla_gbl.h             |   18 +-
 drivers/scsi/qla2xxx/qla_gs.c              |    2 +-
 drivers/scsi/qla2xxx/qla_init.c            |   54 ++-
 drivers/scsi/qla2xxx/qla_inline.h          |   21 +-
 drivers/scsi/qla2xxx/qla_iocb.c            |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c             |   43 +-
 drivers/scsi/qla2xxx/qla_mbx.c             |  151 ++---
 drivers/scsi/qla2xxx/qla_mid.c             |    6 +-
 drivers/scsi/qla2xxx/qla_nx.c              |   97 +++-
 drivers/scsi/qla2xxx/qla_nx.h              |    2 +-
 drivers/scsi/qla2xxx/qla_os.c              |   85 ++-
 drivers/scsi/qla2xxx/qla_settings.h        |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c             |    2 +-
 drivers/scsi/qla2xxx/qla_version.h         |    6 +-
 drivers/scsi/qla4xxx/ql4_os.c              |    5 +-
 drivers/scsi/scsi_error.c                  |    6 +
 drivers/scsi/scsi_proc.c                   |   58 ++-
 drivers/scsi/scsi_tgt_lib.c                |    6 +-
 drivers/scsi/scsi_transport_fc.c           |   11 +-
 drivers/scsi/tmscsim.c                     |   22 +-
 drivers/scsi/u14-34f.c                     |   61 +-
 drivers/scsi/wd33c93.c                     |   45 +-
 drivers/target/Kconfig                     |    1 +
 drivers/target/Makefile                    |    2 +
 drivers/target/tcm_fc/Kconfig              |    5 +
 drivers/target/tcm_fc/Makefile             |   15 +
 drivers/target/tcm_fc/tcm_fc.h             |  215 +++++++
 drivers/target/tcm_fc/tfc_cmd.c            |  696 +++++++++++++++++++++
 drivers/target/tcm_fc/tfc_conf.c           |  677 ++++++++++++++++++++
 drivers/target/tcm_fc/tfc_io.c             |  374 +++++++++++
 drivers/target/tcm_fc/tfc_sess.c           |  541 ++++++++++++++++
 drivers/usb/storage/isd200.c               |    1 -
 119 files changed, 6388 insertions(+), 1680 deletions(-)
 create mode 100644 drivers/target/tcm_fc/Kconfig
 create mode 100644 drivers/target/tcm_fc/Makefile
 create mode 100644 drivers/target/tcm_fc/tcm_fc.h
 create mode 100644 drivers/target/tcm_fc/tfc_cmd.c
 create mode 100644 drivers/target/tcm_fc/tfc_conf.c
 create mode 100644 drivers/target/tcm_fc/tfc_io.c
 create mode 100644 drivers/target/tcm_fc/tfc_sess.c

James
