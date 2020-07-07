Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6899C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B311F20738
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DY/Y6rRC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgGGOBG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728155AbgGGOBE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:01:04 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF981C08C5E3
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:01:03 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 22so43400524wmg.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/cqZIdFqcpIXxhTbwotqjldLYbQ1H9RlyQjCdSkXyGs=;
        b=DY/Y6rRCsOjNTJ4MkMoPwBn+t6tp8Ea3aR3cwKW07HPMrJatmNWyjsxXWn8QkYDC9A
         MjrEbwgrbgZZxlHsmKUvipQUvak0bqLJ9f+zQwDGAQFTgW54RkqkMz/JGF+4e5i78Q/c
         2KBqbs2XOY808AW/smRWfFkGiaf9aMa713477C90tUkPIRj74nGwK2SRjYtBnft1e8i3
         IVkvAi1yYxYJ37bqk704jsA8Ompe5sVbx1WP9CxrdUjsqIps8siu/zYqjiAuTHQrJdCb
         41vt5Gk8sl8yd0WJ0DpcW5y/WTCY7ErzeiiIJe2KAXO8GRuw9+Oe0ws8P8hbK/NUezih
         UwYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/cqZIdFqcpIXxhTbwotqjldLYbQ1H9RlyQjCdSkXyGs=;
        b=IzCycpbrOfqPCPIISgru0kr7vzkWaSiV+Hh84ZE/lnr1XhvILA7FJzRaQpBEhZinZr
         1dsicmN9VidG0GE1xTQMXPptQzqPgZfOfdNjVHDDIk6Aiv2DhrnwWypXOceYxoDlVzt1
         CMeH3K1R6mms2Pk46DDqmmSEPGncs/mO981tT7YXsy8tREQYDuwJBTBfSBKVYtaMXSmZ
         x9HOMrIGZ24+nyWaw/8VeIuRVJCoF+Nq8rkq4rQHe9nBBM4g69yovsdrFlnr0U9t4ucd
         VPOufC+XSEJu3Sg2QEjNZaeExx9XFpNI4ics+4/9WaCyS558y4qMQFqBAJWdEdnGD80g
         4tww==
X-Gm-Message-State: AOAM531Cy7X6Z8nWsGL1sn2mTiQWieCwuNwCmzZUSeraRdl1bH/5t+q0
        hz9Bk17uBtjsUc55IpgPA9/drw==
X-Google-Smtp-Source: ABdhPJxcwcKHBS+Zqr7hOZ8rG07HC55gAhjiOhogcm4iiP2hTlX4x1wCiARK/E88lw9mjx75xGrnpA==
X-Received: by 2002:a1c:49d4:: with SMTP id w203mr4610085wma.13.1594130462391;
        Tue, 07 Jul 2020 07:01:02 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id z25sm1102823wmk.28.2020.07.07.07.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:01:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/10] scsi: fdomain: Mark 'fdomain_pm_ops' as __maybe_unused
Date:   Tue,  7 Jul 2020 15:00:48 +0100
Message-Id: <20200707140055.2956235-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707140055.2956235-1-lee.jones@linaro.org>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Not all source files which include 'fdomain.h' make use of 'fdomain_pm_ops'
leaving them defined but unused.  Mark it as __maybe_unused to tell the
compiler this is not only acceptable, but expected.

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/scsi/pcmcia/fdomain_cs.c:16:
 drivers/scsi/fdomain.h:106:32: warning: ‘fdomain_pm_ops’ defined but not used [-Wunused-const-variable=]
 106 | static const struct dev_pm_ops fdomain_pm_ops;
 | ^~~~~~~~~~~~~~

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/fdomain.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fdomain.h b/drivers/scsi/fdomain.h
index 6f63fc6b0d127..93afcee207aed 100644
--- a/drivers/scsi/fdomain.h
+++ b/drivers/scsi/fdomain.h
@@ -103,7 +103,7 @@ enum {
 #define REG_FIFO_COUNT		14	/* R: FIFO Data Count */
 
 #ifdef CONFIG_PM_SLEEP
-static const struct dev_pm_ops fdomain_pm_ops;
+static const struct dev_pm_ops __maybe_unused fdomain_pm_ops;
 #define FDOMAIN_PM_OPS	(&fdomain_pm_ops)
 #else
 #define FDOMAIN_PM_OPS	NULL
-- 
2.25.1

