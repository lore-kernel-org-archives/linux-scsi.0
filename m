Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A30C25B46
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 20:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjJWUM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 16:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJWUM0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 16:12:26 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF841A4
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 13:12:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7cc433782so46406637b3.3
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 13:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698091943; x=1698696743; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TaYzqiDcDWKgPy4uGsQmrLXLk2sBD/yDm1Jxt8SJs8M=;
        b=LnZYaIDMWg7IVK3lRjrc4+EjjUnh2MqiMWJr6ZhH+lryJnEi0uAS0ExJiY2S3qaiRi
         lvj1k9OzrDh7YRMoSDet2GGQdOYCAMqcFl+nfTNqWfnDZ+6t7SHF0y+4TF9ia4VY/gNk
         k8UEY9gH1DYd/HaaLsTbimpBvZhz0TIl/RUyHJZJgMEi9O4E+d80sGONz8ibFO6V7VtE
         U7IlvLtoUcRY/PNfMLM/EIM1mdlKrRfkWM5Dj8X1DTnwaNV7HyCWzvjipyTL9aYR82c9
         +R4yo0XTvm7pGEz0RLLzwJRdH4N5Q/aDpRMeuO3Jz5MhVDQxcPZZKubPPp9h75GJGZH8
         XfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698091943; x=1698696743;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TaYzqiDcDWKgPy4uGsQmrLXLk2sBD/yDm1Jxt8SJs8M=;
        b=fxDsfgoPd3vAOKsB0mDG2qolPRE+W89Ayuhlk0ZSRcE2eOGwpL91+o9+72kDNI3HNB
         W4hQVRDwFKcJfasGQzQU0j7tjc4xagXj/j8tmyjHs5Lc18/KEUNIEL6wRvrEir7jM/Jd
         Ly+FAWT4vLujokDxH3w5JSpih+pwFsKKIuwAMB2aNyUr8ysRvmmsV7b/LRPYlpoD+Drs
         ob6xJzl+tIRYgC3qyM3NXa4GZu0N6B/BUcgqZtxIzFrjlmoTjDf/cMZmytfGcoj7oLVo
         c41ATTJNrui0Bsaf7oDLayLp6fWooWo02GLoiQWb7psKpd0mgkNBDp6nl+842i9nqWuB
         EYKg==
X-Gm-Message-State: AOJu0Yw0F4hMoBw121qkQL0HC2ulW3wgNsHJmh7r4KilyTxRqshV587p
        FPvMVn57CAm94j16RdPN5yE7Fks/toHCmdOIvQ==
X-Google-Smtp-Source: AGHT+IHDcQhZF3S6ev46PsP31VJ143R9m5nA9+25vhWXz518arOoV43l0DM3lCYGWdXUSli8kfuj4DTuRkUgpAueEw==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a25:8485:0:b0:da0:394d:7e19 with SMTP
 id v5-20020a258485000000b00da0394d7e19mr3980ybk.12.1698091943613; Mon, 23 Oct
 2023 13:12:23 -0700 (PDT)
Date:   Mon, 23 Oct 2023 20:12:22 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAKXTNmUC/y2NQQqDQAxFryJZN6AzjpRepRSxMaPZjJIUUWTu3
 kFcPD5v898Jxips8KpOUN7EZElFmkcFNA9pYpSxOLja+aaA9tNE64GjysZqaGSC37S7SPf0kRZ Gwuha78Oz7dgHKH+rcpT9ar0/Of8B91Q6OnsAAAA=
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1698091942; l=3749;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=nllTzTiPjRT5s2K8r25wvqMnTGFjjYXsOSJyrZ516eA=; b=Cfv7kTFGU3by66ZpqIYT0fT+2TqTsEGOn7q86guhmaK5u4xcxkPzCD4nMiXOHBYWA55tKtuJG
 u/PgjCIgPA1AJ7eSIxsqoVNfvWZeb5i6SozixjafFpQAGDMsEsAhjTE
X-Mailer: b4 0.12.3
Message-ID: <20231023-strncpy-drivers-scsi-bnx2fc-bnx2fc_fcoe-c-v1-1-a3736943cde2@google.com>
Subject: [PATCH] scsi: bnx2fc: replace deprecated strncpy with strscpy
From:   Justin Stitt <justinstitt@google.com>
To:     Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

