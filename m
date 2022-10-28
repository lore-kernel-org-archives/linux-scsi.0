Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6281CC38A02
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Oct 2022 05:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJ1FIU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Oct 2022 01:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ1FIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2022 01:08:19 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 157EE1B156D;
        Thu, 27 Oct 2022 22:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=kt3iK
        smMMKWgKoyXI3XPdA6XBPWW/6C1tCL/uRPd9MA=; b=AglJgsWJOGqK4TLQzKDZU
        bb4PEmfDKj22TOMzGdnRhz/leTmXASNH5IA/Ehaz5/lc+8Z/d1+NBTyk5QLA8gaV
        maBRVzTgthNnuguZ8A0lktughEd4DAMGcANe8Hk5b9hIQLWJPrr4YkS/3iEI+uW3
        2XcFNQdtZOeyDLnCq/9zzY=
Received: from localhost.localdomain (unknown [111.206.145.21])
        by smtp5 (Coremail) with SMTP id HdxpCgCHr_CZY1tj9i5AoA--.10196S2;
        Fri, 28 Oct 2022 13:07:37 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     james.smart@broadcom.com
Cc:     dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        hackerzheng666@gmail.com, alex000young@gmail.com,
        security@kernel.org, linux-kernel@vger.kernel.org,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] scsi: lpfc: fix double free bug in lpfc_bsg_write_ebuf_set
Date:   Fri, 28 Oct 2022 13:07:36 +0800
Message-Id: <20221028050736.151185-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgCHr_CZY1tj9i5AoA--.10196S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrW3Zr1rGw1rKw1kZFyxXwb_yoW8ZrW8pa
        y3C3Z7ArZrtF4IqrWDA34Yv3s3tayfXFy2kFZFg3WrWF1FvryjyF1UtF18XFWYkFyI9rZ8
        tF4UK34UWF17Xa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziLZ2hUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXBmoU1Xl4nrbGgAAsX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When error occurs, it frees dmabuf in both lpfc_bsg_write_ebuf_set
and lpfc_bsg_issue_mbox.

Fix it by removing free code in lpfc_bsg_write_ebuf_set.

Reported-by: Zheng Wang <hackerzheng666@gmail.com>
Reported-by: Zhuorao Yang <alex000young@gmail.com>

Fixes: 7ad20aa9d39a ("[SCSI] lpfc 8.3.24: Extend BSG infrastructure and add link diagnostics")

Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index ac0c7ccf2eae..7362d9c1a50b 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -4439,15 +4439,13 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 
 		dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
 		if (!dd_data) {
-			rc = -ENOMEM;
-			goto job_error;
+			return -ENOMEM;
 		}
 
 		/* mailbox command structure for base driver */
 		pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (!pmboxq) {
-			rc = -ENOMEM;
-			goto job_error;
+			return -ENOMEM;
 		}
 		memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
 		pbuf = (uint8_t *)phba->mbox_ext_buf_ctx.mbx_dmabuf->virt;
@@ -4480,8 +4478,7 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 		lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
 				"2970 Failed to issue SLI_CONFIG ext-buffer "
 				"mailbox command, rc:x%x\n", rc);
-		rc = -EPIPE;
-		goto job_error;
+		return -EPIPE;
 	}
 
 	/* wait for additional external buffers */
@@ -4489,14 +4486,6 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
 	return SLI_CONFIG_HANDLED;
-
-job_error:
-	if (pmboxq)
-		mempool_free(pmboxq, phba->mbox_mem_pool);
-	lpfc_bsg_dma_page_free(phba, dmabuf);
-	kfree(dd_data);
-
-	return rc;
 }
 
 /**
-- 
2.25.1

