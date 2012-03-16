From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] qla2xxx: Add target mode LLD and TCM fabric support
Date: Fri, 16 Mar 2012 23:23:19 +0000
Message-ID: <1331940202-22305-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: target-devel <target-devel@vger.kernel.org>, Qlogic Linux Team <linux-driver@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Parallels.com>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hello Qlogic Linux and SCSI/target folks,

This updated patch series for an initial v3.4 mainline merge of qla2xxx
target mode has been cut against jejb's scsi-misc/master branch to include
for-3.4 changes to current qla2xxx LLD code.

It's available now in the latest target-pending/for-next-merge HEAD:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next-merge

Updating to v3.4-rc0 bound scsi-misc qla2xxx patches from RFC-v5 was mostly
straight forward, and also included dropping a few minor bits that have been
merged in upstream qla2xxx LLD code.

As discussed during RFC-v5, patch #1 in this series now includes:

commit 45348067c9a8b911ec6f09829b4c91bd310eb6ef
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Fri Mar 16 15:20:34 2012 -0700

    qla_target: Convert to qlini_mode='enabled' by default

to disable target mode operation so that existing qla2xxx.ko initiator mode
is *always* enabled by default.  As we don't have a resolution yet for interaction
between scsi-core <-> target-core subsystems for 'hot' transition between
different mixed mode operation, the initial merge of this code will require:

    modprobe qla2xxx qlini_mode="disabled"

in order to access and register scsi_qla_host ports for target mode ops via
normal tcm_qla2xxx WWPN group registration.

So at this point, patch #2 is the most imporant to ensure the changes required
for qla_target.c infrstructure in existing LLD code to not cause regressions
for existing SCSI initiator mode operation.  Andrew & Co, it would be great if
you could have a look and let us know if you have any immediate concerns here.

This update also includes changes from this week's round of linux-next feedback.
Thanks again to DanC, Joern, and all those who has been contributing to improve
this code!

--nab

Nicholas Bellinger (3):
  qla2xxx: Add LLD target-mode infrastructure for >= 24xx series
  qla2xxx: Enable >= 24xx target-mode support in SCSI LLD
  tcm_qla2xxx: Add >= 24xx series fabric module for target-core

 drivers/scsi/qla2xxx/Kconfig       |    8 +
 drivers/scsi/qla2xxx/Makefile      |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c    |    5 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |    5 +
 drivers/scsi/qla2xxx/qla_dbg.h     |    5 +
 drivers/scsi/qla2xxx/qla_def.h     |   69 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |    7 +
 drivers/scsi/qla2xxx/qla_gs.c      |    4 +-
 drivers/scsi/qla2xxx/qla_init.c    |   82 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |  102 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   83 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  101 +
 drivers/scsi/qla2xxx/qla_mid.c     |   17 +-
 drivers/scsi/qla2xxx/qla_os.c      |  133 +-
 drivers/scsi/qla2xxx/qla_target.c  | 4724 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.h  |  986 ++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 1981 +++++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  149 ++
 18 files changed, 8429 insertions(+), 35 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_target.c
 create mode 100644 drivers/scsi/qla2xxx/qla_target.h
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.c
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.h

-- 
1.7.2.5
