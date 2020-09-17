Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20817C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 19:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDD3120874
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 19:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mt9OJz/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgIQTRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 15:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbgIQQSX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 12:18:23 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0070AC061756
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2020 09:00:31 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id q12so1343874plr.12
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2020 09:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dL5bjsBTpI1WHY1Lul+C+ZXEBNZvu4AIQRGli0lUOx4=;
        b=mt9OJz/zcgF06uTcLmCvJqC8qMwbhFkudsZx0RItt2u4Ob+qc8sisFaFzs7LTpHzUq
         Lz/Y0ZIL25qKDWNeKPz3v96dDvnRySrz767m50CaxcHxh6zM4I++9vA06lge3EOMujDY
         7yFbNmb2A5UfCGvzfL9XW3WYKGyRegQ0piDyWgmB7Vhvuwdc8pZ4a8fKOa87E67QXgOQ
         p5882KV/axOpCDf/91KXDflwXE75rCx9miWnMkOsvCulckrGfYVZTOHftw2pHiL6Yg6p
         hMJPAgfqKscwpKx+mzUNzVbFAadDLBsqU22NuMmFvPfnYxprj8/J9sUfDxggbXQ/Rau0
         66NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dL5bjsBTpI1WHY1Lul+C+ZXEBNZvu4AIQRGli0lUOx4=;
        b=Fj8RQA6k4uumBX3kRw7nRyNlbUgYv5XNaTimYAo6/NNjwm4IqGKvAX4MQb2c6+vlXZ
         H6tYM7JHPkg6Vibp/8JSnnuD5IkAz/aCn1QYIHWkSRz3OrbmK5exXTD3lhcfRwRGhX5M
         j6JEYYyRzgH1qstD/4t8ktilQ5far6TdEPc/hmpSybQCD65sqgxGDuuhq5k6p9Z6qq5f
         VBFnAFXZqpIGqFllirVpBbyzZHES+3V05kaS/Zaw3hgRG4nJE8btI8INQktyAxoRioy7
         tWNsQWaHGjuYelZ7+M13RhVtYGskFaA02kfSW8Bds0F9Au9+1LBjGDGU4j7lCDUDO0w1
         iF/w==
X-Gm-Message-State: AOAM5322SnNg2yy7tp5kWDUjaAsPtXyAMZ+XdbvgGyPmj4SiTdxhDoTz
        OtNbCA22Pp6H0wG3fPs/EzDL8CVP9cYuAQ==
X-Google-Smtp-Source: ABdhPJwcuj0AmaWpE2pcCdWARsJi+GFNSXG5434TRGxLz09h5InR+K75RaoJGx1EYZdj9dCbSxC6bQ==
X-Received: by 2002:a17:902:d311:b029:d1:e598:3ff8 with SMTP id b17-20020a170902d311b02900d1e5983ff8mr11509473plc.50.1600358431116;
        Thu, 17 Sep 2020 09:00:31 -0700 (PDT)
Received: from localhost.localdomain ([161.81.44.186])
        by smtp.gmail.com with ESMTPSA id 137sm29897pfu.149.2020.09.17.09.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 09:00:30 -0700 (PDT)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 1/2] scsi: sg: use queue_logical_block_size() in max_sectors_bytes()
Date:   Fri, 18 Sep 2020 00:00:15 +0800
Message-Id: <20200917160016.2091-1-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Logical block size was never / is no longer necessarily 512.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 drivers/scsi/sg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 20472aaaf630..8a2cca71017f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -848,10 +848,11 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
 static int max_sectors_bytes(struct request_queue *q)
 {
 	unsigned int max_sectors = queue_max_sectors(q);
+	max_sectors *= queue_logical_block_size(q);
 
-	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
+	max_sectors = min_t(unsigned int, max_sectors, INT_MAX);
 
-	return max_sectors << 9;
+	return max_sectors;
 }
 
 static void
-- 
2.28.0

