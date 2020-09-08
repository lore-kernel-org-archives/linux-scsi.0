Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183CFC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 09:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7BE721D7B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 09:58:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="X1Ljs9YI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgIHJ6S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 05:58:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11382 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728973AbgIHJ6R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 05:58:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0889pkPU008557;
        Tue, 8 Sep 2020 02:58:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=1FIfgwwoNtRaRjziQSLwLNXfEdybeX9/ml/J471buis=;
 b=X1Ljs9YIDd3Df+FO38d6T96Qv+6hCbRbN1tTm7i3dO+iLuQ9VJsI5/Sy1r5iYNYGL2/y
 uTXks/TuIFCZaFQtZXmQQDkH3TcdPmS342/z3sIVf/9bkKDua3F21gJwwvNpClKrDg4k
 OFSlXMsIr4Lmz1bPT3NbGksjpHRxfRd8YUexx798I2UWQ4vKekH7EqlNZ3TNbej4pOgq
 aj4o4awwIMqzoRixbJFQYMFMQfKFRNQDFxJ/2IHPYFidQCun9mUkax4T7KB39YaWuSQ/
 CfgqWCIeipb2vXR6MHMZUfDRBoFfUxTm4WcjZHi4VXlr+uQkiYmW3v8hzTtlGmC/khou uw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvr1tt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 02:58:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Sep
 2020 02:58:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Sep
 2020 02:58:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Sep 2020 02:58:10 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 208FA3F703F;
        Tue,  8 Sep 2020 02:58:10 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0889w9Dm026880;
        Tue, 8 Sep 2020 02:58:09 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0889w91j026871;
        Tue, 8 Sep 2020 02:58:09 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 2/8] qedi: Skip f/w connection termination for pci shutdown handler.
Date:   Tue, 8 Sep 2020 02:56:51 -0700
Message-ID: <20200908095657.26821-3-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200908095657.26821-1-mrangankar@marvell.com>
References: <20200908095657.26821-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_05:2020-09-08,2020-09-08 signatures=0
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

