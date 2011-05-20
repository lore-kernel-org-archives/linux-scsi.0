From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/6] target: .40 bugfixes+changes (round 1)
Date: Thu, 19 May 2011 20:19:08 -0700
Message-ID: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James & Co,

This series is the first round of target core .v40 changes containing
the four original bugfixes for .39 required for tcm_fc(openfcoe) HW
offload and other in-flight HW drivers to function properly.  This
series was originally posted here:

[PATCH-v2 0/4] Bugfixes for .39-rc8
http://marc.info/?l=linux-scsi&m=130514011321906&w=2

As before, the first four patches should be backported to
.39.y and 38.y..

For your convience, this original four part series has been merged
with two other conversion patches requested by Mike and Christoph
to be fixed ahead of the iscsi-target merge.  This includes dropping
the legacy target_core_fabric_ops->pack_lun() call for REPORT_LUNs
in favor of int_to_scsilun(), and converting from libsas.h:TASK_ATTR
usage to proper scsi_tcq.h:MSG_*_TAG for target core.

The latter two patches also include conversion for the two current
scsi-misc upstream fabric modules: tcm_loop and tcm_fc(openfcoe).

This patch has been made against the latest scsi-misc HEAD:

commit 6ad11eaa8a689a27e0c99905bcf800a37cd432a0
Author: Joe Carnuccio <joe.carnuccio@qlogic.com>
Date:   Tue May 10 11:30:16 2011 -0700

    [SCSI] qla2xxx: Refactor call to qla2xxx_read_sfp for thermal temperature.
    

This series is available directly from git here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-40-target

Please review and merge.

Thanks!

--nab

Nicholas Bellinger (6):
  target: Fix multi task->task_sg[] chaining logic bug
  target: Fix interrupt context bug with stats_lock and
    core_tmr_alloc_req
  target: Fix bug with task_sg chained transport_free_dev_tasks release
  target: Fix task->task_execute_queue=1 clear bug + LUN_RESET OOPs
  target: Convert REPORT_LUNs to use int_to_scsilun
  target: Convert TASK_ATTR to scsi_tcq.h definitions

 drivers/target/loopback/tcm_loop.c      |   25 +++---------
 drivers/target/target_core_configfs.c   |    4 --
 drivers/target/target_core_device.c     |   29 +++----------
 drivers/target/target_core_pscsi.c      |    4 +-
 drivers/target/target_core_tmr.c        |    7 ++-
 drivers/target/target_core_transport.c  |   68 ++++++++++++++++++++----------
 drivers/target/tcm_fc/tfc_cmd.c         |   20 +++++++++-
 drivers/target/tcm_fc/tfc_conf.c        |    8 ----
 include/scsi/scsi_tcq.h                 |    1 +
 include/target/target_core_base.h       |    1 +
 include/target/target_core_fabric_ops.h |    1 -
 include/target/target_core_transport.h  |    1 +
 12 files changed, 86 insertions(+), 83 deletions(-)

-- 
1.7.5.1
