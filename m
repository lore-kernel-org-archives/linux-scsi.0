From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.0+ merge window
Date: Fri, 15 Mar 2019 17:23:19 -0700
Message-ID: <1552695799.24933.24.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the final round of mostly small fixes and performance
improvements to our initial submit.  The main regression fix is the
ia64 simscsi build failure which was missed in the serial number
elimination conversion.

You will find the topmost patch has been rebased.  Apparently one of
our number can't spell scsi: and, since it is the oneliner of the
patch, I felt it had to be fixed.  There are no code changes from what
was in linux-next.  The original commit is here for you to verify:

https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/log/?h=cockup

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Andy Shevchenko (1):
      scsi: target: tcmu: Switch to bitmap_zalloc()

Arnd Bergmann (4):
      scsi: lpfc: fix 32-bit format string warning
      scsi: lpfc: fix unused variable warning
      scsi: qla2xxx: avoid printf format warning
      scsi: ufs: hisi: fix ufs_hba_variant_ops passing

Bill Kuzeja (1):
      scsi: qla2xxx: Fix panic in qla_dfs_tgt_counters_show

Cathy Avery (1):
      scsi: target: tcmu: wait for nl reply only if there are listeners or during an add

Dan Carpenter (2):
      scsi: lpfc: Fix error codes in lpfc_sli4_pci_mem_setup()
      scsi: qla2xxx: check for kstrtol() failure

Erwan Velu (1):
      scsi: smartpqi: Reporting 'logical unit failure'

Felipe Franciosi (1):
      scsi: virtio_scsi: don't send sc payload with tmfs

Hannes Reinecke (1):
      scsi: ia64: simscsi: use request tag instead of serial_number

James Smart (2):
      scsi: lpfc: resolve static checker warning in lpfc_sli4_hba_unset
      scsi: lpfc: Correct __lpfc_sli_issue_iocb_s4 lockdep check

John Garry (1):
      scsi: hisi_sas: Set PHY linkrate when disconnected

Lee Duncan (1):
      scsi: libiscsi: Hold back_lock when calling iscsi_complete_task

Sagar Biradar (1):
      scsi: aacraid: Fix performance issue on logical drives

Steve Sistare (1):
      scsi: megaraid_sas: reduce module load time

Vasily Averin (1):
      scsi: libiscsi: fall back to sendmsg for slab pages

Xiang Chen (4):
      scsi: hisi_sas: Change SERDES_CFG init value to increase reliability of HiLink
      scsi: hisi_sas: Send HARD RESET to clear the previous affiliation of STP target port
      scsi: hisi_sas: Fix a timeout race of driver internal and SMP IO
      scsi: hisi_sas: Change return variable type in phy_up_v3_hw()

Xiaofei Tan (1):
      scsi: hisi_sas: print PHY RX errors count for later revision of v3 hw

And the diffstat:

 arch/ia64/hp/sim/simscsi.c                |  7 +--
 drivers/scsi/aacraid/linit.c              | 13 +++--
 drivers/scsi/hisi_sas/hisi_sas.h          |  8 +++
 drivers/scsi/hisi_sas/hisi_sas_main.c     | 57 ++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 89 ++++++++++++++++++++++---------
 drivers/scsi/libiscsi.c                   | 22 +++++++-
 drivers/scsi/libiscsi_tcp.c               | 11 ++--
 drivers/scsi/lpfc/lpfc_init.c             | 21 ++++----
 drivers/scsi/lpfc/lpfc_nvme.c             |  3 +-
 drivers/scsi/lpfc/lpfc_sli.c              |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  4 +-
 drivers/scsi/qla2xxx/qla_attr.c           |  2 +
 drivers/scsi/qla2xxx/qla_dfs.c            |  2 +
 drivers/scsi/qla2xxx/qla_iocb.c           |  4 +-
 drivers/scsi/smartpqi/smartpqi_init.c     |  6 +++
 drivers/scsi/ufs/ufs-hisi.c               | 11 ++--
 drivers/scsi/ufs/ufshcd-pltfrm.c          |  2 +-
 drivers/scsi/ufs/ufshcd-pltfrm.h          |  2 +-
 drivers/scsi/ufs/ufshcd.h                 |  2 +-
 drivers/scsi/virtio_scsi.c                |  2 -
 drivers/target/target_core_user.c         | 19 ++++---
 22 files changed, 210 insertions(+), 80 deletions(-)

James
