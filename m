From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.11+ merge window
Date: Sun, 10 Nov 2013 12:41:54 +0800
Message-ID: <1384058514.2212.6.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38785 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758589Ab3KJEl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2013 23:41:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This patch set is driver updates for qla4xxx, scsi_debug, pm80xx,
fcoe/libfc, eas2r, lpfc, be2iscsi and megaraid_sas plus some assorted
bug fixes and cleanups

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is:

Aaron Lu (1):
      sd: call blk_pm_runtime_init before add_disk

Adheer Chandravanshi (7):
      qla4xxx: Add support to get CHAP details for flash target session
      qla4xxx: Add support to set CHAP entries
      scsi_transport_iscsi: Add support to set CHAP entries
      qla4xxx: Use offset based on adapter type to set CHAP entry in flash
      qla4xxx: Populate local CHAP credentials for flash target sessions
      qla4xxx: Support setting of local CHAP index for flash target entry
      qla4xxx: Correct the check for local CHAP entry type

Akinobu Mita (5):
      scsi_debug: fix sparse warnings related to data integrity field
      scsi_debug: fix invalid value check for guard module parameter
      scsi_debug: avoid partial copying PI from prot_sglist to dif_storep
      scsi_debug: factor out copying PI from dif_storep to prot_sglist
      scsi_debug: fix buffer overrun when DIF/DIX is enabled and virtual_gb > 0

Anand Kumar Santhanam (10):
      pm80xx: Firmware logging support.
      pm80xx: Phy settings support for motherboard controller.
      pm80xx: IButton security feature support for motherboard controllers.
      pm80xx: Print SAS address of IO failed device.
      pm80xx: 4G boundary fix.
      pm80xx: Queue rotation logic for inbound and outbound queues.
      pm80xx: Set device state response logic fix.
      pm80xx: Display controller BIOS version.
      pm80xx: Indirect SMP request fix.
      pm80xx: Device id changes to support series 8 controllers.

Bart Van Assche (13):
      fcoe: Reduce fcoe_sysfs_fcf_add() stack usage
      fcoe: Add missing newlines in debug messages
      fcoe: Declare fcoe_ctlr_mode_set() static
      fcp: Do not interpret check condition as underrun
      libfc: Do not invoke the response handler after fc_exch_done()
      libfc: Reduce exchange lock contention in fc_exch_recv_abts()
      libfc: Avoid that sending after an abort triggers a kernel warning
      libfc: Protect ep->esb_stat changes via ex_lock
      libfc: Fix a race in fc_exch_timer_set_locked()
      libfc: Clarify fc_exch_find()
      libfc: Micro-optimize fc_setup_exch_mgr()
      libfc: Debug code fixes
      libfc: Source code comment spelling fixes

Bernd Schubert (1):
      sd: Reduce buffer size for vpd request

Bradley Grove (4):
      esas2r: Cleanup snprinf formatting of firmware version
      esas2r: Remove superfluous mask of pcie_cap_reg
      esas2r: Fixes for big-endian platforms
      esas2r: Directly call kernel functions for atomic bit operations

Chad Dupuis (1):
      qla2xxx: Fix request queue null dereference.

Chris Leech (1):
      iscsi_tcp: consider session state in iscsi_sw_sk_state_check

Eddie Wai (4):
      MAINTAINER: Updated maintainer info for bnx2fc
      bnx2fc: Bump version from 1.0.14 to 2.4.1
      BNX2FC: hung task timeout warning observed when rmmod bnx2x with active FCoE targets
      bnx2fc: Fixed a SCSI CMD cmpl race condition between ABTS and CLEANUP

Felipe Pena (1):
      lpfc: Fix typo on NULL assignment

Hannes Reinecke (8):
      scsi_error: Escalate to LUN reset if abort fails
      Add 'eh_deadline' to limit SCSI EH runtime
      remove check for 'resetting'
      dc395: Move 'last_reset' into internal host structure
      tmscsim: Move 'last_reset' into host structure
      advansys: Remove 'last_reset' references
      dpt_i2o: return SCSI_MLQUEUE_HOST_BUSY when in reset
      dpt_i2o: Remove DPTI_STATE_IOCTL

Hiral Patel (2):
      fnic: Incremented driver version
      fnic: Fnic Statistics Collection

Jack Wang (1):
      export device_busy for sdev

James Bottomley (1):
      Derive the FLUSH_TIMEOUT from the basic I/O timeout

James Smart (8):
      lpfc 8.3.43: Update lpfc version to driver version 8.3.43
      lpfc 8.3.43: Fixed not processing task management IOCB response status
      lpfc 8.3.43: Fixed spinlock hang.
      lpfc 8.3.43: Fixed invalid Total_Data_Placed value received for els and ct command responses
      lpfc 8.3.43: Fixed invalid fcp_rsp length fir FCP_ICMND
      lpfc 8.3.43: Fixed invalid mailbox timeouts
      lpfc 8.3.43: Fixed spinlock inversion problem.
      lpfc 8.3.43: Fix crash after xri limit is reached.

