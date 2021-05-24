Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A090C47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BC516115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhEXDL3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:29 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:37647 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhEXDL2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:28 -0400
Received: by mail-pj1-f42.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so10437632pjb.2
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8ZrZxpFyLWC/b8TX2g9suyIzirLulmQYWjh1aPwWLg=;
        b=avRDFYM+UK+RTBWt5bb0SF27JS+d855KX2zhcU/C9j+Qa+u7naQDR+krHgdBEXba+z
         /Q5fDCaJinCl8Y5Pt0J3LSHyy4IHtJV3jceUfmXe1CMo/9m0xieBDdCgTEWzyqT933ZR
         nEwCxMl0fMP34bykC09aAXUqRCy4UNBojyxCKNac4/ZbN5iNyKhE7Ju9u1xG0moeNDT9
         QhDPg/QV5H8sbe2MRiETcvpFN9MJQIQzhr07bvbQ7iA4zTslFQHz6vZDGFwprNkevhWG
         8nRth7fG7GI4C3QlO2AQYOpJdxA6v8HSfYoZlJDVlz4nBT+Q8qt1FAy1XwHGONDeNMkb
         h55Q==
X-Gm-Message-State: AOAM530AfSjWmD1MaSezdvspULfw4ewVCwAIA4/xFNyiEK4ZjmsIAfFy
        LzXjH4k2VDytdvWoVRg53Vc=
X-Google-Smtp-Source: ABdhPJwi26T/bFyZSn5a24FWNIWE9zKYikA4yp9xU3ztfjTTFZ7dwYe5bUTfzmr1mV9smqYcmxRFzg==
X-Received: by 2002:a17:90a:4308:: with SMTP id q8mr22050183pjg.78.1621825800731;
        Sun, 23 May 2021 20:10:00 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 33/51] ncr53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:38 -0700
Message-Id: <20210524030856.2824-34-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ncr53c8xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index c76e9f05d042..09958f78b70f 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4164,8 +4164,8 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 	**
 	**----------------------------------------------------
 	*/
-	if (np->settle_time && cmd->request->timeout >= HZ) {
-		u_long tlimit = jiffies + cmd->request->timeout - HZ;
+	if (np->settle_time && scsi_cmd_to_rq(cmd)->timeout >= HZ) {
+		u_long tlimit = jiffies + scsi_cmd_to_rq(cmd)->timeout - HZ;
 		if (time_after(np->settle_time, tlimit))
 			np->settle_time = tlimit;
 	}
