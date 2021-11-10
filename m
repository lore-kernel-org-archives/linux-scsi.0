Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AA5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 21:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BFAC61250
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 21:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhKJVO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 16:14:28 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:49547 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbhKJVO1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 16:14:27 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id kusZmABmuHQrlkusZmT8fA; Wed, 10 Nov 2021 22:11:36 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 10 Nov 2021 22:11:36 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        gmalavali@marvell.com, hmadhani@marvell.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: qla2xxx: Fix memory leaks in the error handling path of 'qla2x00_mem_alloc()'
Date:   Wed, 10 Nov 2021 22:11:34 +0100
Message-Id: <cc2fe0148944cfac5e58339bf98e76fd5c3a54b8.1636578573.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In case of memory allocation failure, we should release many things and
should not return directly.

The tricky part here, is that some (kzalloc + dma_pool_alloc) resources
are allocated and stored in 'unusable' and a 'good' list.
The 'good' list is then freed and only the 'unusable' list remains
allocated.
So, only this 'unusable' list is then freed in the error handling path of
the function.

So, instead of adding even more code in this already huge function, just
'continue' (as already done if dma_pool_alloc() fails) instead of
returning directly.

After the 'for' loop, we will then branch to the correct place of the
error handling path when another memory allocation will (likely) fail
afterward.

Fixes: 50b812755e97 ("scsi: qla2xxx: Fix DMA error when the DIF sg buffer crosses 4GB boundary")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Certainly not the best solution, but look 'safe' to me.
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index abcd30917263..0722dd618b99 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4151,7 +4151,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 					ql_dbg_pci(ql_dbg_init, ha->pdev,
 					    0xe0ee, "%s: failed alloc dsd\n",
 					    __func__);
-					return -ENOMEM;
+					continue;
 				}
 				ha->dif_bundle_kallocs++;
 
-- 
2.30.2

