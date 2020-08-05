Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC40C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F6EE2177B
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="FDTPZcuL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgHEErU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 00:47:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21388 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgHEErU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 00:47:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0754ZZqI023968
        for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2020 21:47:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=6tH6vLqUhUnBnp73H+Qa/+UpXiH+uaVtJLF1ElYn8js=;
 b=FDTPZcuLxSJrsNne7ymxK3Bv8niB52W9lXnbL+WYalWwkxzuJrkA3z/1n7BGAUY5gdC8
 rmhJgM6LZm+WVvbY3YM9b/P9yR3uiubfs3W70MMQFzMOwU7OTCf/TMY7cBX6JjGk025O
 GWdzxlvUJWqSX5IZhJHT22AxlBMVziB5qgkmm74jUTl1y6Jpmzz0Ymm2VEYBos/VI940
 KXwK2Dc8HTAXgyg9+Erfi1n+dZ43YSB839gLPI5vhUSiQcX3jCgJauCJGxyBumZoiPaf
 h/SSuO1vUxQysClRHNAGJOgUIaMDRJ0y6e5zRHJ5EKhJGdGdmWd26fcgOA1u4nvXsT8v MA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8fex8hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 21:47:18 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:47:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:47:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 4 Aug 2020 21:47:16 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 06D143F7043;
        Tue,  4 Aug 2020 21:47:16 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0754lFAR030632;
        Tue, 4 Aug 2020 21:47:15 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0754lFhI030631;
        Tue, 4 Aug 2020 21:47:15 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/10] qla2xxx: Fix WARN_ON in qla_nvme_register_hba
Date:   Tue, 4 Aug 2020 21:43:59 -0700
Message-ID: <20200805044402.30543-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200805044402.30543-1-njavali@marvell.com>
References: <20200805044402.30543-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_03:2020-08-03,2020-08-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

qla_nvme_register_hba puts out a warning when there are not enough
queue pairs available for FC-NVME.
Just fail the NVME registration rather than a WARNING + Call Trace.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  1 +
 drivers/scsi/qla2xxx/qla_nvme.c | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 8c92af5e4390..1bc090d8a71b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3880,6 +3880,7 @@ struct qla_hw_data {
 		uint32_t	scm_supported_f:1;
 				/* Enabled in Driver */
 		uint32_t	scm_enabled:1;
+		uint32_t	max_req_queue_warned:1;
 	} flags;
 
 	uint16_t max_exchg;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index d66d47a0f958..be1d49f5c622 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -686,7 +686,15 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	tmpl = &qla_nvme_fc_transport;
 
 	WARN_ON(vha->nvme_local_port);
-	WARN_ON(ha->max_req_queues < 3);
+
+	if (ha->max_req_queues < 3) {
+		if (!ha->flags.max_req_queue_warned)
+			ql_log(ql_log_info, vha, 0x2120,
+			       "%s: Disabling FC-NVME due to lack of free queue pairs (%d).\n",
+			       __func__, ha->max_req_queues);
+		ha->flags.max_req_queue_warned = 1;
+		return ret;
+	}
 
 	qla_nvme_fc_transport.max_hw_queues =
 	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
-- 
2.19.0.rc0

