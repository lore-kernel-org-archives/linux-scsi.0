Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CA4C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 06:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FD32611C6
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 06:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243426AbhHFGtv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 02:49:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61422 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243437AbhHFGtq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 02:49:46 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210806064929epoutp014eea8cfc67842cb40796d9afa2c17228~YpOUw5AyY0697906979epoutp01r
        for <linux-scsi@vger.kernel.org>; Fri,  6 Aug 2021 06:49:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210806064929epoutp014eea8cfc67842cb40796d9afa2c17228~YpOUw5AyY0697906979epoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628232569;
        bh=gJCCy2Ht0sPXrCRoSqLiiOd5tzgdsC+3Sxg7b2d4PBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=gUtBk4eZEJY95Kxs3YVohaf2SUkojMJEs9LJHKUcxqoEPJs3crgcxNfV/4AKdlJpb
         y4M/dBhYHRSgoDQ7UutY4QqhlDMrT9V3LYBCO7gZPCmSRhzw+lm4i6tobvIajSDUdb
         csGFH6sJ3rZ/a6ynR4mW2ExAobeVCXRp+AfzusYU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210806064928epcas2p2ac917e0d17344f5c78f9b576765f09d2~YpOUEC3QG3198631986epcas2p2n;
        Fri,  6 Aug 2021 06:49:28 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Ggx0j65jRz4x9QK; Fri,  6 Aug
        2021 06:49:25 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.6D.03626.57BDC016; Fri,  6 Aug 2021 15:49:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210806064924epcas2p4572538fd1fa7a73d8262737e38a9b537~YpOQHobrM2181121811epcas2p4q;
        Fri,  6 Aug 2021 06:49:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210806064924epsmtrp1f9e7f456007d9b64e4ad86eeebca6e3b~YpOQGh4fp0395203952epsmtrp1j;
        Fri,  6 Aug 2021 06:49:24 +0000 (GMT)
X-AuditID: b6c32a47-6a9ff70000010e2a-e8-610cdb755f87
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A0.21.32548.47BDC016; Fri,  6 Aug 2021 15:49:24 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210806064924epsmtip141562bf2d87059faaa06d7ef61f1b48d~YpOP21uae3134831348epsmtip12;
        Fri,  6 Aug 2021 06:49:24 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 1/2] scsi: ufs: introduce vendor isr
