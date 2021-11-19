Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D0DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B35610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhKSUB0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:26 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:39653 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbhKSUBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:18 -0500
Received: by mail-pg1-f173.google.com with SMTP id r5so9522341pgi.6
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NpmGtVZCN0eh/5cVUgS8lSbtT/POAC/Ec5Ht56f9MCA=;
        b=05p8grfjKv6zC8wH3z9vc7lfFnFIFoPQX5Rhce0+M+VR/aA+NK2LP5WKHGXd/6Td9V
         YLcuhZGwGzaSsjnMvK+uDxCw3dCs8Y1MmRxxEEdRT0ZaJpbU5mTify40fgNoEGdmdB4m
         aUPbCi7JP0gz16/kMUYg23fGCbDmjcRNFkivdXW8nY7+Z8bpggIBg/GVwz2TeFjt+NBX
         NXFo40B7NcmRwqpmk2MViBH1gtZv6uA0AqwSq4P9NXDn/QuF9nSdVEytsMJpDJoH83B8
         FHUvqE2gkl39e8I0a17AYc8acKfr0rlB+tQrgLjOV5Yuz7Wc7KAwNuCe0MDSdaYLDIr1
         6sWg==
X-Gm-Message-State: AOAM533vlR+zotkuOznKePeAYYabQQWZHfDpNI22UeaKOF/a+vY5p8bY
        GE+uhp2l3t8kSxykHLlaxzU=
X-Google-Smtp-Source: ABdhPJwonBWtCofDPsV+vGsyinrRBQqDroICb5ugA46WFc/s4sZXwH8C0PS1Ftl3pYub6JOAvURRHw==
X-Received: by 2002:a05:6a00:234a:b0:49f:c0f7:f474 with SMTP id j10-20020a056a00234a00b0049fc0f7f474mr25569628pfj.64.1637351896264;
        Fri, 19 Nov 2021 11:58:16 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:15 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 10/20] scsi: ufs: Remove dead code
Date:   Fri, 19 Nov 2021 11:57:33 -0800
Message-Id: <20211119195743.2817-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag
conflicts") guarantees that 'tag' is not in use by any SCSI command.
Remove the check that returns early if a conflict occurs.

Acked-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ff9532968ae7..fced4528ee90 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6730,11 +6730,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	tag = req->tag;
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		err = -EBUSY;
-		goto out;
-	}
-
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
@@ -6802,8 +6797,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
-out:
-	blk_mq_free_request(req);
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
