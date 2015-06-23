From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL v2] SCSI updates for the 4.1+ merge window
Date: Mon, 22 Jun 2015 17:20:06 -0700
Message-ID: <1435018806.2237.180.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34129 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbbFWAUI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Jun 2015 20:20:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a resend of the original tree with the tag attached at original
commit c8806b6 snic: driver for Cisco SCSI HBA

---

This is the usual grab bag of driver updates (lpfc, hpsa,
megaraid_sas, cxgbi, be2iscsi) plus an assortment of minor updates.
There are also one new driver: the Cisco snic; the advansys driver has
been rewritten to get rid of the warning about converting it to the
DMA API, the tape statistics patch got in and finally, there's a
resuffle of SCSI header files to separate more cleanly initiator from
target mode (and better share the common definitions).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The Short Changelog is:

Bart Van Assche (6):
      qla2xxx: Fix indentation
      qla2xxx: Comment out unreachable code
      target: Minimize SCSI header #include directives
      target: Correct a comment
      Move code that is used both by initiator and target drivers
      Split SCSI header files

Brian King (1):
      ipr: Increase default adapter init stage change timeout

Christoph Hellwig (9):
      virtio_scsi: don't select CONFIG_BLK_DEV_INTEGRITY
      megaraid_sas : swap whole register in megasas_register_aen
      megaraid_sas : fix megasas_fire_cmd_fusion calling convention
      megaraid_sas : add missing byte swaps to the sriov code
      megaraid_sas : bytewise or should be done on native endian variables
      megaraid_sas : move endianness conversion into caller of megasas_get_seq_num
      megaraid_sas : add endianness conversions for all ones
      megaraid_sas : add endianness annotations
      megaraid_sas : add missing __iomem annotations

Dan Carpenter (2):
      csiostor: fix an error code in csio_hw_init()
      sd: fix an error return in probe()

Don Brace (2):
      hpsa: change driver version
      hpsa: add in new controller id

Hannes Reinecke (24):
      scsi: Do not set cmd_per_lun to 1 in the host template
      advansys: Update to version 3.5 and remove compilation warning
      advansys: Remove call to dma_cache_sync()
      advansys: use spin_lock_irqsave() in interrupt handler
      advansys: Check for DMA mapping errors
      advansys: Remove cmd_per_lun setting
      advansys: Remove obsolete virtual memory mapping comment
      advansys: Remove 'a_flag'
      advansys: rename 'ASC_RQ_XX' to 'ADV_RQ_XX'
      advansys: Remove CC_VERY_LONG_SG_LIST
      advansys: Remove ASC_SCSI_REQ_Q
      advansys: scsi_q1->data_addr is little endian
      advansys: cleanup function return codes
      advansys: Make AscIsrChipHalted() a void function
      advansys: remove 'ERR' definition
      advansys: Remove 'TRUE' and 'FALSE' definitions
      advansys: use standard data types
      advansys: use 'bool' instead of 'int'
      advansys: Use dma_pool for sg elements
      advansys: Use DMA-API for mapping request blocks
      advansys: Use DMA-API for carrier buffer
      advansys: use DMA-API for mapping sense buffer
      advansys: use shared host tag map for command lookup
      advansys: use host_reset

James Bottomley (2):
      ips: remove pointless #warning
      scsi_scan: fix queue depth initialisation problem

James Smart (24):
      lpfc: Update version to 10.7.0.0 for upstream patch set.
      lpfc: Fix to drop PLOGIs from fabric node till LOGO processing completes
      lpfc: Fix scsi task management error message.
      lpfc: Fix cq_id masking problem.
      lpfc: Fix scsi prep dma buf error.
      lpfc: Add support for using block multi-queue
      lpfc: Devices are not discovered during takeaway/giveback testing
      lpfc: Fix vport deletion failure.
      lpfc: Check for active portpeerbeacon.
      lpfc: Update driver version for upstream patch set 10.6.0.1.
      lpfc: Change buffer pool empty message to miscellaneous category
      lpfc: Fix incorrect log message reported for empty FCF record.
      lpfc: Fix rport leak.
      lpfc: Correct loss of RSCNs during array takeaway/giveback testing.
      lpfc: Fix crash in vport_delete.
      lpfc: Fix to remove IRQF_SHARED flag for MSI/MSI-X vectors.
      lpfc: Fix discovery issue when changing from Pt2Pt to Fabric.
      lpfc: Correct reporting of vport state on fdisc command failure.
      lpfc: Add support for RDP ELS command.
      lpfc: Fix ABORTs WQ selection in terminate_rport_io
      lpfc: Correct reference counting of rport
      lpfc: Add support for ELS LCB.
      lpfc: Correct loss of target discovery after cable swap.
      lpfc: The lpfc driver does not issue RFF_ID and RFT_ID in the correct sequence

