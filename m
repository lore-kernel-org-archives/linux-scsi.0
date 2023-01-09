Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D70C54EBD
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbjAIXWj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbjAIXWi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:38 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E6F38BC
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:37 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so14477254pjg.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3YGfo3Ab/nIS1rG0NDx9hRuWBzX86hr1xQC26F1FiM=;
        b=I/3v57X5t4isgv3GWZw+QZIdxUO0p9j5BDA9oR6FGTIJBSIvmpX5aMhJBjalWM3vwW
         n2UHUPKR+kX7cFrOpuCvXxfgGV6SGsA8XvB6PjRy0NsM6MtP0W117fD0C4iyZE5Rupe4
         rs25vkxZy4qUP/xrk2xV/hj4gQEDk+EIQNg7fuEJ0gYIwoJJHflhBYZjIg5jHr3SwX5n
         VR/hi4A7NMDclnOKnGLk2iyx3nt1DN2QbsvrYHAXIs2LXdYHoO5aY1zostup2DvhKvo9
         s5RRqtLlj3DxVOFg+KXUkNew9jcoWyaPkIWcGSRHpjdMf2hW49odC0Ge5T3hGAAq9Eqq
         bQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3YGfo3Ab/nIS1rG0NDx9hRuWBzX86hr1xQC26F1FiM=;
        b=PY/H4/saAaZeysH+KBXJxbUPQvHX2fESrD1v+2c7w4R6ejl1i6/wK/8RsM3zChyWi+
         Ykzs9Y9lO/ES/5m3M9eV1xoYyXKarZ4KYf4NtFZcT2n7+so5008jbFAyk2MtRJ6QemXm
         UjUDAX06t6H0Bd/qrrdzl2fSGRKLTNhhG6OL15onUlzuUZddO2AZhBXNTwJyJhOIw95+
         CbQcUaw5DBF7VuHMqDZpw8nR4/Xh7HncIEYM+tn9cwwmurTl03eYOi+clw+ejT+/JZMD
         C6y+2WoMSxrQCgncb3Eb8m7fmzTwdSTYFbQz3QWxiiUqs28O7Koe0UKD1uy5fLFHtJTy
         M8Jw==
X-Gm-Message-State: AFqh2kptY6zFsuetZd9HW228FhNQhOwxSNAJDOTYk+jLhXWfi/G9CaVF
        JzDm1f+6xGbPytd8o7HKmBUlGMDX/3c=
X-Google-Smtp-Source: AMrXdXvJCBIVcGIAkeJ9c3eJbKTnrPA0cTWm/t2vMNzhMcc1kitKVG98ZrWdWcH8pAiBUWt/ZMM3iA==
X-Received: by 2002:a17:902:c643:b0:192:4c84:4508 with SMTP id s3-20020a170902c64300b001924c844508mr61442672pls.20.1673306556726;
        Mon, 09 Jan 2023 15:22:36 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:36 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 01/12] lpfc: Fix space indentation in lpfc_xcvr_data
Date:   Mon,  9 Jan 2023 15:33:06 -0800
Message-Id: <20230109233317.54737-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The kernel test robot detected inconsistent indentations for an if
statement block in the lpfc_xcvr_data_show routine.

This patch reduces the extraneous tabs used for the if statement block in
question.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 46 +++++++++++++++--------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 77e1b2911cb4..9df90c0ab44d 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1941,33 +1941,25 @@ lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
 			&rdp_context->page_a0[SSF_TRANSCEIVER_CODE_B7];
 
 	len += scnprintf(buf + len, PAGE_SIZE - len, "Speeds: \t");
-		if (*(uint8_t *)trasn_code_byte7 == 0) {
-			len += scnprintf(buf + len, PAGE_SIZE - len,
-					 "Unknown\n");
-		} else {
-			if (trasn_code_byte7->fc_sp_100MB)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "1 ");
-			if (trasn_code_byte7->fc_sp_200mb)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "2 ");
-			if (trasn_code_byte7->fc_sp_400MB)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "4 ");
-			if (trasn_code_byte7->fc_sp_800MB)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "8 ");
-			if (trasn_code_byte7->fc_sp_1600MB)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "16 ");
-			if (trasn_code_byte7->fc_sp_3200MB)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "32 ");
-			if (trasn_code_byte7->speed_chk_ecc)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "64 ");
-			len += scnprintf(buf + len, PAGE_SIZE - len, "GB\n");
-		}
+	if (*(uint8_t *)trasn_code_byte7 == 0) {
+		len += scnprintf(buf + len, PAGE_SIZE - len, "Unknown\n");
+	} else {
+		if (trasn_code_byte7->fc_sp_100MB)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "1 ");
+		if (trasn_code_byte7->fc_sp_200mb)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "2 ");
+		if (trasn_code_byte7->fc_sp_400MB)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "4 ");
+		if (trasn_code_byte7->fc_sp_800MB)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "8 ");
+		if (trasn_code_byte7->fc_sp_1600MB)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "16 ");
+		if (trasn_code_byte7->fc_sp_3200MB)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "32 ");
+		if (trasn_code_byte7->speed_chk_ecc)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "64 ");
+		len += scnprintf(buf + len, PAGE_SIZE - len, "GB\n");
+	}
 	temperature = (rdp_context->page_a2[SFF_TEMPERATURE_B1] << 8 |
 		       rdp_context->page_a2[SFF_TEMPERATURE_B0]);
 	vcc = (rdp_context->page_a2[SFF_VCC_B1] << 8 |
-- 
2.38.0

