Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E006C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240813AbiCJJ1m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240810AbiCJJ13 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:29 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1AF139CDA
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:28 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dlxL024974
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=t01Jpkvqi12Jaxpoujgi5IKpFLXnHkfmvT5TpgV5ocQ=;
 b=HvWkcG1GBPZnAE6PCJhBPPKEZVKPPHU7zMfNycEX9fQFJthT0LX6Aw+LQu/Th+EoS7+u
 y3US2C7oa0I4SBkkbb+lQd5IoFWLXVEZHheoolnmZjXQ+DFxw42UtYqs6UuuL26j5Op4
 9HCncxUmvZf/hD/fiCeVe2gnLV7HqTpmXNVfEacC/bdHd7rcR9iU5Vyqp7B8h/JA1cx4
 NjOEdNF/6GiU1z19H8hTpE8b75yUyPz39LBnihZy5mn5exgWTDMQarCbAAVhNb2dE4J3
 kkP9cuzR9UWZOsZOX6+D0XbkfeLPHlVsvzL94O8VhqUSFpXqLn7GvXw9JM/uOqnOz5hv 5w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7x-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:27 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Mar
 2022 01:26:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:23 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D98383F7058;
        Thu, 10 Mar 2022 01:26:23 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QNFA023033;
        Thu, 10 Mar 2022 01:26:23 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9QNZs023032;
        Thu, 10 Mar 2022 01:26:23 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 12/13] qla2xxx: Increase max limit of ql2xnvme_queues
Date:   Thu, 10 Mar 2022 01:26:03 -0800
Message-ID: <20220310092604.22950-13-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: PZpCLa101F759P8NRPpK-6516D_43Q4G
X-Proofpoint-ORIG-GUID: PZpCLa101F759P8NRPpK-6516D_43Q4G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shreyas Deodhar <sdeodhar@marvell.com>

Increase max limit of ql2xnvme_queues to (max_qpair - 1).

Cc: stable@vger.kernel.org
Fixes: 65120de26a547 ("scsi: qla2xxx: Add ql2xnvme_queues module param to configure number of NVMe queues")
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 15 ++++++++++-----
 drivers/scsi/qla2xxx/qla_nvme.h |  1 -
 drivers/scsi/qla2xxx/qla_os.c   |  1 -
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 794a95b2e3b4..87c9404aa401 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -799,17 +799,22 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	ha = vha->hw;
 	tmpl = &qla_nvme_fc_transport;
 
-	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES || ql2xnvme_queues > MAX_NVME_HW_QUEUES) {
+	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES) {
 		ql_log(ql_log_warn, vha, 0xfffd,
-		    "ql2xnvme_queues=%d is out of range(MIN:%d - MAX:%d). Resetting ql2xnvme_queues to:%d\n",
-		    ql2xnvme_queues, MIN_NVME_HW_QUEUES, MAX_NVME_HW_QUEUES,
-		    DEF_NVME_HW_QUEUES);
+		    "ql2xnvme_queues=%d is lower than minimum queues: %d. Resetting ql2xnvme_queues to:%d\n",
+		    ql2xnvme_queues, MIN_NVME_HW_QUEUES, DEF_NVME_HW_QUEUES);
 		ql2xnvme_queues = DEF_NVME_HW_QUEUES;
+	} else if (ql2xnvme_queues > (ha->max_qpairs - 1)) {
+		ql_log(ql_log_warn, vha, 0xfffd,
+		       "ql2xnvme_queues=%d is greater than available IRQs: %d. Resetting ql2xnvme_queues to: %d\n",
+		       ql2xnvme_queues, (ha->max_qpairs - 1),
+		       (ha->max_qpairs - 1));
+		ql2xnvme_queues = ((ha->max_qpairs - 1));
 	}
 
 	qla_nvme_fc_transport.max_hw_queues =
 	    min((uint8_t)(ql2xnvme_queues),
-		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
+		(uint8_t)((ha->max_qpairs - 1) ? (ha->max_qpairs - 1) : 1));
 
 	ql_log(ql_log_info, vha, 0xfffb,
 	       "Number of NVME queues used for this port: %d\n",
diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_nvme.h
index d0e3c0e07baa..d299478371b2 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.h
+++ b/drivers/scsi/qla2xxx/qla_nvme.h
@@ -14,7 +14,6 @@
 #include "qla_dsd.h"
 
 #define MIN_NVME_HW_QUEUES 1
-#define MAX_NVME_HW_QUEUES 128
 #define DEF_NVME_HW_QUEUES 8
 
 #define NVME_ATIO_CMD_OFF 32
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 89c7ac36a41a..8f47dd421e33 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -344,7 +344,6 @@ MODULE_PARM_DESC(ql2xnvme_queues,
 	"Number of NVMe Queues that can be configured.\n"
 	"Final value will be min(ql2xnvme_queues, num_cpus,num_chip_queues)\n"
 	"1 - Minimum number of queues supported\n"
-	"128 - Maximum number of queues supported\n"
 	"8 - Default value");
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
-- 
2.19.0.rc0

