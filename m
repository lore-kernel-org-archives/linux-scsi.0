From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.20+ merge window
Date: Mon, 24 Dec 2018 09:19:53 -0800
Message-ID: <1545671993.2810.25.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly update of the usual drivers: smarpqi, lpfc, qedi,
megaraid_sas, libsas, zfcp, mpt3sas, hisi_sas.  Additionally, we have a
pile of annotation, unused variable and minor updates.  The big API
change is the updates for Christoph's DMA rework which include removing
the DISABLE_CLUSTERING flag.  And finally there are a couple of target
tree updates.

Note: there is a merge conflict caused local commit c4e521b654e15e
"scsi: qla2xxx: Split the __qla2x00_abort_all_cmds() function" clashing
with upstream f2ffd4e5bc7b "scsi: qla2xxx: Timeouts occur on surprise
removal of QLogic adapter".  The resolution is the obvious one: to
update the moved code, but also to remove the now unused status
variable from __qla2x00_abort_all_cmds().  I've attached it below just
in case you want to see it.

We had some late arriving commits, but I've verified they've all had at
least one linux-next run.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Ajish Koshy (2):
      scsi: smartpqi: allow for larger raid maps
      scsi: smartpqi: add support for huawei controllers

Anatoliy Glagolev (1):
      scsi: qla2xxx: deadlock by configfs_depend_item

Anil Gurumurthy (1):
      scsi: qla2xxx: Enable FC-NVME on NPIV ports

Arnd Bergmann (3):
      scsi: aacraid: change event_wait to a completion
      scsi: aacraid: change wait_sem to a completion
      scsi: cxgb4i: fix thermal configuration dependencies

Avri Altman (1):
      scsi: ufs: Remove redundant sense size definition

Bart Van Assche (13):
      scsi: virtio_scsi: Remove per-target data because it is no longer used
      scsi: qla2xxx: Split the __qla2x00_abort_all_cmds() function
      scsi: target/core: Reduce the amount of code executed with a spinlock held
      scsi: target/core: Make ABORT and LUN RESET handling synchronous
      scsi: target/core: Fix TAS handling for aborted commands
      scsi: target/core: Simplify the code for aborting SCSI commands
      scsi: target/core: Make it possible to wait from more than one context for command completion
      scsi: target/core: Use system workqueues for TMF
      scsi: target/core: Make sure that target_wait_for_sess_cmds() waits long enough
      scsi: target/core: Simplify transport_clear_lun_ref()
      scsi: target/core: Use kvcalloc() instead of open-coding it
      scsi: target/tcmu: Fix queue_cmd_ring() declaration
      scsi: qla2xxx: Introduce a switch/case statement in qlt_xmit_tm_rsp()

Chengguang Xu (2):
      scsi: qla4xxx: remvoe unnecessary condition check for mempool_destroy()
      scsi: qla4xxx: remove unnecessary condition check for dma_pool_destroy()

Christoph Hellwig (36):
      scsi: myrs: remove the dma_boundary_limit
      scsi: myrb: remove the dma_boundary limit
      scsi: block: remove the cluster flag
      scsi: remove the use_clustering flag
      scsi: mac53c94: remove DISABLE_CLUSTERING
      scsi: mesh: remove DISABLE_CLUSTERING
      scsi: xen-scsifront: remove DISABLE_CLUSTERING
      scsi: powertec: remove the explicit use_clustering setting
      scsi: cumana_2: remove the explicit use_clustering setting
      scsi: introduce a max_segment_size host_template parameters
      scsi: flip the default on use_clustering
      scsi: make sure all drivers set the use_clustering flag
      scsi: aha1542: convert to DMA mapping API
      scsi: wd719x: always use generic DMA API
      scsi: wd719x: use per-command private data
      scsi: wd719x: there should be no active SCBs on removal
      scsi: sym53c8xx: use dma_set_mask
      scsi: stex: use dma_set_mask_and_coherent
      scsi: mvumi: use dma_set_mask
      scsi: lpfc: use dma_set_mask_and_coherent
      scsi: isci: use dma_set_mask_and_coherent
      scsi: initio: use dma_set_mask
      scsi: hptiop: use dma_set_mask
      scsi: hisi_sas: use dma_set_mask_and_coherent
      scsi: esas2r: use dma_set_mask_and_coherent
      scsi: dpt_i2o: use dma_set_mask
      scsi: bfa: use dma_set_mask_and_coherent
      scsi: arcmsr: use dma_set_mask
      scsi: pmcraid: use generic DMA API
      scsi: pmcraid: don't allocate a dma coherent buffer for sense data
      scsi: pmcraid: simplify pmcraid_cancel_all a bit
      scsi: qla2xxx: use lower_32_bits and upper_32_bits instead of reinventing them
      scsi: qla1280: properly handle 64-bit DMA
      scsi: qla1280: use lower_32_bits and upper_32_bits instead of reinventing them
      scsi: ips: properly handle 64-bit DMA
      scsi: ips: use lower_32_bits and upper_32_bits instead of reinventing them

