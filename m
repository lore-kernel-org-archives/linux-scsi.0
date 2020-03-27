Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F47C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 06:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C882A20714
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 06:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="e3we/JDF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgC0GCO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 02:02:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31992 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgC0GCO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 02:02:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R60YiH020330
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 23:02:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=bCsK1FQ2xIZQ7l7wb2MlCNuz8qzASUL7nMa79fq/MGo=;
 b=e3we/JDFkBOzPz38kjsarETUTVA7TCWAUNug7+PzF9tP3q1gxhcLEHzfRDKU1viVj3zj
 64dffPTKv75NHE2MWOwk6Z7YzE7L8uYu8C2DxhBq/19+WwG9uak3i4rO4BnpCXJ3TvQS
 gmP/uG8Dg2yLC8jJ/ILU9ahKaRbCXUuUNv0WKzqzsR21Cb0CneFaRdwL3hMa/9W+OvqD
 GVXYJBXTclcvmQvOSwW+U617ZA7EBdZb/fg5oKGivFHSO5LpFxmFgyx5PdfmvCfO3FJv
 tIb4Hmci81H/OdFlDyDiWE1xifhSPY9qF1TUlPDc/UL0BmCN+8znaW/UEPIVlZchh/T1 fQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9p1f1g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 23:02:13 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 23:02:11 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 23:02:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id ECFB73F703F;
        Thu, 26 Mar 2020 23:02:11 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02R62BFJ017143;
        Thu, 26 Mar 2020 23:02:11 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02R62BOo017142;
        Thu, 26 Mar 2020 23:02:11 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>
Subject: [PATCH 1/2] libfc: If PRLI rejected, move rport to PLOGI state.
Date:   Thu, 26 Mar 2020 23:02:07 -0700
Message-ID: <20200327060208.17104-2-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200327060208.17104-1-skashyap@marvell.com>
References: <20200327060208.17104-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_14:2020-03-26,2020-03-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

-If PRLI reject code indicates "rejected status",
   move rport state machine back to PLOGI state.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/libfc/fc_rport.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index da6e97d..6bb8917 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1208,9 +1208,15 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
 		if (!rjt)
 			FC_RPORT_DBG(rdata, "PRLI bad response\n");
-		else
+		else {
 			FC_RPORT_DBG(rdata, "PRLI ELS rejected, reason %x expl %x\n",
 				     rjt->er_reason, rjt->er_explan);
+			if (rjt->er_reason == ELS_RJT_UNAB &&
+			    rjt->er_explan == ELS_EXPL_PLOGI_REQD) {
+				fc_rport_enter_plogi(rdata);
+				goto out;
+			}
+		}
 		fc_rport_error_retry(rdata, FC_EX_ELS_RJT);
 	}
 
-- 
1.8.3.1

