From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.1+ merge window
Date: Fri, 17 May 2019 07:44:45 -0700
Message-ID: <1558104285.3050.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the final round of mostly small fixes in our initial
submit.  The fix for the read only regressions is the most extensive
change and also intrudes outside of SCSI because the partition and read
only handling is mostly in block.  The specific problem is the
inability to distinguish between devices marked read only by the
administrator and devices that come up read only but switch to
read/write once they are ready to receive data.  Without the fix these
devices are currently forced to stay read only causing regressions in
the enterprise.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Colin Ian King (1):
      scsi: bnx2fc: fix incorrect cast to u64 on shift operation

Erwan Velu (1):
      scsi: smartpqi: Reporting unhandled SCSI errors

James Smart (4):
      scsi: lpfc: Update lpfc version to 12.2.0.2
      scsi: lpfc: add check for loss of ndlp when sending RRQ
      scsi: lpfc: correct rcu unlock issue in lpfc_nvme_info_show
      scsi: lpfc: resolve lockdep warnings

Martin K. Petersen (1):
      scsi: sd: block: Fix regressions in read-only block device handling

Quinn Tran (1):
      scsi: qla2xxx: Add cleanup for PCI EEH recovery

YueHaibing (3):
      scsi: myrs: Fix uninitialized variable
      scsi: qedi: remove set but not used variables 'cdev' and 'udev'
      scsi: qedi: remove memset/memcpy to nfunc and use func instead

And the diffstat:

 block/blk-core.c                      |   2 +-
 block/genhd.c                         |  34 ++++--
 block/ioctl.c                         |   4 +
 block/partition-generic.c             |   7 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c      |   2 +-
 drivers/scsi/lpfc/lpfc_attr.c         |  37 +++---
 drivers/scsi/lpfc/lpfc_els.c          |   5 +-
 drivers/scsi/lpfc/lpfc_sli.c          |  84 ++++++++-----
 drivers/scsi/lpfc/lpfc_version.h      |   2 +-
 drivers/scsi/myrs.c                   |   2 +-
 drivers/scsi/qedi/qedi_dbg.c          |  32 ++---
 drivers/scsi/qedi/qedi_iscsi.c        |   4 -
 drivers/scsi/qla2xxx/qla_os.c         | 221 +++++++++++++---------------------
 drivers/scsi/sd.c                     |   4 +-
 drivers/scsi/smartpqi/smartpqi_init.c |  23 ++--
 include/linux/genhd.h                 |  11 +-
 16 files changed, 230 insertions(+), 244 deletions(-)

James
