Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE35C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D860611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351220AbhERRqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:31 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:39499 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347084AbhERRq0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:26 -0400
Received: by mail-pg1-f182.google.com with SMTP id v14so4801586pgi.6
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TXPzkzuJQGE01JowfjgEICCjDt9e86KsHwCasja+Oho=;
        b=IMxv3dJmhfV8L4r7d6H9wxhdF20LsKa6znApPHsX0IyqoqQ+EsVN44IOBQvv0a+/VZ
         BwWwqOLcb5vyzOgLNJZSygBy+owhpdaaYdB0bXNJU6QO1CYXdhMTrGay8mfTvU09JKrK
         vDWPGNOp7QK+MdUYQb8VZnAVuYqFyabxJpvlpQdlTu82+3f17JCwUXflxRK5a6qOCDkx
         iQiTVj+VDmLF+OW9T346wUaEbI/OgPoNXl38ntgwNfyLrgmm5CeEZmbLDnc0vfb53SUS
         X7JRWdhYusWQEYYEOEZIqvB2TVxFGV4tdY3odq5QMJNgSz/0mrM+CHdGvSldR8tFl/cL
         HxJw==
X-Gm-Message-State: AOAM531EppP8Xcij5b9Uj4RrJ6tjl74PIfq97EwYQxSvIdhoOC7NaqTc
        Vkj2WusA95Iv2NF96zdT7EQ=
X-Google-Smtp-Source: ABdhPJyC+thNJ7YMgaplGjDfAm4YT9hGBFHRjlHtKrIyxhuE1v2+c3l9TLLlAqkBUVFUz95uCFMnnQ==
X-Received: by 2002:a63:1422:: with SMTP id u34mr6286597pgl.263.1621359908063;
        Tue, 18 May 2021 10:45:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 10/50] zfcp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:10 -0700
Message-Id: <20210518174450.20664-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
index 2e4804ef2fb9..9e3f37b4423d 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2377,7 +2377,7 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 		}
 	}
 
-	blk_add_driver_data(scsi->request, &blktrc, sizeof(blktrc));
+	blk_add_driver_data(scsi_cmd_to_rq(scsi), &blktrc, sizeof(blktrc));
 }
 
 /**
