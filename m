Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3ECC2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 06:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05D132072A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 06:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="COX4pMpC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgDHGn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 02:43:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40870 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbgDHGn7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 02:43:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0386emwf025182;
        Tue, 7 Apr 2020 23:43:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=7svR/YTSPxP3A/E2SxL95L7h5JARrcSytHzq0dP8vOE=;
 b=COX4pMpCnZJ0Q2JvkU0uf1A/DHh0V5cMlPRzVOyFqRPCtqWoUAOOlDYdySgoccQggb4n
 J3XKq+lynhkne5uujmkPO4LMKUrg3Z1go+nnbMuVitiL3zc2INq9KXvR+nv9lwCpR3KW
 2nCJhVrW5mIEXmMSSMLzbmYC4V5ODhl+K0QTNoDUVMcGyXnE1W9TiBT31O0CM0FU4LED
 I5WGp0HVhZO219t+I/uyPsovXpTjBT/+AXk2xDZPu1ePVL0niEYSjBVXKaRql6S4Jh7n
 sCgSUnbxyatUDLFu2lvOsdg43MrHazIK+HQkUmjkMlT2/hV9HTYM9iNE7EXmKHhBmTga KQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3091me1ykv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 23:43:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 7 Apr
 2020 23:43:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 7 Apr 2020 23:43:52 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 74AAC3F703F;
        Tue,  7 Apr 2020 23:43:52 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0386hqCZ019444;
        Tue, 7 Apr 2020 23:43:52 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0386hqf2019435;
        Tue, 7 Apr 2020 23:43:52 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 6/6] qedi: Fix termination timeouts in session logout
Date:   Tue, 7 Apr 2020 23:43:32 -0700
Message-ID: <20200408064332.19377-7-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200408064332.19377-1-mrangankar@marvell.com>
References: <20200408064332.19377-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

The destroy conn ramrod timedout while session logouts.
Fix the wait delay for graceful vs abortive termination
as per the FW requirements.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 80c724b..b867a14 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1065,6 +1065,9 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		break;
 	}
 
+	if (!abrt_conn)
+		wait_delay += qedi->pf_params.iscsi_pf_params.two_msl_timer;
+
 	qedi_ep->state = EP_STATE_DISCONN_START;
 	ret = qedi_ops->destroy_conn(qedi->cdev, qedi_ep->handle, abrt_conn);
 	if (ret) {
-- 
1.8.3.1

