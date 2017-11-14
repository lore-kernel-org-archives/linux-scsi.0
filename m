From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.14+ merge window
Date: Tue, 14 Nov 2017 08:36:03 -0800
Message-ID: <1510677363.4078.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly updates of the usual suspects: lpfc, qla2xxx, hisi_sas,
megaraid_sas, pm80xx, mpt3sas, be2iscsi, hpsa. and a host of minor
updates.

There's no major behaviour change or additions to the core in all of
this, so the potential for regressions should be small (biggest
potential being in the scsi error handler changes).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alim Akhtar (4):
      scsi: ufs: Remove unused UFS_BIT() macro
      scsi: ufs: Remove unused #defines
      scsi: ufs-qcom: Remove uses of UFS_BIT() macro
      scsi: ufs: Change HCI macro to actual bit position

Arnd Bergmann (3):
      scsi: aacraid: use timespec64 instead of timeval
      scsi: mpt3sas: fix dma_addr_t casts
      scsi: nsp32: fix logic bug in error handling

Arvind Yadav (1):
      scsi: scsi_transport_iscsi: fix spelling mistake: 'Cound' -> 'Could'

Bader Ali Saleh (1):
      scsi: hpsa: update discovery polling

Bart Van Assche (1):
      scsi: qla2xxx: Suppress a kernel complaint in qla_init_base_qpair()

Cathy Avery (1):
      scsi: storvsc: Allow only one remove lun work item to be issued per lun

Christoph Hellwig (4):
      scsi: qla2xxx: don't break the bsg-lib abstractions
      scsi: scsi_transport_sas: check reply payload length instead of bidi request
      scsi: libfc: don't assign resid_len in fc_lport_bsg_request
      scsi: bfa: don't reset max_segments for every bsg request

Christos Gkekas (2):
      scsi: qedi: Delete redundant variables
      scsi: bnx2i: Clean up unused pointers in bnx2i_hwi

Colin Ian King (6):
      scsi: megaraid_sas: fix spelling mistake: "thershold" -> "threshold"
      scsi: aic7xxx: make a couple of functions static
      scsi: libsas: remove unused variable sas_ha
      scsi: libcxgbi: remove redundant check and close on csk
      scsi: ufs: tc-dwc-g210: make arrays static, reduces object code size
      scsi: lpfc: remove redundant null check on eqe

Damien Le Moal (6):
      scsi: sd_zbc: Fix sd_zbc_read_zoned_characteristics()
      scsi: sd_zbc: Use well defined macros
      scsi: sd_zbc: Rearrange code
      scsi: sd_zbc: Fix comments and indentation
      scsi: sd_zbc: Move ZBC declarations to scsi_proto.h
      scsi: sd: Align maximum write same blocks to physical block size

Dan Carpenter (4):
      scsi: mpt3sas: remove a stray KERN_INFO
      scsi: mpt3sas: cleanup _scsih_pcie_enumeration_event()
      scsi: lpfc: Fix a precedence bug in lpfc_nvme_io_cmd_wqe_cmpl()
      scsi: bfa: integer overflow in debugfs

Dick Kennedy (19):
      scsi: lpfc: Fix hard lock up NMI in els timeout handling.
      scsi: lpfc: change version to 11.4.0.4
      scsi: lpfc: Fix oops of nvme host during driver unload.
      scsi: lpfc: Extend RDP support
      scsi: lpfc: Ensure io aborts interlocked with the target.
      scsi: lpfc: Fix secure firmware updates
      scsi: lpfc: Fix crash in lpfc_nvme_fcp_io_submit during LIP
      scsi: lpfc: Disable NPIV support if NVME is enabled
      scsi: lpfc: Fix oops if nvmet_fc_register_targetport fails
      scsi: lpfc: Revise NVME module parameter descriptions for better clarity
      scsi: lpfc: Fix FCP hba_wqidx assignment
      scsi: lpfc: Move CQ processing to a soft IRQ
      scsi: lpfc: Make ktime sampling more accurate
      scsi: lpfc: PLOGI failures during NPIV testing
      scsi: lpfc: Fix warning messages when NVME_TARGET_FC not defined
      scsi: lpfc: Fix lpfc nvme host rejecting IO with Not Ready message
      scsi: lpfc: Fix crash receiving ELS while detaching driver
      scsi: lpfc: fix pci hot plug crash in list_add call
      scsi: lpfc: fix pci hot plug crash in timer management routines

