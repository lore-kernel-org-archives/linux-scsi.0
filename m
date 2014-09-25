From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 18/19] Target/transport: SCSI Status Respond being sent to Initiator twice.
Date: Thu, 25 Sep 2014 04:10:11 -0400
Message-ID: <1411632612-7320-19-git-send-email-saurav.kashyap@qlogic.com>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:59824 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109AbaIYIoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 04:44:17 -0400
In-Reply-To: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

From: Quinn Tran <quinn.tran@qlogic.com>

During temporary resource starvation at lower transport layer, command
is placed on queue full retry path, which expose this problem.  The TCM
Qfull handling send the same cmd twice to lower layer.  The 1st time
led to cmd normal free path.  The 2nd time cause Null pointer access.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/target/target_core_transport.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7fa62fc..ab61014 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1877,8 +1877,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
 	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret)
-			goto out;
+		goto out;
 	}
 
 	switch (cmd->data_direction) {
-- 
1.7.7

