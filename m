Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C526C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B1A60EBD
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbhHJEkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:40:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237180AbhHJEj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:39:58 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A4amVp008701
        for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2021 21:39:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=vITjiZ/KaAHTgmTLxeQO3DmbzvQMKLNgJPPNLB0CP6k=;
 b=AOeX7IGgPSe45sFYqzwaHEFUPjPQIi15k7/0JiG8qqR38vy465eeumoqEcuZywAhAbbf
 aQ3iXMqdB1ymouRd3XK26/18Vu+BhxGaEtmN8fDDL3Bz8emSKaqkZRtYtt9CxFa+evIQ
 Duq3O8gU4/+9cqZ/4jo3Hl+Oqp+Y7UCt3wjYBA+w8tjF3uti4hngpBnTRyYq8Gk5MmY3
 V0uilSSNMh5FNxJWoNVF95rUBMkmQym8Vm96D+CjlR82BHf/JegZddCNGCphrAgA7dYL
 8sZmtvyKUqazcmrKdoXVtPAxfDunJarMy4tkZBN0FzZOrhuPdAMApDXdS7X5eA1GIEKr TQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3abfu2gf97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 21:39:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 9 Aug
 2021 21:39:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 9 Aug 2021 21:39:35 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C923D3F7044;
        Mon,  9 Aug 2021 21:39:35 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17A4dZkX001229;
        Mon, 9 Aug 2021 21:39:35 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17A4dZ8D001228;
        Mon, 9 Aug 2021 21:39:35 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 10/14] qla2xxx: suppress unnecessary log messages during login
Date:   Mon, 9 Aug 2021 21:37:16 -0700
Message-ID: <20210810043720.1137-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210810043720.1137-1-njavali@marvell.com>
References: <20210810043720.1137-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: S8MHmxRKES1YPs4g0fDZM5fYwvJo-Hpx
X-Proofpoint-GUID: S8MHmxRKES1YPs4g0fDZM5fYwvJo-Hpx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Suppress logging of retryable errors. These could still be seen
if extended logging is enabled.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c  | 23 +++++++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index df532c5531a9..4f68b4ebcbc4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -360,7 +360,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	if (NVME_TARGET(vha->hw, fcport))
 		lio->u.logio.flags |= SRB_LOGIN_SKIP_PRLI;
 
-	ql_log(ql_log_warn, vha, 0x2072,
+	ql_dbg(ql_dbg_disc, vha, 0x2072,
 	       "Async-login - %8phC hdl=%x, loopid=%x portid=%06x retries=%d.\n",
 	       fcport->port_name, sp->handle, fcport->loop_id,
 	       fcport->d_id.b24, fcport->login_retry);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 93ab686c7a30..b0b5af21781a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2326,6 +2326,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct srb_iocb *lio;
 	uint16_t *data;
 	uint32_t iop[2];
+	int logit = 1;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, logio);
 	if (!sp)
@@ -2403,9 +2404,11 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	case LSC_SCODE_PORTID_USED:
 		data[0] = MBS_PORT_ID_USED;
 		data[1] = LSW(iop[1]);
+		logit = 0;
 		break;
 	case LSC_SCODE_NPORT_USED:
 		data[0] = MBS_LOOP_ID_USED;
+		logit = 0;
 		break;
 	case LSC_SCODE_CMD_FAILED:
 		if (iop[1] == 0x0606) {
@@ -2438,12 +2441,20 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		break;
 	}
 
-	ql_log(ql_log_warn, sp->vha, 0x5037,
-	       "Async-%s failed: handle=%x pid=%06x wwpn=%8phC comp_status=%x iop0=%x iop1=%x\n",
-	       type, sp->handle, fcport->d_id.b24, fcport->port_name,
-	       le16_to_cpu(logio->comp_status),
-	       le32_to_cpu(logio->io_parameter[0]),
-	       le32_to_cpu(logio->io_parameter[1]));
+	if (logit)
+		ql_log(ql_log_warn, sp->vha, 0x5037, "Async-%s failed: "
+		       "handle=%x pid=%06x wwpn=%8phC comp_status=%x iop0=%x iop1=%x\n",
+		       type, sp->handle, fcport->d_id.b24, fcport->port_name,
+		       le16_to_cpu(logio->comp_status),
+		       le32_to_cpu(logio->io_parameter[0]),
+		       le32_to_cpu(logio->io_parameter[1]));
+	else
+		ql_dbg(ql_dbg_disc, sp->vha, 0x5037, "Async-%s failed: "
+		       "handle=%x pid=%06x wwpn=%8phC comp_status=%x iop0=%x iop1=%x\n",
+		       type, sp->handle, fcport->d_id.b24, fcport->port_name,
+		       le16_to_cpu(logio->comp_status),
+		       le32_to_cpu(logio->io_parameter[0]),
+		       le32_to_cpu(logio->io_parameter[1]));
 
 logio_done:
 	sp->done(sp, 0);
-- 
2.19.0.rc0

