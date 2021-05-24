Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81307C47085
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 662A561166
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhEXDKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:50 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:36694 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhEXDKr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:47 -0400
Received: by mail-pj1-f42.google.com with SMTP id n6-20020a17090ac686b029015d2f7aeea8so10436674pjt.1
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TXPzkzuJQGE01JowfjgEICCjDt9e86KsHwCasja+Oho=;
        b=YXxWVEBT3OGNFsjqWw/4/3BgsfNLvTCLxtd+cZB8sunepvJHbmmaQHzSIn71pOUyKE
         m4JI3DQYDBNrd2xAy1tTGlDQ1aSE+wtENawyXp6PhGjQxJc7Zco17wNLKQy/EFpUVV+J
         3e2kNlJmTjuy/oSMIu7BcS+AB4xsh7DakYkhHCo3KRM4G7ty+YqJzTu9BfcTqkKZWr8c
         Mpe9nB1269oDar3r53z5DHNV4lUczofYqGQyLocbpTRVL0ocM9nJ7wZBXNBg/n2gWQbz
         J62cGBPBgx5aZRV/n/Ltu1WZaWa6UcM6r7GveTTO6R4mVLzzEhwp7SKW+g2CeJZM06aX
         A+QQ==
X-Gm-Message-State: AOAM533Aez2LizEO6Kb/lMHM9EUsQE7cRxqRe9XlkxIZfxwI062H1fGV
        0kJWb5OKJQCcGLjbzQkUq3M=
X-Google-Smtp-Source: ABdhPJz5ncnMjO9qqN/oiUY4AfBEExJZXzLi3LUqTSM3rJVDpTUvmTVQgQyOm9spwc+Ec5cQD5wPXw==
X-Received: by 2002:a17:90a:6402:: with SMTP id g2mr22411025pjj.82.1621825759152;
        Sun, 23 May 2021 20:09:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v3 10/51] zfcp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:15 -0700
Message-Id: <20210524030856.2824-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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
