Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1844C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C52CA2075B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 22:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NcAE1SH8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389639AbgAPWAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:00:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53333 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729503AbgAPWAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 17:00:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id m24so5381251wmc.3;
        Thu, 16 Jan 2020 14:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oIn+Jvngj5pWP7exdhrbj7B/VR3utuuUJaPI5QggeLQ=;
        b=NcAE1SH8vL4NAONhNeG3//w0M7GQVz0DiGsz3fshkybB7yDqnoQZYxTAbSfDKfXF8A
         A0bTHvade4wpI81k3lhLKM+eCzubM7WT/1gbfD/qoB0xxjCTpbnJCV/1+726JSy6Eef/
         EgWKfViiYtxdqLFHMDD1MATTee5qvUEV+0jXQ2udUHWswG82cQQLVRlwReFLRh8WqWf5
         xN8xBkAZSHnYnej8oJpE3nW00sH3N9FFAtWvMwUifgDodx1WfyAldA6wjmcElI6vE8L6
         z5XS6nlwz2B7jAhVuyHZan5ssOg24naz7twy72uwvVanyslzOZGZFhYXNw+8vz1kjVA+
         FW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oIn+Jvngj5pWP7exdhrbj7B/VR3utuuUJaPI5QggeLQ=;
        b=ZjOd90H2wsrlTV1WC+/XDE+9Kc03jXVQrkAlE6wo3nde6P3KcS5LZTpocwblZJoHXo
         rbobTh2oYxjYeipefgg1k/tOI7iI32y2vyjVQQmguneynTgoLvb1nfCyUmdg6IuoEStf
         xNRHavfybTFVkxhtCDMsN95KOKsgNi9OvymSdUu/Jr5YSFUVU5T4K8wif71/nFk33cFc
         zv3yIN98VoSOL7JzlnS19pYbfy9xoesuNysWxY8nX34Y6UviuyMjaRwhMkAnvIPTWrvj
         Tv1MzzkmKqDS8S11L+GmCg+GL/faTVcTxuf8lXiGmiD2umMhOkbz7SwuZMScD955Y7sE
         y/Jw==
X-Gm-Message-State: APjAAAWSpxTeUhiG5pAsbYIk3m48/3Fp0nM8dwmH7fE+6280bFPOhVBU
        ogRlWnqYTLqA35PGe0sP5oU=
X-Google-Smtp-Source: APXvYqw6KydyP6gocEdkQdlORTHH7IwMM6gD5avULnOd8yG9XpYgcEHS59fdqBAmXXnGFgFhGaTNlQ==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr1148335wmk.172.1579212040835;
        Thu, 16 Jan 2020 14:00:40 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id a14sm32418131wrx.81.2020.01.16.14.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 14:00:40 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 9/9] scsi: ufs: Use UFS device indicated maximum LU number
Date:   Thu, 16 Jan 2020 22:59:14 +0100
Message-Id: <20200116215914.16015-10-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200116215914.16015-1-huobean@gmail.com>
References: <20200116215914.16015-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

According to Jedec standard UFS 3.0 and UFS 2.1 Spec, the maximum number
of logical units supported by the UFS device is indicated by parameter
bMaxNumberLU in Geometry Descriptor. This patch is to delete current
hard code macro definition of UFS_UPIU_MAX_GENERAL_LUN and switch to
use device indicated number instead.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c |  2 +-
 drivers/scsi/ufs/ufs.h       | 12 +++++++++---
 drivers/scsi/ufs/ufshcd.c    |  4 ++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 720be3f64be7..dbdf8b01abed 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -713,7 +713,7 @@ static ssize_t _pname##_show(struct device *dev,			\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	struct ufs_hba *hba = shost_priv(sdev->host);			\
 	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);			\
-	if (!ufs_is_valid_unit_desc_lun(lun))				\
+	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))		\
 		return -EINVAL;						\
 	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,	\
 		lun, _duname##_DESC_PARAM##_puname, buf, _size);	\
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index c982bcc94662..dde2eb02f76f 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -63,7 +63,6 @@
 #define UFS_UPIU_MAX_UNIT_NUM_ID	0x7F
 #define UFS_MAX_LUNS		(SCSI_W_LUN_BASE + UFS_UPIU_MAX_UNIT_NUM_ID)
 #define UFS_UPIU_WLUN_ID	(1 << 7)
-#define UFS_UPIU_MAX_GENERAL_LUN	8
 
 /* Well known logical unit id in LUN field of UPIU */
 enum {
@@ -539,12 +538,19 @@ struct ufs_dev_info {
 
 /**
  * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
+ * @dev_info: pointer of instance of struct ufs_dev_info
  * @lun: LU number to check
  * @return: true if the lun has a matching unit descriptor, false otherwise
  */
-static inline bool ufs_is_valid_unit_desc_lun(u8 lun)
+static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info,
+		u8 lun)
 {
-	return lun == UFS_UPIU_RPMB_WLUN || (lun < UFS_UPIU_MAX_GENERAL_LUN);
+	if (!dev_info || !dev_info->max_lu_supported) {
+		pr_err("Max General LU supported by UFS isn't initilized\n");
+		return false;
+	}
+
+	return lun == UFS_UPIU_RPMB_WLUN || (lun < dev_info->max_lu_supported);
 }
 
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0c4fb5d447da..a942d5346793 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3270,7 +3270,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	 * Unit descriptors are only available for general purpose LUs (LUN id
 	 * from 0 to 7) and RPMB Well known LU.
 	 */
-	if (!ufs_is_valid_unit_desc_lun(lun))
+	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))
 		return -EOPNOTSUPP;
 
 	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
@@ -4525,7 +4525,7 @@ static int ufshcd_get_lu_wp(struct ufs_hba *hba,
 	 * protected so skip reading bLUWriteProtect parameter for
 	 * it. For other W-LUs, UNIT DESCRIPTOR is not available.
 	 */
-	else if (lun >= UFS_UPIU_MAX_GENERAL_LUN)
+	else if (lun >= hba->dev_info.max_lu_supported)
 		ret = -ENOTSUPP;
 	else
 		ret = ufshcd_read_unit_desc_param(hba,
-- 
2.17.1

