From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for the 3.18+ merge window
Date: Sat, 20 Dec 2014 08:41:19 -0800
Message-ID: <1419093679.2184.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44907 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027AbaLTQlV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2014 11:41:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a much shorter set of patches that were on the go but didn't
make it in to the early pull request for the merge window.  It's really
a set of bug fixes plus some final cleanup work on the new tag queue
API.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is:

Boris Bodemann (1):
      esas2r: Correct typos of "validate" in a comment

Brian King (2):
      ipr: set scsi_level correctly for disk arrays
      ipr: add support for async scanning to speed up boot

Christoph Hellwig (7):
      fc: FCP_PTA_SIMPLE is 0
      ibmvfc: remove unused tag variable
      scsi: remove MSG_*_TAG defines
      scsi: remove scsi_set_tag_type
      scsi: remove scsi_get_tag_type
      scsi: never drop to untagged mode during queue ramp down
      scsi: remove ->change_queue_type method

Douglas Gilbert (2):
      scsi_debug: improve driver description in Kconfig
      scsi_debug: fix compare and write errors

Ewan D. Milne (2):
      scsi_debug: fix missing "break;" in SDEBUG_UA_CAPACITY_CHANGED case
      scsi_debug: take sdebug_host_list_lock when changing capacity

Laurence Oberman (1):
      qla2xxx: fix race in handling rport deletion during recovery causes panic

Long Li (1):
      storvsc: ring buffer failures may result in I/O freeze

Martin K. Petersen (1):
      scsi: blacklist RSOC for Microsoft iSCSI target devices

Sreekanth Reddy (2):
      Revert " mpt3sas: Remove phys on topology change"
      Revert " mpt2sas: Remove phys on topology change."

Tony Battersby (1):
      scsi: fix random memory corruption with scsi-mq + T10 PI

And the diffstat:

 drivers/infiniband/ulp/srp/ib_srp.c        |   1 -
 drivers/infiniband/ulp/srpt/ib_srpt.c      |  10 +--
 drivers/scsi/53c700.c                      |  41 +---------
 drivers/scsi/Kconfig                       |  17 ++---
 drivers/scsi/advansys.c                    |   8 +-
 drivers/scsi/aic94xx/aic94xx_init.c        |   1 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c          |   1 -
 drivers/scsi/bnx2fc/bnx2fc_io.c            |   6 +-
 drivers/scsi/csiostor/csio_scsi.c          |   5 +-
 drivers/scsi/esas2r/esas2r_flash.c         |   4 +-
 drivers/scsi/esas2r/esas2r_main.c          |   1 -
 drivers/scsi/fcoe/fcoe.c                   |   1 -
 drivers/scsi/fnic/fnic_main.c              |   1 -
 drivers/scsi/ibmvscsi/ibmvfc.c             |   2 -
 drivers/scsi/ipr.c                         | 116 +++++++++++------------------
 drivers/scsi/ipr.h                         |   4 +-
 drivers/scsi/isci/init.c                   |   1 -
 drivers/scsi/libsas/sas_scsi_host.c        |   8 --
 drivers/scsi/lpfc/lpfc_scsi.c              |   2 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c       |   1 -
 drivers/scsi/mpt2sas/mpt2sas_transport.c   |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c       |   1 -
 drivers/scsi/mpt3sas/mpt3sas_transport.c   |   5 +-
 drivers/scsi/mvsas/mv_init.c               |   1 -
 drivers/scsi/pm8001/pm8001_init.c          |   1 -
 drivers/scsi/pmcraid.c                     |   1 -
 drivers/scsi/qla2xxx/qla_init.c            |   2 -
 drivers/scsi/qla2xxx/qla_os.c              |   1 -
 drivers/scsi/qla2xxx/qla_target.c          |  12 +--
 drivers/scsi/scsi.c                        |  22 ------
 drivers/scsi/scsi_debug.c                  |  62 +++++----------
 drivers/scsi/scsi_devinfo.c                |   1 +
 drivers/scsi/scsi_lib.c                    |   4 +-
 drivers/scsi/scsi_sysfs.c                  |  30 +-------
 drivers/scsi/scsi_transport_spi.c          |   2 +-
 drivers/scsi/storvsc_drv.c                 |   7 +-
 drivers/target/iscsi/iscsi_target.c        |  14 ++--
 drivers/target/loopback/tcm_loop.c         |   5 +-
 drivers/target/sbp/sbp_target.c            |   2 +-
 drivers/target/target_core_pscsi.c         |   2 +-
 drivers/target/target_core_sbc.c           |   2 +-
 drivers/target/target_core_spc.c           |   4 +-
 drivers/target/target_core_transport.c     |  16 ++--
 drivers/target/tcm_fc/tfc_cmd.c            |   8 +-
 drivers/usb/gadget/legacy/tcm_usb_gadget.c |  10 +--
 drivers/xen/xen-scsiback.c                 |   2 +-
 include/scsi/libsas.h                      |   1 -
 include/scsi/scsi_host.h                   |  13 ----
 include/scsi/scsi_tcq.h                    |  36 ---------
 include/target/target_core_base.h          |   6 ++
 include/trace/events/target.h              |   8 +-
 51 files changed, 151 insertions(+), 366 deletions(-)

James


