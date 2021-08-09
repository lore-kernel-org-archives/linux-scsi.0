Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D392FC432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B335360EE7
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbhHIXEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:40 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:51784 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbhHIXEj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:39 -0400
Received: by mail-pj1-f46.google.com with SMTP id oa17so5472588pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Ngh8bZIHX7uSToo3cEaIXtbZZeKNQTo0O7QeD8+ltQ=;
        b=T+VBaSCXZ8a0Z3UYRUIQS/I7U9DGMZ7lWptGarUHCyseDxn5l5YOeG+uA0/JN83787
         1yYe4dBIpQ07tXTIoVN7dyudha7rvm0ZdTw4UZNrhlE3WMU6MXSIPcN/CB8XJkikE3nZ
         gNf3fTTU9tbDN1Oec42vI05UWRLzC2Af/bnnPYeOne6j+BzMXpOTVNA12vv5+OgkLyqO
         e3yNwqfI5elbMSwFtWiyH1Wa8AL/7q3HKziu2cS4GS/IimX2F/HARWvXqAoy7iLfvdLj
         3wnyJ+9z7S4NyvlWb5NLPCQd8iVJIAXmDXjip96+2rLVU6EDo289eh2/uULW+5ZytUt6
         crCA==
X-Gm-Message-State: AOAM531ojmYVe+HIDWFuR9L75H7vRRDjXS3JpHtP4k+YteAE6RErqCji
        SHEe8YReei5UfWuP5/HqRe0=
X-Google-Smtp-Source: ABdhPJwrDi1RF26QBXAXkJddKB8BrX+84biJYB294bsHzIimXR6/G3NgLeAAYZpek2HjxoERBNaecw==
X-Received: by 2002:a17:902:e549:b029:12c:bf10:36c9 with SMTP id n9-20020a170902e549b029012cbf1036c9mr22024938plf.66.1628550258215;
        Mon, 09 Aug 2021 16:04:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v5 10/52] zfcp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:13 -0700
Message-Id: <20210809230355.8186-11-bvanassche@acm.org>
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
