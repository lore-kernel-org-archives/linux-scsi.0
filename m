Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2FCC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351756AbhLXHIB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:08:01 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48638 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351757AbhLXHHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:53 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2WGJx008452
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=M8u1DDpHFucZYdLqiOa+eImPayo+Hp2wEuTeG5x8EXY=;
 b=D16qycRvN9KlzH20llHZBcJaFrn+GbKmn2pwTEZO8D5lCydLEajxlCb6+VO7u/QgHrxB
 RdD7kFdZKWftTelRUWihE/5kTNxACZpfoArR9aQTcAHB5Dcuw4zM6Y5VfQn0zaRRPjjd
 OzwcMkBeHI6EN3tzK8EiQp199Y/LxN2wNcBFJfUEEATyo6JqbWRJX5qm4Il85Clt2A7N
 42oiCfyKSic2k4pCvIbIu68iyQDzZDvnOuNv2mfTLyZUmIcMFh31zFK3Yd9pMJGX8WmQ
 EBzPciKznsbV7RRVXwks6IC9r7dj2hB2JF+1Ehe3PZxFFLdPayz9DVsuKWl+dzfIHjM+ SA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d4t6kjua2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:52 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 23:07:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:51 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8E8053F7097;
        Thu, 23 Dec 2021 23:07:49 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77nis017984;
        Thu, 23 Dec 2021 23:07:49 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77nvg017983;
        Thu, 23 Dec 2021 23:07:49 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 09/16] qla2xxx: Add ql2xnvme_queues module param to configure number of NVME queues
Date:   Thu, 23 Dec 2021 23:07:05 -0800
Message-ID: <20211224070712.17905-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211224070712.17905-1-njavali@marvell.com>
References: <20211224070712.17905-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: gy1EeJQQASD19oHFEXNZSR5m2l1eoiPY
X-Proofpoint-ORIG-GUID: gy1EeJQQASD19oHFEXNZSR5m2l1eoiPY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shreyas Deodhar <sdeodhar@marvell.com>

Add ql2xnvme_queues module parameter to configure number of NVME queues

Usage:
Number of NVMe Queues that can be configured.
Final value will be min(ql2xnvme_queues, num_cpus, num_chip_queues),
1 - Minimum number of queues supported
128 - Maximum number of queues supported
8 - Default value

Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_nvme.c | 16 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_nvme.h |  4 ++++
 drivers/scsi/qla2xxx/qla_os.c   |  8 ++++++++
 4 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3f8b8bbabe6d..cedc347e3c33 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -192,6 +192,7 @@ extern int ql2xfulldump_on_mpifail;
 extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
+extern u32 ql2xnvme_queues;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index e22ec7cb65db..718c761ff5f8 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -710,7 +710,7 @@ static struct nvme_fc_port_template qla_nvme_fc_transport = {
 	.fcp_io		= qla_nvme_post_cmd,
 	.fcp_abort	= qla_nvme_fcp_abort,
 	.map_queues	= qla_nvme_map_queues,
-	.max_hw_queues  = 8,
+	.max_hw_queues  = DEF_NVME_HW_QUEUES,
 	.max_sgl_segments = 1024,
 	.max_dif_sgl_segments = 64,
 	.dma_boundary = 0xFFFFFFFF,
@@ -779,10 +779,22 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 
 	WARN_ON(vha->nvme_local_port);
 
+	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES || ql2xnvme_queues > MAX_NVME_HW_QUEUES) {
+		ql_log(ql_log_warn, vha, 0xfffd,
+		    "ql2xnvme_queues=%d is out of range(MIN:%d - MAX:%d). Resetting ql2xnvme_queues to:%d\n",
+		    ql2xnvme_queues, MIN_NVME_HW_QUEUES, MAX_NVME_HW_QUEUES,
+		    DEF_NVME_HW_QUEUES);
+		ql2xnvme_queues = DEF_NVME_HW_QUEUES;
+	}
+
 	qla_nvme_fc_transport.max_hw_queues =
-	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
+	    min((uint8_t)(ql2xnvme_queues),
 		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
 
+	ql_log(ql_log_info, vha, 0xfffb,
+	    "Number of NVME queues used for this port: %d\n",
+	    qla_nvme_fc_transport.max_hw_queues);
+
 	pinfo.node_name = wwn_to_u64(vha->node_name);
 	pinfo.port_name = wwn_to_u64(vha->port_name);
 	pinfo.port_role = FC_PORT_ROLE_NVME_INITIATOR;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_nvme.h
index f81f219c7c7d..d0e3c0e07baa 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.h
+++ b/drivers/scsi/qla2xxx/qla_nvme.h
@@ -13,6 +13,10 @@
 #include "qla_def.h"
 #include "qla_dsd.h"
 
+#define MIN_NVME_HW_QUEUES 1
+#define MAX_NVME_HW_QUEUES 128
+#define DEF_NVME_HW_QUEUES 8
+
 #define NVME_ATIO_CMD_OFF 32
 #define NVME_FIRST_PACKET_CMDLEN (64 - NVME_ATIO_CMD_OFF)
 #define Q2T_NVME_NUM_TAGS 2048
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c4b4b4496399..7d5159306112 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -338,6 +338,14 @@ static void qla2x00_free_device(scsi_qla_host_t *);
 static int qla2xxx_map_queues(struct Scsi_Host *shost);
 static void qla2x00_destroy_deferred_work(struct qla_hw_data *);
 
+u32 ql2xnvme_queues = DEF_NVME_HW_QUEUES;
+module_param(ql2xnvme_queues, uint, S_IRUGO);
+MODULE_PARM_DESC(ql2xnvme_queues,
+	"Number of NVMe Queues that can be configured.\n"
+	"Final value will be min(ql2xnvme_queues, num_cpus,num_chip_queues)\n"
+	"1 - Minimum number of queues supported\n"
+	"128 - Maximum number of queues supported\n"
+	"8 - Default value");
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
 struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
-- 
2.23.1

