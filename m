Return-Path: <SRS0=m3i9=XZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9513C4360C
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Sep 2019 09:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A897921BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Sep 2019 09:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbfI3Jnk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 05:43:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3189 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727884AbfI3Jnk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Sep 2019 05:43:40 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 92904F81AE160CBAF173;
        Mon, 30 Sep 2019 17:43:38 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 17:43:32 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <anil.gurumurthy@qlogic.com>, <sudarsana.kalluru@qlogic.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] bfa: Make restart_bfa static
Date:   Mon, 30 Sep 2019 17:43:27 +0800
Message-ID: <20190930094327.46836-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix sparse warning:

drivers/scsi/bfa/bfad.c:1491:1: warning:
 symbol 'restart_bfa' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/bfa/bfad.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 2f9213b..eb0c763 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1487,8 +1487,7 @@ bfad_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 	return ret;
 }
 
-int
-restart_bfa(struct bfad_s *bfad)
+static int restart_bfa(struct bfad_s *bfad)
 {
 	unsigned long flags;
 	struct pci_dev *pdev = bfad->pcidev;
-- 
2.7.4


