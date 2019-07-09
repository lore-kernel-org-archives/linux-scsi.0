From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.2+ merge window
Date: Tue, 09 Jul 2019 12:14:53 -0700
Message-ID: <1562699693.3362.93.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly update of the usual drivers: qla2xxx, hpsa, lpfc, ufs,
mpt3sas, ibmvscsi, megaraid_sas, bnx2fc and hisi_sas as well as the
removal of the osst driver (I heard from Willem privately that he would
like the driver removed because all his test hardware has
failed).  Plus number of minor changes, spelling fixes and other
trivia.

The big merge conflict this time around is the SPDX licence tags. 
Following discussion on linux-next, we believe our version to be more
accurate than the one in the tree, so the resolution is to take our
version for all the SPDX conflicts.  You can do a git checkout --theirs 
for everything, although there is one non-SPDX conflict which is also a
theirs resolution:

lpfc_version.h: use version 12.2.0.3; it's a conflict from our own
fixes branch, sorry about that.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (1):
      scsi: ufshdc-pci: Add Intel PCI IDs for EHL

Arthur Simchaev (1):
      scsi: ufs: Documentation: Announce ufs-tool v1.0

Arun Easi (1):
      scsi: qla2xxx: Fix kernel crash after disconnecting NVMe devices

Bart Van Assche (5):
      scsi: RDMA/srp: Fix a sleep-in-invalid-context bug
      scsi: Avoid that .queuecommand() gets called for a blocked SCSI device
      scsi: Restrict user space SCSI device state changes to "running" and "offline"
      scsi: sd: Inline sd_probe_part2()
      scsi: sd: Rely on the driver core for asynchronous probing

Bean Huo (2):
      scsi: ufs-bsg: complete ufs-bsg job only if no error
      scsi: ufs-bsg: fix typo in ufs_bsg_request

Bharath Vedartham (1):
      scsi: message: fusion: Use kmemdup instead of memcpy and kmalloc

Branden Bonaby (1):
      scsi: storvsc: Add ability to change scsi queue depth

Chad Dupuis (2):
      scsi: bnx2fc: Only put reference to io_req in bnx2fc_abts_cleanup if cleanup times out
      scsi: bnx2fc: Redo setting source FCoE MAC

Chandrakanth Patil (18):
      scsi: megaraid_sas: Update driver version to 07.710.06.00-rc1
      scsi: megaraid_sas: Introduce various Aero performance modes
      scsi: megaraid_sas: Use high IOPS queues based on IO workload
      scsi: megaraid_sas: Set affinity for high IOPS reply queues
      scsi: megaraid_sas: Enable coalescing for high IOPS queues
      scsi: megaraid_sas: Add support for High IOPS queues
      scsi: megaraid_sas: Add support for MPI toolbox commands
      scsi: megaraid_sas: Offload Aero RAID5/6 division calculations to driver
      scsi: megaraid_sas: RAID1 PCI bandwidth limit algorithm is applicable for only Ventura
      scsi: megaraid_sas: megaraid_sas: Add check for count returned by HOST_DEVICE_LIST DCMD
      scsi: megaraid_sas: Handle sequence JBOD map failure at driver level
      scsi: megaraid_sas: Don't send FPIO to RL Bypass queue
      scsi: megaraid_sas: In probe context, retry IOC INIT once if firmware is in fault
      scsi: megaraid_sas: Release Mutex lock before OCR in case of DCMD timeout
      scsi: megaraid_sas: Call disable_irq from process IRQ poll
      scsi: megaraid_sas: Remove few debug counters from IO path
      scsi: megaraid_sas: Add support for Non-secure Aero PCI IDs
      scsi: megaraid_sas: Add 32 bit atomic descriptor support to AERO adapters

