Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EB8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FD1D6121E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhJTVnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:43:19 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:38494 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhJTVnS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:43:18 -0400
Received: by mail-pj1-f44.google.com with SMTP id n8-20020a17090a2bc800b00196286963b9so1553655pje.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KTE3wXfAj3/bfGh/UCC5HhreHQlaIJPsagYymtFF0qU=;
        b=iuL58qCEWCHslVa2C9Yg7IZwsbmb9qYIYTxXW/PYkRzOaod/mviNuPVB9vCWYbO9Ud
         0m4gBofiH4gPszt8ZsX7sVTDg1nzY6b6iLu8uk3X1SE/D6I1ra66IjSm9TjDSd7tk6vu
         ax1FqMya0v+ZIKrAf7PaKZjShby3iB/2lsKtLNxhWqzg8bi42SBfllE0VOJ0tcrwxddK
         rtiFej+3b4vpdNiHjZj/yJdg4j7+5pmujak8ekKEZmqRssOZks86MKbEy6ekcVoZsDEA
         Ai/VyglwE6fIvIZU7y3nO7inPIRksA1eeYFVD65FmdRUKyeRfNOwYisjm2lbbTAB4be7
         sn+Q==
X-Gm-Message-State: AOAM532tg5ph5TAZEA3ON8aXoova415YGixbTmi+djgURmEMGkthVBb2
        WUCwzbKj/EckZwT0unzWOLs=
X-Google-Smtp-Source: ABdhPJxvyTxc/4CVlOzrmvPTYY/i8fxt8BTRvd/SqL4uizGWTXVgam8ujYevTI1lvjXaTkB4DqO+hw==
X-Received: by 2002:a17:90b:1041:: with SMTP id gq1mr1605206pjb.31.1634766063758;
        Wed, 20 Oct 2021 14:41:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:41:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v2 05/10] scsi: ufs: Export ufshcd_schedule_eh_work()
Date:   Wed, 20 Oct 2021 14:40:19 -0700
Message-Id: <20211020214024.2007615-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
References: <20211020214024.2007615-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it possible to call ufshcd_schedule_eh_work() from other source
files than ufshcd.c. Additionally, convert a source code comment into a
lockdep_assert_held() call.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 drivers/scsi/ufs/ufshcd.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 49623bf3e876..0739aa566725 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -244,7 +244,6 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
-static void ufshcd_schedule_eh_work(struct ufs_hba *hba);
 static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on);
 static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
@@ -5915,9 +5914,10 @@ static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
 	       (hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK));
 }
 
-/* host lock must be held before calling this func */
-static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
+void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 {
+	lockdep_assert_held(hba->host->host_lock);
+
 	/* handle fatal errors only when link is not in error state */
 	if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
 		if (hba->force_reset || ufshcd_is_link_broken(hba) ||
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 64ce723327b9..3f5dc6732fe1 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1023,6 +1023,7 @@ int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
 void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk *refclk);
 void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val);
 void ufshcd_hba_stop(struct ufs_hba *hba);
+void ufshcd_schedule_eh_work(struct ufs_hba *hba);
 
 static inline void check_upiu_size(void)
 {
