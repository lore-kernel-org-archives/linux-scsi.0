Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00CDC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 08:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B3DA22AAF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 08:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbhAKIsl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 03:48:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbhAKIsl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 03:48:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67FCD22581;
        Mon, 11 Jan 2021 08:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610354880;
        bh=N98hLzcb3E+X96QtBAkk1ea6lYkc4SJir9whIubX4Ck=;
        h=From:To:Cc:Subject:Date:From;
        b=eI7ihsLfQmobHMfkfmOHembqlu6Df5bRvRpmfqnTndCxfL11p5bqxQz4GxbKAyL7d
         exkB5WreT5lAcljKPum2JRJVuyCxES8w7B7jT3exkbIovJA7/8c7qqMZYw05Ve7xtG
         FWuY4bmlvlp/lPjCHBRKOKSvA4TJ7LFvHWlDCgtFtXRacqwBeuU1VASrGa8uypeysN
         vsT/0dBIRWgEVth1yDQ8cALkzX+Rgi47mkblCjreOZh7XsvE2Ph+H7nF5D03pdmrYx
         0+mb9MsU8Y45eh3jEvz83mPAsaGQ8ehKLCmVoEDOesjO+7HWLo/wLYQiM+MaFl/1iz
         QmNiUKwR0/GxQ==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v2] scsi: ufs: WB is not allowed in RPMB_LUN
Date:   Mon, 11 Jan 2021 00:47:56 -0800
Message-Id: <20210111084756.1810924-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

Kernel stack violation when getting unit_descriptor/wb_buf_alloc_units from
rpmb lun. The reason is the unit descriptor length is different per LU.

The lengh of Normal LU is 45, while the one of rpmb LU is 35.

int ufshcd_read_desc_param(struct ufs_hba *hba, ...)
{
	param_offset=41;
	param_size=4;
	buff_len=45;
	...
	buff_len=35 by rpmb LU;

	if (is_kmalloc) {
		/* Make sure we don't copy more data than available */
		if (param_offset + param_size > buff_len)
			param_size = buff_len - param_offset;
			--> param_size = 250;
		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
		--> memcpy(param_read_buf, desc_buf+41, 250);

[  141.868974][ T9174] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: wb_buf_alloc_units_show+0x11c/0x11c
	}
}

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufs-sysfs.c | 3 ++-
 drivers/scsi/ufs/ufs.h       | 6 ++++--
 drivers/scsi/ufs/ufshcd.c    | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 08e72b7eef6a..50e90416262b 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -792,7 +792,8 @@ static ssize_t _pname##_show(struct device *dev,			\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	struct ufs_hba *hba = shost_priv(sdev->host);			\
 	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);			\
-	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))		\
+	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun,		\
+				_duname##_DESC_PARAM##_puname))		\
 		return -EINVAL;						\
 	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,	\
 		lun, _duname##_DESC_PARAM##_puname, buf, _size);	\
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 14dfda735adf..7a0069c83900 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -552,13 +552,15 @@ struct ufs_dev_info {
  * @return: true if the lun has a matching unit descriptor, false otherwise
  */
 static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info,
-		u8 lun)
+		u8 lun, u8 param_offset)
 {
 	if (!dev_info || !dev_info->max_lu_supported) {
 		pr_err("Max General LU supported by UFS isn't initialized\n");
 		return false;
 	}
-
+	/* WB is not allowed in RPMB_WLUN */
+	if (param_offset == UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS)
+		return lun < dev_info->max_lu_supported;
 	return lun == UFS_UPIU_RPMB_WLUN || (lun < dev_info->max_lu_supported);
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2a715f13fe1d..48cbd4f294dd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3425,7 +3425,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	 * Unit descriptors are only available for general purpose LUs (LUN id
 	 * from 0 to 7) and RPMB Well known LU.
 	 */
-	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))
+	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun, param_offset))
 		return -EOPNOTSUPP;
 
 	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
-- 
2.30.0.284.gd98b1dd5eaa7-goog