Christoph Hellwig (23):
      scsi: st: add a SPDX tag to st.c
      scsi: sr: add a SPDX tag to sr.c
      scsi: sg: switch to SPDX tags
      scsi: ses: switch to SPDX tags
      scsi: sd: switch remaining files to SPDX tags
      scsi: sd: add a SPDX tag to sd.c
      scsi: libsas: switch remaining files to SPDX tags
      scsi: libsas: switch sas_ata.[ch] to SPDX tags
      scsi: libsas: add a SPDX tag to sas_task.c
      scsi: libiscsi: switch to SPDX tags
      scsi: libfcoe: switch to SPDX tags
      scsi: libfc: switch to SPDX tags
      scsi: libfc: remove duplicate GPL boilerplate text
      scsi: scsi_transport_srp: switch to SPDX tags
      scsi: scsi_transport_spi: switch to SPDX tags
      scsi: scsi_transport_sas: switch to SPDX tags
      scsi: scsi_transport_iscsi: switch to SPDX tags
      scsi: scsi_transport_fc: switch to SPDX tags
      scsi: scsi_transport_fc: remove duplicate GPL boilerplate text
      scsi: scsi_transport.h: switch to SPDX tags
      scsi: scsi_netlink: remove duplicate GPL boilerplate text
      scsi: core: switch the remaining scsi midlayer files to use SPDX tags
      scsi: core: add SPDX tags to scsi midlayer files missing licensing information

Christophe JAILLET (1):
      scsi: tcmu: Simplify tcmu_update_uio_info()

Colin Ian King (1):
      scsi: hpsa: fix an uninitialized read and dereference of pointer dev

Deepak Ukey (2):
      scsi: pm80xx: Modified the logic to collect IOP event logs
      scsi: pm80xx: Event log size through sysfs

Don Brace (7):
      scsi: hpsa: update driver version
      scsi: hpsa: correct device resets
      scsi: hpsa: do-not-complete-cmds-for-deleted-devices
      scsi: hpsa: wait longer for ptraid commands
      scsi: hpsa: check for tag collision
      scsi: hpsa: use local workqueues instead of system workqueues
      scsi: hpsa: correct simple mode

Dongli Zhang (1):
      scsi: virtio_scsi: remove unused 'affinity_hint_set'

Enzo Matsumiya (1):
      scsi: qla2xxx: remove double assignment in qla2x00_update_fcport

Finn Thain (7):
      scsi: mac_scsi: Treat Last Byte Sent time-out as failure
      scsi: mac_scsi: Enable PDMA on Mac IIfx
      scsi: mac_scsi: Fix pseudo DMA implementation, take 2
      scsi: mac_scsi: Increase PIO/PDMA transfer length threshold
      scsi: NCR5380: Handle PDMA failure reliably
      scsi: NCR5380: Always re-enable reselection interrupt
      Revert "scsi: ncr5380: Increase register polling limit"

Geert Uytterhoeven (2):
      scsi: isci: Grammar s/the its/its/
      scsi: aic7xxx: Spelling s/configuraion/configuration/

Gen Zhang (1):
      scsi: mpt3sas_ctl: fix double-fetch bug in _ctl_ioctl_main()

Gustavo A. R. Silva (2):
      scsi: megaraid_sas: Use struct_size() helper
      scsi: mpt3sas: Mark expected switch fall-through

Hannes Reinecke (1):
      scsi: osst: kill obsolete driver

Hariprasad Kelam (1):
      scsi: target/iscsi: fix possible condition with no effect (if == else)

Jack Wang (1):
      scsi: MAINTAINERS: update maintainer for PM8001

