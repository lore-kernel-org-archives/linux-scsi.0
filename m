Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6792C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 20:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92E4E60F38
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 20:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhHPUL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 16:11:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230204AbhHPUL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 16:11:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629144654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kVj5qK7AP8LRloafitxHpnELunfwbeT76H+IqksB9Ss=;
        b=NU71HU766f5j4XtxW7+UGUMC0kYBZIOuqsCwm0dUY5hFzyJ+MCmEazMmhz5wc+QNYMecqZ
        FofJvnUaajOzsm6uWtyvCFOWSZXpgQGx1B7W8+GKe1S0W3Q72z8DoTlx0zp8bC8U+CobXA
        Wvd+59DmcH+X8lZgiAHQEunlV/IuGKc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-rFPraUOeM1u5MYTMebR-lQ-1; Mon, 16 Aug 2021 16:10:53 -0400
X-MC-Unique: rFPraUOeM1u5MYTMebR-lQ-1
Received: by mail-qv1-f72.google.com with SMTP id a3-20020a0cb3430000b02903432d100232so13659618qvf.16
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 13:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kVj5qK7AP8LRloafitxHpnELunfwbeT76H+IqksB9Ss=;
        b=PrCI6WUUbeiY4g5ijqm2kvpImmTpv6zp/NfKaFwqY1jnzO1UnE4e29iA+G6dnuQzyN
         oRdxvACHhqUVIdtioNXTI9nt487e7LBSRK4MUwKj3B8Q+/UrKFgotmJ8Q0EV5/Yttgaq
         b6qoLPBTwTczOEh0e6gs+1MGZ8hvHxrQQIzG5/ACP1cYesErdQWV6kr41++qZqgW8Ee/
         75x3nKl4HVGabU2/zB0Ok8MPH9ShhQPqcndPAxE7dQjTwOQzK7fjiDUSVItczepyjp0e
         vxk7VXzYRpFwg6k5DS+fwDAonLT23lJ3rQUpGQ96Vh5cJUW7UrO2gUqSEHYjB/VWh0+z
         wh1w==
X-Gm-Message-State: AOAM530H1JFF/AdakRtyo4n5B8yQW51VwDZHPXNrJ1kt9qxTZEDynhK9
        rWAy/3cHRhe+ETXRpYxqzoCy22tizxfk9R1LrSqPwFG3VRxP4MnwJV/bp/KgJeRS8kJJIkYgm6U
        qVHvDW9OzbVlIxOy4d20k5w==
X-Received: by 2002:a37:aa17:: with SMTP id t23mr60100qke.209.1629144653110;
        Mon, 16 Aug 2021 13:10:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiEZQdL6YlxZ5FIv8f2rts2pWkuXh1Rm60hORQ24pfTVfjKtsYif3n9Kygu6Ee4XGKFeOVvA==
X-Received: by 2002:a37:aa17:: with SMTP id t23mr60091qke.209.1629144652927;
        Mon, 16 Aug 2021 13:10:52 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id k8sm124227qkk.96.2021.08.16.13.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 13:10:52 -0700 (PDT)
From:   trix@redhat.com
To:     hare@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: myrb: reorder status check of myrb_get_rbld_progress()
Date:   Mon, 16 Aug 2021 13:10:42 -0700
Message-Id: <20210816201042.1294196-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Static analysis reports this representative problem
myrb.c:1909: warning: The left operand of '!=' is a garbage value
        if (rbld_buf.ldev_num != sdev->id ||
            ~~~~~~~~~~~~~~~~~ ^

myrb_get_rbld_progress() can return without setting rbld_buf.ldev_num.
Reorder the checks in the if () statement so a failure short circuits
the rbld_buf.ldev_num check.

Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/myrb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index a4a88323e0209..132aec8e51e5b 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1906,8 +1906,8 @@ static ssize_t rebuild_show(struct device *dev,
 
 	status = myrb_get_rbld_progress(cb, &rbld_buf);
 
-	if (rbld_buf.ldev_num != sdev->id ||
-	    status != MYRB_STATUS_SUCCESS)
+	if (status != MYRB_STATUS_SUCCESS ||
+	    rbld_buf.ldev_num != sdev->id)
 		return snprintf(buf, 32, "not rebuilding\n");
 
 	return snprintf(buf, 32, "rebuilding block %u of %u\n",
-- 
2.26.3

