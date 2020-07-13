Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2828CC43459
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07BC72072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qt186vtK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgGMIBL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729299AbgGMIAY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:24 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A4EC061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:24 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r12so14702183wrj.13
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s1f2VykJlM3ygLpY+EskgDzDL15LmxoT0Iv4BzUdNoA=;
        b=qt186vtKt/PK9OFVozF2ZRakTSgUeJRV1rrbbqIKCx7/qsazwzFJ+7UmD1xgA05o3z
         KOIGkNlEK6gM72mGnM8EMNzSKe5sNFw/q+a4vwVXV1vgV3v2qpKkgLosG42A5Bz/cURJ
         n/TVPhX3q/sgAGqeyi+cUZcinU7LHM57nf8ED48+sziFHwCaPxn8y23NfGnk5FoLkcdP
         vE9V9B5h3JcgZSk5p1mtloek9yXl7FDeDPWQHmaFlMsphXUqByWh4fXfs/W1yZT8iDcI
         AYoPpHCJ2pAFp/vTiK5O1N3FCTLTP8DywpDNAn1wy8PLNgkNno80PYS+ZaxIqW2ndN4k
         R4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1f2VykJlM3ygLpY+EskgDzDL15LmxoT0Iv4BzUdNoA=;
        b=r7ogOAgTmIHg0a+gOscehj5TRq+fW/yn0FNBbyBSdJQDxWi06q3VHXaJwG90jksDtI
         C5q9YUYjdoTJ2baNve9TdTWXMhyAZfnPit+sNLXCnwFOgo3Thz4GdB6M1hittigWSMZH
         0RgP5oav8/GM3lxDFCtSmyf6bOJvYILyBDvQItBMDyoHH7yZ1ERjA3q+I7HbwuOvZlD3
         OPc72fNl8cS0I9zE8cneJVVEc8bkLmjYUJQaqsz9pFEHaDIHbL2CkdnETP4n9jYzci60
         2C8ELq6Lurs4T2NXclzOO4QgquydLv9sCcplN3fzaJh27KkdsnFuEnaI2fu3izLnse2u
         K/tA==
X-Gm-Message-State: AOAM533Pn5PcWcAYd86OvS1P1d+Org0I3PIIXWQsWdJviCgkDdWjDSnX
        +I2tIeV5B5FBGpMnDHqQa1L2NA==
X-Google-Smtp-Source: ABdhPJxH84D/9opvqFIODJ7EdCyqyBHoMySBXyJRPSJ95zQfXyDTcQoDqv0ufs9OhvaubRyrArzOog==
X-Received: by 2002:adf:80c7:: with SMTP id 65mr50742755wrl.246.1594627223033;
        Mon, 13 Jul 2020 01:00:23 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:22 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Brian King <brking@us.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v2 14/24] scsi: ipr: Fix struct packed-not-aligned issues
Date:   Mon, 13 Jul 2020 08:59:51 +0100
Message-Id: <20200713080001.128044-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/ipr.h:1687:1: warning: alignment 1 of ‘struct ipr_dump_location_entry’ is less than 4 [-Wpacked-not-aligned]
 1687 | }__attribute__((packed));
 | ^
 drivers/scsi/ipr.h:1711:1: warning: alignment 1 of ‘struct ipr_driver_dump’ is less than 4 [-Wpacked-not-aligned]
 1711 | }__attribute__((packed));
 | ^

Cc: Brian King <brking@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ipr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 9a0d3d7293206..783ee03ad9ea2 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1684,7 +1684,7 @@ struct ipr_dump_entry_header {
 struct ipr_dump_location_entry {
 	struct ipr_dump_entry_header hdr;
 	u8 location[20];
-}__attribute__((packed));
+}__attribute__((packed, aligned (4)));
 
 struct ipr_dump_trace_entry {
 	struct ipr_dump_entry_header hdr;
@@ -1708,7 +1708,7 @@ struct ipr_driver_dump {
 	struct ipr_dump_location_entry location_entry;
 	struct ipr_dump_ioa_type_entry ioa_type_entry;
 	struct ipr_dump_trace_entry trace_entry;
-}__attribute__((packed));
+}__attribute__((packed, aligned (4)));
 
 struct ipr_ioa_dump {
 	struct ipr_dump_entry_header hdr;
-- 
2.25.1

