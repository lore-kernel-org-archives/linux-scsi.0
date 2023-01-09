Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3D0C5479D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbjAIXWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbjAIXWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:43 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83705FFD
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:40 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id 17so11344398pll.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9d5KbCTYqMB3xYbjOw0/jFF8F80T+AZKpqEy/1t0Ljs=;
        b=oIB1oU9Ok/rluVY6MMuiO4CtZBo5KxRWTRZ7pOxqar/fGaxw4l+TWhQg+Mdi0v1iZJ
         zjY6zCmbvBpgPKo1xu1xTiKiSKE8q723/2mzKi5QWyHt0Lb3XNnltdbel52eFISPEJDi
         pUxQuPa0w2nJrYOP0cJGgGYARQVNB2sS0CH7khZwP9XQwu9y5V+4YUJMNBw56qDvwTRm
         HA/esxGYWCC0Bb6aQFlZb1SElheMn4jm2cTe98vjRJ8rbfhsoGMqQy57iwRk9evxIu4V
         ebe/QNZSlCWZHo+UluXFqVBfO9lCWwagTyKYXSA37TFcrP6Nz8Fg9iSQ2XcSZRfyL3uu
         4Zfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9d5KbCTYqMB3xYbjOw0/jFF8F80T+AZKpqEy/1t0Ljs=;
        b=6arQWvucbIWgXrBWmVBEADY0NA0tM7T+zV+2z0CumBORma027Pe4QYFUIEjomLJdLK
         K9Vngd9skvMVYFU2nwY46xSogWerQLXSm7zILOU1dIH+XqwwIuP2qy0w0Sl59ZbHcZtQ
         BxcCGw9AWgYRpJNwaViNGNtBB15oteNLGN0jEV6pmtO0QvbvsKyi4EjnvsYNg/fut0l0
         uOhCIP4yulZjewImtYmXWb7+a4iEs8u4vnLkx8KgRoZrzyB7r5F5PlGAGgrXvAji9DSe
         8IexkIxD9tzpB0+EJavbD0u80kDFYFdhebqAk9i5KdBF/V5zccOqgINDuY0F+GKh6fo3
         NSbw==
X-Gm-Message-State: AFqh2kr3RRYJ8/Td8UjvkKW/jopvjcSuu+nnBpD6RBwn1Od9uy4IbNaV
        zI/4W2Ab4ziS5Gz9aYLsaKz5FmmjS8k=
X-Google-Smtp-Source: AMrXdXtHk8Z9fD+hGd8vdatgZhpfUBfBzE33ngHCcsFot6McpmIvZC4/4ulXEnqwpDIfvMDx3jYT2w==
X-Received: by 2002:a17:902:edd1:b0:192:50fe:504a with SMTP id q17-20020a170902edd100b0019250fe504amr62192124plk.16.1673306560302;
        Mon, 09 Jan 2023 15:22:40 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:40 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 02/12] lpfc: Replace outdated strncpy with strscpy
Date:   Mon,  9 Jan 2023 15:33:07 -0800
Message-Id: <20230109233317.54737-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The kernel test robot pointed out non-NULL terminated string possibilities
when using strncpy in lpfc_xcvr_data_show routine.  Although we manually
set the NULL character after strncpy, strncpy usage is outdated.

Replace all strncpy usages with the preferred strscpy API.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 9df90c0ab44d..c95401225057 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1905,8 +1905,7 @@ lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
 		goto out_free_rdp;
 	}
 
-	strncpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_NAME], 16);
-	chbuf[16] = 0;
+	strscpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_NAME], 16);
 
 	len = scnprintf(buf, PAGE_SIZE - len, "VendorName:\t%s\n", chbuf);
 	len += scnprintf(buf + len, PAGE_SIZE - len,
@@ -1914,17 +1913,13 @@ lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
 			 (uint8_t)rdp_context->page_a0[SSF_VENDOR_OUI],
 			 (uint8_t)rdp_context->page_a0[SSF_VENDOR_OUI + 1],
 			 (uint8_t)rdp_context->page_a0[SSF_VENDOR_OUI + 2]);
-	strncpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_PN], 16);
-	chbuf[16] = 0;
+	strscpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_PN], 16);
 	len += scnprintf(buf + len, PAGE_SIZE - len, "VendorPN:\t%s\n", chbuf);
-	strncpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_SN], 16);
-	chbuf[16] = 0;
+	strscpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_SN], 16);
 	len += scnprintf(buf + len, PAGE_SIZE - len, "VendorSN:\t%s\n", chbuf);
-	strncpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_REV], 4);
-	chbuf[4] = 0;
+	strscpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_REV], 4);
 	len += scnprintf(buf + len, PAGE_SIZE - len, "VendorRev:\t%s\n", chbuf);
-	strncpy(chbuf, &rdp_context->page_a0[SSF_DATE_CODE], 8);
-	chbuf[8] = 0;
+	strscpy(chbuf, &rdp_context->page_a0[SSF_DATE_CODE], 8);
 	len += scnprintf(buf + len, PAGE_SIZE - len, "DateCode:\t%s\n", chbuf);
 	len += scnprintf(buf + len, PAGE_SIZE - len, "Identifier:\t%xh\n",
 			 (uint8_t)rdp_context->page_a0[SSF_IDENTIFIER]);
-- 
2.38.0

