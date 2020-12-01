Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839C6C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 229B7206E3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YUCbUeL4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgLAI3B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:29:01 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53674 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726311AbgLAI3B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 03:29:01 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B18L16d027368
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 00:28:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=wywfcasSSSJGRlMSJAHNtIVTekPQsfDSUfWIxDis7zo=;
 b=YUCbUeL4mnXat4jLZ8qMiqs4Ce6WhQSVRymLckdjJZsgG6DpIgb3BYQzhsux4y8bCM3v
 l0kk2zLS9KcGexJEbaGfHsxI6ZectpNOU0gmwN4ENDWJkRHJdJ1x0XHIPSbZ/VU+Ehjf
 88OL1wpUOozxCL8GQ5w7GhENdkAvWxrWWETJH4syjo28wzBzOLmado1FyI0cdFiT9An8
 2WJGTASsOiM5/k72uO4rEnayD4p/KU/uIZHDxefs6z0H3X8uDqP4bTf6GLFdUBnbUyA3
 8ibpn0+e9f3ZXOIYWX4QIxbf/V9RrihJz8AaUDW+mEdzc6C5hUJD/cyuB+eEFX7KCZ3N Uw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 353mssfkk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 00:28:21 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:28:20 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:28:19 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 00:28:19 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3CEC83F703F;
        Tue,  1 Dec 2020 00:28:19 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B18SJNA024205;
        Tue, 1 Dec 2020 00:28:19 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B18SJC2024204;
        Tue, 1 Dec 2020 00:28:19 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 01/15] scsi: qla2xxx: Return EBUSY on fcport deletion
Date:   Tue, 1 Dec 2020 00:27:16 -0800
Message-ID: <20201201082730.24158-2-njavali@marvell.com>
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

From: Daniel Wagner <dwagner@suse.de>

When the fcport is about to be deleted we should return EBUSY instead of
ENODEV. Only for EBUSY will the request be requeued in a multipath setup.

Also return EBUSY when the firmware has not yet started to avoid dropping
the request.

Link: https://lore.kernel.org/r/20201014073048.36219-1-dwagner@suse.de
Reviewed-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 1f9005125313..b7a1dc24db38 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -554,10 +554,12 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 
 	fcport = qla_rport->fcport;
 
-	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
-	    (fcport && fcport->deleted))
+	if (!qpair || !fcport)
 		return -ENODEV;
 
+	if (!qpair->fw_started || fcport->deleted)
+		return -EBUSY;
+
 	vha = fcport->vha;
 
 	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
-- 
2.19.0.rc0

