Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09306C3DA7A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Jan 2023 21:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbjAEVrr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Jan 2023 16:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbjAEVrY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2023 16:47:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB0E63199
        for <linux-scsi@vger.kernel.org>; Thu,  5 Jan 2023 13:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672955201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RJxX8F2Oi9p4ox5AYCJudMMSN3aLdKu313AtW9TP9ck=;
        b=Sq+qngd9FJpOAuTyAeugbH/NwrQueo/+/RPHrJkwAAdSlLoQ3yQ3J4r/Yv94e7gpu8LOZD
        uWDy9a+31Mzbnr9a+9Q5Dfdt1AzTXkdmJETKVJtOk8MzqKExr+okrzQAWVd4t3WwnvYW9r
        bkHmwpkHX2u79tDLRr+pjVo2E+hlpcU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-342-EPNpXWjoMGCVNkzZkZxVyQ-1; Thu, 05 Jan 2023 16:46:39 -0500
X-MC-Unique: EPNpXWjoMGCVNkzZkZxVyQ-1
Received: by mail-qk1-f199.google.com with SMTP id h13-20020a05620a244d00b006fb713618b8so25845607qkn.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jan 2023 13:46:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJxX8F2Oi9p4ox5AYCJudMMSN3aLdKu313AtW9TP9ck=;
        b=ldnXqZhj2ssQih4EN16KHrxItqevkRyqP7ZyrtjYkIW9vYsvDvu1HZudfKiYxf2P7V
         pR2pdNdOExVDuxVrcqbTxZ+3QXvbq76rrOTi81VUggituDyRO+xEo0s42U9SKjQokWei
         zovjzXMfydhlgMcvwGMQp0yAzSPXcbb/tXtTjfmOSbehFHkroltGJ+TWY+2txivKPdYp
         NflDhe/ggRIkeZ0MSrEm/fyWaSV0PiFgLjEOkshxlv2azfJNQ3Q3LvoykeTh4n5O5SKz
         RnsbfAhh1FerQOxJckyWUCcUFTEu2Z6mY3pLUEG9cVRW690vV1q8sK8Fmvzourl4Lq0d
         /IEA==
X-Gm-Message-State: AFqh2kpAxiWk+rMGIor76kQqGrKPyMKQfJxoKVa1XzT5/ruKhu7l/taM
        Ur52Igjc9bUysvJKqsnP3F6SDs7JsZKZvrK9XTY8zKvTAaAX0EilaHwEHlYHVdutkyRirXC+bEj
        pcyGzenE3VP6NtHuNyRcHww==
X-Received: by 2002:a05:622a:4d98:b0:3a5:24ac:a175 with SMTP id ff24-20020a05622a4d9800b003a524aca175mr79247732qtb.56.1672955199436;
        Thu, 05 Jan 2023 13:46:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtOxlIpJae+yvLp/3VsoqW8D9MXFVzcQIHBPniSyIwWqQ9/WnS8U1M90QS9GG96j49U3uDZDA==
X-Received: by 2002:a05:622a:4d98:b0:3a5:24ac:a175 with SMTP id ff24-20020a05622a4d9800b003a524aca175mr79247709qtb.56.1672955199240;
        Thu, 05 Jan 2023 13:46:39 -0800 (PST)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bq22-20020a05622a1c1600b0039c7b9522ecsm22189237qtb.35.2023.01.05.13.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 13:46:38 -0800 (PST)
From:   Tom Rix <trix@redhat.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, nathan@kernel.org,
        ndesaulniers@google.com, beanhuo@micron.com,
        Arthur.Simchaev@wdc.com, stanley.chu@mediatek.com,
        j-young.choi@samsung.com, peter.wang@mediatek.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: ufs: core: initialize sg_cnt, sg_list
Date:   Thu,  5 Jan 2023 16:46:35 -0500
Message-Id: <20230105214635.874609-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The clang build fails with
drivers/ufs/core/ufs_bsg.c:107:6: error: variable 'sg_cnt' is used
  uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        if (dir != DMA_NONE) {
            ^~~~~~~~~~~~~~~
Similar for sg_list.

This is not an error because ufshcd_advanced_rpmb_req_handler() does a
similar check, but that check can be reduced if sg_list is initialized to NULL.
Initialize sg_cnt to silence its error.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/ufs/core/ufs_bsg.c | 4 ++--
 drivers/ufs/core/ufshcd.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 0044029bcf7b..0d38e7fa34cc 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -70,9 +70,9 @@ static int ufs_bsg_exec_advanced_rpmb_req(struct ufs_hba *hba, struct bsg_job *j
 	struct ufs_rpmb_reply *rpmb_reply = job->reply;
 	struct bsg_buffer *payload = NULL;
 	enum dma_data_direction dir;
-	struct scatterlist *sg_list;
+	struct scatterlist *sg_list = NULL;
 	int rpmb_req_type;
-	int sg_cnt;
+	int sg_cnt = 0;
 	int ret;
 	int data_len;
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index da81eafc19d5..6ed728885650 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7051,7 +7051,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 	/* Copy EHS, starting with byte32, immediately after the CDB package */
 	memcpy(lrbp->ucd_req_ptr + 1, req_ehs, sizeof(*req_ehs));
 
-	if (dir != DMA_NONE && sg_list)
+	if (sg_list)
 		ufshcd_sgl_to_prdt(hba, lrbp, sg_cnt, sg_list);
 
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
-- 
2.27.0

