Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BCFC2D0DB
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBD5E22522
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:10:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pACO54zR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgATNKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:10:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40598 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgATNKK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 08:10:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so14618076wmi.5;
        Mon, 20 Jan 2020 05:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ygaQ/46D8dGQ52VSi/XMDPuo6obEX8tZiKmv9YWb3M4=;
        b=pACO54zR5xoMJzdsrylDNfbu+eXZKS2kWL9dsFO9X+u04NOGXS6afl5nSE0mb/GmGp
         QzEWMQJvUSzfZ8hTl+8W759mk+KdF7c89eQQXAohBYwTxUtTYEc/b0Bzw455P/letpcD
         ROgkrVFrYOjevFTw2TT6IsRl+dlg+dprBqitnZKuxucoo0BW8LqHi04yXPigBpkTLnm5
         b3gOlVIBI1PgX/hyNmkyBuNgRS61YYUjQbIgVl3RkUYGiHffazKD3lhfKJJcQ4BDhx6c
         biJ6ywfLjmcUAttSMDyzu7vM2BH9PHpxRISUJBSoTxouEsyYaUEnHa9t/gQZn4jkH7x+
         sXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ygaQ/46D8dGQ52VSi/XMDPuo6obEX8tZiKmv9YWb3M4=;
        b=flzW8aFpXfvPdRPUqEOrc1urPmwAARhfeiwmXxvNDtyso/nJlTBePHKwd9LHdLVDIZ
         Jhkdnar3s5U02c6NIcfTvgDHJMssBhUFhoZLTwqrILeuCqmHBs5HAuUOmDAkkI6viwns
         YT2bUxcHa2H+Ywsj2ru8xMzNUQVfh+xQfQEgx/T9EMhbnwd8pCsBNbJNrbVhAgazDz7D
         DOPo39Le6PPyvVGgzLdxbkL6UcpzAv9K8/iRVe5xyRjoip0/0MJqd0xdigx+ebCD2Bqg
         joEZYT/BpwoNQyY6CnHT/FLcaudxwxLAm9fPzZXgXEgNlC8FBehekLEXoeCLFjizSF4Z
         RTPQ==
X-Gm-Message-State: APjAAAV2OP2QCfmUhI1lcnY9roV4B7jcHO2Dm/a0A51ZxSUFacC/rgeY
        ToJHp5Hy3QmUVgKj6B9x6Gk=
X-Google-Smtp-Source: APXvYqxG4Tmf7UOO1mQ7QRQblVPm30R3woYtQQZNUjBsyjLOufLsSuaR0E8AE8K5I2RQBW3+ise1Ew==
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr18277857wma.138.1579525808359;
        Mon, 20 Jan 2020 05:10:08 -0800 (PST)
Received: from ubuntu-G3.micron.com ([165.225.86.138])
        by smtp.gmail.com with ESMTPSA id p18sm23065386wmb.8.2020.01.20.05.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:10:07 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 8/8] scsi: ufs: Use UFS device indicated maximum LU number
Date:   Mon, 20 Jan 2020 14:08:20 +0100
Message-Id: <20200120130820.1737-9-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200120130820.1737-1-huobean@gmail.com>
References: <20200120130820.1737-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

According to Jedec standard UFS 3.0 and UFS 2.1 Spec, Maximum number
of logical units supported by the UFS device is indicated by parameter
bMaxNumberLU in Geometry Descriptor. This patch is to delete current
hard code macro definition of UFS_UPIU_MAX_GENERAL_LUN, and switch to
use device indicated number instead.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
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
index 1d2812ad8742..d7f2465447e0 100644
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

