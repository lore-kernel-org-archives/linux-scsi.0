Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78003C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 01:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbiG1BSb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jul 2022 21:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbiG1BSa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2022 21:18:30 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D009820F5C
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2022 18:18:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d3so492881pls.4
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2022 18:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DbJ1JQagj5h+ZbT03NPdBvoB9tQLkDVPT4NuZ0/GtLk=;
        b=E3EHc2z1Ho78zDYmfDRILIQg6ZXyLq0LWBpNb80YqCkQ51v9w9qHNQQjXRr7i6u32+
         RB9ZdJgYENhwccpgPQMp8OKYaniR1UkP9XcCOFTIqlFnsx9O28uvE9oKk1J2m8srzCZJ
         sGA8DqCGTQUfQ6Z0Z0mBNnvTUdpiZe52kCxMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DbJ1JQagj5h+ZbT03NPdBvoB9tQLkDVPT4NuZ0/GtLk=;
        b=fEhhZcT1n+yUge9ljtQlF3cdXjNxJY1mgTrwIPIT266rrtl5paTKXibgTtBrhBLItG
         291R2pAlWLwnw344P3er5YbFckCFaYFA7T45OWlM8RaUWfbV1s27z5hL/GPLzeOxkfYF
         2r9urE9q/o5CLwxuvJCDyN2ZJi+APP6HGmyArcS+RXx6gd34xNoVtB60OmhKb5Tn70Ug
         CSj6xoBJp1ZsDDjz2h/fHD4dLNGtFJ572M+bjsOHgxdQWb2c69l7Hi7VySA6bsPVJFRl
         bsZVqCcUgDoUAW++tonh7HiwV93CEmlelfg4KqIZanS8d1ykUoohmqUvrmEJNY017eWL
         dzdg==
X-Gm-Message-State: AJIora87ciSLjbdWHGlW/dbazVeNzz8aUOEc9+jez+o76qmEJ3LMmv/z
        dfTw+t0RVpdbbXEgP7uZJG+hOA==
X-Google-Smtp-Source: AGRyM1tCPi0ohc89CBXSKZxfLRltdXXs8O6uc+qjEJHGaLQkOtqcpqh+t16kXliEsJVbuwrhb7K7rQ==
X-Received: by 2002:a17:90b:3ec1:b0:1f1:edcf:dd2b with SMTP id rm1-20020a17090b3ec100b001f1edcfdd2bmr7703792pjb.156.1658971108399;
        Wed, 27 Jul 2022 18:18:28 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902f60300b0016bdea07b9esm14294309plg.190.2022.07.27.18.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 18:18:28 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v3] scsi: ufs: ufs-pci: Correct check for RESET DSM
Date:   Thu, 28 Jul 2022 11:18:21 +1000
Message-Id: <20220728111748.v3.1.I22460c4f4a9ccf2c96c3f9bb392b409926d80b2f@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dsm_fns is a bitmap, and it is 0-indexed according to the check in
__intel_dsm function. But common initialization was checking it as if it
was 1-indexed. This patch corrects the discrepancy. This change won't
break any existing calls to the function, since before the change both
bits 0 and 1 were checked and needed to be set.

Signed-off-by: Daniil Lunev <dlunev@chromium.org>

---

Changes in v3:
* Commit message typos
* Args indentation

Changes in v2:
* Make __INTEL_DSM_SUPPORTED a function
* use `1u` instead of `1` in shift operator

 drivers/ufs/host/ufshcd-pci.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 04166bda41daa..b9572fcc3bda5 100644
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
+				  enum intel_ufs_dsm_func_id fn)
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

