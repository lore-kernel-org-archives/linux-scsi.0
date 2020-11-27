Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86DFC3E8C5
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Nov 2020 00:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A386F2222C
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Nov 2020 00:31:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LlZqlmAB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbgK0UBt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 15:01:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731209AbgK0UA4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 15:00:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606507201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=YX3PDhvRE+VeqHxgvNMZolM1FSVvjpNDz5RKUJDXUSA=;
        b=LlZqlmABA1q82dCq/khbm37uWlCtUOmt3ARIWTMsLjoOIYZL7kWiCxYsD/ZQ6yWsBvbqBV
        6blz9K8RTvp0/0yZaSrg9qaWHIRraHlwnSR32DdyFbaYxPoTZrFfeWThiYjOLJxlVU8MMR
        4JkivsBcyV/UCpTrmVGKM9dbP3tvCck=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-mg78b8EDO9G0ImFZXoPJlA-1; Fri, 27 Nov 2020 14:21:56 -0500
X-MC-Unique: mg78b8EDO9G0ImFZXoPJlA-1
Received: by mail-qk1-f197.google.com with SMTP id 202so4260375qkl.9
        for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2020 11:21:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YX3PDhvRE+VeqHxgvNMZolM1FSVvjpNDz5RKUJDXUSA=;
        b=HSlKr8cax1Q6qO2jePxvS+a+4PsDtVWK+KH0fTnWqWuFNmMUu6s1OoPERwBIKyuiQ1
         iQR/yZAYis3SkxMxrYcosVsDLjRqf/CCQaOh4EhRgYjO4B2Q4Xcs0yhx2f4nTbSXqlmX
         aXpm1FqvtgfxqAzFy2x1Bb4O+fev0VCl+o5lpDAGPgWmW3xcxnZ9k5ypxXanMKhm5tcz
         fYjHjU7X8YpPnsYSvDuM8ztS/kTjhDJmGrd5ezkJvndoXq3kCjBWdATHIxb2PSV4mINX
         BGPloJYp1oa63XFuOlFV05JdUJK8bMVuyCHVNM02CQNLw7bKPVGz+6lD+pupDObN+CRQ
         mT5A==
X-Gm-Message-State: AOAM532Y0gsAHAfvfTLS+MwNAl5GBV08eysd52UbJYiC8JghWDxFw+rf
        aW/HJExpkK2H6XPC5wPfdoFt08SKTrFEC4CSszE5BgO3i14vMCxZuyTv/jbJFjvH4+5DSpNu0ci
        c+MHPwP26cNwlzUZADQwjlA==
X-Received: by 2002:a05:622a:291:: with SMTP id z17mr9764529qtw.180.1606504915966;
        Fri, 27 Nov 2020 11:21:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxTjd3+sc/rOOK9IGazo/f+VSMO0SUNnoM4vNPL9Qx06yg0Cqm4w4a1MKDCHKvLsCni1m5cUA==
X-Received: by 2002:a05:622a:291:: with SMTP id z17mr9764514qtw.180.1606504915784;
        Fri, 27 Nov 2020 11:21:55 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id z19sm6946111qtu.51.2020.11.27.11.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 11:21:55 -0800 (PST)
From:   trix@redhat.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 11:21:49 -0800
Message-Id: <20201127192149.2859789-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 include/scsi/scsi_driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 6dffa8555a39..f6221c006aa7 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -25,7 +25,7 @@ struct scsi_driver {
 
 extern int scsi_register_driver(struct device_driver *);
 #define scsi_unregister_driver(drv) \
-	driver_unregister(drv);
+	driver_unregister(drv)
 
 extern int scsi_register_interface(struct class_interface *);
 #define scsi_unregister_interface(intf) \
-- 
2.18.4

