Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C42C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 02:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E17561C4F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 02:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350652AbhKPCvc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 21:51:32 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:23460 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242592AbhKPCtH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 21:49:07 -0500
X-UUID: 9a027e8e361d429caf9c5402f373c751-20211116
X-UUID: 9a027e8e361d429caf9c5402f373c751-20211116
X-User: zhangyue1@kylinos.cn
Received: from localhost.localdomain [(118.26.139.139)] by nksmu.kylinos.cn
        (envelope-from <zhangyue1@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1200601199; Tue, 16 Nov 2021 10:54:51 +0800
From:   zhangyue <zhangyue1@kylinos.cn>
To:     qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fix the problem that the pointer "sp" is double free
Date:   Tue, 16 Nov 2021 10:45:58 +0800
Message-Id: <20211116024558.7647-1-zhangyue1@kylinos.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

in function qla24xx_sp_unmap, it is already called sp->free(sp), then
it`s not need to called sp->free(sp) after qla24xx_sp_unmap is called.

Signed-off-by: zhangyue <zhangyue1@kylinos.cn>
---
 drivers/scsi/qla2xxx/qla_gs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index c3195d4c25e5..a7198a1e23fb 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -4228,7 +4228,6 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 		if (rc) {
 			/* Cleanup here to prevent memory leak */
 			qla24xx_sp_unmap(vha, sp);
-			sp->free(sp);
 		}
 
 		spin_lock_irqsave(&vha->work_lock, flags);
-- 
2.30.0

