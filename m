From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1 1/3] Ibmvscsis: Properly deregister target sessions
Date: Wed, 31 Aug 2016 11:28:59 -0500
Message-ID: <1472660941-23856-2-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1472660941-23856-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935724AbcHaQ3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 12:29:12 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7VGMfY0098585
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2016 12:29:11 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 255p3whan7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2016 12:29:11 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Wed, 31 Aug 2016 12:29:10 -0400
In-Reply-To: <1472660941-23856-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, dan.carpenter@oracle.com
Cc: mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

The driver currently doesn't properly deregisters target sessions
completely, so this will address that.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Signed-off-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index b29fef9..a515cdd 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1934,6 +1934,8 @@ static int ibmvscsis_drop_nexus(struct ibmvscsis_tport *tport)
 	/*
 	 * Release the SCSI I_T Nexus to the emulated ibmvscsis Target Port
 	 */
+	target_wait_for_sess_cmds(se_sess);
+	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 	tport->ibmv_nexus = NULL;
 	kfree(nexus);
-- 
2.5.4 (Apple Git-61)

