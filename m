From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 1/2] qla2xxx: Don't crash if we can't find cmd for failed CTIO
Date: Mon, 11 Jun 2012 18:23:15 -0700
Message-ID: <1339464196-22744-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:51937 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753092Ab2FLBXW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jun 2012 21:23:22 -0400
Received: by dano14 with SMTP id o14so6796618dan.11
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jun 2012 18:23:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arun Easi <arun.easi@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

In qlt_do_ctio_completion(), there's no point in calling
qlt_term_ctio_exchange() with a NULL cmd -- all that it does is crash
in a NULL pointer dereference, since it does

	qlt_send_term_exchange(vha, cmd, &cmd->atio, 1);

and dereferencing &cmd->atio is a bad idea if cmd itself is NULL.

If we really need to do this, we could take the values from the
failed CTIO we're processing, but it's not clear if it's worth
the replumbing to do that.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 04f80eb..c263f90 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2477,11 +2477,9 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 	}
 
 	cmd = qlt_ctio_to_cmd(vha, handle, ctio);
-	if (cmd == NULL) {
-		if (status != CTIO_SUCCESS)
-			qlt_term_ctio_exchange(vha, ctio, NULL, status);
+	if (cmd == NULL)
 		return;
-	}
+
 	se_cmd = &cmd->se_cmd;
 	tfo = se_cmd->se_tfo;
 
-- 
1.7.9.5

