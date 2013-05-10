From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for the 3.9+ merge window
Date: Fri, 10 May 2013 16:00:00 -0700
Message-ID: <1368226800.2024.32.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55829 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880Ab3EJXAD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 May 2013 19:00:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the final round of SCSI patches for the merge window.  It
consists mostly of driver updates (bnx2fc, ibmfc, fnic, lpfc, be2iscsi,
pm80xx, qla4x and ipr).  There's also the power management updates that
complete the patches in Jens' tree, an iscsi refcounting problem fix
from the last pull, some dif handling in scsi_debug fixes, a few nice
code cleanups and an error handling busy bug fix.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is

Adheer Chandravanshi (2):
      qla4xxx: Assign values using correct datatype
      qla4xxx: Fix smatch warnings

Akinobu Mita (4):
      scsi_debug: fix logical block provisioning support
      scsi_debug: clear correct memory region when LBPRZ is enabled
      scsi_debug: prohibit scsi_debug_unmap_granularity == scsi_debug_unmap_alignment
      scsi_debug: call map_region() and unmap_region() only when needed

Armen Baloyan (1):
      qla2xxx: fix sparse warning "large integer implicitly truncated to unsigned type"

Bhanu Prakash Gollapudi (5):
      bnx2fc: Bumped version to 1.0.14
      bnx2fc: Update copyright dates
      bnx2fc: Fix race condition between IO completion and abort
      bnx2fc: Include chip number in the symbolic name
      bnx2fc: Enable cached tasks to improve performance

Brian King (5):
      ibmvfc: Driver version 1.0.11
      ibmvfc: Suppress ABTS if target gone
      ibmvfc: Send cancel when link is down
      ibmvfc: Support FAST_IO_FAIL in EH handlers
      ibmvfc: Properly set cancel flags when cancelling abort

Chad Dupuis (1):
      qla2xxx: Update firmware link in Kconfig file.

Dan Carpenter (3):
      libosd: remover duplicate __bitwise annotation
      megaraid_sas: release lock on error path
      csiostor: off by one error

Fengguang Wu (1):
      qla2xxx: qla2x00_sp_compl can be static.

Hannes Reinecke (1):
      Handle MLQUEUE busy response in scsi_send_eh_cmnd

Hiral Patel (3):
      fnic: Incremented driver version
      fnic: Kernel panic due to FIP mode misconfiguration
      fnic: FIP VLAN Discovery Feature Support

James Bottomley (3):
      sas: unify the pointlessly separated enums sas_dev_type and sas_device_type
      lpfc: fix up Kconfig dependencies
      sd: fix array cache flushing bug causing performance problems

James Smart (22):
      lpfc 8.3.39: Update lpfc version for 8.3.39 driver release
      lpfc 8.3.39: Fixed driver handling of CLEAR_LA with NPIV enabled causing SID=0 frames out
      lpfc 8.3.39: Reduced tmo value set to FLOGI WQE for quick recovery from FLOGI sequence timeout
      lpfc 8.3.39: Add log message when completes with clean address bit set to zero
      lpfc 8.3.39: Fixed driver vector mapping to CPU affinity
      lpfc 8.3.39: Fixed iocb flags not being reset for scsi commands
      lpfc 8.3.39: Fixed system panic during EEH recovery due to midlayer acting on outstanding I/O
      lpfc 8.3.39: Fixed not returning FAILED status when SCSI invoking host reset handler failed
      lpfc 8.3.39: Fixed bad book keeping in posting els sgls to port
      lpfc 8.3.39: Fixed deadlock between hbalock and nlp_lock use
      lpfc 8.3.39: Fixed BlockGuard to take advantage of rdprotect/wrprotect info when available
      lpfc 8.3.39: Reduced spinlock contention on SCSI buffer list
      lpfc 8.3.39: Fixed crash when processing bsg's sg list with high memory pages
      lpfc 8.3.39: Remove lpfc_fcp_look_ahead module parameter
      lpfc 8.3.39: Fix driver issues with SCSI Host reset
      lpfc 8.3.39: Doorbell formation information logged in dual-chute mode WQ and RQ setup
      lpfc 8.3.39: Fix driver issues with large s/g lists for BlockGuard
      lpfc 8.3.39: Fix driver issues with large lpfc_sg_seg_cnt values
      lpfc 8.3.39: Fixed pt2pt and loop discovery problems on topology changes.
      lpfc 8.3.39: Remove driver dependency on HZ
      lpfc 8.3.39: Fixed BlockGuard error reporting
      lpfc 8.3.39: Fixed VPI allocation issues after firmware dump is performed