Date:   Fri,  6 Aug 2021 15:34:11 +0900
Message-Id: <0f6f2337e98f8a8a7dfae816bc001af28fa3a7be.1628231581.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1628231581.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1628231581.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmuW7pbZ5Eg29L9CxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58Hpf7epk8Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkC
        OKJybDJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOADldS
        KEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFBgaFugVJ+YWl+al6yXn51oZGhgYmQJV
        JuRkvPjVy16whb+i4fYRlgbGzzxdjJwcEgImEj+v3GDrYuTiEBLYwSixZMoGKOcTo8TnaUuZ
        IZzPjBLHPm5lhmnpautjA7GFBHYxSsyfJQVR9INRouPYG1aQBJuApsTTm1OZQGwRgX1MEkd3
        pYPYzALqErsmnACLCwtYS/xvWMUOYrMIqEos3dzC0sXIwcErEC3x5kYoxC45iZvnOsH2cgpY
        Siy62c6EzpYQmMkhsbfFFsJ2kfj49CTUncISr45vYYewpSRe9rdB2fUS+6Y2sILcLCHQwyjx
        dN8/RoiEscSsZ+2MIDcwA92/fpc+iCkhoCxx5BYLxPV8Eh2H/7JDhHklOtqEIBqVJX5Nmgw1
        RFJi5s07UJs8JD4/62eHhA7QpnVXtjBPYJSfhbBgASPjKkax1ILi3PTUYqMCY+S428QITqNa
        7jsYZ7z9oHeIkYmD8RCjBAezkghv8mKuRCHelMTKqtSi/Pii0pzU4kOMpsBgnMgsJZqcD0zk
        eSXxhqZGZmYGlqYWpmZGFkrivBpxXxOEBNITS1KzU1MLUotg+pg4OKUamMyd+griTn6P3Hxk
        ZxmfvXSe3vy/5wS3XkgLuu3tbcnLveSGNpfI4vnS8hbqqpVPyy4sFj6eNXX5FW2Re/EPj5x/
        sKZyyXk5HQbtzW53i+cv0md+tkO8ozDHluXOnCf87NdWztY5LZl0cuXFmsr7hS6GXILd09Sn
        Nhdq5nKGpFg/nJn1fKL9mUlpy/43L895zHK39dh9BcX/pXz/X63U+dnwKaNg6RE31Qcvlm27
        sOTSrpWXDYIWz1EvDz/C01+6/J9aVIqOpzRrSPAsDdWd53d/2Nn7f5b7+z2BS1odb25evlvr
        GmNe0tX5drmuL0T3MXUefbzK6WqOyIINohUfvoU+uvv6sJbRd2llseVvOlcpsRRnJBpqMRcV
        JwIA0Ct3AiwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnG7JbZ5Eg/6PUhYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLm1uOslhc3jWHzaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8t9vUwei/e8ZPKYsOgAo8f39R1sHh+f3mLx6NuyitHj8yY5j/YD3UwB
        HFFcNimpOZllqUX6dglcGS9+9bIXbOGvaLh9hKWB8TNPFyMnh4SAiURXWx9bFyMXh5DADkaJ
        fXNvsEEkJCVO7HzOCGELS9xvOcIKYgsJfGOU+DM/EMRmE9CUeHpzKhNIs4jAOSaJqZeXMoEk
        mAXUJXZNOAFmCwtYS/xvWMUOYrMIqEos3dzC0sXIwcErEC3x5kYoxHw5iZvnOplBbE4BS4lF
        N9uZIHZZSKza+5wNl/gERoEFjAyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCI0FL
        awfjnlUf9A4xMnEwHmKU4GBWEuFNXsyVKMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB
        9MSS1OzU1ILUIpgsEwenVAOTwqGphyVYsi75y1nfihFzt79VrXvOVGnlmj8Zq77yBFVJ7fq4
        uuzAPZM/zM+4DSS8Nl9f/7zIad1KTZPjj/3WXtRxzWd8Vd0b3HPkmrBgAU9AlLx5pkL5LL2z
        Nh0fZiQ6P/5keir4yXzjJMcojvuL1dl52yJV7ASLa+zWLE17075OUbXRJTSc46xu3VRVXt/d
        vx8/trNxuT5pl5PMgv0pklOXVxUCU5749aZag5yboiE5v8S1hVK3BvQH1TFanbz2JPXujFfN
        270sZ59Wdi2cK5qlzD+pZeqWm7+X7Fp+cMnO0FfSbfe3d0fGr1g9d13rgfWCTPFML/8u/VOY
        mXxm/g2JxFOHJOxm1T45WqXEUpyRaKjFXFScCACDScjg8wIAAA==
X-CMS-MailID: 20210806064924epcas2p4572538fd1fa7a73d8262737e38a9b537
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210806064924epcas2p4572538fd1fa7a73d8262737e38a9b537
References: <cover.1628231581.git.kwmad.kim@samsung.com>
        <CGME20210806064924epcas2p4572538fd1fa7a73d8262737e38a9b537@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is to activate some interrupt sources
that aren't defined in UFSHCI specifications. Those
purpose could be error handling, workaround or whatever.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 10 ++++++++++
 drivers/scsi/ufs/ufshcd.h |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 05495c34a2b7..f85a9b335e0b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6428,6 +6428,16 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
 	irqreturn_t retval = IRQ_NONE;
+	int res = 0;
+	unsigned long flags;
+
+	retval = ufshcd_vops_intr(hba, &res);
+	if (res) {
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->force_reset = true;
+		ufshcd_schedule_eh_work(hba);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
 
 	if (intr_status & UFSHCD_UIC_MASK)
 		retval |= ufshcd_uic_cmd_compl(hba, intr_status);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 971cfabc4a1e..1ed0a911f864 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -356,6 +356,7 @@ struct ufs_hba_variant_ops {
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
+	irqreturn_t	(*intr)(struct ufs_hba *hba, int *res);
 };
 
 /* clock gating state  */
@@ -1296,6 +1297,13 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }
 
+static inline irqreturn_t ufshcd_vops_intr(struct ufs_hba *hba, int *res)
+{
+	if (hba->vops && hba->vops->intr)
+		return hba->vops->intr(hba, res);
+	return IRQ_NONE;
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /*
-- 
2.31.1

