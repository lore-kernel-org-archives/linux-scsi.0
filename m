From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] final scsi updates for the 2.6.36 merge window
 [possibly]
Date: Sat, 14 Aug 2010 15:28:01 -0400
Message-ID: <1281814081.21641.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

So I have a few more fixes queued than this, but owing to server failure
while I was away, I didn't get the rest into linux-next in time ... so
unless the merge window elongates, that's it, I think.

Patches are available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Alan Stern (1):
      remove fake "address-of" expression

Brian King (3):
      ibmvfc: Driver version 1.0.9
      ibmvfc: Fix terminate_rport_io
      ibmvfc: Fix rport add/delete race resulting in oops

FUJITA Tomonori (1):
      53c700: remove dma_is_consistent usage

Hannes Reinecke (1):
      Return NEEDS_RETRY for eh commands with status BUSY

James Bottomley (1):
      make error handling more robust in the face of reservations

James Smart (3):
      lpfc 8.3.16: Change LPFC driver version to 8.3.16
      lpfc 8.3.16: FCoE Discovery and Failover Fixes
      lpfc 8.3.16: SLI Additions, updates, and code cleanup

Jayamohan Kallickal (3):
      be2iscsi: Driver Version change to 2.0.549.0
      be2iscsi: Increase max sector
      be2iscsi: Add support for iscsi boot

Joe Eykholt (1):
      tgt: fix warning

Julia Lawall (2):
      drivers/message/fusion: Adjust confusing if indentation
      pm8001: introduce missing kfree

Lalit Chandivade (2):
      qla4xxx: Added AER support for ISP82xx
      qla4xxx: Stop firmware before doing init firmware.

Mike Christie (2):
      libfc: call fc_remote_port_chkready under the host lock.
      iscsi boot: mv iscsi_boot_sysfs to drivers/scsi

Nilesh Javali (1):
      qla4xxx: Handle outstanding mbx cmds on hung f/w scenarios

Randy Dunlap (1):
      be2iscsi: select ISCSI_BOOT_SYSFS

Vikas Chaudhary (6):
      qla4xxx: fix compilation warning
      qla4xxx: Update driver version to 5.02.00-k3
      qla4xxx: updated mbx_sys_info struct to sync with FW 4.6.x
      qla4xxx: clear AF_DPC_SCHEDULED flage when exit from do_dpc
      qla4xxx: Use the correct request queue.
      qla4xxx: set correct value in sess->recovery_tmo

And the diffstat:

 drivers/firmware/Kconfig            |    8 
 drivers/firmware/Makefile           |    1 
 drivers/firmware/iscsi_boot_sysfs.c |  481 ------------------------------------
 drivers/message/fusion/mptbase.c    |    2 
 drivers/scsi/53c700.c               |    3 
 drivers/scsi/Kconfig                |    8 
 drivers/scsi/Makefile               |    1 
 drivers/scsi/be2iscsi/Kconfig       |    1 
 drivers/scsi/be2iscsi/be_cmds.h     |  147 +++++++++--
 drivers/scsi/be2iscsi/be_iscsi.c    |   76 +++--
 drivers/scsi/be2iscsi/be_iscsi.h    |    2 
 drivers/scsi/be2iscsi/be_main.c     |  311 +++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_main.h     |    7 
 drivers/scsi/be2iscsi/be_mgmt.c     |   71 +++++
 drivers/scsi/ibmvscsi/ibmvfc.c      |  380 +++++++++++++++-------------
 drivers/scsi/ibmvscsi/ibmvfc.h      |    6 
 drivers/scsi/iscsi_boot_sysfs.c     |  481 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_fcp.c         |    4 
 drivers/scsi/lpfc/lpfc.h            |    3 
 drivers/scsi/lpfc/lpfc_attr.c       |   46 +++
 drivers/scsi/lpfc/lpfc_bsg.c        |    9 
 drivers/scsi/lpfc/lpfc_compat.h     |    3 
 drivers/scsi/lpfc/lpfc_els.c        |   76 +++++
 drivers/scsi/lpfc/lpfc_hbadisc.c    |   17 -
 drivers/scsi/lpfc/lpfc_hw.h         |   32 +-
 drivers/scsi/lpfc/lpfc_init.c       |  132 ++++++---
 drivers/scsi/lpfc/lpfc_mbox.c       |    8 
 drivers/scsi/lpfc/lpfc_scsi.c       |    8 
 drivers/scsi/lpfc/lpfc_sli.c        |   36 +-
 drivers/scsi/lpfc/lpfc_version.h    |    2 
 drivers/scsi/pm8001/pm8001_hwi.c    |   13 
 drivers/scsi/qla4xxx/ql4_def.h      |   36 ++
 drivers/scsi/qla4xxx/ql4_fw.h       |   20 -
 drivers/scsi/qla4xxx/ql4_glbl.h     |    2 
 drivers/scsi/qla4xxx/ql4_init.c     |   14 -
 drivers/scsi/qla4xxx/ql4_iocb.c     |    2 
 drivers/scsi/qla4xxx/ql4_isr.c      |    3 
 drivers/scsi/qla4xxx/ql4_mbx.c      |   48 +++
 drivers/scsi/qla4xxx/ql4_nx.c       |   17 -
 drivers/scsi/qla4xxx/ql4_os.c       |  315 +++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_version.h  |    2 
 drivers/scsi/scsi_error.c           |   11 
 drivers/scsi/scsi_priv.h            |    2 
 drivers/scsi/scsi_sysfs.c           |    2 
 drivers/scsi/scsi_tgt_lib.c         |    1 
 45 files changed, 1999 insertions(+), 851 deletions(-)

James
