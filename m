From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.9+ merge window
Date: Thu, 22 Dec 2016 12:47:08 -0800
Message-ID: <1482439628.2415.65.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53730 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756289AbcLVUrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 15:47:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is mostly stuff which missed the initial pull.  There's a new
driver: qedi, some ufs, ibmvscsis and ncr5380 updates plus some
assorted driver fixes and also a fix for the bug where if a device goes
into a blocked state between configuration and sysfs device add (which
can be a long time under async probing) it would become permanently
blocked.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is:

Adam Manzanares (1):
      scsi: mpt3sas: Recognize and act on iopriority info

Adam Radford (1):
      scsi: Update 3ware driver email addresses

Amit Kushwaha (1):
      scsi: hpsa: remove memory allocate failure message

Benjamin Block (1):
      scsi: zfcp: fix use-after-"free" in FC ingress path after TMF

Finn Thain (2):
      scsi: g_NCR5380: Autoprobe board IRQ by default
      scsi: g_NCR5380: Fix automatic IRQ on HP C2502 cards

Kevin Barnett (1):
      scsi: aacraid: remove wildcard for series 9 controllers

Manish Rangankar (1):
      scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.

Michael Hernandez (3):
      scsi: qla2xxx: Add Block Multi Queue functionality.
      scsi: qla2xxx: Add multiple queue pair functionality.
      scsi: qla2xxx: Utilize pci_alloc_irq_vectors/pci_free_irq_vectors calls.

Ondrej Zary (2):
      scsi: g_NCR5380: Use probe_irq_*() for IRQ probing
      scsi: g_NCR5380: Check for chip presence before calling NCR5380_init()

Quinn Tran (1):
      scsi: qla2xxx: Fix Target mode handling with Multiqueue changes.

Steffen Maier (2):
      scsi: zfcp: fix rport unblock race with LUN recovery
      scsi: zfcp: do not trace pure benign residual HBA responses at default level

Subhash Jadavani (2):
      scsi: ufs-qcom: fix bug with read/modify write of UFS_CFG1
      scsi: ufs: add quirk to increase host PA_SaveConfigTime

Tyrel Datwyler (3):
      scsi: ibmvscsi: add write memory barrier to CRQ processing
      scsi: ibmvscsi: log bad SRP response opcode in hex format
      scsi: ibmvscsi: add vscsi hosts to global list_head

Varun Prakash (5):
      scsi: libcxgbi: return error if interface is not up
      scsi: cxgb4i: libcxgbi: add missing module_put()
      scsi: cxgb4i: libcxgbi: cxgb4: add T6 iSCSI completion feature
      scsi: cxgb4i: libcxgbi: add active open cmd for T6 adapters
      scsi: cxgb4i: use cxgb4_tp_smt_idx() to get smt_idx

Wei Fang (1):
      scsi: avoid a permanent stop of the scsi device's request queue

Yaniv Gardi (2):
      scsi: ufs-qcom: add probe_defer in case phy driver not probed yet
      scsi: ufs: add support for UFS HCI 2.1

himanshu.madhani@cavium.com (1):
      scsi: qla2xxx: Only allow operational MBX to proceed during RESET.

