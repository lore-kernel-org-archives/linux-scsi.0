Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B12C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 10:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B5B22222D
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 10:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393189AbgJTKar (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 06:30:47 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:2361 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393162AbgJTK3r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 06:29:47 -0400
IronPort-SDR: 1H2J4JFXZ2SPeNm32kfrUm5ItULGpxgfsxmluksRPcGf9vKAhDOJORoZqzRq4ItvjVvesza+u3
 UDzwuMwL6Gx/gDgGEcZbBjvITuSyQRtx4XD7jeg9bDruVKzcna03J85EaNpkcGJmnS6cYtw8iR
 2qpsuGLgb8yqUyVVY7M9KbtLHXNyTUgqgmbY0GRpa1FzsX9hNGtshj725FB4H2lhRpr3QsXu6E
 p/gVsHcVA4bdQgTpEV2mBPPA0v4FLUI2zRcr91Obp7GLL9raEG1IbUobX15wObkoImyh1TlK7c
 ejU=
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="scan'208";a="29218188"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 20 Oct 2020 03:29:47 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 20 Oct 2020 03:29:46 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 1F57B217A5; Tue, 20 Oct 2020 03:29:46 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: ufs: Fix unexpected values get from ufshcd_read_desc_param()
Date:   Tue, 20 Oct 2020 03:29:06 -0700
Message-Id: <1603189751-26541-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since WB feature has been added, WB related sysfs entries can be accessed
even when an UFS device does not support WB feature. In that case, the
descriptors which are not supported by the UFS device may be wrongly
reported when they are accessed from their corrsponding sysfs entries.
Fix it by adding a sanity check of parameter offset against the actual
decriptor length.

Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a2ebcc8..8861ad6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3184,13 +3184,19 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	/* Get the length of descriptor */
 	ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
 	if (!buff_len) {
-		dev_err(hba->dev, "%s: Failed to get desc length", __func__);
+		dev_err(hba->dev, "%s: Failed to get desc length\n", __func__);
+		return -EINVAL;
+	}
+
+	if (param_offset >= buff_len)
+		dev_err(hba->dev, "%s: Invalid offset 0x%x in descriptor IDN 0x%x, length 0x%x\n",
+			__func__, param_offset, desc_id, buff_len);
 		return -EINVAL;
 	}
 
 	/* Check whether we need temp memory */
 	if (param_offset != 0 || param_size < buff_len) {
-		desc_buf = kmalloc(buff_len, GFP_KERNEL);
+		desc_buf = kzalloc(buff_len, GFP_KERNEL);
 		if (!desc_buf)
 			return -ENOMEM;
 	} else {
@@ -3204,14 +3210,14 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 					desc_buf, &buff_len);
 
 	if (ret) {
-		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
+		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d\n",
 			__func__, desc_id, desc_index, param_offset, ret);
 		goto out;
 	}
 
 	/* Sanity check */
 	if (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] != desc_id) {
-		dev_err(hba->dev, "%s: invalid desc_id %d in descriptor header",
+		dev_err(hba->dev, "%s: invalid desc_id %d in descriptor header\n",
 			__func__, desc_buf[QUERY_DESC_DESC_TYPE_OFFSET]);
 		ret = -EINVAL;
 		goto out;
@@ -3221,12 +3227,12 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	buff_len = desc_buf[QUERY_DESC_LENGTH_OFFSET];
 	ufshcd_update_desc_length(hba, desc_id, desc_index, buff_len);
 
-	/* Check wherher we will not copy more data, than available */
-	if (is_kmalloc && (param_offset + param_size) > buff_len)
-		param_size = buff_len - param_offset;
-
-	if (is_kmalloc)
+	if (is_kmalloc) {
+		/* Make sure we don't copy more data than available */
+		if (param_offset + param_size > buff_len)
+			param_size = buff_len - param_offset;
 		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
+	}
 out:
 	if (is_kmalloc)
 		kfree(desc_buf);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

