Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0112CC433E5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D339A208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BB8oAg6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgGWM12 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbgGWMZB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:01 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CFCC0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:00 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id 88so4977414wrh.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OWikrHcjIEL13jknWWaUiCgmVBPYjsVQNgOhFstQ6kk=;
        b=BB8oAg6wAh/txP2Zw6XlLsdMIMjiFCw3n8QNnz+5qnf/iAGYJvKlY8VFgS75Q/OPnW
         0lhnnWlp8LgvU4zRh+u6mSS8gdNbN/fCyK6UC8LFWS7mC8bAJQ90U4rhEUTHLZr37zWY
         0LQ7Es10351jkZU5W0m83pqKwZU8zj6e56ek1R76wpC9wa8HJAvrtfwDKeVOnnpTxNXz
         HOVQ8iAivYVb0FCcO0xMuA1T1bWbgrn4SuB2fqgWspRAVWfknGcxyy8wcH8zCM4XzHbk
         jxQfWwJXpOcAnH04XdrVg2G7KnMLip7J+DCE7A6Mutm9VOZ6qWqcdEd9957uDxpVIqGn
         AtAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OWikrHcjIEL13jknWWaUiCgmVBPYjsVQNgOhFstQ6kk=;
        b=f72zkOSCwCGn6NuGBc7dr6nMO7DF1fyOjwqsNN/P8E4lR/T3EsmHEtwR9uTt+AIt9T
         9250leGG3SzZyvwLcpab4I0h5xjs6SaJXdxNYmcJMpQD4x9RYO3yFs/1xhpQzAG3B0Ts
         XkhQHs86fjVk07KrHqmo8UITrkJgXm0HPWJc8dZWP5q5A86xYXOnBhaTWzV/PaH1DDAR
         GV8a6+dPfKvIxSjCgT/4vAZ2GaOlTefdKLETTnTSp+owQg2pNx/ODva35ndmhjv/VFII
         /u9bInYzGUaSZ6wub+yTlgpdB6DyfdCPMam1S7jJCN5PjtnCIfX+1oJCFIhdn/l8O8ax
         NOMg==
X-Gm-Message-State: AOAM532A57CzTGWzYHHYyLa12S643CO8X2bfkDQkk28mQMqwZWcuw3ED
        XEQ/8J3FqlSU/MwS378dZq+tgg==
X-Google-Smtp-Source: ABdhPJxhEY7+qPHjPhuX5V9UXTKocEiF3ZgSgjLNy48r0c8fWe4GAkvPRAdVDSpqXvIYiB7pHa/2iw==
X-Received: by 2002:adf:b34a:: with SMTP id k10mr3801954wrd.402.1595507099540;
        Thu, 23 Jul 2020 05:24:59 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:24:58 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Anil Veerabhadrappa <anilgv@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>
Subject: [PATCH 08/40] scsi: bnx2i: bnx2i_sysfs: Add missing descriptions for 'attr' parameter
Date:   Thu, 23 Jul 2020 13:24:14 +0100
Message-Id: <20200723122446.1329773-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bnx2i/bnx2i_sysfs.c:40: warning: Function parameter or member 'attr' not described in 'bnx2i_show_sq_info'
 drivers/scsi/bnx2i/bnx2i_sysfs.c:60: warning: Function parameter or member 'attr' not described in 'bnx2i_set_sq_info'
 drivers/scsi/bnx2i/bnx2i_sysfs.c:96: warning: Function parameter or member 'attr' not described in 'bnx2i_show_ccell_info'
 drivers/scsi/bnx2i/bnx2i_sysfs.c:114: warning: Function parameter or member 'attr' not described in 'bnx2i_set_ccell_info'

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bnx2i/bnx2i_sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index 6d56fd60cb2b2..3dc790089f0fc 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -30,6 +30,7 @@ static inline struct bnx2i_hba *bnx2i_dev_to_hba(struct device *dev)
 /**
  * bnx2i_show_sq_info - return(s currently configured send queue (SQ) size
  * @dev:	device pointer
+ * @attr:	device attribute (unused)
  * @buf:	buffer to return current SQ size parameter
  *
  * Returns current SQ size parameter, this paramater determines the number
@@ -47,6 +48,7 @@ static ssize_t bnx2i_show_sq_info(struct device *dev,
 /**
  * bnx2i_set_sq_info - update send queue (SQ) size parameter
  * @dev:	device pointer
+ * @attr:	device attribute (unused)
  * @buf:	buffer to return current SQ size parameter
  * @count:	parameter buffer size
  *
@@ -87,6 +89,7 @@ static ssize_t bnx2i_set_sq_info(struct device *dev,
 /**
  * bnx2i_show_ccell_info - returns command cell (HQ) size
  * @dev:	device pointer
+ * @attr:	device attribute (unused)
  * @buf:	buffer to return current SQ size parameter
  *
  * returns per-connection TCP history queue size parameter
@@ -103,6 +106,7 @@ static ssize_t bnx2i_show_ccell_info(struct device *dev,
 /**
  * bnx2i_get_link_state - set command cell (HQ) size
  * @dev:	device pointer
+ * @attr:	device attribute (unused)
  * @buf:	buffer to return current SQ size parameter
  * @count:	parameter buffer size
  *
-- 
2.25.1

