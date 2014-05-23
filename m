From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] iser-target: Add missing target_put_sess_cmd for ImmedateData failure
Date: Fri, 23 May 2014 19:32:49 +0000
Message-ID: <1400873569-3606-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:49787 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaEWT5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2014 15:57:30 -0400
Received: by mail-oa0-f52.google.com with SMTP id eb12so6133882oac.39
        for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 12:57:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a bug where an early exception for SCSI WRITE
with ImmediateData=Yes was missing the target_put_sess_cmd() call
to drop the extra se_cmd->cmd_kref reference obtained during the
normal iscsit_setup_scsi_cmd() codepath execution.

This bug was manifesting itself during session shutdown within
isert_cq_rx_comp_err() where target_wait_for_sess_cmds() would
end up waiting indefinately for the last se_cmd->cmd_kref put to
occur for the failed SCSI WRITE + ImmediateData descriptors.

This fix follows what traditional iscsi-target code already does
for the same failure case within iscsit_get_immediate_data().

Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b622783..52c5ab8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1209,6 +1209,8 @@ sequence_cmd:
 
 	if (!rc && dump_payload == false && unsol_data)
 		iscsit_set_unsoliticed_dataout(cmd);
+	else if (dump_payload && imm_data)
+		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
 
 	return 0;
 }
-- 
1.7.10.4

