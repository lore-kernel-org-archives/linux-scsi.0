Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7273AC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A538613C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhGIU37 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:29:59 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:35594 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhGIU37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:29:59 -0400
Received: by mail-pj1-f44.google.com with SMTP id h1-20020a17090a3d01b0290172d33bb8bcso8920830pjc.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZxG8FSjJ+H6UcHhqSpfKZ7Z8e5I0Em+SOZHonYacPSA=;
        b=iDpU/rl+Hv61iR5KHFP+iOOr0PHZG6GaBo4nM8kr2jIR5vEZbPqxNTwnOjShcizN+T
         g2PP0a1P9vh0Mn54gqGLhYIyGJfecrgrNPSblE8fkTXr1I4R5WR/ArDQFDRksxk2h5sq
         4fcJJayRsSR2yS/TQIX1UhD4MaMJv8n4RHa93hTjl/YtqWHtssbPvi5Y4bUJLytwrj9P
         yFp0Do8k1V4D6cqlZqbd+L7nbrG87ddLXhAvyPOT4rStfBWaX7y66mF9wHJMa1LTDUXl
         RmmMgZ0o4cJN+gE22eS7s6EtKMjiqvNYQ90DJIOZOtIJ2Pfafk5TWqMNJH3X/0bCpj9z
         G9mQ==
X-Gm-Message-State: AOAM533AgfTTT1dDVWoPMlAY4dep4OpJjJ9BMKGrGwHFkK0QYjRehFX4
        kpxIG0H+ne+82JLpvwMqas4YXzThYaI=
X-Google-Smtp-Source: ABdhPJyEMon6ClKtaWNSxExqmifPvG3Y8t+wBSYMVjSXeEiwsJTNZOEJuu1PwNETbtZpYCp7/Ad+aw==
X-Received: by 2002:a17:902:a60f:b029:129:b2dc:e921 with SMTP id u15-20020a170902a60fb0290129b2dce921mr17186674plq.11.1625862435458;
        Fri, 09 Jul 2021 13:27:15 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 06/19] scsi: ufs: Remove ufshcd_valid_tag()
Date:   Fri,  9 Jul 2021 13:26:25 -0700
Message-Id: <20210709202638.9480-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_add_host() allocates shost->can_queue tags. ufshcd_init() sets
shost->can_queue to hba->nutrs. In other words, we know that tag values
will less than hba->nutrs. Hence remove the checks that verify that
blk_get_request() returns a tag less than hba->nutrs. This check
was introduced by commit 14497328b6a6 ("scsi: ufs: verify command tag
validity").

Keep the tag >= 0 check because it helps to detect use-after-free issues.

CC: Avri Altman <avri.altman@wdc.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 42 ++++++++++-----------------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2148e123e9db..fa52117fdb3e 100644
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
@@ -2701,20 +2696,12 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
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
+	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -2968,7 +2955,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 	tag = req->tag;
-	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
+	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
 	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		err = -EBUSY;
@@ -6673,7 +6660,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 	tag = req->tag;
-	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
+	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
 	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		err = -EBUSY;
@@ -6975,24 +6962,15 @@ static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
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
+	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
