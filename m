Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16282C433E5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 09:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED12C20717
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 09:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731173AbgGVJGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 05:06:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51982 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726870AbgGVJGC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jul 2020 05:06:02 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DA87E38B4DC8F5CDD7E1;
        Wed, 22 Jul 2020 17:05:59 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Wed, 22 Jul 2020
 17:05:52 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <john.garry@huawei.com>, <yanaijie@huawei.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH v1 1/2] {topost} scsi: libsas: delete postreset at sas_sata_ops
Date:   Wed, 22 Jul 2020 17:04:02 +0800
Message-ID: <1595408643-63011-2-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595408643-63011-1-git-send-email-luojiaxing@huawei.com>
References: <1595408643-63011-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We fill postreset with ata_std_postreset() at sas_sata_ops before, but we
found out that ata_std_postreset() call sata_scr_read()/sata_scr_write()
which need to access SCR register. Actually we don't own these kind of
register, so sata_scr_read()/sata_scr_write always return -EOPNOTSUPP.

We drop ata_std_postreset() at sas_sata_ops.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_ata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 5d716d3..a7d16d2 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -510,7 +510,6 @@ void sas_ata_end_eh(struct ata_port *ap)
 static struct ata_port_operations sas_sata_ops = {
 	.prereset		= ata_std_prereset,
 	.hardreset		= sas_ata_hard_reset,
-	.postreset		= ata_std_postreset,
 	.error_handler		= ata_std_error_handler,
 	.post_internal_cmd	= sas_ata_post_internal,
 	.qc_defer               = ata_std_qc_defer,
-- 
2.7.4

