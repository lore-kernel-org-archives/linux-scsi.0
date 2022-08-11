Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1478DC25B06
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 23:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbiHKXoK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 19:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHKXoJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 19:44:09 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B6C9AFCC
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 16:44:07 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id p125so14230636pfp.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 16:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ny9KWbCu2Y/ozn2Hhz4f6jkJiKNZ0nlCqvjOfz0lLVU=;
        b=3ZaXQye8THrX7jf0noQwR6RfoKuaJvLUrc6tsMdli+6JTrf9Fs5oQHf7TlkNEpVQ3+
         OKvWmtSAtiLBLv1p9btHM/v1eZ/4pu7/LT9xf0DI051NA1RUtJYr/hdp0tYm3SFlGAXx
         MlQgAN07erZbWl0Cuwq8AndP5AJGoyd9XcsU1kTOTl7CIydVJjaRqkCSaFF0NtKSw34d
         qM7CEBIN9b/YTWgAP6YJMVNiLgm7kGxOgnDeh3u5AXN47zG5u3lmoyVJNV9qpR2UyRk+
         7eLCJMUuqH8nzN/wq5RKVgTCsgDloM51QGsIGEDB8gk6JYNH9yDytxebrGKSKmjxh85k
         RLiA==
X-Gm-Message-State: ACgBeo0MMgiY1NUU3KQACzjVEXEkumtyuNswl2/TJDVuNXUG0iRUX7MV
        9wrYj8pLXyriqFv7JDs9HoqePkkRnUI=
X-Google-Smtp-Source: AA6agR4NDq8qSJzlictdcMRTSHQ6iOfPZlSzsSqzXZIbknTZWL0zpaeo0JU4xzlSK5ewPtjz+uYmwA==
X-Received: by 2002:a65:6e05:0:b0:420:f9b6:a69a with SMTP id bd5-20020a656e05000000b00420f9b6a69amr1066532pgb.3.1660261447109;
        Thu, 11 Aug 2022 16:44:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:fa57:1951:439d:3051])
        by smtp.gmail.com with ESMTPSA id g198-20020a6252cf000000b0052e0b928c3csm240398pfb.219.2022.08.11.16.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 16:44:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Reduce the power mode change timeout
Date:   Thu, 11 Aug 2022 16:43:49 -0700
Message-Id: <20220811234401.1957911-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current power mode change timeout (180 s) is so large that it can
cause a watchdog timer to fire. Reduce the power mode change timeout to
10 seconds.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e32b6b834b7f..2dd355a5da54 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8776,6 +8776,8 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_device *sdp;
 	unsigned long flags;
 	int ret, retries;
+	unsigned long deadline;
+	int32_t remaining;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -8808,9 +8810,14 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
+	deadline = jiffies + 10 * HZ;
 	for (retries = 3; retries > 0; --retries) {
+		ret = -ETIMEDOUT;
+		remaining = deadline - jiffies;
+		if (remaining <= 0)
+			break;
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+				   remaining / HZ, 0, 0, RQF_PM, NULL);
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)
