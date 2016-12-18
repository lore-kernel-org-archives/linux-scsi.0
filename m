From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/9] qla2xxx: Cleanup for target code.
Date: Sun, 18 Dec 2016 01:02:40 -0800
Message-ID: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0083.outbound.protection.outlook.com ([104.47.41.83]:18059
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751532AbcLRJDZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Dec 2016 04:03:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Hi Christoph, Bart,

I am submitting this reworked series of patches which were consolidated
and modified in a single patch in previous submission. 

Here's link to the patch submitted on Dec 6, 2016.

http://www.spinics.net/lists/target-devel/msg13657.html

The existing code access TCM/LIO structures (i.e.. se_cmd and its members)
across both tcm_qla2xxx as well as in qla2xxx modules. Based on several
customer request as well as internal review, we reorganized the code to move
TCM/LIO specific code to tcm_qla2xxx module. This improved code readability,
manage code better, as well as support multiple target stacks. Earlier submission
provided a wrong impression of adding dead code. We understand your concerns and
so we are resubmitting the patches as multiple patchset as requested. As part
of this effort we have cleaned up some unused code. I've put down more details
related to each patch to help the review.

Patch #1 moves the command search out of qla2xxx driver and moves it to
tcm_qla2xxx, which should be the one who has knowlege of this.

Patch #2 moves task management code close to tcm_qla2xxx.

Patch #3 moves command allocation and free to a callback which can reside 
in tcm_qla2xxx layer.

Patch #4 uses the check for sess pointer being NULL before getting kref. This
consolidation is helpful to prevent system crash. 

Patch #5 moves the check for command residual count from qla2xx to tcm_qla2xxx. 
Also, we converted check into a void function to simplify usage of code instead
of copying same block of code in multiple place.

Patch #6 checks for scsi_status field which in small 

Patch #7 tries to clean up usage of LBA/CDB and moves it to tcm_qla2xxx.

Patch #8 tries to cleanup T10-DIF and moves the error checking logic to tcm_qla2xxx. 

Patch #9 is where we are cleaning up old un-used code related to SRR. This patch also
attempts to cleanly isolate se_cmd access to tcm_qla2xxx layer. 

Overall, as part of this cleanup/re-organization effort we cleanedup more than 490+ 
unused lines of code. Hope this provides better picture.

Please consider them for target-pending. I will be sending rest of the patches
in smaller series for better review.

Thanks,
Himanshu

Quinn Tran (9):
  qla2xxx: Move cmd search out of qla during ABTS
  qla2xxx: Cleanup TMF code translation from qla_target.
  qla2xxx: Move percpu_ida_{alloc|free} to tcm_qla2xxx.
  qla2xxx: Cleanup for sess_kref handling
  qla2xxx: Move Command residual check from qla2xxx to tcm_qla2xxx
  qla2xxx: Remove direct access of scsi_status field in se_cmd
  qla2xxx: Remove direct access to t_task_cdb/t_task_lba field
  qla2xxx: Add T10-DIF opcode/type in qla_tgt_cmd
  qla2xxx: Remove se_cmd struct out of qla_tgt_cmd/qla_tgt_mgmt_cmd

 drivers/scsi/qla2xxx/qla_def.h     |    1 +
 drivers/scsi/qla2xxx/qla_target.c  | 1039 +++++-------------------------------
 drivers/scsi/qla2xxx/qla_target.h  |   36 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  299 +++++++++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |   10 +
 5 files changed, 402 insertions(+), 983 deletions(-)

-- 
1.8.3.1

