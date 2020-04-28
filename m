Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627ACC83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 392D1206B9
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:47:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BP6hUfw9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgD1GrY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725867AbgD1GrY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 02:47:24 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA8FC03C1A9
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2020 23:47:24 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u16so1489784wmc.5
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2020 23:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=fCsSsIWaAXzpuvS6fLsJqZDlPEZcOoy/iQTpwe3g/JQ=;
        b=BP6hUfw9JcsrKYCPOCxzCrLO+VMQNJdpaXGbi1ouf0ErZ9fNH9Mbyk4uoGI2avbsEN
         55pfKVn20+lFRI4/MHFs4Ab8MNH+DaqQ0vsFbpQl30kha5s0LxUFHUTlIhu/94rq9mlf
         LPtx/c+rCfIEI+vAxetssluHdFsd4wIn4Z7eU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fCsSsIWaAXzpuvS6fLsJqZDlPEZcOoy/iQTpwe3g/JQ=;
        b=RPfqsd9T6p0X6LGNt8uTJsE72g1reu6PcvyTeGsLbgTDjaCJ09dnp/Fv1vxI8FpGpD
         SDYf2X38oW7AtUOkhKm10mbHmUee0KILijEfrO7t1esf7lYB5ISllL1KkEBxtX5RHPyt
         x1c+RMmciFkf0B8mqSaGs+6+Dc+WYfcv3N7u0XENcqxPE5cAbXBDrTpgjFC4db7614Cd
         /yl8omgngPCffkvC/13Vr+hbpl4SRs7rB5GkKS5kIEGQ97SCtyu/SqGY5SG+FXnld9zy
         mfvW5VbhnPa6IQVCR8Eeen24zJQThtmFmXbGvNPZo7CBhAtgsA61+INcoAKXNDZWHIpD
         HhgQ==
X-Gm-Message-State: AGi0PuZ0dGDjGxMC6poNm425rPKwepXZrC1qfLiihwTvP0f/UMxsiMP6
        zqg2EHOt4/AKXU2BBI6bUIfOXziLML28LKG8KJJDqFecoBNShiDTCKZQ+wfGjtrPDkgt4iWvdYw
        Yci8khqPVyhMZ7Enle/Ho/KYo9ydW+m0ICklLUano0sQkOq3FLeKlKbAABdzwXz1m/p19Wria2N
        CKK2AdaaFgysySdOc6HTvk
X-Google-Smtp-Source: APiQypIzi/MNZXf4h1Uv8AW8W037G/7ohKEhoR8MDfQenefKNeKDhKlbKYFVm9kGJaS5bjT8BpWL9w==
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr3002137wmi.155.1588056442584;
        Mon, 27 Apr 2020 23:47:22 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 91sm25870350wra.37.2020.04.27.23.47.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 23:47:21 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt3sas: Update maintainers list.
Date:   Tue, 28 Apr 2020 02:47:08 -0400
Message-Id: <1588056428-29369-1-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Updated maintainers list for MPT DRIVERS

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e09bd92..512d32e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9731,11 +9731,11 @@ F:	drivers/hid/hid-lg-g15.c
 
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
 M:	Sathya Prakash <sathya.prakash@broadcom.com>
-M:	Chaitra P B <chaitra.basappa@broadcom.com>
+M:	Sreekanth Reddy <sreekanth.reddy@broadcom.com>
 M:	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
 L:	MPT-FusionLinux.pdl@broadcom.com
 L:	linux-scsi@vger.kernel.org
-W:	http://www.avagotech.com/support/
+W:	https://www.broadcom.com/support
 S:	Supported
 F:	drivers/message/fusion/
 F:	drivers/scsi/mpt3sas/
-- 
1.8.3.1

