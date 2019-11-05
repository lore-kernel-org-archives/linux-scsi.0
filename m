Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7201BC5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 467C8206BA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FI1Mlbxj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbfKEPHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:07:14 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27934 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730939AbfKEPHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:07:13 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5ExrDP009715;
        Tue, 5 Nov 2019 07:07:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=VmsXVF/xIEV1oGVL9l1r1yF2kqr9GrynI/5S6DGFAYA=;
 b=FI1MlbxjV7Pfv6FO6p6vPnOl3BepPrWKXrvkOUk1hly/KEkWCEF0peZhuhbga1RvXZr0
 dblC21ggky0Buv6YR+p9fOfFWiPa8ycWjFPNYbYDnbB07fr4MTI1aOgbX+EoMePPkDna
 40zsYBkM5epuxbSPed82l/B3YP5Q998hjlOxt9e/gCB1cEuKcfA3sYpa5Z0315e2Kd5y
 m/qQzvx6AQ8QH4xWaeKNQetIiEhwqwa3TEgn2uIZPv9FZEh0U9FRReIZjQcvRcV8FX9C
 LU9b4lHGKzjfGLI7/t1/iPxHyOR7RHFb5hao/R+gfv0cDgtFuVOAIvkTL7JK8XXIwwVU 9A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n93cmg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 07:07:12 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 07:07:10 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 5 Nov 2019 07:07:10 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 17D873F7040;
        Tue,  5 Nov 2019 07:07:10 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA5F79Qu008151;
        Tue, 5 Nov 2019 07:07:09 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA5F79un008150;
        Tue, 5 Nov 2019 07:07:09 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 4/8] qla2xxx: Fix driver unload hang
Date:   Tue, 5 Nov 2019 07:06:53 -0800
Message-ID: <20191105150657.8092-5-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191105150657.8092-1-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_05:2019-11-05,2019-11-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

This patch fixes driver unload hang by removing msleep()

Fixes: d74595278f4ab ("scsi: qla2xxx: Add multiple queue pair functionality.")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bddb26baedd2..ff4528702b4e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9009,8 +9009,6 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
 	struct qla_hw_data *ha = qpair->hw;
 
 	qpair->delete_in_progress = 1;
-	while (atomic_read(&qpair->ref_count))
-		msleep(500);
 
 	ret = qla25xx_delete_req_que(vha, qpair->req);
 	if (ret != QLA_SUCCESS)
-- 
2.12.0

