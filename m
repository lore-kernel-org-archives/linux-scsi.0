Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AD9C25B0E
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Aug 2022 01:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241680AbiHSBST (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Aug 2022 21:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiHSBSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2022 21:18:16 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6399CE97
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:12 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id c20so2417423qtw.8
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=pahNwCbJrf/wSivBBZ0962KNSPOHVIkwr/mWjP1s69A=;
        b=c5Wu3raM5PR3T3s6D+uND8Iuy2WXjYEGvdCQVy8AUdnoYv69IidNWjwbKH3SRrDsDx
         bJ/hnaxRRP/vf62XtrTG2GqVpV/knS30D2EvbDfSk20027OKs2UZOrrv2vscTI9u5Kid
         8nwGiQzgq9UeWgvoVetjXu+6Pzx5V21vkYxXgE3zG/tOFnOD3CdRYMtrJiQzYM/6Nh4F
         E5IbTZT56SmQKf4EBFEMOOtYghYMGXXLAjINCmVPvcdTlVUkhUzYp8QfsvSR6Nx31BDY
         LXAv9QaX9R1JSNTC7fAFXMIioZM6jwc3gjiXwjh03hESS3LZvhFMnaWqE/ETVJ95Pbcq
         Qcrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=pahNwCbJrf/wSivBBZ0962KNSPOHVIkwr/mWjP1s69A=;
        b=s+tqh//LQJiIPb44fRxSAkjipdWcbY0B+AsI9HkZa2RZ8guPWFZbB/X33dDVTzL1+N
         GbnupsTnprfQNvRVuzZXo7RmH6EG2/ZLSaKi5f3B5/QkBQpw5ch9N4kbtCs3DL5bwV7k
         0ZkSARbjj9BRH8ypsgGWKrV3d3r5tPJx7c5QrNKYTjAI3jzcu0sdDtv3klTwIv1A++Gl
         9ZCeiQSBSx5WPRgjhq6magK/JX8wF1RfQbQw/KHz8+NOTP29NCgbXqPjTmyoxqrwvlgi
         rfR6SmIH12aJ+YJheg6jfzFbllgnVYWCE2y8q7kw9Ej/xwc5qNoGiWT5CATNJlmUZZmS
         O2kw==
X-Gm-Message-State: ACgBeo0FvtXsdQMFcMM0onNa1wQKMZ0BAOCmy+/rWbP6Pp6Y9rvzSbYd
        iwE85PDxi//GuruiTNanelj/yYgnsyM=
X-Google-Smtp-Source: AA6agR7/2LX4YodjNltJ35McanozesgFtowrU8M0XQugKxQiA7pR3YGgxWdcWdE0oS1gRDFAvOj6cg==
X-Received: by 2002:a05:622a:1492:b0:344:5130:4094 with SMTP id t18-20020a05622a149200b0034451304094mr4941966qtx.3.1660871891423;
        Thu, 18 Aug 2022 18:18:11 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id u5-20020a05620a0c4500b006b5e296452csm2612502qki.54.2022.08.18.18.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 18:18:11 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 2/7] lpfc: Fix null ndlp ptr dereference in abnormal exit path for GFT_ID
Date:   Thu, 18 Aug 2022 18:17:31 -0700
Message-Id: <20220819011736.14141-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220819011736.14141-1-jsmart2021@gmail.com>
References: <20220819011736.14141-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An error case exit from lpfc_cmpl_ct_cmd_gft_id() results in a call
to lpfc_nlp_put() with a null pointer to a nodelist structure.

Changed lpfc_cmpl_ct_cmd_gft_id() to initialize nodelist pointer
upon entry.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 13dfe285493d..b555ccb5ae34 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1509,7 +1509,7 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_sli_ct_request *CTrsp;
 	int did;
 	struct lpfc_nodelist *ndlp = NULL;
-	struct lpfc_nodelist *ns_ndlp = NULL;
+	struct lpfc_nodelist *ns_ndlp = cmdiocb->ndlp;
 	uint32_t fc4_data_0, fc4_data_1;
 	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
 	u32 ulp_word4 = get_job_word4(phba, rspiocb);
@@ -1522,15 +1522,12 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			      ulp_status, ulp_word4, did);
 
 	/* Ignore response if link flipped after this request was made */
-	if ((uint32_t) cmdiocb->event_tag != phba->fc_eventTag) {
+	if ((uint32_t)cmdiocb->event_tag != phba->fc_eventTag) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "9046 Event tag mismatch. Ignoring NS rsp\n");
 		goto out;
 	}
 
-	/* Preserve the nameserver node to release the reference. */
-	ns_ndlp = cmdiocb->ndlp;
-
 	if (ulp_status == IOSTAT_SUCCESS) {
 		/* Good status, continue checking */
 		CTrsp = (struct lpfc_sli_ct_request *)outp->virt;
-- 
2.26.2

