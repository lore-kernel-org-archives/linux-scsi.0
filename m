Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06634C433E7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 21:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A61B8218AC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 21:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602883110;
	bh=CuhQEC39RKXr50s9lMmLS4igWZ5Lm4KzACaFvg0MMN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Kb/A7cbbxj9pPGdMFm0R3A7jkooU3xsIpbbX6X7aEvXaENMbqMMEcYnvq0EmxtDIK
	 HSgTT0BPYVczyRVIVNeJOO3ABpkrN0PRU9qgds64epI43mb/rbKLym86zHjDoUx8+T
	 HU6pIgcUU20LhdD68j7lTgwktBV+K76jmWPEXH9s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411036AbgJPVS2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 17:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411029AbgJPVS1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Oct 2020 17:18:27 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C43C9214DB;
        Fri, 16 Oct 2020 21:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602883106;
        bh=CuhQEC39RKXr50s9lMmLS4igWZ5Lm4KzACaFvg0MMN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nu5amy4kimytW5LQR4av2fLy3ZdiHYo/m3kumHLjitvI2umRsmepwCCXqNxy8FpoY
         WnpVTHMzPbSoPPKLYHR67ctQwNWUqJVxaLytV1q37ISNIjh9K3b2rpxJVjYBsVw3LB
         NMpTN1pWKf7t+oAHObli37doSm432NWjHF212O7A=
Date:   Fri, 16 Oct 2020 14:18:26 -0700
From:   jaegeuk@kernel.org
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH v2] scsi: ufs: fix clkgating on/off correctly
Message-ID: <20201016211826.GA3441410@google.com>
References: <20201016060259.390029-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016060259.390029-1-jaegeuk@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The below call stack prevents clk_gating at every IO completion.
We can remove the condition, ufshcd_any_tag_in_use(), since clkgating_work
will check it again.

ufshcd_complete_requests(struct ufs_hba *hba)
  ufshcd_transfer_req_compl()
    __ufshcd_transfer_req_compl()
      __ufshcd_release(hba)
        if (ufshcd_any_tag_in_use() == 1)
           return;
  ufshcd_tmc_handler(hba);
    blk_mq_tagset_busy_iter();

In addition, we have to avoid gate_work, if it was disabled.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---

Change log from v1:
 - change the patch subject
 - fix clkgate.is_enable to work

 drivers/scsi/ufs/ufshcd.c | 5 +++--
 drivers/scsi/ufs/ufshcd.h | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a2db8182663d..75e8a76f20c7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1729,9 +1729,10 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended
 		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
-		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
+		|| hba->outstanding_tasks
 		|| hba->active_uic_cmd || hba->uic_async_done
-		|| ufshcd_eh_in_progress(hba))
+		|| ufshcd_eh_in_progress(hba)
+		|| ufshcd_is_clkgating_enabled(hba))
 		return;
 
 	hba->clk_gating.state = REQ_CLKS_OFF;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8344d8cb3678..09e59cb86e69 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -814,6 +814,11 @@ static inline bool ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
 		!(hba->quirks & UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8);
 }
 
+static inline bool ufshcd_is_clkgating_enabled(struct ufs_hba *hba)
+{
+	return hba->clk_gating.is_enabled;
+}
+
 static inline bool ufshcd_is_auto_hibern8_enabled(struct ufs_hba *hba)
 {
 	return FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) ? true : false;
-- 
2.29.0.rc1.297.gfa9743e501-goog

