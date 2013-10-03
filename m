From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 3/3] iscsi-target; Allow an extra tag_num / 2 number of percpu_ida tags
Date: Thu,  3 Oct 2013 21:01:12 +0000
Message-ID: <1380834072-25309-4-git-send-email-nab@daterainc.com>
References: <1380834072-25309-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1380834072-25309-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch bumps the default number of tags allocated per session by
iscsi-target via transport_alloc_session_tags() -> percpu_ida_init()
by another (tag_num / 2).

This is done to take into account the tags waiting to be acknowledged
and released in iscsit_ack_from_expstatsn(), but who's number are not
directly limited by the CmdSN Window queue_depth being enforced by
the target.

Using a larger value here is also useful to prevent percpu_ida_alloc()
from having to steal tags from other CPUs when no tags are available
on the local CPU, while waiting for unacknowledged tags to be released.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_nego.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 14d1aed..ef6d836 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1192,7 +1192,7 @@ get_target:
 	 */
 alloc_tags:
 	tag_num = max_t(u32, ISCSIT_MIN_TAGS, queue_depth);
-	tag_num += ISCSIT_EXTRA_TAGS;
+	tag_num += (tag_num / 2) + ISCSIT_EXTRA_TAGS;
 	tag_size = sizeof(struct iscsi_cmd) + conn->conn_transport->priv_size;
 
 	ret = transport_alloc_session_tags(sess->se_sess, tag_num, tag_size);
-- 
1.7.10.4
