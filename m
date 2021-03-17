Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6460DC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F29464F51
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhCQJNv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbhCQJNR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:17 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CA3C061763
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:05 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j18so1009567wra.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RSRsbfCO9Cf0f9DEirpibbVNzbe0r6NW41Oc9P5QERM=;
        b=B9UmQZCXrChcjGnSseaXL/8B1GG67+Q9AM8YIEqdFozJfacR5/RTobK2kKvkfGFHod
         hfIAA2wTHuRrDgtV/M5J9qW57zinJv8rJ3qs7UlyQNU9EPUfJgZY706MFchEu4S4mDiB
         AvMsONfEBC1dwpcsbWdZL+Y/glgFSdSzHC8Ay+WhytKLT36gsLEt06VpIG95alhwFOxG
         wqfwT63wqdxEyBbUbKke2z3El2mju344wkGs7d+2NHAHmTdYnx/WWVwvkgwT7PDUzJN6
         J3sp/miM772E5mQiLUEmn88fqpiCIyOC98oya+mrC6gKd2sIqf4Dgt82bbWHDTlarFGY
         sIpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RSRsbfCO9Cf0f9DEirpibbVNzbe0r6NW41Oc9P5QERM=;
        b=DqwqugVegR7koW5QFoBKxMgZncnZOImOFvAXfsKWps/H79W9b13x64DsbAOH7qbR77
         ZHwVo2TIIGNVkrvkNas0dozlgbmW6I3viYzpgARb1OBsm2Kw+bO7SAGavXS0/Ar1wkrT
         OcQPle8mxnphtdAscm1DizPvaQiqhf5N85V2O1eNsp/owEyvZycav5YKJ9Nh5vmomCS1
         V15p9NHhuZ7ElMexmXCTsoUBXr/IsBWSDCJVr8iaqJ8sHcSTmtUuEUADjwAMje9Or0H2
         ZoYHGxOJhqxDOtOHoCtLS9p86wd6TgyP2nQ1hDcOH9Fn0fL9MSGGsUFXBHx4xE1eQE+b
         treg==
X-Gm-Message-State: AOAM530/SEWSVBAUnkQ+3LtcwQwXiCX7A+3wYz2mkFCaMB5fHTrHOpvH
        I/pz0TC3gaGXbijsJ29muIkh/Q==
X-Google-Smtp-Source: ABdhPJyAzRAEjgAWlS6E/N61aqnjttkXfW4nRJvzlvYXLd46Jpd2OfToSgukokzDQVrtLTkBlfBf5w==
X-Received: by 2002:a5d:684d:: with SMTP id o13mr3435876wrw.235.1615972384631;
        Wed, 17 Mar 2021 02:13:04 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 24/36] scsi: isci: remote_node_context: Fix one function header and demote a couple more
Date:   Wed, 17 Mar 2021 09:12:18 +0000
Message-Id: <20210317091230.2912389-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/remote_node_context.c:77: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_context.c:167: warning: Cannot understand  *
 drivers/scsi/isci/remote_node_context.c:206: warning: Cannot understand  *

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/remote_node_context.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index 68333f523b351..7a576b995afae 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -74,7 +74,7 @@ const char *rnc_state_name(enum scis_sds_remote_node_context_states state)
 #undef C
 
 /**
- *
+ * sci_remote_node_context_is_ready()
  * @sci_rnc: The state of the remote node context object to check.
  *
  * This method will return true if the remote node context is in a READY state
@@ -163,12 +163,7 @@ static void sci_remote_node_context_construct_buffer(struct sci_remote_node_cont
 	rnc->ssp.oaf_source_zone_group = 0;
 	rnc->ssp.oaf_more_compatibility_features = 0;
 }
-/**
- *
- * @sci_rnc:
- * @callback:
- * @callback_parameter:
- *
+/*
  * This method will setup the remote node context object so it will transition
  * to its ready state.  If the remote node context is already setup to
  * transition to its final state then this function does nothing. none
@@ -203,8 +198,6 @@ static void sci_remote_node_context_setup_to_destroy(
 }
 
 /**
- *
- *
  * This method just calls the user callback function and then resets the
  * callback.
  */
-- 
2.27.0