Joe Handzik (3):
      hpsa: add more ioaccel2 error handling, including underrun statuses.
      hpsa: Get queue depth from identify physical bmic for physical disks.
      hpsa: use ioaccel2 path to submit IOs to physical drives in HBA mode.

Johannes Thumshirn (1):
      advansys: fix compilation errors and warnings when CONFIG_PCI is not set

John Soni Jose (6):
      be2iscsi : Bump the driver version
      be2iscsi : Logout of FW Boot Session
      be2iscsi : Fix memory check before unmapping.
      be2iscsi : Fix memory leak in the unload path
      be2iscsi : Fix the PCI request region reserving.
      be2iscsi : Fix the retry count for boot targets

Karen Xie (4):
      cxgb4i: set the initial sequence number
      cxgbi: update driver versions
      cxgbi: update copyright to 2015
      cxgbi: use per-connection link-speed dependent send/recv windows

Luis R. Rodriguez (1):
      fusion: remove dead MTRR code

Narsimhulu Musini (1):
      snic: driver for Cisco SCSI HBA

Nilesh Javali (1):
      bnx2i: Fix call trace while device reset

Robert Elliott (18):
      hpsa: propagate the error code in hpsa_kdump_soft_reset
      hpsa: use scsi host_no as hpsa controller number
      hpsa: add interrupt number to /proc/interrupts interrupt name
      hpsa: create workqueue after the driver is ready for use
      hpsa: fix try_soft_reset error handling
      hpsa: cleanup for init_one step 2 in kdump
      hpsa: skip free_irq calls if irqs are not allocated
      hpsa: call pci_release_regions after pci_disable_device
      hpsa: do not print ioaccel2 warning messages about unusual completions.
      hpsa: clean up some error reporting output in abort handler
      hpsa: clean up driver init
      hpsa: correct return values from driver functions.
      hpsa: do not check cmd_alloc return value - it cannnot return NULL
      hpsa: refactor freeing of resources into more logical functions
      hpsa: clean up error handling
      hpsa: break hpsa_free_irqs_and_disable_msix into two functions
      hpsa: print accurate SSD Smart Path Enabled status
      hpsa: make function names consistent

Sagi Grimberg (1):
      iscsi: Fix iscsi endpoints leak

Seymour, Shane M (1):
      st: implement tape statistics

Stephen Boyd (1):
      ufs-qcom: Switch dependency to ARCH_QCOM

Stephen Cameron (9):
      hpsa: add support sending aborts to physical devices via the ioaccel2 path
      hpsa: try resubmitting down raid path on task set full
      hpsa: do not ignore return value of hpsa_register_scsi
      hpsa: factor out hpsa_init_cmd function
      hpsa: allow lockup detected to be viewed via sysfs
      hpsa: hpsa decode sense data for io and tmf
      hpsa: decrement h->commands_outstanding in fail_all_outstanding_cmds
      hpsa: clean up aborts
      hpsa: add masked physical devices into h->dev[] array

Stephen Rothwell (1):
      target: explicitly include scsi_proto.h in target_core_fabric_lib.c

Sumit.Saxena@avagotech.com (10):
      megaraid_sas : Modify return value of megasas_issue_blocked_cmd() and wait_and_poll() to consider command status returned by firmware
      megaraid_sas : Support for Avago's Single server High Availability product
      megaraid_sas : Add release date and update driver version
      megaraid_sas : Modify driver's meta data to reflect Avago
      megaraid_sas : Use Block layer tag support for internal command indexing
      megaraid_sas : Enhanced few prints
      megaraid_sas : Move controller's queue depth calculation in adapter specific function
      megaraid_sas : Add separate functions for building sysPD IOs and non RW LDIOs
      megaraid_sas : Add separate function for refiring MFI commands
      megaraid_sas : Add separate function for setting up IRQs

