From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 3.1 merge window
Date: Fri, 28 Oct 2011 08:17:18 +0200
Message-ID: <1319782638.22700.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This represents the usual round of driver updates (fusion, mvsas, isci,
qla2 qla4, iscsi, lpfc, be2iscsi, bnx2fc, megaraid, fcoe and ipr).
There is also a new Marvell UMI driver and this also contains the gendev
preferred_name update, which will set how the user wants their disk
device to be reported by the kernel printk system.  One of the
highlights of the release is the increasing use of the block generic
device to transport configuration information to HBAs.

The head sha1 is

commit 590134fa78fbdbe5fea78c7ae0b2c3364bc9572f

The patch is available here:

git://git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adam Radford (11):
      megaraid_sas: Fix instance access in megasas_reset_timer
      megaraid_sas: Changelog and version update
      megaraid_sas: Add driver workaround for PERC5/1068 kdump kernel panic
      megaraid_sas: Add multiple MSI-X vector/multiple reply queue support
      megaraid_sas: Add support for MegaRAID 9360/9380 12GB/s controllers
      megaraid_sas: Clear FUSION_IN_RESET before enabling interrupts
      megaraid_sas: Clear state change interrupts
      megaraid_sas: Remove some unnecessary code
      megaraid_sas: Fix mismatch in megasas_reset_fusion() mutex lock-unlock
      megaraid_sas: Increase default cmds per lun to 256
      megaraid_sas: Continue booting immediately if FW in FAULT at driver load time

Anton Blanchard (1):
      ipr: Always initiate hard reset in kdump kernel

Bhanu Prakash Gollapudi (34):
      bnx2fc: Bumped version to 1.0.8
      bnx2fc: Return error statistics of remote peer
      fcoe,libfcoe: Move common code for fcoe_get_lesb to fcoe_transport
      bnx2fc: call ctlr_link_up only when the interface is enabled
      bnx2fc: Bumped version to 1.0.7
      bnx2fc: Handle bnx2fc_map_sg failure
      bnx2fc: Replace scsi_dma_map() with dma_map_sg().
      bnx2fc: Add driver documentation
      bnx2fc: Bumped version to 1.0.6
      bnx2fc: Fix FW assert during RSCN stress tests
      bnx2fc: Fix panic caused because of incorrect errror handling in create().
      bnx2fc: Avoid calling bnx2fc_if_destroy with unnecessary locks
      bnx2fc: No abort issued for REC when it times out
      bnx2fc: Send solicitation only after vlan discovery is complete
      bnx2fc: Reset max receive frame size during link up
      bnx2fc: Need not schedule destroy_work from __bnx2fc_destroy
      bnx2fc: Bump version to 1.0.5
      bnx2fc: Prevent creating of NPIV port with duplicate WWN
      bnx2fc: Obtain WWNN/WWPN from the shared memory
      fcoe: Move common functions to fcoe_transport library
      bnx2fc: Drop incoming ABTS
      bnx2fc: code cleanup in bnx2fc_offload_session
      bnx2fc: Fix NULL pointer deref during arm_cq.
      bnx2fc: IO errors when receiving unsolicited LOGO
      bnx2fc: Do not reuse the fcoe connection id immediately
      bnx2fc: Clear DESTROY_CMPL flag after firmware destroy
      bnx2fc: Handle NETDEV_UNREGISTER for vlan devices
      bnx2fc: Reorganize cleanup code between interface_cleanup and if_destory
      bnx2fc: Change function names of bnx2fc_netdev_setup/bnx2fc_netdev_cleanup
      bnx2fc: Do not attempt destroying NPIV port twice
      bnx2fc: Remove erroneous kref_get on IO request
      bnx2fc: Enable bsg_request support for bnx2fc
      bnx2fc: Bug fixes in percpu_thread_create/destroy
      bnx2fc: Reset the max receive frame size

Brian King (2):
      ipr: Fix BUG on adapter dump timeout
      ipr: Stop reading adapter dump prematurely

Chad Dupuis (2):
      qla2xxx: Fix "active_mask" may be used uninitialized warning.
      qla2xxx: Enable write permission to some debug related module parameters to be changed dynamically.

