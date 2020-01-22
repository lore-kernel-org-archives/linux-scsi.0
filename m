Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992C5C33CAF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 10:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B0F42467C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 10:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgAVKXQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:23:16 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10128 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727847AbgAVKXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jan 2020 05:23:16 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DA74A6B2DAB1D3C604B3;
        Wed, 22 Jan 2020 18:23:13 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 22 Jan 2020 18:23:07 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <hmadhani@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next] scsi: qla2xxx: use PTR_ERR_OR_ZERO() to simplify code
Date:   Wed, 22 Jan 2020 18:18:12 +0800
Message-ID: <20200122101812.94816-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PTR_ERR_OR_ZERO contains if(IS_ERR(...)) + PTR_ERR, just use 
PTR_ERR_OR_ZERO directly.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index abe7f79..719d53d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1462,10 +1462,8 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 				       sizeof(struct qla_tgt_cmd),
 				       TARGET_PROT_ALL, port_name,
 				       qlat_sess, tcm_qla2xxx_session_cb);
-	if (IS_ERR(se_sess))
-		return PTR_ERR(se_sess);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(se_sess);
 }
 
 static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
-- 
2.7.4