Tej Parkash (1):
      bnx2i: Fixed firmware assert, during target logout.

Tomas Henzl (5):
      mptsas: fix depth param in scsi_track_queue_full
      megaraid: fix irq setup process regression
      hpsa: dont meddle with hw which isn't ours (cciss)
      cciss: correct the non-resettable board list
      cciss: remove duplicate entries from board_type struct

Webb Scales (10):
      hpsa: cleanup reset
      hpsa: use block layer tag for command allocation
      hpsa: performance tweak for hpsa_scatter_gather()
      hpsa: refactor and rework support for sending TEST_UNIT_READY
      hpsa: don't return abort request until target is complete
      hpsa: use helper routines for finishing commands
      hpsa: add ioaccel sg chaining for the ioaccel2 path
      hpsa: factor out hpsa_ioaccel_submit function
      hpsa: rework controller command submission
      hpsa: clean up host, channel, target, lun prints

Yaniv Gardi (10):
      scsi: ufs-qcom: enable UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION
      scsi: ufs: add quirk to handle broken UFS HCI version
      scsi: ufs-qcom: enable UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE quirk
      scsi: ufs: introduce UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE quirk
      scsi: ufs-qcom: enable quirk to fix gear change to HS
      scsi: ufs: introduce a broken PA_RXHSUNTERMCAP quirk
      scsi: ufs-qcom: enable UFSHCD_QUIRK_BROKEN_LCC
      scsi: ufs: provide a quirk to disable the LCC
      scsi: ufs-qcom: don't enable interrupt aggregation
      scsi: ufs: introduce the capability and quirk for interrupt aggregation

kbuild test robot (2):
      megaraid_sas : megasas_complete_outstanding_ioctls() can be static
      aacraid: aac_src_intr_message() can be static