Chauhan, Vijay (1):
      scsi_dh_rdac: Adding NetApp as a brand name for rdac

Christoph Hellwig (3):
      libsas: fix sas_queuecommand return values
      libsas: reindent sas_queuecommand
      libsas: sas_queuecommand doesnt need host_lock

Dan Carpenter (1):
      aacraid: use lower snprintf() limit

Dan Williams (15):
      libsas: fix port->dev_list locking
      isci: export phy events via ->lldd_control_phy()
      isci: atapi support
      isci: fix support for large smp requests
      libsas: fix warnings when checking sata/stp protocol
      libsas: fix try_test_sas_gpio_gp_bit() build error
      pm8001: remove pm8001_slave_{alloc|configure}
      mvsas: remove mvs_slave_{alloc|configure}
      libsas: dynamic queue depth
      libsas,libata: fix ->change_queue_{depth|type} for sata devices
      libsas: disable scanning lun > 0 on ata devices
      isci: initial sgpio write support
      isci: fix sgpio register definitions
      libsas: sgpio write support
      libsas: export sas_alloc_task()

Eric Dumazet (1):
      fcoe: use kthread_create_on_node

Finn Thain (1):
      mac_esp: remove redundant mutual exclusion

Giridhar Malavali (2):
      qla2xxx: Issue mailbox command only when firmware hung bit is reset for ISP82xx.
      qla2xxx: Add support for ISP82xx to capture dump (minidump) on failure.

Hannes Reinecke (7):
      scsi_dh_alua: Decrease retry interval
      scsi_dh_alua: Fix Erroneous TPG ID check
      scsi_dh: Check for sdev state in store_dh_state()
      scsi_dh_alua: always update TPGS status on activate
      scsi_dh: Implement match callback function
      scsi_dh: Fixup kernel-doc comments
      scsi_dh_alua: Evaluate TPGS setting from inquiry data

Harish Zunjarrao (5):
      qla4xxx: Added Get ACB support using BSG
      qla4xxx: Added restore factory defaults support using BSG
      qla4xxx: Add read/update NVRAM support for 40xx adapters using BSG
      qla4xxx: Add get ACB state support using BSG
      qla4xxx: Code cleanup for read/update flash using BSG

Jack Wang (1):
      libsas: set sas_address and device type of rphy

James Smart (10):
      lpfc 8.3.27: Change driver version to 8.3.27
      lpfc 8.3.27: T10 additions for SLI4
      lpfc 8.3.27: Fix queue allocation failure recovery
      lpfc 8.3.27: Change algorithm for getting physical port name
      lpfc 8.3.27: Changed worst case mailbox timeout
      lpfc 8.3.27: Miscellanous logic and interface fixes
      lpfc 8.3.26: Change driver version to 8.3.26
      lpfc 8.3.26: Fix SYSFS interface issues
      lpfc 8.3.26: Fix HBA initialization issues
      lpfc 8.3.26: Fix issues pertaining to SCSI/FC protocol.

Jayamohan Kallickal (8):
      be2iscsi: Move driver Version to 4.1.239.0
      be2iscsi: memset wrb for ring create
      be2iscsi: Fix for case where task->sc was cleanedup earlier
      be2iscsi: Fix for wrong dmsg setting in wrb
      be2iscsi: Fix for kdump failure
      be2iscsi: Add pci_disable device
      be2iscsi: Adding a shutdown Routine
      be2iscsi: Fixing the /proc/interrupts problem V3

Jeff Skirvin (4):
      isci: The port state should be set to stopping on the last phy.
      isci: fix decode of DONE_CRC_ERR TC completion status
      isci: SATA/STP I/O is only returned in the normal path to libsas
      isci: fix missed unlock in apc_agent_timeout()

Jianyun Li (1):
      mvumi: Add Marvell UMI driver

Joe Carnuccio (3):
      qla2xxx: Return sysfs error codes appropriate to conditions.
      qla2xxx: Provide method for updating I2C attached VPD.
      qla2xxx: Correction to sysfs edc interface.

Julia Lawall (1):
      mpt2sas: take size of pointed value, not pointer

