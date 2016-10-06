From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.8+ merge window
Date: Thu, 06 Oct 2016 15:03:03 +0800
Message-ID: <1475737383.11072.29.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This update includes the usual round of major driver updates (hpsa,
be2iscsi, hisi_sas, zfcp, cxlflash).  There's a new incarnation of hpsa
called smartpqi for which a driver is added, there's some cleanup work
of the ibm vscsi target and updates to libfc, plus a whole host of
minor fixes and updates and finally the removal of several ISA drivers
which seem not to have been used for years.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Baoyou Xie (10):
      scsi: mvsas: Mark symbols static where possible
      scsi: pm8001: Mark symbols static where possible
      scsi: lpfc: Mark symbols static where possible
      scsi: megaraid_sas: clean function declarations in megaraid_sas_base.c up
      scsi: bnx2fc: Mark symbols static where possible
      scsi: aacraid: mark aac_src_select_comm() static
      scsi: ufs: Add missing header dependencies for tc-dwc-g210
      scsi: pmcraid: mark symbols static where possible
      scsi: qla4xxx: Mark symbols static where possible
      scsi: move function declarations to scsi_priv.h

Bhaktipriya Shridhar (2):
      scsi: mpt: Remove deprecated create_singlethread_workqueue
      scsi: mptfc: Remove deprecated create_singlethread_workqueue

Borislav Petkov (1):
      scsi: arcmsr: Simplify user_len checking

Brian King (4):
      scsi: ibmvfc: Fix I/O hang when port is not mapped
      scsi: ipr: Remove redundant messages at adapter init time
      scsi: ipr: Don't log unnecessary 9084 error details
      scsi: ipr: Add asynchronous error notification

Bryant G. Ly (4):
      scsi: ibmvscsis: Fixed unused variable
      scsi: ibmvscsis: Fixed a bug reported by Dan Carpenter
      scsi: ibmvscsis: Code cleanup of print statements
      scsi: ibmvscsis: Properly deregister target sessions

Calvin Owens (4):
      mpt3sas: Fix warnings exposed by W=1
      mpt3sas: Eliminate dead sleep_flag code
      mpt3sas: Eliminate conditional locking in mpt3sas_scsih_issue_tm()
      mpt3sas: Ensure the connector_name string is NUL-terminated

Christoph Hellwig (10):
      scsi: dtc: remove from tree
      scsi: t128: remove from tree
      scsi: pas16: remove from tree
      scsi: u14-34f: remove from tree
      scsi: ultrastor: remove from tree
      scsi: in2000: remove from tree
      scsi: wd7000: remove from tree
      scsi: sd: Move DIF protection types to t10-pi.h
      scsi: qla2xxx: Use struct t10_pi_tuple
      scsi: scsi_debug: Use struct t10_pi_tuple instead of struct sd_dif_tuple

Christophe JAILLET (4):
      scsi: bnx2fc: Simplify code
      scsi: be2iscsi: Fix error return code
      scsi: megaraid_sas: Fix the search of first memory bar
      scsi: aic94xx: Add missing error code assignment before test

Colin Ian King (3):
      scsi: megaraid_sas: add in missing white space in error message text
      scsi: bfa: Do not dereference port before it is null checked
      scsi: qla2xxx: fix spelling mistake "retyring" -> "retrying"

Dan Carpenter (2):
      scsi: arcmsr: Buffer overflow in arcmsr_iop_message_xfer()
      qla2xxx: small cleanup in qla2x00_wait_for_hba_ready()

Daniel Wagner (3):
      scsi: virtio_scsi: Use complete() instead complete_all()
      scsi: sym53c8xx_2: Use complete() instead complete_all()
      scsi: csiostor: Fix completion usage

Don Brace (5):
      scsi: hpsa: correct call to hpsa_do_reset
      scsi: hpsa: Check for null devices in ioaccel submission patch
      scsi: hpsa: Check for null device pointers
      scsi: hpsa: Determine device external status earlier
      scsi: smartpqi: add smartpqi.txt

Finn Thain (3):
      scsi: ncr5380: Improve interrupt latency during PIO tranfers
      scsi: ncr5380: Avoid a compiler warning
      scsi: Documentation/scsi: Remove nodisconnect parameter

