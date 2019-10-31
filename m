Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92203CA9ECE
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 22:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7008820862
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 22:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfJaWzl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 18:55:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32873 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbfJaWzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 18:55:40 -0400
Received: by mail-pl1-f194.google.com with SMTP id y8so3431645plk.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2019 15:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2sp5hWX8cM1VYWqXk5IDcMfjtFajr2AWpOWYZwhDLQo=;
        b=qByHe3zej3c2dOJndfsLepNGylh3h5NRUG9FcQYZ6m+CHPZN0F673/rgmrSH6O/elT
         dhoK/+CKYE3TLElwXAXMhN4k2UtpYRJ8R+50syzC+5aYWISDPEs2e/bl7ElDLvSIgfjc
         9bqg8bPnWKWl6XcbxdMFNdwT/9i/hRJ4PVdmKpnJ9666WuBY7z3/ZUva4K1B44cNkJz6
         Bbb3rWn7LaDueh+sIzm/5SiMe30AvJuv18IMna0wOyA5+nK6j8Aql/dvn4iBkZFbZelM
         09nkCnpOktJEsGLdKfwxL3fXfq9so12fxxl2xA8xOuKzV0/8aASwdkgzABXdcL8fWzPc
         tzMw==
X-Gm-Message-State: APjAAAUbUkvOTmfnJyuCxLZoRweMe5VrZopOdxYTr7j5gvaCYBH5N3sY
        cJ3GDLeG1yAGYCQNL+cRMKE=
X-Google-Smtp-Source: APXvYqyhN3jgEeslL8qj4BgDolHUEgIqP9iEEgHrCXqhYznqsyu4iV40hCwP6A73eiCHUOaWpW95gA==
X-Received: by 2002:a17:902:44d:: with SMTP id 71mr8668947ple.274.1572562540055;
        Thu, 31 Oct 2019 15:55:40 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id d139sm8391711pfd.162.2019.10.31.15.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 15:55:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Gilad Broner <gbroner@codeaurora.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/4] ufs: Remove superfluous memory barriers
Date:   Thu, 31 Oct 2019 15:55:28 -0700
Message-Id: <20191031225528.233895-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191031225528.233895-1-bvanassche@acm.org>
References: <20191031225528.233895-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calling wmb() after having written to a doorbell slows down code and does
not help to commit the doorbell write faster. Hence remove such wmb()
calls.

Cc: Gilad Broner <gbroner@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8c969fab5d92..ace929df7bab 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1864,8 +1864,6 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	/* Make sure that doorbell is committed immediately */
-	wmb();
 	ufshcd_add_command_trace(hba, task_tag, "send");
 }
 
@@ -5598,8 +5596,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	wmb();
 
 	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
-	/* Make sure that doorbell is committed immediately */
-	wmb();
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
-- 
2.24.0.rc0.303.g954a862665-goog

