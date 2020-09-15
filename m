Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA64C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A7E620936
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600202842;
	bh=6CFCy86M8iz95yHuyD/L5TCOMJziCyBzC/IGpcbjHtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nkzp3H1T4XMuR9PITPfFO2HZFC+0R+SS8MWguEEd4uU1ltcLfMBG3IGq5UC5ByqBE
	 /kRKz3x836FRXyLrOOwBhRLvC3b7HDGsgr/yhUvtTqqVMpWSdnTMyQ7YnJ6pF8FEfZ
	 9oipnTi0ejZrzganmcNzEh1+ZvGfgmk3WXhbObPk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgIOUrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 16:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgIOUqq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 16:46:46 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F005D212CC;
        Tue, 15 Sep 2020 20:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600202798;
        bh=6CFCy86M8iz95yHuyD/L5TCOMJziCyBzC/IGpcbjHtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GKifIzuYRs4t0HlIw0zbNCbSPAjZYiQ7a9d2vmCClRZNhwYxxNsU1HFef/XwWOCt
         ABqxRgLbCrz4zdV30pebCDiEf+Q0R+Ir+rT/ew5Rk5dTmvtALfbh4m+5tHW1lzAtbf
         53kjfucWbMbCamWVUQ1xSog9J5Wow2CcBWb5iPUk=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 4/6] scsi: ufs: fix LINERESET on hibern8
Date:   Tue, 15 Sep 2020 13:45:30 -0700
Message-Id: <20200915204532.1672300-4-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200915204532.1672300-1-jaegeuk@kernel.org>
References: <20200915204532.1672300-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

When testing infinite test to read sysfs entries of UFS, I got a UFS timeout
with the following kernel message.

query: dev_cmd_send: seq_no=78082 tag=31, idn=2
query: ufshcd_wait_for_dev_cmd: dev_cmd request timedout, tag 31
query: __ufshcd_query_descriptor: opcode 0x01 for idn 2 failed, index 0, err = -11
 --  hibern8: dme: dme_send: cmd_id=0x17 idn=0
query: ufshcd_query_descriptor: failed with error -11, retries 3
 --  hibern8: ufshcd_update_uic_error: LINERESET during hibern8 enter
 --  hibern8: __ufshcd_uic_hibern8_enter: hibern8 enter failed. ret = -110

The problem is casued by hibern8 command issued by ufshcd_suspend(), which is
not aware of query command. If autohibern8 is enabled, we actually don't need
to issue hibern8 command by suspend.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 20 ++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h |  1 +
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 848e33ec40639..bdc82cc3824aa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3079,8 +3079,12 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 	int retries;
 
 	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
-		err = __ufshcd_query_descriptor(hba, opcode, idn, index,
+		err = -EAGAIN;
+		down_read(&hba->query_lock);
+		if (!ufshcd_is_link_hibern8(hba))
+			err = __ufshcd_query_descriptor(hba, opcode, idn, index,
 						selector, desc_buf, buf_len);
+		up_read(&hba->query_lock);
 		if (!err || err == -EINVAL)
 			break;
 	}
@@ -8263,8 +8267,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum ufs_pm_level pm_lvl;
 	enum ufs_dev_pwr_mode req_dev_pwr_mode;
 	enum uic_link_state req_link_state;
+	bool need_upwrite = false;
 
-	hba->pm_op_in_progress = 1;
 	if (!ufshcd_is_shutdown_pm(pm_op)) {
 		pm_lvl = ufshcd_is_runtime_pm(pm_op) ?
 			 hba->rpm_lvl : hba->spm_lvl;
@@ -8275,6 +8279,15 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		req_link_state = UIC_LINK_OFF_STATE;
 	}
 
+	if (ufshcd_is_runtime_pm(pm_op) &&
+			req_link_state == UIC_LINK_HIBERN8_STATE &&
+			hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT) {
+		need_upwrite = true;
+		if (!down_write_trylock(&hba->query_lock))
+			return -EBUSY;
+	}
+	hba->pm_op_in_progress = 1;
+
 	/*
 	 * If we can't transition into any of the low power modes
 	 * just gate the clocks.
@@ -8403,6 +8416,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 	hba->pm_op_in_progress = 0;
+	if (need_upwrite)
+		up_write(&hba->query_lock);
 
 	if (ret)
 		ufshcd_update_reg_hist(&hba->ufs_stats.suspend_err, (u32)ret);
@@ -8894,6 +8909,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	mutex_init(&hba->dev_cmd.lock);
 
 	init_rwsem(&hba->clk_scaling_lock);
+	init_rwsem(&hba->query_lock);
 
 	ufshcd_init_clk_gating(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 363589c0bd370..6f8e05eaf9661 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -754,6 +754,7 @@ struct ufs_hba {
 	bool is_urgent_bkops_lvl_checked;
 
 	struct rw_semaphore clk_scaling_lock;
+	struct rw_semaphore query_lock;
 	unsigned char desc_size[QUERY_DESC_IDN_MAX];
 	atomic_t scsi_block_reqs_cnt;
 
-- 
2.28.0.618.gf4bc123cb7-goog

