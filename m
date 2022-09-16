Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20741ECAAD8
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 18:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiIPSm4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Sep 2022 14:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiIPSmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2022 14:42:38 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D437CB8F28
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 11:42:26 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id k21so11693936pls.11
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 11:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=fgGk5ZlTzagiFFEIY9ZlkyjyaTEOKb5EwjaNFdAYWw4=;
        b=WPwyh6xY19Q2WorHmEh6kqfVzZ0JddbkL5ELoIBJrTmPqrHYR5mhezErjLQ+63MCR8
         swB9mMh6NpWruwa2vgyA3ZVIsmwLjrdAaHxtQcKGCMUGuL/Yl5zUksPrr2oZ9S1Be22z
         113jPz+yRtkuNtuGnre/jBh/sXYDBJN9cvPeBmUrW+bczKbwmi8pOvagKJ70FBYPEmPz
         Rlp1+Dm6q5iCjSWIxafQhs0MKf/0tBUVNrEix1grn8gErDrWWKWPsxcnEQGil1Obpjm7
         aWbzROw3yoUZLTfo5gt+LFcUbnu3QpttRvvZ1Xktw0mWNvDh+WMc0p1te/QPmjqmwcd3
         T/aA==
X-Gm-Message-State: ACrzQf3zDEUa1kIbHaiM3yRriDafq99HTaCAkk9TjOIS7CMwNpSIkrWQ
        xMiOFw4fBmrZsoFxujB9CIktRcMxOvE=
X-Google-Smtp-Source: AMsMyM7/GSTfDBtslL883++8n4NCbSqij0w3YxftFrh5ItgIcYyR2z15H7si3q0PHnrqh6J1R5ewfw==
X-Received: by 2002:a17:90b:2245:b0:200:57df:44cf with SMTP id hk5-20020a17090b224500b0020057df44cfmr18023165pjb.135.1663353746056;
        Fri, 16 Sep 2022 11:42:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:b2fd:791c:a216:ceef])
        by smtp.gmail.com with ESMTPSA id b15-20020a170903228f00b001784a45511asm8427077plh.79.2022.09.16.11.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 11:42:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        dh0421.hwang@samsung.com, Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH] scsi: ufs: Fix deadlocks between power management and error handler
Date:   Fri, 16 Sep 2022 11:42:06 -0700
Message-Id: <20220916184220.867535-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following deadlocks have been observed on multiple test setups:

* ufshcd_wl_suspend() is waiting for blk_execute_rq() to complete while it
  holds host_sem.
* ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
  latter function tries to obtain host_sem.
This is a deadlock because blk_execute_rq() can't execute SCSI commands
while the host is in the SHOST_RECOVERY state and because the error
handler cannot make progress either.

* ufshcd_wl_runtime_resume() is waiting for blk_execute_rq() to finish
  while it holds host_sem.
* ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
  latter function calls pm_runtime_resume().
This is a deadlock because of the same reason as the previous scenario.

Fix both deadlocks by not obtaining host_sem from the power management
code paths. Removing the host_sem locking from the power management code
is safe because the ufshcd_err_handler() is already serialized against
SCSI command execution.

The ufshcd_rpm_get_sync() call at the start of
ufshcd_err_handling_prepare() may deadlock since calling scsi_execute()
is required by the UFS runtime resume implementation. Fixing that
deadlock falls outside the scope of this patch.

Cc: dh0421.hwang@samsung.com
Cc: Asutosh Das <asutoshd@codeaurora.org>
Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7c15cbc737b4..cd3c2aa981c6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9254,16 +9254,13 @@ static int ufshcd_wl_suspend(struct device *dev)
 	ktime_t start = ktime_get();
 
 	hba = shost_priv(sdev->host);
-	down(&hba->host_sem);
 
 	if (pm_runtime_suspended(dev))
 		goto out;
 
 	ret = __ufshcd_wl_suspend(hba, UFS_SYSTEM_PM);
-	if (ret) {
+	if (ret)
 		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__,  ret);
-		up(&hba->host_sem);
-	}
 
 out:
 	if (!ret)
@@ -9296,7 +9293,6 @@ static int ufshcd_wl_resume(struct device *dev)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_sys_suspended = false;
-	up(&hba->host_sem);
 	return ret;
 }
 #endif
