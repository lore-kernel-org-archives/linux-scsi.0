Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6825CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD5A61212
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhIJXeC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbhIJXdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:35 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD7CC0613D9
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:21 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q68so3218511pga.9
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V3CtqB54aGUlAB2YSezJgPFCNJSusZEaGV+8iCSjgiM=;
        b=hnK7vvCW8aUzBgtksP64l6d1xKM36TUuXJjsgV6BmRey2mLKkXSbqlPOUJEj/U4QnE
         p03RnWZHYuvuXkjI6ffpg/0PyOJkwD8duELdirqC1f5sVSYi3PQb/jvw71r4sB0/qtNA
         oVBZziBQD3EImoJeaCi60nMwGr5bvAgSf2tjizot101crBn2cVnSU4Mr463b9e2pMF9I
         nd3mzK7/kPbgUnAZAT186AG+Czr7mL+sZ7hNGBpTc/JFPRytUMglmLL9EMwbiT20KGtd
         4AJY1PMuBAh8pvlCNfhgsk/kACgsL+0Sz2oUE7GBESFFBdJOzm2o+P6GcGL9lPzB4OyV
         jXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V3CtqB54aGUlAB2YSezJgPFCNJSusZEaGV+8iCSjgiM=;
        b=ltkdv8cqZbnl+ksg7NU3NmeBP30Qr3AIaYSO68MyaMMJT8CEsBH9IAMWYzMQgSax7d
         dmz4vyVwIGKShZ1isDQmInL3PvRXa6HLWkcWIvdCeo51H/J3JSVDDhkWNG48PPJKg5bc
         pDUCwRjXbBqV9uHNs/EpdGJUIwxwn44kQfzOwkb6zMGOjicfb4T3TBZmHYaWqep8KlHi
         Y+5PSIEJOvURYfsz2KgOxpPtxJWFfTmCtpqz1uznVu9C8qLzMJcvCdkU8vBt1EbSUsSW
         /FZHWM+bpqQAfzNUWoHwqa984SnhhD1QPVl9BOgFv9Z0WoHaWD4ewuchyHwYiVwCmXmv
         +jrA==
X-Gm-Message-State: AOAM5339UhAguV0xVObhULYf+ycHL6PeOgND6drTAbQin8bSPlx+oSKJ
        SS1lL1nBRFwH2caCUlTHCxT1aTT788CCDKLR
X-Google-Smtp-Source: ABdhPJz8RG5K52o3OgojPj8xkuiBUvp2HqGKgLIeDvjiZEFDPzfLN+bnOEGqLOR/aS1bqwIhT1mLDQ==
X-Received: by 2002:a05:6a00:1823:b0:42a:ee71:d74a with SMTP id y35-20020a056a00182300b0042aee71d74amr1599pfa.63.1631316741412;
        Fri, 10 Sep 2021 16:32:21 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:21 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 14/14] lpfc: Update lpfc version to 14.0.0.2
Date:   Fri, 10 Sep 2021 16:31:59 -0700
Message-Id: <20210910233159.115896-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.0.0.2

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index a7aba7833425..dec71775f677 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.0.0.1"
+#define LPFC_DRIVER_VERSION "14.0.0.2"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

