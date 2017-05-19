From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH 7/7] qedi: Fix endpoint NULL panic during recovery.
Date: Fri, 19 May 2017 01:33:21 -0700
Message-ID: <20170519083321.18030-8-manish.rangankar@cavium.com>
References: <20170519083321.18030-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0059.outbound.protection.outlook.com ([104.47.36.59]:64800
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755168AbdESIdt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 04:33:49 -0400
In-Reply-To: <20170519083321.18030-1-manish.rangankar@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index d6978cb..8bc7ee1 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1494,6 +1494,8 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
 	ep = qedi_conn->ep;
+	if (!ep)
+		return -ENODEV;
 
 	tid = qedi_get_task_idx(qedi);
 	if (tid == -1)
-- 
1.8.3.1
