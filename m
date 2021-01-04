Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB799C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86402216C4
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbhADSE2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbhADSE1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:04:27 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503D5C0617A7
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:30 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v1so64228pjr.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8aDJGHx9QEXfSvCoO2quKuCjJPe1pZ786HtRKBaNp+A=;
        b=aOrDPlLSWPLTyFMjZ47YVefmMdfAvOsp7w3XTvxFtHP7H4wskIfTHBsTVoRC4DwWYK
         74c6CY571wc/tHZLEuMsWrCmvxh3ugbgTuNW93agzTXUtSYcSE7MIziS/1Z4j4BpsIqC
         YB1bJk0Xp6IqPypQKp1puPxPnCQFTGqaBTTGyH0WpucJD/cGGkqKI5pBd3shA3Xz+3ET
         H7ELfoQy5hveOSuE2Of8FooDfx3Ujut2H/d29x0VPj0srqoh8tGvB/utqNMUKrHGuyUi
         dE7K0E4xM+RXZysmy4e2bORnOTMoJ+o7iRh7/WKweuHEbsCHupYyc/0X1+cobUDeITnL
         GTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8aDJGHx9QEXfSvCoO2quKuCjJPe1pZ786HtRKBaNp+A=;
        b=jhf8C0N7Px9YqnNzQWxxuQbMTJ3P6zlqOXw7FQCTDaorcVib89ijp9a4mSThKDIrW8
         O+TPJpWMppmE3qHl+7lAtFgNJ9q2SZvlNfRqheVQ2MGfKCRFqS2Hi2jsBZdyzgm6nYU3
         shwZqAJHmKxexjCWvZZExbNNCYO+6So4OtwWZGWJU13EAcUKhBLy2L/nCcpF36dmVq0Z
         g0X5wUwt4oP+cCJoTNScKx17DaqMST+96JwtzNuq41p+NF+V87FnR1UYn0ZVeYNaHy3R
         5ukIyJyRex5MPSHumGHNS74OiutpJmy/ncxs+mU+fciy3gihZMawJ+w1KAba008VMXDU
         Wvvw==
X-Gm-Message-State: AOAM533xoV/KCVz52keIuztMKMNsW1eMMPpegtXQWPhew9ystdSb3pFc
        0w5MmkivS71UwyuZBF76CQBiud8qrlE=
X-Google-Smtp-Source: ABdhPJziQFfSUiVVXbyNsc3MNYWpM1LNdOxl5PKmSuf8jCrpeWVp3CB2V72cngG65Yr9IhQKdhxsXA==
X-Received: by 2002:a17:90a:db4e:: with SMTP id u14mr71353pjx.184.1609783409797;
        Mon, 04 Jan 2021 10:03:29 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:29 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 15/15] lpfc: Update lpfc version to 12.8.0.7
Date:   Mon,  4 Jan 2021 10:02:40 -0800
Message-Id: <20210104180240.46824-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.8.0.7

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 234dca60995b..fade044c8f15 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.6"
+#define LPFC_DRIVER_VERSION "12.8.0.7"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

