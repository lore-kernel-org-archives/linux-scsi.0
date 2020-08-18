Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDDCC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 11:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5DFF206DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 11:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHRLnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 07:43:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57928 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbgHRLnA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 07:43:00 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0501C79FEDFC11880153;
        Tue, 18 Aug 2020 19:42:58 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 18 Aug 2020
 19:42:51 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] scsi: libfc: Fix passing zero to 'PTR_ERR' warning
Date:   Tue, 18 Aug 2020 19:42:35 +0800
Message-ID: <20200818114235.51052-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

drivers/scsi/libfc/fc_disc.c:304
 fc_disc_error() warn: passing zero to 'PTR_ERR'

fc_disc_error() expect a ERR_PTR pointer, so pass
ERR_PTR(err) to fix this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/libfc/fc_disc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index d8cbc9c0e766..1077fcff4d50 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -343,6 +343,7 @@ static void fc_disc_gpn_ft_req(struct fc_disc *disc)
 {
 	struct fc_frame *fp;
 	struct fc_lport *lport = fc_disc_lport(disc);
+	int err;
 
 	lockdep_assert_held(&disc->disc_mutex);
 
@@ -356,8 +357,10 @@ static void fc_disc_gpn_ft_req(struct fc_disc *disc)
 	fp = fc_frame_alloc(lport,
 			    sizeof(struct fc_ct_hdr) +
 			    sizeof(struct fc_ns_gid_ft));
-	if (!fp)
+	if (!fp) {
+		err = -ENOMEM;
 		goto err;
+	}
 
 	if (lport->tt.elsct_send(lport, 0, fp,
 				 FC_NS_GPN_FT,
@@ -365,7 +368,7 @@ static void fc_disc_gpn_ft_req(struct fc_disc *disc)
 				 disc, 3 * lport->r_a_tov))
 		return;
 err:
-	fc_disc_error(disc, NULL);
+	fc_disc_error(disc, ERR_PTR(err));
 }
 
 /**
-- 
2.17.1


