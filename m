Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1DFC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 17:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D1920866
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 17:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgLHR32 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 12:29:28 -0500
Received: from mail-m975.mail.163.com ([123.126.97.5]:50586 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgLHR32 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 12:29:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=mhb1hiwoFlD+Yupftc
        Lzct0BXhlsBvQWytCvH/Rlhcw=; b=bimc8M89VAlQpHA9a56AzhVBteAX+EE7xj
        vEhGSHP1e9m4fDpg1H+FNEJlJ/KE/5iZBWJ6wkhfQXXVBEbHMHEyi6G5ODhbm+AO
        fK297+qSMRgxsyoq0pXANGBAMkTEqbqBB+Tlq0kjuM1NNFu5McZMJw9LlIivtm8b
        fqwCGmoXU=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp5 (Coremail) with SMTP id HdxpCgB3k2NtrM9fceG3EA--.2717S4;
        Wed, 09 Dec 2020 00:40:19 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] hisi_sas: Fix possible buffer overflows in prep_ssp_v3_hw
Date:   Wed,  9 Dec 2020 00:40:11 +0800
Message-Id: <20201208164011.13866-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: HdxpCgB3k2NtrM9fceG3EA--.2717S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF4xZF4rAw4fXF4xJry7ZFb_yoWkuFc_Gw
        4FgrnxWr40kF4vkan3Cr43X3s0yw48Jr9Y9FnIv3y7AryjyFsFqFnrWFs8Zry7Gr43Aw18
        G3W5XryFkF4xAjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUOVyDUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbiZRD0MF8ZLc7dRwABsP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

prep_ssp_v3_hw() calls memcpy() without checking the
destination size may trigger a buffer overflower, which a
local user could use to cause denial of service or the
execution of arbitrary code.
Fix it by putting the length check before calling memcpy().

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 7133ca859..2664c36d3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1267,7 +1267,8 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 	memcpy(buf_cmd, &task->ssp_task.LUN, 8);
 	if (!tmf) {
 		buf_cmd[9] = ssp_task->task_attr | (ssp_task->task_prio << 3);
-		memcpy(buf_cmd + 12, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
+		memcpy(buf_cmd + 12, scsi_cmnd->cmnd,
+		       min_t(unsigned short, scsi_cmnd->cmd_len, strlen(buf_cmd)-12));
 	} else {
 		buf_cmd[10] = tmf->tmf;
 		switch (tmf->tmf) {
-- 
2.17.1