Don Brace (10):
      scsi: hpsa: bump driver version
      scsi: hpsa: add enclosure logical identifier
      scsi: hpsa: correct logical volume removal
      scsi: hpsa: reduce warning messages on device removal
      scsi: hpsa: update queue depth for externals
      scsi: hpsa: correct smart path enabled
      scsi: hpsa: change timeout for internal cmds
      scsi: hpsa: add controller checkpoint
      scsi: smartpqi: correct spelling error in documentation
      scsi: smartpqi: update driver version to 1.1.2-126

Douglas Gilbert (1):
      scsi: scsi_debug: write_same: fix error report

Duane Grigsby (2):
      scsi: qla2xxx: Changes to support N2N logins
      scsi: qla2xxx: Allow MBC_GET_PORT_DATABASE to query and save the port states

Finn Thain (1):
      scsi: NCR5380: Suppress SDTR and WDTR message logging

Giridhar Malavali (1):
      scsi: qla2xxx: Query FC4 type during RSCN processing

Hannes Reinecke (14):
      scsi: scsi_error: Handle power-on reset unit attention
      scsi: scsi_error: Do not retry illegal function error
      scsi: scsi_devinfo: Add TRY_VPD_PAGES to HITACHI OPEN-V blacklist entry
      scsi: scsi_devinfo: Add 'AIX VDASD' to blacklist
      scsi: scsi_devinfo: fixup string compare
      scsi: scsi_devinfo: Whitespace fixes
      scsi: scsi_devinfo: Reformat blacklist flags
      scsi: scsi: Export blacklist flags to sysfs
      scsi: scsi_debug: allow to specify inquiry vendor and model
      scsi: scsi_dh: suppress errors from unsupported devices
      scsi: scsi_dh: Return SCSI_DH_XX error code from ->attach()
      scsi: fcoe: open-code fcoe_destroy_work() for NETDEV_UNREGISTER
      scsi: fcoe: separate out fcoe_vport_remove()
      scsi: fcoe: move fcoe_interface_remove() out of fcoe_interface_cleanup()

Himanshu Jha (1):
      scsi: be2iscsi: Use kasprintf

Himanshu Madhani (4):
      scsi: qla2xxx: Use ql2xnvmeenable to enable Q-Pair for FC-NVMe
      scsi: qla2xxx: Update driver version to 10.00.00.02-k
      scsi: qla2xxx: Add ATIO-Q processing for INTx mode
      scsi: qla2xxx: Reinstate module parameter ql2xenablemsix

Huanlin Ke (1):
      scsi: ufs: continue to boot even with Boot LUN is disabled

James Smart (4):
      scsi: scsi_transport_fc: add 64GBIT and 128GBIT port speed definitions
      scsi: lpfc: correct nvme sg segment count check
      scsi: lpfc: Set missing abort context
      scsi: lpfc: Reduce log spew on controller reconnects

Jason Yan (4):
      scsi: libsas: rename notify_port_event() for consistency
      scsi: libsas: remove unused port_gone_completion and DISCE_PORT_GONE
      scsi: libsas: remove the numbering for each event enum
      scsi: libsas: kill useless ha_event and do some cleanup

Jeffy Chen (1):
      scsi: scsi_devinfo: Add scsi_devinfo_tbl.c

