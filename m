Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AB9C64E7B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 20:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2280220789
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 20:56:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fgLvsHrE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbgK3U4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 15:56:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25226 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728337AbgK3U4p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 15:56:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606769718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=/ZAwvZtDYmNBQEeHwjGA++LouPQPRyxXm/Ha/6ZWHhA=;
        b=fgLvsHrEmfOgETQnJ7/MCS1/gSiTf8NZoR/Xov41ay2RFjdzcpAcB1dORRrFdpSfJYTbU4
        xERdwBJmDzxuIkpQYeqS3vvVAPJDuWhSLADCxB8vozETGZi/gYHn75wwpJoUvtweB8g4mg
        j17Oj96nhps80SizaPiM7YD1UqyUdD8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-pyya-zy0MaOxQQZ5yy4x7g-1; Mon, 30 Nov 2020 15:55:16 -0500
X-MC-Unique: pyya-zy0MaOxQQZ5yy4x7g-1
Received: by mail-qt1-f200.google.com with SMTP id n12so9268783qta.9
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2020 12:55:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/ZAwvZtDYmNBQEeHwjGA++LouPQPRyxXm/Ha/6ZWHhA=;
        b=D5fbYw9Ny5jDuG2iZlNOfRnia4Y4Kbf4iC88bXLS2at6rgz+0QFw05m8dSjIexoNIi
         N8MPpamz3XeV7UyzhcdpCWH/xruZ3fOBgbBezW7qJY8uVjXb3cutgN0WJrsIlCT+lU1p
         tWLi4Urfov3VUGCdm99I72p+hFoV3b9Ief5Uyafl+33GwzoG/gwcEHO+d1gRxfReg/yt
         w+jrqzrDARAGb9UMRRKLesU7GEI3DDqXh2+VopLSahHgSXNuw74xjgi8hxryJZ2OxQHT
         bIO4Nz6T2qdLvQp3Lb5fZfFZ0RFWGz+QTiKDMtRLdA4APSXzyzNXBhghMtTt59XpLfFj
         SFYQ==
X-Gm-Message-State: AOAM533afIjAnSFiRCVE9WbsPkEr9QuHCkne6erfEkOh+YwNkPAK7Tdr
        nzNN7FG9yIWvNdw4k/jEphXOZjB53/NtOnsPHNObOEU8v1Ir/rGTJua427oG/ivhj95L6Vqd16C
        CGUzMRye5N+TqP9t2ONkr6A==
X-Received: by 2002:a05:620a:16cd:: with SMTP id a13mr7120032qkn.11.1606769716068;
        Mon, 30 Nov 2020 12:55:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/UdhwRv7V20I5LgOaUh7kjrCLd1h/h9sMAUjhfrnNHqyBTazMGwFil5wCxl6j8kugPGe+hw==
X-Received: by 2002:a05:620a:16cd:: with SMTP id a13mr7120016qkn.11.1606769715886;
        Mon, 30 Nov 2020 12:55:15 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id p48sm18251568qtp.67.2020.11.30.12.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 12:55:15 -0800 (PST)
From:   trix@redhat.com
To:     njavali@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] scsi: qla2xxx: remove trailing semicolon in macro definition
Date:   Mon, 30 Nov 2020 12:55:09 -0800
Message-Id: <20201130205509.3447316-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.
Remove unneeded escaped newline.

Signed-off-by: Tom Rix <trix@redhat.com>
---
v2: remove unneeded escaped newline
---
 drivers/scsi/qla2xxx/qla_def.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ed9b10f8537d..6248e528efe5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4970,8 +4970,7 @@ struct secure_flash_update_block_pk {
 } while (0)
 
 #define QLA_QPAIR_MARK_NOT_BUSY(__qpair)		\
-	atomic_dec(&__qpair->ref_count);		\
-
+	atomic_dec(&__qpair->ref_count)
 
 #define QLA_ENA_CONF(_ha) {\
     int i;\
-- 
2.18.4

