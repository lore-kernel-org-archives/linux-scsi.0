Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB816C49EAD
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 09:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF1002190F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 09:41:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="V5nT74Sd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbfKEJlG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 04:41:06 -0500
Received: from mail-m975.mail.163.com ([123.126.97.5]:46446 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730666AbfKEJlG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 04:41:06 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Nov 2019 04:41:04 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=xxMGlcw5GbZw4GQ6BF
        lQ+/IDcAWTKfDv489Cws362Ws=; b=V5nT74Sdkbbfu35zM5y22MwUZonPnvEjTY
        AbsjN/52kL6EePx5MC1uIvUYrSi5CpBNZtwTSr2nMcovs0ztUkdjcbflvmE7ozLF
        Eb94jC2suqOSQXlCrRXZ26ovCaXr59HFWcjLSZzTcBF+hpUMi1ze/1cV75mBy5Ci
        khjEkJvFs=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp5 (Coremail) with SMTP id HdxpCgDXn9AbQMFdapjCJw--.278S3;
        Tue, 05 Nov 2019 17:25:51 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     QLogic-Storage-Upstream@qlogic.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] SCSI: qla4xxx: fix double free bug
Date:   Tue,  5 Nov 2019 17:25:27 +0800
Message-Id: <1572945927-27796-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: HdxpCgDXn9AbQMFdapjCJw--.278S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFW8Cw18CF45Aw15Ary3twb_yoWfCFbE9w
        s29r97WrnF9rn5Xw17XrZ7Jaya9rn5ZF4v9rnYv34fAr93uwnrAr17ZFW3Z398Ka13ZF45
        Cw1DXryFvr45GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbZNVPUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiNh9kclWBhJ17PgAAs3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The variable init_fw_cb is released twice, resulting in a double free
bug. The call to the function dma_free_coherent() before goto is removed
to get rid of potential double free.

Fixes: 2a49a78ed3c ("[SCSI] qla4xxx: added IPv6 support.")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index dac9a7013208..02636b4785c5 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -640,9 +640,6 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 
 	if (qla4xxx_get_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma) !=
 	    QLA_SUCCESS) {
-		dma_free_coherent(&ha->pdev->dev,
-				  sizeof(struct addr_ctrl_blk),
-				  init_fw_cb, init_fw_cb_dma);
 		goto exit_init_fw_cb;
 	}
 
-- 
2.7.4

