Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F8E9C83014
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A95132087C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:31:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DuH+hNZc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgLAIbC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:31:02 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42138 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726415AbgLAIbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 03:31:02 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B18L24J027375
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 00:30:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=3ts3kW4KhrHFu1Kw6itn1g7AXJrcKqu8k9JwSL4OJmA=;
 b=DuH+hNZc6vds2MSkEXgaijGydL3QWmSfkQuImZ6ciSYRFJ5ISniKduXo3KiujmGUSofk
 tdUXGCwlb86LqRumtOgbdaRnsBMrqq2dyRrbEtqNc9PbXga4DwFBanIsxHW2lNf9YLtK
 svdTo3+awUAeQs1tnr6O/z22q4HfbKGLhujAzmurWibb0kfCMtaEY4I92OcEZm+53SQu
 xaZhjCam0TWyiEd89LcgMzKtCzRiybv94tMfE9p0DAdO/jCt05Edoji8bBgURk8tq2oS
 +ORlVvZTTIGqTsI1WLrDXKkp572eWHAmNE5wHbQim4BIf4u8gXstiLdESyrgVgvs2Qts RA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 353mssfkqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 00:30:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:30:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:30:20 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 00:30:20 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DF95F3F7041;
        Tue,  1 Dec 2020 00:30:19 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B18UJoN024297;
        Tue, 1 Dec 2020 00:30:19 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B18UJNP024240;
        Tue, 1 Dec 2020 00:30:19 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 06/15] qla2xxx: Fix compilation issue in PPC systems
Date:   Tue, 1 Dec 2020 00:27:21 -0800
Message-ID: <20201201082730.24158-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201201082730.24158-1-njavali@marvell.com>
References: <20201201082730.24158-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_01:2020-11-30,2020-12-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Fix compile time errors reported on PPC systems.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nx.c  | 2 +-
 drivers/scsi/qla2xxx/qla_nx2.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index b3ba0de5d4fb..fd994e36200a 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -965,7 +965,7 @@ qla82xx_read_status_reg(struct qla_hw_data *ha, uint32_t *val)
 static int
 qla82xx_flash_wait_write_finish(struct qla_hw_data *ha)
 {
-	uint32_t val;
+	uint32_t val = 0;
 	int i, ret;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 01ccd4526707..68a16c95dcb7 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -139,7 +139,7 @@ qla8044_poll_wait_for_ready(struct scsi_qla_host *vha, uint32_t addr1,
 	uint32_t mask)
 {
 	unsigned long timeout;
-	uint32_t temp;
+	uint32_t temp = 0;
 
 	/* jiffies after 100ms */
 	timeout = jiffies + msecs_to_jiffies(TIMEOUT_100_MS);
@@ -2594,7 +2594,7 @@ qla8044_minidump_process_rdmux(struct scsi_qla_host *vha,
 	struct qla8044_minidump_entry_hdr *entry_hdr,
 	uint32_t **d_ptr)
 {
-	uint32_t r_addr, s_stride, s_addr, s_value, loop_cnt, i, r_value;
+	uint32_t r_addr, s_stride, s_addr, s_value, loop_cnt, i, r_value = 0;
 	struct qla8044_minidump_entry_mux *mux_hdr;
 	uint32_t *data_ptr = *d_ptr;
 
-- 
2.19.0.rc0

