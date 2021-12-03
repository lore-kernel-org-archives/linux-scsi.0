Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62DB0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376773AbhLCXX6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:23:58 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:42569 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376419AbhLCXX5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:23:57 -0500
Received: by mail-pf1-f172.google.com with SMTP id u80so4266776pfc.9
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:20:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XzOn4f/acWOzRXs1p+hJdHukOKqsYgZHwz6SxIy9I7U=;
        b=t+KABHF4zkQvN5Ar38ZChTp1Z/eqm0YLND10xiEO5sp2Noc7/6Bs3RIcrZfQjpr3CL
         R/0fWNJx8g85UNW8D/3bO0QOB8mx1XCiQLOJASiNADv0senxkSYVAbcqWsvx8s9/Hd5c
         +l7lQuK+X+q/P6OIsPEmTnqTDAqwO4R+ZSx2U57bZ1nNHf9mVsVrpDLsloilcE4gswxm
         aXirUAMZSO9Li9U+DGG+ZPtOtMWNh+Bx+0W6i9vJ+zhD5m0c/6XGWhfXylbodeq+/eL+
         AVTOXpiL1hmOC15mImrao8TEWo2ytiB88fAPdwvTr1z1uvpXp0PcYljXJkR0j6BLc4kL
         FHgQ==
X-Gm-Message-State: AOAM533zNCt8A1wmkzjFdil4dL4FbgG4CSlT5tEkoEpr3qQONKs7UN7s
        XUylNt85REue+nRrtJXHNns=
X-Google-Smtp-Source: ABdhPJw8twbCrFh3aDVYKZoPxDR5Hh3sIYlQxMsvVdBZ7dZ8SUf5eF5m0PdCb7FUedzGSIneWNAtzg==
X-Received: by 2002:a63:914c:: with SMTP id l73mr6911480pge.184.1638573633199;
        Fri, 03 Dec 2021 15:20:33 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:20:32 -0800 (PST)
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
Subject: [PATCH v4 05/17] scsi: ufs: Remove dead code
Date:   Fri,  3 Dec 2021 15:19:38 -0800
Message-Id: <20211203231950.193369-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
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
Tested-by: Bean Huo <beanhuo@micron.com>
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
