Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99499C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7989F20720
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uS2We1QX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgGUQmA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730361AbgGUQl7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:41:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90A1C0619DD
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:41:58 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z2so21894580wrp.2
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UfDjUA593MuBMsUoDcOCldx6yOsIutwb3at5+hZcMH8=;
        b=uS2We1QXESiFdsyeFgZJ8qcpnYWSH4GYKE2+1ykiEWTD8Or0KBtvnLEePVpMEiaal3
         hsWv8ESjxXtzD3jLi0bl5YxQkygMBuQlnhuDVzrJtiZKbyLi9V0yX5dU6RW7Vtrm9YgN
         /jaW3SLJboEMgyVRUTGxnQZpOx07ejf01IhtMgz7AtJCQx8lwV0wJsbvMK8GKlHeLp+d
         JPlCih+LhE0ECuHHnMaaRxWA7POlAfaw6xYfA0GZVjb4kHbPORxP3qkUGGZPlQUg28ef
         l5OmbIHcKkHJhaCTytH64rwK406QK17r4SWrhc9aacKGwtnOTZnzU1O2iD03Oi+KrQbR
         mclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UfDjUA593MuBMsUoDcOCldx6yOsIutwb3at5+hZcMH8=;
        b=oYVBOu++jfO/C+PrJJaQxpsbOfJK8EzPeDmul8dZEx9QqjUxJ290+BId3Jc05VUYyA
         JICGShZD3NtcAg3Df+QM4qbL82iv/7HRR2B3LZ2bqNImEVpahAYQyF4ol42pr0ej5xcP
         NVuoCmYbZGOkPhldpQYGY69jEdHwA0nnsxdtBrJNur3zlpnhuu6UJsTnIlNh1hX+CTxC
         KLqepz0B1ld8qnPG+ekIXUgv3qtFfRuLVJX1WnOVMMxJXMPSlQ1UW2ENE5W4IVkeS6Hv
         auFGxsIS++DOYIpmTQb/9rSjOYKqtiUyjB5xX/bN8rwuxRkj6joRMJTVlnuiG7hL0vqm
         CM5A==
X-Gm-Message-State: AOAM53351mt/VLXwPPbUtp/0l4r49LNuNS17xIYgSvkmUzlfd7OJehuI
        wuCjSktXMhUoy9ZEq6tuDMssVQ==
X-Google-Smtp-Source: ABdhPJxlqrf9qoABZosf5QxKiUSbADvH9vyBoXG6UbDTJlUEZFhoTXnVzHyUvgYOxdedUp4pA+/fnQ==
X-Received: by 2002:a5d:4710:: with SMTP id y16mr28343857wrq.189.1595349717570;
        Tue, 21 Jul 2020 09:41:57 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:41:57 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH 04/40] scsi: aacraid: rkt: Add missing description for 'dev'
Date:   Tue, 21 Jul 2020 17:41:12 +0100
Message-Id: <20200721164148.2617584-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

And clean-up a couple of whitespace issues while we're here.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/rkt.c:64: warning: Function parameter or member 'dev' not described in 'aac_rkt_ioremap'

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/rkt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/rkt.c b/drivers/scsi/aacraid/rkt.c
index 5f2cede4d4776..8ebc67e541af0 100644
--- a/drivers/scsi/aacraid/rkt.c
+++ b/drivers/scsi/aacraid/rkt.c
@@ -57,6 +57,7 @@ static int aac_rkt_select_comm(struct aac_dev *dev, int comm)
 
 /**
  *	aac_rkt_ioremap
+ *	@dev: device to ioremap
  *	@size: mapping resize request
  *
  */
@@ -77,8 +78,8 @@ static int aac_rkt_ioremap(struct aac_dev * dev, u32 size)
  *	aac_rkt_init	-	initialize an i960 based AAC card
  *	@dev: device to configure
  *
- *	Allocate and set up resources for the i960 based AAC variants. The 
- *	device_interface in the commregion will be allocated and linked 
+ *	Allocate and set up resources for the i960 based AAC variants. The
+ *	device_interface in the commregion will be allocated and linked
  *	to the comm region.
  */
 
-- 
2.25.1

