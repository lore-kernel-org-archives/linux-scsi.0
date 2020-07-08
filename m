Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37C6C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A250E20775
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KpCSdog7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgGHMC2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbgGHMC2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:28 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B354C08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:27 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o8so2706550wmh.4
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OYcU6QrkQ8vEFK16KZ0JwglvYSsa1RsL+nSDllm7Llo=;
        b=KpCSdog7huLlJl0j5Tz551x3UOHlNMY59WJnYF7IOjTNQ7wGfCYJwMCkY7q/tQQvFB
         tPxTBmOK4P2phupcTbCAGmgW4bl05vYVFXnkPACYCRmO5PurZJ5BotQL4IfIkwBK0vRx
         9AEOsxpeG4po7sQEpY9l227WkEHE3rKVKVmlrH1c3xkFMfY8xEXRsJY0W9lQ1rINQecT
         e8EmCwPRoEPigbSphNAFdzgSsGLRbOtOumrBqaXFbPKvjqEKmzp/E8inOLjAld3mGX0p
         rqYQH6JHXH01TBdNtxnNOBkHOP5k2WyPD6yo7rRy/U875/5DH47Rut8yY7Nx1xj2qTW5
         QrQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OYcU6QrkQ8vEFK16KZ0JwglvYSsa1RsL+nSDllm7Llo=;
        b=LHdp98gzCHb66LfP0XpC6HsCQR60mCg8CKkfWi85y+wWBoUyI1tL9wOR31xssVQnIP
         NhcXYNUbMo8I7Nz44DGv2xZGf7a41elpnMTZCFnDf9BIooCgATSd/ramNDHAYFMMcw7E
         Gv0VWeMc7nvbtYFVNtItAIfM1KjCm/N2qMqbK1tYdPDCEjFzpatbms8UbeLqZHqJg43I
         XQ5IxEBFzfaMxKPruoFjHCeWtBxyfJ0BKLNiizppDADsaKslHqRY6JgzLCacjsukVhw3
         F/BOfgUeyToSdALAxPqc1O2MTDhp3wgb9L0nYWFBiLwlD5CgVt9a8JEibC1znpvCtURg
         a3tg==
X-Gm-Message-State: AOAM532tlQQV2ETpmKr68z6h9I5Yusnbzt4xqTmMqnujMHiRU+d7iG1T
        FReLxw/jaPeXADMp5TjIw8li9Q==
X-Google-Smtp-Source: ABdhPJycC9Sqys7Gmp7jg5AAPUD6iK1Pq5Uk5vSy/gv3EyAVuisDIiJYjEPx39WpB5AD7BroV+e4sA==
X-Received: by 2002:a1c:2485:: with SMTP id k127mr8789530wmk.138.1594209746128;
        Wed, 08 Jul 2020 05:02:26 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:25 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/30] scsi: libfc: fc_exch: Supply some missing kerneldoc struct/function attributes/params
Date:   Wed,  8 Jul 2020 13:01:52 +0100
Message-Id: <20200708120221.3386672-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/libfc/fc_exch.c:66: warning: Function parameter or member 'left' not described in 'fc_exch_pool'
 drivers/scsi/libfc/fc_exch.c:66: warning: Function parameter or member 'right' not described in 'fc_exch_pool'
 drivers/scsi/libfc/fc_exch.c:100: warning: Function parameter or member 'lport' not described in 'fc_exch_mgr'
 drivers/scsi/libfc/fc_exch.c:727: warning: Function parameter or member 'ep' not described in 'fc_invoke_resp'
 drivers/scsi/libfc/fc_exch.c:727: warning: Function parameter or member 'sp' not described in 'fc_invoke_resp'
 drivers/scsi/libfc/fc_exch.c:727: warning: Function parameter or member 'fp' not described in 'fc_invoke_resp'

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/libfc/fc_exch.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 52e8666598531..16eb3b60ed582 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -49,6 +49,8 @@ static struct workqueue_struct *fc_exch_workqueue;
  * @total_exches: Total allocated exchanges
  * @lock:	  Exch pool lock
  * @ex_list:	  List of exchanges
+ * @left:	  Cache of free slot in exch array
+ * @right:	  Cache of free slot in exch array
  *
  * This structure manages per cpu exchanges in array of exchange pointers.
  * This array is allocated followed by struct fc_exch_pool memory for
@@ -60,7 +62,6 @@ struct fc_exch_pool {
 	u16		 next_index;
 	u16		 total_exches;
 
-	/* two cache of free slot in exch array */
 	u16		 left;
 	u16		 right;
 } ____cacheline_aligned_in_smp;
@@ -74,6 +75,7 @@ struct fc_exch_pool {
  * @ep_pool:	    Reserved exchange pointers
  * @pool_max_index: Max exch array index in exch pool
  * @pool:	    Per cpu exch pool
+ * @lport:	    Local exchange port
  * @stats:	    Statistics structure
  *
  * This structure is the center for creating exchanges and sequences.
@@ -702,6 +704,9 @@ int fc_seq_exch_abort(const struct fc_seq *req_sp, unsigned int timer_msec)
 
 /**
  * fc_invoke_resp() - invoke ep->resp()
+ * @ep:	   The exchange to be operated on
+ * @fp:	   The frame pointer to pass through to ->resp()
+ * @sp:	   The sequence pointer to pass through to ->resp()
  *
  * Notes:
  * It is assumed that after initialization finished (this means the
-- 
2.25.1

