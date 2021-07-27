Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6F5C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 12:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AAF261A3F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 12:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhG0Mgf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 08:36:35 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:61888 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbhG0Mgf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 08:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627389395; x=1658925395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=QflOCDwcgW3OC1VQgoA1Hz5zfRTa+mhAWKhPfg48n7A=;
  b=lF+BWw+XjT3GDaZ/6flGk8tU9XzfTcLt4e5Wt7FHnZfLfFPXiePiN0OW
   0v1kbrbJSKdyim58IUVbngv+XAgmszmt8U75Qfvx7+wb2WVGRnSeMuzcz
   KmLzdj8O4l7vlYGk2ANVakk2tlPJlhYQK30PCRpr68aHyrL3d91fXefUC
   T2dYAoIfoO/2j5VsPWU92WIoYCe9Oa+TmpRLYAaS31+drHg6C7qxhXzby
   5YoeuuLmrEMTwM8zHPvopS9N3QI1WgPT5GJS1QBXmRyiB0iKhzketpkWq
   en8euTmYylzfy6vijaTa1hxJMzxrT8a6m7FQt0yTDi/2mOA5N1k/L7yGM
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,273,1620662400"; 
   d="scan'208";a="174813585"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 20:36:35 +0800
IronPort-SDR: BDmgRTiLfhbc7XuwFzVwwRiepPqJ3h0i5D5jjyaCOFbd7hHzstCUOwICQtnVWO4Hhw3NOLIfIO
 eTAwCZc58C6S+XOZfmyvy1ImdG6DzpMk6RrWidFXiExvZzIM6cQV0ptQsCvR4s+Wcigy3BfFch
 EWXVtf0lLdRVEUkmff10LZeki4HkPKp9xBUTOqLY7OfY221zSuB7pBbtpzqlKvUze382ViMN/r
 UwCUtUC4W7Hqq6A9zRD0PQnmVzjnjb+xLb9zQOMB4g6mvGWw83XLwmQ6bJXLoZpl2jQ1NeKeLj
 ssEchysT87LC4CnppuSIHmy3
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2021 05:12:29 -0700
IronPort-SDR: Ix+QTwPeSMKp/tuFGUsfSjuZ53Uo4O/JGJGMKmXMXiOPaPEZKJevglwmzfn1Oa0P+EZxLX0twV
 bEDzH4IAT3cNFl18oQn0SdYqU5fql1tevIRVmXptcwnu+/0XeW/UqqCVPBUmJdlV4kiD56+rVZ
 TzOQpR9axkD09OymSMqEEupTa/9KihSud8K937gHB5nXr4LV+umgQs2BDQ6YQlQ3zkXoQBMxTZ
 WlK2h/34ePxXY7XpnojImUJzxFY8UgIqypwok2yDqjYgqVRvDsMU9SVdo2u7KvZA6z0iHAQ9X4
 wro=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jul 2021 05:36:33 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/3] scsi: ufs: Map the correct size to the rpmb unit descriptor
Date:   Tue, 27 Jul 2021 15:35:45 +0300
Message-Id: <20210727123546.17228-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727123546.17228-1-avri.altman@wdc.com>
References: <20210727123546.17228-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Each lun is designated by its unit descriptor. All regular luns share
the same unit descriptor size. The rpmb unit descriptor size, however,
is different.

Log the correct size for the rpmb unit descriptor in an unused
descriptor id number.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufs.h     |  1 +
 drivers/scsi/ufs/ufs_bsg.c |  3 ++-
 drivers/scsi/ufs/ufshcd.c  | 18 +++++++++++-------
 drivers/scsi/ufs/ufshcd.h  |  2 +-
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 579cf6f9e7a1..d0be8d4c8091 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -167,6 +167,7 @@ enum desc_idn {
 	QUERY_DESC_IDN_GEOMETRY		= 0x7,
 	QUERY_DESC_IDN_POWER		= 0x8,
 	QUERY_DESC_IDN_HEALTH           = 0x9,
+	QUERY_DESC_IDN_UNIT_RPMB	= 0xA,
 	QUERY_DESC_IDN_MAX,
 };
 
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 39bf204c6ec3..fcb46c882f1c 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -11,11 +11,12 @@ static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_len,
 {
 	int desc_size = be16_to_cpu(qr->length);
 	int desc_id = qr->idn;
+	int desc_index = qr->index;
 
 	if (desc_size <= 0)
 		return -EINVAL;
 
-	ufshcd_map_desc_id_to_length(hba, desc_id, desc_len);
+	ufshcd_map_desc_id_to_length(hba, desc_id, desc_index, desc_len);
 	if (!*desc_len)
 		return -EINVAL;
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 74ccfd2b80ce..eec1bc95391b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3319,11 +3319,13 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
  * @desc_len: mapped desc length (out)
  */
 void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
-				  int *desc_len)
+				  int desc_index, int *desc_len)
 {
 	if (desc_id >= QUERY_DESC_IDN_MAX || desc_id == QUERY_DESC_IDN_RFU_0 ||
 	    desc_id == QUERY_DESC_IDN_RFU_1)
 		*desc_len = 0;
+	else if (desc_index == UFS_UPIU_RPMB_WLUN)
+		*desc_len = hba->desc_size[QUERY_DESC_IDN_UNIT_RPMB];
 	else
 		*desc_len = hba->desc_size[desc_id];
 }
@@ -3334,14 +3336,16 @@ static void ufshcd_update_desc_length(struct ufs_hba *hba,
 				      unsigned char desc_len)
 {
 	if (hba->desc_size[desc_id] == QUERY_DESC_MAX_SIZE &&
-	    desc_id != QUERY_DESC_IDN_STRING &&
-	    desc_index != UFS_UPIU_RPMB_WLUN)
+	    desc_id != QUERY_DESC_IDN_STRING) {
+		if (desc_index == UFS_UPIU_RPMB_WLUN)
 		/* For UFS 3.1, the normal unit descriptor is 10 bytes larger
 		 * than the RPMB unit, however, both descriptors share the same
-		 * desc_idn, to cover both unit descriptors with one length, we
-		 * choose the normal unit descriptor length by desc_index.
+		 * desc_idn, but differ by the descriptor index
 		 */
-		hba->desc_size[desc_id] = desc_len;
+			hba->desc_size[QUERY_DESC_IDN_UNIT_RPMB] = desc_len;
+		else
+			hba->desc_size[desc_id] = desc_len;
+	}
 }
 
 /**
@@ -3372,7 +3376,7 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		return -EINVAL;
 
 	/* Get the length of descriptor */
-	ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
+	ufshcd_map_desc_id_to_length(hba, desc_id, desc_index, &buff_len);
 	if (!buff_len) {
 		dev_err(hba->dev, "%s: Failed to get desc length\n", __func__);
 		return -EINVAL;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 971cfabc4a1e..c77bef77ec87 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1105,7 +1105,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
 
 void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
-				  int *desc_length);
+				  int desc_index, int *desc_length);
 
 u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);
 
-- 
2.17.1

