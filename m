Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592D0C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbiCaWic (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240723AbiCaWia (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:38:30 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147311F6F09
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:37 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id f10so877209plr.6
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9eRTboFWeaeOjc6NWkIYp0ZtF46lBUx0bcLmD6erhj4=;
        b=glSGYC1c0BvmzuGbTZW4UJrth51IetGVZfIPnA8uczK3TQ+gIAoSAmjINIAQ3wOzvf
         9LtCmk406mt5VFKCi34SX6nyPuowLAA3rHJSFHq0vNceUPWB5ZalW8mhAy01n51GGxsN
         dzFWhOmJjMn2ArFOnThWTFpCtssYXYRQnaqfvzXAq0bJoDQlbtOf1qgQisBj+xJF9ZEx
         fTRrdNDyH1PQG2lWPzV2EwUxiiWq02aqNpupw+xw8abbJ5FbTCjbfqfoWfZc0c9jnKgr
         mcD89zDUI+GAETFr9c6BwSpUtNy81LNR6TzmDkXOsEcHBBkd0Pn9Nt6GE67Cgk+tzxt+
         33dQ==
X-Gm-Message-State: AOAM533VIWu/xOdBuM+7zIGrHMN4Ezvz7DrmyFy82akMcmRXX+mNoE1t
        dcnwr7S8+qrDwQESzcH0Jtw=
X-Google-Smtp-Source: ABdhPJzjo52IJ/cUsKTgqfKG4zUreRIVEgCtg6sS/5NMXduHtq3jVuvyGcB+UYGZjusMKdvgnEf2Bw==
X-Received: by 2002:a17:902:a714:b0:154:6dfe:bba9 with SMTP id w20-20020a170902a71400b001546dfebba9mr7256857plq.124.1648766196534;
        Thu, 31 Mar 2022 15:36:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:36:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 13/29] scsi: ufs: Remove the LUN quiescing code from ufshcd_wl_shutdown()
Date:   Thu, 31 Mar 2022 15:34:08 -0700
Message-Id: <20220331223424.1054715-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Quiescing LUNs falls outside the scope of a shutdown callback. The shutdown
callback is called from inside the reboot() system call and the reboot()
system call is called after user space has stopped accessing block devices.
Hence this patch that removes the quiescing calls from
ufshcd_wl_shutdown(). This patch makes shutdown faster since multiple
synchronize_rcu() calls are removed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a48362165672..ae08c7964f2d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9212,9 +9212,7 @@ static int ufshcd_wl_resume(struct device *dev)
 static void ufshcd_wl_shutdown(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ufs_hba *hba;
-
-	hba = shost_priv(sdev->host);
+	struct ufs_hba *hba = shost_priv(sdev->host);
 
 	down(&hba->host_sem);
 	hba->shutting_down = true;
@@ -9222,12 +9220,6 @@ static void ufshcd_wl_shutdown(struct device *dev)
 
 	/* Turn on everything while shutting down */
 	ufshcd_rpm_get_sync(hba);
-	scsi_device_quiesce(sdev);
-	shost_for_each_device(sdev, hba->host) {
-		if (sdev == hba->sdev_ufs_device)
-			continue;
-		scsi_device_quiesce(sdev);
-	}
 	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 }
 
