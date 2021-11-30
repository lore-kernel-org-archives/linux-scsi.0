Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B85C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240900AbhK3Xhc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:37:32 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:35587 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241065AbhK3XhU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:37:20 -0500
Received: by mail-pl1-f177.google.com with SMTP id b13so16220824plg.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:34:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2NcKKuNFXDrVoNqJibcOxzYNgtrcA0XwNPYkrUXSc+8=;
        b=bgB8rMnH++ln5qChWQT77mzTXTT8tB4KuUblUCVv2AR/W+lROMuhSjJ3hqkDWlMNji
         Kr65n1ksp9UDzlD5aPLe5gw0VL1f0wRjxcWsWJMu3Jnp4ljcxLwP+G4Dzbbg9RUTvAAb
         XIi9J2AfFVs+ih3ZbXmeO2OkRKG4/lNkBF21sM6/RvD3g6uhJDAhaL1/vfXlIWb6KXta
         omDYmzkIZc/SGU8uANDqTxDWCREOM5Og0qiWtoMc7szCprAQmwJcu4etTuqb0iYs0JJC
         1XTHB7F54mzNwrKFmEPKNxsx2ZAevqB1AIoR2NrR3r8vUHV3XDRGUEfufSlH/7aa8RcG
         gohA==
X-Gm-Message-State: AOAM533lFzI/J7sBTvdHtjBdcOmYcsC1ou9grqa6mIAkNr/CER0VjsCD
        xhwyaOG1XJM0yrVIEZAflbk=
X-Google-Smtp-Source: ABdhPJxVDvum3oCTIBYHML/nvLksNERCX/QiYwN6y6tsZ4SnHzStUXCRyeYz/clD+6/r4TKHGj4Kxg==
X-Received: by 2002:a17:90b:4b90:: with SMTP id lr16mr2751323pjb.57.1638315239764;
        Tue, 30 Nov 2021 15:33:59 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:33:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 06/17] scsi: ufs: Remove dead code
Date:   Tue, 30 Nov 2021 15:33:13 -0800
Message-Id: <20211130233324.1402448-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
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
 drivers/scsi/ufs/ufshcd.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 973b7b083dbe..d4996ada55b6 100644
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
@@ -6802,8 +6797,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
-out:
 	blk_mq_free_request(req);
+
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
