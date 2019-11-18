Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C733EC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 02:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FBDF206D4
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 02:48:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZAHb2RK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfKRCs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 21:48:26 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46707 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfKRCs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Nov 2019 21:48:26 -0500
Received: by mail-pg1-f196.google.com with SMTP id r18so8846341pgu.13;
        Sun, 17 Nov 2019 18:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LJN39JvnBb2Ux5j3Tg40TBNH2WUxnDoGsfa7IupBTVI=;
        b=ZAHb2RK9q+W6dB+/aNWg/9K49ic9zZD1IlGvjYHAq5rPESRF9FBvit+YKlhWUIPTYu
         4mwxvn2yykpSn5B1vZIOzWZzvgnk4+dAv2Op8pZCbcQy2JkxzBVL1Y4x5glh/Ly2LaYr
         E1AdMp6XESISya5DKuR8DgFPqq57nwqtLt0fim7WKJF8xmgA+NC/dC53QcnnWiK1m0IN
         D7agbyVSsFvpJVxVxUikMYQz40FCPzrvA2PSJZO5NSSa5/s7xn+ASD62a6wgNb+EvOoY
         6OXbKodt4ujIQlwkpfXBQsALoO92ddIYwpscGVN9PRnJ93bvhCGk29rdJswTdlYmKg/6
         7zLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LJN39JvnBb2Ux5j3Tg40TBNH2WUxnDoGsfa7IupBTVI=;
        b=pGPZ5M4mCOtffqyGENDoT5nPWldDMC68b3V2nHnt6FVUB34aW8MxQZayLj4TeZ04Yv
         zLJXL8hPrBetmFCxLdrbiApuHc6fd8UxWFifNgO9krBqbXWtMj9tGZ/8R1VAzjDSjEeI
         tdPKfSeaQlYxWpRk2GwCFf+O5KEIe/KarPlpNHDBksIdapyZsgF0uxmnnFUd7YuEJqcX
         hmUKBZCR6rkDRzWzajVpB+Fv64gherGQuwjHC//jcLRRzQfVxxyr9Djm4WXw1pRT7okJ
         88NCW12bqkxgt6ZqLvM6ayO+F5YORKfAJ0XBrSX3VcJskmyJ/AjeyYAFywlOX8l4N+xv
         4PVg==
X-Gm-Message-State: APjAAAXcG5bv72xMPAtiTEBVDiUEulFNTPOAS2NbF9RnGa8ugF4txlPV
        61qlZTN5ZMWm7YbsZ9trrKw=
X-Google-Smtp-Source: APXvYqxPWcFo6G0pp+6Un/9vYsChZ6XnP5zORNI+ij00omFSTq9HSpZcokYHpOLbZwUJF5JIWIH/Fg==
X-Received: by 2002:a62:e716:: with SMTP id s22mr31429246pfh.258.1574045306003;
        Sun, 17 Nov 2019 18:48:26 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id j5sm19018009pfe.100.2019.11.17.18.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Nov 2019 18:48:25 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Don Brace <don.brace@microsemi.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] scsi: smartpqi: add missed free_irq in suspend
Date:   Mon, 18 Nov 2019 10:48:15 +0800
Message-Id: <20191118024815.21524-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls request_irq in resume but does not call free_irq in
suspend.
Add the missed call to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ea5409bebf57..ebe563cfc36b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8023,6 +8023,8 @@ static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t stat
 	pqi_ctrl_wait_for_pending_io(ctrl_info, NO_TIMEOUT);
 	pqi_stop_heartbeat_timer(ctrl_info);
 
+	free_irq(pci_irq_vector(pci_dev, 0), &ctrl_info->queue_groups[0]);
+
 	if (state.event == PM_EVENT_FREEZE)
 		return 0;
 
-- 
2.24.0