Colin Ian King (3):
      scsi: bfa: clean up a couple of indentation issues
      scsi: 3w-xxxx: fix indentation issue, add missing tab
      scsi: mpt3sas: fix spelling mistake "manufaucturing" -> "manufacturing"

Dave Carroll (7):
      scsi: smartpqi: correct volume status
      scsi: smartpqi: do not offline disks for transient did no connect conditions
      scsi: smartpqi: wake up drives after os resumes from suspend
      scsi: smartpqi: add sysfs attributes
      scsi: smartpqi: refactor sending controller raid requests
      scsi: smartpqi: turn off lun data caching for ptraid
      scsi: smartpqi: add no_write_same for logical volumes

David Disseldorp (9):
      scsi: target: perform t10_wwn ID initialisation in target_alloc_device()
      scsi: target: remove hardcoded T10 Vendor ID in INQUIRY response
      scsi: target: add device vendor_id configfs attribute
      scsi: target: consistently null-terminate t10_wwn strings
      scsi: target: use consistent left-aligned ASCII INQUIRY data
      scsi: target: replace fabric_ops.name with fabric_alias
      scsi: target: drop unnecessary get_fabric_name() accessor from fabric_ops
      scsi: target: drop unused pi_prot_format attribute storage
      scsi: target: add emulate_pr backstore attr to toggle PR support

Don Brace (4):
      scsi: smartpqi: fix build warnings
      scsi: smartpqi: update driver version
      scsi: smartpqi: bump driver version
      scsi: smartpqi: add smp_utils support

Ewan D. Milne (1):
      scsi: lpfc: do not set queue->page_count to 0 if pc_sli4_params.wqpcnt is invalid

Fedor Loshakov (1):
      scsi: zfcp: make DIX experimental, disabled, and independent of DIF

Fred Herard (1):
      scsi: iscsi: Capture iscsi debug messages using tracepoints

Giridhar Malavali (1):
      scsi: qla2xxx: Fix for FC-NVMe discovery for NPIV port

Gustavo A. R. Silva (14):
      scsi: isci: request: mark expected switch fall-through
      scsi: isci: remote_node_context: mark expected switch fall-throughs
      scsi: isci: remote_device: Mark expected switch fall-throughs
      scsi: isci: phy: Mark expected switch fall-through
      scsi: myrb: Mark expected switch fall-throughs
      scsi: mpt3sas: mpt3sas_scsih: Mark expected switch fall-through
      scsi: BusLogic: mark expected switch fall-through
      scsi: xen-scsifront: mark expected switch fall-through
      scsi: megaraid_sas_fusion: Mark expected switch fall-through
      scsi: megaraid: megaraid_sas_base: Mark expected switch fall-through
      scsi: libfc: fc_rport: Mark expected switch fall-through
      scsi: hpsa: mark expected switch fall-throughs
      scsi: aacraid: Mark expected switch fall-through
      scsi: aacraid: Mark expected switch fall-throughs

Himanshu Madhani (2):
      scsi: qla2xxx: Update driver version to 10.00.00.12-k
      scsi: qla2xxx: Fix NPIV handling for FC-NVMe

James Bottomley (1):
      scsi: aha1542: Fix zeroday __udivdi3 warning

James Smart (35):
      scsi: lpfc: Update lpfc version to 12.0.0.10
      scsi: lpfc: Adding ability to reset chip via pci bus reset
      scsi: lpfc: Add log messages to aid in debugging fc4type discovery issues
      scsi: lpfc: Fix discovery failure when PLOGI is defered
      scsi: lpfc: update fault value on successful trunk events.
      scsi: lpfc: Correct MDS loopback diagnostics support
      scsi: lpfc: Fix link state reporting for trunking when adapter is offline
      scsi: lpfc: Enable Management features for IF_TYPE=6
      scsi: lpfc: update driver version to 12.0.0.9
      scsi: lpfc: Fix dif and first burst use in write commands
      scsi: lpfc: Fix driver release of fw-logging buffers
      scsi: lpfc: Correct topology type reporting on G7 adapters
      scsi: lpfc: Correct code setting non existent bits in sli4 ABORT WQE
      scsi: lpfc: Defer LS_ACC to FLOGI on point to point logins
      scsi: lpfc: ls_rjt erroneus FLOGIs
      scsi: lpfc: rport port swap discovery issue.
      scsi: lpfc: Cap NPIV vports to 256
      scsi: lpfc: Fix kernel Oops due to null pring pointers
      scsi: lpfc: Fix a duplicate 0711 log message number.
      scsi: lpfc: Fix discovery failures during port failovers with lots of vports
      scsi: lpfc: refactor mailbox structure context fields
      scsi: lpfc: update manufacturer attribute to reflect Broadcom
      scsi: lpfc: Fix panic when FW-log buffsize is not initialized
      scsi: lpfc: update driver version to 12.0.0.8
      scsi: lpfc: add Trunking support
      scsi: lpfc: Implement GID_PT on Nameserver query to support faster failover
      scsi: lpfc: Correct loss of fc4 type on remote port address change
      scsi: lpfc: Fix odd recovery in duplicate FLOGIs in point-to-point
      scsi: lpfc: Correct LCB RJT handling
      scsi: lpfc: fcoe: Fix link down issue after 1000+ link bounces
      scsi: lpfc: Correct errors accessing fw log
      scsi: lpfc: Reset link or adapter instead of doing infinite nameserver PLOGI retry
      scsi: lpfc: Fix LOGO/PLOGI handling when triggerd by ABTS Timeout event
      scsi: lpfc: Fix lpfc_sli4_read_config return value check
      scsi: lpfc: Correct speeds on SFP swap

