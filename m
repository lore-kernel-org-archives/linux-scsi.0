Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED043C43458
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C77382072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VLiZTK1Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgGMHst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728942AbgGMHqv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:46:51 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D95C08C5DB
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:51 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 22so12326014wmg.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oudq2oeculi6K4POMA0xfQMiSgZLhEbNGoOFwG0ADmE=;
        b=VLiZTK1YdPounijVnkxQ3ZjJXAksw6WHoLAGOcJ3PPwwLBAgKzsO6C68bpRtW2oM8l
         P23zcEDL2q+LbLvngUYT6ZEFO7pKZl7Sl1hb8WA9PtC+MBlZViu3jYskVRT8pEhii/rA
         tV+xAXEneOWp4sRcXUk2nE9UUDl6b6sYd/KiRLeEDlJ81hehGArRGwNbA4NyHz3zCFqH
         tfE0GL0v7JUnk1UakZgNbPJy2wlhfqHB95cb8DXF1OJn4bVgYFRygsN/fEKxc3w7QUFP
         Xdsjd76DNvdjJGLL0aHhfKkP13hnEqjI/fB9oeAOTc13rdVgfP6fz5eoFK4fU/FTsCoB
         ZjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oudq2oeculi6K4POMA0xfQMiSgZLhEbNGoOFwG0ADmE=;
        b=ruqXx0nQEi8u/w7uPBv1+OnW9tP31zAuqfaV4Q3HcNg1+wFTfFra5mrftLhF+TEM3h
         4IGVS+fGhgRGbUIIWjGYu8x3ODIujBi2axZE0swg3V9Z5CUB+HaXNdRMjtLkbTbUlacM
         XEqR4kr68wFEXmQwnr0BDP0pdGh0usxfJYD4ea/oymIn7OYPYbGEzPQet8aCscO5Dnt9
         R14pON9CyB7RU3mYbeH78BBaZ4F1D0mD73MGWTpZ+Ql1GT9jXxSIu7YNZS/OXpLl5cFx
         VIuQEtqVR8JsiZ1Y04ppYiy6xcKfi+r3dwkeATbwdgK1hF2kyfvHG+qUThYQyS94ga75
         apuA==
X-Gm-Message-State: AOAM533XbgXGFWBT8igL5Pxtlfk2G5jhn/j+VSPB6Rfq9gxATJUSGdZj
        1b8q4VmobxzgEOgvsSHUFNgoeg==
X-Google-Smtp-Source: ABdhPJybRu2H52vwDKAoLc7Wg3gmekkvg4QBs6pwc2WHuHji+ygyeu/Opw5m8U3YkJ1vTDi5KxbB3w==
X-Received: by 2002:a1c:4d11:: with SMTP id o17mr17317622wmh.134.1594626409906;
        Mon, 13 Jul 2020 00:46:49 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:46:49 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 02/29] include: scsi: scsi_transport_fc: Match HBA Attribute Length with HBAAPI V2.0 definitions
Date:   Mon, 13 Jul 2020 08:46:18 +0100
Message-Id: <20200713074645.126138-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to 'include/scsi/scsi_transport_fc.h':

 "Attributes are based on HBAAPI V2.0 definitions"

... so it seems sane to match the 'HBA Attribute Length' to them.

If we don't, the compiler complains that the copied data will be truncated.

Fixes the following W=1 kernel build warning(s):

 In file included from include/linux/bitmap.h:9,
 from include/linux/cpumask.h:12,
 from include/linux/smp.h:13,
 from include/linux/percpu.h:7,
 from include/scsi/libfc.h:13,
 from drivers/scsi/libfc/fc_elsct.c:17:
 In function ‘strncpy’,
 inlined from ‘fc_ct_ms_fill.constprop’ at include/scsi/fc_encode.h:263:3:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output may be truncated copying 64 bytes from a string of length  79 [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~
 In function ‘strncpy’,
 inlined from ‘fc_ct_ms_fill.constprop’ at include/scsi/fc_encode.h:275:3:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output may be truncated copying 64 bytes from a string of length 79 [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/scsi/fc/fc_ms.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
index 800d53dc94705..9e273fed0a85f 100644
--- a/include/scsi/fc/fc_ms.h
+++ b/include/scsi/fc/fc_ms.h
@@ -63,8 +63,8 @@ enum fc_fdmi_hba_attr_type {
  * HBA Attribute Length
  */
 #define FC_FDMI_HBA_ATTR_NODENAME_LEN		8
-#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	64
-#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	64
+#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	80
+#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	80
 #define FC_FDMI_HBA_ATTR_MODEL_LEN		256
 #define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		256
 #define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	256
-- 
2.25.1

