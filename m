Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18175C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 06:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3D8D6124C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 06:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhFHGyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 02:54:21 -0400
Received: from m12-13.163.com ([220.181.12.13]:38712 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFHGyV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Jun 2021 02:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=NB69t
        56dnHwp4Cpi9/viJYWq9pSuTO7tWxcNKZlQeWw=; b=PUntIfAYX2/9jnIfjWaVm
        tfMkSA7hPu+E0PA2vHNPa7Yb0Gp3jR8zji9rZTAWJoG6HfPpo56K+rTvUQKh8iJo
        Azjv/hS05xWm9HgJD/aRem30YeDr24IjeVjMHF/jwM+frzuaJ0cI6sjYzpc04KWS
        U9Oa7moKfoW+6Bvsup4yFI=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowACXm3ufCL9gVrmxFA--.57475S2;
        Tue, 08 Jun 2021 14:05:20 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_mem: Removed unnecessary 'return'
Date:   Tue,  8 Jun 2021 14:04:22 +0800
Message-Id: <20210608060422.256554-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowACXm3ufCL9gVrmxFA--.57475S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF4kuFWUtw1rZF1UXw4kCrg_yoW8XFWkpa
        13Ga4Uur4DtF1xKF43Jr45A3ZIva1Sq34jka1vv345uFnYyryrKFyUAFy8Ww15tF4vkrna
        yrn2gay5ua17GrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07juPfdUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/xtbBEQCrUFaEEpfDogAAsc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_mem.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index be54fbf5146f..f5b4c4a81eba 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -269,7 +269,6 @@ lpfc_mem_free(struct lpfc_hba *phba)
 		mempool_destroy(phba->device_data_mem_pool);
 	}
 	phba->device_data_mem_pool = NULL;
-	return;
 }
 
 /**
@@ -338,8 +337,6 @@ lpfc_mem_free_all(struct lpfc_hba *phba)
 	/* Free the iocb lookup array */
 	kfree(psli->iocbq_lookup);
 	psli->iocbq_lookup = NULL;
-
-	return;
 }
 
 /**
@@ -405,7 +402,6 @@ __lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 	} else {
 		dma_pool_free(phba->lpfc_mbuf_pool, virt, dma);
 	}
-	return;
 }
 
 /**
@@ -429,7 +425,6 @@ lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	__lpfc_mbuf_free(phba, virt, dma);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
-	return;
 }
 
 /**
@@ -519,7 +514,6 @@ lpfc_els_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp)
 {
 	dma_pool_free(phba->lpfc_hbq_pool, hbqbp->dbuf.virt, hbqbp->dbuf.phys);
 	kfree(hbqbp);
-	return;
 }
 
 /**
@@ -682,7 +676,6 @@ lpfc_in_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
 	}
-	return;
 }
 
 /**
-- 
2.25.1


