Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45475C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 07:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjERH7M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 03:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjERH7F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 03:59:05 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6543226A2
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:59:02 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34I7Ggd0003425
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:59:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=502PJnjz9uwM4sa04gsCwmAxUMVS7kt70KMIlpfpMls=;
 b=Ua8D1Kb8EPK6zb3QBy6gMA+PMAk+ktJk0bybZq9+xHmi2zQpL9NAA433efxSXpiiid7x
 IkEC6QyESqrV5iP2GZsMw3s+2IWHetbfqE7qZpqoheIPK/QIzT/MhKrAxWHPM3Yc4qXU
 EDong/3rOqxWCPf5rC0oRQAZS9QmW4WaSbONur0St8sWQFwg+JALQY/NuYxSaagFKIfg
 8Yt372wWBxm5dit+MemmsBG/XsXslYCq4CMwivJauRDaq9NwRDFWqIzwfqKfkOjyuAjn
 6X6QCl0EfpxQFdD7D0wjA0T+Z1Yi/Nqu4rdMl1wq5DT9UtdPtb8gZyLqJYCVBtTx9g+c fA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qmyexb9gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:59:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 18 May
 2023 00:58:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 18 May 2023 00:58:58 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 04D9E3F7065;
        Thu, 18 May 2023 00:58:56 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 5/8] qla2xxx: klocwork - Fix buffer overrun
Date:   Thu, 18 May 2023 13:28:38 +0530
Message-ID: <20230518075841.40363-6-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230518075841.40363-1-njavali@marvell.com>
References: <20230518075841.40363-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: mb8VHHUCwax0taNB39l3CxJ_ND6DqF1D
X-Proofpoint-ORIG-GUID: mb8VHHUCwax0taNB39l3CxJ_ND6DqF1D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_05,2023-05-17_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Klocwork warning: Buffer Overflow - Array Index Out of Bounds

Driver uses fc_els_flogi to calculate size of buffer.
The actual buffer is nested inside of fc_els_flogi
which is smaller.

Replace structure name to allow proper size calculation.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0df6eae7324e..b0225f6f3221 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5549,7 +5549,7 @@ static void qla_get_login_template(scsi_qla_host_t *vha)
 	__be32 *q;
 
 	memset(ha->init_cb, 0, ha->init_cb_size);
-	sz = min_t(int, sizeof(struct fc_els_flogi), ha->init_cb_size);
+	sz = min_t(int, sizeof(struct fc_els_csp), ha->init_cb_size);
 	rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
 					    ha->init_cb, sz);
 	if (rval != QLA_SUCCESS) {
-- 
2.23.1