Lalit Chandivade (5):
      qla4xxx: Free Device Database (DDB) reserved by FW
      qla4xxx: Fix getting BIDI CHAP for boot targets
      qla4xxx: Fix exporting boot targets to sysfs
      qla4xxx: Do not add duplicate CHAP entry in FLASH
      qla4xxx: Fix bidirectional CHAP.

Luben Tuikov (1):
      libsas: Allow expander T-T attachments

Manish Rangankar (10):
      qla4xxx: updated device id check for BFS.
      qla4xxx: Fixed target discovery failed issue.
      qla4xxx: Fixed active session re-open issue.
      qla4xxx: Fixed device blocked issue on link up-down.
      qla4xxx: Fixed session destroy issue on link up-down.
      qla4xxx: Clear DDB map index on the basis of AEN.
      qla4xxx: Boot from SAN support for open-iscsi
      qla4xxx: Remove reduandant code after open-iscsi integration.
      qla4xxx: support iscsiadm session mgmt
      scsi_transport_iscsi: Add conn login, kernel to user, event to support offload session login.

Mark Salyzyn (2):
      pm8001: missing break statements
      pm8001: fix DEV_IS_GONE infinite retry

Meelis Roos (1):
      qlogicpti: fix timeout

Mike Christie (19):
      qla4xxx: export address/port of connection (fix udev disk names)
      iscsi class: fix vlan configuration
      qla4xxx: fix data alignment and use nl helpers
      iscsi class: fix link local mispelling
      iscsi class: Replace iscsi_get_next_target_id with IDA
      qla4xxx: select iscsi boot sysfs attrs
      scsi scan: don't fail scans when host is in recovery
      qla4xxx: export iface name
      iscsi class: add bsg support to iscsi class
      libiscsi: don't bugon when if user sets markers
      iscsi class: expand vlan support
      be2iscsi: remove host and session casts
      iscsi class: sysfs group is_visible callout for iscsi host attrs
      iscsi class: remove iface param mask
      iscsi class: sysfs group is_visible callout for session attrs
      iscsi cls: sysfs group is_visible callout for conn attrs
      iscsi class: add iface representation
      qla4xxx: add support for set_net_config
      iscsi_transport: add support for net settings

Mike Miller (1):
      hpsa: change confusing message to be more clear

Moger, Babu (2):
      scsi_dh_alua: Add one more check-condition for alua handler
      scsi_dh_rdac: Adding couple more vendor product ids

Nao Nishijima (2):
      sd: Use sd_printk() instead of printk()
      genhd: add a new attribute "alias" in gendisk

Nilesh Javali (1):
      qla4xxx: Add new FLT firmware region

Nithin Nayak Sujir (1):
      bnx2fc: Validate vlan id in NETDEV_UNREGISTER handler

Saurav Kashyap (5):
      qla2xxx: During loopdown perform Diagnostic loopback.
      qla2xxx: Fix array out of bound warning.
      qla2xxx: check for marker IOCB during response queue processing.
      qla2xxx: Prevent CPU lockups when "ql2xdontresethba" module param is set.
      qla2xxx: Implemeted beacon on/off for ISP82XX.

Steffen Maier (1):
      zfcp: non-experimental support for DIF/DIX

Swen Schillig (2):
      zfcp: support for hardware data router
      qdio: base support for hardware data router with zfcp

TARUISI Hiroaki (1):
      Fix out of spec CD-ROM problem with media change

Vasu Dev (5):
      fcoe: setup default initial value for DDP threshold
      fcoe: use real dev in case of HW vlan acceleration
      libfc: cache align fc_exch_pool
      libfc: cache align struct fc_exch fields
      libfc: cache align struct fc_fcp_pkt fields

Vikas Chaudhary (13):
      qla4xxx: Update driver version to 5.02.00-k8
      qla4xxx: Update license
      qla4xxx: Added support for adapter and firmware reset
      scsi: Added support for adapter and firmware reset
      qla4xxx: added support to update initiator iscsi port
      scsi_transport_iscsi: Added support to update initiator iscsi port
      qla4xxx: Added vendor specific sysfs attributes
      qla4xxx: Added support to update mtu
      scsi_transport_iscsi: Added support to update mtu
      qla4xxx: add bsg support
      qla4xxx: Add VLAN support
      qla4xxx: added support to show multiple iface in sysfs
      qla4xxx: Added new "struct ipaddress_config"