Jitendra Bhivare (10):
      scsi: be2iscsi: Update driver version
      scsi: be2iscsi: Remove A-circumflex character in copyright marking
      scsi: be2iscsi: Fix misc static analysis errors
      scsi: be2iscsi: Add cmd to set host data
      scsi: be2iscsi: Modify IOCTL to fetch user configured IQN
      scsi: be2iscsi: Fix _get_initname buffer overflow
      scsi: be2iscsi: Fix _modify_eq_delay buffer overflow
      scsi: be2iscsi: Free msi_name and disable HW intr
      scsi: be2iscsi: Fix return value in mgmt_open_connection
      scsi: be2iscsi: Fix boot flags in sysfs

Kevin Barnett (2):
      scsi: smartpqi: cleanup raid map warning message
      scsi: smartpqi: update controller ids

Kurt Garloff (1):
      scsi: scsi_devinfo: Add REPORTLUN2 to EMC SYMMETRIX blacklist entry

Long Li (1):
      scsi: storvsc: Avoid excessive host scan on controller change

Martin K. Petersen (1):
      scsi: Clarify SCSI core module parameter documentation

Martin Wilck (2):
      scsi: hpsa: cleanup sas_phy structures in sysfs when unloading
      scsi: hpsa: destroy sas transport properties before scsi_host

Matthew R. Ochs (3):
      scsi: cxlflash: Derive pid through accessors
      scsi: cxlflash: Allow cards without WWPN VPD to configure
      scsi: cxlflash: Use derived maximum write same length

Meng Xu (1):
      scsi: mpt3sas: remove redundant copy_from_user in _ctl_getiocinfo

Petros Koutoupis (1):
      scsi: scsi_error: DID_SOFT_ERROR comment clean up

Randy Dunlap (2):
      scsi: update description of logging_level bits
      scsi: fix doc. typo for I2O

Scott Teel (1):
      scsi: hpsa: clear tmpdevice in scan thread

Shiju Jose (1):
      scsi: hisi_sas: use array for v2 hw AXI errors

Shivasharan S (19):
      scsi: megaraid_sas: driver version upgrade
      scsi: megaraid_sas: Add support for 64bit consistent DMA
      scsi: megaraid_sas: Do not limit queue_depth to 1k in non-RDPQ mode
      scsi: megaraid_sas: Retry with reduced queue depth when alloc fails for higher QD
      scsi: megaraid_sas: Incorrect processing of IOCTL frames for SMP/STP commands
      scsi: megaraid_sas: Resize MFA frame used for IOC INIT to 4k
      scsi: megaraid_sas: Update current host time to FW during IOC Init
      scsi: megaraid_sas: Move controller memory allocations and DMA mask settings from probe to megasas_init_fw
      scsi: megaraid_sas: Move initialization of instance parameters inside newly created function megasas_init_ctrl_params
      scsi: megaraid_sas: remove instance->ctrl_info
      scsi: megaraid_sas: Pre-allocate frequently used DMA buffers
      scsi: megaraid_sas: Create separate functions for allocating and freeing controller DMA buffers
      scsi: megaraid_sas: Create separate functions to allocate ctrl memory
      scsi: megaraid_sas: reduce size of fusion_context and use kmalloc for allocation
      scsi: megaraid_sas: replace is_ventura with adapter_type checks
      scsi: megaraid_sas: Remove redundant checks for ctrl_context
      scsi: megaraid_sas: replace instance->ctrl_context checks with instance->adapter_type
      scsi: megaraid_sas: Add support for Crusader controllers
      scsi: megaraid_sas: use adapter_type for all gen controllers

Sreekanth Reddy (10):
      scsi: mpt3sas: Bump mpt3sas driver version to v16.100.00.00
      scsi: mpt3sas: Adding support for SAS3616 HBA device
      scsi: mpt3sas: Fix possibility of using invalid Enclosure Handle for SAS device after host reset
      scsi: mpt3sas: Display chassis slot information of the drive
      scsi: mpt3sas: Updated MPI headers to v2.00.48
      scsi: mpt3sas: Fix IO error occurs on pulling out a drive from RAID1 volume created on two SATA drive
      scsi: mpt3sas: Fix removal and addition of vSES device during host reset
      scsi: mpt3sas: Reduce memory footprint in kdump kernel
      scsi: mpt3sas: Fixed memory leaks in driver
      scsi: mpt3sas: Processing of Cable Exception events

