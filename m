Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBB4C3F68F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7477F22525
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hOX7AWby"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgATNJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:09:46 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36785 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgATNJp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 08:09:45 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so29523347wru.3;
        Mon, 20 Jan 2020 05:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0nfogaZM2dNL7CJVNT5K6skef+A5vufAFs1oVF/aB60=;
        b=hOX7AWbyIAm8dos332hRD1BCIr8emfGDM3Z50AZGqgs0WJi6vfOTza9cctYVTXhX/E
         gjdPlMUHM1fM0CGjyW3L9Pj61b2HnfPoiKrtzA8sp7qees56oYKnZ8TElrIhgMDE+cGv
         7qxo8gZbcqugFS//1mB6fcpy0fk62IQJJcuJmvpCPC6l02qEjFWpb3W2q/FeUK+8CzKN
         zLsidXl8ub3PNgUIojdbAuCiCmBh8ShS6KxXqE8azAwRo2hvSTvT4rgStvl8pmi9E+bB
         v+1eCN5V+6DKE+Mdf/DN1KUvydELvqYOY3ES/aCZ5MKTkxDkHAxM7CCNP6pDUijiI0oK
         eqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0nfogaZM2dNL7CJVNT5K6skef+A5vufAFs1oVF/aB60=;
        b=fhbzXHuwKzD28wsgeXgXtYW/kkXKOLCHm4E1DK4tCQJSinfba8cpjuFl2YlMh8b0Fr
         iogyj4/awQHZf+PcYY3CrTEnV3V1lm8x9NsoNsH5640GmMSCj+WeqegZSZWCTb3t+XIx
         OJZEvAiPls+pShJ1odOeL206VUIAwh79SjivlkQphTi9lO/a+hny8GDQStaX1d37hlrC
         9qFUKLoDg2vVT0c0s5nH4nYmgY7ATyMI9wlSxTj15OLaWOvkIhz74lqbno7Jbt+lFll6
         xejnQCGTdbF6QrCJWKOSHIeYihh1LYcEMEXb89vMeIbQjMN1uMfje2Lu77JT2E35IqUL
         lfnQ==
X-Gm-Message-State: APjAAAVcvN1swWWR0boYP5mU9RjLd22Yj3Qi6QtROc9fPvnvrE61bUOH
        bkyB2vMPffxt2PkxiJr84Qg=
X-Google-Smtp-Source: APXvYqwQu61/jfEBPX1pApD1AvgjEKGFspoBGXvW4gOm62cY1uR6+/MzTJ7kO39Hmr69/VrjSG7WqA==
X-Received: by 2002:a5d:448c:: with SMTP id j12mr17820821wrq.125.1579525783483;
        Mon, 20 Jan 2020 05:09:43 -0800 (PST)
Received: from ubuntu-G3.micron.com ([165.225.86.138])
        by smtp.gmail.com with ESMTPSA id p18sm23065386wmb.8.2020.01.20.05.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:09:43 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/8] scsi: ufs: Move ufshcd_get_max_pwr_mode() to ufshcd_device_params_init()
Date:   Mon, 20 Jan 2020 14:08:16 +0100
Message-Id: <20200120130820.1737-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200120130820.1737-1-huobean@gmail.com>
References: <20200120130820.1737-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

ufshcd_get_max_pwr_mode() only need to be called once while booting, take
it out from ufshcd_probe_hba() and inline into ufshcd_device_params_init().

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 935b50861864..5dfe760f2786 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6959,6 +6959,11 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 			QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 		hba->dev_info.f_power_on_wp_en = flag;
 
+	/* Probe maximum power mode co-supported by both UFS host and device */
+	if (ufshcd_get_max_pwr_mode(hba))
+		dev_err(hba->dev,
+			"%s: Failed getting max supported power mode\n",
+			__func__);
 out:
 	return ret;
 }
@@ -7057,11 +7062,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	ufshcd_force_reset_auto_bkops(hba);
 	hba->wlun_dev_clr_ua = true;
 
-	if (ufshcd_get_max_pwr_mode(hba)) {
-		dev_err(hba->dev,
-			"%s: Failed getting max supported power mode\n",
-			__func__);
-	} else {
+	/* Gear up to HS gear if supported */
+	if (hba->max_pwr_info.is_valid) {
 		/*
 		 * Set the right value to bRefClkFreq before attempting to
 		 * switch to HS gears.
-- 
2.17.1

