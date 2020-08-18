Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA03C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D60F206B5
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:35:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cQXzpJ6P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHRMfn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:35:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726651AbgHRMfm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:35:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICTLwa027326
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:35:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=1gvS9iUIHDY6SXtKj+y90AlTdRkfXQHbd6yBVYUu96o=;
 b=cQXzpJ6PTVi/y9CnN+iG3PKB2ikOUEesqSsq6gnyly677A0+u28RlyS4YMfy/r+v2wd7
 UoCy2dsYYJvq8PxdraSWJsIuEnkt2LTmEHGph1XM/QZhigbW3JcQ/h30xsgdiJ/p1zFc
 3+HzMo4XRA11nNLlBDNLjhVm1ziqeUWz4C0GVxDpfygzbI7PdKUJhD8B/Pu+KQMEXtYS
 vsm74Y3GNNnVzntpj1Q0O4pacdD0KGfvshFIYHin6DLZ1f6MpZ2o7m8FoKK/S3tuMxqd
 4OiZ/y9pZW9R+MCiFrHtI1KYo6DmWdMOwaAFgNrtf14ZyIISLMpOdpNdr+aEvklDHg/T LA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fhjeqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:35:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:35:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:35:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 05:35:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 68C523F703F;
        Tue, 18 Aug 2020 05:35:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07ICZejS020454;
        Tue, 18 Aug 2020 05:35:40 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07ICZep2020453;
        Tue, 18 Aug 2020 05:35:40 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 08/12] qla2xxx: Fix I/O errors during LIP reset tests
Date:   Tue, 18 Aug 2020 05:31:59 -0700
Message-ID: <20200818123203.20361-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200818123203.20361-1-njavali@marvell.com>
References: <20200818123203.20361-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

In .fcp_io(), returning ENODEV as soon as remote port delete has started
can cause I/O errors. Fix this by returning EBUSY until the remote port
delete finishes.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 1c742875817f..12906ee73cbd 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -548,6 +548,16 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 		return rval;
 
 	vha = fcport->vha;
+
+	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
+		return rval;
+
+	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
+		return -EBUSY;
+
+	if ((qpair && !qpair->fw_started) || fcport->deleted)
+		return -EBUSY;
+
 	/*
 	 * If we know the dev is going away while the transport is still sending
 	 * IO's return busy back to stall the IO Q.  This happens when the
-- 
2.19.0.rc0

