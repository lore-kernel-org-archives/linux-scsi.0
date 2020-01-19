Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1181C32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 984A124683
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ifVChtVX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgASAOU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 19:14:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36606 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729028AbgASAOT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 19:14:19 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so26066135wru.3;
        Sat, 18 Jan 2020 16:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JcxadZK131d3CCycqq881Qc4UK7AcKsZZt6NwsgpxHk=;
        b=ifVChtVXpP+xBlUVu5XoyB70HfTtAuMqusG0xmzFTa1OPurEPYaVhOzIv8gKX0Yri0
         ejGzgu00Hl4+2lVv+NQms8/70vnhrNYgsg0qGALHdjK7XwaRvAH+52jxbhp+ryQeHRmH
         Q64Il+GPgjnof37sq0J8a3mGfXCv0IYXOsxus8OhvM6N0kiKewD0eTpDSGchs9T53Q0b
         7YoY7Krn06UTb5kwwvNEfxqrlJg8ws6bkXW2fqmqB+/hTRlbZ5I+44AnJOGuMuLPchXj
         KXR2FErUgYyInhUZTJrNoAu67kjsfrVIOHbh66OCRySJijfg1RDzJCpxmbsrHXlC1IMR
         ESZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JcxadZK131d3CCycqq881Qc4UK7AcKsZZt6NwsgpxHk=;
        b=HLQHfMAbSQtgdCCVK9u9p3zGZZIC180IoKVz8UzCs2Z5OAxwn+P7EUlEuqI2qZc/7c
         4wQ3UQRPB8V/+5M6aB3AGr78dgHZNWJ0KR4YbaM1/iUH60s1fD1nwC5FYVtN17AsHE9n
         TqozBBT3slihyGwS55hglYTwh4O06ztsIh3ppBTh9dEcmlNmvtIKKe8Z9a9OTbAvL1+S
         zN6GN3/AxW7ZLQlu68j32xMDvFaFwmLvc00d6aFG9Rw+P/KfIO802qHLcNGrJ22j4Llu
         1a67J45jmW9D3pbT9P3Jfr4elfTYtdFbVs7N3K946zR/rmvaZ+n9vs8E8+iJYTG3yJ7B
         OqXA==
X-Gm-Message-State: APjAAAUjLptHe3n6fpGsF+FlsHAxlQkNrUqvArMOqZlG4H+FQevqTjQH
        ioM6sY4D0s+IU94GiLDT2chePY1J
X-Google-Smtp-Source: APXvYqyZAtKZNrooDp4z+ENSIc9Q2g4g5qH9RKG229vCI4YFDrzwwzYb42W/mQIfVw2yN4A0ln8BNw==
X-Received: by 2002:adf:ef0b:: with SMTP id e11mr11117619wro.128.1579392857675;
        Sat, 18 Jan 2020 16:14:17 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id i8sm42177432wro.47.2020.01.18.16.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 16:14:17 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 8/8] scsi: ufs: Use UFS device indicated maximum LU number
Date:   Sun, 19 Jan 2020 01:13:27 +0100
Message-Id: <20200119001327.29155-9-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200119001327.29155-1-huobean@gmail.com>
References: <20200119001327.29155-1-huobean@gmail.com>
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
index dd10558f4d01..bf714221455e 100644
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

