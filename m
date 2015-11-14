From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.3+ merge window
Date: Fri, 13 Nov 2015 19:05:27 -0500
Message-ID: <1447459527.25030.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58818 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbbKNAFb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Nov 2015 19:05:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Sorry for the delay in this patch which was mostly caused by getting the
merger of the mpt2/mpt3sas driver, which was seen as an essential item
of maintenance work to do before the drivers diverge too much.
Unfortunately, this caused a compile failure (detected by linux-next),
which then had to be fixed up and incubated.  In addition to the
mpt2/3sas rework, there are updates from pm80xx, lpfc, bnx2fc, hpsa,
ipr, aacraid, megaraid_sas, storvsc and ufs plus an assortment of
changes including some year 2038 issues, a fix for a remove before
detach issue in some drivers and a couple of other minor issues.

This tree also includes a subtree pull from Martin, who has been
wrangling the mpt2/3 merger plus sorting out applying several other
drivers.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The Short Changelog is:

Alison Schofield (1):
      scsi: pmcraid: replace struct timeval with ktime_get_real_seconds()

Arnd Bergmann (1):
      bnx2fc: reduce stack usage in __bnx2fc_enable

Bart Van Assche (1):
      scsi: Fix a bdi reregistration race

Benjamin Rood (9):
      pm80xx: remove the SCSI host before detaching from SAS transport
      pm80xx: avoid a panic if MSI(X) interrupts are disabled
      pm80xx: wait a minimum of 500ms before issuing commands to SPCv
      pm80xx: do not examine registers for iButton feature if ATTO adapter
      pm80xx: set PHY profiles for ATTO 12Gb SAS controllers
      pm80xx: add support for ATTO devices during SAS address initiailization
      pm80xx: add ATTO PCI IDs to pm8001_pci_table
      pm80xx: add support for PMC Sierra 8070 and PMC Sierra 8072 SAS controllers
      pm80xx: configure PHY settings based on subsystem vendor ID

Brian King (1):
      SCSI: Increase REPORT_LUNS timeout

Calvin Owens (1):
      sg: Fix double-free when drives detach during SG_IO

Chad Dupuis (6):
      bnx2fc: Update version number to 2.9.6.
      bnx2fc: Remove explicit logouts.
      bnx2fc: Fix FCP RSP residual parsing.
      bnx2fc: Set ELS transfer length correctly for middle path commands.
      bnx2fc: Remove 'NetXtreme II' from source files.
      bnx2fc: Update copyright for 2015.

Christoph Hellwig (3):
      mpt2sas: Use mpi headers from mpt3sas
      scsi: use host wide tags by default
      scsi: restart list search after unlock in scsi_remove_target

Dan Carpenter (1):
      mptfusion: don't allow negative bytes in kbuf_alloc_2_sgl()

Don Brace (15):
      hpsa: bump the driver version
      hpsa: enhance device messages
      hpsa: enhance hpsa_get_device_id
      hpsa: correct ioaccel2 sg chain len
      hpsa: correct check for non-disk devices
      hpsa: fix hpsa_adjust_hpsa_scsi_table
      hpsa: correct transfer length for 6 byte read/write commands
      hpsa: abandon rescans on memory alloaction failures.
      hpsa: allow driver requested rescans
      hpsa: fix null device issues
      hpsa: check for null arguments to dev_printk
      hpsa: change devtype to unsigned
      hpsa: remove unused hpsa_tag_discard_error_bits
      hpsa: stop zeroing reset_cmds_out and ioaccel_cmds_out during rescan
      hpsa: remove unused parameter hostno

Gabriel Krisman Bertazi (6):
      sd: Clear PS bit before Mode Select.
      ipr: Driver version 2.6.3.
      ipr: Issue Configure Cache Parameters command.
      ipr: Inquiry IOA page 0xC4 during initialization.
      ipr: Don't set NO_ULEN_CHK bit when resource is a vset.
      ipr: Add delay to ensure coherent dumps.

Jack Wang (3):
      mvsas: remove SCSI host before detaching from SAS transport
      aic94xx: remove SCSI host before detaching from SAS transport
      isci: remove SCSI host before detaching from SAS transport

Jiri Slaby (1):
      fcoe: use continue instead of goto+label

Johannes Thumshirn (1):
      scsi: Export SCSI Inquiry data to sysfs

John Soni Jose (2):
      be2iscsi: Bump the driver version
      be2iscsi: Fix updating the next pointer during WRB posting

