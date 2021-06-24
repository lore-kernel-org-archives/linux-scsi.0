Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972F6C49EA5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 23:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EDAC6120D
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 23:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhFXXcm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 19:32:42 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:47030 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbhFXXcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 19:32:39 -0400
Received: by mail-pj1-f44.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso4437015pjp.5
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 16:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DQMLp+HnEG2+R8dlVEUu7JtNdIIc4u/G0aNKz7uvA6Q=;
        b=uIMdswTasCu0Mvnud2x32OrS18hMdcpj6+wDDOOaDG56sFnmPyL03spVQLh2Ea17zw
         vF1WXjeTLGNk489uHxBTwCuMBZwzziwVChKDsQ0l0kFzA2IC8OfC53T4xYAb/s34mXq0
         pYdFH+YEnAhXPSTjkHv0EuY5UWLxTQQmI6tX//bgRdiRszYN/j9KlAbwJ1bNJw3H6pvx
         6N17MsjQSl0J4rKq3F1PI85TUe5PCaJKfHtsjFAB4n24E3p8YPrQ9dKbPgPaPlsGMwID
         Bq6XSMwk7YpN0EzSVxTOGzRHV1BvAnEjvZoqjSMDeKq6EzWRocJxSVqQm4MsFXz25Mut
         BVrg==
X-Gm-Message-State: AOAM532lDj32M9HkH5yDkSqahzDAt8IUI4ECaQJ8+BeWWrSY8LrmuzTB
        Zv0fD1npyily2SxjC+sXFiY=
X-Google-Smtp-Source: ABdhPJyhxl14PPDsWGT8TgVUVKZukmvUvpMlafkrv0MzsSC+TtJDg54SXkdZgShHqIlC1mjGXMjdng==
X-Received: by 2002:a17:90a:7641:: with SMTP id s1mr7941616pjl.84.1624577418098;
        Thu, 24 Jun 2021 16:30:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j16sm3599908pgh.69.2021.06.24.16.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 16:30:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Gilad Broner <gbroner@codeaurora.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Dolev Raviv <draviv@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 3/3] ufs: Remove ufshcd_valid_tag()
Date:   Thu, 24 Jun 2021 16:29:57 -0700
Message-Id: <20210624232957.6805-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624232957.6805-1-bvanassche@acm.org>
References: <20210624232957.6805-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_add_host() allocates shost->can_queue tags. ufshcd_init() sets
shost->can_queue to hba->nutrs. In other words, we know that tag values
will be in the range [0, hba->nutrs). Hence remove the checks that
verify that blk_get_request() returns a tag in this range. This check
was introduced by commit 14497328b6a6 ("scsi: ufs: verify command tag
validity").

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Gilad Broner <gbroner@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 40 ++++++---------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fb493533c034..64a24fb7da27 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -253,11 +253,6 @@ static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
 static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
 
-static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
-{
-	return tag >= 0 && tag < hba->nutrs;
-}
-
 static inline void ufshcd_enable_irq(struct ufs_hba *hba)
 {
 	if (!hba->is_irq_enabled) {
@@ -2701,21 +2696,11 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
  */
 static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
+	struct ufs_hba *hba = shost_priv(host);
+	int tag = cmd->request->tag;
 	struct ufshcd_lrb *lrbp;
-	struct ufs_hba *hba;
-	int tag;
 	int err = 0;
 
-	hba = shost_priv(host);
-
-	tag = cmd->request->tag;
-	if (!ufshcd_valid_tag(hba, tag)) {
-		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
-		BUG();
-	}
-
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
@@ -2968,7 +2953,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 	tag = req->tag;
-	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		err = -EBUSY;
@@ -6675,7 +6659,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 	tag = req->tag;
-	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		err = -EBUSY;
@@ -6978,25 +6961,14 @@ static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
  */
 static int ufshcd_abort(struct scsi_cmnd *cmd)
 {
-	struct Scsi_Host *host;
-	struct ufs_hba *hba;
+	struct Scsi_Host *host = cmd->device->host;
+	struct ufs_hba *hba = shost_priv(host);
+	unsigned int tag = cmd->request->tag;
+	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
-	unsigned int tag;
 	int err = 0;
-	struct ufshcd_lrb *lrbp;
 	u32 reg;
 
-	host = cmd->device->host;
-	hba = shost_priv(host);
-	tag = cmd->request->tag;
-	lrbp = &hba->lrb[tag];
-	if (!ufshcd_valid_tag(hba, tag)) {
-		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
-		BUG();
-	}
-
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* If command is already aborted/completed, return SUCCESS */
