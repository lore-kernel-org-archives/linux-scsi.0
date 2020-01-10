Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8219FC282DD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 18:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5516220842
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 18:36:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6QNPXji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgAJSgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 13:36:45 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38912 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728650AbgAJSgo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 13:36:44 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so2757357wrt.6;
        Fri, 10 Jan 2020 10:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UXJ0984uNLCZWdtiVqvMGUgerEXFIAg/QOnqL6st/Yc=;
        b=J6QNPXjiDIbeROuPF40FlaKOCsPWz/Hp5miGsAzvdZHMMzZ4YM/fZhNpnYsZAVyit+
         KY5LmV5+4EuP260rUO+OK+hFncFcJpbo58Ru747SE0RZLxTVoL6FrQBrLvhSXhoS93r9
         09vKJU5f1m045AYtv0OV22IuUdqgBx8tTAneLeNjiO3xB6G4y4W6GE2KNzW47Xv0gmtv
         rAT418APTztNaIRKdrmxVmxIxSj0N9dn0PN2LkALSwjsjlKZ/DXy/4YRnDGMXi9KidLB
         9GK//AMXHIx40Cyf1ioU9cDozHS9wZsFAkgDXz0i5ZJsQSLQYHXKiIGkyVe+PsjBiv1I
         4+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UXJ0984uNLCZWdtiVqvMGUgerEXFIAg/QOnqL6st/Yc=;
        b=ZPyzc3FXsCDOiWDEYXM5qwm8JBjRZXdCvsvaRib9QHe9RxhI5m9uG9Vr23IAGMFLdV
         NfpwtVFUuOjx3SZKFKlf6axrdvVOGm96Da78OFoHyPTE5IwRJWcZhqXo/KQDVvvapU9H
         wM9H9aZBt/Mzvz3WaNnjQAiapGw9bZeTm9pAFqM2HWdIPBuC2GPo5XVzwb4XmjFtw3VT
         TujKAJEt9PKf/KvzSsjYqYgMzF6xDjYd3f2Q6fI1WppHBH1NSg3bi3UOq+xItqGUnNhQ
         tjhoWKN5OGTnpCIO1DbEZX3gPbG2uHzH+1ir3/qX5u2LbVfIjFXjBP0UD8AOCKldy3II
         /dpg==
X-Gm-Message-State: APjAAAXI7Ru9jQn8qngwWH2zaBsAdGmMjvdkCEXhWUm+ldP2pHVYav0g
        5V8EX/7N/BtR2Him3ZAe2oQ=
X-Google-Smtp-Source: APXvYqx7KXO/xXinQdF5sICKA1kVrAQNdZxc2mrAPKuyywfPlaCEl0uTtJkEuJDdsopR2UYeeWb1nw==
X-Received: by 2002:a5d:538e:: with SMTP id d14mr4995494wrv.358.1578681402813;
        Fri, 10 Jan 2020 10:36:42 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id x11sm3182825wre.68.2020.01.10.10.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 10:36:42 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] scsi: ufs: use UFS device indicated maximum LU number
Date:   Fri, 10 Jan 2020 19:36:06 +0100
Message-Id: <20200110183606.10102-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110183606.10102-1-huobean@gmail.com>
References: <20200110183606.10102-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

According to Jedec standard UFS 3.0 and UFS 2.1 Spec, Maximum number of logical
units supported by the UFS device is indicated by parameter bMaxNumberLU in
Geometry Descriptor. This patch is to delete current hard code macro definition
of UFS_UPIU_MAX_GENERAL_LUN, and switch to use device indicated number instead.

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
index 5ca7ea4f223e..810eeca0de63 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -63,7 +63,6 @@
 #define UFS_UPIU_MAX_UNIT_NUM_ID	0x7F
 #define UFS_MAX_LUNS		(SCSI_W_LUN_BASE + UFS_UPIU_MAX_UNIT_NUM_ID)
 #define UFS_UPIU_WLUN_ID	(1 << 7)
-#define UFS_UPIU_MAX_GENERAL_LUN	8
 
 /* Well known logical unit id in LUN field of UPIU */
 enum {
@@ -548,12 +547,19 @@ struct ufs_dev_desc {
 
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
index a297fe55e36a..c6ea5d88222d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3286,7 +3286,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	 * Unit descriptors are only available for general purpose LUs (LUN id
 	 * from 0 to 7) and RPMB Well known LU.
 	 */
-	if (!ufs_is_valid_unit_desc_lun(lun))
+	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))
 		return -EOPNOTSUPP;
 
 	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
@@ -4540,7 +4540,7 @@ static int ufshcd_get_lu_wp(struct ufs_hba *hba,
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