K. Y. Srinivasan (2):
      scsi: storvsc: Fix a bug in the handling of SRB status flags
      storvsc: Don't set the SRB_FLAGS_QUEUE_ACTION_ENABLE flag

Kevin Barnett (6):
      hpsa: add in sas transport class
      hpsa: move scsi_add_device and scsi_remove_device calls to new function
      hpsa: refactor hpsa_figure_bus_target_lun
      hpsa: add function is_logical_device
      hpsa: simplify update scsi devices
      hpsa: simplify check for device exposure

Laurent Vivier (2):
      ibmvscsi: set max_lun to 32
      ibmvscsi: display default value for max_id, max_lun and max_channel.

Mahesh Rajashekhara (9):
      aacraid: Update driver version
      aacraid: Use pci_enable_msix_range()
      aacraid: IOCTL fix
      aacraid: Reset irq affinity hints
      aacraid: Tune response path if IsFastPath bit set
      aacraid: Enable 64bit write to controller register
      aacraid: Change interrupt mode to MSI for Series 6
      aacraid: Add Power Management support
      aacraid: Fix for LD name and UID not exposed to OS

Peter Oberparleiter (2):
      scsi_sysfs: Fix queue_ramp_up_period return code
      scsi_sysfs: Fix queue_ramp_up_period return code

Rasmus Villemoes (1):
      hpsa: fix multiple issues in path_info_show

Scott Teel (5):
      hpsa: disable report lun data caching
      hpsa: add discovery polling for PT RAID devices.
      hpsa: eliminate fake lun0 enclosures
      hpsa: generalize external arrays
      hpsa: fix physical target reset

Sebastian Herbszt (1):
      libfc: Use the correct function name in kernel-doc comment.

Seymour, Shane M (1):
      st: allow debug output to be enabled or disabled via sysfs

Sreekanth Reddy (19):
      mpt3sas: Bump mpt3sas driver version to 09.102.00.00
      mpt3sas: Single driver module which supports both SAS 2.0 & SAS 3.0 HBAs
      mpt2sas, mpt3sas: Update the driver versions
      mpt3sas: setpci reset kernel oops fix
      mpt3sas: Added OEM Gen2 PnP ID branding names
      mpt3sas: Refcount fw_events and fix unsafe list usage
      mpt3sas: Refcount sas_device objects and fix unsafe list usage
      mpt3sas: sysfs attribute to report Backup Rail Monitor Status
      mpt3sas: Ported WarpDrive product SSS6200 support
      mpt3sas: fix for driver fails EEH, recovery from injected pci bus error
      mpt3sas: Manage MSI-X vectors according to HBA device type
      mpt3sas: Don't send PHYDISK_HIDDEN RAID action request on SAS2 HBAs
      mpt3sas: Build MPI SGL LIST on GEN2 HBAs and IEEE SGL LIST on GEN3 HBAs
      mpt2sas, mpt3sas: Remove SCSI_MPTXSAS_LOGGING entry from Kconfig
      mpt3sas: Define 'hba_mpi_version_belonged' IOC variable
      mpt2sas: Remove .c and .h files from mpt2sas driver
      mpt2sas: Move Gen2 HBA's device registration to a separate file
      mpt3sas: Move Gen3 HBA's device registration to a separate file
      mpt3sas: Added mpt2sas driver definitions

Stephen Rothwell (1):
      mpt3sas: fix inline markers on non inline function declarations

Sudip Mukherjee (2):
      lpfc: fix memory leak and NULL dereference
      FlashPoint: fix build warning

Sumit Saxena (2):
      megaraid_sas: Fix sparse warning
      megaraid_sas: Make tape drives visible on PERC5 controllers

Tim Gardner (1):
      be2iscsi: Fix bogus WARN_ON length check

Tina Ruchandani (2):
      mvumi: 64bit value for seconds_since1970
      stex: Remove use of struct timeval

Tomas Henzl (1):
      hpsa: move lockup_detected attribute to host attr

Vitaly Kuznetsov (2):
      scsi_scan: don't dump trace when scsi_prep_async_scan() is called twice
      storvsc: get rid of bounce buffer

Yaniv Gardi (8):
      scsi: ufs-qcom: add QUniPro hardware support and power optimizations
      scsi: ufs-qcom: add debug prints for test bus
      scsi: ufs: make the UFS variant a platform device
      scsi: ufs: creates wrapper functions for vops
      scsi: ufs: add ufshcd_get_variant ufshcd_set_variant
      scsi: ufs-qcom: update configuration option of SCSI_UFS_QCOM component
      scsi: ufs-qcom: fix compilation warning if compiled as a module
      phy: qcom-ufs: fix build error when the component is built as a module

