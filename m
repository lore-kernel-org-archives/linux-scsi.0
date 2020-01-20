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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F995C33CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53A8A22525
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:09:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KEpR7IBa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgATNJw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:09:52 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35450 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgATNJw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 08:09:52 -0500
Received: by mail-wr1-f68.google.com with SMTP id g17so29471035wro.2;
        Mon, 20 Jan 2020 05:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/3xFRKoJ9mK9crMSN19CDem50p2shDlmdkEhOU+c0tI=;
        b=KEpR7IBaaatng20qXd0/G9/SujrmK4kv3BcyhpbGINjOPUOCsTiJ+hO42+JPH68g+z
         NCalyaeCyVnOjWtIz8l+F5UNeF0KlbbWDKk2t6GGiF0pbhhHW5J1lHyAKtxDl8wS4Uz8
         eBiI1JGYJ0wwk5J4cS7LvVvGPMwxqsUCI95dpVAKLaFAPYBxz654Vn8XOwfAvvGrdGuq
         SIuwkniMUgAOF43majTmje8zGIaGbzpdE90CnvKyJNzh+GLDpBqQCagFdXnNjT+El239
         4pKf59FH2dm3tsj+cac233JKH9BzL4NdHyPPXfVKGYhOiBpJpj5zrG7UxCez479mb+eC
         vmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/3xFRKoJ9mK9crMSN19CDem50p2shDlmdkEhOU+c0tI=;
        b=Q9DIgBuZq4Cnl2ZxBKD80MIgDvvOr5pDmFIq757L2Lf+hn7bgz1BDc1LoR0NdhB6fJ
         d2FC5JuULkAMuX1cIxcv1Bb8QdkUzzyVJXN989Dw+ZZdGJdmkB7vDeES2AHLoOhY1+XF
         nC4SeNL8Hx0dN7DMp7vHTZp4T1vZJlRwn9In05lGtpZ+yD72OtEnBWID+hYfqs47GYsJ
         nh4o9mA4crcCyEeUXmx/k/zNIAk5d936z2M2PhN3/NdAZNOA+IvSkFbZdcAq0+5z7wjc
         06hsCHyWPFMcRVZANjdh2M4s+mMXX9imlbvDXupqV9/ZMBrYoIjPTtq+7/1Phf7s+SvO
         EtgQ==
X-Gm-Message-State: APjAAAVR91OIIxyzpBwkny6Uhnfm6x5QC9xdtVKK4z39TWB+IsQj9i8c
        KtajAy0P0PVlyvRsjwzfyhQ=
X-Google-Smtp-Source: APXvYqwnABy9fYgHh+NbPDAbrxy+R7YiJzxS1mB9B9LHjKk6cB/sI+2pMGOW2qv2xluFRmgVyJMJ/Q==
X-Received: by 2002:adf:df0e:: with SMTP id y14mr17429525wrl.377.1579525790516;
        Mon, 20 Jan 2020 05:09:50 -0800 (PST)
Received: from ubuntu-G3.micron.com ([165.225.86.138])
        by smtp.gmail.com with ESMTPSA id p18sm23065386wmb.8.2020.01.20.05.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:09:49 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/8] scsi: ufs: Inline two functions into their callers
Date:   Mon, 20 Jan 2020 14:08:17 +0100
Message-Id: <20200120130820.1737-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200120130820.1737-1-huobean@gmail.com>
References: <20200120130820.1737-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete ufshcd_read_power_desc() and ufshcd_read_device_desc(), directly
inline ufshcd_read_desc() into its callers.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5dfe760f2786..3d3289bb3cad 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3146,17 +3146,6 @@ static inline int ufshcd_read_desc(struct ufs_hba *hba,
 	return ufshcd_read_desc_param(hba, desc_id, desc_index, 0, buf, size);
 }
 
-static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
-					 u8 *buf,
-					 u32 size)
-{
-	return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
-}
-
-static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
-{
-	return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
-}
 
 /**
  * struct uc_string_id - unicode string
@@ -6493,7 +6482,8 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 	if (!desc_buf)
 		return;
 
-	ret = ufshcd_read_power_desc(hba, desc_buf, buff_len);
+	ret = ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0,
+			desc_buf, buff_len);
 	if (ret) {
 		dev_err(hba->dev,
 			"%s: Failed reading power descriptor.len = %d ret = %d",
@@ -6599,7 +6589,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
-	err = ufshcd_read_device_desc(hba, desc_buf, hba->desc_size.dev_desc);
+	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, desc_buf,
+			hba->desc_size.dev_desc);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
-- 
2.17.1