Wayne Boyer (1):
      ipr: Add support to flash FPGA and flash back DRAM images

Xiangliang Yu (8):
      mvsas: update driver version
      mvsas: fixed SMP request watchdog timeout issue.
      mvsas: expander write performance enhancement
      mvsas: change SL mode0 register value
      mvsas: fixed wrong destination when hiting NAK for command frame
      mvsas: fixed some disk spin up issue
      mvsas: add support for 9480 device id
      mvsas: fix expander link error

kashyap.desai@lsi.com (6):
      mptfusion: Fix for device offline while doing aggressive HBA reset
      mpt2sas: Added missing mpt2sas_base_detach call from scsih_remove context
      mptfusion: Bump version 3.4.20
      mptfusion: Avoid out of order Event processing due to cpu migration
      mptfusion: Better handling of DEAD IOC PCI-E Link down error condition
      mptfusion: Set max sector count module parameter

nagalakshmi.nandigama@lsi.com (3):
      mptfusion: Added check for SILI bit in READ_16 CDB for DATA UNDERRUN ERRATA
      mpt2sas: Bump driver version 09.100.00.01
      mpt2sas: Added NUNA IO support in driver which uses multi-reply queue support of the HBA

and the diffstat

 Documentation/ABI/testing/sysfs-block       |   13 +
 Documentation/scsi/00-INDEX                 |    2 +
 Documentation/scsi/ChangeLog.megaraid_sas   |   15 +
 Documentation/scsi/LICENSE.qla4xxx          |  310 ++++
 Documentation/scsi/bnx2fc.txt               |   75 +
 arch/s390/include/asm/qdio.h                |    5 +
 block/genhd.c                               |   71 +
 drivers/ata/libata-core.c                   |    1 +
 drivers/ata/libata-scsi.c                   |   44 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c    |   80 +-
 drivers/message/fusion/mptbase.c            |   92 +-
 drivers/message/fusion/mptbase.h            |   72 +-
 drivers/message/fusion/mptsas.c             |   47 +-
 drivers/message/fusion/mptscsih.c           |   18 +-
 drivers/message/fusion/mptscsih.h           |    1 +
 drivers/s390/cio/qdio_main.c                |   11 +-
 drivers/s390/cio/qdio_setup.c               |    1 +
 drivers/s390/scsi/zfcp_dbf.c                |   36 +
 drivers/s390/scsi/zfcp_def.h                |    7 +
 drivers/s390/scsi/zfcp_ext.h                |    1 +
 drivers/s390/scsi/zfcp_fsf.c                |   80 +-
 drivers/s390/scsi/zfcp_qdio.c               |   58 +-
 drivers/s390/scsi/zfcp_qdio.h               |   66 +-
 drivers/s390/scsi/zfcp_scsi.c               |   15 +-
 drivers/scsi/Kconfig                        |   14 +-
 drivers/scsi/Makefile                       |    1 +
 drivers/scsi/aacraid/linit.c                |    7 +-
 drivers/scsi/aic94xx/aic94xx_scb.c          |    1 +
 drivers/scsi/be2iscsi/be_cmds.c             |   20 +
 drivers/scsi/be2iscsi/be_cmds.h             |    2 +
 drivers/scsi/be2iscsi/be_iscsi.c            |   60 +-
 drivers/scsi/be2iscsi/be_iscsi.h            |    2 +
 drivers/scsi/be2iscsi/be_main.c             |  112 +-
 drivers/scsi/be2iscsi/be_main.h             |    5 +-
 drivers/scsi/bnx2fc/bnx2fc.h                |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c            |   26 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |  226 ++-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c            |   16 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c             |   32 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c            |   23 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |   80 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c          |   20 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c          |   20 +-
 drivers/scsi/cxgbi/libcxgbi.c               |   56 +
 drivers/scsi/cxgbi/libcxgbi.h               |    1 +
 drivers/scsi/device_handler/scsi_dh.c       |   61 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  107 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    6 +-
 drivers/scsi/fcoe/fcoe.c                    |  103 +-
 drivers/scsi/fcoe/fcoe.h                    |   11 +-
 drivers/scsi/fcoe/fcoe_transport.c          |  101 ++
 drivers/scsi/hpsa.c                         |    6 +-
 drivers/scsi/ipr.c                          |   31 +-
 drivers/scsi/ipr.h                          |    4 +-
 drivers/scsi/isci/host.c                    |   69 +
 drivers/scsi/isci/host.h                    |   15 +
 drivers/scsi/isci/init.c                    |    3 +
 drivers/scsi/isci/isci.h                    |    2 +-
 drivers/scsi/isci/phy.c                     |   11 +
 drivers/scsi/isci/port.c                    |    2 +-
 drivers/scsi/isci/port_config.c             |    2 +-
 drivers/scsi/isci/registers.h               |  122 +--
 drivers/scsi/isci/remote_device.c           |   24 +
 drivers/scsi/isci/remote_device.h           |    9 +
 drivers/scsi/isci/request.c                 |  380 ++++-
 drivers/scsi/isci/request.h                 |   31 +-
 drivers/scsi/isci/sas.h                     |    2 -
 drivers/scsi/isci/task.c                    |   29 +-
 drivers/scsi/isci/task.h                    |   19 +
 drivers/scsi/iscsi_tcp.c                    |   83 +-
 drivers/scsi/libfc/fc_exch.c                |   11 +-
 drivers/scsi/libfc/fc_fcp.c                 |    2 -
 drivers/scsi/libiscsi.c                     |    9 -
 drivers/scsi/libsas/sas_discover.c          |   13 +-
 drivers/scsi/libsas/sas_expander.c          |   37 +-
 drivers/scsi/libsas/sas_host_smp.c          |  103 ++-
 drivers/scsi/libsas/sas_init.c              |   43 +-
 drivers/scsi/libsas/sas_scsi_host.c         |  145 +-
 drivers/scsi/lpfc/lpfc.h                    |   20 +-
 drivers/scsi/lpfc/lpfc_attr.c               |   79 +-
 drivers/scsi/lpfc/lpfc_crtn.h               |    4 +-
 drivers/scsi/lpfc/lpfc_ct.c                 |    3 +
 drivers/scsi/lpfc/lpfc_debugfs.c            |  181 ++
 drivers/scsi/lpfc/lpfc_els.c                |   33 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |    7 +-
 drivers/scsi/lpfc/lpfc_hw4.h                |  300 +++-
 drivers/scsi/lpfc/lpfc_init.c               |  287 ++--
 drivers/scsi/lpfc/lpfc_logmsg.h             |    1 +
 drivers/scsi/lpfc/lpfc_mbox.c               |   80 +-
 drivers/scsi/lpfc/lpfc_scsi.c               |  244 +++-
 drivers/scsi/lpfc/lpfc_sli.c                |  460 ++++--
 drivers/scsi/lpfc/lpfc_sli.h                |   18 +-
 drivers/scsi/lpfc/lpfc_sli4.h               |   23 +-
 drivers/scsi/lpfc/lpfc_version.h            |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c              |   16 +-
 drivers/scsi/mac_esp.c                      |    9 -
 drivers/scsi/megaraid/megaraid_sas.h        |   22 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  239 ++-
 drivers/scsi/megaraid/megaraid_sas_fp.c     |   26 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  193 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   19 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c         |  447 ++++--
 drivers/scsi/mpt2sas/mpt2sas_base.h         |   46 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |   28 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |    2 +
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |    2 +-
 drivers/scsi/mvsas/mv_94xx.c                |   35 +
 drivers/scsi/mvsas/mv_defs.h                |    2 +
 drivers/scsi/mvsas/mv_init.c                |   13 +-
 drivers/scsi/mvsas/mv_sas.c                 |   79 +-
 drivers/scsi/mvsas/mv_sas.h                 |    4 +-
 drivers/scsi/mvumi.c                        | 2018 +++++++++++++++++++++
 drivers/scsi/mvumi.h                        |  505 ++++++
 drivers/scsi/pm8001/pm8001_hwi.c            |   73 +-
 drivers/scsi/pm8001/pm8001_init.c           |    4 +-
 drivers/scsi/pm8001/pm8001_sas.c            |   93 +-
 drivers/scsi/pm8001/pm8001_sas.h            |    2 -
 drivers/scsi/qla2xxx/qla_attr.c             |  111 +-
 drivers/scsi/qla2xxx/qla_bsg.c              |  152 ++
 drivers/scsi/qla2xxx/qla_bsg.h              |   42 +
 drivers/scsi/qla2xxx/qla_dbg.c              |    6 +-
 drivers/scsi/qla2xxx/qla_def.h              |    9 +-
 drivers/scsi/qla2xxx/qla_gbl.h              |   18 +
 drivers/scsi/qla2xxx/qla_init.c             |   36 +-
 drivers/scsi/qla2xxx/qla_isr.c              |    5 +
 drivers/scsi/qla2xxx/qla_mbx.c              |  127 ++
 drivers/scsi/qla2xxx/qla_nx.c               |  970 ++++++++++-
 drivers/scsi/qla2xxx/qla_nx.h               |  255 +++-
 drivers/scsi/qla2xxx/qla_os.c               |   46 +-
 drivers/scsi/qla4xxx/Kconfig                |    1 +
 drivers/scsi/qla4xxx/Makefile               |    2 +-
 drivers/scsi/qla4xxx/ql4_attr.c             |   76 +
 drivers/scsi/qla4xxx/ql4_bsg.c              |  513 ++++++
 drivers/scsi/qla4xxx/ql4_bsg.h              |   19 +
 drivers/scsi/qla4xxx/ql4_def.h              |  214 ++-
 drivers/scsi/qla4xxx/ql4_fw.h               |  198 ++-
 drivers/scsi/qla4xxx/ql4_glbl.h             |   71 +-
 drivers/scsi/qla4xxx/ql4_init.c             |  852 ++--------
 drivers/scsi/qla4xxx/ql4_iocb.c             |   68 +-
 drivers/scsi/qla4xxx/ql4_isr.c              |   83 +-
 drivers/scsi/qla4xxx/ql4_mbx.c              |  820 ++++++++-
 drivers/scsi/qla4xxx/ql4_nvram.c            |   21 +
 drivers/scsi/qla4xxx/ql4_nx.c               |   17 +
 drivers/scsi/qla4xxx/ql4_os.c               | 2515 ++++++++++++++++++++++-----
 drivers/scsi/qla4xxx/ql4_version.h          |    2 +-
 drivers/scsi/qlogicpti.c                    |    2 +-
 drivers/scsi/scsi_error.c                   |   12 +-
 drivers/scsi/scsi_sysfs.c                   |   38 +
 drivers/scsi/scsi_transport_iscsi.c         |  738 +++++++--
 drivers/scsi/scsi_transport_sas.c           |   10 +-
 drivers/scsi/sd.c                           |    7 +-
 include/linux/genhd.h                       |    4 +
 include/linux/libata.h                      |    2 +
 include/scsi/iscsi_if.h                     |  135 +-
 include/scsi/libfc.h                        |   76 +-
 include/scsi/libfcoe.h                      |    5 +
 include/scsi/libsas.h                       |   54 +-
 include/scsi/sas.h                          |   24 +-
 include/scsi/scsi_bsg_iscsi.h               |  110 ++
 include/scsi/scsi_device.h                  |    6 +
 include/scsi/scsi_host.h                    |   16 +-
 include/scsi/scsi_transport_iscsi.h         |   47 +-
 162 files changed, 14194 insertions(+), 3404 deletions(-)
 create mode 100644 Documentation/scsi/LICENSE.qla4xxx
 create mode 100644 Documentation/scsi/bnx2fc.txt
 create mode 100644 drivers/scsi/mvumi.c
 create mode 100644 drivers/scsi/mvumi.h
 create mode 100644 drivers/scsi/qla4xxx/ql4_bsg.c
 create mode 100644 drivers/scsi/qla4xxx/ql4_bsg.h
 create mode 100644 include/scsi/scsi_bsg_iscsi.h

James
