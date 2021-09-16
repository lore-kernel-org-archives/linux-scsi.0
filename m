Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AE1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 17:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 728F260EE3
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 17:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbhIPRyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 13:54:45 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:34325 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356745AbhIPRuq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2021 13:50:46 -0400
Received: by mail-pf1-f172.google.com with SMTP id g14so6668413pfm.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2021 10:49:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQRlEvE1hxMByE9eyd22BigeX+yU/xBwnUsgebSZMOk=;
        b=HDuXBmrhCMq5D03jSkRUlwzMoE4uRGs4tr/q386rvOOxiehkgZCiMENKtG30s8CI9h
         YDmaqfjUklIpgeIqBt//1RnEqD9r18PVC9c5Tm5S7s4zoy9tcfI+lNHUZOMcXe4TTGeU
         m1HTx2Oz3B6bFDNpOZrxBpfHfXETNRYxrT8erBRftVGF1o1x2L/yOUq4t2h2pZstJFEP
         h0mVz2y8+Ml/Bl1wFSuIW+hVpS9MKujdpDy6+YoZAxu7GmT1j5lHhfbak3dS/DVaJ7/W
         xUtRaaYYiv0g6P27gKboQ+Scf9HIZ15TW4Njpm0RMwYC6p1Qf7BJ7BVegrCF451bNGQl
         Gt0w==
X-Gm-Message-State: AOAM5313fydOsmDNKyDcVYDAdjR7k8dZXKbkefRe3Di4a5gccxLyfuU+
        cDN8Hlpr64dkq2hIQ0knHus=
X-Google-Smtp-Source: ABdhPJzIFzZ5P7DQZsgPaIpMnZ+TGQ+fHwo4gkVLWyqAoFLT9KHHbRIWNqWqyPTwaXjgQAu7lwHPCw==
X-Received: by 2002:a63:a517:: with SMTP id n23mr6008360pgf.412.1631814565032;
        Thu, 16 Sep 2021 10:49:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:72bb:5072:e839:3844])
        by smtp.gmail.com with ESMTPSA id r2sm4263485pgn.8.2021.09.16.10.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 10:49:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] scsi: ufs: Unbreak the reset handler
Date:   Thu, 16 Sep 2021 10:49:08 -0700
Message-Id: <20210916174914.2259122-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A command tag is passed as the second argument of the
__ufshcd_transfer_req_compl() call in ufshcd_eh_device_reset_handler()
instead of a bitmask. Fix this as follows:
- Pass a bitmask as argument instead of a command tag.
- Report the command as aborted instead of requeuing it.
- Instead of giving up if clearing a command fails, iterate over all
  commands.

Cc: Can Guo <cang@codeaurora.org>
Fixes: a45f937110fa ("scsi: ufs: Optimize host lock on transfer requests send/compl paths")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..d1dc52c76847 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6876,7 +6876,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			__ufshcd_transfer_req_compl(hba, pos, /*retry_requests=*/true);
+			__ufshcd_transfer_req_compl(hba, 1U << pos, false);
 		}
 	}
 