Hannes Reinecke (4):
      scsi: libfc: do not send ABTS when resetting exchanges
      scsi: libfc: reset exchange manager during LOGO handling
      scsi: libfc: send LOGO for PLOGI failure
      scsi: libfc: Issue PRLI after a PRLO has been received

Heiner Kallweit (1):
      scsi: configure runtime pm before calling device_add in scsi_add_host_with_dma

Jitendra Bhivare (31):
      scsi: be2iscsi: Add missing unlock for mbox_lock
      scsi: be2iscsi: Remove redundant iscsi_wrb desc memset
      MAINTAINERS: Update be2iscsi contact info
      scsi: be2iscsi: Update the driver version
      scsi: be2iscsi: Update copyright information
      scsi: be2iscsi: Fix queue and connection parameters
      scsi: be2iscsi: Fix bad WRB index error
      scsi: be2iscsi: Fix async PDU handling path
      scsi: be2iscsi: Add FUNCTION_RESET during driver unload
      scsi: be2iscsi: Fail the sessions immediately after TPE
      scsi: be2iscsi: Add TPE recovery feature
      scsi: be2iscsi: Add V1 of EPFW cleanup IOCTL
      scsi: be2iscsi: Fix POST check and reset sequence
      scsi: be2iscsi: Move functions to right files
      scsi: be2iscsi: Add IOCTL to check UER supported
      scsi: be2iscsi: Fix to add timer for UE detection
      scsi: be2iscsi: Fix to make boot discovery non-blocking
      scsi: be2iscsi: Fix checks for HBA in error state
      scsi: be2iscsi: Remove isr_lock and dead code
      scsi: be2iscsi: Remove alloc_mcc_tag & beiscsi_pci_soft_reset
      scsi: be2iscsi: Check all zeroes IP before issuing IOCTL
      scsi: be2iscsi: Handle only NET_PARAM in iface_get_param
      scsi: be2iscsi: Rename iface get/set/create/destroy APIs
      scsi: be2iscsi: Update iface handle before any set param
      scsi: be2iscsi: Move VLAN code to common iface_set_param
      scsi: be2iscsi: Fix release of DHCP IP in static mode
      scsi: be2iscsi: Fix gateway APIs to support IPv4 & IPv6
      scsi: be2iscsi: Set and return right iface v4/v6 states
      scsi: be2iscsi: Reduce driver load/unload time
      scsi: be2iscsi: Replace _bh version for mcc_lock spinlock
      scsi: be2iscsi: Fix to use correct configuration values

Johannes Thumshirn (2):
      scsi: fcoe: provide translation table between Ethernet and FC port speeds
      mpt3sas: Don't spam logs if logging level is 0

John Garry (23):
      scsi: hisi_sas: send three identify before phy up
      scsi: hisi_sas: add missing SATA pending device type to v2 hw
      scsi: hisi_sas: remove init_id_frame_v1_hw()
      scsi: hisi_sas: remove init_id_frame_v2_hw()
      scsi: hisi_sas: fix HBA SAS addr endianness for v1 hw
      scsi: hisi_sas: fix HBA SAS addr endianness for v2 hw
      scsi: hisi_sas: set dma mask before allocate DMA memory
      scsi: hisi_sas: fix a potential warning for sata disk ejection
      scsi: hisi_sas: fix phy8 linkrate calculation in phy_up_v2_hw()
      scsi: hisi_sas: disable dlvry queues once at reset for v2 hw
      scsi: hisi_sas: use safe BITS_PER_BYTE for slot tag size calculation
      scsi: hisi_sas: only zero slot memory when reused
      scsi: hisi_sas: keep CHL_INT2 masked for v2 HW
      scsi: hisi_sas: save delivery queue write pointer
      scsi: hisi_sas: save completion queue read pointer
      scsi: hisi_sas: update version to 1.6
      scsi: hisi_sas: add TMF success check
      scsi: hisi_sas: fail tmf task prep when port detached
      scsi: hisi_sas: add v2 hw slot complete internal abort support
      scsi: hisi_sas: add prep_abort_v2_hw()
      scsi: hisi_sas: add internal abort to hisi_sas_abort_task()
      scsi: hisi_sas: add internal abort in hisi_sas_dev_gone()
      scsi: hisi_sas: add internal abort main code

