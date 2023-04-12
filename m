Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D146FC7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 20:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjDLUlq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjDLUlp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 16:41:45 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBE159E0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:41:44 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id q2so17618691pll.7
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681332104; x=1683924104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9HN99QwsksXCBCaVQ2bJ/Ic4jm/KkGkP0u89WLoXno=;
        b=kIsEDYtq4O/DDLoVLCly8RZ/Dh3C4M8IQ/cXnZSb3aZNoz3FlzoOtG17tC9ccQUE7T
         TAjbyAz8J8lH3/mBO81HvX4ilBcx+8eaDzeAysiUXUEbNwhjwX3sPzRefk2/RoCiK9ui
         AuqsmbzSmzziQ4PawMurt8Wx4K9HyXQp0YBYpAWOcjKrlvJhUCfvpUsyfR4KQi4ZMp1F
         h+LQx0MlfuUBilPyBHuMkOOj6eA1By9pKv8Z+SZP6uCW6C/QeQdQWxHBFTFGG6bdZVP0
         mxe0lyW5SJEZGYOakSamapQakV6sJJ8QWBn1URPFF9/17pRSeDG2EUBHMZB/e+1o160j
         M50Q==
X-Gm-Message-State: AAQBX9e090YLICkCrcFGRbIEPOUmlt6uDd+FDlwqVO1CFnliihso7Ob6
        LlBrZ41PAheYCpJVkrwNgE4uKcA7f28=
X-Google-Smtp-Source: AKy350ZCetmhvvIr7NOVHfo92KeeZZKGFX+N8Zbc1OXE9YnpFtQsP1fwSfb1GHDhdDDJ28EJKJG/0A==
X-Received: by 2002:a05:6a20:be1e:b0:eb:c8dc:a565 with SMTP id ge30-20020a056a20be1e00b000ebc8dca565mr2836379pzb.7.1681332103874;
        Wed, 12 Apr 2023 13:41:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d89d:35dd:5938:1993])
        by smtp.gmail.com with ESMTPSA id l19-20020a62be13000000b006249928aba2sm12123364pff.59.2023.04.12.13.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 13:41:43 -0700 (PDT)
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
Date:   Wed, 12 Apr 2023 13:41:24 -0700
Message-Id: <20230412204125.3222615-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
In-Reply-To: <20230412204125.3222615-1-bvanassche@acm.org>
References: <20230412204125.3222615-1-bvanassche@acm.org>
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
 
