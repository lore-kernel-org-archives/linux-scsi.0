Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EF9C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA29964D5D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhCQJNr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhCQJNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:11 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C675EC06175F
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:10 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id 61so992215wrm.12
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hdrx4ZDIqWWXCMIUIHjqy5M6xHh5UviAprBwzcqZnso=;
        b=ADMZ9cq3UjXb3mFr70/P7f/svyjPjcoI6pNxsw1Z1In3b/CCiehItfmDGj8ShIivIK
         sqy6mFvwDowypd8BjJdYzyNHlfOODXxH4ib+zKFotJmkyDk1TtlCP9FxCXd1KkVXFkWq
         o3vGEzMNGbkrur5BODNFI8Y7taNO03DnMXv94iTr22aM4s6jshxXVQcaOswE+f7ujBqQ
         CshP9pNxx6hBEOd0Ax9ftbmnyyWwZ7gksmrOrcHBcF4ZJljDletomLYVyIe+I1Dqh6AV
         EUdgHWw/dUTY+Hi7+fz9ehbY4/3g1vElEs4m3fnHjEEl2JDohvhaxoDrje99Tx0eSPZ7
         pRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hdrx4ZDIqWWXCMIUIHjqy5M6xHh5UviAprBwzcqZnso=;
        b=tNCqyh68sfDM4rhqEEWfGigIToGehSlyoEVjtGVpgBM7SNUe9+SiH4QTXqhCuVpHiU
         1GtzQkmHpcEfXUBq4WKhzX4u1l3l2bsstlrtIcCQ+kBEwZmnHfEBQogLpUymysNLPxZy
         4N7c2+mC6FAERTVOFeFzD7pl1ra4jatQKn8PoHvZCBAMuc2apbipCGj7KTgnoyUzaEG/
         XSz6K9rVZVNYc1YGBFRRrzJiDaGnUh1KJnkKXpAAPAHpi72PbcCwDUjN9Lsp/aoLdB8f
         2KepDiWx1K3IEOlnkYitBLwqQNats8Pb6n4MqozOQD/mymHRczWWuhNwzIa3THb3oVy9
         ydKg==
X-Gm-Message-State: AOAM532Cs7ghasADqmmSwnLo0TGoT7ZUdAUFu1epALrk2CGzC3A+Pnwz
        yyocipv6myZm3fWvqzoMIgyWWg==
X-Google-Smtp-Source: ABdhPJyce6n27wI17PtQ5IRp7saOtwmxNB3UD47OIgyBOc+bS91ofdwq9UrHv3TIgOn7PvWLJ8/jDg==
X-Received: by 2002:a5d:5088:: with SMTP id a8mr3404299wrt.294.1615972389604;
        Wed, 17 Mar 2021 02:13:09 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 29/36] scsi: isci: remote_node_context: Demote kernel-doc abuse
Date:   Wed, 17 Mar 2021 09:12:23 +0000
Message-Id: <20210317091230.2912389-30-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/remote_node_context.c:206: warning: Function parameter or member 'rnc' not described in 'sci_remote_node_context_notify_user'
 drivers/scsi/isci/remote_node_context.c:206: warning: expecting prototype for This method just calls the user callback function and then resets the(). Prototype was for sci_remote_node_context_notify_user() instead

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/remote_node_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index 7a576b995afae..77ba0291134e2 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -197,7 +197,7 @@ static void sci_remote_node_context_setup_to_destroy(
 	wake_up(&ihost->eventq);
 }
 
-/**
+/*
  * This method just calls the user callback function and then resets the
  * callback.
  */
-- 
2.27.0

