Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5733AC6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 18:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbiI0Soh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiI0SoU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 14:44:20 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002EA1C4800
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:44:18 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id f193so10226703pgc.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:44:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1GLKdsE9mlEjI3G0icPW9Cfl6Qc2h3FWYS/7Ll/qo1A=;
        b=AhlxwCeU/l8fNGnvP0cOWehaXLdiFY0dyjS4dErH9wiVEgpOK/iojJtIqo70sXnssk
         5NZXTHUJQfTVnaMDPIhwMVuZT+0D/1lG/MXs1Bi+Sgm/ALtUfiS57mn1MFr8W+/PEcMX
         wa+Q50b6TUdMrkPS5foIZmLbVKJV//cvueAiFLddowguKyjblXr+qxc2LOscTQgva9/5
         /5NDMdzsSpkrcKQN8X3Hnrkjcpn7ADa8bucj/qKHtGUSKNO0fyStmSSBClQKDAwx+t3G
         kpu0xRlcBU6NTw6Y8MmR2kd1kAxfWAVwJ5o/0IW7fUI7cyF9cP6csjPP0mI2GlNrf2mz
         Csig==
X-Gm-Message-State: ACrzQf3SyesfybrIk3idYqqEZdeR+7CqRlnjsOdATsyv2qY44xqNSBup
        ONCSZHNmONlfp/Bqa+1yabhl/QpStKc=
X-Google-Smtp-Source: AMsMyM5jxkc5AngKUGo4zf1VSFXHJIeHI8vmP80eL3+PuGcPKKSaafn71r8uSIpCf1JnGwiEWFNfSg==
X-Received: by 2002:a05:6a00:1d82:b0:541:1ea2:e7e with SMTP id z2-20020a056a001d8200b005411ea20e7emr30770598pfw.71.1664304258399;
        Tue, 27 Sep 2022 11:44:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:457b:8ecb:16d:677])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7956f000000b0052e987c64efsm2184083pfq.174.2022.09.27.11.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:44:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v2 6/8] scsi: ufs: Try harder to change the power mode
Date:   Tue, 27 Sep 2022 11:43:07 -0700
Message-Id: <20220927184309.2223322-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220927184309.2223322-1-bvanassche@acm.org>
References: <20220927184309.2223322-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of only retrying the START STOP UNIT command if a unit attention
is reported, repeat it if any SCSI error is reported by the device or if
the command timed out.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 02e73208b921..e8c0504e9e83 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8784,9 +8784,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	for (retries = 3; retries > 0; --retries) {
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
-		if (!scsi_status_is_check_condition(ret) ||
-				!scsi_sense_valid(&sshdr) ||
-				sshdr.sense_key != UNIT_ATTENTION)
+		if (ret < 0)
+			break;
+		if (host_byte(ret) == 0 && scsi_status_is_good(ret))
 			break;
 	}
 	if (ret) {
