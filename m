Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20465C63777
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 21:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B280721D7A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 21:57:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="vg3y/EoH";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="vg3y/EoH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732398AbgK0V5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 16:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732290AbgK0V4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Nov 2020 16:56:34 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69858C0613D1;
        Fri, 27 Nov 2020 13:56:34 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 3ABD812805D5;
        Fri, 27 Nov 2020 13:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1606514192;
        bh=Ea+FO6Fv9PXJHIW1GiZoH8O6dvYG/m+z/pyBfg8cp4g=;
        h=Message-ID:Subject:From:To:Date:From;
        b=vg3y/EoHrnXmxuk3/695z5cvoNPCQEqicy9H5cuvk/s4/b4GSGamB2ayXNopFWUeV
         ziYnovXjSkixTFgqLoGHQHzF/WDiT9gN7xEIDq8V65jMr8vzw0ZceQantngt+pdpSJ
         cCtE4UNU92Pgan6LZ1asfkoDrNg7qBt7f0zcU+Ho=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RjZBCclJDqXV; Fri, 27 Nov 2020 13:56:32 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C99F212805CF;
        Fri, 27 Nov 2020 13:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1606514192;
        bh=Ea+FO6Fv9PXJHIW1GiZoH8O6dvYG/m+z/pyBfg8cp4g=;
        h=Message-ID:Subject:From:To:Date:From;
        b=vg3y/EoHrnXmxuk3/695z5cvoNPCQEqicy9H5cuvk/s4/b4GSGamB2ayXNopFWUeV
         ziYnovXjSkixTFgqLoGHQHzF/WDiT9gN7xEIDq8V65jMr8vzw0ZceQantngt+pdpSJ
         cCtE4UNU92Pgan6LZ1asfkoDrNg7qBt7f0zcU+Ho=
Message-ID: <4340233ae5e105c5617401f84a5ed13c341f5ecf.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.10-rc5
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 27 Nov 2020 13:56:30 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three small fixes in the UFS driver: two are for power management
issues and the third is to fix a slew of problem in the sysfs code.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Can Guo (2):
      scsi: ufs: Make sure clk scaling happens only when HBA is runtime ACTIVE
      scsi: ufs: Fix unexpected values from ufshcd_read_desc_param()

Stanley Chu (1):
      scsi: ufs: Fix race between shutdown and runtime resume flow

And the diffstat:

 drivers/scsi/ufs/ufshcd.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7a160b86adc6..0c148fcd24de 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1294,8 +1294,15 @@ static int ufshcd_devfreq_target(struct device *dev,
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
+	pm_runtime_get_noresume(hba->dev);
+	if (!pm_runtime_active(hba->dev)) {
+		pm_runtime_put_noidle(hba->dev);
+		ret = -EAGAIN;
+		goto out;
+	}
 	start = ktime_get();
 	ret = ufshcd_devfreq_scale(hba, scale_up);
+	pm_runtime_put(hba->dev);
 
 	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
 		(scale_up ? "up" : "down"),
@@ -3192,13 +3199,19 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	/* Get the length of descriptor */
 	ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
 	if (!buff_len) {
-		dev_err(hba->dev, "%s: Failed to get desc length", __func__);
+		dev_err(hba->dev, "%s: Failed to get desc length\n", __func__);
+		return -EINVAL;
+	}
+
+	if (param_offset >= buff_len) {
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
@@ -3212,14 +3225,14 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
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
@@ -3229,12 +3242,12 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
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
@@ -8900,11 +8913,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
 		goto out;
 
-	if (pm_runtime_suspended(hba->dev)) {
-		ret = ufshcd_runtime_resume(hba);
-		if (ret)
-			goto out;
-	}
+	pm_runtime_get_sync(hba->dev);
 
 	ret = ufshcd_suspend(hba, UFS_SHUTDOWN_PM);
 out:

