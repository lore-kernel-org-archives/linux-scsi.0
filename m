From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1] ibmvscsis: Fix cleaning up pointers
Date: Tue,  9 May 2017 11:50:26 -0500
Message-ID: <1494348626-62378-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60751 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754186AbdEIQud (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 May 2017 12:50:33 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v49GmtG4040617
        for <linux-scsi@vger.kernel.org>; Tue, 9 May 2017 12:50:32 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ab91fgsx3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 09 May 2017 12:50:32 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Tue, 9 May 2017 10:50:30 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: mikecyr@linux.vnet.ibm.com, mikecyr@us.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, stable@vger.kernel.org

This patch is dependent on:
'commit 25e78531268e ("ibmvscsis: Do not send aborted task response")'
This patch cleans up some pointers after usage.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Reviewed-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> # v4.8+
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index d390325..ee64241 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1170,6 +1170,8 @@ static struct ibmvscsis_cmd *ibmvscsis_get_free_cmd(struct scsi_info *vscsi)
 		cmd = list_first_entry_or_null(&vscsi->free_cmd,
 					       struct ibmvscsis_cmd, list);
 		if (cmd) {
+			if (cmd->abort_cmd)
+				cmd->abort_cmd = NULL;
 			cmd->flags &= ~(DELAY_SEND);
 			list_del(&cmd->list);
 			cmd->iue = iue;
@@ -1774,6 +1776,7 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 				if (cmd->abort_cmd) {
 					retry = true;
 					cmd->abort_cmd->flags &= ~(DELAY_SEND);
+					cmd->abort_cmd = NULL;
 				}
 
 				/*
-- 
2.5.4 (Apple Git-61)
