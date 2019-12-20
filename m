Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A7AC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2D2924679
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Q+ILiBik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfLTKc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 05:32:56 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:35793 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfLTKcz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 05:32:55 -0500
Received: by mail-pg1-f180.google.com with SMTP id l24so4741963pgk.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 02:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cz6MvoAT/LDo49I+DalZZygU5MP/dM2eUpmG6RUcDsw=;
        b=Q+ILiBikz70XwroxoO7KK6igjqdY0MWTT07Nb37bpT03YWHX5S3xNveesmLg3pGQ8G
         XOZVBdBx6o3ptAZVt130Xh6xRC+Pf4Llizp9sdpAPUiTYsScvdjPRQyd1CVJZnLPaekO
         X7G38LT5ADTSmCljm9mmihLJ+V7L/3GQJeKkQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cz6MvoAT/LDo49I+DalZZygU5MP/dM2eUpmG6RUcDsw=;
        b=bD+pAESJ7dVJwgyJsn0fGOAoeM103crkXwD7wBUm+5k5BOcfTs/n1d2OXNNXEvbaq0
         c5x1uLCEZcqpU3zsuc3Pls+oetKWpIRlK1XaPOfxeLvZxFEfJ3ZXgBJ8cK+/Z0NfU5Ks
         cQtwSx9z1QxscUvQBS17Lld6xnf81B+un9mS8Cc1mxhYa9ynVSSH1tC9F+UhnJTXOyaY
         5pY9l3ZOqoQfj//B/QGv4hmnbJCoDJU7BXhpJwvk+Jp9bivp3KWbiHDx+Kx/TjYih0id
         kaIvbG8w9Y3PLVyBPvqxbOEPRDclaw29+txb67RsWWFs0Gv9aWH/ib04jWOM1Tjn8y1z
         BZhw==
X-Gm-Message-State: APjAAAU5M06JzSFmFPSm9mcsxBx8oc/6dTWfrkgeKuK4zG9yOMnDSKA3
        hqzINDnQ/ouz2r38jdqhIBaLxwZiG6AmtUK1ndPbMxkEdpMZ3Mn3l1h4XDuelcxlAjj7DGQot6A
        5THPIPbfNVLWq9C5q0R3lJteG4A10kjjoY55YekBsbbGqg2+j5TnY5/oG6JexLeNJhiihil8EDo
        yhkkIMDQ0doZG9kOddMA==
X-Google-Smtp-Source: APXvYqxxYOI0LN8PzmAS5oj+JKPDpm9ieKl+SFw4lYwSbHfNoYue5vkxTlFdcpj3G/wq8MhVHuRshA==
X-Received: by 2002:a63:6b07:: with SMTP id g7mr13849710pgc.243.1576837974276;
        Fri, 20 Dec 2019 02:32:54 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 200sm12185364pfz.121.2019.12.20.02.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:32:53 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 10/10] mpt3sas: Update drive version to 33.100.00.00
Date:   Fri, 20 Dec 2019 05:32:10 -0500
Message-Id: <20191220103210.43631-11-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
References: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update mpt3sas driver version from 32.100.00.00 to 33.100.00.00

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
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

