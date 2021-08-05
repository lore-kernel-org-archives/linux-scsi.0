Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3496C4320E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A948D6112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242634AbhHETTW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:22 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:35673 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242791AbhHETTJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:09 -0400
Received: by mail-pj1-f44.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so17372756pjs.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Ngh8bZIHX7uSToo3cEaIXtbZZeKNQTo0O7QeD8+ltQ=;
        b=G6EgTNpOyFf5DEjS1pDLVCHtXLaJG2scv0/Hi7TLnekNhHmyC2UVgM1svgIGboZp8y
         JSeUtyMjQ5OHlw6u1q7beua8KZVW8jjHwTRjKX+BEB06xvDIzu1oJjChg3ePw/KKm1H1
         7uOYW1WxCUNlvyl5dyPXxXIuBIPShgwROG5B3hn3wV52jkBIj1K/TKSOvecV0q5kqSAO
         ztdhlnUTLfK0DDlRbJECmscSwIDNAMBAHJLmwBZOKGjSlOaZ8zLnoOtvjG8YDvmmPPzD
         yXIYNGpU1FG8OwO4pN4VMfTAILEPsqfH5bywTaC2J3JLfz22nRDlu4YRKVSzkyJGd3Kz
         zULQ==
X-Gm-Message-State: AOAM533Bxs+72jf8D0Degkj1Vepgr8G4bmpOXZSuxJXn9LN7rkVuPqTH
        CjQCOZHHyeIGDC5EalqzQ6o=
X-Google-Smtp-Source: ABdhPJxDScyfyl/3WJf3WEUzxwltWDYdr7+QxPMsqr9sw4eaLTO9X0b34Ovng/Nw9AxTHu/T0z8BBA==
X-Received: by 2002:a17:902:d48a:b029:12c:2142:6702 with SMTP id c10-20020a170902d48ab029012c21426702mr5237867plg.53.1628191134954;
        Thu, 05 Aug 2021 12:18:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v4 10/52] zfcp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:46 -0700
Message-Id: <20210805191828.3559897-11-bvanassche@acm.org>
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

Acked-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/s390/scsi/zfcp_fsf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 1990216cf289..6da8f6d05d39 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2377,7 +2377,7 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 		}
 	}
 
-	blk_add_driver_data(scsi->request, &blktrc, sizeof(blktrc));
+	blk_add_driver_data(scsi_cmd_to_rq(scsi), &blktrc, sizeof(blktrc));
 }
 
 /**