strncpy() is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

We expect hba->chip_num to be NUL-terminated based on its usage with
format strings:

	snprintf(fc_host_symbolic_name(lport->host), 256,
		 "%s (QLogic %s) v%s over %s",
		BNX2FC_NAME, hba->chip_num, BNX2FC_VERSION,
		interface->netdev->name);

Moreover, NUL-padding is not required as hba is zero-allocated from its
callsite:

	hba = kzalloc(sizeof(*hba), GFP_KERNEL);

Considering the above, a suitable replacement is `strscpy` [2] due to
the fact that it guarantees NUL-termination on the destination buffer
without unnecessarily NUL-padding.

Regarding stats_addr->version, I've opted to also use strscpy() instead
of strscpy_pad() as I typically see these XYZ_get_strings() pass
zero-allocated data. I couldn't track all of where
bnx2fc_ulp_get_stats() is used and if required, we could opt for
strscpy_pad().

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.

Found with: $ rg "strncpy\("
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 05ddbb9bb7d8..3ebfb09329ad 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1737,32 +1737,32 @@ static int bnx2fc_bind_pcidev(struct bnx2fc_hba *hba)
 
 	switch (pdev->device) {
 	case PCI_DEVICE_ID_NX2_57710:
-		strncpy(hba->chip_num, "BCM57710", BCM_CHIP_LEN);
+		strscpy(hba->chip_num, "BCM57710", sizeof(hba->chip_num));
 		break;
 	case PCI_DEVICE_ID_NX2_57711:
-		strncpy(hba->chip_num, "BCM57711", BCM_CHIP_LEN);
+		strscpy(hba->chip_num, "BCM57711", sizeof(hba->chip_num));
 		break;
 	case PCI_DEVICE_ID_NX2_57712:
 	case PCI_DEVICE_ID_NX2_57712_MF:
 	case PCI_DEVICE_ID_NX2_57712_VF:
-		strncpy(hba->chip_num, "BCM57712", BCM_CHIP_LEN);
+		strscpy(hba->chip_num, "BCM57712", sizeof(hba->chip_num));
 		break;
 	case PCI_DEVICE_ID_NX2_57800:
 	case PCI_DEVICE_ID_NX2_57800_MF:
 	case PCI_DEVICE_ID_NX2_57800_VF:
-		strncpy(hba->chip_num, "BCM57800", BCM_CHIP_LEN);
+		strscpy(hba->chip_num, "BCM57800", sizeof(hba->chip_num));
 		break;
 	case PCI_DEVICE_ID_NX2_57810:
 	case PCI_DEVICE_ID_NX2_57810_MF:
 	case PCI_DEVICE_ID_NX2_57810_VF:
-		strncpy(hba->chip_num, "BCM57810", BCM_CHIP_LEN);
+		strscpy(hba->chip_num, "BCM57810", sizeof(hba->chip_num));
 		break;
 	case PCI_DEVICE_ID_NX2_57840:
 	case PCI_DEVICE_ID_NX2_57840_MF:
 	case PCI_DEVICE_ID_NX2_57840_VF:
 	case PCI_DEVICE_ID_NX2_57840_2_20:
 	case PCI_DEVICE_ID_NX2_57840_4_10:
-		strncpy(hba->chip_num, "BCM57840", BCM_CHIP_LEN);
+		strscpy(hba->chip_num, "BCM57840", sizeof(hba->chip_num));
 		break;
 	default:
 		pr_err(PFX "Unknown device id 0x%x\n", pdev->device);
@@ -1800,7 +1800,7 @@ static int bnx2fc_ulp_get_stats(void *handle)
 	if (!stats_addr)
 		return -EINVAL;
 
-	strncpy(stats_addr->version, BNX2FC_VERSION,
+	strscpy(stats_addr->version, BNX2FC_VERSION,
 		sizeof(stats_addr->version));
 	stats_addr->txq_size = BNX2FC_SQ_WQES_MAX;
 	stats_addr->rxq_size = BNX2FC_CQ_WQES_MAX;

---
base-commit: 9c5d00cb7b6bbc5a7965d9ab7d223b5402d1f02c
change-id: 20231023-strncpy-drivers-scsi-bnx2fc-bnx2fc_fcoe-c-f24335846e35

Best regards,
--
Justin Stitt <justinstitt@google.com>

