Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB232C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 09:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6392F2247F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 09:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgLWJHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 04:07:54 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33034 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728233AbgLWJHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Dec 2020 04:07:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BN90xfA011310
        for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2020 01:07:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=SVCamUmyuMJXs8DGP9uuPh/p+GCCMnhDEIaJ+ar1g1o=;
 b=NgnaYO6xO5Q7qI143MQvC5k0dj9ZyK0IgDiUTt1tu4efwD1VVdkB/pzu7i+tOjWgNJ60
 b2Bf/LAKNYFfoPoBYqzXAV/dnVz88mF4MT0j4BkWBbNBPDSU/22/AyQLZeyltgr99caX
 pbBeHR4Ewjlw0uZ/rb7LKui+QRjTDd4xsQZG/x5KlwNYZv6kUf7I4inC1ZgVQs7KLQbZ
 pwmXwZE7xISG6/vcCRPnd798P0xryrRkeGjdV1XfH31FcXsXvFJ0A5o0oZrrih++5rhF
 qKEfQ999xjw2H4HGnKkKT3MeWv0YdIChXOLYiB3yAyOaSKDDUnvbawKsG/dt41rAou9g BA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35k0hx5jve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2020 01:07:13 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 23 Dec
 2020 01:07:11 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Dec 2020 01:07:11 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6303E3F703F;
        Wed, 23 Dec 2020 01:07:11 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0BN97BFx016584;
        Wed, 23 Dec 2020 01:07:11 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0BN97Brw016583;
        Wed, 23 Dec 2020 01:07:11 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 6/7] qla2xxx: Enable NVME CONF (BIT_7) when enabling SLER
Date:   Wed, 23 Dec 2020 01:04:21 -0800
Message-ID: <20201223090422.16500-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201223090422.16500-1-njavali@marvell.com>
References: <20201223090422.16500-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-23_04:2020-12-21,2020-12-23 signatures=0
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

