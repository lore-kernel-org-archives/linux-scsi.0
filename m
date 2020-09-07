Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8A8C2D0E3
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 12:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56F842137B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 12:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HYUJqESt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgIGMRe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 08:17:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56956 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729240AbgIGMRK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 08:17:10 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087C5EsI027419
        for <linux-scsi@vger.kernel.org>; Mon, 7 Sep 2020 05:17:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=TlscUWwBinF6cECQatGwwiuqiobYntM8FDZQqS+IXNI=;
 b=HYUJqESt2GNnoaTwuVTqm05PP0yNsWvTyJuy/L9aUP4AgX2WaJuh0bsCpUoXKHtytQxV
 RFj0hAQsazx6i0toxJyzsNc+77kSwyN7t22ksw5xx3RZ6N4DB5JBybeQDuxQl07jiAa4
 FbyKzMukBkoWkN/hxdsGZUkfIPj/K1EnapL6a92YqS395me5bePz7DltDgEM/NMWSwHe
 JjFVUZH4Q1frQN9awmpoACjTbMxxeAo2lzo0A04fguk7rfQD55DXeMIC2bl0TtZ70Uen
 309KaqfXkHWo/1KiPH4aBOAjlRHUpGhAxpGHvpMoENSc2DV3mAt4xR6gAN+1/f1HkSdA Pg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pqv3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2020 05:17:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 05:17:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 05:17:08 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8D6003F7043;
        Mon,  7 Sep 2020 05:17:08 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 087CH8OK005230;
        Mon, 7 Sep 2020 05:17:08 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 087CH8vX005229;
        Mon, 7 Sep 2020 05:17:08 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 5/8] qedf: Return SUCCESS if stale rport in encountered
Date:   Mon, 7 Sep 2020 05:14:40 -0700
Message-ID: <20200907121443.5150-6-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200907121443.5150-1-jhasan@marvell.com>
References: <20200907121443.5150-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_06:2020-09-07,2020-09-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

 If SUCCESS is not return, it can get escalated. Hence, return
  SUCCESS similar to other conditions.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index bf1b755..50af70a 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -704,7 +704,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	rdata = fcport->rdata;
 	if (!rdata || !kref_get_unless_zero(&rdata->kref)) {
 		QEDF_ERR(&qedf->dbg_ctx, "stale rport, sc_cmd=%p\n", sc_cmd);
-		rc = 1;
+		rc = SUCCESS;
 		goto out;
 	}
 
-- 
1.8.3.1

