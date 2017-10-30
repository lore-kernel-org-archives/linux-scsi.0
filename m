From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 10/19] tcmu: release blocks for partially setup cmds
Date: Sun, 29 Oct 2017 22:44:30 -0500
Message-ID: <1509335079-5276-11-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

If we cannot setup a cmd because we run out of ring space
or global pages release the blocks before sleeping. This
prevents a deadlock where dev0 has waiting_blocks set and
needs N blocks, but dev1 to devX have each allocated N / X blocks
and also hit the global block limit so they went to sleep.

find_free_blocks is not able to take the sleeping dev's
blocks becaause their waiting_blocks is set and even
if it was not the block returned by find_last_bit could equal
dbi_max. The latter will probably never happen because
DATA_BLOCK_BITS is so high but in the next patches
DATA_BLOCK_BITS and TCMU_GLOBAL_MAX_BLOCKS will be settable so
it might be lower and could happen.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5226b82..612ac65 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -806,6 +806,13 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 		int ret;
 		DEFINE_WAIT(__wait);
 
+		/*
+		 * Don't leave commands partially setup because the unmap
+		 * thread might need the blocks to make forward progress.
+		 */
+		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cur);
+		tcmu_cmd_reset_dbi_cur(tcmu_cmd);
+
 		prepare_to_wait(&udev->wait_cmdr, &__wait, TASK_INTERRUPTIBLE);
 
 		pr_debug("sleeping for ring space\n");
-- 
1.8.3.1
