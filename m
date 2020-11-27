Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46E6C3E8C5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 18:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A31F22244
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 18:27:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NM9igEvi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgK0S1u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 13:27:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726361AbgK0S1u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 13:27:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606501668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=ivVfcziFHnEvcS5Bte7luvrxRDQJe1ZJdM0WYQjDTTA=;
        b=NM9igEviGoRRu/M5b2Z16gStmwis1XI83RiAKNV+GakK8JgnjuiS++rXvSgQVtF8kvKkvu
        YqX33Uq2fdFqBRVF2IaHuNs1xcYoIvDeeVJkMQtR0pC/HmahOT/fpd6ZRek5ByU7nmUlk4
        HgpMiwZtXCqJeHWr9YtHRIicP9tWJGw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-6tFNqvljOH6fNoGdtGWifA-1; Fri, 27 Nov 2020 13:27:47 -0500
X-MC-Unique: 6tFNqvljOH6fNoGdtGWifA-1
Received: by mail-qv1-f70.google.com with SMTP id s8so3491485qvr.20
        for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2020 10:27:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ivVfcziFHnEvcS5Bte7luvrxRDQJe1ZJdM0WYQjDTTA=;
        b=t2YJIt2uWByvM9YAcpJ3VAE67C7W5PvAS7gLL2qRKNCK/ztZ0sCGUoR62IXPQM1+f7
         ub9iWIYsNasCvUqAwS56PJFdDaRcadKakKqfiDQfrCT9DFoIiHCmqiJRtWZ1Ect7/pm1
         713exwZG2fVZ8jzrsBOzoxwXRI5iqGDHh4loespJKa4/72kCfNQCRKc6zbATwbmoyayQ
         GGLpAQW8GxNPLJTWF0Pj2QYfzaolbsQB9PaVCN0rWMCErRduc1+rBIQrPQ3n5wkq5QSm
         Nbei+zSHi98ZzfapxwIg4wk4SnNCZcwEsvL9+gX61EMEslqlkQI2m0Dhf0OAGXRTnvpa
         WL+w==
X-Gm-Message-State: AOAM5338fbUoQSXQpNszkKWs6hUyeHQuNcIHwi8p7TuccaHNVacijUSQ
        8uWM927s8SRFaa6qTPuQ4LRlohGDr9AzkFG+PYAAR79Q5bsunJpyNiUxNqwfrVwxKMGKy1Ks5SO
        G7m0u15OF3laV8uTdfAehcA==
X-Received: by 2002:a05:6214:1150:: with SMTP id b16mr9236310qvt.46.1606501666755;
        Fri, 27 Nov 2020 10:27:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5LBFW1XYMsGNH49WE9w7zTVsK3Xp4ZMYlvm2rn00CcrHZZTtmkUgDFpLEqHTZigDkV/pjzA==
X-Received: by 2002:a05:6214:1150:: with SMTP id b16mr9236303qvt.46.1606501666568;
        Fri, 27 Nov 2020 10:27:46 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id p73sm6497879qka.79.2020.11.27.10.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 10:27:45 -0800 (PST)
From:   trix@redhat.com
To:     njavali@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: qla2xxx: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 10:27:41 -0800
Message-Id: <20201127182741.2801597-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ed9b10f8537d..86d249551b2d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4970,7 +4970,7 @@ struct secure_flash_update_block_pk {
 } while (0)
 
 #define QLA_QPAIR_MARK_NOT_BUSY(__qpair)		\
-	atomic_dec(&__qpair->ref_count);		\
+	atomic_dec(&__qpair->ref_count)		\
 
 
 #define QLA_ENA_CONF(_ha) {\
-- 
2.18.4