Julia Lawall (1):
      scsi: sr: constify sr_pm_ops structure

Kevin Barnett (15):
      scsi: smartpqi: bump driver version
      scsi: smartpqi: update Kconfig
      scsi: smartpqi: remove timeout for cache flush operations
      scsi: smartpqi: scsi queuecommand cleanup
      scsi: smartpqi: minor tweaks to update time support
      scsi: smartpqi: minor function reformating
      scsi: smartpqi: correct event acknowledgment timeout issue
      scsi: smartpqi: correct controller offline issue
      scsi: smartpqi: add kdump support
      scsi: smartpqi: enhance reset logic
      scsi: smartpqi: enhance drive offline informational message
      scsi: smartpqi: simplify spanning
      scsi: smartpqi: change tmf macro names
      scsi: smartpqi: change aio sg processing
      smartpqi: initial commit of Microsemi smartpqi driver

Kiwoong Kim (2):
      scsi: ufs: Get a TM service response from the correct offset
      scsi: ufs: Fix a wrong string in power mode change

Mahesh Rajashekhara (1):
      scsi: hpsa: correct scsi 6byte lba calculation

Markus Elfring (1):
      scsi: megaraid_sas: Use memdup_user() rather than duplicating its implementation

Matthew R. Ochs (10):
      scsi: cxlflash: Fix context reference tracking on detach
      scsi: cxlflash: Refactor WWPN setup
      scsi: cxlflash: Improve EEH recovery time
      scsi: cxlflash: Fix to avoid EEH and host reset collisions
      scsi: cxlflash: Update documentation
      scsi: cxlflash: Remove adapter file descriptor cache
      scsi: cxlflash: Transition to application close model
      scsi: cxlflash: Add kref to context
      scsi: cxlflash: Cache owning adapter within context
      scsi: cxlflash: Avoid mutex when destroying context

Paul Burton (2):
      scsi: sg: Use mult_frac, drop MULDIV macro
      scsi: sg: Avoid overflow when USER_HZ > HZ

Scott Teel (2):
      scsi: hpsa: Prevent sending bmic commands to externals
      scsi: hpsa: Check for vpd support before sending

Shawn Lin (2):
      scsi: esas2r: don't reinitialize adapter's req_table
      scsi: esas2r: not need to alloc zero buffer for local_atto_ioctl

Steffen Maier (10):
      zfcp: trace full payload of all SAN records (req,resp,iels)
      zfcp: fix payload trace length for SAN request&response
      zfcp: fix D_ID field with actual value on tracing SAN responses
      zfcp: restore tracing of handle for port and LUN with HBA records
      zfcp: trace on request for open and close of WKA port
      zfcp: restore: Dont use 0 to indicate invalid LUN in rec trace
      zfcp: retain trace level for SCSI and HBA FSF response records
      zfcp: close window with unblocked rport during rport gone
      zfcp: fix ELS/GS request&response length for hardware data router
      zfcp: fix fc_host port_type with NPIV

Tyrel Datwyler (2):
      scsi: ibmvfc: add FC Class 3 Error Recovery support
      scsi: ibmvfc: Set READ FCP_XFER_READY DISABLED bit in PRLI

Uma Krishnan (2):
      scsi: cxlflash: Remove the device cleanly in the system shutdown path
      scsi: cxlflash: Scan host only after the port is ready for I/O

Vincent Stehlé (1):
      scsi: fcoe: fix off by one in eth2fc_speed()

Wei Yongjun (4):
      scsi: ibmvscsis: Fix error return code in ibmvscsis_probe()
      scsi: fusion: Fix error return code in mptfc_probe()
      scsi: ibmvfc: fix typo in parameter description
      scsi: ibmvscsis: Use list_move_tail instead of list_del/list_add_tail

kevin Barnett (1):
      scsi: smartpqi: raid bypass lba calculation fix

tang.junhui (1):
      scsi: scsi_dh_alua: Fix memory leak in alua_rtpg()

