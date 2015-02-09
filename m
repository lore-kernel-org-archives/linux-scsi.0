From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.19+ merge window
Date: Mon, 09 Feb 2015 15:04:23 -0800
Message-ID: <1423523063.2130.40.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the usual grab bag of driver updates (hpsa, storvsc, mp2sas,
megaraid_sas, ses) plus an assortment of minor updates.  There's also an
update to ufs which adds new phy drivers and finally a new logging
infrastructure for SCSI.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Bart Van Assche (1):
      sg: remove an unused variable

Christoph Hellwig (5):
      sr: reduce debug noise in sr_do_ioctl
      ch: remove debug noise in ch_do_scsi
      scsi: always use format argumets for dev_printk
      scsi: annotate sdev_prefix_printk and scmd_printk as printf-like
      storvsc: use cmd_size to allocate per-command data

Dan Carpenter (2):
      mpt3sas: issue_reset is uninitialized
      mpt2sas: issue_reset is uninitialized

Dan Williams (4):
      ses: add reliable slot attribute
      ses: add enclosure logical id
      ses: generate KOBJ_CHANGE on enclosure attach
      ses: close potential registration race

Don Brace (12):
      hpsa: Use local workqueues instead of system workqueues
      hpsa: add in P840ar controller model name
      hpsa: add in gen9 controller model names
      hpsa: return failed from device reset/abort handlers
      hpsa: slightly optimize SA5_performant_completed
      hpsa: count passthru cmds with atomics, not a spin locked int
      hpsa: honor queue depth of physical devices
      hpsa: use workqueue to resubmit failed ioaccel commands
      hpsa: do not queue commands internally in driver
      hpsa: correct change_queue_depth
      hpsa: change how SA controllers are reset
      hpsa: correct endian sparse warnings

Douglas Gilbert (1):
      scsi: asc/ascq codes, sync to T10 2014/12/21

Ewan D. Milne (2):
      scsi_debug: Implement WRITE BUFFER command
      scsi_debug: Add REPORTED LUNS DATA HAS CHANGED Unit Attention

Fabian Frederick (1):
      hpsa: Fix -Wunused-but-set-variable warning

Hannes Reinecke (12):
      scsi_logging: return void for dev_printk() functions
      libata: fixup oops in ata_eh_link_report()
      scsi: do not display kernel pointer in message logs
      scsi: Do not display buffer pointers in scsi_log_send()
      scsi: Conditionally compile in constants.c
      scsi: use per-cpu buffer for formatting scsi_print_result()
      scsi: use per-cpu buffer for formatting sense
      libata: use __scsi_format_command()
      scsi: use external buffer for command logging
      scsi: log request tag for scmd_printk()
      scsi: Implement per-cpu logging buffer
      esp_scsi: remove check for ESP_MAX_TAGS

James Smart (1):
      lpfc: correct device removal deadlock after link bounce

K. Y. Srinivasan (4):
      storvsc: force SPC-3 compliance on win8 and win8 r2 hosts
      storvsc: fix a bug in storvsc limits
      storvsc: force discovery of LUNs that may have been removed.
      storvsc: in responce to a scan event, scan the host

Randy Dunlap (1):
      scsi: fix scsi_error.c kernel-doc warning

Rasmus Villemoes (6):
      scsi: print single-character strings with seq_putc
      scsi: merge consecutive seq_puts calls
      scsi: replace seq_printf with seq_puts
      aha152x: replace seq_printf with seq_puts
      advansys: replace seq_printf with seq_puts
      scsi: remove SPRINTF macro

Rickard Strandqvist (1):
      3w-9xxx.c: Cleaning up missing null-terminate in conjunction with strncpy

Rob Evers (3):
      scsi: retry report-luns when reported LU count requres more memory
      scsi: use set/get_unaligned_be32 in report_luns
      scsi: avoid unnecessary GFP_ATOMIC allocation in scsi_report_lun_scan

Robert Elliott (16):
      hpsa: detect and report failures changing controller transport modes
      hpsa: shorten the wait for the CISS doorbell mode change ack
      hpsa: optimize cmd_alloc function by remembering last allocation
      hpsa: avoid unneccesary calls to resource freeing functions
      hpsa: fix memory leak in hpsa_alloc_cmd_pool
      hpsa: report allocation failures while allocating SG chain blocks
      hpsa: pass error from pci_set_consistent_dma_mask from hpsa_message
      hpsa: rename hpsa_request_irq to hpsa_request_irqs
      hpsa: report failure to ioremap config table
      hpsa: downgrade the Waiting for no-op print to dev_info
      hpsa: propagate return value from board ID lookup
      hpsa: propagate hard_reset failures in reset_devices mode
      hpsa: remove 0x from queue depth print which is in decimal
      hpsa: notice all request_irq errors
      hpsa: rename free_irqs to hpsa_free_irqs
      hpsa: adjust RAID-1, RAID-1ADM, and RAID-6 names

