Return-Path: <SRS0=GQ+9=BM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8727C433E3
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Aug 2020 11:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76EC207DF
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Aug 2020 11:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHBLH1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Aug 2020 07:07:27 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:60691 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgHBLH0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2020 07:07:26 -0400
Received: from localhost.localdomain ([93.22.148.198])
        by mwinf5d84 with ME
        id Ab7P230064H42jh03b7PEJ; Sun, 02 Aug 2020 13:07:24 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 02 Aug 2020 13:07:24 +0200
X-ME-IP: 93.22.148.198
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     QLogic-Storage-Upstream@qlogic.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, vikas.chaudhary@qlogic.com,
        lalit.chandivade@qlogic.com, michaelc@cs.wisc.edu,
        JBottomley@Parallels.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: qla2xxx: Fix the size used in a 'dma_free_coherent()' call
Date:   Sun,  2 Aug 2020 13:07:21 +0200
Message-Id: <20200802110721.677707-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update the size used in 'dma_free_coherent()' in order to match the one
used in the corresponding 'dma_alloc_coherent()'.

While at it, remove a memset after a call to 'dma_alloc_coherent()'.
This is useless since
commit 518a2f1925c3 ("dma-mapping: zero memory returned from dma_alloc_*")

Fixes: 4161cee52df8 ("[SCSI] qla4xxx: Add host statistics support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The memset has been added in the same commit, so I think it is ok to
remove it in the same path.
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 73883435ab58..a43d7229f9a1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4933,8 +4933,6 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
-	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
-
 	/* List of Purex ELS */
 	cmd_opcode[0] = ELS_FPIN;
 	cmd_opcode[1] = ELS_RDP;
@@ -4966,7 +4964,7 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 		    "Done %s.\n", __func__);
 	}
 
-	dma_free_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
+	dma_free_coherent(&ha->pdev->dev, ELS_CMD_MAP_SIZE,
 	   els_cmd_map, els_cmd_map_dma);
 
 	return rval;
-- 
2.25.1

