Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1823C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 744A8207F9
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gwDnoQdj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgGIRrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728594AbgGIRqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:17 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0127C08C5CE
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:15 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q15so2842914wmj.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s1f2VykJlM3ygLpY+EskgDzDL15LmxoT0Iv4BzUdNoA=;
        b=gwDnoQdji4kOk1Gx453RYcXY4/p19T4HB3UAOQ9r3rQaWnjsvW0jmbOlA03+LBxTq3
         cccf4WtZJ+jFJIgvLBlc0fl05f4XkCMrn/PZjoP0/eB1sReRdbWyhr4PgQUteMSCJQT5
         74G/xtJ+G9WQRmREe9OMsS26QhO7p+oQAjCufWAQe2QSW7gt0smOYdfq5SSD1K3GO1Au
         neGuSaytWS5kVXNk/LVX6oVer891CsdBxti/TKD52US2OTHUnggCtcKhtOL7mXQkfZDx
         YRQeURxxT3p/+ET+tmL3fpIPL5mLt9Io2nWOgCYOGe88FmGV+/WRJRN4Cv9Gac3dwdn3
         iDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1f2VykJlM3ygLpY+EskgDzDL15LmxoT0Iv4BzUdNoA=;
        b=OY+z9F6jXFouefQFoMDy6GqX/jpnIFyKJnDby0kAyg4LTVoVwJb+79n8QEf4tCO6Nb
         Aik/lg7IHAzm/HVY0zcQ26w75kOKtRrVwrMwCdMBBEgJOuXLp6NCQtKc5y64r1Ce908O
         A1lzBG+1IB0obgQLdfQx1SAvxlGGpfUuhTu2IyaBItkI69a0uCm49JbxYb2itvJTjp8l
         DmlWghj7EBukOCww5LJV0q6vgwmoHPuMrVmxnv9B8O7kK7Z6QhayLypRMzAMaTYdZ5g3
         M+Izndk1ljXVXS/5/DLif7k3U0ForQg8TBEwjARXm5/wxxbUE57lLivqtLUFvsuQH0oQ
         J4aA==
X-Gm-Message-State: AOAM532/Gay2DkktFBAOFoPJpRpX6q49mxBOWA8HxUcmaKikC2LOuZ9r
        7Dbt0eN3b5bOZdPwBvRYN4hEvA==
X-Google-Smtp-Source: ABdhPJwf4c/2TEywxCAoRcyEuiZ+zUUNFRwDIPxtAycnXBX8sXxvWxYjmix9q7TewIpa8VaU6NEHMA==
X-Received: by 2002:a05:600c:258:: with SMTP id 24mr1143837wmj.70.1594316774530;
        Thu, 09 Jul 2020 10:46:14 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Brian King <brking@us.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 14/24] scsi: ipr: Fix struct packed-not-aligned issues
Date:   Thu,  9 Jul 2020 18:45:46 +0100
Message-Id: <20200709174556.7651-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/ipr.h:1687:1: warning: alignment 1 of ‘struct ipr_dump_location_entry’ is less than 4 [-Wpacked-not-aligned]
 1687 | }__attribute__((packed));
 | ^
 drivers/scsi/ipr.h:1711:1: warning: alignment 1 of ‘struct ipr_driver_dump’ is less than 4 [-Wpacked-not-aligned]
 1711 | }__attribute__((packed));
 | ^

Cc: Brian King <brking@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ipr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 9a0d3d7293206..783ee03ad9ea2 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1684,7 +1684,7 @@ struct ipr_dump_entry_header {
 struct ipr_dump_location_entry {
 	struct ipr_dump_entry_header hdr;
 	u8 location[20];
-}__attribute__((packed));
+}__attribute__((packed, aligned (4)));
 
 struct ipr_dump_trace_entry {
 	struct ipr_dump_entry_header hdr;
@@ -1708,7 +1708,7 @@ struct ipr_driver_dump {
 	struct ipr_dump_location_entry location_entry;
 	struct ipr_dump_ioa_type_entry ioa_type_entry;
 	struct ipr_dump_trace_entry trace_entry;
-}__attribute__((packed));
+}__attribute__((packed, aligned (4)));
 
 struct ipr_ioa_dump {
 	struct ipr_dump_entry_header hdr;
-- 
2.25.1

