Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF54DC433E1
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C23B32177B
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:13:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="h2vJMjtI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgHGLNl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 07:13:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43628 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728004AbgHGLJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 07:09:16 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077AoTUb009561
        for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2020 04:08:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=mKbdG4A0hvySNwGCtBg++ey3IZP5mgcf7HF0afXNbaU=;
 b=h2vJMjtIP/gKuiYNhbGrpPq6p53/KZDVo5wMhLo9EYT0F863+FcBvrFbS/E3sERMMu2+
 KFJqNKzZUdRJQb00blq62dVps+wICbYIMHg4YLwS1itXxlpFMDh3Hhhf9C4CMaGdTibF
 wDyVLIKh7LHDiZ2tnctCF2UWSPHswpUCJEmwIYBFCWaRwAeM07ozIsI5hRHp8iCtNafY
 0uynC4gJOMY27tQ+1KXw19205iatEr00YzCU4FIgDneJkvERMrPXG2oNLTOvCgZVvao8
 XXTLudHqjebwkD+EinTRnHxlUeboOWiMrwnNlX3o+reYH7/b4Sa+5Eq6CQELutH/+pYi Tg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32s3c98gbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2020 04:08:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 Aug
 2020 04:08:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 7 Aug 2020 04:08:33 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0E03A3F703F;
        Fri,  7 Aug 2020 04:08:33 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 077B8WKW020020;
        Fri, 7 Aug 2020 04:08:32 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 077B8WLO020019;
        Fri, 7 Aug 2020 04:08:32 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 3/7] qedf: Do not kill timeout work for original IO on RRQ completion.
Date:   Fri, 7 Aug 2020 04:06:52 -0700
Message-ID: <20200807110656.19965-4-jhasan@marvell.com>
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

 -The timer is already cancelled when abort get completed, hence
  no need of cancelling it again.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf_els.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index ab4b1a9..edd6702 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -185,10 +185,6 @@ static void qedf_rrq_compl(struct qedf_els_cb_arg *cb_arg)
 		goto out_free;
 	}
 
-	if (rrq_req->event != QEDF_IOREQ_EV_ELS_TMO &&
-	    rrq_req->event != QEDF_IOREQ_EV_ELS_ERR_DETECT)
-		cancel_delayed_work_sync(&orig_io_req->timeout_work);
-
 	refcount = kref_read(&orig_io_req->refcount);
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "rrq_compl: orig io = %p,"
 		   " orig xid = 0x%x, rrq_xid = 0x%x, refcount=%d\n",
-- 
1.8.3.1

