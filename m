Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1515EC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 08:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC12E206F0
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 08:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgHaIME (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 04:12:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53978 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726244AbgHaIMD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Aug 2020 04:12:03 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0CCAA6890FC728C0B61D;
        Mon, 31 Aug 2020 16:12:02 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 31 Aug 2020
 16:11:55 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 2/4] scsi: fnic: remove set but not used variable in is_fnic_fip_flogi_reject()
Date:   Mon, 31 Aug 2020 16:11:24 +0800
Message-ID: <20200831081126.3251288-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831081126.3251288-1-yanaijie@huawei.com>
References: <20200831081126.3251288-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/scsi/fnic/fnic_fcs.c: In function ‘is_fnic_fip_flogi_reject’:
drivers/scsi/fnic/fnic_fcs.c:317:9: warning: variable ‘els_len’ set but
not used [-Wunused-but-set-variable]
  317 |  size_t els_len = 0;
      |         ^~~~~~~
drivers/scsi/fnic/fnic_fcs.c:312:21: warning: variable ‘els_dtype’ set
but not used [-Wunused-but-set-variable]
  312 |  enum fip_desc_type els_dtype = 0;
      |                     ^~~~~~~~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/fnic/fnic_fcs.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 673887e383cc..894c0d28c534 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -309,12 +309,10 @@ static inline int is_fnic_fip_flogi_reject(struct fcoe_ctlr *fip,
 	struct fc_frame_header *fh = NULL;
 	struct fip_desc *desc;
 	struct fip_encaps *els;
-	enum fip_desc_type els_dtype = 0;
 	u16 op;
 	u8 els_op;
 	u8 sub;
 
-	size_t els_len = 0;
 	size_t rlen;
 	size_t dlen = 0;
 
@@ -346,10 +344,8 @@ static inline int is_fnic_fip_flogi_reject(struct fcoe_ctlr *fip,
 		if (dlen < sizeof(*els) + sizeof(*fh) + 1)
 			return 0;
 
-		els_len = dlen - sizeof(*els);
 		els = (struct fip_encaps *)desc;
 		fh = (struct fc_frame_header *)(els + 1);
-		els_dtype = desc->fip_dtype;
 
 		if (!fh)
 			return 0;
-- 
2.25.4