Jayamohan Kallickal (23):
      be2iscsi: Bump driver version
      be2iscsi: Fix SGL posting for unaligned ICD values
      be2iscsi: Fix AER handling in driver
      be2iscsi: Invalidate WRB in Abort/Reset Path
      be2iscsi: Fix Insufficient Buffer Error returned in MBX Completion
      be2iscsi: Fix log level for protocol specific logs
      be2iscsi: Fix MSIx creation for SKH-R adapter
      be2iscsi: Display Port Identifier for each iSCSI function
      be2iscsi: Dispaly CID available for connection offload
      be2iscsi: Fix chute cleanup during drivers unload.
      be2iscsi: Fix connection offload to support Dual Chute.
      be2iscsi: Fix CID allocation/freeing to support Dual chute mode
      be2iscsi: Fix WRB_Q posting to support Dual Chute mode
      be2iscsi: Fix SGL Initilization and posting Pages for Dual Chute
      be2iscsi: Fix Template HDR support for Dual Chute mode
      be2iscsi: Fix changes in ASYNC Path for SKH-R adapter
      be2iscsi: Config parameters update for Dual Chute Support
      be2iscsi: Fix soft lock up issue during UE or if FW taking time to respond
      be2iscsi: Fix locking mechanism in Unsol Path
      be2iscsi: Fix negotiated parameters upload to FW
      be2iscsi: Fix repeated issue of MAC ADDR get IOCTL
      be2iscsi: Fix the MCCQ count leakage
      be2iscsi: Fix Template HDR IOCTL

Joe Perches (1):
      scsi: Convert uses of compare_ether_addr to ether_addr_equal

Jon Mason (1):
      lpfc: remove unnecessary read of PCI_CAP_ID_EXP

Khalid Aziz (2):
      buslogic: Added check for DMA mapping errors
      BusLogic: Fix an oops when intializing multimaster adapter

Manish Rangankar (1):
      qla4xxx: correctly update session discovery_parent_idx.

Mike Miller (1):
      hpsa: remove unused Smart Array ID

Narsimhulu Musini (1):
      fnic: host reset returns nonzero value(errno) on success

Neil Horman (4):
      fcoe: Fix missing mutex_unlock in fcoe_sysfs_fcf_add error path
      fcoe: cleanup return codes from fcoe_rcv
      fcoe: make sure fcoe frames are unshared prior to manipulating them
      fcoe: ensure that skb placed on the fip_recv_list are unshared

Oliver Neukum (1):
      sd: Add error handling during flushing caches

Robert Love (1):
      libfcoe: Make fcoe_sysfs optional / fix fnic NULL exception

Stewart, Sean (3):
      scsi_dh_alua: ALUA handler attach should succeed while TPG is transitioning
      scsi_dh_alua: ALUA check sense should retry device internal reset unit attention
      scsi_dh_rdac: Add new IBM 1813 product id to rdac devlist

Sumit.Saxena@lsi.com (2):
      megaraid_sas: Fix synchronization problem between sysPD IO path and AEN path
      megaraid_sas: fixes for few endianess issues

