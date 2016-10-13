From: Michael Cyr <mikecyr@us.ibm.com>
Subject: [PATCH v2 6/6] ibmvscsis: Issues from Dan Carpenter/Smatch
Date: Thu, 13 Oct 2016 11:02:43 -0500
Message-ID: <1476374563-13967-7-git-send-email-mikecyr@us.ibm.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
 <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50349 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756549AbcJMQE5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 12:04:57 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9DFxR5T092283
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 12:03:15 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 262awv30q9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 12:03:15 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mikecyr@us.ibm.com>;
        Thu, 13 Oct 2016 12:03:14 -0400
In-Reply-To: <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, Michael Cyr <mikecyr@us.ibm.com>

Signed-off-by: Michael Cyr <mikecyr@us.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index fe220a1..c9fa356 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1896,14 +1896,7 @@ static long ibmvscsis_mad(struct scsi_info *vscsi, struct viosrp_crq *crq)
 
 		pr_debug("mad: type %d\n", be32_to_cpu(mad->type));
 
-		if (be16_to_cpu(mad->length) < 0) {
-			dev_err(&vscsi->dev, "mad: length is < 0\n");
-			ibmvscsis_post_disconnect(vscsi,
-						  ERR_DISCONNECT_RECONNECT, 0);
-			rc = SRP_VIOLATION;
-		} else {
-			rc = ibmvscsis_process_mad(vscsi, iue);
-		}
+		rc = ibmvscsis_process_mad(vscsi, iue);
 
 		pr_debug("mad: status %hd, rc %ld\n", be16_to_cpu(mad->status),
 			 rc);
@@ -2523,7 +2516,6 @@ static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
 		dev_err(&vscsi->dev, "0x%llx: parsing SRP descriptor table failed.\n",
 			srp->tag);
 		goto fail;
-		return;
 	}
 
 	cmd->rsp.sol_not = srp->sol_not;
@@ -3282,7 +3274,8 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	INIT_LIST_HEAD(&vscsi->waiting_rsp);
 	INIT_LIST_HEAD(&vscsi->active_q);
 
-	snprintf(vscsi->tport.tport_name, 256, "%s", dev_name(&vdev->dev));
+	snprintf(vscsi->tport.tport_name, IBMVSCSIS_NAMELEN, "%s",
+		 dev_name(&vdev->dev));
 
 	pr_debug("probe tport_name: %s\n", vscsi->tport.tport_name);
 
-- 
2.5.0

