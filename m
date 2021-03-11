Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79885C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 06:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 301AB64FAB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 06:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCKGaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 01:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhCKGaO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 01:30:14 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C137AC061574;
        Wed, 10 Mar 2021 22:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=Q0Q4fXrl+Z
        c6rfgHniJ+mO2J67W6fLX642I1Ov802hU=; b=RNOwCY2qllPTBqvhSnpcQAr3B7
        ETjhQCvPxVK7opD9BXWhmLUl9zLGV0tMecZ/x3ZXaEiU27H54Pz8zryJH5IoTd/K
        zY8/hcDksxYpTuZ8gfaIYAaFuTcOxLh7NJZEsm4e1bbqw0eAnWrDwQsTvhVV0PUo
        MhWAwBXJraE2WLSjA=
Received: from ubuntu.localdomain (unknown [114.214.226.60])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBnbBzvuElg4vgJAA--.2021S4;
        Thu, 11 Mar 2021 14:30:07 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     hare@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] scsi: Fix a double free in myrs_cleanup
Date:   Wed, 10 Mar 2021 22:30:05 -0800
Message-Id: <20210311063005.9963-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygBnbBzvuElg4vgJAA--.2021S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtFy3AF1xGF13ZrW7WrWktFb_yoWfJwb_ur
        4FvF4xJrW5trn7Kw18Jr4FyrWj9r48X3yF9F90gayrAFW8Zr9rXr40vwn0v3W7Ww47WFyU
        Wws0qr1fAr4xJjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1c4S5
        UUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In myrs_cleanup, cs->mmio_base will be freed twice by
iounmap().

Fixes: 77266186397c6 ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/scsi/myrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 4adf9ded296a..329fd025c718 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2273,12 +2273,12 @@ static void myrs_cleanup(struct myrs_hba *cs)
 	if (cs->mmio_base) {
 		cs->disable_intr(cs);
 		iounmap(cs->mmio_base);
+		cs->mmio_base = NULL;
 	}
 	if (cs->irq)
 		free_irq(cs->irq, cs);
 	if (cs->io_addr)
 		release_region(cs->io_addr, 0x80);
-	iounmap(cs->mmio_base);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 	scsi_host_put(cs->host);
-- 
2.25.1


