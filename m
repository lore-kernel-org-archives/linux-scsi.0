Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6BDC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E15052080C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600203277;
	bh=d1coarY+kYt3CCUrBHh62z5mGDhyA+XvBeFtxID2pGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Zsry8UApFLwmPTTUJB5z8EIU8jjB5aJhEE8mLEqUHD0t+jZQnT9Os/gSJ5gtfwsBk
	 PwyU9WcFV84mWpd62zs+np5mHeMQZuLyLNOO2Tm9/gyt7I6b4SQuZObn+n1cH78cCH
	 VfYoYxHREAVISWocg8qI4ZA8sBTeQRtUWX+IW95E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgIOUyQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 16:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727861AbgIOUqh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 16:46:37 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C53DD20936;
        Tue, 15 Sep 2020 20:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600202796;
        bh=d1coarY+kYt3CCUrBHh62z5mGDhyA+XvBeFtxID2pGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xr8SluegS6UFjDnRpW/eqYJKEKHp5AEwAjkKRdYO08kzM4/klo8niX2DcQe4Zss2c
         /pDVZNXyll/QpGFYJTmky/I8GRlEj9rr9tP/57W6H9SfvBbFCxfWh8x5XGQLItcKvy
         s2Cr/rv/S23NegqGZTb2Ysq/QYz3mnFuwwlNTkEg=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/6] scsi: ufs: clear UAC for FFU
Date:   Tue, 15 Sep 2020 13:45:28 -0700
Message-Id: <20200915204532.1672300-2-jaegeuk@kernel.org>
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

In order to conduct FFU or RPMB operations, UFS needs to clear UAC. This patch
clears it explicitly, so that we could get no failure given early execution.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 41 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d929c3d1e58cc..5deba03a61f75 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7385,6 +7385,45 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	return ret;
 }
 
+static int
+ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp);
+
+static int ufshcd_clear_uac(struct ufs_hba *hba)
+{
+	struct scsi_device *sdp;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	sdp = hba->sdev_ufs_device;
+	if (sdp) {
+		ret = scsi_device_get(sdp);
+		if (!ret && !scsi_device_online(sdp)) {
+			ret = -ENODEV;
+			scsi_device_put(sdp);
+		}
+	} else {
+		ret = -ENODEV;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (ret)
+		goto out_err;
+
+	if (hba->wlun_dev_clr_ua) {
+		ret = ufshcd_send_request_sense(hba, sdp);
+		if (ret)
+			goto out;
+		/* Unit attention condition is cleared now */
+		hba->wlun_dev_clr_ua = false;
+	}
+out:
+	scsi_device_put(sdp);
+out_err:
+	if (ret)
+		dev_err(hba->dev, "%s: Failed UAC clear ret = %d\n", __func__, ret);
+	return ret;
+}
+
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
@@ -7500,6 +7539,8 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 		pm_runtime_put_sync(hba->dev);
 		ufshcd_exit_clk_scaling(hba);
 		ufshcd_hba_exit(hba);
+	} else {
+		ufshcd_clear_uac(hba);
 	}
 }
 
-- 
2.28.0.618.gf4bc123cb7-goog