And the diffstat:

 Documentation/kernel-parameters.txt            |    2 -
 Documentation/powerpc/cxlflash.txt             |   44 +-
 Documentation/scsi/00-INDEX                    |    2 -
 Documentation/scsi/dtc3x80.txt                 |   43 -
 Documentation/scsi/in2000.txt                  |  202 -
 Documentation/scsi/scsi-parameters.txt         |   20 -
 Documentation/scsi/smartpqi.txt                |   80 +
 MAINTAINERS                                    |   38 +-
 drivers/message/fusion/mptbase.c               |    7 +-
 drivers/message/fusion/mptfc.c                 |    7 +-
 drivers/s390/scsi/zfcp_dbf.c                   |  162 +-
 drivers/s390/scsi/zfcp_dbf.h                   |   14 +-
 drivers/s390/scsi/zfcp_erp.c                   |   12 +-
 drivers/s390/scsi/zfcp_ext.h                   |    8 +-
 drivers/s390/scsi/zfcp_fsf.c                   |   22 +-
 drivers/s390/scsi/zfcp_fsf.h                   |    4 +-
 drivers/s390/scsi/zfcp_scsi.c                  |    8 +-
 drivers/scsi/Kconfig                           |  136 +-
 drivers/scsi/Makefile                          |    8 +-
 drivers/scsi/NCR5380.c                         |   15 +-
 drivers/scsi/NCR5380.h                         |   10 +-
 drivers/scsi/aacraid/src.c                     |    2 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c             |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c               |   12 +-
 drivers/scsi/be2iscsi/be.h                     |   15 +-
 drivers/scsi/be2iscsi/be_cmds.c                | 1096 ++--
 drivers/scsi/be2iscsi/be_cmds.h                |  142 +-
 drivers/scsi/be2iscsi/be_iscsi.c               |  408 +-
 drivers/scsi/be2iscsi/be_iscsi.h               |   25 +-
 drivers/scsi/be2iscsi/be_main.c                | 2480 +++++-----
 drivers/scsi/be2iscsi/be_main.h                |  220 +-
 drivers/scsi/be2iscsi/be_mgmt.c                | 1497 +++---
 drivers/scsi/be2iscsi/be_mgmt.h                |   51 +-
 drivers/scsi/bfa/bfa_fcs_lport.c               |    4 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c               |    4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c              |   12 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c               |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                |    2 +-
 drivers/scsi/csiostor/csio_scsi.c              |    5 +-
 drivers/scsi/cxlflash/main.c                   |   81 +-
 drivers/scsi/cxlflash/superpipe.c              |  180 +-
 drivers/scsi/cxlflash/superpipe.h              |    3 +-
 drivers/scsi/cxlflash/vlun.c                   |   13 +-
 drivers/scsi/device_handler/scsi_dh_alua.c     |    1 +
 drivers/scsi/dtc.c                             |  447 --
 drivers/scsi/dtc.h                             |   42 -
 drivers/scsi/esas2r/esas2r_init.c              |    4 -
 drivers/scsi/esas2r/esas2r_main.c              |    2 +-
 drivers/scsi/fcoe/fcoe_transport.c             |   53 +-
 drivers/scsi/hisi_sas/hisi_sas.h               |   18 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c          |  238 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c         |   36 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c         |  130 +-
 drivers/scsi/hosts.c                           |   12 +-
 drivers/scsi/hpsa.c                            |  139 +-
 drivers/scsi/hpsa.h                            |    1 -
 drivers/scsi/hpsa_cmd.h                        |    1 +
 drivers/scsi/ibmvscsi/ibmvfc.c                 |   12 +-
 drivers/scsi/ibmvscsi/ibmvfc.h                 |    1 +
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c       |   37 +-
 drivers/scsi/in2000.c                          | 2302 ---------
 drivers/scsi/in2000.h                          |  412 --
 drivers/scsi/ipr.c                             |  134 +-
 drivers/scsi/ipr.h                             |    8 +-
 drivers/scsi/libfc/fc_exch.c                   |    1 -
 drivers/scsi/libfc/fc_rport.c                  |   26 +-
 drivers/scsi/lpfc/lpfc_ct.c                    |   82 +-
 drivers/scsi/lpfc/lpfc_els.c                   |   34 +-
 drivers/scsi/lpfc/lpfc_mbox.c                  |    4 +-
 drivers/scsi/lpfc/lpfc_sli.c                   |    4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c      |   28 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h    |    9 +
 drivers/scsi/mpt3sas/mpt3sas_base.c            |  259 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h            |   24 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c          |    7 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c             |   49 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c           |  169 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c       |   28 +-
 drivers/scsi/mvsas/mv_64xx.c                   |   19 +-
 drivers/scsi/mvsas/mv_94xx.c                   |   41 +-
 drivers/scsi/mvsas/mv_sas.c                    |   16 +-
 drivers/scsi/pas16.c                           |  565 ---
 drivers/scsi/pas16.h                           |  121 -
 drivers/scsi/pm8001/pm8001_hwi.c               |    4 +-
 drivers/scsi/pm8001/pm8001_sas.c               |    2 +-
 drivers/scsi/pmcraid.c                         |    8 +-
 drivers/scsi/qla2xxx/qla_def.h                 |   10 -
 drivers/scsi/qla2xxx/qla_isr.c                 |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                  |   18 +-
 drivers/scsi/qla4xxx/ql4_nx.c                  |    2 +-
 drivers/scsi/scsi_debug.c                      |   54 +-
 drivers/scsi/scsi_priv.h                       |    2 +
 drivers/scsi/scsi_scan.c                       |    2 -
 drivers/scsi/sd.c                              |   11 +-
 drivers/scsi/sd.h                              |   30 -
 drivers/scsi/sd_dif.c                          |   10 +-
 drivers/scsi/sg.c                              |   20 +-
 drivers/scsi/smartpqi/Kconfig                  |   54 +
 drivers/scsi/smartpqi/Makefile                 |    3 +
 drivers/scsi/smartpqi/smartpqi.h               | 1136 +++++
 drivers/scsi/smartpqi/smartpqi_init.c          | 6303 ++++++++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |  350 ++
 drivers/scsi/smartpqi/smartpqi_sis.c           |  404 ++
 drivers/scsi/smartpqi/smartpqi_sis.h           |   34 +
 drivers/scsi/sr.c                              |    2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c            |    2 +-
 drivers/scsi/t128.c                            |  407 --
 drivers/scsi/t128.h                            |   97 -
 drivers/scsi/u14-34f.c                         | 1971 --------
 drivers/scsi/ufs/tc-dwc-g210.c                 |    1 +
 drivers/scsi/ufs/ufs.h                         |    1 +
 drivers/scsi/ufs/ufshcd.c                      |    6 +-
 drivers/scsi/ultrastor.c                       | 1210 -----
 drivers/scsi/ultrastor.h                       |   80 -
 drivers/scsi/virtio_scsi.c                     |    2 +-
 drivers/scsi/wd7000.c                          | 1657 -------
 include/linux/t10-pi.h                         |   20 +
 include/uapi/scsi/cxlflash_ioctl.h             |   19 +-
 118 files changed, 12923 insertions(+), 13627 deletions(-)
 delete mode 100644 Documentation/scsi/dtc3x80.txt
 delete mode 100644 Documentation/scsi/in2000.txt
 create mode 100644 Documentation/scsi/smartpqi.txt
 delete mode 100644 drivers/scsi/dtc.c
 delete mode 100644 drivers/scsi/dtc.h
 delete mode 100644 drivers/scsi/in2000.c
 delete mode 100644 drivers/scsi/in2000.h
 delete mode 100644 drivers/scsi/pas16.c
 delete mode 100644 drivers/scsi/pas16.h
 create mode 100644 drivers/scsi/smartpqi/Kconfig
 create mode 100644 drivers/scsi/smartpqi/Makefile
 create mode 100644 drivers/scsi/smartpqi/smartpqi.h
 create mode 100644 drivers/scsi/smartpqi/smartpqi_init.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sas_transport.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.h
 delete mode 100644 drivers/scsi/t128.c
 delete mode 100644 drivers/scsi/t128.h
 delete mode 100644 drivers/scsi/u14-34f.c
 delete mode 100644 drivers/scsi/ultrastor.c
 delete mode 100644 drivers/scsi/ultrastor.h
 delete mode 100644 drivers/scsi/wd7000.c

James