Janek Kotas (2):
      scsi: ufs: Add UFS platform driver for Cadence UFS
      scsi: dt-bindings: ufs: Add bindings for Cadence UFS

John Garry (6):
      scsi: hisi_sas: Fix warnings detected by sparse
      scsi: libsas: Remove pcidev reference
      scsi: libsas: Drop SAS_DPRINTK() and revise logs levels
      scsi: libsas: Drop sas_printk()
      scsi: libsas: Use pr_fmt(fmt)
      scsi: libsas: Delete sas_dump.{c, h}

Kevin Barnett (2):
      scsi: smartpqi: correct lun reset issues
      scsi: smartpqi: add support for PQI Config Table handshake

Mahesh Rajashekhara (5):
      scsi: smartpqi: add ofa support
      scsi: smartpqi: increase fw status register read timeout
      scsi: smartpqi: check for null device pointers
      scsi: smartpqi: correct host serial num for ssa
      scsi: smartpqi: Add retries for device reset

Manish Rangankar (3):
      scsi: qedi: Move LL2 producer index processing in BH.
      scsi: qedi: Add packet filter in light L2 Rx path.
      scsi: qedi: Check for session online before getting iSCSI TLV data.

Martin K. Petersen (1):
      Revert "scsi: lpfc: ls_rjt erroneus FLOGIs"

Murthy Bhat (2):
      scsi: smartpqi: fix disk name mount point
      scsi: smartpqi: add h3c ssid

Nilesh Javali (6):
      scsi: qedi: Update driver version to 8.33.0.21
      scsi: qedi: add module param to set ping packet size
      scsi: qedi: Allocate IRQs based on msix_cnt
      scsi: qedi: Replace PAGE_SIZE with QEDI_PAGE_SIZE
      scsi: qedi: Fix spelling mistake "OUSTANDING" -> "OUTSTANDING"
      scsi: qedi: Cleanup redundant QEDI_PAGE_SIZE macro definition

Qian Cai (1):
      scsi: megaraid: fix out-of-bound array accesses

Rob Herring (1):
      scsi: sun_esp: Use of_node_name_eq for node name comparisons

Sabyasachi Gupta (3):
      scsi: snic: Use vzalloc
      scsi: fnic: Use vzalloc
      scsi: lpfc: Use dma_zalloc_coherent

Sagar Biradar (1):
      scsi: smartpqi: enhance numa node detection

Shivasharan S (26):
      scsi: megaraid_sas: driver version update
      scsi: megaraid_sas: Use 63-bit DMA addressing
      scsi: megaraid_sas: add retry logic in megasas_readl
      scsi: megaraid_sas: changes to function prototypes
      scsi: megaraid_sas: Introduce new Aero adapter type
      scsi: megaraid_sas: Fix Ventura series based checks
      scsi: megaraid_sas: Add support for MegaRAID Aero controllers
      scsi: megaraid_sas: Update driver version
      scsi: megaraid_sas: modify max supported lds related print
      scsi: megaraid_sas: remove unused macro
      scsi: megaraid_sas: increase timeout for IOC INIT to 180seconds
      scsi: megaraid_sas: Remove double endian conversion
      scsi: megaraid_sas: Re-use max_mfi_cmds to calculate queue sizes
      scsi: megaraid_sas: Rename scratch_pad registers
      scsi: megaraid_sas: Remove spin lock for dpc operation
      scsi: megaraid_sas: optimize raid context access in IO path
      scsi: megaraid_sas: Fail init if heartbeat timer fails
      scsi: megaraid_sas: For SRIOV, do not set STOP_ADP bit
      scsi: megaraid_sas: Fix combined reply queue mode detection
      scsi: megaraid_sas: Fix module parameter description
      scsi: megaraid_sas: Fix goto labels in error handling
      scsi: megaraid_sas: Update copyright information
      scsi: megaraid_sas: Add check for reset adapter bit
      scsi: megaraid_sas: Fix msleep granularity
      scsi: megaraid_sas: Add support for FW snap dump
      scsi: megaraid_sas: Add watchdog thread to detect Firmware fault

