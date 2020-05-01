Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBA7C47256
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9294206B8
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eF2Fcp9i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgEAVng (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 17:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgEAVnf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 17:43:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5340CC061A0E
        for <linux-scsi@vger.kernel.org>; Fri,  1 May 2020 14:43:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y24so1287449wma.4
        for <linux-scsi@vger.kernel.org>; Fri, 01 May 2020 14:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q2WXSY/D24CgevE9oYaDlbnGltcEBFA+lO731ikf4mo=;
        b=eF2Fcp9irLhAz629uyuU+nPSeDZ/7fG8YR3kROToCBvmHb7DImTNYk+boH+rPnrVfm
         I0D8pgmEiqPeqScVQjFwINSc3rV4+C1rrjxPmzsByNBFsgSVwNcZRIMUbiHLz3nHbEE3
         /ElWE/2wC2MZK9NGZGd7NQos8e6znH1n1erU2eOJWmjE0di//AXyWltFx+xXA6bVv462
         3bwHVWJsC49WLtXD0QPkLyeB0j6RZYZFhd4RbxwibfHRsEuTUvSfPbs/kKOnbxL/Bwj1
         dJnsk505KIokpVsq+ZU49cs2fLX84L2IU/OE1X1XlDxA0TPuVW5ZRUE/O9I3ZZuzVaV/
         NLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q2WXSY/D24CgevE9oYaDlbnGltcEBFA+lO731ikf4mo=;
        b=NxXbd7l22C6JjPxFvGjhamnt5BTNBlJsd53u3rJg2DzMPYIRZFiTFCFvH/47Gq7dDE
         5kJGLTmsET3G4NF9Q4kATcHXotEctLkJlTWfShiyyBl8JaD2dqq9NVTU2QghHozsBCYG
         C+BMFqQ1O1IKnc/NhDldxU/pfdkdgTzPyYrwgDPmJmcud1WZi6Oi8unkY/VVp87lc6Tw
         4sG8qjkgjDJrn6X2FAejA+gI5h+GCMQTFtWZlPZdyTNZwH2yXcxdAzz/IeyrrUAxwLSn
         7tVAeWGxyz2PhLrHwQxGTdPZYyvTqB8mBtFo+lIKzRjmjPD0isr3FfAOAHN0b0f/xrAI
         zJXQ==
X-Gm-Message-State: AGi0PuYn01HoNJqBAQTSXC/pE7ZKNrfdh/8qNlYRG/Mwd42gZmn1LaKB
        51KIArJkwlDPQpAis/flXF4O190U
X-Google-Smtp-Source: APiQypLqsENf3amD2FiQmYC9cGhB/P8xvoys4pCV5FVAzn8rWopeDkVLWSLeFLxP9BEa2jYYROTpcg==
X-Received: by 2002:a1c:990d:: with SMTP id b13mr1394844wme.179.1588369413823;
        Fri, 01 May 2020 14:43:33 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t2sm1207734wmt.15.2020.05.01.14.43.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 14:43:33 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 8/9] lpfc: Fix MDS Diagnostic Enablement definition
Date:   Fri,  1 May 2020 14:43:09 -0700
Message-Id: <20200501214310.91713-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200501214310.91713-1-jsmart2021@gmail.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The MDS diagnostic enablement bit for the adapter interface is incorrect
in the driver header.

Correct the bit position for the SET_FEATURE MDS bit.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 10c5d1c3122e..6dfff0376547 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3541,7 +3541,7 @@ struct lpfc_mbx_set_feature {
 #define lpfc_mbx_set_feature_UER_SHIFT  0
 #define lpfc_mbx_set_feature_UER_MASK   0x00000001
 #define lpfc_mbx_set_feature_UER_WORD   word6
-#define lpfc_mbx_set_feature_mds_SHIFT  0
+#define lpfc_mbx_set_feature_mds_SHIFT  2
 #define lpfc_mbx_set_feature_mds_MASK   0x00000001
 #define lpfc_mbx_set_feature_mds_WORD   word6
 #define lpfc_mbx_set_feature_mds_deep_loopbk_SHIFT  1
-- 
2.26.1

