Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357E7C432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BCB960F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbhHIXFB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:01 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:40661 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237005AbhHIXEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:52 -0400
Received: by mail-pj1-f49.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so1411549pji.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xh8XA54Imxo9ILc5L+S6WvBmWu7PpD2lkFGz180jRy0=;
        b=qZyIjBUoTyJv6tDWHKAL1kzGJq5pcjnPLyRirlsogLhuHPyyPPSJsuoPK3fLymnjuM
         /C+GEz7UsRub8KCTJrU/oWquy3mmNNkdozayBjWPRl3PVOkqlIhtgKuj/hVA9ccKKi0y
         VrkeWlFEsNIVZvChdxdrr4Dk13LsaL46Yl3pXRyN/215W9cz8twXSgy68d3+FWsVNf9n
         kKAVey24LnWvBd0u5JcS+CaVoshS2WKm2qSyQKxsybGapR/3Z5i9EYoXhTq4JdcgOx6m
         x7yw76Wkl40hPZ9dzZi2y9K43ALvhxFu3YUMOdronm/BZ/lJVE9FjowsWETXXiD4y52s
         LfTA==
X-Gm-Message-State: AOAM531P434mx3pM6DiRXpcA/Y0pbo5uQG1akQuWokmNlTi5+DukSJcV
        XZ1TDPu/0VbihdYYbQ258NE=
X-Google-Smtp-Source: ABdhPJzpLUrywU8kCqDTsGkDq3bez2wNPxVOiBtZlZSPn2mrTfRUkzoqCv0eFrDPHY8IfFrVrOPv8w==
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id l6-20020a056a0016c6b029032de1909dd0mr25699377pfc.70.1628550271242;
        Mon, 09 Aug 2021 16:04:31 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 18/52] cxlflash: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:21 -0700
Message-Id: <20210809230355.8186-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