Souptick Joarder (1):
      scsi: aic94xx: Use dma_pool_zalloc

Sreekanth Reddy (1):
      scsi: mpt3sas: Display message on Configurable secure HBA

Steffen Maier (23):
      scsi: zfcp: improve kdoc for return of zfcp_status_read_refill()
      scsi: zfcp: fix posting too many status read buffers leading to adapter shutdown
      scsi: zfcp: drop old default switch case which might paper over missing case
      scsi: zfcp: drop default switch case which might paper over missing case
      scsi: zfcp: silence -Wimplicit-fallthrough in zfcp_erp_lun_strategy()
      scsi: zfcp: silence remaining kdoc warnings in header files
      scsi: zfcp: silence all W=1 build warnings for existing kdoc
      scsi: zfcp: properly format LUN (and WWPN) for LUN sharing violation kmsg
      scsi: zfcp: use enum zfcp_erp_act_result for argument/return of affected functions
      scsi: zfcp: use enum zfcp_erp_steps for struct zfcp_erp_action.step
      scsi: zfcp: the action field of zfcp_erp_action is actually the type
      scsi: zfcp: clarify function argument name for trace tag string
      scsi: zfcp: ERP thread setup kdoc update
      scsi: zfcp: update kernel message for invalid FCP_CMND length, it's not the CDB
      scsi: zfcp: drop duplicate seq_no from zfcp_fsf_req which is also in QTCB header
      scsi: zfcp: drop duplicate fsf_command from zfcp_fsf_req which is also in QTCB header
      scsi: zfcp: drop unnecessary forward prototype for struct zfcp_fsf_req
      scsi: zfcp: group sort internal structure definitions for proximity
      scsi: zfcp: namespace prefix for internal latency data structures
      scsi: zfcp: update width in comment for ZFCP_COMMON_FLAGS mask
      scsi: zfcp: move scsi_eh & non-ERP timeout defines owned by and local to zfcp_fsf.c
      scsi: zfcp: drop unnecessary forward prototype for struct zfcp_reqlist
      scsi: zfcp: move SG table helper from aux to fc and make them static

Stephan Günther (1):
      scsi: mpt3sas: fix memory ordering on 64bit writes

Subhash Jadavani (1):
      scsi: ufs: set the device reference clock setting

Suganath Prabu (14):
      scsi: mpt3sas: Update driver version to 27.101.00.00
      scsi: mpt3sas: Replace readl with ioc->base_readl
      scsi: mpt3sas: Add separate function for aero doorbell reads
      scsi: mpt3sas: Introduce flag for aero based controllers
      scsi: mpt3sas: Bump driver version to 27.100.00.00
      scsi: mpt3sas: Fix driver modifying persistent data in Manufacturing page11
      scsi: mpt3sas: Don't modify EEDPTagMode field setting on SAS3.5 HBA devices
      scsi: mpt3sas: Fix Sync cache command failure during driver unload
      scsi: mpt3sas: Call sas_remove_host before removing the target devices
      scsi: mpt3sas: Refactor mpt3sas_wait_for_ioc function
      scsi: mpt3sas: Separate out mpt3sas_wait_for_ioc
      scsi: mpt3sas: Added new #define variable IOC_OPERATIONAL_WAIT_COUNT
      scsi: mpt3sas: Add support for Aero controllers
      scsi: mpt3sas: Update MPI headers to support Aero controllers

Thomas Meyer (3):
      scsi: qla2xxx: NULL check before some freeing functions is not needed
      scsi: qedf: NULL check before some freeing functions is not needed
      scsi: megaraid_sas: NULL check before some freeing functions is not needed

Tomas Winkler (1):
      scsi: ufs: add fall through annotation

Varun Prakash (2):
      scsi: csiostor: fix incorrect dma device in case of vport
      scsi: csiostor: remove flush_scheduled_work()

Wei Yongjun (1):
      scsi: target/core: Use kmem_cache_free() instead of kfree()

Xiang Chen (8):
      scsi: hisi_sas: Add support for DIF feature for v2 hw
      scsi: hisi_sas: Make sg_tablesize consistent value
      scsi: hisi_sas: Relocate some code to reduce complexity
      scsi: hisi_sas: change the time of SAS SSP connection
      scsi: hisi_sas: Relocate some codes to avoid an unused check
      scsi: hisi_sas: Add support for interrupt coalescing for v3 hw
      scsi: hisi_sas: Add support for interrupt converge for v3 hw
      scsi: hisi_sas: Create separate host attributes per HBA

Yanjiang Jin (1):
      scsi: smartpqi: call pqi_free_interrupts() in pqi_shutdown()

Yue Haibing (1):
      scsi: libfc: Remove set but not used variable 'disc'

YueHaibing (3):
      scsi: fcoe: remove set but not used variable 'port'
      scsi: ufs: Fix platform_no_drv_owner.cocci warnings
      scsi: bnx2i: remove set but not used variable 'cid_num'

zhong jiang (1):
      scsi: zfcp: remove unnecessary null pointer check before mempool_destroy

And the diffstat

 .../devicetree/bindings/ufs/cdns,ufshc.txt         |   31 +
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |    6 +
 Documentation/scsi/scsi_mid_low_api.txt            |    2 -
 arch/ia64/hp/sim/simscsi.c                         |    2 +-
 block/blk-merge.c                                  |   18 +-
 block/blk-settings.c                               |    3 -
 block/blk-sysfs.c                                  |    5 +-
 drivers/firewire/sbp2.c                            |    1 -
 drivers/infiniband/ulp/iser/iscsi_iser.c           |    1 -
 drivers/infiniband/ulp/srp/ib_srp.c                |    1 -
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    8 +-
 drivers/message/fusion/mptfc.c                     |    1 -
 drivers/message/fusion/mptsas.c                    |    1 -
 drivers/message/fusion/mptspi.c                    |    1 -
 drivers/s390/scsi/zfcp_aux.c                       |   82 +-
 drivers/s390/scsi/zfcp_dbf.c                       |   25 +-
 drivers/s390/scsi/zfcp_dbf.h                       |   14 +-
 drivers/s390/scsi/zfcp_def.h                       |  113 +-
 drivers/s390/scsi/zfcp_erp.c                       |  345 +++--
 drivers/s390/scsi/zfcp_ext.h                       |    9 +-
 drivers/s390/scsi/zfcp_fc.c                        |   48 +-
 drivers/s390/scsi/zfcp_fc.h                        |   21 +-
 drivers/s390/scsi/zfcp_fsf.c                       |   51 +-
 drivers/s390/scsi/zfcp_fsf.h                       |    4 +-
 drivers/s390/scsi/zfcp_qdio.c                      |   11 +-
 drivers/s390/scsi/zfcp_qdio.h                      |    9 +-
 drivers/s390/scsi/zfcp_reqlist.h                   |    2 +-
 drivers/s390/scsi/zfcp_scsi.c                      |   15 +-
 drivers/scsi/3w-9xxx.c                             |    1 -
 drivers/scsi/3w-sas.c                              |    1 -
 drivers/scsi/3w-xxxx.c                             |    3 +-
 drivers/scsi/53c700.c                              |    1 -
 drivers/scsi/BusLogic.c                            |    2 +-
 drivers/scsi/a100u2w.c                             |    1 -
 drivers/scsi/a2091.c                               |    2 +-
 drivers/scsi/a3000.c                               |    1 -
 drivers/scsi/aacraid/aachba.c                      |    5 +-
 drivers/scsi/aacraid/aacraid.h                     |    5 +-
 drivers/scsi/aacraid/commctrl.c                    |    5 +-
 drivers/scsi/aacraid/commsup.c                     |   19 +-
 drivers/scsi/aacraid/dpcsup.c                      |   19 +-
 drivers/scsi/aacraid/linit.c                       |    4 +-
 drivers/scsi/aacraid/src.c                         |    2 +-
 drivers/scsi/advansys.c                            |   12 +-
 drivers/scsi/aha152x.c                             |    2 +-
 drivers/scsi/aha1542.c                             |  127 +-
 drivers/scsi/aha1740.c                             |    1 -
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |    1 -
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |    1 -
 drivers/scsi/aic94xx/aic94xx_hwi.c                 |    3 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |    1 -
 drivers/scsi/arcmsr/arcmsr_hba.c                   |    9 +-
 drivers/scsi/arm/acornscsi.c                       |    2 +-
 drivers/scsi/arm/arxescsi.c                        |    2 +-
 drivers/scsi/arm/cumana_1.c                        |    2 +-
 drivers/scsi/arm/cumana_2.c                        |    1 -
 drivers/scsi/arm/eesox.c                           |    1 -
 drivers/scsi/arm/oak.c                             |    2 +-
 drivers/scsi/arm/powertec.c                        |    1 -
 drivers/scsi/atari_scsi.c                          |    2 +-
 drivers/scsi/atp870u.c                             |    1 -
 drivers/scsi/be2iscsi/be_main.c                    |    9 +-
 drivers/scsi/bfa/bfa_ioc.c                         |    4 +-
 drivers/scsi/bfa/bfad.c                            |   18 +-
 drivers/scsi/bfa/bfad_im.c                         |    2 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    1 -
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    2 -
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |    1 -
 drivers/scsi/csiostor/csio_init.c                  |    3 +-
 drivers/scsi/csiostor/csio_scsi.c                  |    2 -
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |    2 +-
 drivers/scsi/cxgbi/cxgb4i/Kconfig                  |    4 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |    2 +-
 drivers/scsi/cxlflash/main.c                       |    1 -
 drivers/scsi/dc395x.c                              |    2 +-
 drivers/scsi/dmx3191d.c                            |    2 +-
 drivers/scsi/dpt_i2o.c                             |   13 +-
 drivers/scsi/esas2r/esas2r_init.c                  |   49 +-
 drivers/scsi/esas2r/esas2r_main.c                  |    1 -
 drivers/scsi/esp_scsi.c                            |    1 -
 drivers/scsi/fcoe/fcoe.c                           |    5 -
 drivers/scsi/fnic/fnic_main.c                      |    1 -
 drivers/scsi/fnic/fnic_trace.c                     |    3 +-
 drivers/scsi/g_NCR5380.c                           |    2 +-
 drivers/scsi/gdth.c                                |    1 -
 drivers/scsi/gvp11.c                               |    2 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |   13 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  203 +--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   25 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   74 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  322 +++-
 drivers/scsi/hosts.c                               |    6 +-
 drivers/scsi/hpsa.c                                |    6 +-
 drivers/scsi/hptiop.c                              |   11 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |    1 -
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |    1 -
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |    8 +-
 drivers/scsi/imm.c                                 |    1 -
 drivers/scsi/initio.c                              |    3 +-
 drivers/scsi/ipr.c                                 |    1 -
 drivers/scsi/ips.c                                 |   10 +-
 drivers/scsi/ips.h                                 |    9 -
 drivers/scsi/isci/init.c                           |   20 +-
 drivers/scsi/isci/phy.c                            |    1 +
 drivers/scsi/isci/remote_device.c                  |    4 +-
 drivers/scsi/isci/remote_node_context.c            |    4 +-
 drivers/scsi/isci/request.c                        |    2 +-
 drivers/scsi/iscsi_tcp.c                           |    6 +-
 drivers/scsi/libfc/fc_rport.c                      |    3 +-
 drivers/scsi/libiscsi.c                            |   10 +
 drivers/scsi/libiscsi_tcp.c                        |    4 +
 drivers/scsi/libsas/Makefile                       |    3 +-
 drivers/scsi/libsas/sas_ata.c                      |   26 +-
 drivers/scsi/libsas/sas_discover.c                 |   33 +-
 drivers/scsi/libsas/sas_dump.c                     |   63 -
 drivers/scsi/libsas/sas_dump.h                     |   29 -
 drivers/scsi/libsas/sas_event.c                    |    1 -
 drivers/scsi/libsas/sas_expander.c                 |  236 ++-
 drivers/scsi/libsas/sas_init.c                     |   10 +-
 drivers/scsi/libsas/sas_internal.h                 |   16 +-
 drivers/scsi/libsas/sas_phy.c                      |    8 +-
 drivers/scsi/libsas/sas_port.c                     |   23 +-
 drivers/scsi/libsas/sas_scsi_host.c                |  123 +-
 drivers/scsi/libsas/sas_task.c                     |   10 +-
 drivers/scsi/lpfc/lpfc.h                           |   29 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  230 ++-
 drivers/scsi/lpfc/lpfc_bsg.c                       |  200 ++-
 drivers/scsi/lpfc/lpfc_bsg.h                       |   38 +
 drivers/scsi/lpfc/lpfc_crtn.h                      |    5 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |  261 +++-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    2 +
 drivers/scsi/lpfc/lpfc_disc.h                      |    4 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  468 ++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  224 ++-
 drivers/scsi/lpfc/lpfc_hw.h                        |    1 +
 drivers/scsi/lpfc/lpfc_hw4.h                       |   80 +
 drivers/scsi/lpfc/lpfc_init.c                      |  273 +++-
 drivers/scsi/lpfc/lpfc_mbox.c                      |   44 +-
 drivers/scsi/lpfc/lpfc_mem.c                       |    6 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   81 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |    2 -
 drivers/scsi/lpfc/lpfc_scsi.c                      |  145 +-
 drivers/scsi/lpfc/lpfc_scsi.h                      |    4 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  309 ++--
 drivers/scsi/lpfc/lpfc_sli.h                       |    6 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   14 +
 drivers/scsi/lpfc/lpfc_version.h                   |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |    4 +-
 drivers/scsi/mac53c94.c                            |    2 +-
 drivers/scsi/mac_esp.c                             |    2 +-
 drivers/scsi/mac_scsi.c                            |    2 +-
 drivers/scsi/megaraid.c                            |    1 -
 drivers/scsi/megaraid/megaraid_mbox.c              |   10 +-
 drivers/scsi/megaraid/megaraid_mm.c                |    3 +-
 drivers/scsi/megaraid/megaraid_sas.h               |   74 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  447 ++++--
 drivers/scsi/megaraid/megaraid_sas_fp.c            |   24 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  470 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |   26 +-
 drivers/scsi/mesh.c                                |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h                    |   17 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h               |   94 +-
 drivers/scsi/mpt3sas/mpi/mpi2_image.h              |  506 ++++++
 drivers/scsi/mpt3sas/mpi/mpi2_init.h               |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h                |  359 +----
 drivers/scsi/mpt3sas/mpi/mpi2_pci.h                |   11 +-
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h               |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h                |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h               |   72 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  145 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   14 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |   29 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   21 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   72 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   91 +-
 drivers/scsi/mvme147.c                             |    1 -
 drivers/scsi/mvsas/mv_init.c                       |    1 -
 drivers/scsi/mvumi.c                               |    3 +-
 drivers/scsi/myrb.c                                |    3 +
 drivers/scsi/ncr53c8xx.c                           |    1 -
 drivers/scsi/nsp32.c                               |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c                       |    2 +-
 drivers/scsi/pcmcia/qlogic_stub.c                  |    2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c                 |    1 -
 drivers/scsi/pm8001/pm8001_init.c                  |    1 -
 drivers/scsi/pmcraid.c                             |  117 +-
 drivers/scsi/ppa.c                                 |    1 -
 drivers/scsi/ps3rom.c                              |    1 -
 drivers/scsi/qedf/qedf_main.c                      |    4 +-
 drivers/scsi/qedi/qedi.h                           |    7 +-
 drivers/scsi/qedi/qedi_iscsi.c                     |    1 -
 drivers/scsi/qedi/qedi_main.c                      |   87 +-
 drivers/scsi/qedi/qedi_version.h                   |    4 +-
 drivers/scsi/qla1280.c                             |   53 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |    2 +
 drivers/scsi/qla2xxx/qla_init.c                    |   10 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |    1 +
 drivers/scsi/qla2xxx/qla_nvme.c                    |   16 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  101 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   22 +-
 drivers/scsi/qla2xxx/qla_target.h                  |    8 -
 drivers/scsi/qla2xxx/qla_version.h                 |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   64 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                 |    3 -
 drivers/scsi/qla4xxx/ql4_os.c                      |   11 +-
 drivers/scsi/qlogicfas.c                           |    2 +-
 drivers/scsi/qlogicpti.c                           |    1 -
 drivers/scsi/scsi_debug.c                          |    8 +-
 drivers/scsi/scsi_lib.c                            |    6 +-
 drivers/scsi/scsi_transport_iscsi.c                |   34 +-
 drivers/scsi/sgiwd93.c                             |    2 +-
 drivers/scsi/smartpqi/smartpqi.h                   |  216 ++-
 drivers/scsi/smartpqi/smartpqi_init.c              | 1606 +++++++++++++++++---
 drivers/scsi/smartpqi/smartpqi_sas_transport.c     |  164 +-
 drivers/scsi/smartpqi/smartpqi_sis.c               |   15 +-
 drivers/scsi/smartpqi/smartpqi_sis.h               |    1 +
 drivers/scsi/snic/snic_main.c                      |    1 -
 drivers/scsi/snic/snic_trc.c                       |    3 +-
 drivers/scsi/stex.c                                |   18 +-
 drivers/scsi/storvsc_drv.c                         |    1 -
 drivers/scsi/sun3_scsi.c                           |    2 +-
 drivers/scsi/sun_esp.c                             |    7 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |    5 +-
 drivers/scsi/ufs/Kconfig                           |    8 +
 drivers/scsi/ufs/Makefile                          |    1 +
 drivers/scsi/ufs/cdns-pltfrm.c                     |  148 ++
 drivers/scsi/ufs/ufs.h                             |   18 +-
 drivers/scsi/ufs/ufshcd.c                          |  104 +-
 drivers/scsi/ufs/ufshcd.h                          |    2 +
 drivers/scsi/virtio_scsi.c                         |   53 -
 drivers/scsi/vmw_pvscsi.c                          |    1 -
 drivers/scsi/wd719x.c                              |  136 +-
 drivers/scsi/wd719x.h                              |    1 -
 drivers/scsi/xen-scsifront.c                       |    3 +-
 drivers/staging/rts5208/rtsx.c                     |    6 -
 drivers/staging/unisys/visorhba/visorhba_main.c    |    1 -
 drivers/target/iscsi/iscsi_target.c                |   11 +-
 drivers/target/iscsi/iscsi_target_configfs.c       |   11 +-
 drivers/target/iscsi/iscsi_target_erl1.c           |   28 +-
 drivers/target/loopback/tcm_loop.c                 |   10 +-
 drivers/target/sbp/sbp_target.c                    |    8 +-
 drivers/target/target_core_alua.c                  |    6 +-
 drivers/target/target_core_configfs.c              |  157 +-
 drivers/target/target_core_device.c                |  111 +-
 drivers/target/target_core_fabric_configfs.c       |    2 +-
 drivers/target/target_core_internal.h              |    2 -
 drivers/target/target_core_pr.c                    |   90 +-
 drivers/target/target_core_pscsi.c                 |   50 +-
 drivers/target/target_core_spc.c                   |   28 +-
 drivers/target/target_core_stat.c                  |   34 +-
 drivers/target/target_core_tmr.c                   |   56 +-
 drivers/target/target_core_tpg.c                   |   23 +-
 drivers/target/target_core_transport.c             |  416 +++--
 drivers/target/target_core_ua.c                    |    4 +-
 drivers/target/target_core_user.c                  |    2 +-
 drivers/target/target_core_xcopy.c                 |   13 +-
 drivers/target/tcm_fc/tfc_conf.c                   |    8 +-
 drivers/usb/gadget/function/f_tcm.c                |    8 +-
 drivers/usb/image/microtek.c                       |    1 -
 drivers/usb/storage/scsiglue.c                     |    7 -
 drivers/usb/storage/uas.c                          |    1 +
 drivers/vhost/scsi.c                               |    8 +-
 drivers/xen/xen-scsiback.c                         |    8 +-
 include/linux/blkdev.h                             |    6 -
 include/linux/libata.h                             |    2 -
 include/scsi/scsi_host.h                           |   20 +-
 include/target/target_core_base.h                  |   25 +-
 include/target/target_core_fabric.h                |   25 +-
 include/trace/events/iscsi.h                       |  107 ++
 269 files changed, 7999 insertions(+), 3861 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
 delete mode 100644 drivers/scsi/libsas/sas_dump.c
 delete mode 100644 drivers/scsi/libsas/sas_dump.h
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_image.h
 create mode 100644 drivers/scsi/ufs/cdns-pltfrm.c
 create mode 100644 include/trace/events/iscsi.h

