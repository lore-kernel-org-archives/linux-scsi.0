Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87BCC2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA7112075E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VW2nbAtt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfLZLOU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:14:20 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:43437 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZLOU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:14:20 -0500
Received: by mail-wr1-f46.google.com with SMTP id d16so23379133wre.10
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AO5VVAM67so5GWV1q7NAtExoJpG6U8frOwjkug6RLp4=;
        b=VW2nbAttMB4uA6ZwjZrNa2Y2ASrKcU6e0nsxB+0wWZ5Ybimnumt9DJXjNLarYk/Vv6
         xl/sV1di5Ii30uBDtJLHlkNmTTrD2pYuUKkMLywSxc1PeD9+uYh/A/6f7DI7SBW5UJ+7
         Hanr7OnkAPL+bjPa6pl1f9euLWJvfc8ixE600=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AO5VVAM67so5GWV1q7NAtExoJpG6U8frOwjkug6RLp4=;
        b=EVhIPo4y4yk+mfOVhJMup1ncSWhMyE5c8tZH/+MKgQo/8EUcQc4ZLV3rS8B078upzk
         1pvtZfN2OdKRioSN2vi/AaDzO4VbXIp79gwT4A0Qkxa1yC+J1H8nHkIQ1u6lwZ4Ie98q
         FmNTXVZkwnTD2+k05eoQx3qtVXE4qhhIaBNtqtppDd5A//duOUfehCEQdXBewErP3I1K
         TCTTcjhMwH6cSLUu7hxVNoniDKPohU8Mc70mIZXxrweowH+obOqgOumwYls/aGBKssef
         yX2wEjA2BO6fzgu5T3+jg2M7USJoy9714shau2bCILAS8bNyPYNp/7fPKNJPjS5e5WEf
         /hcw==
X-Gm-Message-State: APjAAAV9PoIwbjeo13qLyBv8WZ1xRO5xT+nOkVL+qK053R6xbpWRCNvr
        cURe1ZsqcoAXB3C6H9vfaSIhGuAb/2wtjFrFbvx4vcPK8N+CrzUwhS4ijWzpYTnliPjVbjQrg3S
        vjJNdfZkoQIa7ELmzWLq8ZssLUIoGa28reME2/Vq5vMxpugdOCDAwJhASt/0/2o+EtGDbizH6mW
        Zdpm+JWhR/
X-Google-Smtp-Source: APXvYqztECnbNJX09dRJCuake0rC9F1vHzFcZaSMh+9ENNOPI6lKf2+YZPhXMqZGbQAxqKuVRCpQZA==
X-Received: by 2002:adf:a308:: with SMTP id c8mr43565868wrb.240.1577358858131;
        Thu, 26 Dec 2019 03:14:18 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u8sm7957966wmm.15.2019.12.26.03.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 03:14:17 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 10/10] mpt3sas: Update drive version to 33.100.00.00
Date:   Thu, 26 Dec 2019 06:13:33 -0500
Message-Id: <20191226111333.26131-11-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
References: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update mpt3sas driver version from 32.100.00.00 to 33.100.00.00

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 6ab726b..1cde3fc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -76,8 +76,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"32.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		32
+#define MPT3SAS_DRIVER_VERSION		"33.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		33
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
-- 
2.18.1

