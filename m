Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997F2C433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E385221F0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbhAKKAO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:00:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbhAKKAN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 05:00:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 314E522288;
        Mon, 11 Jan 2021 09:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610359173;
        bh=m+Ij2dBktkSThrVZO1cu0ZmecjHv4ArG21/Sjc4ELbE=;
        h=From:To:Cc:Subject:Date:From;
        b=Sumn3fI6nwDJfqbK511YBu2eJjBViZRlp2x2+Br8BXA8vvEPtthXbTMKZTgQQlpbW
         QNbRczwfo8k1oLrSoQd1gcY0nnwhglZLUamIOlEGItf0xhV5sBlYRHXNTG8EN2w+SZ
         5tpiNVfLVODYF38SEKpNZCJJrNpWtvxwG25eBPYRSCOLpg+y5Y88aiviU+6z5bsAOs
         cjfjUsfD6RzcKhDUAoXoi5crKKssDFWYbqWSUWZzNgeraAr9f85/6+C87H2HcLna1s
         JgHKdOrVK0vF+rRyxM5z2mPsjsaG19cKWTQwydD5ZZvf8XHLSv3jE07FF3LbuDnVMi
         rroztWqR3y9YA==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v3] scsi: ufs: WB is only available on LUN #0 to #7
Date:   Mon, 11 Jan 2021 01:59:27 -0800
Message-Id: <20210111095927.1830311-1-jaegeuk@kernel.org>
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
index 14dfda735adf..580aa56965d0 100644
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
+	/* WB is available only for the logical unit from 0 to 7 */
+	if (param_offset == UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS)
+		return lun < UFS_UPIU_MAX_WB_LUN_ID;
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