And the diffstat:

 MAINTAINERS                                |    2 +-
 drivers/scsi/BusLogic.c                    |   52 +-
 drivers/scsi/advansys.c                    |    8 +-
 drivers/scsi/be2iscsi/be.h                 |    2 +-
 drivers/scsi/be2iscsi/be_cmds.c            |  200 ++++-
 drivers/scsi/be2iscsi/be_cmds.h            |   65 +-
 drivers/scsi/be2iscsi/be_iscsi.c           |  175 +++-
 drivers/scsi/be2iscsi/be_main.c            | 1331 ++++++++++++++++++++--------
 drivers/scsi/be2iscsi/be_main.h            |  182 ++--
 drivers/scsi/be2iscsi/be_mgmt.c            |  290 ++++--
 drivers/scsi/be2iscsi/be_mgmt.h            |   13 +-
 drivers/scsi/bnx2fc/bnx2fc.h               |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c          |   65 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c            |    6 +
 drivers/scsi/dc395x.c                      |   24 +-
 drivers/scsi/device_handler/scsi_dh_alua.c |   31 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c |    1 +
 drivers/scsi/dpt_i2o.c                     |   35 +-
 drivers/scsi/dpti.h                        |    1 -
 drivers/scsi/esas2r/esas2r.h               |  132 ++-
 drivers/scsi/esas2r/esas2r_disc.c          |   55 +-
 drivers/scsi/esas2r/esas2r_flash.c         |   34 +-
 drivers/scsi/esas2r/esas2r_init.c          |  156 ++--
 drivers/scsi/esas2r/esas2r_int.c           |   97 +-
 drivers/scsi/esas2r/esas2r_io.c            |   73 +-
 drivers/scsi/esas2r/esas2r_ioctl.c         |   28 +-
 drivers/scsi/esas2r/esas2r_main.c          |   34 +-
 drivers/scsi/esas2r/esas2r_targdb.c        |    2 +-
 drivers/scsi/esas2r/esas2r_vda.c           |   12 +-
 drivers/scsi/fcoe/fcoe.c                   |   25 +-
 drivers/scsi/fcoe/fcoe_ctlr.c              |  148 ++--
 drivers/scsi/fcoe/fcoe_sysfs.c             |   14 +-
 drivers/scsi/fnic/fnic.h                   |   10 +-
 drivers/scsi/fnic/fnic_debugfs.c           |  390 +++++++-
 drivers/scsi/fnic/fnic_fcs.c               |   18 +-
 drivers/scsi/fnic/fnic_isr.c               |   18 +
 drivers/scsi/fnic/fnic_main.c              |   19 +
 drivers/scsi/fnic/fnic_scsi.c              |  253 +++++-
 drivers/scsi/fnic/fnic_stats.h             |  116 +++
 drivers/scsi/fnic/fnic_trace.c             |  185 ++++
 drivers/scsi/fnic/fnic_trace.h             |    3 +-
 drivers/scsi/hosts.c                       |    7 +
 drivers/scsi/hpsa.c                        |    1 -
 drivers/scsi/iscsi_tcp.c                   |    1 +
 drivers/scsi/libfc/fc_exch.c               |  251 ++++--
 drivers/scsi/libfc/fc_fcp.c                |   10 +-
 drivers/scsi/libfc/fc_lport.c              |    4 +-
 drivers/scsi/libfc/fc_rport.c              |    6 +-
 drivers/scsi/lpfc/lpfc_bsg.c               |    7 +-
 drivers/scsi/lpfc/lpfc_ct.c                |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c           |    8 +-
 drivers/scsi/lpfc/lpfc_hw4.h               |   30 +-
 drivers/scsi/lpfc/lpfc_init.c              |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c              |  131 ++-
 drivers/scsi/lpfc/lpfc_scsi.h              |    1 +
 drivers/scsi/lpfc/lpfc_sli.c               |  183 +++-
 drivers/scsi/lpfc/lpfc_sli4.h              |    1 +
 drivers/scsi/lpfc/lpfc_version.h           |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h       |    1 +
 drivers/scsi/megaraid/megaraid_sas_base.c  |   16 +-
 drivers/scsi/pm8001/pm8001_ctl.c           |  153 ++++
 drivers/scsi/pm8001/pm8001_ctl.h           |    6 +
 drivers/scsi/pm8001/pm8001_defs.h          |    8 +-
 drivers/scsi/pm8001/pm8001_hwi.c           |  152 +++-
 drivers/scsi/pm8001/pm8001_hwi.h           |    3 +
 drivers/scsi/pm8001/pm8001_init.c          |   65 +-
 drivers/scsi/pm8001/pm8001_sas.c           |    9 +-
 drivers/scsi/pm8001/pm8001_sas.h           |   74 +-
 drivers/scsi/pm8001/pm80xx_hwi.c           |  523 ++++++++++-
 drivers/scsi/pm8001/pm80xx_hwi.h           |   15 +-
 drivers/scsi/qla2xxx/qla_dbg.c             |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c             |    9 +
 drivers/scsi/qla4xxx/ql4_def.h             |    1 +
 drivers/scsi/qla4xxx/ql4_fw.h              |    4 +
 drivers/scsi/qla4xxx/ql4_glbl.h            |    2 +
 drivers/scsi/qla4xxx/ql4_inline.h          |   12 +
 drivers/scsi/qla4xxx/ql4_mbx.c             |   34 +-
 drivers/scsi/qla4xxx/ql4_os.c              |  471 +++++++++-
 drivers/scsi/scsi.c                        |   28 -
 drivers/scsi/scsi_debug.c                  |  137 +--
 drivers/scsi/scsi_error.c                  |  146 ++-
 drivers/scsi/scsi_pm.c                     |    3 +-
 drivers/scsi/scsi_sysfs.c                  |   39 +
 drivers/scsi/scsi_transport_iscsi.c        |   26 +
 drivers/scsi/sd.c                          |   85 +-
 drivers/scsi/sd.h                          |    6 +-
 drivers/scsi/tmscsim.c                     |   14 +-
 drivers/scsi/tmscsim.h                     |    1 +
 include/scsi/fc/fc_fc2.h                   |    2 +-
 include/scsi/iscsi_if.h                    |   17 +
 include/scsi/libfc.h                       |    9 +
 include/scsi/libfcoe.h                     |    7 +-
 include/scsi/scsi_host.h                   |    5 +-
 include/scsi/scsi_transport_iscsi.h        |    1 +
 94 files changed, 5610 insertions(+), 1430 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_stats.h

James


