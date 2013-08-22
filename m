From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 12/12] target: Release COMPARE_AND_WRITE mutex in generic failure path
Date: Thu, 22 Aug 2013 04:54:10 +0000
Message-ID: <1377147250-10125-13-git-send-email-nab@daterainc.com>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch adds a extra check for SCF_COMPARE_AND_WRITE within
transport_generic_request_failure() to invoke the callback for
compare_and_write_callback() or compare_and_write_done(), in
order to release se_dev->caw_mutex from the generic failure
path.

It also adds to checks within compare_and_write_callback() to
avoid processing when transport_generic_request_failure() occurs
early enough that cmd->t_data_sg or cmd->t_bidi_data_sg have not
been setup yet, nor se_dev->caw_mutex obtained from within
sbc_compare_and_write().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c       |    7 +++++++
 drivers/target/target_core_transport.c |    6 ++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index bb1b42b..287e960 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -372,6 +372,13 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd)
 	sense_reason_t ret = TCM_NO_SENSE;
 	int rc, i;
 
+	/*
+	 * Handle early failure in transport_generic_request_failure(),
+	 * which will not have taken ->caw_mutex yet..
+	 */
+	if (!cmd->t_data_sg || !cmd->t_bidi_data_sg)
+		return TCM_NO_SENSE;
+
 	buf = kzalloc(cmd->data_length, GFP_KERNEL);
 	if (!buf) {
 		pr_err("Unable to allocate compare_and_write buf\n");
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a95e799..3009cda 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1560,6 +1560,12 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	 * For SAM Task Attribute emulation for failed struct se_cmd
 	 */
 	transport_complete_task_attr(cmd);
+	/*
+	 * Handle special case for COMPARE_AND_WRITE failure, where the
+	 * callback is expected to drop the per device ->caw_mutex.
+	 */
+	if (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE)
+		cmd->transport_complete_callback(cmd);
 
 	switch (sense_reason) {
 	case TCM_NON_EXISTENT_LUN:
-- 
1.7.2.5