Suganath Prabu Subramani (13):
      scsi: mpt3sas: Update mpt3sas driver version.
      scsi: mpt3sas: Fix sparse warnings
      scsi: mpt3sas: Fix nvme drives checking for tlr.
      scsi: mpt3sas: NVMe drive support for BTDHMAPPING ioctl command and log info
      scsi: mpt3sas: Add-Task-management-debug-info-for-NVMe-drives.
      scsi: mpt3sas: scan and add nvme device after controller reset
      scsi: mpt3sas: Set NVMe device queue depth as 128
      scsi: mpt3sas: Handle NVMe PCIe device related events generated from firmware.
      scsi: mpt3sas: API's to remove nvme drive from sml
      scsi: mpt3sas: API 's to support NVMe drive addition to SML
      scsi: mpt3sas: Added support for nvme encapsulated request message.
      scsi: mpt3sas: SGL to PRP Translation for I/Os to NVMe devices
      scsi: mpt3sas: Add nvme device support in slave alloc, target alloc and probe

Thomas Meyer (2):
      scsi: qla2xxx: Cocci spatch "pool_zalloc-simple"
      scsi: lpfc: Cocci spatch "pool_zalloc-simple"

Varun Prakash (4):
      scsi: libcxgbi: simplify task->hdr allocation for mgmt cmds
      scsi: cxgb4i: fix Tx skb leak
      scsi: libcxgbi: in case of vlan pass 0 as ifindex to find route
      scsi: csiostor: enable PCIe relaxed ordering if supported

Vasyl Gomonovych (1):
      scsi: lpfc: fix kzalloc-simple.cocci warnings

Viswas G (9):
      scsi: pm80xx: corrected linkrate value.
      scsi: pm80xx: panic on ncq error cleaning up the read log.
      scsi: pm80xx: corrected SATA abort handling sequence.
      scsi: pm80xx: modified port reset timer value for PM8006 card
      scsi: pm80xx: cleanup in pm8001_abort_task function.
      scsi: pm80xx: tag allocation for phy control request.
      scsi: pm80xx: Different SAS addresses for phys.
      scsi: pm80xx: ILA and inactive firmware version through sysfs
      scsi: pm80xx: redefine sas_identify_frame structure

Xiang Chen (6):
      scsi: hisi_sas: fix a bug when free device for v3 hw
      scsi: hisi_sas: us start_phy in PHY_FUNC_LINK_RESET
      scsi: hisi_sas: fix SATA breakpoint memory size
      scsi: hisi_sas: grab hisi_hba.lock when processing slots
      scsi: hisi_sas: fix internal abort slot timeout bug
      scsi: hisi_sas: delete get_ncq_tag_v3_hw()

Xiaofei Tan (10):
      scsi: hisi_sas: add v3 hw port AXI error handling
      scsi: hisi_sas: add v3 hw support for AXI fatal error
      scsi: hisi_sas: complete all tasklets prior to host reset
      scsi: hisi_sas: add hisi_hba.rst_work init for v3 hw
      scsi: hisi_sas: add v3 hw DFX feature
      scsi: hisi_sas: init connect cfg register for v3 hw
      scsi: hisi_sas: check PHY state in get_wideport_bitmap_v3_hw()
      scsi: hisi_sas: fix the risk of freeing slot twice
      scsi: hisi_sas: fix NULL check in SMP abort task path
      scsi: hisi_sas: use spin_lock_irqsave() for hisi_hba.lock

Yisheng Xie (1):
      scsi: megaraid: Remove redundant code in megasas_alloc_cmds

Zang Leigang (2):
      scsi: ufs: add ufs a command complete time stamp
      scsi: ufs: fix a pclint warning

chenxiang (1):
      scsi: libsas: add event to defer list tail instead of head when draining

kehuanlin (1):
      scsi: ufs: fix wrong command type of UTRD for UFSHCI v2.1

