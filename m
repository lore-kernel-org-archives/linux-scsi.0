From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] target: Bug-fixes for v4.11-rc
Date: Thu, 30 Mar 2017 08:29:52 +0000
Message-ID: <1490862594-2712-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Rob Millner <rlm@daterainc.com>, Chu Yuan Lin <cyl@datera.io>, James Shen <jcs@datera.io>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

Here are two additional target bug-fixes that have been found
by the DATERA Q/A + automation team during extended longevity
and stress testing atop v4.1.y stable code.

The first is a iscsi-target specific TMR reference leak during
session shutdown when se_cmd quiesce occured before hand-off
back to iscsi-target, that results in se_tmr_req descriptors
being left after se_cmd was freed.

This would manifest as kernel paging OOPsen during LUN_RESET
after the leak occured, because the associated se_tmr_req had
not been released even though the pre-allocated parent se_cmd
descriptor had already been freed during session shutdown.

The second is a race between se_lun configfs unlink shutdown
when se_lun->lun_ref percpu_ref RCU grace period is happening,
and user-space attempts to add a new NodeACL mappedlun configfs
symlink while se_lun shutdown is occuring.

This would manifest as NULL pointer dereference OOPsen within
target_stat_scsi_att_intr_port_show_attr_dev() after a new
NodeACL mappedlun was added to a se_lun that had already
been shutdown.

Both have been verified on v4.1.y stable code, and forward
ported to v4.11-rc.

Please review.

--nab

Nicholas Bellinger (2):
  iscsi-target: Fix TMR reference leak during session shutdown
  target: Avoid mappedlun symlink creation during lun shutdown

 drivers/target/iscsi/iscsi_target_util.c     | 12 +++++++-----
 drivers/target/target_core_fabric_configfs.c |  5 +++++
 drivers/target/target_core_tpg.c             |  4 ++++
 include/target/target_core_base.h            |  1 +
 4 files changed, 17 insertions(+), 5 deletions(-)

-- 
1.9.1
