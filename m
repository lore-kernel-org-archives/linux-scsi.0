Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39836C433EB
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42EAE22BED
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XayB9/rh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgHCVCy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 17:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729166AbgHCVCy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 17:02:54 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B46CC06174A
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 14:02:54 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 9so781361wmj.5
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2020 14:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AzOMuMEQzffdKvTiKaCUMO5vzzF1Jnr8wtCb02HgiE4=;
        b=XayB9/rharHrQfpjBZb+bHIjx9IzQUgngEnG16Frtt+3HcT8XWeTaYYcXLUCHOe6hA
         510ZjngXUbLT9tybBNxdqXiY8//ElWHcEk5tCrDIgrzq/UWQMAZn0UA0lRUG8W46kZON
         /dvIIyOjY9jOeKOyYew11z9zZtF1aMFP0AeCjoJOssM5SqnK1RFukgkMn5p5T8Iu2rvY
         MbUvCL6FOdeLcMF9jAB702q0sDtoV8m7IzKnpbMr2b7iNjyRDIaBbIvg6wZFQTuFOW9o
         pr22GbVp/gjo5x36CIk2zfBD9hphV+wjK1eSJCOd9h8M+kHCkyuUKB9A48RO+489/vfJ
         Aj/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AzOMuMEQzffdKvTiKaCUMO5vzzF1Jnr8wtCb02HgiE4=;
        b=o+61m7g4oi1+6wh/ro2NXSNh+igsPw4ahJlkNBGTKuwy5XjY6fiaHiiicQ9WytCSmj
         09S064K0LFz2sYm7DYQcQgX3tt3tb9Bf8Ry5iopYgHPwJIdt35pDoTZTi2zQ8JRlMFOp
         SLfGH06nXJynaYmcRQZAROjJZ/6RDt5u9SpfP/4Rz7sPS9lqKn3muc2dtTKUu7GGpBho
         6nIIi2KzSsEQ0MmvFWaKeN1zNYYjpEniUAa3yrdpgsfXiBTBTyhpXwCtEtmFBK8d2dla
         Nzbgs+W92z0XoTU/JKNwSN89i8G2aq3qBVuqWWZeMVpHbxZ83n+IUmFCtwXLYIpGk5x/
         jpmQ==
X-Gm-Message-State: AOAM530xc0VUlnfKxDvFairoDwgycrKcF8ynS91gg0qsIa7qmud/oEy3
        ifLKm+k5gm7BRfDh0rZV2PVS92a9
X-Google-Smtp-Source: ABdhPJxDXQ2zi8WewnBT97BRbhEdAmVoahnGeFdX/Vf6K9m7R9RZNyWEeaVeyCoX7rzLevFYHV6ZDA==
X-Received: by 2002:a1c:48f:: with SMTP id 137mr856174wme.171.1596488572387;
        Mon, 03 Aug 2020 14:02:52 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm26649040wrm.23.2020.08.03.14.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:02:51 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 8/8] lpfc: Update lpfc version to 12.8.0.3
Date:   Mon,  3 Aug 2020 14:02:29 -0700
Message-Id: <20200803210229.23063-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803210229.23063-1-jsmart2021@gmail.com>
References: <20200803210229.23063-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.8.0.3

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 1987c6666279..20adec4387f0 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.2"
+#define LPFC_DRIVER_VERSION "12.8.0.3"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

