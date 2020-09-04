Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA10BC43461
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8575206E7
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:52:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="K8/ZjptR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgIDEwT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:52:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7702 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725765AbgIDEwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 00:52:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0844oe8Y011257
        for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2020 21:52:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=OH3zLa0ybCc8bf39M/fbApT3gR+SD1m3M9v9/DWLknU=;
 b=K8/ZjptRgXinnK8nTVzhRiLLaCOoyWQ+ZfhRuVqvCOG1lC4sxrpCdcbmcP9rmSFREXWc
 OO0ZR1SaOvDrvN+9DSTLZ3lOdGhzUNG0GFXbMS4bog/LWHufAJ9dTLsvqsyh1KRaCoym
 BlLIXzhdUUcZRUdWTRSBt3qYNpXz2lfaYJI0XE3WNGPN2dAceZPr4CiphlBL2IOsxuSm
 AFgOfceogMFV1gTziKF4tdzmzTAAhNdo8HbR/TujagtVRrtFMNdGfCao6YEi5hRCoS2M
 IzLBrqRCUEpuzL8O41F6Hj1VR4dzQrADUi8mcRxlu9Z5W1UoaYJx4OnHxH1WaU6m6aaE NQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqrpwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 21:52:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 21:52:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Sep 2020 21:52:16 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A43803F704B;
        Thu,  3 Sep 2020 21:52:16 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0844qG3Z023679;
        Thu, 3 Sep 2020 21:52:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0844qGs7023670;
        Thu, 3 Sep 2020 21:52:16 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 01/13] qla2xxx: Fix I/O failures during remote port toggle testing
Date:   Thu, 3 Sep 2020 21:51:16 -0700
Message-ID: <20200904045128.23631-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200904045128.23631-1-njavali@marvell.com>
References: <20200904045128.23631-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_02:2020-09-03,2020-09-04 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Driver was using a lower value for dev_loss_tmo making it more prone to
I/O failures during remote port toggle testing. Set dev_loss_tmo to zero
during remote port registration to allow nvme-fc default dev_loss_tmo to
be used, which is higher than what driver was using.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 drivers/scsi/qla2xxx/qla_nvme.h | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 90bbc61f361b..435f17f87301 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -42,7 +42,7 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
 	req.port_name = wwn_to_u64(fcport->port_name);
 	req.node_name = wwn_to_u64(fcport->node_name);
 	req.port_role = 0;
-	req.dev_loss_tmo = NVME_FC_DEV_LOSS_TMO;
+	req.dev_loss_tmo = 0;
 
 	if (fcport->nvme_prli_service_param & NVME_PRLI_SP_INITIATOR)
 		req.port_role = FC_PORT_ROLE_NVME_INITIATOR;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_nvme.h
index fbb844226630..cf45a5b277f1 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.h
+++ b/drivers/scsi/qla2xxx/qla_nvme.h
@@ -14,9 +14,6 @@
 #include "qla_def.h"
 #include "qla_dsd.h"
 
-/* default dev loss time (seconds) before transport tears down ctrl */
-#define NVME_FC_DEV_LOSS_TMO  30
-
 #define NVME_ATIO_CMD_OFF 32
 #define NVME_FIRST_PACKET_CMDLEN (64 - NVME_ATIO_CMD_OFF)
 #define Q2T_NVME_NUM_TAGS 2048
-- 
2.19.0.rc0

