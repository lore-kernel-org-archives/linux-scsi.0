Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FAAC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A01F46112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242899AbhHETTd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:33 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:44803 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242687AbhHETT1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:27 -0400
Received: by mail-pj1-f45.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so11971856pjh.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xh8XA54Imxo9ILc5L+S6WvBmWu7PpD2lkFGz180jRy0=;
        b=sAeNlJwTK0OXDftXzQ83lcLKIAreoa4TIM9GEa32JPoa8sWkjNuFeMbl+JFfsmHtVs
         7ZtGAiU89fDo/bIl7kt71I4C3R5DCTN02RT9AedcESzfjHlawMob9yb5CJqdfcQdZIqZ
         9VN8C1D/zgqhDbheCuo/pqzjU16G8kzb1Edn4TyLU6F7Ycpcqg8drMOZPcOMQ33dcBKg
         ylpAhFaS6/u0k2bnXqoMUmjWDZF2edGRHAZCPk3gKqwqcBDDG4i/wYl7qRvRw9uaxcFW
         sX6UuPd1YFNTT/Tr748fA6FNZa7JCQHrUkh7IUrH4jesr/hG2A0URyjqDxl0RA9rh2IH
         xJlg==
X-Gm-Message-State: AOAM530Hou9vmoHQtYpE8KuN93MtJTU0nui2gXgcxlj+vix8M03pbsc3
        K2gox08Bp1+tOgXm96tc6us=
X-Google-Smtp-Source: ABdhPJxzSK3rnlPh70KtkMV2iWAtEpyK1d4aWYe3ogvY2DW/ZxWWrvE0XKEgzxJa9wfm7qehHcMzrQ==
X-Received: by 2002:a17:902:8642:b029:12c:dda2:30c3 with SMTP id y2-20020a1709028642b029012cdda230c3mr5154530plt.84.1628191152422;
        Thu, 05 Aug 2021 12:19:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 18/52] cxlflash: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:54 -0700
Message-Id: <20210805191828.3559897-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 222593bc2afe..2f1894588e0b 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -433,7 +433,7 @@ static u32 cmd_to_target_hwq(struct Scsi_Host *host, struct scsi_cmnd *scp,
 		hwq = afu->hwq_rr_count++ % afu->num_hwqs;
 		break;
 	case HWQ_MODE_TAG:
-		tag = blk_mq_unique_tag(scp->request);
+		tag = blk_mq_unique_tag(scsi_cmd_to_rq(scp));
 		hwq = blk_mq_unique_tag_to_hwq(tag);
 		break;
 	case HWQ_MODE_CPU:
