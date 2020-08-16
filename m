Return-Path: <SRS0=wEW2=B2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807E2C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Aug 2020 07:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DDB20738
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Aug 2020 07:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AjDLUVVE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgHPHCv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Aug 2020 03:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbgHPHCt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Aug 2020 03:02:49 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7817BC061786;
        Sun, 16 Aug 2020 00:02:49 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id b2so6315525qvp.9;
        Sun, 16 Aug 2020 00:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DNuBQuYyy/AXTOZKEj0w60E3VxqxkDJyVdWryUqF7co=;
        b=AjDLUVVEvhLzGHIpwd8eN8LmNGftpaISCIyRkl7Ib2doJj485mDPjKO+UW/QIzy/BT
         tB4w0y0I6ob7ocjMaIxIyGOmEbo04tTt5rUtcRyHvWKjedz4QGNhXCpbc8hANtF9mCps
         PnW1LmxOo4quxEDLbC2CsYaqeW2inbrxxz3SpaznwWQ5MWk9aldLe3aqyA7jJTBRupaL
         7HAh43ieYB3PLLi34wSPC4DbvBo74vYSEd2Almu/LkZiMiovqiilCNEU5mPVpF595aBu
         T2CRgXXL12weS2EUVCgng6DPCZoqAYYZgusQ5jj1zJJWR/C8jUBHimKGsvPsNW6fCOmW
         AzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DNuBQuYyy/AXTOZKEj0w60E3VxqxkDJyVdWryUqF7co=;
        b=jPitHsAr2+zsz+w2tymAkJkW4j7hcC18qIkF9ievQkqByN23n2qPnuiJL69btQENxY
         mFcafbA2AuXkht3HcnWWdWD9oPXTHOoVbLFeIcdJKGXPi0EYXmBteW8DfIAN7PshoaOa
         ZEFdkQqI4Nipw7/iGMKt9tImvZHrlUSZq2SkpXDb6jtjsibKlm4D1cgK9HC6+dsrSPP7
         TiogzRTrCHj84E2yolnbGny5ek2gUOOTBZgXGoA1e7NObjn04EbKTBrp/GehRTx8Ykup
         kodp4soHSQVVBmBlex9BOMVmfy6kZy5ZIbzVKQJyDnJU5eP85Br43r+fE+KRntrOG9hA
         W26g==
X-Gm-Message-State: AOAM533II20wLoSgBsCMbq9f8b9Ruwiar97t2BvlgR9u0h0b7xGReSkf
        y01ICB9aRO1yKIhSGKeT/YbJQ69nnuwsnYlJ
X-Google-Smtp-Source: ABdhPJwFUWfpXq/DyHLBfaqe3LKnzT9Z0PUTX8oyXWksHGkrvoTsvvrQAoYDwKwMHGoFbVdi5WJZpA==
X-Received: by 2002:a0c:fdeb:: with SMTP id m11mr9659799qvu.103.1597561368097;
        Sun, 16 Aug 2020 00:02:48 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c100:b9d:4032:a79a:238d:9f7a])
        by smtp.googlemail.com with ESMTPSA id s184sm13737006qkf.50.2020.08.16.00.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 00:02:47 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.ibm.com, hare@suse.com
Cc:     ztong0001@gmail.com
Subject: [PATCH] scsi: aic7xxx: fix error code handling
Date:   Sun, 16 Aug 2020 03:02:42 -0400
Message-Id: <20200816070242.978839-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ahc_linux_queue_recovery_cmd returns SUCCESS(0x2002) or FAIL(0x2003),
but the caller is checking error case using !=0

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index e7ccb8b80fc1..7bba961d1ae0 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -730,7 +730,7 @@ ahc_linux_abort(struct scsi_cmnd *cmd)
 	int error;
 
 	error = ahc_linux_queue_recovery_cmd(cmd, SCB_ABORT);
-	if (error != 0)
+	if (error != SUCCESS)
 		printk("aic7xxx_abort returns 0x%x\n", error);
 	return (error);
 }
@@ -744,7 +744,7 @@ ahc_linux_dev_reset(struct scsi_cmnd *cmd)
 	int error;
 
 	error = ahc_linux_queue_recovery_cmd(cmd, SCB_DEVICE_RESET);
-	if (error != 0)
+	if (error != SUCCESS)
 		printk("aic7xxx_dev_reset returns 0x%x\n", error);
 	return (error);
 }
-- 
2.25.1

