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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D89C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 20:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 035FC23D1C
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 20:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbgLIUwg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 15:52:36 -0500
Received: from mail-m973.mail.163.com ([123.126.97.3]:40624 "EHLO
        mail-m973.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgLIUwg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 15:52:36 -0500
X-Greylist: delayed 23315 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2020 15:52:36 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=gQ5estX4aQOus4o3RQ
        hPJH0633LIum7VHgBpqNT4W2E=; b=I3Y2w6F3Fet1/easBiGugG9pw30b5mBVc7
        Wxsb9fU6XrZO9vM9akdqoH9a+4IUhKZ0xVg3dNMxw0gqEERcMjEO317oXTdNsMgM
        wh0ZcckQYCkjDyFLQ98MClTd7ypy5919tDcUHEXWjWedbhtCd+j5ernkd5MRkGxV
        p5vKH4HpM=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp3 (Coremail) with SMTP id G9xpCgA3nqOWx9BfiyalOg--.64718S4;
        Wed, 09 Dec 2020 20:48:26 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] hisi_sas: Fix possible buffer overflows in prep_ssp_v3_hw
Date:   Wed,  9 Dec 2020 20:48:18 +0800
Message-Id: <20201209124818.25122-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: G9xpCgA3nqOWx9BfiyalOg--.64718S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zr13Ww4fCr1kXFy5uryfZwb_yoW8Gw4fpr
        W8uay2vrWkJw48Kan2gF4xZr90qa1kGr1Fgayj9a4rA3W5Ja4xCa42krW2qay5Cw47ZF1U
        WrsrJryUWa1kGrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Ub4SrUUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/xtbBRRr1MFPAIxgz8wAAsy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

prep_ssp_v3_hw() calls memcpy() without checking the destination
size may trigger a buffer overflower.

buf_cmd should be a ssp_tmf_iu struct through the analysis of
the command below:
buf_cmd = hisi_sas_cmd_hdr_addr_mem(slot) +
        sizeof(struct ssp_frame_hdr);

Then buf_cmd + 12 should point to tag, so the length parameter
of memcpy() should not exceed sizeof(__be16)+sizeof(u8)*14):
struct ssp_tmf_iu {
    u8     lun[8];
    u16    _r_a;
    u8     tmf;
    u8     _r_b;
    __be16 tag;
    u8     _r_c[14];
} __attribute__ ((packed));

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 7133ca859..d02831c17 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1267,7 +1267,9 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 	memcpy(buf_cmd, &task->ssp_task.LUN, 8);
 	if (!tmf) {
 		buf_cmd[9] = ssp_task->task_attr | (ssp_task->task_prio << 3);
-		memcpy(buf_cmd + 12, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
+		memcpy(buf_cmd + 12, scsi_cmnd->cmnd,
+		       min_t(unsigned short, scsi_cmnd->cmd_len,
+			     sizeof(__be16) + sizeof(u8) * 14));
 	} else {
 		buf_cmd[10] = tmf->tmf;
 		switch (tmf->tmf) {
-- 
2.17.1

