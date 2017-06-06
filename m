From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1] ibmvscsis: Use tpgt passed in by user
Date: Tue,  6 Jun 2017 15:45:49 -0500
Message-ID: <1496781949-46587-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751672AbdFFUqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2017 16:46:05 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v56Kiib6021858
        for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2017 16:45:55 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2awy7m4e6k-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jun 2017 16:45:54 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Tue, 6 Jun 2017 14:45:54 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

ibmvscsis always returned 0 for the tpg/tag, since it did not
parse the value passed in by the user.

When functions like ALUA members exports the value, it will
be incorrect because targetcli/rtslib starts the tpg numbering
at 1.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 3571052..522d547 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3914,8 +3914,16 @@ static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
 {
 	struct ibmvscsis_tport *tport =
 		container_of(wwn, struct ibmvscsis_tport, tport_wwn);
+	u16 tpgt;
 	int rc;
 
+	if (strstr(name, "tpgt_") != name)
+		return ERR_PTR(-EINVAL);
+	rc = kstrtou16(name + 5, 0, &tpgt);
+	if (rc)
+		return ERR_PTR(rc);
+	tport->tport_tpgt = tpgt;
+
 	tport->releasing = false;
 
 	rc = core_tpg_register(&tport->tport_wwn, &tport->se_tpg,
-- 
2.5.4 (Apple Git-61)