Jayamohan Kallickal (16):
      be2iscsi: Bump the driver version to 10.0.467.0
      be2iscsi: Fix issue in passing the exp_cmdsn and max_cmdsn
      be2scsi: Update copyright dates to 2013
      be2iscsi: Fix checking Adapter state while establishing CXN
      be2iscsi: Fix dynamic CID allocation Mechanism in driver
      be2iscsi : Fix the NOP-In handling code path
      be2iscsi: Fix the Port Link Status issue
      be2iscsi: Fix displaying the Active Session Count from driver
      be2iscsi: Fix displaying the FW Version from driver.
      be2iscsi: Fix support for DEFQ extension
      be2iscsi: Fix MACRO for checking the adapter type
      be2iscsi: Fix freeing CXN specific driver resources.
      be2iscsi: Fix MSIX support in SKH-R to 32
      be2iscsi: Fix MBX Command issues
      be2iscsi: Fix returning Failure when MBX fails with Insufficient buffer error
      be2iscsi: Fix lack of uninitialize pattern to FW

Jeremy Higdon (1):
      sd_dif: problem with verify of type 1 protection information (PI)

Lin Ming (2):
      sd: change to auto suspend mode
      sd: use REQ_PM in sd's runtime suspend operation

Mike Christie (1):
      iscsi class, qla4xxx: fix sess/conn refcounting when find fns are used

Sakthivel K (11):
      pm80xx: thermal, sas controller config and error handling update
      pm80xx: NCQ error handling changes
      pm80xx: WWN Modification for PM8081/88/89 controllers
      pm80xx: Changed module name and debug messages update
      pm80xx: Firmware flash memory free fix, with addition of new memory region for it
      pm80xx: SPC new firmware changes for device id 0x8081 alone
      pm80xx: Added SPCv/ve specific hardware functionalities and relevant changes in common files
      pm80xx: MSI-X implementation for using 64 interrupts
      pm80xx: Updated common functions common for SPC and SPCv/ve
      pm80xx: Multiple inbound/outbound queue configuration
      pm80xx: Added SPCv/ve specific ids, variables and modify for SPC

Shlomo Pongratz (1):
      be2iscsi: Fix possible reentrancy issue in be_iopoll

Vikas Chaudhary (4):
      qla4xxx: Fix iocb_cnt calculation in qla4xxx_send_mbox_iocb()
      qla4xxx: Update driver version to 5.03.00-k9
      qla4xxx: Fix sparse warning for qla4xxx_sysfs_ddb_tgt_create
      qla4xxx: Silence gcc warning

Vinayak Holikatti (2):
      ufs: Correct the expected data transfersize
      ufs: Add Platform glue driver for ufshcd

Wei Yongjun (1):
      scsi_transport_iscsi: fix error return code in iscsi_transport_init()

wenxiong@linux.vnet.ibm.com (2):
      ipr: SATA DVD probing failed with 64bit adapter
      ipr: Need to reset adapter after the 6th EEH error

