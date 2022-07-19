Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29F0C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 00:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbiGSAUJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 20:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiGSAUI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 20:20:08 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A9E37F86
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 17:20:05 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so14211461pjf.2
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 17:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O4T2VQDxAWCrJIF9JXck1NEHm4y5ISvV3hD9xQiPuAk=;
        b=jHJtw10vDryNboN4iS1vTEDcw4++rsAMT+oMpC4qCdktpwfJXav5atwlQxJUQlAlUt
         WkrprZ+wNT5qddGI+8++AcfEe7GtK7aMNOtCSRqWmp5bzm2S+AwgyFmatEA+Bi7ns53V
         u2S4UeWl/z22mWLYSEgXP17ktwllvML1VWN3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O4T2VQDxAWCrJIF9JXck1NEHm4y5ISvV3hD9xQiPuAk=;
        b=SGq7In7U+WeLGtJbpF1wxF/FaPAS9csIn8X7JM1bUnwAoUMrSZOaCcS00nfWrsnzgm
         qO2c+H22PRdpOwB17IiyMTvttzxrtX5DvegCKfyrSf8CLahn1dT0IrvJj4MIF/g4jlm4
         n2D07R29CNBvKQ5HUwPc6Jn5fvcz4mPIzCdl9iTWNadkrvIDxy50p1MkOCD8nZpOeovd
         mLw0aXNk2m4iQAF5LvyJZ3pnlqn+B0BHbe7ZO4JrplRuACIWbiaTEvpdLGSSIoSJpHek
         cThx0VnN1alDkbROmBwwSi5Thu0uBEvaoDyYUW50rnxd5P9h873A5b6KuSLYNH3tSE7h
         gqGw==
X-Gm-Message-State: AJIora+VnQqhsbjxLbnDXH+r5YpJRLBSgJZazWDFvdgyMR0FevpXHE+M
        guFRKhfEj24WuPXJ60/iBmL0bA==
X-Google-Smtp-Source: AGRyM1vF7G9VIj7hNbh/uQX4M+nAU6jRINRgeMGqfALml7DCCkNmCtqF4Gk9efWCuSb0ZblQJ/RjNw==
X-Received: by 2002:a17:90a:f404:b0:1f1:fd63:281a with SMTP id ch4-20020a17090af40400b001f1fd63281amr705772pjb.158.1658190005301;
        Mon, 18 Jul 2022 17:20:05 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id a8-20020a1709027e4800b0016cbb46806asm9075813pln.278.2022.07.18.17.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 17:20:04 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: ufs: ufs-pci: Correct check for RESET DSM
Date:   Tue, 19 Jul 2022 10:19:54 +1000
Message-Id: <20220719101903.v2.1.I22460c4f4a9ccf2c96c3f9bb392b409926d80b2f@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dsm_fns is a bitmap, and it is 0-indexed according to the check in
__intel_dsm funciton. But common initialization was checking it as if it
was 1-indexed. The CL corrects the discrepancy. This change won't break
any existing calls to the function, since before the change both bits 0
and 1 were checked and needed to be set.

Signed-off-by: Daniil Lunev <dlunev@chromium.org>

---

Changes in v2:
* Make __INTEL_DSM_SUPPORTED a function
* use `1u` instead of `1` in shift operator

 drivers/ufs/host/ufshcd-pci.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 04166bda41daa..c13c31c2ae793 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -24,7 +24,7 @@ struct ufs_host {
 	void (*late_init)(struct ufs_hba *hba);
 };
 
-enum {
+enum intel_ufs_dsm_func_id {
 	INTEL_DSM_FNS		=  0,
 	INTEL_DSM_RESET		=  1,
 };
@@ -42,6 +42,15 @@ static const guid_t intel_dsm_guid =
 	GUID_INIT(0x1A4832A0, 0x7D03, 0x43CA,
 		  0xB0, 0x20, 0xF6, 0xDC, 0xD1, 0x2A, 0x19, 0x50);
 
+static bool __intel_dsm_supported(struct intel_host *host,
+				   enum intel_ufs_dsm_func_id fn)
+{
+	return fn < 32 && fn >= 0 && (host->dsm_fns & (1u << fn));
+}
+
+#define INTEL_DSM_SUPPORTED(host, name) \
+	__intel_dsm_supported(host, INTEL_DSM_##name)
+
 static int __intel_dsm(struct intel_host *intel_host, struct device *dev,
 		       unsigned int fn, u32 *result)
 {
@@ -71,7 +80,7 @@ static int __intel_dsm(struct intel_host *intel_host, struct device *dev,
 static int intel_dsm(struct intel_host *intel_host, struct device *dev,
 		     unsigned int fn, u32 *result)
 {
-	if (fn > 31 || !(intel_host->dsm_fns & (1 << fn)))
+	if (!__intel_dsm_supported(intel_host, fn))
 		return -EOPNOTSUPP;
 
 	return __intel_dsm(intel_host, dev, fn, result);
@@ -300,7 +309,7 @@ static int ufs_intel_device_reset(struct ufs_hba *hba)
 {
 	struct intel_host *host = ufshcd_get_variant(hba);
 
-	if (host->dsm_fns & INTEL_DSM_RESET) {
+	if (INTEL_DSM_SUPPORTED(host, RESET)) {
 		u32 result = 0;
 		int err;
 
@@ -342,7 +351,7 @@ static int ufs_intel_common_init(struct ufs_hba *hba)
 		return -ENOMEM;
 	ufshcd_set_variant(hba, host);
 	intel_dsm_init(host, hba->dev);
-	if (host->dsm_fns & INTEL_DSM_RESET) {
+	if (INTEL_DSM_SUPPORTED(host, RESET)) {
 		if (hba->vops->device_reset)
 			hba->caps |= UFSHCD_CAP_DEEPSLEEP;
 	} else {
-- 
2.31.0

