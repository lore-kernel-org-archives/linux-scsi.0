Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A652C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E53AE22C9F
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="ciPUGO5e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgHGLJx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 07:09:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37090 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbgHGLIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 07:08:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077AoEsc009463
        for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2020 04:08:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=CLcZ/UE+uwL7RS9wtnHPTOS2aoJOqdXPbDMK2I/PGPM=;
 b=ciPUGO5ecapUW/OXe9tI4ipbzG5n2ueqJoHZWFAluG1ri4GJCZZ3ufkwJ40NOtgZSFjt
 EC1BLKeShcCAVXKLtjZCSz2kYtbyx2neAIGmudHJW2u/ZzjU/ef/JkXff6Uqa4JskEPb
 BMN7fQpUnRE+XjmB3166mqShgYu9FT7YV2/874b07Ghs4qQTtxooroUUt8jAVAuh/ycY
 UsRmomWn4ZHHfuYsWNql8zr3CjWp/MCELYcYOnFi3rEIzZlllC8uYe4YlJ/yvPOyQ24Q
 mCdb52zDWA8wn1Caimm5ZiUippbIBi9qIpjeUlgCT79yZnjMzsJGlFBPaaOFOcxOZwnV 2g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32s3c98gae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2020 04:08:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 Aug
 2020 04:08:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 7 Aug 2020 04:08:09 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E11D73F703F;
        Fri,  7 Aug 2020 04:08:08 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 077B88Cr020016;
        Fri, 7 Aug 2020 04:08:08 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 077B88Tr020015;
        Fri, 7 Aug 2020 04:08:08 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 2/7] qedf: check the validity of rjt frame before processing.
Date:   Fri, 7 Aug 2020 04:06:51 -0700
Message-ID: <20200807110656.19965-3-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200807110656.19965-1-jhasan@marvell.com>
References: <20200807110656.19965-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_06:2020-08-06,2020-08-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

This is reported by Klockwork.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Change-Id: I22a440fc4834bca858570dff8a3e41933121f831
---
 drivers/scsi/qedf/qedf_els.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index 542ba94..ab4b1a9 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -883,6 +883,11 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
 	opcode = fc_frame_payload_op(fp);
 	if (opcode == ELS_LS_RJT) {
 		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
+		if (!rjt) {
+			QEDF_ERR(&qedf->dbg_ctx, "payload get failed");
+			goto out_free_frame;
+		}
+
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS,
 		    "Received LS_RJT for REC: er_reason=0x%x, "
 		    "er_explan=0x%x.\n", rjt->er_reason, rjt->er_explan);
-- 
1.8.3.1

