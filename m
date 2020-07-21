Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3978C433F2
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9A16207DD
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lMb4wjDU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgGUQmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730540AbgGUQmR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:17 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121DCC0619DA
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:17 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a14so7002976wra.5
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tk/9PpJj3IjnUUvno6UFEVw3K4ZZzww2rfSi8MPmyJM=;
        b=lMb4wjDU3b7k+Ix4Tajy3V/XNCIzn9AeMx+Gy2I3LOimG2LvLXLlHQoxoiiOPhtNyS
         TOHmywAu/W6iADoMfAn8br/lyzSviID8feUGnhY4XFALqSDOhtHtB8YFjPT4G8c1Ku3n
         PHBy5Q29nVUWwedHJ6MiLvYQLdg7X9wJb88aDcK+nmUFG24pCuwyn4NVv7RWmjyyw6N+
         oN29a0dIqRoHa4/5Z4c4z0YBxcrBnZ7BzQJ09Go/gLCH0ZOHjR6Ei59p3ni/bKufLLQD
         UukQHHpBBmFwNSiOsJvBHtF8P1gy2znSVAmnxROqxE9RhWFJ7KujQHv1Gu4jmQlzwgoU
         LpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tk/9PpJj3IjnUUvno6UFEVw3K4ZZzww2rfSi8MPmyJM=;
        b=SAY4eEXEi7wiEKn6gLnKImAvvg7iBN9Kze7kWwTsSfqogFE3jNuafrWFpZ2+t4vJH2
         2kjUTYDmJzk7oABhOOLTnyokaGutAVPyf9Ro23NR/XjkeOkxw9tSE0GNV6TXtG1patps
         4gX1vV2D5sowTNJAXkjZJqlJsXuEeTCcWqYlVXll94mjT9Sv4LvCtA5w+4KuuTdLfzE2
         TbtTNqSFAMgfriY2f4qUtjvx0fN0x1qwU4do9badcS3MX5Par2Ltcb/dic443RL3PadK
         Oxt25mGfKO2DJQDaKb+0ToH5Ml05WCprcG2ayTT0B9UMpQspZ+lU3fOR3+KlKWeJgm9r
         XtEw==
X-Gm-Message-State: AOAM530RwcfO7Gm8+3qHPIxl1owLQXyfmiIHM57oiu4zxV8n9FmNwWy/
        t7WSsiTPeDnKeZabe6lUm45M3g==
X-Google-Smtp-Source: ABdhPJzi44RFlMJHl69DBzg3wibdw5A1lXzpGtuc3p5Ug1b6hgKcSiU4s5ZQ8KQZaqxkhcJMwbPpAA==
X-Received: by 2002:adf:97c1:: with SMTP id t1mr1258158wrb.294.1595349735760;
        Tue, 21 Jul 2020 09:42:15 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 12/40] scsi: qla4xxx: ql4_init: Remove set but unused variable 'func_number'
Date:   Tue, 21 Jul 2020 17:41:20 +0100
Message-Id: <20200721164148.2617584-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla4xxx/ql4_init.c: In function ‘ql4xxx_set_mac_number’:
 drivers/scsi/qla4xxx/ql4_init.c:17:10: warning: variable ‘func_number’ set but not used [-Wunused-but-set-variable]

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 5963127f7d2ef..82f6e7f3969ec 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -14,7 +14,6 @@
 static void ql4xxx_set_mac_number(struct scsi_qla_host *ha)
 {
 	uint32_t value;
-	uint8_t func_number;
 	unsigned long flags;
 
 	/* Get the function number */
@@ -22,7 +21,6 @@ static void ql4xxx_set_mac_number(struct scsi_qla_host *ha)
 	value = readw(&ha->reg->ctrl_status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	func_number = (uint8_t) ((value >> 4) & 0x30);
 	switch (value & ISP_CONTROL_FN_MASK) {
 	case ISP_CONTROL_FN0_SCSI:
 		ha->mac_index = 1;
-- 
2.25.1

