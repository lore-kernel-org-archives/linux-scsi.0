Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E90B7C001DC
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbjGLRyX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbjGLRxz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:55 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36F412F
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:50 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-51f64817809so636320a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184430; x=1689789230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGW4L1yM4j5Oc0g3u6zCqTTAZJUXAUAdzTVERIwlx+s=;
        b=bDpMNpVTbEEugq74+oku7HjS3/XKcLX4AmOANcAsRUCkvdFGg+cjphri5d6i9RSxvU
         XO9C0WshzKkeU51kqnKHi4JNDXX8SYJnCA0wLaK5nTMXYneYintn5FrGxEzFXf/AOwrq
         /nNu5WVROhXpI78uAm7N4udVG5QeLoi48zCee5K3SjUW/r6k/C78ZGqKPj08o87qyP6G
         yiRidPSzldaHhq4qXRvBv7BV9wyLL7LOR3MjVp8T5o+gRRPDzJmbZwo2cYycY6k/Gw4e
         S9Grgxa2uozWWoIQnWaKbcBT6g90L3OkamvTDRSDwPc8YGXeRzvUXCFzt2diUioS3SpI
         QSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184430; x=1689789230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TGW4L1yM4j5Oc0g3u6zCqTTAZJUXAUAdzTVERIwlx+s=;
        b=LZ6iAjYP0WVIOz875sTBn/JLwKwAnLtXDKQ37wfm8ELt9AJbcbmAEIkuaXDYB6l20J
         mBMVmR/qDXFCdfdJovXLZfU+n5VogGOYZKZuXFSEh53aZY6XOldnnBZgDTVcmNuG9AH7
         U9pU1LT/FDpitLtrGitrFxTW0aJzvfABbXprfsTSxvfPfF0J5O+e/U3JT3Viu66itK5Y
         3ZAIpBX+YRZk8iNwTGLM/jmn8odEFL25esklBKH24hEwgM0L5zDlKQ/kXo/mGNRYUerb
         jl55xusj/uKUR3uqzyFrFZPS1ZL05earR2sKh8PUnKBYjuNXg+dNrAkh/OQ54xNG/TvR
         X+uw==
X-Gm-Message-State: ABy/qLYyrXaRqGA7NXoIvT0Lat9iTKYRZFvmAHHJHrceo16OY45bJkt9
        DtLTZrGsPx0Cum40K+Gqm+F0zTsYQ4A=
X-Google-Smtp-Source: APBJJlGAt0WqUKFYpS51UZlrzN12kyhJUxjgbq/QofhjAZb91xYw2btERTahebAATj9SWp2g4pC7QQ==
X-Received: by 2002:a17:903:32c4:b0:1b8:a469:53d8 with SMTP id i4-20020a17090332c400b001b8a46953d8mr163119plr.0.1689184429974;
        Wed, 12 Jul 2023 10:53:49 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:49 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 11/12] lpfc: Update lpfc version to 14.2.0.14
Date:   Wed, 12 Jul 2023 11:05:21 -0700
Message-Id: <20230712180522.112722-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.14

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 6f35491aed0f..13a547277f97 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.13"
+#define LPFC_DRIVER_VERSION "14.2.0.14"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