and the diffstat:

 Documentation/ABI/testing/sysfs-class-scsi_tape |  109 +
 Documentation/scsi/st.txt                       |   59 +
 Documentation/target/tcm_mod_builder.py         |    7 +-
 MAINTAINERS                                     |    8 +
 drivers/block/cciss.c                           |   27 +-
 drivers/block/cciss_scsi.c                      |    1 -
 drivers/firewire/sbp2.c                         |    1 -
 drivers/infiniband/ulp/srpt/ib_srpt.c           |    1 +
 drivers/infiniband/ulp/srpt/ib_srpt.h           |    2 +-
 drivers/message/fusion/mptbase.c                |   24 -
 drivers/message/fusion/mptbase.h                |    1 -
 drivers/message/fusion/mptsas.c                 |    4 +-
 drivers/s390/scsi/zfcp_scsi.c                   |    1 -
 drivers/scsi/Kconfig                            |   20 +-
 drivers/scsi/Makefile                           |    2 +
 drivers/scsi/NCR53c406a.c                       |    1 -
 drivers/scsi/a100u2w.c                          |    1 -
 drivers/scsi/aacraid/src.c                      |    2 +-
 drivers/scsi/advansys.c                         | 1474 +++++-------
 drivers/scsi/aha152x.c                          |    1 -
 drivers/scsi/aha1542.c                          |    1 -
 drivers/scsi/aha1740.c                          |    1 -
 drivers/scsi/aha1740.h                          |    1 -
 drivers/scsi/aic94xx/aic94xx_init.c             |    1 -
 drivers/scsi/arm/arxescsi.c                     |    1 -
 drivers/scsi/arm/cumana_2.c                     |    1 -
 drivers/scsi/arm/eesox.c                        |    1 -
 drivers/scsi/atp870u.c                          |    1 -
 drivers/scsi/atp870u.h                          |    1 -
 drivers/scsi/be2iscsi/be_cmds.c                 |    4 +
 drivers/scsi/be2iscsi/be_cmds.h                 |   12 +
 drivers/scsi/be2iscsi/be_main.c                 |   76 +-
 drivers/scsi/be2iscsi/be_main.h                 |    6 +-
 drivers/scsi/be2iscsi/be_mgmt.c                 |   69 +
 drivers/scsi/be2iscsi/be_mgmt.h                 |    3 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c                |    5 +-
 drivers/scsi/csiostor/csio_hw.c                 |    1 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c              |   20 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.h              |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c              |   52 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.h              |    4 +-
 drivers/scsi/cxgbi/libcxgbi.c                   |   20 +-
 drivers/scsi/cxgbi/libcxgbi.h                   |    6 +-
 drivers/scsi/dpt_i2o.c                          |    1 -
 drivers/scsi/fdomain.c                          |    1 -
 drivers/scsi/hpsa.c                             | 2794 ++++++++++++++++-------
 drivers/scsi/hpsa.h                             |   19 +-
 drivers/scsi/hpsa_cmd.h                         |   34 +-
 drivers/scsi/imm.c                              |    1 -
 drivers/scsi/initio.c                           |    1 -
 drivers/scsi/ipr.h                              |    2 +-
 drivers/scsi/ips.c                              |    9 +-
 drivers/scsi/isci/init.c                        |    1 -
 drivers/scsi/lpfc/lpfc.h                        |    2 +
 drivers/scsi/lpfc/lpfc_crtn.h                   |    2 +
 drivers/scsi/lpfc/lpfc_disc.h                   |    4 +-
 drivers/scsi/lpfc/lpfc_els.c                    |  733 +++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                |  181 +-
 drivers/scsi/lpfc/lpfc_hw.h                     |  201 ++
 drivers/scsi/lpfc/lpfc_hw4.h                    |  236 +-
 drivers/scsi/lpfc/lpfc_init.c                   |   26 +-
 drivers/scsi/lpfc/lpfc_mbox.c                   |  152 ++
 drivers/scsi/lpfc/lpfc_nportdisc.c              |   10 +-
 drivers/scsi/lpfc/lpfc_scsi.c                   |   65 +-
 drivers/scsi/lpfc/lpfc_scsi.h                   |    3 +
 drivers/scsi/lpfc/lpfc_sli.c                    |   82 +-
 drivers/scsi/lpfc/lpfc_sli4.h                   |   21 +
 drivers/scsi/lpfc/lpfc_version.h                |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c                  |    9 +-
 drivers/scsi/mac53c94.c                         |    1 -
 drivers/scsi/megaraid/megaraid_sas.h            |  342 +--
 drivers/scsi/megaraid/megaraid_sas_base.c       |  739 +++---
 drivers/scsi/megaraid/megaraid_sas_fp.c         |   17 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c     |  554 +++--
 drivers/scsi/megaraid/megaraid_sas_fusion.h     |  281 ++-
 drivers/scsi/mvsas/mv_init.c                    |    1 -
 drivers/scsi/nsp32.c                            |    1 -
 drivers/scsi/pcmcia/nsp_cs.c                    |    1 -
 drivers/scsi/pcmcia/qlogic_stub.c               |    1 -
 drivers/scsi/pcmcia/sym53c500_cs.c              |    1 -
 drivers/scsi/pm8001/pm8001_init.c               |    1 -
 drivers/scsi/ppa.c                              |    1 -
 drivers/scsi/ps3rom.c                           |    1 -
 drivers/scsi/qla1280.c                          |    1 -
 drivers/scsi/qla2xxx/qla_init.c                 |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c                 |    8 +-
 drivers/scsi/qla2xxx/qla_isr.c                  |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c                   |    2 +-
 drivers/scsi/qla2xxx/qla_nx2.c                  |   13 +-
 drivers/scsi/qla2xxx/qla_os.c                   |    7 +-
 drivers/scsi/qla2xxx/qla_target.c               |   16 +-
 drivers/scsi/qlogicfas.c                        |    1 -
 drivers/scsi/qlogicpti.c                        |    1 -
 drivers/scsi/scsi.c                             |   46 -
 drivers/scsi/scsi_common.c                      |  178 ++
 drivers/scsi/scsi_error.c                       |   64 -
 drivers/scsi/scsi_scan.c                        |   65 +-
 drivers/scsi/scsi_transport_iscsi.c             |    2 +
 drivers/scsi/sd.c                               |    3 +-
 drivers/scsi/snic/Makefile                      |   17 +
 drivers/scsi/snic/cq_desc.h                     |   77 +
 drivers/scsi/snic/cq_enet_desc.h                |   38 +
 drivers/scsi/snic/snic.h                        |  414 ++++
 drivers/scsi/snic/snic_attrs.c                  |   77 +
 drivers/scsi/snic/snic_ctl.c                    |  279 +++
 drivers/scsi/snic/snic_debugfs.c                |  560 +++++
 drivers/scsi/snic/snic_disc.c                   |  551 +++++
 drivers/scsi/snic/snic_disc.h                   |  124 +
 drivers/scsi/snic/snic_fwint.h                  |  525 +++++
 drivers/scsi/snic/snic_io.c                     |  518 +++++
 drivers/scsi/snic/snic_io.h                     |  118 +
 drivers/scsi/snic/snic_isr.c                    |  204 ++
 drivers/scsi/snic/snic_main.c                   | 1044 +++++++++
 drivers/scsi/snic/snic_res.c                    |  295 +++
 drivers/scsi/snic/snic_res.h                    |   97 +
 drivers/scsi/snic/snic_scsi.c                   | 2632 +++++++++++++++++++++
 drivers/scsi/snic/snic_stats.h                  |  123 +
 drivers/scsi/snic/snic_trc.c                    |  181 ++
 drivers/scsi/snic/snic_trc.h                    |  121 +
 drivers/scsi/snic/vnic_cq.c                     |   86 +
 drivers/scsi/snic/vnic_cq.h                     |  110 +
 drivers/scsi/snic/vnic_cq_fw.h                  |   62 +
 drivers/scsi/snic/vnic_dev.c                    |  748 ++++++
 drivers/scsi/snic/vnic_dev.h                    |  110 +
 drivers/scsi/snic/vnic_devcmd.h                 |  270 +++
 drivers/scsi/snic/vnic_intr.c                   |   59 +
 drivers/scsi/snic/vnic_intr.h                   |  105 +
 drivers/scsi/snic/vnic_resource.h               |   68 +
 drivers/scsi/snic/vnic_snic.h                   |   54 +
 drivers/scsi/snic/vnic_stats.h                  |   68 +
 drivers/scsi/snic/vnic_wq.c                     |  237 ++
 drivers/scsi/snic/vnic_wq.h                     |  170 ++
 drivers/scsi/snic/wq_enet_desc.h                |   96 +
 drivers/scsi/st.c                               |  272 ++-
 drivers/scsi/st.h                               |   22 +
 drivers/scsi/sym53c416.c                        |    1 -
 drivers/scsi/ufs/Kconfig                        |    2 +-
 drivers/scsi/ufs/ufs-qcom.c                     |   39 +-
 drivers/scsi/ufs/ufshcd.c                       |  108 +-
 drivers/scsi/ufs/ufshcd.h                       |   53 +-
 drivers/scsi/ufs/ufshci.h                       |    8 +-
 drivers/scsi/virtio_scsi.c                      |   11 +-
 drivers/scsi/wd719x.c                           |    1 -
 drivers/scsi/wd719x.h                           |    2 -
 drivers/staging/rts5208/rtsx.c                  |    1 -
 drivers/target/iscsi/iscsi_target.c             |    2 +-
 drivers/target/iscsi/iscsi_target_device.c      |    1 -
 drivers/target/iscsi/iscsi_target_tmr.c         |    2 +-
 drivers/target/sbp/sbp_target.c                 |    2 +-
 drivers/target/target_core_alua.c               |    3 +-
 drivers/target/target_core_device.c             |    4 +-
 drivers/target/target_core_fabric_lib.c         |    4 +-
 drivers/target/target_core_file.c               |    3 +-
 drivers/target/target_core_iblock.c             |    3 +-
 drivers/target/target_core_pr.c                 |    3 +-
 drivers/target/target_core_pscsi.c              |    2 -
 drivers/target/target_core_pscsi.h              |    6 +-
 drivers/target/target_core_rd.c                 |    3 +-
 drivers/target/target_core_sbc.c                |    2 +-
 drivers/target/target_core_spc.c                |    3 +-
 drivers/target/target_core_stat.c               |    3 -
 drivers/target/target_core_tmr.c                |    2 -
 drivers/target/target_core_tpg.c                |    3 +-
 drivers/target/target_core_transport.c          |    4 +-
 drivers/target/target_core_ua.c                 |    3 +-
 drivers/target/target_core_user.c               |    5 +-
 drivers/target/target_core_xcopy.c              |    3 +-
 drivers/target/tcm_fc/tfc_cmd.c                 |    4 -
 drivers/target/tcm_fc/tfc_conf.c                |    4 -
 drivers/target/tcm_fc/tfc_io.c                  |    4 -
 drivers/target/tcm_fc/tfc_sess.c                |    4 -
 drivers/usb/gadget/legacy/tcm_usb_gadget.c      |    1 -
 drivers/usb/gadget/legacy/tcm_usb_gadget.h      |    1 -
 drivers/usb/image/microtek.c                    |    1 -
 drivers/usb/storage/scsiglue.c                  |    1 -
 drivers/usb/storage/uas.c                       |    1 -
 drivers/vhost/scsi.c                            |    3 +-
 drivers/xen/xen-scsiback.c                      |    5 +-
 include/linux/libata.h                          |    2 -
 include/scsi/scsi.h                             |  291 +--
 include/scsi/scsi_common.h                      |   64 +
 include/scsi/scsi_device.h                      |    2 -
 include/scsi/scsi_eh.h                          |   31 -
 include/scsi/scsi_proto.h                       |  281 +++
 include/target/iscsi/iscsi_target_core.h        |    1 -
 include/target/target_core_base.h               |   15 +-
 include/trace/events/target.h                   |    2 +-
 187 files changed, 16789 insertions(+), 3735 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-scsi_tape
 create mode 100644 drivers/scsi/scsi_common.c
 create mode 100644 drivers/scsi/snic/Makefile
 create mode 100644 drivers/scsi/snic/cq_desc.h
 create mode 100644 drivers/scsi/snic/cq_enet_desc.h
 create mode 100644 drivers/scsi/snic/snic.h
 create mode 100644 drivers/scsi/snic/snic_attrs.c
 create mode 100644 drivers/scsi/snic/snic_ctl.c
 create mode 100644 drivers/scsi/snic/snic_debugfs.c
 create mode 100644 drivers/scsi/snic/snic_disc.c
 create mode 100644 drivers/scsi/snic/snic_disc.h
 create mode 100644 drivers/scsi/snic/snic_fwint.h
 create mode 100644 drivers/scsi/snic/snic_io.c
 create mode 100644 drivers/scsi/snic/snic_io.h
 create mode 100644 drivers/scsi/snic/snic_isr.c
 create mode 100644 drivers/scsi/snic/snic_main.c
 create mode 100644 drivers/scsi/snic/snic_res.c
 create mode 100644 drivers/scsi/snic/snic_res.h
 create mode 100644 drivers/scsi/snic/snic_scsi.c
 create mode 100644 drivers/scsi/snic/snic_stats.h
 create mode 100644 drivers/scsi/snic/snic_trc.c
 create mode 100644 drivers/scsi/snic/snic_trc.h
 create mode 100644 drivers/scsi/snic/vnic_cq.c
 create mode 100644 drivers/scsi/snic/vnic_cq.h
 create mode 100644 drivers/scsi/snic/vnic_cq_fw.h
 create mode 100644 drivers/scsi/snic/vnic_dev.c
 create mode 100644 drivers/scsi/snic/vnic_dev.h
 create mode 100644 drivers/scsi/snic/vnic_devcmd.h
 create mode 100644 drivers/scsi/snic/vnic_intr.c
 create mode 100644 drivers/scsi/snic/vnic_intr.h
 create mode 100644 drivers/scsi/snic/vnic_resource.h
 create mode 100644 drivers/scsi/snic/vnic_snic.h
 create mode 100644 drivers/scsi/snic/vnic_stats.h
 create mode 100644 drivers/scsi/snic/vnic_wq.c
 create mode 100644 drivers/scsi/snic/vnic_wq.h
 create mode 100644 drivers/scsi/snic/wq_enet_desc.h
 create mode 100644 include/scsi/scsi_common.h
 create mode 100644 include/scsi/scsi_proto.h

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
