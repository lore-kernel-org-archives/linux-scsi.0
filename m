From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/3] target: Allow non zero ListID in EXTENDED_COPY parameter list
Date: Tue,  8 Oct 2013 19:56:32 +0000
Message-ID: <1381262193-19797-3-git-send-email-nab@daterainc.com>
References: <1381262193-19797-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381262193-19797-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes target_do_xcopy() to allow processing of non-zero
ListIDs in EXTENDED_COPY parameter list data, instead of returning
CHECK_CONDITION status.

As the copy offload implementation reports SNLID=1 (Supports No ListID)
in OPERATING PARAMETERS, any ListID value presented by the client is
currently ignored.

Also, properly extract list_id_usage for informational purposes.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_xcopy.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 6b9774c..fe98555 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -911,11 +911,8 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 	}
 
 	list_id = p[0];
-	if (list_id != 0x00) {
-		pr_err("XCOPY with non zero list_id: 0x%02x\n", list_id);
-		goto out;
-	}
-	list_id_usage = (p[1] & 0x18);
+	list_id_usage = (p[1] & 0x18) >> 3;
+
 	/*
 	 * Determine TARGET DESCRIPTOR LIST LENGTH + SEGMENT DESCRIPTOR LIST LENGTH
 	 */
-- 
1.7.10.4