James Smart (21):
      scsi: lpfc: Update lpfc version to 12.2.0.3
      scsi: lpfc: Fix kernel warnings related to smp_processor_id()
      scsi: lpfc: Fix BFS crash with DIX enabled
      scsi: lpfc: Fix FDMI fc4type for nvme support
      scsi: lpfc: Fix fcp_rsp_len checking on lun reset
      scsi: lpfc: Fix poor use of hardware queues if fewer irq vectors
      scsi: lpfc: Fix oops when driver is loaded with 1 interrupt vector
      scsi: lpfc: Fix incorrect logical link speed on trunks when links down
      scsi: lpfc: Fix memory leak in abnormal exit path from lpfc_eq_create
      scsi: lpfc: Rework misleading nvme not supported in firmware message
      scsi: lpfc: Fix hardlockup in scsi_cmd_iocb_cmpl
      scsi: lpfc: Cancel queued work for an IO when processing a received ABTS
      scsi: lpfc: Prevent 'use after free' memory overwrite in nvmet LS handling
      scsi: lpfc: Fix PT2PT PLOGI collison stopping discovery
      scsi: lpfc: Revert message logging on unsupported topology
      scsi: lpfc: Fix nvmet handling of received ABTS for unmapped frames
      scsi: lpfc: Separate CQ processing for nvmet_fc upcalls
      scsi: lpfc: Revise message when stuck due to unresponsive adapter
      scsi: lpfc: Correct nvmet buffer free race condition
      scsi: lpfc: Fix nvmet target abort cmd matching
      scsi: lpfc: Fix alloc context on oas lun creations

Jason Yan (1):
      scsi: libsas: no need to join wide port again in sas_ex_discover_dev()

John Garry (2):
      scsi: libsas: aic94xx: hisi_sas: mvsas: pm8001: Use dev_is_expander()
      scsi: hisi_sas: Reduce HISI_SAS_SGE_PAGE_CNT in size

Lee Jones (1):
      scsi: ufs-qcom: Add support for platforms booting ACPI

Lin Yi (2):
      scsi: bnx2fc: fix bnx2fc_cmd refcount imbalance in send_srr
      scsi: bnx2fc: fix bnx2fc_cmd refcount imbalance in send_rec

Luo Jiaxing (1):
      scsi: hisi_sas: Ignore the error code between phy down to phy up

Nathan Chancellor (2):
      scsi: lpfc: Avoid unused function warnings
      scsi: ibmvscsi: Don't use rc uninitialized in ibmvscsi_do_work

Ondrej Zary (6):
      scsi: wd719x: Fix resets and aborts
      scsi: fdomain: Add PCMCIA support
      scsi: fdomain: Add register definitions
      scsi: fdomain: Resurrect driver - ISA support
      scsi: fdomain: Resurrect driver - PCI support
      scsi: fdomain: Resurrect driver - Core

Quinn Tran (3):
      scsi: qla2xxx: move IO flush to the front of NVME rport unregistration
      scsi: qla2xxx: Fix NVME cmd and LS cmd timeout race condition
      scsi: qla2xxx: on session delete, return nvme cmd

Saurav Kashyap (4):
      scsi: bnx2fc: Update the driver version to 2.12.10
      scsi: bnx2fc: Limit the IO size according to the FW capability
      scsi: bnx2fc: Do not allow both a cleanup completion and abort completion for the same request
      scsi: bnx2fc: Separate out completion flags and variables for abort and cleanup

Shivasharan S (20):
      scsi: megaraid_sas: Update driver version to 07.708.03.00
      scsi: megaraid_sas: Export RAID map through debugfs
      scsi: megaraid_sas: Fix MSI-X vector print
      scsi: megaraid_sas: Add debug prints for device list
      scsi: megaraid_sas: Add prints in suspend and resume path
      scsi: megaraid_sas: Print firmware interrupt status
      scsi: megaraid_sas: Print FW fault information
      scsi: megaraid_sas: Export RAID map id through sysfs
      scsi: megaraid_sas: Print BAR information from driver
      scsi: megaraid_sas: Dump system registers for debugging
      scsi: megaraid_sas: Dump system interface regs from sysfs
      scsi: megaraid_sas: Add formatting option for megasas_dump
      scsi: megaraid_sas: Enhance internal DCMD timeout prints
      scsi: megaraid_sas: Enhance prints in OCR and TM path
      scsi: megaraid_sas: Load balance completions across all MSI-X
      scsi: megaraid_sas: IRQ poll to avoid CPU hard lockups
      scsi: megaraid_sas: Block PCI config space access from userspace during OCR
      scsi: megaraid_sas: Rework code around controller reset
      scsi: megaraid_sas: fw_reset_no_pci_access required for MFI adapters only
      scsi: megaraid_sas: Remove unused variable target_index

