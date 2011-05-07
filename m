From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Bugfixes for .39-rc7
Date: Fri,  6 May 2011 19:54:55 -0700
Message-ID: <1304736898-10830-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>, "Robert W. Love" <robert.w.love@intel.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

My apologies for lateness with this bugfix series.  This series contains
three patches that should be considered critical target core bugfixes for
.39 that have been under stress testing in a couple of different labs
recently using lio-core-2.6.git/lio-4.1 (.39-rcX) and /lio-4.0 (.38.3)
branch code.

These are all important bugfixes that are required to run with in-flight
.40 HW target drivers in the upstream LIO tree.  This includes fixes for
the main transport_do_task_sg_chain() Data I/O mapping logic, and
task->task_sg[] shutdown path from MSI-X interrupt context.  These patches
apply for all of the following fabric drivers:

   tcm_fc(openfcoe) w/ ddp offload, tcm_qla2xxx, ib_srpt and ibmvscsis.

These patches address issues that are able to easily produce OOPsen with
small backstore max_sectors values, so please review+consider for .39 and
also queue into stable@kernel.org for .38.

The series is also available here for a direct pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-rc-fixes

and has been made against the following scsi-rc-fixes HEAD:

commit c055f5b2614b4f758ae6cc86733f31fa4c2c5844
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Sun May 1 09:42:07 2011 -0500

    [SCSI] fix oops in scsi_run_queue()

Thanks!

--nab

Nicholas Bellinger (3):
  target: Fix multi task->task_sg[] chaining logic bug
  target: Fix interrupt context bug with stats_lock and
    core_tmr_alloc_req
  target: Fix bug with task_sg chained transport_free_dev_tasks release

 drivers/target/target_core_device.c    |    4 +-
 drivers/target/target_core_tmr.c       |    7 +++--
 drivers/target/target_core_transport.c |   39 ++++++++++++++++++++++---------
 include/target/target_core_base.h      |    1 +
 include/target/target_core_transport.h |    1 +
 5 files changed, 35 insertions(+), 17 deletions(-)

-- 
1.7.5.1
