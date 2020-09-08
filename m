Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9FEC43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96E6521897
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dn991XKX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgIHF0o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 01:26:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45212 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbgIHF0n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 01:26:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0885Pi85023737;
        Mon, 7 Sep 2020 22:26:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=bmDvC3ZNx55Y+wPxvBwkaE98rDbLuoSaGr6pb30JTdU=;
 b=dn991XKX50F2jg8rtrgFjXVO7gl9A3/I/pJABHg07uTr50+8LW/1RA6GqOs7uCR2xQR3
 G3jlDXiCrjM9lpkUTapVRaizPDIHgh7pvhG/U9doYU23eLzE9ks6D/zRbE+ea/vMMXLt
 NkTp5SGf5Y1He5FG+tlnwni5PKuJC/Huf4U7fy2YmVvIvE9i3uDPkLWLAnFFA28w0R1+
 CoPBpGFwwoeM1g4O/peBE/F1V+gVr5uR9Ss1hUnOMgbxqn8VxpSUsakLmA9Y9aOlX7Gt
 Ceighs/YMi71WFRmvr7OYdbrtzedfYGCbNzimWMrNBMuAWz0exLMTXT7CFP5eg+J1TVS Yg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pt6d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 22:26:38 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 22:26:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 22:26:37 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3BEAB3F7043;
        Mon,  7 Sep 2020 22:26:37 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0885QbmH021989;
        Mon, 7 Sep 2020 22:26:37 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0885Qbp8021988;
        Mon, 7 Sep 2020 22:26:37 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 5/8] qedi: Use snprintf instead of sprintf
Date:   Mon, 7 Sep 2020 22:24:09 -0700
Message-ID: <20200908052412.21917-6-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200908052412.21917-1-mrangankar@marvell.com>
References: <20200908052412.21917-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_02:2020-09-07,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use snprintf to limit max number of bytes to the buffer.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index e1ec22d7d699..2db99613b8a9 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2538,7 +2538,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_DISC, "MAC address is %pM.\n",
 		  qedi->mac);
 
-	sprintf(host_buf, "host_%d", qedi->shost->host_no);
+	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
 	qedi_ops->common->set_name(qedi->cdev, host_buf);
 
 	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
-- 
2.25.0

