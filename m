Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505E6C77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 23:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjDQXHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 19:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDQXHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 19:07:14 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999F12D60
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 16:07:13 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-63b5312bd4fso6255708b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 16:07:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681772833; x=1684364833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9HN99QwsksXCBCaVQ2bJ/Ic4jm/KkGkP0u89WLoXno=;
        b=acUg7ih28MAGEZ48i94sR7gD+v3UOxRbefZ0gAdGSbUCD1RHsAnY0ff1duxIEcQ4+y
         +hjzCJkyiI4LXS2JyJqk3zUcZKzwMDMzj/v+YcDoXFF1kNlpGEVa3v/zJDiwmdOHQX0C
         pNfT4Z9UmDHTrkgpmKTBCZOuo1B24xzlMgZVqg38gjk6/vRJEu3gEXT48/EtjYJH1Yro
         zMj1aN6pHN2rXFYLad4pY1RtXVwHIKPdix0g8EpCiBQKU+JyuFHmYb5ts8grWZ/rmVvU
         DSLOOkymbJZOggCWYDr4vSVRh7OsUYufmKycBjrMnOxfBYsbU75JYUF0CT9+2ogLoQBg
         +BUg==
X-Gm-Message-State: AAQBX9cgOUgbhke1xvFIBgdJ3OqzTDADhbw//aNFb/R0VTm7Oqx7227V
        zD/d9hgjl0SrAADTekPeXwI=
X-Google-Smtp-Source: AKy350bWIZsqi1QgUMQySBAS0TOn9YInEX6VM8a1Fq128x1L3hRVd4B3vHXyvpYe8Ua8aEhNfg+ngA==
X-Received: by 2002:a17:90b:1007:b0:247:5c00:10 with SMTP id gm7-20020a17090b100700b002475c000010mr190338pjb.2.1681772833094;
        Mon, 17 Apr 2023 16:07:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2cdd:e77:b589:1518])
        by smtp.gmail.com with ESMTPSA id t4-20020a17090ad14400b002478d21de2bsm2539576pjw.36.2023.04.17.16.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 16:07:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@google.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH v2 2/4] scsi: ufs: Simplify ufshcd_wl_shutdown()
Date:   Mon, 17 Apr 2023 16:06:54 -0700
Message-ID: <20230417230656.523826-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230417230656.523826-1-bvanassche@acm.org>
References: <20230417230656.523826-1-bvanassche@acm.org>
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
 
