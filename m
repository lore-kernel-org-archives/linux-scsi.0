Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528A6C55191
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 02:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF0720700
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 02:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgDZCgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Apr 2020 22:36:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2903 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726087AbgDZCgl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Apr 2020 22:36:41 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 48B3CA1F5A8F0D3B8022;
        Sun, 26 Apr 2020 10:36:37 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Sun, 26 Apr 2020 10:36:30 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next v2] scsi: aacraid: Use memdup_user() as a cleanup
Date:   Sun, 26 Apr 2020 10:42:44 +0800
Message-ID: <1587868964-75969-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix coccicheck warning which recommends to use memdup_user().

This patch fixes the following coccicheck warning:

drivers/scsi/aacraid/commctrl.c:516:15-22: WARNING opportunity for memdup_user

Fixes: 4645df1035b3 ("[PATCH] aacraid: swapped kmalloc args.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/scsi/aacraid/commctrl.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index ffe41bc..102658b 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -513,15 +513,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	user_srbcmd = kmalloc(fibsize, GFP_KERNEL);
-	if (!user_srbcmd) {
-		dprintk((KERN_DEBUG"aacraid: Could not make a copy of the srb\n"));
-		rcode = -ENOMEM;
-		goto cleanup;
-	}
-	if(copy_from_user(user_srbcmd, user_srb,fibsize)){
-		dprintk((KERN_DEBUG"aacraid: Could not copy srb from user\n"));
-		rcode = -EFAULT;
+	user_srbcmd = memdup_user(user_srb, fibsize);
+	if (IS_ERR(user_srbcmd)) {
+		rcode = PTR_ERR(user_srbcmd);
 		goto cleanup;
 	}
 
-- 
2.6.2

