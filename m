Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD025C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Mar 2021 02:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 975EA64F48
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Mar 2021 02:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhCMClY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 21:41:24 -0500
Received: from mail-m17635.qiye.163.com ([59.111.176.35]:41842 "EHLO
        mail-m17635.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhCMClY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 21:41:24 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by mail-m17635.qiye.163.com (Hmail) with ESMTPA id AAB3D400105;
        Sat, 13 Mar 2021 10:41:21 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] scsi: qla2xxx: use dma_pool_zalloc instead
Date:   Sat, 13 Mar 2021 10:41:15 +0800
Message-Id: <1615603275-14303-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZHR9JTRkfH0pIGEoZVkpNSk5NS0hJQ0lLSktVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hNSlVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OC46EAw4Tz8RTFEDAklIKlE1
        DwEKCwlVSlVKTUpOTUtISUNJSE1PVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFKQklCNwY+
X-HM-Tid: 0a782975b00ad991kuwsaab3d400105
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

use dma_pool_zalloc instead of dma_pool_alloc and memset

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0743925..ac5e954
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4238,11 +4238,10 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 
 	/* Get consistent memory allocated for Special Features-CB. */
 	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-		ha->sf_init_cb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+		ha->sf_init_cb = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL,
 						&ha->sf_init_cb_dma);
 		if (!ha->sf_init_cb)
 			goto fail_sf_init_cb;
-		memset(ha->sf_init_cb, 0, sizeof(struct init_sf_cb));
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0199,
 			   "sf_init_cb=%p.\n", ha->sf_init_cb);
 	}
-- 
2.7.4