And the diffstat

 drivers/scsi/Kconfig                      |    2 +
 drivers/scsi/aic94xx/aic94xx_dev.c        |   24 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c        |    2 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c        |    2 +-
 drivers/scsi/be2iscsi/be.h                |    2 +-
 drivers/scsi/be2iscsi/be_cmds.c           |  172 +-
 drivers/scsi/be2iscsi/be_cmds.h           |   27 +-
 drivers/scsi/be2iscsi/be_iscsi.c          |   70 +-
 drivers/scsi/be2iscsi/be_iscsi.h          |    2 +-
 drivers/scsi/be2iscsi/be_main.c           |  375 ++-
 drivers/scsi/be2iscsi/be_main.h           |   29 +-
 drivers/scsi/be2iscsi/be_mgmt.c           |   43 +-
 drivers/scsi/be2iscsi/be_mgmt.h           |   35 +-
 drivers/scsi/bnx2fc/bnx2fc.h              |    8 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c          |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |   55 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c          |    8 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c           |    9 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c          |    2 +-
 drivers/scsi/csiostor/csio_lnode.h        |    2 +-
 drivers/scsi/csiostor/csio_rnode.h        |    2 +-
 drivers/scsi/fnic/fnic.h                  |   34 +-
 drivers/scsi/fnic/fnic_fcs.c              |  564 +++-
 drivers/scsi/fnic/fnic_fip.h              |   68 +
 drivers/scsi/fnic/fnic_main.c             |   51 +-
 drivers/scsi/fnic/vnic_dev.c              |   10 +
 drivers/scsi/fnic/vnic_dev.h              |    2 +
 drivers/scsi/fnic/vnic_devcmd.h           |   67 +
 drivers/scsi/ibmvscsi/ibmvfc.c            |   85 +-
 drivers/scsi/ibmvscsi/ibmvfc.h            |    7 +-
 drivers/scsi/ipr.c                        |   16 +-
 drivers/scsi/ipr.h                        |    2 +-
 drivers/scsi/isci/remote_device.c         |    4 +-
 drivers/scsi/isci/remote_device.h         |    2 +-
 drivers/scsi/isci/request.c               |    6 +-
 drivers/scsi/isci/task.c                  |    2 +-
 drivers/scsi/libsas/sas_ata.c             |   18 +-
 drivers/scsi/libsas/sas_discover.c        |   34 +-
 drivers/scsi/libsas/sas_expander.c        |  110 +-
 drivers/scsi/libsas/sas_internal.h        |   10 +-
 drivers/scsi/libsas/sas_port.c            |    2 +-
 drivers/scsi/lpfc/lpfc.h                  |   24 +-
 drivers/scsi/lpfc/lpfc_attr.c             |  166 +-
 drivers/scsi/lpfc/lpfc_bsg.c              |   39 +-
 drivers/scsi/lpfc/lpfc_crtn.h             |    1 +
 drivers/scsi/lpfc/lpfc_ct.c               |    3 +-
 drivers/scsi/lpfc/lpfc_els.c              |  113 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c          |   91 +-
 drivers/scsi/lpfc/lpfc_hw.h               |    1 +
 drivers/scsi/lpfc/lpfc_hw4.h              |    7 +-
 drivers/scsi/lpfc/lpfc_init.c             |  607 ++++-
 drivers/scsi/lpfc/lpfc_logmsg.h           |    1 +
 drivers/scsi/lpfc/lpfc_mbox.c             |    9 +-
 drivers/scsi/lpfc/lpfc_mem.c              |   14 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c        |   25 +-
 drivers/scsi/lpfc/lpfc_scsi.c             |  798 ++++--
 drivers/scsi/lpfc/lpfc_sli.c              |  106 +-
 drivers/scsi/lpfc/lpfc_sli4.h             |   21 +-
 drivers/scsi/lpfc/lpfc_version.h          |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c            |   25 +-
 drivers/scsi/lpfc/lpfc_vport.h            |    1 +
 drivers/scsi/megaraid/megaraid_sas_base.c |    3 +-
 drivers/scsi/mvsas/mv_init.c              |    2 +-
 drivers/scsi/mvsas/mv_sas.c               |   16 +-
 drivers/scsi/mvsas/mv_sas.h               |    4 +-
 drivers/scsi/pm8001/Makefile              |    7 +-
 drivers/scsi/pm8001/pm8001_ctl.c          |   74 +-
 drivers/scsi/pm8001/pm8001_defs.h         |   34 +-
 drivers/scsi/pm8001/pm8001_hwi.c          |  817 ++++--
 drivers/scsi/pm8001/pm8001_hwi.h          |    4 +-
 drivers/scsi/pm8001/pm8001_init.c         |  383 ++-
 drivers/scsi/pm8001/pm8001_sas.c          |  119 +-
 drivers/scsi/pm8001/pm8001_sas.h          |  181 +-
 drivers/scsi/pm8001/pm80xx_hwi.c          | 4130 +++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h          | 1523 +++++++++++
 drivers/scsi/qla2xxx/Kconfig              |    4 +-
 drivers/scsi/qla2xxx/qla_mr.c             |    6 +-
 drivers/scsi/qla2xxx/qla_os.c             |    2 +-
 drivers/scsi/qla4xxx/ql4_iocb.c           |    1 +
 drivers/scsi/qla4xxx/ql4_os.c             |   45 +-
 drivers/scsi/qla4xxx/ql4_version.h        |    2 +-
 drivers/scsi/scsi_debug.c                 |   97 +-
 drivers/scsi/scsi_error.c                 |   37 +-
 drivers/scsi/scsi_lib.c                   |    9 +-
 drivers/scsi/scsi_pm.c                    |   84 +-
 drivers/scsi/scsi_transport_iscsi.c       |   94 +-
 drivers/scsi/sd.c                         |   42 +-
 drivers/scsi/sd.h                         |    1 +
 drivers/scsi/sd_dif.c                     |    8 -
 drivers/scsi/ufs/Kconfig                  |   11 +
 drivers/scsi/ufs/Makefile                 |    1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c          |  217 ++
 drivers/scsi/ufs/ufshcd.c                 |    2 +-
 include/linux/pci_ids.h                   |    6 +-
 include/scsi/libsas.h                     |    4 +-
 include/scsi/osd_protocol.h               |    2 +-
 include/scsi/sas.h                        |   22 +-
 include/scsi/sas_ata.h                    |    4 +-
 include/scsi/scsi_device.h                |   16 +-
 include/scsi/scsi_transport_iscsi.h       |    8 +-
 include/scsi/scsi_transport_sas.h         |    7 -
 101 files changed, 10569 insertions(+), 1481 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_fip.h
 create mode 100644 drivers/scsi/pm8001/pm80xx_hwi.c
 create mode 100644 drivers/scsi/pm8001/pm80xx_hwi.h
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c

James


