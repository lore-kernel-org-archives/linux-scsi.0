Return-Path: <SRS0=qHo0=X6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F070C3E8AB
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 07:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2AE320862
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 07:35:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RNxsouHc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfJEHfj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Oct 2019 03:35:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33804 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJEHfj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Oct 2019 03:35:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id b128so5317856pfa.1
        for <linux-scsi@vger.kernel.org>; Sat, 05 Oct 2019 00:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8aaDJ3KJTWBvgPvGck3r7tVL6xlfCWxTE6ez+2z2dP8=;
        b=RNxsouHc1CDPiM+h9JQm9f+3TE7R/XzhVRw4iUOfdEnDTj6Lvqap5XCzusQeXQspSh
         2MDKsYaKL6m9laqNUD5uqHvAb+E3oOrHJHKoZEBmSZenJexzcLqi9+hiG/WUq98CFTIb
         UMso61p+bipuFyG7BByk/bAqKZIR7KcGcAsL4SbWwJaOnxewP6KIFnAzaa2D5YPdNdDH
         /gXp/1ilIMq8Fzm88PceYGyuw/9PqujQjdkvc7hw3n1gQ9oBafJNS1oKkGq60ZF6+q5z
         NnYxdm2WsefLOxJ8gYvHqv7TvUa2gSodL8dcBWuc2ZiL06S9FQ3ZVVgs0YDxzdwi7rcC
         gucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8aaDJ3KJTWBvgPvGck3r7tVL6xlfCWxTE6ez+2z2dP8=;
        b=Y0W4wRhsDdf2ly+P4MQ/pNXmnl2plL9T6+SK+8goqBDIEql/E41qwX7qYdPDqKJors
         lh80FpRMZMAvuVbOxPKE0bRa4cCovUun558C52vmx0y0/0UCCDnMJ8J5s1yExQHr1XgG
         IlhkUjD7MQBKAR4GaDRFSJWLbknGLf1UNrjzdrqDcxeMjOTj0zm+OlgOgvcDsGaeJ+2c
         f9aVyDZARHj7NQWFDaUfYfkLjaPjQMLl9aRfxnEwVKHvmYkUlzmCVsalRTnf4QBWyEQn
         uxydh1UdFaQ/S7T2BUD4FY1B+oYidrVZenXyLSmI2lGlARTAsttclFLJeAvq+v6u1ZgN
         zw6w==
X-Gm-Message-State: APjAAAUgRwa6Vg4Q9FujDhoBXvIfsX0Xs2cMMQFHIvidAxQz6pPmXuy7
        +vhHZfHQtWDjpjFAG/aBkWU=
X-Google-Smtp-Source: APXvYqz0brgL5lwanCDEWYfX3A8WWCQTsdSt1NMkc/P5jw4d73ij8ozJtU7rK6YBeUURfYuK0znfIQ==
X-Received: by 2002:a63:2aca:: with SMTP id q193mr19385050pgq.156.1570260938323;
        Sat, 05 Oct 2019 00:35:38 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1950:559a:117f:4889:e0ff:3af])
        by smtp.gmail.com with ESMTPSA id f65sm4158849pgc.90.2019.10.05.00.35.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 00:35:37 -0700 (PDT)
From:   aliasgar.surti500@gmail.com
To:     brking@us.ibm.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Subject: [PATCH] scsi:ipr: removed unnecessary semicolon from switch case
Date:   Sat,  5 Oct 2019 13:05:26 +0530
Message-Id: <20191005073526.11761-1-aliasgar.surti500@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Aliasgar Surti <aliasgar.surti500@gmail.com>

Unneeded semicolon is used after the closing braces of
switch case. Removed the same.

Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>
---
 drivers/scsi/ipr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 079c04bc448a..c463cd74fed8 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1164,7 +1164,7 @@ static void ipr_update_ata_class(struct ipr_resource_entry *res, unsigned int pr
 	default:
 		res->ata_class = ATA_DEV_UNKNOWN;
 		break;
-	};
+	}
 }
 
 /**
-- 
2.17.1

