Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CA2C05027
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 20:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCNU6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Mar 2023 16:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjCNU6e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2023 16:58:34 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153BC22CA7
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2023 13:58:33 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id x11so17919927pln.12
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2023 13:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678827512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+iEwKs38qVEIWRs4AnDpSDFcrFdOmxuMiJcx4NiH1w=;
        b=YgBa1Gr/huVqj16GNHrKT+Ejqmup2WKYsAzgij1Lv7FLl7/3Q+3RSyRzjVmop/7TQq
         c33NHq/qBhmaLrn91co6kdW/TXkf3AIGkmycLhPFPLDGpVO6y7hSzu7gS3X2VlF+lSIZ
         VZdM42YaN+s28GqaWlH16N9QuwfybLl7B1Si6NaxU39SRC/JX9c3vVMVfFMJOICfKhVv
         Caq7KXClRZZhYPdY3b9Ufuc9RPlBnGFITKPMWO8gvnWpU3wleet5P4aUXviklPOsYJUI
         +JjWFLd4Wrr4Ri0ydCEiO5fWBM7FzIvhVXLyEZoMUxf2aNnGfrwdL3MI6D7VlJEMctKL
         3pyg==
X-Gm-Message-State: AO0yUKVdwznqw88ylAb3X4lgHDeQX+ZOCKXaNJTo186sCUqIJliXOcHO
        +W1fjPw126Abt+M+taKSjq8=
X-Google-Smtp-Source: AK7set98j0B7bhbr203IBgJRKBqiN0Hu5X9aV7AlCl1RiiTuHyFsoLlAdZxvCCnkzySx+RX/lphXrw==
X-Received: by 2002:a17:90a:f3ca:b0:23d:3a3f:950b with SMTP id ha10-20020a17090af3ca00b0023d3a3f950bmr3052732pjb.22.1678827512408;
        Tue, 14 Mar 2023 13:58:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:558a:e74:a7b9:2212])
        by smtp.gmail.com with ESMTPSA id x14-20020a17090a530e00b002348d711ebbsm2153386pjh.16.2023.03.14.13.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:58:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Date:   Tue, 14 Mar 2023 13:58:12 -0700
Message-Id: <20230314205822.313447-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Neither UFS host controllers nor UFS devices require a ten second delay
after a host reset or after a bus reset. Hence this patch.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 172d25fef740..ce7b765aa2af 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8744,6 +8744,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.max_sectors		= (1 << 20) / SECTOR_SIZE, /* 1 MiB */
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
+	.skip_settle_delay	= 1,
 	.sdev_groups		= ufshcd_driver_groups,
 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
 };