Sreekanth Reddy (4):
      scsi: mpt3sas: Fix msix load balance on and off settings
      scsi: mpt3sas: Determine smp affinity on per HBA basis
      scsi: mpt3sas: Use configured PCIe link speed, not max
      scsi: mpt3sas: Remove CPU arch check to determine perf_mode

Stanley Chu (3):
      scsi: ufs: Add error-handling of Auto-Hibernate
      scsi: ufs: Do not overwrite Auto-Hibernate timer
      scsi: ufs: Introduce ufshcd_is_auto_hibern8_supported()

Suganath Prabu S (10):
      scsi: mpt3sas: Update driver version to 29.100.00.00
      scsi: mpt3sas: Introduce perf_mode module parameter
      scsi: mpt3sas: Enable interrupt coalescing on high iops
      scsi: mpt3sas: Affinity high iops queues IRQs to local node
      scsi: mpt3sas: save and use MSI-X index for posting RD
      scsi: mpt3sas: Use high iops queues under some circumstances
      scsi: mpt3sas: change _base_get_msix_index prototype
      scsi: mpt3sas: Add flag high_iops_queues
      scsi: mpt3sas: Add Atomic RequestDescriptor support on Aero
      scsi: mpt3sas: function pointers of request descriptor

Thomas Meyer (1):
      scsi: lpfc: Use *_pool_zalloc rather than *_pool_alloc

Tomas Henzl (5):
      scsi: mpt3sas: use DEVICE_ATTR_{RO, RW}
      scsi: mpt3sas: make driver options visible in sys
      scsi: megaraid_sas: use DEVICE_ATTR_{RO, RW}
      scsi: megaraid_sas: use octal permissions instead of constants
      scsi: megaraid_sas: make max_sectors visible in sys

Tyrel Datwyler (3):
      scsi: ibmvscsi: fix tripping of blk_mq_run_hw_queue WARN_ON
      scsi: ibmvscsi: redo driver work thread to use enum action states
      scsi: ibmvscsi: Wire up host_reset() in the driver's scsi_host_template

Varun Prakash (1):
      scsi: cxgb4i: add support for IEEE_8021QAZ_APP_SEL_STREAM selector

Weitao Hou (1):
      scsi: pm8001: Fix typo in code comments

Xiang Chen (3):
      scsi: hisi_sas: Disable stash for v3 hw
      scsi: hisi_sas: Change the type of some numbers to unsigned
      scsi: hisi_sas: Delete PHY timers when rmmod or probe failed

Xiaofei Tan (1):
      scsi: hisi_sas: Fix the issue of argument mismatch of printing ecc errors

YueHaibing (7):
      scsi: megaraid_sas: Remove unused including <linux/version.h>
      scsi: megaraid_sas: remove set but not used variables 'buff_addr' and 'ci_h'
      scsi: megaraid_sas: remove set but not used variable 'sge_sz'
      scsi: lpfc: Make some symbols static
      scsi: lpfc: Remove set but not used variables 'qp'
      scsi: megaraid_sas: remove set but not used variables 'host' and 'wait_time'
      scsi: megaraid_sas: remove set but not used variable 'cur_state'

