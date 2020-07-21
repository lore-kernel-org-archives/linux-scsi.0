Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C57EC433EB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C5B120792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xcJAwrBD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbgGUQnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730337AbgGUQmv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:51 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EB5C061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:51 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a6so2571316wmm.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M8+UZcZUhhqKut3OyHo3JRwoJJfbHjVLAS5HKcU2P9s=;
        b=xcJAwrBDxOijmIb5EWqqi6IUCT4N+icn8sSqNnP3ujDCW5mK9cErrAc2G8SM/7IYW4
         ckNWal2RvX0ja7Cwdrn2jTHwa2LkIBD1A0O2P+T5I24IESjMU9nGu+OouAWRxQttHnzW
         ChuSUKA+LSjtQX2syAa7JolKfDYgBpMuxgwxls+jWgmRkisFK2AERpQW0ihJgXiTpBke
         YJK5M0BlQ1JNr34Z+84eH20QI50AJNumEW1dobktKjBcu3piM+O1iujXS6U3skDfZ8ae
         JwvA2RaW7oXomWA8vvtj6Hjduz85yiaUeQ0VL5PKqQmEnDgM4wmBYAGyig7+syxc6PCH
         alQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M8+UZcZUhhqKut3OyHo3JRwoJJfbHjVLAS5HKcU2P9s=;
        b=rPqi67ge3rEYW0ZhMc49vApBhzYxshkIJSptuTETUUBzhv3WQbgeMPZtT5ocK9rLZU
         w9CafNhKLUWMCUtS91Z2PzbUeAZjP73rwYQFvRvW+0e7+DKQU+jO9JQcO602dDP9xnqa
         Djojb5X74e4qEMMI9KZu6y2Nkz4fV6G0F7Yo/PBo/lAcg47Z2LtOk68/FHLau/AtC/Z+
         k+hzxfZPGDUz+QzfIWS9WX8mbcO3/B3ISQ2gbMOmwHT/ZuSvL9KTqMn3nS8l9bBuq28q
         8uOqSnwqbX+2e9atGXRbDM5ENRpIestWjZwOsI1bzlTDVWBsgE19jTdTFPKz79bWN/OJ
         Abag==
X-Gm-Message-State: AOAM532DJcpcaeVzMXnM43tWW/+ppLLvR7JUOtW7LpEdEn1eUqzf/h1v
        vzHzdaIIeAq2nKTB6r/IzMbepg==
X-Google-Smtp-Source: ABdhPJzy9a7uiGxpHfmugGiWdgGNCKhUePyos+MbIiiP+QN4lYYyhGE1HMxFeo9WZdVFY3Puz80BFg==
X-Received: by 2002:a1c:750a:: with SMTP id o10mr5025410wmc.165.1595349769186;
        Tue, 21 Jul 2020 09:42:49 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:48 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Matthew Wilcox <willy@infradead.org>,
        Gerard Roudier <groudier@free.fr>,
        Wolfgang Stanglmeier <wolf@cologne.de>,
        Stefan Esser <se@mi.Uni-Koeln.de>,
        Richard Waltham <dormouse@farsrobt.demon.co.uk>
Subject: [PATCH 37/40] scsi: sym53c8xx_2: sym_glue: Add missing description for 'pdev'
Date:   Tue, 21 Jul 2020 17:41:45 +0100
Message-Id: <20200721164148.2617584-38-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/sym53c8xx_2/sym_glue.c:1784: warning: Function parameter or member 'pdev' not described in 'sym2_reset_workarounds'

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Gerard Roudier <groudier@free.fr>
Cc: Wolfgang Stanglmeier <wolf@cologne.de>
Cc: Stefan Esser <se@mi.Uni-Koeln.de>
Cc: Richard Waltham <dormouse@farsrobt.demon.co.uk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index f455243bdb9be..28edb6e53ea2a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1774,6 +1774,7 @@ static pci_ers_result_t sym2_io_slot_dump(struct pci_dev *pdev)
 
 /**
  * sym2_reset_workarounds - hardware-specific work-arounds
+ * @pdev: pointer to PCI device
  *
  * This routine is similar to sym_set_workarounds(), except
  * that, at this point, we already know that the device was
-- 
2.25.1