and the diffstat:

 Documentation/scsi/g_NCR5380.txt            |   46 +-
 MAINTAINERS                                 |    8 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |   13 +
 drivers/s390/scsi/zfcp_dbf.c                |   17 +-
 drivers/s390/scsi/zfcp_dbf.h                |   41 +-
 drivers/s390/scsi/zfcp_erp.c                |   61 +-
 drivers/s390/scsi/zfcp_ext.h                |    4 +-
 drivers/s390/scsi/zfcp_fsf.h                |    3 +-
 drivers/s390/scsi/zfcp_reqlist.h            |   30 +-
 drivers/s390/scsi/zfcp_scsi.c               |   61 +-
 drivers/scsi/3w-9xxx.c                      |    9 +-
 drivers/scsi/3w-9xxx.h                      |    9 +-
 drivers/scsi/3w-sas.c                       |    7 +-
 drivers/scsi/3w-sas.h                       |    7 +-
 drivers/scsi/3w-xxxx.c                      |    7 +-
 drivers/scsi/3w-xxxx.h                      |    5 +-
 drivers/scsi/Kconfig                        |    1 +
 drivers/scsi/Makefile                       |    1 +
 drivers/scsi/NCR5380.c                      |   77 +-
 drivers/scsi/NCR5380.h                      |   11 -
 drivers/scsi/aacraid/linit.c                |    2 -
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c          |  320 +++-
 drivers/scsi/cxgbi/libcxgbi.c               |   40 +-
 drivers/scsi/cxgbi/libcxgbi.h               |    2 +
 drivers/scsi/g_NCR5380.c                    |  153 +-
 drivers/scsi/g_NCR5380.h                    |    2 +
 drivers/scsi/hpsa.c                         |   37 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            |    7 +-
 drivers/scsi/ibmvscsi/ibmvscsi.h            |    1 +
 drivers/scsi/mpt3sas/mpt3sas_base.h         |    6 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |   43 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |   34 +-
 drivers/scsi/qedi/Kconfig                   |   10 +
 drivers/scsi/qedi/Makefile                  |    5 +
 drivers/scsi/qedi/qedi.h                    |  364 ++++
 drivers/scsi/qedi/qedi_dbg.c                |  143 ++
 drivers/scsi/qedi/qedi_dbg.h                |  144 ++
 drivers/scsi/qedi/qedi_debugfs.c            |  244 +++
 drivers/scsi/qedi/qedi_fw.c                 | 2378 +++++++++++++++++++++++++++
 drivers/scsi/qedi/qedi_gbl.h                |   73 +
 drivers/scsi/qedi/qedi_hsi.h                |   52 +
 drivers/scsi/qedi/qedi_iscsi.c              | 1624 ++++++++++++++++++
 drivers/scsi/qedi/qedi_iscsi.h              |  232 +++
 drivers/scsi/qedi/qedi_main.c               | 2127 ++++++++++++++++++++++++
 drivers/scsi/qedi/qedi_sysfs.c              |   52 +
 drivers/scsi/qedi/qedi_version.h            |   14 +
 drivers/scsi/qla2xxx/qla_attr.c             |   36 +-
 drivers/scsi/qla2xxx/qla_dbg.c              |    4 +-
 drivers/scsi/qla2xxx/qla_def.h              |  108 +-
 drivers/scsi/qla2xxx/qla_gbl.h              |   28 +-
 drivers/scsi/qla2xxx/qla_init.c             |  173 +-
 drivers/scsi/qla2xxx/qla_inline.h           |   30 +
 drivers/scsi/qla2xxx/qla_iocb.c             |  407 ++++-
 drivers/scsi/qla2xxx/qla_isr.c              |  223 ++-
 drivers/scsi/qla2xxx/qla_mbx.c              |   85 +-
 drivers/scsi/qla2xxx/qla_mid.c              |  116 +-
 drivers/scsi/qla2xxx/qla_os.c               |  475 ++++--
 drivers/scsi/scsi_sysfs.c                   |    4 -
 drivers/scsi/ufs/ufs-qcom.c                 |   44 +-
 drivers/scsi/ufs/ufs-qcom.h                 |    1 +
 drivers/scsi/ufs/ufs_quirks.h               |   30 +-
 drivers/scsi/ufs/ufshcd.c                   |   55 +-
 drivers/scsi/ufs/ufshcd.h                   |   12 +-
 drivers/scsi/ufs/ufshci.h                   |    7 +
 64 files changed, 9670 insertions(+), 695 deletions(-)
 create mode 100644 drivers/scsi/qedi/Kconfig
 create mode 100644 drivers/scsi/qedi/Makefile
 create mode 100644 drivers/scsi/qedi/qedi.h
 create mode 100644 drivers/scsi/qedi/qedi_dbg.c
 create mode 100644 drivers/scsi/qedi/qedi_dbg.h
 create mode 100644 drivers/scsi/qedi/qedi_debugfs.c
 create mode 100644 drivers/scsi/qedi/qedi_fw.c
 create mode 100644 drivers/scsi/qedi/qedi_gbl.h
 create mode 100644 drivers/scsi/qedi/qedi_hsi.h
 create mode 100644 drivers/scsi/qedi/qedi_iscsi.c
 create mode 100644 drivers/scsi/qedi/qedi_iscsi.h
 create mode 100644 drivers/scsi/qedi/qedi_main.c
 create mode 100644 drivers/scsi/qedi/qedi_sysfs.c
 create mode 100644 drivers/scsi/qedi/qedi_version.h

James