sumit.saxena@avagotech.com (22):
      megaraid_sas : Remove debug print from function megasas_update_span_set
      megaraid_sas : Driver version upgrade
      megaraid_sas : SMAP restriction--do not access user memory from IOCTL code
      megaraid_sas: Make PI enabled VD 8 byte DMA aligned
      megaraid_sas: Initialize tasklet before setting up IRQs
      megaraid_sas: Indicate online firmware upgrade support for Secure JBOD feature
      megaraid_sas: Update OCR capability on controller properties change
      megaraid_sas: Do not use PAGE_SIZE for max_sectors
      megaraid_sas: Support for Cutlass (12 Gbps) controller
      megaraid_sas: Support for Intruder (12 Gbps) controller
      megaraid_sas: Remove PCI id checks
      megaraid_sas: Expose TAPE drives unconditionally
      megaraid_sas: Version update
      megaraid_sas: Code refactor for use of requestorId
      megaraid_sas: Fix validHandles check in I/O path
      megaraid_sas: Print critical firmware event messages
      megaraid_sas: Chip reset if driver fails to get IOC ready
      megaraid_sas: Support for max_io_size 1MB
      megaraid_sas: Code cleanup-use local variable drv_ops inside megasas_ioc_init_fusion
      megaraid_sas: JBOD sequence number support
      megaraid_sas: Increase timeout to 60 secs for abort frames during shutdown
      megaraid_sas: Synchronize driver headers with firmware APIs

