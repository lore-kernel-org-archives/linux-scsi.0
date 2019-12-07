Return-Path: <SRS0=TzWF=Z5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D302C2D0C1
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 03:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CE79217BA
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 03:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfLGDXA convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Dec 2019 22:23:00 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:51206 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726375AbfLGDXA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Dec 2019 22:23:00 -0500
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id ED74ECD816885C6273E8;
        Sat,  7 Dec 2019 11:22:57 +0800 (CST)
Received: from DGGEML525-MBS.china.huawei.com ([169.254.4.251]) by
 DGGEML402-HUB.china.huawei.com ([fe80::fca6:7568:4ee3:c776%31]) with mapi id
 14.03.0439.000; Sat, 7 Dec 2019 11:22:47 +0800
From:   "wubo (T)" <wubo40@huawei.com>
To:     "james.smart@broadcom.com" <james.smart@broadcom.com>,
        "dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>
Subject: [PATCH] scsi:lpfc:Fix memory leak on lpfc_bsg_write_ebuf_set func
Thread-Topic: [PATCH] scsi:lpfc:Fix memory leak on lpfc_bsg_write_ebuf_set
 func
Thread-Index: AdWsrSWHywN8OEO0QwWyn3DtmiXZsw==
Date:   Sat, 7 Dec 2019 03:22:46 +0000
Message-ID: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E7A966@DGGEML525-MBS.china.huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.252]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When phba->mbox_ext_buf_ctx.seqNum != phba->mbox_ext_buf_ctx.numBuf, 
dd_data should be freed before return SLI_CONFIG_HANDLED.

When lpfc_sli_issue_mbox func return fails, pmboxq should be also freed in job_error tag.


Signed-off-by:Bo wu <wubo40@huawei.com>
Reviewed-by:Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 39a736b887b1..6c2b03415a2c 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -4489,12 +4489,6 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 	phba->mbox_ext_buf_ctx.seqNum++;
 	nemb_tp = phba->mbox_ext_buf_ctx.nembType;
 
-	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
-	if (!dd_data) {
-		rc = -ENOMEM;
-		goto job_error;
-	}
-
 	pbuf = (uint8_t *)dmabuf->virt;
 	size = job->request_payload.payload_len;
 	sg_copy_to_buffer(job->request_payload.sg_list,
@@ -4531,6 +4525,13 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 				"2968 SLI_CONFIG ext-buffer wr all %d "
 				"ebuffers received\n",
 				phba->mbox_ext_buf_ctx.numBuf);
+
+		dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
+		if (!dd_data) {
+			rc = -ENOMEM;
+			goto job_error;
+		}
+
 		/* mailbox command structure for base driver */
 		pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (!pmboxq) {
@@ -4579,6 +4580,8 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 	return SLI_CONFIG_HANDLED;
 
 job_error:
+	if (pmboxq)
+		mempool_free(pmboxq, phba->mbox_mem_pool);
 	lpfc_bsg_dma_page_free(phba, dmabuf);
 	kfree(dd_data);
 
-- 
2.19.1
