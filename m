From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 3/5] target: Release se_cmd when LUN lookup fails for TMR
Date: Wed,  2 Jan 2013 12:47:59 -0800
Message-ID: <1357159681-24477-4-git-send-email-roland@kernel.org>
References: <1357159681-24477-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:33042 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752758Ab3ABUsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2013 15:48:10 -0500
Received: by mail-gh0-f197.google.com with SMTP id f15so18527978ghb.0
        for <linux-scsi@vger.kernel.org>; Wed, 02 Jan 2013 12:48:09 -0800 (PST)
In-Reply-To: <1357159681-24477-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

When transport_lookup_tmr_lun() fails and we return a task management
response from target_complete_tmr_failure(), we need to call
transport_cmd_check_stop_to_fabric() to release the last ref to the
cmd after calling se_tfo->queue_tm_rsp(), or else we will never remove
the failed TMR from the session command list (and we'll end up waiting
forever when trying to tear down the session).

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 49390d8..fe6208f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1393,6 +1393,8 @@ static void target_complete_tmr_failure(struct work_struct *work)
 
 	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
+
+	transport_cmd_check_stop_to_fabric(cmd);
 }
 
 /**
-- 
1.8.0

