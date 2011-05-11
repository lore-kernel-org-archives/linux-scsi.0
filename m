From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 0/4] Bugfixes for .39-rc8
Date: Tue, 10 May 2011 21:35:31 -0700
Message-ID: <1305088535-27486-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm18-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.23]:34643
	"HELO nm18-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751179Ab1EKSzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2011 14:55:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

This series is resend of four patches that should be considered critical
target core bugfixes for .39 that have been under stress testing in a
couple of different labs recently using lio-core-2.6.git/lio-4.1 (.39-rcX)
and /lio-4.0 (.38.3) branch code.

These are all important bugfixes that are required to run with in-flight
.40 HW target drivers in the upstream LIO tree.  This includes fixes for
the main transport_do_task_sg_chain() Data I/O mapping logic, and
task->task_sg[] shutdown path from MSI-X interrupt context.  These bugfixes
apply for all of the following HW fabric drivers:

   tcm_fc(openfcoe) w/ ddp offload, tcm_qla2xxx, ib_srpt and ibmvscsis.

These patches address issues that are able to easily produce OOPsen with
small backstore max_sectors values.  Please review+apply for .39 and
also queue into stable@kernel.org for .38.

The series is also available here for a direct pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-rc-fixes

and has been made against the following scsi-rc-fixes-2.6.git HEAD:

commit c055f5b2614b4f758ae6cc86733f31fa4c2c5844
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Sun May 1 09:42:07 2011 -0500

    [SCSI] fix oops in scsi_run_queue()

Thanks!

--nab

Nicholas Bellinger (4):
  target: Fix multi task->task_sg[] chaining logic bug
  target: Fix interrupt context bug with stats_lock and
    core_tmr_alloc_req
  target: Fix bug with task_sg chained transport_free_dev_tasks release
  target: Fix task->task_execute_queue=1 clear bug + LUN_RESET OOPs

 drivers/target/target_core_device.c    |    4 +-
 drivers/target/target_core_tmr.c       |    7 +++--
 drivers/target/target_core_transport.c |   46 +++++++++++++++++++++++--------
 include/target/target_core_base.h      |    1 +
 include/target/target_core_transport.h |    1 +
 5 files changed, 42 insertions(+), 17 deletions(-)

-- 
1.7.5.1