James

---

diff --cc drivers/scsi/qla2xxx/qla_os.c
index d0ecc729a90a,90f1742cff58..89f952cb4795
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@@ -1746,6 -1745,41 +1745,49 @@@ qla2x00_loop_reset(scsi_qla_host_t *vha
  	return QLA_SUCCESS;
  }
  
+ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
+ 			      unsigned long *flags)
+ 	__releases(qp->qp_lock_ptr)
+ 	__acquires(qp->qp_lock_ptr)
+ {
+ 	scsi_qla_host_t *vha = qp->vha;
+ 	struct qla_hw_data *ha = vha->hw;
+ 
+ 	if (sp->type == SRB_NVME_CMD || sp->type == SRB_NVME_LS) {
+ 		if (!sp_get(sp)) {
+ 			/* got sp */
+ 			spin_unlock_irqrestore(qp->qp_lock_ptr, *flags);
+ 			qla_nvme_abort(ha, sp, res);
+ 			spin_lock_irqsave(qp->qp_lock_ptr, *flags);
+ 		}
+ 	} else if (GET_CMD_SP(sp) && !ha->flags.eeh_busy &&
+ 		   !test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) &&
+ 		   !qla2x00_isp_reg_stat(ha) && sp->type == SRB_SCSI_CMD) {
+ 		/*
+ 		 * Don't abort commands in adapter during EEH recovery as it's
+ 		 * not accessible/responding.
+ 		 *
+ 		 * Get a reference to the sp and drop the lock. The reference
+ 		 * ensures this sp->done() call and not the call in
+ 		 * qla2xxx_eh_abort() ends the SCSI cmd (with result 'res').
+ 		 */
+ 		if (!sp_get(sp)) {
++			int status;
++
+ 			spin_unlock_irqrestore(qp->qp_lock_ptr, *flags);
 -			qla2xxx_eh_abort(GET_CMD_SP(sp));
++			status = qla2xxx_eh_abort(GET_CMD_SP(sp));
+ 			spin_lock_irqsave(qp->qp_lock_ptr, *flags);
++			/*
++			 * Get rid of extra reference caused
++			 * by early exit from qla2xxx_eh_abort
++			 */
++			if (status == FAST_IO_FAIL)
++				atomic_dec(&sp->ref_count);
+ 		}
+ 	}
+ 	sp->done(sp, res);
+ }
+ 
  static void
  __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
  {
