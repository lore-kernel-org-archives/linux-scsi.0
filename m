Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B2CC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 908C764EE3
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355707AbhCDAdA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244719AbhCCO6a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:58:30 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FA1C0613DE
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:46:42 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id u16so5966950wrt.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WNQAPxGMnqLL7g3LltPLuvKvyAOeTz8LyxGMxNVsyHE=;
        b=sVSVp9AxBtfr9XnMsMLHY+Za2AdiIrWKn4fsk+8hYwtrvDV7QnyEYYyptJ4Kbctavg
         2Mr1ByDFM+WvEJr2kRUwFcR5jblcTFpP3XzGbNKLX8R6J0QAmgVJEPr9qSxdV8r8Sja4
         Rjggve1rDqlK8Bj9wf+F7imYLbeOMy8RnVijKXgyP5LACWRkPa35nfeARfMcIwleM1XY
         BUHCKHOrzAl5Qvzz2Yca8DjZa1EQTJCWVeZF3KBvmvMKkuVkVDzyucKx/dEMNzpGHsno
         goFv0W4F+yAE2kxqNHDYMaABbhaf71ehoTFQOBCH+Ly3U1Lq4xmQIOmdcT/8MvJldPdx
         /Tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WNQAPxGMnqLL7g3LltPLuvKvyAOeTz8LyxGMxNVsyHE=;
        b=Mo1NdsQc4KXweYk/8FxPXoBaIE+g/lOL+3LBLvS/rwD19dJ+5c9K2IGIaa/454hRnu
         O/p5pf75Lxn5KCEzRa/SLV4S5+J9dtT08ucb2zZmFtINzQ1zIVMT1vfJHu/hJJeUea0J
         4Q/0ijYfhVyEEHn4e5wplG9AwdEXPCmcQmxpFtsYCP2d1Keum4YHeR5o8PFWFckypK1Q
         0QpWs5FTH1nBAEcgSbzA4DtAIBZ5XDjMsKrm9ofjANNh5WlqmRcdvZAaHg66tHgjQmtW
         pzAnacj5esyf3iGcGqa/lr2AfebpxxRH49VOFSoH6FD9VkUWHsBl1lhjI/XXO4RwTA5N
         TK4A==
X-Gm-Message-State: AOAM530U1zLOXMI13KV7TyYlaS46BMurwHHNU9p3EatZKdf3DLVNhGJ9
        S1X3D2yt3+t7hL+WcfCqQFPENw==
X-Google-Smtp-Source: ABdhPJwz7Cbb5q6oZiB21g3fYOlbJ9E2LU3Ob3H595o8I3XgXxqkikxXdx4eIh6JmOjiR51ogLMcIA==
X-Received: by 2002:adf:c101:: with SMTP id r1mr27898465wre.38.1614782801291;
        Wed, 03 Mar 2021 06:46:41 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:46:40 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 03/30] scsi: fcoe: Fix function name fcoe_set_vport_symbolic_name() in description
Date:   Wed,  3 Mar 2021 14:46:04 +0000
Message-Id: <20210303144631.3175331-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/fcoe/fcoe.c:2782: warning: expecting prototype for fcoe_vport_set_symbolic_name(). Prototype was for fcoe_set_vport_symbolic_name() instead

Cc: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/fcoe/fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 03bf49adaafe6..89ec735929c3e 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2771,7 +2771,7 @@ static int fcoe_vport_disable(struct fc_vport *vport, bool disable)
 }
 
 /**
- * fcoe_vport_set_symbolic_name() - append vport string to symbolic name
+ * fcoe_set_vport_symbolic_name() - append vport string to symbolic name
  * @vport: fc_vport with a new symbolic name string
  *
  * After generating a new symbolic name string, a new RSPN_ID request is
-- 
2.27.0

