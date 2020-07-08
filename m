Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA570C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C932B20775
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jqFRszdp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgGHMEo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728977AbgGHMC2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:28 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941E2C08C5DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:28 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g10so3825930wmc.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oudq2oeculi6K4POMA0xfQMiSgZLhEbNGoOFwG0ADmE=;
        b=jqFRszdpAMk/WEosA8vCIRplw1s1iZVrYBQi444fVIoA249wMXPC1qA438UH/pbuQP
         Y10ZiE8f7eoJFYP7Cg3TfSow5vMIIKrfp4BoWdH+JPlXnbdl81a5gGetvj1SYKBgNf4F
         D35LtipJgz5JBrVEq+XnPNNiOHGzFPmjAwzdsQDMSptzo/0L1uaqMjWCMQSk2NEpk//M
         dZDsHlJINjfzhUqIRcSIdEAIWl/KwTxs3zuFSFQIS6xfqMoPsiLbmJS8520VaOUnJdPl
         7iYbyatQKg/SdPNXYUQKn0Efp4F0tDOkI3pFXy8P79jDnb/eHuubmfN6cdgpM2dB5H3d
         FF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oudq2oeculi6K4POMA0xfQMiSgZLhEbNGoOFwG0ADmE=;
        b=b9SrUewiqYe6zEM6NDyHrmGPAlgWqWg/nsjJJrjHQW2jsdyFIy/LMaEYy1J42VSIUO
         Xi5gy5KjDxXjdvJbG2Xt0CXnT9+N6knc0QkXs9+8XSgfLh8Ud26up8x9FX4vJsXuROky
         UIV8BvsiPvSdoaEs2WmZU4v1IGKACb9rc67vbUNGjrSsBnRKg4DIgSSlUrgdZ+r7G4/O
         lvUC2BPBJKBaa23chfNfscn/sh36tOXVbiBFAqFMrChzdXqYP7kkeQOEcF2JLl7m96Hs
         zkHdXpPvUfaZvvg9W7ms8Lg0TWpd3+YTb9vVHlyp4yslUXA424R3Yy9STfAiGE+wj7Rn
         GRTA==
X-Gm-Message-State: AOAM532Xdc9LdEJ7GyqHKA0Y4fDZF/NAJvTJGcFp26d9gm9oi0Blgvz8
        LlePpwfrv1bZyQRgiLNBVcb3Xg==
X-Google-Smtp-Source: ABdhPJzYNIcclovtnQ3AJIvggPGf90KHk3jlI7m3GaG1Us2M/TmmiUx/g/jjRI1O0K985J5D3nwqIQ==
X-Received: by 2002:a1c:2842:: with SMTP id o63mr8902604wmo.169.1594209747310;
        Wed, 08 Jul 2020 05:02:27 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:26 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/30] include: scsi: scsi_transport_fc: Match HBA Attribute Length with HBAAPI V2.0 definitions
Date:   Wed,  8 Jul 2020 13:01:53 +0100
Message-Id: <20200708120221.3386672-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
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

