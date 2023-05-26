Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248DAC77B73
	for <linux-scsi@archiver.kernel.org>; Fri, 26 May 2023 15:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244214AbjEZP6g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 May 2023 11:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243698AbjEZP6f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2023 11:58:35 -0400
X-Greylist: delayed 554 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 May 2023 08:58:33 PDT
Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E36D10A
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 08:58:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685116156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3T1uOil3H6JZ0A20Wy7Xg4wFXp60Swnu6f66HFlzrXs=;
        b=j1zCirSxEiElqWRN5se32FpZD2r1znYeumfNWe68aAQSKGo2aA0fZze6T3+qXDyIwUCeR6
        VI0z8UrWqgpxX3ixM0TpEq0Fcqe4Vtt/bvezkSDzwntUyv8zcw2nDIBJut2M34KrztRJrV
        Zm180a3Bwt7sLIWx/LyNN/RvSs6ENlk=
From:   Jackie Liu <liu.yun@linux.dev>
To:     njavali@marvell.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: remove unnecessary NULL pointer check
Date:   Fri, 26 May 2023 23:49:05 +0800
Message-Id: <20230526154905.1419042-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

By the time we get here, fcport can't be NULL, because task_work is
can't be NULL, so this NULL check is not necessary, just cleanup.

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5258b07687a9..0ba089a753f2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -684,7 +684,7 @@ void qla24xx_delete_sess_fn(struct work_struct *work)
 	fc_port_t *fcport = container_of(work, struct fc_port, del_work);
 	struct qla_hw_data *ha = NULL;
 
-	if (!fcport || !fcport->vha || !fcport->vha->hw)
+	if (!fcport->vha || !fcport->vha->hw)
 		return;
 
 	ha = fcport->vha->hw;
-- 
2.25.1

