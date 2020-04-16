Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E825C2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16765206A2
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ny7WEImV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgDPUbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 16:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729201AbgDPUbt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 16:31:49 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7593C061A0F;
        Thu, 16 Apr 2020 13:31:48 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h26so63604wrb.7;
        Thu, 16 Apr 2020 13:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZV8q7Yt6HpElSZoCMxiPcUAG2BqF2GevrGqBMwvpwfk=;
        b=Ny7WEImVsNMqX8ehMXgDmzrDAlFi2hj83f3y++BhFGrNuzfTX3AC2QEcJv1Soaxp6Z
         wLUHqsK0UA1ixOEK+BsBYkKKodRyXGp6SSDJ1XUkH3mfhpxJpzVUdsDsUyyhv3yiEwKP
         6ynGKMiIMr7bZczUO6uT64nz8evQjO7Bp/x7EiauZ7L7tBY+7HEB+/u10qZu/0XK9r32
         UiEtp+BMLjrdWElAzTkY/3+OX+4L4dDvdwMWawUuVoOB4ZwyR5HV9x/tua845MqthyZP
         ymsn/s3KszS0ESJhwpC7BSU0oATFtNxuu8vcgZk2joJIV/gZnyoRVceDMnvKqYAV9czo
         L8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZV8q7Yt6HpElSZoCMxiPcUAG2BqF2GevrGqBMwvpwfk=;
        b=PQhMjssYfrmnJ3DeDkhhMaEAwBoT7W0EdmSQtuW2rdXIy1WtYe00SPk4IQVbzGaIg5
         qXCdWd2lSa5S2KwRnjD9oGK07OPwNiPeeROLlnp5Z4Xxry6am7sQnUiNA9X0nxuQAo10
         SnsX4wm0n+GffZWZjGXvuQSHoJLmrxOM0vJXb7rD9HvBpVWK14hFTxyO6wfX0Kd3JK8T
         ADmnxEHUP35GqOV8v0PVZGDJ4ShjRRO/dQ9PkZZ/Etjw4TNrQ5MfyTL0yYw3ztFFUY7e
         ko06WxR2C9uOtTgkOI+HYhMDAA3A3armY/3imMlG+2p5+0Cbj7Tk4uEqHFrgYHKDXW9d
         rAPQ==
X-Gm-Message-State: AGi0PuYiQE2XQFpqEoIApu6/A4D8KHxVmBHka2Y5VekvHZslQ+s0Eosl
        BKCE6P8OdPNyiGo9b204Ze8=
X-Google-Smtp-Source: APiQypLf9Ac2PPexr+UaRuiOheVFwZ+YUgU8qImYFCz8T6W2kKrvBm7e5QZl62oHcBbLrJlyBHyPIg==
X-Received: by 2002:a5d:498b:: with SMTP id r11mr17317wrq.368.1587069107206;
        Thu, 16 Apr 2020 13:31:47 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id s9sm17638864wrg.27.2020.04.16.13.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 13:31:46 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] scsi: ufs: make ufshcd_read_unit_desc_param() non-static func
Date:   Thu, 16 Apr 2020 22:31:23 +0200
Message-Id: <20200416203126.1210-3-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200416203126.1210-1-beanhuo@micron.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

HPB driver needs to read unit descriptors through ufshcd_read_unit_desc_param(),
make it an extern Function.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 +++-----
 drivers/scsi/ufs/ufshcd.h | 5 ++++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index de13d2333f1f..83ed2879d930 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3326,11 +3326,9 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
  *
  * Return 0 in case of success, non-zero otherwise
  */
-static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
-					      int lun,
-					      enum unit_desc_param param_offset,
-					      u8 *param_read_buf,
-					      u32 param_size)
+int ufshcd_read_unit_desc_param(struct ufs_hba *hba, int lun,
+				enum unit_desc_param param_offset,
+				u8 *param_read_buf, u32 param_size)
 {
 	/*
 	 * Unit descriptors are only available for general purpose LUs (LUN id
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6ffc08ad85f6..7ce9cc2f10fe 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -856,7 +856,10 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
 extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-			struct ufs_pa_layer_attr *desired_pwr_mode);
+				  struct ufs_pa_layer_attr *desired_pwr_mode);
+extern int ufshcd_read_unit_desc_param(struct ufs_hba *hba, int lun,
+				       enum unit_desc_param param_offset,
+				       u8 *param_read_buf, u32 param_size);
 
 /* UIC command interfaces for DME primitives */
 #define DME_LOCAL	0
-- 
2.17.1

