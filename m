Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C48C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 14:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13D0520782
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 14:19:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uNytucz+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgHKOTl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 10:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgHKOTl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2020 10:19:41 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78E7C06174A;
        Tue, 11 Aug 2020 07:19:40 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id qc22so13287532ejb.4;
        Tue, 11 Aug 2020 07:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XTS1vpDtg3OP4CRvjP9CPhkq94c+0NX17v/BpymKceQ=;
        b=uNytucz+Um9k8rX3Op2FkCbsHVQ5HlfOhgD+4S4w/v3zz/qoLvVOgJ66rdJe0mmrSr
         itD46RWboOS8QDoQvh4aQ2SMK01lhJzEf7z7cd2JYzKh1pWzY1yhK1o4IurDSLSL844B
         MP/wEwC5PPnT/mKeduKHpXrhwSzxsIuxsX4c/VQtHhmMfDOLgAhqON6Y+wcpz2oZPhG7
         6mdaNTAsp0XdzVemFpfY/10P4FZFC0ZNJWSDEU1mER4jrm1QJXBg1CMxOhNhzfuTfVsY
         RB92YENATa3QNVVnaZDHXn35YijQpo27AMlH8oT48MhjYZY4G9ejUKnlVw1avfJGDzB4
         vSAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XTS1vpDtg3OP4CRvjP9CPhkq94c+0NX17v/BpymKceQ=;
        b=ejwqRgaTz76cmgE0R8U8l219ej6C8t3JgD17s6v2eZHcXc69S3gE3TIegMDv9f8cfq
         CgQFHwjzLBthH/sJHxS8fTQkfvqq1R6+WYb3vzTjCALfKnhz2l9Da7Ou4s/N397AKcmh
         AT2ZftovjyZNZIJaES3IlNKfjMTki6Ydg6RnEd8Kp53PeGWv1Wqez+wr/NYoT28Js3fc
         Ek3mJMeGKKabo1O6foVwnp3bXeq1fnqeII6uKyZGIEJ2Cg79Um1YAIqV8DlDKgji5kLs
         cEk3jOm2lK64jjfyL6cufqNe3/6NDykLWqmVPrP1r6qTEI5l4fKzVBx4h88U0OLDBvFU
         2Hpw==
X-Gm-Message-State: AOAM5307R9SSi3Xl6mrJyjcXRMFchhKI/dm5EoyYhAyYoXS4AtizhjWj
        nnbbZSe/VTt4jJVXsosjX8Y=
X-Google-Smtp-Source: ABdhPJxqo9iB2hMmj15C/WW8eXdivR3THlqWCAeHsmcxFSrdKtj3mXoJ+l13KMOUI1decDzFWoi00Q==
X-Received: by 2002:a17:906:924d:: with SMTP id c13mr25818352ejx.518.1597155579514;
        Tue, 11 Aug 2020 07:19:39 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b888:52c9:44c:d55b:5f94:2fc4])
        by smtp.gmail.com with ESMTPSA id q15sm1467050edc.74.2020.08.11.07.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 07:19:38 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] scsi: ufs: Cleanup completed request without interrupt notification
Date:   Tue, 11 Aug 2020 16:18:58 +0200
Message-Id: <20200811141859.27399-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200811141859.27399-1-huobean@gmail.com>
References: <20200811141859.27399-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

If somehow no interrupt notification is raised for a completed request
and its doorbell bit is cleared by host, UFS driver needs to cleanup
its outstanding bit in ufshcd_abort(). Otherwise, system may behave
abnormally by below flow:

After ufshcd_abort() returns, this request will be requeued by SCSI
layer with its outstanding bit set. Any future completed request
will trigger ufshcd_transfer_req_compl() to handle all "completed
outstanding bits". In this time, the "abnormal outstanding bit"
will be detected and the "requeued request" will be chosen to execute
request post-processing flow. This is wrong because this request is
still "alive".

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 307622284239..66fe814c8725 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6492,7 +6492,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 			/* command completed already */
 			dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.\n",
 				__func__, tag);
-			goto out;
+			goto cleanup;
 		} else {
 			dev_err(hba->dev,
 				"%s: no response from device. tag = %d, err %d\n",
@@ -6526,6 +6526,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
+cleanup:
 	scsi_dma_unmap(cmd);
 
 	spin_lock_irqsave(host->host_lock, flags);
-- 
2.17.1

