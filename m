From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] ibmvscsis: Fix write_pending failure path
Date: Mon,  2 Oct 2017 12:59:38 -0500
Message-ID: <20171002175938.11764-1-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42998 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751268AbdJBR7o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 13:59:44 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v92HxJcA008704
        for <linux-scsi@vger.kernel.org>; Mon, 2 Oct 2017 13:59:44 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dbp3d6dwa-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2017 13:59:44 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Mon, 2 Oct 2017 11:59:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>

From: "Bryant G. Ly" <bgly@us.ibm.com>

For write_pending if the queue is down or client failed
then return -EIO so that LIO can properly process the
completed command. Prior we returned 0 since LIO could
not handle it properly. Now with:
target: Fix unknown fabric callback queue-full errors
that patch addresses LIO's ability to handle things right.

Signed-off-by: Bryant G. Ly <bgly@us.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 1f75d0380516f..fe5b9d7bc06df 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3767,7 +3767,7 @@ static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 	 */
 	if ((vscsi->flags & (CLIENT_FAILED | RESPONSE_Q_DOWN))) {
 		pr_err("write_pending failed since: %d\n", vscsi->flags);
-		return 0;
+		return -EIO;
 	}
 
 	rc = srp_transfer_data(cmd, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma,
-- 
2.13.5 (Apple Git-94)