with the diffstat:

 Documentation/ABI/testing/sysfs-driver-st          |   12 +
 Documentation/devicetree/bindings/ufs/ufs-qcom.txt |   58 +
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   11 +-
 Documentation/scsi/st.txt                          |    4 +-
 drivers/ata/libata-scsi.c                          |    3 -
 drivers/infiniband/ulp/srp/ib_srp.c                |    5 -
 drivers/message/fusion/mptctl.c                    |    4 +
 drivers/message/fusion/mptsas.c                    |    1 -
 drivers/phy/phy-qcom-ufs.c                         |   11 +
 drivers/scsi/53c700.c                              |   11 +-
 drivers/scsi/FlashPoint.c                          |    2 +-
 drivers/scsi/Kconfig                               |    1 -
 drivers/scsi/Makefile                              |    1 -
 drivers/scsi/aacraid/aachba.c                      |  265 +-
 drivers/scsi/aacraid/aacraid.h                     |   20 +-
 drivers/scsi/aacraid/comminit.c                    |  147 +-
 drivers/scsi/aacraid/commsup.c                     |  113 +-
 drivers/scsi/aacraid/linit.c                       |  152 +
 drivers/scsi/aacraid/rx.c                          |    1 +
 drivers/scsi/aacraid/sa.c                          |    1 +
 drivers/scsi/aacraid/src.c                         |   64 +-
 drivers/scsi/advansys.c                            |    6 -
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |    1 -
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |    1 -
 drivers/scsi/aic94xx/aic94xx_init.c                |    3 +-
 drivers/scsi/be2iscsi/be_main.c                    |   64 +-
 drivers/scsi/be2iscsi/be_main.h                    |    7 +-
 drivers/scsi/be2iscsi/be_mgmt.c                    |   24 +-
 drivers/scsi/be2iscsi/be_mgmt.h                    |    7 +-
 drivers/scsi/bfa/bfad_im.c                         |    2 -
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h              |    6 +-
 drivers/scsi/bnx2fc/Kconfig                        |    5 +-
 drivers/scsi/bnx2fc/bnx2fc.h                       |    9 +-
 drivers/scsi/bnx2fc/bnx2fc_constants.h             |    6 +-
 drivers/scsi/bnx2fc/bnx2fc_debug.c                 |    6 +-
 drivers/scsi/bnx2fc/bnx2fc_debug.h                 |    6 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c                   |   10 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |   26 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |    6 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |  106 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                   |   12 +-
 drivers/scsi/csiostor/csio_scsi.c                  |    2 -
 drivers/scsi/esas2r/esas2r_main.c                  |    1 -
 drivers/scsi/esp_scsi.c                            |    1 -
 drivers/scsi/fcoe/fcoe.c                           |    4 +-
 drivers/scsi/fnic/fnic_main.c                      |    8 -
 drivers/scsi/hosts.c                               |    7 +
 drivers/scsi/hpsa.c                                | 1346 ++-
 drivers/scsi/hpsa.h                                |   47 +-
 drivers/scsi/hpsa_cmd.h                            |   30 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |    1 -
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   10 +-
 drivers/scsi/ibmvscsi/ibmvscsi.h                   |    1 +
 drivers/scsi/ipr.c                                 |  154 +-
 drivers/scsi/ipr.h                                 |   22 +-
 drivers/scsi/isci/init.c                           |    5 +-
 drivers/scsi/libfc/fc_npiv.c                       |    2 +-
 drivers/scsi/lpfc/lpfc_els.c                       |    8 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |    3 -
 drivers/scsi/megaraid/megaraid_sas.h               |   62 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  466 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c            |   28 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  404 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |   36 +-
 drivers/scsi/mpt2sas/Kconfig                       |   67 -
 drivers/scsi/mpt2sas/Makefile                      |    7 -
 drivers/scsi/mpt2sas/mpi/mpi2.h                    | 1170 ---
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h               | 3068 -------
 drivers/scsi/mpt2sas/mpi/mpi2_init.h               |  461 -
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h                | 1708 ----
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h               |  366 -
 drivers/scsi/mpt2sas/mpi/mpi2_sas.h                |  288 -
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h               |  481 --
 drivers/scsi/mpt2sas/mpi/mpi2_type.h               |   61 -
 drivers/scsi/mpt2sas/mpt2sas_base.c                | 4899 -----------
 drivers/scsi/mpt2sas/mpt2sas_base.h                | 1235 ---
 drivers/scsi/mpt2sas/mpt2sas_config.c              | 1527 ----
 drivers/scsi/mpt2sas/mpt2sas_ctl.c                 | 3101 -------
 drivers/scsi/mpt2sas/mpt2sas_ctl.h                 |  419 -
 drivers/scsi/mpt2sas/mpt2sas_debug.h               |  182 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               | 8855 --------------------
 drivers/scsi/mpt2sas/mpt2sas_transport.c           | 2173 -----
 drivers/scsi/mpt3sas/Kconfig                       |   18 +-
 drivers/scsi/mpt3sas/Makefile                      |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  668 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |  233 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |   42 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  259 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h                 |    6 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h               |   16 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               | 1555 ++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   18 +-
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c           |  344 +
 drivers/scsi/mvsas/mv_init.c                       |    3 +-
 drivers/scsi/mvumi.c                               |   10 +-
 drivers/scsi/pm8001/pm8001_defs.h                  |    2 +
 drivers/scsi/pm8001/pm8001_init.c                  |  216 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |    6 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   34 +
 drivers/scsi/pmcraid.c                             |    6 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    1 -
 drivers/scsi/qla4xxx/ql4_os.c                      |    8 -
 drivers/scsi/scsi.c                                |   27 +-
 drivers/scsi/scsi_scan.c                           |    9 +-
 drivers/scsi/scsi_sysfs.c                          |   56 +-
 drivers/scsi/sd.c                                  |    1 +
 drivers/scsi/sg.c                                  |    8 +-
 drivers/scsi/snic/snic_main.c                      |   10 -
 drivers/scsi/st.c                                  |   30 +
 drivers/scsi/stex.c                                |   21 +-
 drivers/scsi/storvsc_drv.c                         |  294 +-
 drivers/scsi/ufs/Kconfig                           |    2 +-
 drivers/scsi/ufs/ufs-qcom.c                        |  905 +-
 drivers/scsi/ufs/ufs-qcom.h                        |   68 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   98 +-
 drivers/scsi/ufs/ufshcd-pltfrm.h                   |   41 +
 drivers/scsi/ufs/ufshcd.c                          |  130 +-
 drivers/scsi/ufs/ufshcd.h                          |  149 +-
 drivers/target/loopback/tcm_loop.c                 |    1 -
 drivers/usb/storage/uas.c                          |    5 -
 include/scsi/scsi_host.h                           |    5 -
 include/scsi/scsi_tcq.h                            |   95 +-
 122 files changed, 6595 insertions(+), 32724 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-st
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-qcom.txt
 delete mode 100644 drivers/scsi/mpt2sas/Kconfig
 delete mode 100644 drivers/scsi/mpt2sas/Makefile
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_init.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_raid.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_sas.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_tool.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_type.h
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_base.c
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_base.h
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_config.c
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_ctl.c
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_ctl.h
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_debug.h
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_scsih.c
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_transport.c
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.h

James


