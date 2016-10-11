From: Michael Cyr <mikecyr@us.ibm.com>
Subject: [PATCH v1 2/3] Properly handle if target_submit_cmd/tmr fails
Date: Tue, 11 Oct 2016 17:58:04 -0500
Message-ID: <1476226685-2276-3-git-send-email-mikecyr@us.ibm.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43511 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754636AbcJKW6b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Oct 2016 18:58:31 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9BMrga3101084
        for <linux-scsi@vger.kernel.org>; Tue, 11 Oct 2016 18:58:30 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2615bv8xma-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 11 Oct 2016 18:58:30 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mikecyr@us.ibm.com>;
        Tue, 11 Oct 2016 16:58:30 -0600
In-Reply-To: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, Michael Cyr <mikecyr@us.ibm.com>

Signed-off-by: Michael Cyr <mikecyr@us.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 34f758c..5c4b979 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2561,6 +2561,10 @@ static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
 			       data_len, attr, dir, 0);
 	if (rc) {
 		dev_err(&vscsi->dev, "target_submit_cmd failed, rc %d\n", rc);
+		spin_lock_bh(&vscsi->intr_lock);
+		list_del(&cmd->list);
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+		spin_unlock_bh(&vscsi->intr_lock);
 		goto fail;
 	}
 	return;
@@ -2640,6 +2644,9 @@ static void ibmvscsis_parse_task(struct scsi_info *vscsi,
 		if (rc) {
 			dev_err(&vscsi->dev, "target_submit_tmr failed, rc %d\n",
 				rc);
+			spin_lock_bh(&vscsi->intr_lock);
+			list_del(&cmd->list);
+			spin_unlock_bh(&vscsi->intr_lock);
 			cmd->se_cmd.se_tmr_req->response =
 				TMR_FUNCTION_REJECTED;
 		}
-- 
2.5.0

