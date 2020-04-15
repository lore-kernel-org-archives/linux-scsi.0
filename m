Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE783C2BB55
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A40320575
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:26:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EI7znLyl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636106AbgDON0F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 09:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636102AbgDONZz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 09:25:55 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3217CC061A0F
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id v2so1237765plp.9
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z2/XKrwBxxGD909K4S30mMzPme2K/Xl+Ll8hjlo4Dp8=;
        b=EI7znLylfXsAOwV73FvSVYfaYSB0XQMTYETqsF5YBKMd3lfcqByaTwx7TCkMF2+nXS
         2CWSdJB/LP8rdf62urUDwGOqAn2RRIPStk+xihciDI2TadbgXeeHNdZR9/2+jmsgfUB0
         p+eNCezrFPpcDxzPCtnGmOTfsI/3+rho4J654=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z2/XKrwBxxGD909K4S30mMzPme2K/Xl+Ll8hjlo4Dp8=;
        b=e3Uqo7wL1/I1xsuVpn7wlsd/OXQxIOOS0OkfevcB9KH2tGhZiIIR3OQG6965Y71B8s
         IapUxqMvprMbw3OD2aDoTda0oLbMIAH1DlLpDcthnlPfDEgdKpuUoh+/DkQqYSYlAn3C
         wsMb4HKKiJW8Sp8Lf7Jnk5aXB9q88K8loy/afqf1dIU5pmkBKVCoWVm/rKVJqNdoV7wY
         3se3omSbeWcmUCi1+pzJWAycAoZQVTXAEJB9YteSzav+apAa6S5D2P3WJolx/SXRGtyx
         cuRYprskdvcGhBq9MgKu3BtyuXd/5NwDxUNULcV6HEil0wgQ6r3Ju+XPiyqLE2UTB3JV
         RTAw==
X-Gm-Message-State: AGi0PuZ9cM7jeyolb5T1A2Ow9s7Mp28Vz3VZLnDze1LxyPPNgelsGyZy
        zfdHASIfRspKbuw/Zjqt5J+P27J29QqZvr4Hk+kbaL9LDTcqc8iXUmn9rBPANRyBoy9Q9i6GvsN
        iAbBQQeD1rYsXuggBMemAdBlL2OAKvMxP2RXPpHpjoATjtRzVp9Q6+AxNF79wV1w0PaBtCnSMix
        XzC9lkN/w9UEoagqbHqZYg
X-Google-Smtp-Source: APiQypLY527NOx5Mrb3akxH1Ko+eaQrNCm3MFdNj+9gR6ijMg76UJQuCpqOHEfOT1Meyf575wgoQbg==
X-Received: by 2002:a17:902:7e42:: with SMTP id a2mr4799168pln.223.1586957154317;
        Wed, 15 Apr 2020 06:25:54 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x186sm13715556pfb.151.2020.04.15.06.25.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 06:25:53 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v1 5/5] mpt3sas: Update mpt3sas version to 33.101.00.00
Date:   Wed, 15 Apr 2020 09:25:25 -0400
Message-Id: <1586957125-19460-6-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Update mpt3sas driver version from 33.100.00.00 to
33.101.00.00

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 99724a7..c136157 100644
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

