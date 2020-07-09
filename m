Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABE4C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39772207D0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F/1o22f0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgGIRqj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728663AbgGIRqZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:25 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5967DC08E6DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:25 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l2so2758710wmf.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=npmbMmGwXmpaLu61Oedwmcs3qT0N7Ml8rtlLxMj9sy4=;
        b=F/1o22f0o/hLVmprlDU9Qr//sGwjrN5uBf5VsCAcjtijVd/dT2CI6MVzsvcskMRGpZ
         +7cVcba0uHIIcgEY9PEBnLie35L9sAdxl1kb5OP4V/14j6/iSyuyPkpHNPh6umlOFV5P
         JAcC8hsTvn+aAiUw9vEP7h1rTfAOwi1xSxFifbmG7f+W9zEmx/J1szmQPv5cF9isaQz2
         11rRmpTP/QRS6mWFSA1OvmVkmlXzipShH9+vRqUKXADfPgY9EtY61uynWcnPhndfAzSS
         jEiICGMcO0EtQPWeUAviR025+ZT/97yCIFkrUBkeDpLOoWW52ZX0T/yiI18fZit3cQkl
         dbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=npmbMmGwXmpaLu61Oedwmcs3qT0N7Ml8rtlLxMj9sy4=;
        b=IWMNL2hElfLeiXsuOb84ANA88M63Ct7gvMJ+ZxYdGS1ubWMWTMeAlf2dMYJnPwwIzW
         jy3SbLNJBAdvfB7PU7Rs2QpD8fBtiNxrJVsrKDySfU1gkl+eHDmBpTcjq/fCKPGVDAtM
         XGx5Ubiiyo6JxPnXwm66SEeiQI9v71fjpI05vQe/sg9N7jyG4EIfeec2mzsjhgN6Bw2z
         rSDROlTWJu4GNjHZJE0DrnYqrjCKKC61CG68J1DpXfzQ8XO3FtqANM3Qsj4tIBX3VcD3
         nIDa83J+VaSCTJ/hhfgd/bngmON846Mv28dKltQcdcmBGWwJHmNyVtSWAYEOHDJRjRWF
         sRaA==
X-Gm-Message-State: AOAM530xXkyytSvQj0vy3IkmnWzzVle2Grf7jtoNfZBlc4SIxgN5Qw+Z
        //oYmhTz+EU9hZ8liEJhsTb6Tg==
X-Google-Smtp-Source: ABdhPJyK0cTHJi/HHlU/eCy0bAteTij1tSUpRhma9IuaO7nlZzYQAcrF4E3VmyYJ9+nrGYNfRBh1Fg==
X-Received: by 2002:a7b:ce87:: with SMTP id q7mr1170635wmj.39.1594316784135;
        Thu, 09 Jul 2020 10:46:24 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:23 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 22/24] scsi: aic7xxx: aic79xx_osm: Remove unused variables 'wait' and 'paused'
Date:   Thu,  9 Jul 2020 18:45:54 +0100
Message-Id: <20200709174556.7651-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It looks like they have never actually been used.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic79xx_osm.c: In function ‘ahd_linux_dev_reset’:
 drivers/scsi/aic7xxx/aic79xx_osm.c:782:9: warning: variable ‘wait’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/aic7xxx/aic79xx_osm.c:781:9: warning: variable ‘paused’ set but not used [-Wunused-but-set-variable]

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 9235b6283c0b3..8e43ff86e0a60 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -775,16 +775,13 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	struct scb *reset_scb;
 	u_int  cdb_byte;
 	int    retval = SUCCESS;
-	int    paused;
-	int    wait;
 	struct	ahd_initiator_tinfo *tinfo;
 	struct	ahd_tmode_tstate *tstate;
 	unsigned long flags;
 	DECLARE_COMPLETION_ONSTACK(done);
 
 	reset_scb = NULL;
-	paused = FALSE;
-	wait = FALSE;
+
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
 	scmd_printk(KERN_INFO, cmd,
-- 
2.25.1

