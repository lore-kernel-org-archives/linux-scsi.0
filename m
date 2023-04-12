Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC02C7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 20:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjDLUki (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDLUki (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 16:40:38 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5A44EC5
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:40:37 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id mn5-20020a17090b188500b00246eddf34f6so5197745pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681332036; x=1683924036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H9HN99QwsksXCBCaVQ2bJ/Ic4jm/KkGkP0u89WLoXno=;
        b=i9LTYru/cOV8Rp+nAgJSX+nzEx2Nfy+XgQgoXwl4hZiFYsHhw5F52ffceJ/BDqJ4Hf
         hz1dR4hg2Iqp2h+Htzr763DSkoYEtWyOT7yae5DyWSLpr7L5n42V1DvAT9LRePjGAHSp
         JFqh/TM/cTzioTveQxIufoIIGrvY8KnRzSYaXAjJaq7RfJXTVEFrGqcgRcSmLSBiwWDS
         JbRSovGUUFmG6B3Vqsby6gDXeSq+9TKfTU7uJbex9QOSov9j1FIHaoPy0n+iGrlJK+r7
         F1PX2od6mxv+Ax/Oo8118K7N7aXDsFVdjdOsMrT5sydBWzjG6oebdad9ZsdzCrw+6pOB
         QTQw==
X-Gm-Message-State: AAQBX9fqQ5sQJFuVedi1AmqyfIVHhJPc/+svZgJ3JBYMeIKJbhzx+rlX
        PnVNuuSZuh7IZW3Yg20qh+Y=
X-Google-Smtp-Source: AKy350akZ6NqSoEzlzqbm3jNEMe38GwVYuOBXZggYJoN8pjjhMjhJD+ujMc9wGC5WDx8oBT3/NokTA==
X-Received: by 2002:a17:902:b28b:b0:1a5:898:37a8 with SMTP id u11-20020a170902b28b00b001a5089837a8mr199789plr.18.1681332036300;
        Wed, 12 Apr 2023 13:40:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d89d:35dd:5938:1993])
        by smtp.gmail.com with ESMTPSA id t4-20020a170902b20400b001a4fecf79e4sm25114plr.49.2023.04.12.13.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 13:40:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH 2/3] scsi: ufs: Simplify ufshcd_wl_shutdown()
Date:   Wed, 12 Apr 2023 13:40:19 -0700
Message-Id: <20230412204029.3222134-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that sd_shutdown() fails future I/O the code for quiescing LUNs in
ufshcd_wl_shutdown() is superfluous. Remove the code for quiescing LUNs.
Also remove the ufshcd_rpm_get_sync() call because it is not necessary
to resume a UFS device before submitting a START STOP UNIT command.

Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9434328ba323..784787cf08c3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9768,22 +9768,12 @@ static int ufshcd_wl_resume(struct device *dev)
 static void ufshcd_wl_shutdown(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ufs_hba *hba;
-
-	hba = shost_priv(sdev->host);
+	struct ufs_hba *hba = shost_priv(sdev->host);
 
 	down(&hba->host_sem);
 	hba->shutting_down = true;
 	up(&hba->host_sem);
 
-	/* Turn on everything while shutting down */
-	ufshcd_rpm_get_sync(hba);
-	scsi_device_quiesce(sdev);
-	shost_for_each_device(sdev, hba->host) {
-		if (sdev == hba->ufs_device_wlun)
-			continue;
-		scsi_device_quiesce(sdev);
-	}
 	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 }
 
