Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C40DC7EE26
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 18:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbjEWSWn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 14:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236660AbjEWSWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 14:22:34 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9299EE5
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:33 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ae65e44536so6262375ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684866153; x=1687458153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIDFmi2a2NujVCZcHyQ+iux/mZ6eRjQJ2YrqzAx7F1o=;
        b=Wo4NCRXNAPZKS25sF4XdgRswgFcO7NU2q4YqJnQUneVbfJRmMq0LxJG7Ra1ajo2GbL
         kRsq/RGvv0W0id/6P8YrLQQgcflaNa6wGx94hsHAFHPhZ3I1fkaCI1w1A2IYgl08xWAy
         YDKVZOISJ/HmfsFvrlXUsyKTed9i/wh19YQ5YhFy/6WgVKh+7r8q+KFBYxYf4WsDbmyk
         ClsNUQGTc/lECoLSiW0xQu5Ncr8sYyU/25aTEtKi7CpzFrioCGt676bI8NiuBAnP40NC
         AQDKvVT5ospDlXbQ/r1Npk9z65iQLpDh2x8qhPOEZG3j8UE3ZTc2cuc6YbgShhrOQLdF
         nGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684866153; x=1687458153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SIDFmi2a2NujVCZcHyQ+iux/mZ6eRjQJ2YrqzAx7F1o=;
        b=Lo/6Z+ndZgyFoArcgQ+6nWVmyeeDeqWlxRvus51YxiSFcY/mnDVSFPUc+1nCKaeuwd
         9vKEBosLvzyyxrQH/kse+gc5aqG90P3JQpFrXSOR/Ypn+IMP6QWH82spI/J5j1OIufgK
         1fTve79eFWYteV19Q0hsWyfAb5HJibrifGyuf1X47uAOTxcFI3k/3piX23LGfZNBaLlQ
         nCFpcezD0Q4cSjwycMLRoYd7BMz6+P8cxS2JdzuTV64rFpTg4xGyEjF2WFrZcSXpPxDU
         DyuxWmIcw98n0mFW7XxdNaJyrLM6+ekQr3hvrxS+OT3EaUwG4Ok5K59UE19F5BZVjlfZ
         CjRQ==
X-Gm-Message-State: AC+VfDwpSGP5OE5CxslYjxEc//4hkyuHCmNTxScCWB8saPIhZVpEC9Wj
        JJS1rHzq7nwkFAnmwKnfzZVY09RGsAU=
X-Google-Smtp-Source: ACHHUZ5jvklZCWrmphwBy60CBjhxW/2y6e8g5ykTP9E4NCxtUtUs8+tswo34oXIE86Tz8JcQTi5YbQ==
X-Received: by 2002:a17:903:2341:b0:1ac:3ebc:af0c with SMTP id c1-20020a170903234100b001ac3ebcaf0cmr15959683plh.1.1684866152824;
        Tue, 23 May 2023 11:22:32 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001a687c505e9sm7070870plg.237.2023.05.23.11.22.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 11:22:32 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 8/9] lpfc: Update lpfc version to 14.2.0.13
Date:   Tue, 23 May 2023 11:32:05 -0700
Message-Id: <20230523183206.7728-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.13

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 5fda8ac6b883..6f35491aed0f 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.12"
+#define LPFC_DRIVER_VERSION "14.2.0.13"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

