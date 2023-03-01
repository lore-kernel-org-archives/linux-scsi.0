Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3AFC678D4
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjCAXHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCAXHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:18 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747C855078
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:17 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id cf14so16214089qtb.10
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1QquRWHvbN6HKV/l3mb+CElIpFpVP7PNk57/ZB3AMM=;
        b=qwTBNC63JUyKdjzGpZeB+2/LFbg5FeIhj0uKt2lx4WbfPHHTzTfDgIcs9/zGlTwoL9
         5IL8q3JeEVpedBwnHigeXeSN1qjkUWcHl5Oqh+VRSKv5+4ZjBze5tdon5vL0JRc5/lxT
         oCIxjX2bvp8AHAI8ijKu+4b6SM3QDse6XYav1NrPjipqVa651GzM2/Gwf2TqV5KvJd1m
         5B9BAjXHg1YjPPwyKc3XZj+NRCBDIdf2nfesYVrBZcMgqDl5sSN6xfJnAqr4v8S648gX
         QVXtOU+dDFFFBaTmb6wlTfXhNsEmQu7ptezUm87rd6IYKUi7TS6xiIhQM0hIrDFMXt9N
         N4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n1QquRWHvbN6HKV/l3mb+CElIpFpVP7PNk57/ZB3AMM=;
        b=h3dePGvy/qrdKS3UU1p0eyOmLxUMbz3cASKLPvz0sOpqeG4P/YGFvKY9UV51gF4Tuc
         FB3C5+n5qrhHWHh6ZzReSh8bQ6cwyxHZXQ4oEsY7TGCeWw9GJ9PDtihQufJNLIWRipbM
         0Y5caD9KMDLvhn3wM7N8ONWGk5eO2vqF3ZKnHMF59277Wzn8DshJR+iKLQA9nuN0kMeX
         9GVXBvEDmUvSUbitbBXAez6jn87EYytOntfGtmVChug/aisW1R9Dc2G35MbgPSthoLHQ
         zTeC3H9k/T6GmFQCxoZKK0VDu8cUq1Slfpr3VTOHxZIn2bTTg3enFxy4xCmzHnkPL8S1
         w7wA==
X-Gm-Message-State: AO0yUKUxjLEjIkQ7Ld9q/Kyzx9y7jIoTVhi4ns+3NTYl1shsfAUeYn9E
        kx3tT3yJZB8zWx83B9iWLYWJ4ZTX8JA=
X-Google-Smtp-Source: AK7set+Sdr9kKjULPmOyiFi3JHiPOqq4wWu6YSU1d+hYHl9n95D/oxYwZecMWRRpFk5zY71kPTxUFA==
X-Received: by 2002:a05:622a:18a1:b0:3bf:a3d0:9023 with SMTP id v33-20020a05622a18a100b003bfa3d09023mr14467998qtc.5.1677712036446;
        Wed, 01 Mar 2023 15:07:16 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:16 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/10] lpfc: Reorder freeing of various dma buffers and their list removal
Date:   Wed,  1 Mar 2023 15:16:18 -0800
Message-Id: <20230301231626.9621-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Code sections where dma resources are freed before list removal are
reworked to ensure item removal before freed.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 2 +-
 drivers/scsi/lpfc/lpfc_ct.c  | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 852b025e2fec..d8e86b468ef6 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -134,8 +134,8 @@ lpfc_free_bsg_buffers(struct lpfc_hba *phba, struct lpfc_dmabuf *mlist)
 	if (mlist) {
 		list_for_each_entry_safe(mlast, next_mlast, &mlist->list,
 					 list) {
-			lpfc_mbuf_free(phba, mlast->virt, mlast->phys);
 			list_del(&mlast->list);
+			lpfc_mbuf_free(phba, mlast->virt, mlast->phys);
 			kfree(mlast);
 		}
 		lpfc_mbuf_free(phba, mlist->virt, mlist->phys);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index e941a99aa965..e290aff2e881 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -476,8 +476,8 @@ lpfc_free_ct_rsp(struct lpfc_hba *phba, struct lpfc_dmabuf *mlist)
 	struct lpfc_dmabuf *mlast, *next_mlast;
 
 	list_for_each_entry_safe(mlast, next_mlast, &mlist->list, list) {
-		lpfc_mbuf_free(phba, mlast->virt, mlast->phys);
 		list_del(&mlast->list);
+		lpfc_mbuf_free(phba, mlast->virt, mlast->phys);
 		kfree(mlast);
 	}
 	lpfc_mbuf_free(phba, mlist->virt, mlist->phys);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c5b69f313af3..bfab1f0fb3f0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22329,10 +22329,10 @@ lpfc_free_sgl_per_hdwq(struct lpfc_hba *phba,
 	/* Free sgl pool */
 	list_for_each_entry_safe(list_entry, tmp,
 				 buf_list, list_node) {
+		list_del(&list_entry->list_node);
 		dma_pool_free(phba->lpfc_sg_dma_buf_pool,
 			      list_entry->dma_sgl,
 			      list_entry->dma_phys_sgl);
-		list_del(&list_entry->list_node);
 		kfree(list_entry);
 	}
 
@@ -22479,10 +22479,10 @@ lpfc_free_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 	list_for_each_entry_safe(list_entry, tmp,
 				 buf_list,
 				 list_node) {
+		list_del(&list_entry->list_node);
 		dma_pool_free(phba->lpfc_cmd_rsp_buf_pool,
 			      list_entry->fcp_cmnd,
 			      list_entry->fcp_cmd_rsp_dma_handle);
-		list_del(&list_entry->list_node);
 		kfree(list_entry);
 	}
 
-- 
2.38.0

