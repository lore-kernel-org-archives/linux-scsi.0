Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EBFC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F4DA218AC
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:25:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IAa7wKAP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgIHFZd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 01:25:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24502 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726387AbgIHFZb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 01:25:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0885Ov1f014198;
        Mon, 7 Sep 2020 22:25:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=1FIfgwwoNtRaRjziQSLwLNXfEdybeX9/ml/J471buis=;
 b=IAa7wKAPbHjUm1BdOKp7xTOR7XOYiVV/4f1+7tzEXxNDHIJVYYeaTqS5zthYI2Gj3jAW
 YixaM7MzXDSoYA4xWqnprebE3pH3Gr4hDstW6RXsGNhn57pJ3Gm6MuXyQppSnddsOxFh
 Hg45//TqbrcWX5ymNEVE9aJNbC6XRLQDgjEWzhBoECZnd8O+BbBSVWhYIL+h9XUEXwnA
 i/IylOxAXpDmLbEUsZD5Eq4Hj6k2C72K1Xm92EzKl52WjiUcakq7mJRCcKX5k9arRp1D
 FcMvmflNt7FsQt0TsKhn7d1hxvOzP2FXTdaVavS78mI2ITHyKybbehld7CvSEevu56/m rw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvr1002-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 22:25:26 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 22:25:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 22:25:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 22:25:25 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CE9C63F703F;
        Mon,  7 Sep 2020 22:25:24 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0885PO9V021969;
        Mon, 7 Sep 2020 22:25:24 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0885POk3021968;
        Mon, 7 Sep 2020 22:25:24 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 2/8] qedi: Skip f/w connection termination for pci shutdown handler.
Date:   Mon, 7 Sep 2020 22:24:06 -0700
Message-ID: <20200908052412.21917-3-mrangankar@marvell.com>
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

In boot from san scenario when qedi pci shutdown handler is
called with active iSCSI sessions, sometimes target takes
too long time to respond to f/w connection termination request.
Instead skip sending termination ramrod and progress with
unload path.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index c14ac7882afa..f815845fc568 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1069,6 +1069,10 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		wait_delay += qedi->pf_params.iscsi_pf_params.two_msl_timer;
 
 	qedi_ep->state = EP_STATE_DISCONN_START;
+
+	if (test_bit(QEDI_IN_SHUTDOWN, &qedi->flags))
+		goto ep_release_conn;
+
 	ret = qedi_ops->destroy_conn(qedi->cdev, qedi_ep->handle, abrt_conn);
 	if (ret) {
 		QEDI_WARN(&qedi->dbg_ctx,
-- 
2.25.0

