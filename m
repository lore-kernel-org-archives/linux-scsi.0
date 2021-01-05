Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC81C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 06:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54D51229C4
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 06:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbhAEGHI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 01:07:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56632 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728176AbhAEGHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 01:07:08 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10566J9s017252
        for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2021 22:06:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=SVCamUmyuMJXs8DGP9uuPh/p+GCCMnhDEIaJ+ar1g1o=;
 b=VhZlwb+DpJRpszz7UwG0Xfhnp4iUpWpRuN9L0lJcC2u9hnb0eYgUvSju/b23/IXk7U/0
 x6YOhlmjbdoEtsyGVP/f6khyEkSsCvyFNnj680xd8YoiuvvexsVvKWB4+JaLCkjZSIzd
 1sIxKTw7nJ5P8kw0RklfMszNPi6Jr0U86qNyAXbpq3T2eE2hhdDzTPZ6T0EzZKSZTwsx
 L+ICkWj0jud8lELDhhk0BStsBbsf3kv6j2iFelK2zaa9JGlmSYRJZXQmotKT7VNLUnMv
 uXOQFI20140DbhGUkDDFhnJR2WxNtgAnevpG3u3JNrQkXJegekTClu97/hy0DKZaalb3 tg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ts7rncj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 22:06:27 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 4 Jan
 2021 22:06:25 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 4 Jan
 2021 22:06:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 4 Jan 2021 22:06:24 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A14BB3F703F;
        Mon,  4 Jan 2021 22:06:24 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 10566OxH020343;
        Mon, 4 Jan 2021 22:06:24 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 10566OWH020342;
        Mon, 4 Jan 2021 22:06:24 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 6/7] qla2xxx: Enable NVME CONF (BIT_7) when enabling SLER
Date:   Mon, 4 Jan 2021 22:03:34 -0800
Message-ID: <20210105060335.20267-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210105060335.20267-1-njavali@marvell.com>
References: <20210105060335.20267-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_01:2021-01-04,2021-01-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Enable NVME confirmation bit in PRLI.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index e27359b294d3..8b41cbaf8535 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2378,6 +2378,8 @@ qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 			logio->io_parameter[0] =
 				cpu_to_le32(NVME_PRLI_SP_FIRST_BURST);
 		if (sp->vha->flags.nvme2_enabled) {
+			/* Set service parameter BIT_7 for NVME CONF support */
+			logio->io_parameter[0] |= NVME_PRLI_SP_CONF;
 			/* Set service parameter BIT_8 for SLER support */
 			logio->io_parameter[0] |=
 				cpu_to_le32(NVME_PRLI_SP_SLER);
-- 
2.19.0.rc0