weiping zhang (2):
      scsi: sd: change manage_start_stop to bool in sysfs interface
      scsi: sd: change allow_restart to bool in sysfs interface

And the diffstat:

 Documentation/driver-api/scsi.rst           |    2 +-
 Documentation/scsi/scsi-parameters.txt      |   13 +-
 Documentation/scsi/smartpqi.txt             |    2 +-
 drivers/scsi/.gitignore                     |    1 +
 drivers/scsi/Makefile                       |    8 +
 drivers/scsi/NCR5380.c                      |   18 +-
 drivers/scsi/aacraid/commsup.c              |   26 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c         |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c          |    2 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c          |    3 -
 drivers/scsi/be2iscsi/be.h                  |   19 +-
 drivers/scsi/be2iscsi/be_cmds.c             |   55 +-
 drivers/scsi/be2iscsi/be_cmds.h             |   48 +-
 drivers/scsi/be2iscsi/be_iscsi.c            |   54 +-
 drivers/scsi/be2iscsi/be_iscsi.h            |    2 +-
 drivers/scsi/be2iscsi/be_main.c             |  114 +-
 drivers/scsi/be2iscsi/be_main.h             |   51 +-
 drivers/scsi/be2iscsi/be_mgmt.c             |  278 ++--
 drivers/scsi/be2iscsi/be_mgmt.h             |   10 +-
 drivers/scsi/bfa/bfad_bsg.c                 |    7 -
 drivers/scsi/bfa/bfad_debugfs.c             |    5 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c              |   10 -
 drivers/scsi/csiostor/csio_hw.h             |    3 +
 drivers/scsi/csiostor/csio_init.c           |    3 +
 drivers/scsi/csiostor/csio_mb.c             |    3 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c          |    1 +
 drivers/scsi/cxgbi/libcxgbi.c               |   50 +-
 drivers/scsi/cxgbi/libcxgbi.h               |    1 -
 drivers/scsi/cxlflash/main.c                |   24 +-
 drivers/scsi/cxlflash/main.h                |    3 +-
 drivers/scsi/cxlflash/sislite.h             |    3 -
 drivers/scsi/cxlflash/superpipe.c           |    6 +-
 drivers/scsi/cxlflash/vlun.c                |    6 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |   10 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |    6 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   12 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    6 +-
 drivers/scsi/fcoe/fcoe.c                    |   81 +-
 drivers/scsi/hisi_sas/hisi_sas.h            |   13 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c       |   46 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c      |    2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |  253 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  257 ++-
 drivers/scsi/hpsa.c                         |  356 +++-
 drivers/scsi/hpsa_cmd.h                     |    3 +
 drivers/scsi/libfc/fc_lport.c               |    3 -
 drivers/scsi/libsas/sas_dump.c              |   10 -
 drivers/scsi/libsas/sas_dump.h              |    1 -
 drivers/scsi/libsas/sas_event.c             |   26 +-
 drivers/scsi/libsas/sas_init.c              |   12 -
 drivers/scsi/lpfc/lpfc.h                    |    3 +
 drivers/scsi/lpfc/lpfc_attr.c               |   10 +-
 drivers/scsi/lpfc/lpfc_bsg.c                |    4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c            |    9 +-
 drivers/scsi/lpfc/lpfc_els.c                |   19 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |    8 +-
 drivers/scsi/lpfc/lpfc_hw4.h                |    2 +-
 drivers/scsi/lpfc/lpfc_init.c               |   30 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c          |    2 +-
 drivers/scsi/lpfc/lpfc_nvme.c               |  174 +-
 drivers/scsi/lpfc/lpfc_nvmet.c              |  148 +-
 drivers/scsi/lpfc/lpfc_sli.c                |  232 ++-
 drivers/scsi/lpfc/lpfc_sli4.h               |    4 +-
 drivers/scsi/lpfc/lpfc_version.h            |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c              |    9 +
 drivers/scsi/megaraid/megaraid_sas.h        |   64 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 1025 +++++++-----
 drivers/scsi/megaraid/megaraid_sas_fp.c     |   20 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  676 ++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   29 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h             |   43 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h        |  564 ++++++-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h        |   11 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |  282 +++-
 drivers/scsi/mpt3sas/mpi/mpi2_pci.h         |  111 ++
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h        |   14 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  658 +++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  177 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |  100 ++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |  164 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 2355 +++++++++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c    |    2 +-
 drivers/scsi/nsp32.c                        |    2 +-
 drivers/scsi/pm8001/pm8001_ctl.c            |   54 +
 drivers/scsi/pm8001/pm8001_hwi.c            |   11 +-
 drivers/scsi/pm8001/pm8001_init.c           |   13 +-
 drivers/scsi/pm8001/pm8001_sas.c            |  124 +-
 drivers/scsi/pm8001/pm8001_sas.h            |   10 +
 drivers/scsi/pm8001/pm80xx_hwi.c            |   62 +-
 drivers/scsi/pm8001/pm80xx_hwi.h            |  102 +-
 drivers/scsi/qedi/qedi_fw.c                 |   17 +-
 drivers/scsi/qla2xxx/qla_bsg.c              |   13 +-
 drivers/scsi/qla2xxx/qla_def.h              |   29 +
 drivers/scsi/qla2xxx/qla_fw.h               |    4 +-
 drivers/scsi/qla2xxx/qla_gbl.h              |    5 +
 drivers/scsi/qla2xxx/qla_init.c             |  140 +-
 drivers/scsi/qla2xxx/qla_iocb.c             |  195 ++-
 drivers/scsi/qla2xxx/qla_isr.c              |   73 +-
 drivers/scsi/qla2xxx/qla_mbx.c              |  132 +-
 drivers/scsi/qla2xxx/qla_mid.c              |    2 +-
 drivers/scsi/qla2xxx/qla_mr.c               |    3 +-
 drivers/scsi/qla2xxx/qla_os.c               |   40 +-
 drivers/scsi/qla2xxx/qla_target.c           |   12 +-
 drivers/scsi/qla2xxx/qla_version.h          |    2 +-
 drivers/scsi/scsi_debug.c                   |   31 +-
 drivers/scsi/scsi_devinfo.c                 |   72 +-
 drivers/scsi/scsi_dh.c                      |   36 +-
 drivers/scsi/scsi_error.c                   |   13 +-
 drivers/scsi/scsi_lib.c                     |    9 +-
 drivers/scsi/scsi_logging.h                 |    8 +-
 drivers/scsi/scsi_priv.h                    |    4 +-
 drivers/scsi/scsi_scan.c                    |    1 +
 drivers/scsi/scsi_sysfs.c                   |   45 +-
 drivers/scsi/scsi_transport_fc.c            |    2 +
 drivers/scsi/scsi_transport_iscsi.c         |    2 +-
 drivers/scsi/scsi_transport_sas.c           |    2 +-
 drivers/scsi/sd.c                           |   32 +-
 drivers/scsi/sd_zbc.c                       |  169 +-
 drivers/scsi/smartpqi/smartpqi_init.c       |   18 +-
 drivers/scsi/storvsc_drv.c                  |   52 +-
 drivers/scsi/ufs/tc-dwc-g210.c              |   10 +-
 drivers/scsi/ufs/ufs-qcom.c                 |    4 +-
 drivers/scsi/ufs/ufs-qcom.h                 |    7 +-
 drivers/scsi/ufs/ufshcd.c                   |   40 +-
 drivers/scsi/ufs/ufshcd.h                   |   16 +-
 drivers/scsi/ufs/ufshci.h                   |   70 +-
 include/scsi/libsas.h                       |   56 +-
 include/scsi/scsi_device.h                  |    3 +-
 include/scsi/scsi_devinfo.h                 |   76 +-
 include/scsi/scsi_proto.h                   |   45 +-
 include/scsi/scsi_transport_fc.h            |    2 +
 131 files changed, 8278 insertions(+), 2473 deletions(-)
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_pci.h

James