Song Liu (1):
      ses: Add power_status to SES device slot

Sreekanth Reddy (10):
      mpt2sas: Bump driver version to 20.100.00.00
      mpt2sas, mpt3sas: set cpu affinity for each MSIX vectors
      mpt2sas, mpt3sas: Update attribution language to Avago
      mpt2sas: map log_info value 0x0x32010081 to DID_RESET
      mpt2sas, mpt3sas: fix upper bound for the module parameter max_sgl_entries
      mpt2sas: MPI2 Rev BB (2.00.20) specification and 2.00.35 header files
      mpt2sas: Bump driver version to 19.100.00.00
      mpt2sas, mpt3sas: Fail the host reset initiated due to discovery related I/O timeouts at driver load time
      mpt2sas, mpt3sas: log exceeded temperature thresholds
      mpt2sas: MPI2 Rev AA (2.00.19) specifications

Stephen Cameron (13):
      hpsa: do not use function pointers in fast path command submission
      hpsa: print CDBs instead of kernel virtual addresses for uncommon errors
      hpsa: do not use a void pointer for scsi_cmd field of struct CommandList
      hpsa: check for ctlr lockup after command allocation in main io path
      hpsa: guard against overflowing raid map array
      hpsa: do not ack controller events on controllers that do not support it
      hpsa: remove incorrect BUG_ONs checking for raid offload enable
      hpsa: do not check for msi(x) in interrupt_pending
      hpsa: factor out hpsa_ciss_submit function
      hpsa: do not request device rescan on every ioaccel path error
      hpsa: get rid of cmd_special_alloc and cmd_special_free
      hpsa: reserve some commands for use by driver
      hpsa: trivial message and comment clean ups

Sumit.Saxena@avagotech.com (8):
      megaraid_sas: driver version update
      megaraid_sas: remove redundant memset call
      megaraid_sas: reserve commands for IOCTLs and internal DCMDs
      megaraid_sas: complete outstanding IOCTLs before killing adapter
      megaraid_sas: disable interrupt_mask before enabling hardware interrupts
      megaraid_sas: fix the problem of non-existing VD exposed to host
      megaraid_sas: add support for secure JBOD
      megaraid_sas: endianness related bug fixes and code optimization

Tomas Henzl (2):
      hpsa: turn off interrupts when kdump starts
      hpsa: fix memory leak in kdump hard reset

Webb Scales (4):
      hpsa: refactor duplicated scan completion code into a new routine
      hpsa: move SG descriptor set-up out of hpsa_scatter_gather()
      hpsa: fix race between abort handler and main i/o path
      hpsa: refactor hpsa_find_board_params() to encapsulate legacy test

Yaniv Gardi (4):
      ufs-qcom: add support for Qualcomm Technologies Inc platforms
      phy: qcom-ufs: add support for 14nm phy
      phy: qcom-ufs: add support for 20nm phy
      phy: qcom-ufs: add support for QUALCOMM Technologies UFS PHY drivers

