Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD12C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2707611AD
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhKJAsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:48:09 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:44023 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhKJAsH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:48:07 -0500
Received: by mail-pg1-f173.google.com with SMTP id b4so621528pgh.10
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rzKl88Ka49hata7BwU6FTR9dOdQKrE4RB1z4nPi+Pbc=;
        b=4t/tLIuw/JO7Sw2yroPER1Rr7ngQOX6X0y9xjSCtgGtoFkQ6xYmtfW/K5U3/kdiso/
         IrYdZMrTAW3t68mxn9w7JU6aTD8vIhz4ysGgjVKZUldd5Ziprpx9gOCUjMydyYG4z9+3
         WRkc0d7M70YpDcQx75z1EClra1kiFK9hWILf/dLKsiR54AbzyIvcPCwC13fbXCslxgAa
         60s2Ery6kIpPT7slk+NITPIzt8eMen6w0KuhZW5hjjOXgI0HNlJYqWpEj/OamUHncK8p
         M4oFGddCnTmUAxIxBxZavIVxGalZlZKTXbsMm3M7BeYF1MNIqMbSiLw8KizhvPR2DnX0
         NG5A==
X-Gm-Message-State: AOAM532Zrk79JEFwybsGdlgKg9fiyzUDQJ6oQqxb+i7Md6V0wy5YWJYc
        Km4+9tKSF79rutjjqy6axag=
X-Google-Smtp-Source: ABdhPJxzM7njQCOa9pK4QLehOZKgin3NdTP4ZzNkZGPeyjzg3acOJDvFFyBXhPM3gFLn2ZnGsQnmtg==
X-Received: by 2002:a63:e214:: with SMTP id q20mr9248959pgh.442.1636505120506;
        Tue, 09 Nov 2021 16:45:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:20 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 04/11] scsi: ufs: Remove dead code
Date:   Tue,  9 Nov 2021 16:44:33 -0800
Message-Id: <20211110004440.3389311-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag
conflicts") guarantees that 'tag' is not in use by any SCSI command.
Remove the check that returns early if a conflict occurs.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dff76b1a0d5d..312e8a5b7733 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6724,11 +6724,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
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
@@ -6796,7 +6791,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
-out:
 	blk_put_request(req);
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
