Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF8AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240811AbiCJJ1b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240797AbiCJJ10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F036139CDF
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dmHP025048
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=oK0ATmMZAh2zMoSKLRHfBEeRInJZrArnhBra9UswBb4=;
 b=jRSY63oj9KmCmSlbk21fyIMm5t3wdxIZHyOuvYlUrg+IFu+0S+PLmT+sy/ihj7yG5mvM
 lHmecHLUWo9SJIz7xzXdiWtl43oIdoRsFDfyUpnBjP1rI+uvJEKcD2eWaF7JZja2jMYW
 z6yAa7auxhgi8f0ywCip/ZB/f8eKYNQPSXmUVETAiAeI9Jj+Dc0dipIKOcwtjbJYTtIC
 w0PxJ8iQe1MzoxomBc/geMw/xeFuhed5myhcosjOzHwFsQl9DtbNMTCGUVEsVE9v4YV1
 s+N1x6cM80OrtdW4PdXIwVdA6s7Tn1OUFUI3iS0bqLnfZQiFrM/+U+0j9IC+lSKnnwFK 8Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Mar
 2022 01:26:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:23 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 06CEB3F705B;
        Thu, 10 Mar 2022 01:26:23 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QMrg022997;
        Thu, 10 Mar 2022 01:26:22 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9QMol022996;
        Thu, 10 Mar 2022 01:26:22 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 03/13] qla2xxx: Fix loss of NVME namespaces after driver reload test
Date:   Thu, 10 Mar 2022 01:25:54 -0800
Message-ID: <20220310092604.22950-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: x07jE0nlzrRb-l7mUYqUIROS0P8MokAR
X-Proofpoint-ORIG-GUID: x07jE0nlzrRb-l7mUYqUIROS0P8MokAR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Driver registration of localport can race when it
happens at the remote port discovery time. Fix
this by calling the registration under a mutex.

Reported-by: Marco Patalano <mpatalan@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Cc: stable@vger.kernel.org
Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization and transport registration")
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 5723082d94d6..3bf5cbd754a7 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -782,8 +782,6 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	ha = vha->hw;
 	tmpl = &qla_nvme_fc_transport;
 
-	WARN_ON(vha->nvme_local_port);
-
 	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES || ql2xnvme_queues > MAX_NVME_HW_QUEUES) {
 		ql_log(ql_log_warn, vha, 0xfffd,
 		    "ql2xnvme_queues=%d is out of range(MIN:%d - MAX:%d). Resetting ql2xnvme_queues to:%d\n",
@@ -797,7 +795,7 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
 
 	ql_log(ql_log_info, vha, 0xfffb,
-	    "Number of NVME queues used for this port: %d\n",
+	       "Number of NVME queues used for this port: %d\n",
 	    qla_nvme_fc_transport.max_hw_queues);
 
 	pinfo.node_name = wwn_to_u64(vha->node_name);
@@ -805,13 +803,25 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	pinfo.port_role = FC_PORT_ROLE_NVME_INITIATOR;
 	pinfo.port_id = vha->d_id.b24;
 
-	ql_log(ql_log_info, vha, 0xffff,
-	    "register_localport: host-traddr=nn-0x%llx:pn-0x%llx on portID:%x\n",
-	    pinfo.node_name, pinfo.port_name, pinfo.port_id);
-	qla_nvme_fc_transport.dma_boundary = vha->host->dma_boundary;
-
-	ret = nvme_fc_register_localport(&pinfo, tmpl,
-	    get_device(&ha->pdev->dev), &vha->nvme_local_port);
+	mutex_lock(&ha->vport_lock);
+	/*
+	 * Check again for nvme_local_port to see if any other thread raced
+	 * with this one and finished registration.
+	 */
+	if (!vha->nvme_local_port) {
+		ql_log(ql_log_info, vha, 0xffff,
+		    "register_localport: host-traddr=nn-0x%llx:pn-0x%llx on portID:%x\n",
+		    pinfo.node_name, pinfo.port_name, pinfo.port_id);
+		qla_nvme_fc_transport.dma_boundary = vha->host->dma_boundary;
+
+		ret = nvme_fc_register_localport(&pinfo, tmpl,
+						 get_device(&ha->pdev->dev),
+						 &vha->nvme_local_port);
+		mutex_unlock(&ha->vport_lock);
+	} else {
+		mutex_unlock(&ha->vport_lock);
+		return 0;
+	}
 	if (ret) {
 		ql_log(ql_log_warn, vha, 0xffff,
 		    "register_localport failed: ret=%x\n", ret);
-- 
2.19.0.rc0

