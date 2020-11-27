Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E897C5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 18:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A977F2224B
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 18:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L6ti1MEP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgK0SZl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 13:25:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726250AbgK0SZk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 13:25:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606501539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Am+Wm5jC2GOijd2mNeO2v2NLrmRbuKRBi2OUboWUBjM=;
        b=L6ti1MEPUup1qnGSvuP5i77ih6WJKTyUCTrk70U1h/PC/cow/ewQX1VRMPXX4aEWHRvFkd
        x+4MJM5cojab2NBmAqFJ4zHCdqPA3MvKFaAUhgxo6K1MvWbEsrU2Ho3XtxfvJ2e4O0G9vc
        s0HXaG1C2oGfyKfissW8ZSljNyo4JHc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-wu7wNSEwOYGg0OCm0D_CWg-1; Fri, 27 Nov 2020 13:25:37 -0500
X-MC-Unique: wu7wNSEwOYGg0OCm0D_CWg-1
Received: by mail-qk1-f198.google.com with SMTP id s128so4188898qke.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2020 10:25:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Am+Wm5jC2GOijd2mNeO2v2NLrmRbuKRBi2OUboWUBjM=;
        b=Ge/TProOz8qpWnV5n3XuDpft0gZwyjVDvmDmfEBFo9BcXLZLTpkpb4bgK+OJiX0yF9
         PvGFianlvZx5IdHYF5+Y76ICLCtHjhfl4XAp3UfdEFecIsZSVcaRsz1mdVuMKWRUvxr9
         cj84l/tLVfZL+K03B0lRuwZaEKYfQaK4l6rK8FCIJ+IyN/oT8NDPZDOtks7Z3RrLp7cv
         H42ZO2OGNX0dvZmLvGOLTUknYGJkioysLv0ZGQ7Trq/8S5mUbW5fzSh7zWEa8J+/HGNE
         oJDTVIxPj2O9zfftIwbZHGwBpZQyWdgqRIHxYSeRAn1fUJtqkYMq2Xk55MXQ40LFjfwu
         lgAw==
X-Gm-Message-State: AOAM531jYAV+oFvUQv8PjzxZGcV4LVyZWz/ieoHvFipmzQ/aoPrTUvVX
        5OUXydDtto8AzCqk33MXOtpKxx4NgibiKqHd8cdVPpPP+6wzsbuuzDMJno4s1I6pdJB8Gxtgxjd
        PDRDcDDATAXtb+CIFSc7vtw==
X-Received: by 2002:a05:622a:154:: with SMTP id v20mr9556422qtw.185.1606501536908;
        Fri, 27 Nov 2020 10:25:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxE4SP5QlhkUVrLJ0zS6npRf76mLh15D+rJ3MesG6bzjI/RkuSvu6k4i+vIGjASO6sn0vTkaA==
X-Received: by 2002:a05:622a:154:: with SMTP id v20mr9556406qtw.185.1606501536735;
        Fri, 27 Nov 2020 10:25:36 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id v15sm6756334qti.92.2020.11.27.10.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 10:25:36 -0800 (PST)
From:   trix@redhat.com
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: aic7xxx: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 10:25:31 -0800
Message-Id: <20201127182531.2796882-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 98b02e7d38bb..ce8604d730d1 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -319,7 +319,7 @@ ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
 }
 
 #define AHD_ASSERT_MODES(ahd, source, dest) \
-	ahd_assert_modes(ahd, source, dest, __FILE__, __LINE__);
+	ahd_assert_modes(ahd, source, dest, __FILE__, __LINE__)
 
 ahd_mode_state
 ahd_save_modes(struct ahd_softc *ahd)
-- 
2.18.4

