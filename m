Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6A1C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8999F6108B
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237806AbhHTDBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbhHTDBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 23:01:11 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA27C061575;
        Thu, 19 Aug 2021 20:00:34 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id n11so9531150qkk.1;
        Thu, 19 Aug 2021 20:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9y/cX/LKtjaQzp4b6Rm1D3+gyyCmB4EMWjE7tmHt7WE=;
        b=ffl2qb1+EjqRD+LDhi2lNKJOJFcFDYPGWh411tibO/vrJDpVP/BbcXqr7PA0fMh9YG
         sMl/pae5t/DsAcZgbTp66ojlXsaksIkffyQO13IQlqcBR9hTZVq61w0Wf/Z3NHh/8GRx
         5jKdaQEiKQveHnNlUsFSh1CLi8iTrxK6xKZoiz5c5ridaR6UpBzadYVoMrbvcr01OqMs
         +0xkbg24EjEPD1bAyDiyOaTBuN6VzwOIU0Ba7FGj9G98WLedggpfnh1HqzA8LTs+IJ8d
         WX0b0Qzk8UweUK/tR58RMgazrHIOh34bSt6bZaAplVmdrrB/eju2CX/l/TO0tlHrj9UJ
         vcLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9y/cX/LKtjaQzp4b6Rm1D3+gyyCmB4EMWjE7tmHt7WE=;
        b=DwkNTIP4AQ2b85CDfxumqLLo7SrLyVgvUpUJMF7cBLuFqAyGg4B/V9rH/3A/Yb9cyV
         iI1GtJHM2L2mh5VQkwHtuth2MSpgOvCJQUsu9AJ1YDCXOw56S/YLelQQ0nzq+0Kbr+Jl
         +Dpqhy48suhAwY1hxHDqeVtEVKzidxmGX4u5zzEJOsDGcW1Z4KPXCXB13VewrYYR9YAS
         Tlluz8vwaO8VzbvWhijA5K+0anfb4e7hhptR4QzbG9JfBvfwGYPryqOhyL1kXHmaKiLB
         nE3INXZ6Lrep5jZXgVBlEurmzoqq6NZKQjW7z6Zu2NLqBQtn/DBr9bGptjfXWNR71T1y
         4gkw==
X-Gm-Message-State: AOAM531sjRUfC+RZvyzY7Hztin8nmWE/I8DfhWw1ImiLHaRuQk24fovm
        gyx/gcV+7cTa/meQWn79Ycs=
X-Google-Smtp-Source: ABdhPJxom5Awt3VFu1T13vRzJNjljU2oF0RW/DFeinmCH0D1cK0lJdgAlHJ8aRIIndPTKROpABOK3g==
X-Received: by 2002:a37:9581:: with SMTP id x123mr6733613qkd.477.1629428433930;
        Thu, 19 Aug 2021 20:00:33 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id z12sm2043272qtw.90.2021.08.19.20.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 20:00:33 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <jing.yangyang@zte.com.cn>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] scsi/csiostor: fix application of sizeof to pointer
Date:   Thu, 19 Aug 2021 20:00:14 -0700
Message-Id: <4a643ef2fe8ed6fc8af9dcb878833cd5b0f254da.1629211553.git.jing.yangyang@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jing yangyang <jing.yangyang@zte.com.cn>

sizeof when applied to a pointer typed expression gives the size of
the pointer.

./drivers/scsi/csiostor/csio_mb.c:1554:46-52: ERROR application of sizeof to pointer

This issue was detected with the help of Coccinelle.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>
---
 drivers/scsi/csiostor/csio_mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index 94810b1..4df8a4d 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -1551,7 +1551,7 @@ enum fw_retval
 		 * Enqueue event to EventQ. Events processing happens
 		 * in Event worker thread context
 		 */
-		if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(mbp)))
+		if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(*mbp)))
 			CSIO_INC_STATS(hw, n_evt_drop);
 
 		return 0;
-- 
1.8.3.1