With the diffstat:

 Documentation/scsi/osst.txt                  |  218 -
 Documentation/scsi/ufs.txt                   |    7 +
 MAINTAINERS                                  |   13 +-
 arch/m68k/mac/config.c                       |   10 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |   21 +-
 drivers/message/fusion/mptbase.c             |    3 +-
 drivers/scsi/Kconfig                         |   57 +-
 drivers/scsi/Makefile                        |    4 +-
 drivers/scsi/NCR5380.c                       |   18 +-
 drivers/scsi/NCR5380.h                       |    2 +-
 drivers/scsi/aic7xxx/aic7xxx.reg             |    2 +-
 drivers/scsi/aic94xx/aic94xx_dev.c           |    4 +-
 drivers/scsi/bnx2fc/bnx2fc.h                 |   14 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c             |   60 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c            |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c              |  116 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c             |   10 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c           |    9 +-
 drivers/scsi/fcoe/fcoe.c                     |   14 +-
 drivers/scsi/fcoe/fcoe.h                     |   14 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                |   14 +-
 drivers/scsi/fcoe/fcoe_sysfs.c               |   14 +-
 drivers/scsi/fcoe/fcoe_transport.c           |   14 +-
 drivers/scsi/fdomain.c                       |  597 +++
 drivers/scsi/fdomain.h                       |  114 +
 drivers/scsi/fdomain_isa.c                   |  222 +
 drivers/scsi/fdomain_pci.c                   |   68 +
 drivers/scsi/hisi_sas/hisi_sas.h             |    8 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c        |   16 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c       |   50 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c       |   50 +-
 drivers/scsi/hosts.c                         |    1 +
 drivers/scsi/hpsa.c                          |  280 +-
 drivers/scsi/hpsa.h                          |    6 +-
 drivers/scsi/hpsa_cmd.h                      |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c             |   77 +-
 drivers/scsi/ibmvscsi/ibmvscsi.h             |   10 +-
 drivers/scsi/isci/remote_device.c            |    4 +-
 drivers/scsi/isci/remote_device.h            |    5 -
 drivers/scsi/isci/request.c                  |    8 +-
 drivers/scsi/isci/task.c                     |    2 +-
 drivers/scsi/libfc/fc_disc.c                 |   14 +-
 drivers/scsi/libfc/fc_elsct.c                |   14 +-
 drivers/scsi/libfc/fc_exch.c                 |   14 +-
 drivers/scsi/libfc/fc_fcp.c                  |   14 +-
 drivers/scsi/libfc/fc_frame.c                |   14 +-
 drivers/scsi/libfc/fc_libfc.c                |   14 +-
 drivers/scsi/libfc/fc_libfc.h                |   14 +-
 drivers/scsi/libfc/fc_lport.c                |   14 +-
 drivers/scsi/libfc/fc_npiv.c                 |   14 +-
 drivers/scsi/libfc/fc_rport.c                |   14 +-
 drivers/scsi/libiscsi.c                      |   15 +-
 drivers/scsi/libiscsi_tcp.c                  |   13 +-
 drivers/scsi/libsas/sas_ata.c                |   16 +-
 drivers/scsi/libsas/sas_discover.c           |   23 +-
 drivers/scsi/libsas/sas_event.c              |   18 +-
 drivers/scsi/libsas/sas_expander.c           |   71 +-
 drivers/scsi/libsas/sas_host_smp.c           |    5 +-
 drivers/scsi/libsas/sas_init.c               |   19 +-
 drivers/scsi/libsas/sas_internal.h           |   19 +-
 drivers/scsi/libsas/sas_phy.c                |   18 +-
 drivers/scsi/libsas/sas_port.c               |   24 +-
 drivers/scsi/libsas/sas_scsi_host.c          |   19 +-
 drivers/scsi/libsas/sas_task.c               |    2 +-
 drivers/scsi/lpfc/lpfc_attr.c                |   34 +-
 drivers/scsi/lpfc/lpfc_bsg.c                 |    2 +-
 drivers/scsi/lpfc/lpfc_crtn.h                |    3 +-
 drivers/scsi/lpfc/lpfc_ct.c                  |   14 +-
 drivers/scsi/lpfc/lpfc_els.c                 |    1 +
 drivers/scsi/lpfc/lpfc_init.c                |  512 ++-
 drivers/scsi/lpfc/lpfc_nvme.c                |   16 +-
 drivers/scsi/lpfc/lpfc_nvmet.c               |  332 +-
 drivers/scsi/lpfc/lpfc_nvmet.h               |    1 +
 drivers/scsi/lpfc/lpfc_scsi.c                |   16 +-
 drivers/scsi/lpfc/lpfc_sli.c                 |   76 +-
 drivers/scsi/lpfc/lpfc_sli4.h                |   11 +-
 drivers/scsi/lpfc/lpfc_version.h             |    2 +-
 drivers/scsi/mac_scsi.c                      |  421 +-
 drivers/scsi/megaraid/Kconfig.megaraid       |    1 +
 drivers/scsi/megaraid/Makefile               |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h         |  101 +-
 drivers/scsi/megaraid/megaraid_sas_base.c    |  712 ++-
 drivers/scsi/megaraid/megaraid_sas_debugfs.c |  179 +
 drivers/scsi/megaraid/megaraid_sas_fp.c      |   82 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c  |  551 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h  |   33 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h         |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c          |  497 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h          |   35 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c        |   73 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c           |  234 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c         |   52 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c     |    8 +-
 drivers/scsi/mvsas/mv_sas.c                  |    2 +-
 drivers/scsi/mvsas/mv_sas.h                  |    3 -
 drivers/scsi/osst.c                          | 6107 --------------------------
 drivers/scsi/osst.h                          |  651 ---
 drivers/scsi/osst_detect.h                   |    7 -
 drivers/scsi/osst_options.h                  |  107 -
 drivers/scsi/pcmcia/Kconfig                  |   10 +
 drivers/scsi/pcmcia/Makefile                 |    1 +
 drivers/scsi/pcmcia/fdomain_cs.c             |   95 +
 drivers/scsi/pm8001/pm8001_ctl.c             |   52 +-
 drivers/scsi/pm8001/pm8001_hwi.c             |    4 +-
 drivers/scsi/pm8001/pm8001_sas.c             |    4 +-
 drivers/scsi/pm8001/pm8001_sas.h             |    1 -
 drivers/scsi/pm8001/pm80xx_hwi.c             |    4 +-
 drivers/scsi/qla2xxx/qla_def.h               |    5 +-
 drivers/scsi/qla2xxx/qla_gbl.h               |    2 +
 drivers/scsi/qla2xxx/qla_init.c              |    1 -
 drivers/scsi/qla2xxx/qla_nvme.c              |  236 +-
 drivers/scsi/qla2xxx/qla_nvme.h              |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                |    1 -
 drivers/scsi/qla2xxx/qla_target.c            |   16 +-
 drivers/scsi/scsi.c                          |   13 +-
 drivers/scsi/scsi_debugfs.h                  |    1 +
 drivers/scsi/scsi_error.c                    |   27 +-
 drivers/scsi/scsi_ioctl.c                    |    1 +
 drivers/scsi/scsi_lib.c                      |    5 +-
 drivers/scsi/scsi_logging.c                  |    3 +-
 drivers/scsi/scsi_pm.c                       |    7 +-
 drivers/scsi/scsi_priv.h                     |    1 -
 drivers/scsi/scsi_sysctl.c                   |    2 +-
 drivers/scsi/scsi_sysfs.c                    |    8 +-
 drivers/scsi/scsi_trace.c                    |   14 +-
 drivers/scsi/scsi_transport_fc.c             |   18 +-
 drivers/scsi/scsi_transport_iscsi.c          |   15 +-
 drivers/scsi/scsi_transport_sas.c            |    2 +-
 drivers/scsi/scsi_transport_spi.c            |   15 +-
 drivers/scsi/scsi_transport_srp.c            |   16 +-
 drivers/scsi/sd.c                            |  112 +-
 drivers/scsi/sd_dif.c                        |   16 +-
 drivers/scsi/sd_zbc.c                        |   16 +-
 drivers/scsi/ses.c                           |   20 +-
 drivers/scsi/sg.c                            |    7 +-
 drivers/scsi/sr.c                            |    1 +
 drivers/scsi/st.c                            |    7 +-
 drivers/scsi/storvsc_drv.c                   |   11 +
 drivers/scsi/ufs/ufs-qcom.c                  |   23 +-
 drivers/scsi/ufs/ufs-sysfs.c                 |    6 +-
 drivers/scsi/ufs/ufs_bsg.c                   |    6 +-
 drivers/scsi/ufs/ufshcd-pci.c                |    2 +
 drivers/scsi/ufs/ufshcd.c                    |   35 +-
 drivers/scsi/ufs/ufshcd.h                    |    5 +
 drivers/scsi/ufs/ufshci.h                    |    6 +-
 drivers/scsi/virtio_scsi.c                   |    3 -
 drivers/scsi/wd719x.c                        |   42 +-
 drivers/target/iscsi/iscsi_target_nego.c     |   15 +-
 drivers/target/target_core_user.c            |   16 +-
 include/scsi/fc/fc_encaps.h                  |   14 +-
 include/scsi/fc/fc_fc2.h                     |   14 +-
 include/scsi/fc/fc_fcoe.h                    |   14 +-
 include/scsi/fc/fc_fcp.h                     |   14 +-
 include/scsi/fc/fc_fip.h                     |   14 +-
 include/scsi/fc/fc_ms.h                      |   17 +-
 include/scsi/iscsi_if.h                      |   13 +-
 include/scsi/iscsi_proto.h                   |   13 +-
 include/scsi/libfc.h                         |   14 +-
 include/scsi/libfcoe.h                       |   14 +-
 include/scsi/libiscsi.h                      |   15 +-
 include/scsi/libiscsi_tcp.h                  |   13 +-
 include/scsi/libsas.h                        |   22 +-
 include/scsi/sas.h                           |   19 +-
 include/scsi/sas_ata.h                       |   17 +-
 include/scsi/scsi_bsg_iscsi.h                |   16 +-
 include/scsi/scsi_transport.h                |   15 +-
 include/scsi/scsi_transport_fc.h             |   18 +-
 include/scsi/scsi_transport_iscsi.h          |   15 +-
 include/scsi/scsi_transport_spi.h            |   15 +-
 include/uapi/scsi/fc/fc_els.h                |   13 -
 include/uapi/scsi/fc/fc_fs.h                 |   13 -
 include/uapi/scsi/fc/fc_gs.h                 |   13 -
 include/uapi/scsi/fc/fc_ns.h                 |   13 -
 include/uapi/scsi/scsi_bsg_fc.h              |   15 -
 include/uapi/scsi/scsi_netlink.h             |   15 -
 include/uapi/scsi/scsi_netlink_fc.h          |   15 -
 176 files changed, 5237 insertions(+), 9540 deletions(-)
 delete mode 100644 Documentation/scsi/osst.txt
 create mode 100644 drivers/scsi/fdomain.c
 create mode 100644 drivers/scsi/fdomain.h
 create mode 100644 drivers/scsi/fdomain_isa.c
 create mode 100644 drivers/scsi/fdomain_pci.c
 create mode 100644 drivers/scsi/megaraid/megaraid_sas_debugfs.c
 delete mode 100644 drivers/scsi/osst.c
 delete mode 100644 drivers/scsi/osst.h
 delete mode 100644 drivers/scsi/osst_detect.h
 delete mode 100644 drivers/scsi/osst_options.h
 create mode 100644 drivers/scsi/pcmcia/fdomain_cs.c

James
