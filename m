Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF332C25B45
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 20:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjJWU0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 16:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJWU0Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 16:26:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB2DB3
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 13:26:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d99ec34829aso4408409276.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 13:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698092773; x=1698697573; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zChXjQ3rQBurGe38Uhj4e52WCZU0FHmenFv/zcC5OdI=;
        b=jwTYd0Ape6rySoWfd1fHI0Em5aEYQw9tCTUF4AVFVuR8O/d6J2aVcGJGeAfwyg45Az
         D+alhVFzNBRtmRb6eOCKi0Ux+9z5gfaGXFaWIBAIcwykjElb5EQ2zbSOrpjAttadl7eM
         otbpme40/zZo8df22ZAa1naKMAbHSnDM3XIFbksvteHwT1T+n3kXo+eu3xBojUhg33/K
         +cG5FiGeq1TbNMwiQKjUVD5eBgyxoQxl0tQ1j2uG628Ou+WbKRGWQR1rjAVaIFcL5pfZ
         GktMnCK/36xDteISi2hp+UCwQO52FV7z3bclk73mEyrRUk2CxrLQlQQ7qR94a8jJXch4
         EOVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698092773; x=1698697573;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zChXjQ3rQBurGe38Uhj4e52WCZU0FHmenFv/zcC5OdI=;
        b=Ek0VZZ/u6kBEmCGzQ/WEaUuhMpwCG4W/Esx4sftvf02UclxmohwzhLjIPNYReAHUxU
         CXatsy1uPIWcG4rE1iXfnN5hhSeGZLlTE7AbPIluri1JEVS3/RYhQvKBQW0W7+U2+7uG
         20CxawovI45l+jMD/OjKKZvH3I1Hp7gJsr58rnpagejJm9lrlfya8VV7dnNX+9hA6ORq
         k3gAa/8WSMSgDYfdiQaxQzaO6gA4oEH06I8J4hOWgQZin00D1FEymkEZHeaThpumZPPN
         19r83l97Ro8ZF91PmDzFzvezJZbEhzuTwAszwsKTsmfaGTr1TfpDmRxGoQCYa8erqber
         TyXA==
X-Gm-Message-State: AOJu0YwdSaATVGU2LaqIC/X+NC/oHpyaqfLKjn/fSLLL4X+AUx+94deI
        a88ip5ZV8CvmkmySh3KWDPpkrvhjpR+cbyulgg==
X-Google-Smtp-Source: AGHT+IEqsrafJ1DZvc3t+zuOQLWw0wftv/ONfKaFgntqNqbR85CvuDoX26tXKyK297RDA0g61HMRGeJRcQbacAry3g==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6902:1083:b0:d9a:c3b8:4274 with
 SMTP id v3-20020a056902108300b00d9ac3b84274mr268500ybu.7.1698092773711; Mon,
 23 Oct 2023 13:26:13 -0700 (PDT)
Date:   Mon, 23 Oct 2023 20:26:13 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAOTWNmUC/x2NQQqDQAxFryJZN6ApVPQqpRQbo2YzI8kginj3B
 hcP/tu8f4KLqTj01Qkmm7rmFNI8KuBlSLOgjuFANT2bAL1Y4vXA0XQTc3R2xSB7yXaPryYtyNh x9/rR1LZCBNFbTSbd76/357r+EuzluXsAAAA=
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1698092772; l=1745;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=9bXDO1Umav441y/UcVZ3FP7PbPbnlidPGSE+wWdxjYc=; b=0hpqJJX/0z59X4fF/5gjjPvrMId7qhNRePYyCg2rX7J3aRjqSyWQF9CJg1UwrVXM1VQK7V1pl
 H5Qhc4QPiCtDCj1FITDJRFf+qZcap66an0jIs/i/0vGGS0ptpwTvmt1
X-Mailer: b4 0.12.3
Message-ID: <20231023-strncpy-drivers-scsi-csiostor-csio_init-c-v1-1-5ea445b56864@google.com>
Subject: [PATCH] scsi: csiostor: replace deprecated strncpy with strscpy
From:   Justin Stitt <justinstitt@google.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
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

`hw` is kzalloc'd just before this string assignment:
|       hw = kzalloc(sizeof(struct csio_hw), GFP_KERNEL);

... which means any NUL-padding is redundant.

Since  CSIO_DRV_VERSION is a small string literal (smaller than
sizeof(dest)):

... there is functionally no change in this swap from strncpy() to
strscpy(). Nonetheless, let's make the change for robustness' sake -- as
it will ensure that drv_version is _always_ NUL-terminated.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.

Found with: $ rg "strncpy\("
---
 drivers/scsi/csiostor/csio_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 0c32faefad7c..d649b7a2a879 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -521,7 +521,8 @@ static struct csio_hw *csio_hw_alloc(struct pci_dev *pdev)
 		goto err;
 
 	hw->pdev = pdev;
-	strncpy(hw->drv_version, CSIO_DRV_VERSION, 32);
+	strscpy(hw->drv_version, CSIO_DRV_VERSION,
+		sizeof(hw->drv_version));
 
 	/* memory pool/DMA pool allocation */
 	if (csio_resource_alloc(hw))

---
base-commit: 9c5d00cb7b6bbc5a7965d9ab7d223b5402d1f02c
change-id: 20231023-strncpy-drivers-scsi-csiostor-csio_init-c-9c96b2f77e22

Best regards,
--
Justin Stitt <justinstitt@google.com>