And the diffstat:

 drivers/ata/libata-eh.c                     |   20 +-
 drivers/misc/enclosure.c                    |  108 +-
 drivers/phy/Kconfig                         |    7 +
 drivers/phy/Makefile                        |    3 +
 drivers/phy/phy-qcom-ufs-i.h                |  159 +++
 drivers/phy/phy-qcom-ufs-qmp-14nm.c         |  201 +++
 drivers/phy/phy-qcom-ufs-qmp-14nm.h         |  177 +++
 drivers/phy/phy-qcom-ufs-qmp-20nm.c         |  257 ++++
 drivers/phy/phy-qcom-ufs-qmp-20nm.h         |  235 ++++
 drivers/phy/phy-qcom-ufs.c                  |  745 +++++++++++
 drivers/scsi/3w-9xxx.c                      |    3 +-
 drivers/scsi/BusLogic.c                     |   10 +-
 drivers/scsi/Kconfig                        |    4 +-
 drivers/scsi/Makefile                       |    6 +-
 drivers/scsi/NCR5380.c                      |   20 +-
 drivers/scsi/advansys.c                     |  142 +-
 drivers/scsi/aha152x.c                      |  295 +++--
 drivers/scsi/aic7xxx/aic79xx_proc.c         |   38 +-
 drivers/scsi/aic7xxx/aic7xxx_proc.c         |   24 +-
 drivers/scsi/arm/fas216.c                   |    6 +-
 drivers/scsi/atari_NCR5380.c                |    4 +-
 drivers/scsi/atp870u.c                      |    5 +-
 drivers/scsi/ch.c                           |    6 -
 drivers/scsi/constants.c                    |  275 +---
 drivers/scsi/dc395x.c                       |   79 +-
 drivers/scsi/dpt_i2o.c                      |    2 +-
 drivers/scsi/eata_pio.c                     |    2 +-
 drivers/scsi/esas2r/esas2r_main.c           |    2 +-
 drivers/scsi/esp_scsi.c                     |    2 -
 drivers/scsi/gdth_proc.c                    |   24 +-
 drivers/scsi/hpsa.c                         | 1858 ++++++++++++++-------------
 drivers/scsi/hpsa.h                         |   61 +-
 drivers/scsi/hpsa_cmd.h                     |  334 +++--
 drivers/scsi/in2000.c                       |   18 +-
 drivers/scsi/ips.c                          |    7 +-
 drivers/scsi/lpfc/lpfc_els.c                |    9 +
 drivers/scsi/megaraid.c                     |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h        |   66 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  188 ++-
 drivers/scsi/megaraid/megaraid_sas_fp.c     |   17 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  109 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    9 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h             |    7 +-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h        |   51 +-
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h         |    4 +-
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h        |    6 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c         |   52 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h         |   16 +-
 drivers/scsi/mpt2sas/mpt2sas_config.c       |   39 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h          |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_debug.h        |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |   47 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |   53 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h         |   12 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |   39 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h        |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |   42 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h |    3 +-
 drivers/scsi/nsp32.c                        |   41 +-
 drivers/scsi/pcmcia/nsp_cs.c                |   50 +-
 drivers/scsi/qla2xxx/qla_dfs.c              |    8 +-
 drivers/scsi/scsi.c                         |   11 +-
 drivers/scsi/scsi_debug.c                   |  128 +-
 drivers/scsi/scsi_error.c                   |   50 +-
 drivers/scsi/scsi_logging.c                 |  485 +++++++
 drivers/scsi/scsi_proc.c                    |   22 +-
 drivers/scsi/scsi_scan.c                    |   54 +-
 drivers/scsi/scsi_trace.c                   |    6 +-
 drivers/scsi/sd.c                           |    7 +-
 drivers/scsi/ses.c                          |  148 ++-
 drivers/scsi/sg.c                           |   17 +-
 drivers/scsi/sr_ioctl.c                     |   11 -
 drivers/scsi/storvsc_drv.c                  |  190 +--
 drivers/scsi/ufs/Kconfig                    |   13 +
 drivers/scsi/ufs/Makefile                   |    1 +
 drivers/scsi/ufs/ufs-qcom.c                 | 1004 +++++++++++++++
 drivers/scsi/ufs/ufs-qcom.h                 |  170 +++
 drivers/scsi/ufs/ufshcd.c                   |    6 +-
 drivers/scsi/wd33c93.c                      |   18 +-
 drivers/scsi/wd7000.c                       |   41 +-
 drivers/xen/xen-scsiback.c                  |    1 +
 include/linux/enclosure.h                   |   13 +-
 include/linux/phy/phy-qcom-ufs.h            |   59 +
 include/scsi/scsi.h                         |    3 +
 include/scsi/scsi_dbg.h                     |   74 +-
 include/scsi/scsi_device.h                  |   22 +-
 92 files changed, 6325 insertions(+), 2265 deletions(-)
 create mode 100644 drivers/phy/phy-qcom-ufs-i.h
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-14nm.c
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-14nm.h
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.c
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.h
 create mode 100644 drivers/phy/phy-qcom-ufs.c
 create mode 100644 drivers/scsi/scsi_logging.c
 create mode 100644 drivers/scsi/ufs/ufs-qcom.c
 create mode 100644 drivers/scsi/ufs/ufs-qcom.h
 create mode 100644 include/linux/phy/phy-qcom-ufs.h

James
