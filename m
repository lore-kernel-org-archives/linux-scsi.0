Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7C3C55191
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A914F20736
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:23:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fvVAb2HI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgDWHX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 03:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWHX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2020 03:23:59 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0320C03C1AB
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:23:58 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d17so5523116wrg.11
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WeErXdmvBpS/99pytbGEcH6lwN0v1sHycZ3XqJLGIkw=;
        b=fvVAb2HItGwOPQFS4Qs6pQpxtI2xQh9RjZFISbTsWDEr8u9TcwFE8jwoYVChwewZnL
         KAGRKmMcuW7UhsA8LpDI6cx7epx5C5Ff6Mfi6V0OWlJxxO697qa5FdXuWIUXvCNET0x2
         axY2hnO6ztPL31dAktMkUnEC0Bntw5zdF1epo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WeErXdmvBpS/99pytbGEcH6lwN0v1sHycZ3XqJLGIkw=;
        b=Bk+u2dwcEbSfFpSGUKwEey8+pEMRRUBIIadCBpAa2fIasgWYOiXfqvUqbm01e32Guj
         Uly6JQT9cV3cKDJEwiOKzjACwNYmqG2E2pafE2mKJAugBrmwex8vTP+T5/L+MfJS8gQ6
         BDO9X8p7lE5c/VoGKc1Akf6zPSjGr54uogDumJYnQ+ePoLmEgq4JPrTVrpsoSAFDTfDN
         UPzh8x9F/9ykzqZXaUvaCGtNc84hszACum6fTI5o6+C9f7o10/YB6+pnWDb13tCV127a
         LpZJS7jXcdkFQIr6sdOJSiUaQeyCYkVo5SLMJocMOgxmYjJEET1kksayYVDNelvs4EMR
         4SQw==
X-Gm-Message-State: AGi0Pua691G0u/VwJ9oKBqv4MXAl1EfvqQ1mvcwZ3HvPOhJcle9uWW2k
        6ahu9xtlRpF0YNOSjwTkRowdZNqsyVxMR0p2xwyTZ0v1HYlJ+v94+sJIe30KiQbpKK5h6q7bToW
        abpkI/FNBc++uyg+12y6EdWbx11gi3vkxiu26y0R9LH1E1OkVikNKqIXEq4Whca8pxhBI0IJyrp
        u9H1GjbJPBW7CQH9t2YZbG
X-Google-Smtp-Source: APiQypIpg8X/M6aEojjbe/jRMTFII57Whu86TpryRoB51Xqz4TkcyTScv8lHawXLlEtSvQhsm9agAA==
X-Received: by 2002:a5d:4702:: with SMTP id y2mr3234771wrq.15.1587626637220;
        Thu, 23 Apr 2020 00:23:57 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id l4sm2336130wrw.25.2020.04.23.00.23.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 00:23:56 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [v2 5/5] mpt3sas: Update mpt3sas version to 33.101.00.00
Date:   Thu, 23 Apr 2020 03:23:16 -0400
Message-Id: <1587626596-1044-6-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update mpt3sas driver version from 33.100.00.00 to
33.101.00.00

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 5a83971..c574379 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -76,9 +76,9 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"33.100.00.00"
+#define MPT3SAS_DRIVER_VERSION		"33.101.00.00"
 #define MPT3SAS_MAJOR_VERSION		33
-#define MPT3SAS_MINOR_VERSION		100
+#define MPT3SAS_MINOR_VERSION		101
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
 
-- 
1.8.3.1

