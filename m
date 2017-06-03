From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Add TARGET_SCF_LOOKUP_LUN_FROM_TAG support
Date: Sat,  3 Jun 2017 22:10:05 +0000
Message-ID: <1496527808-28789-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Himanshu + Quinn,

Here is a small series to introduce proper percpu se_lun->lun_ref
counting for TMR, and add common code in target_submit_tmr() to
do tag lookup for unpacked_lun in order to drop the original
driver specific lookup within __qlt_24xx_handle_abts().

It's rather straight-forward, so review and test as a v4.13 item.

Thanks!

Nicholas Bellinger (3):
  target: Add support for TMR percpu reference counting
  target: Add TARGET_SCF_LOOKUP_LUN_FROM_TAG support for ABORT_TASK
  qla2xxx: Convert QLA_TGT_ABTS to TARGET_SCF_LOOKUP_LUN_FROM_TAG

 drivers/scsi/qla2xxx/qla_target.c      | 39 ++++++-----------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  4 ++-
 drivers/target/target_core_device.c    | 14 ++++++---
 drivers/target/target_core_transport.c | 56 ++++++++++++++++++++++++++++------
 include/target/target_core_base.h      |  3 +-
 5 files changed, 71 insertions(+), 45 deletions(-)

-- 
1.9.1
