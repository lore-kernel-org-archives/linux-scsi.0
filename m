Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349FDC432C3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 11:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 080112073C
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 11:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rIgBPB5E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfLCLNs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 06:13:48 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35953 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfLCLNs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 06:13:48 -0500
Received: by mail-pl1-f195.google.com with SMTP id k20so1580923pls.3;
        Tue, 03 Dec 2019 03:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3OQmcTBUAZ2iXSh3JXM+wJ67H7N0YZcDSFL8pDk9sd4=;
        b=rIgBPB5E+yWkRwsoh+YtACXKnkcsu7iUF1xeunZZFUmes5SEdpGcBEZXP3mHl0Pvfg
         7SjYKW9VDHOXTA6u2BMNfOvbugLa8m6qnY/lUnwDhA+nys0DKbb8riaL+7/NLRvRaDBc
         whkjfAUXXlV+r+lKG10D5SsJ+H1D+t50nmm6wIIvx3EIJjzfi016qOrmSjjhnobK2/x2
         IpPKJgVbyzhGWP40aD8E29+jbM37nxAp7Bn4BUQs/2d7KM6Jkdq3ZvU0/7KEWsv5t+df
         f59UTRRbgQ3OSUuptCc1cVqbzyjE1fP3cETy2K8ubuu+izZHudybWaHuv+HLvpf46W3Z
         o5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3OQmcTBUAZ2iXSh3JXM+wJ67H7N0YZcDSFL8pDk9sd4=;
        b=V3LtvfTOQWD20+e8h6laCPh/89z5RtIRJPQtPwvqpQU6ycGXvZo5HiSvM9PrENRdVY
         5CW7n5PsX5J8QXkAI7D4knwgJlHcEMU1zKZYwRADSxLjDou1mSg7Zihw9+CzgxU80Wqt
         VvRSBWaVFHDXMWtxEdGURemXnMAkyTwtDGyf12iAczLg+/Sr91iko/S8FSA8enwKfV0p
         5sWrb9ZDOpD1/ZgnjDEpS3+Ny8hKx7lLSX0MX6q3JrGlc4kSQRze8/8MImUyCyLBxkgD
         gwqXxcFKAaUHFvrDXWVNjC75+RKE7yxepkQAWSamfcCQ19Il1J4VETeVmw6yGfEqLzmu
         7AbQ==
X-Gm-Message-State: APjAAAXwT3MO21PS1ngdrAsHKkS9RJmPlKChFNwqAwXdqyu4AjDYptlW
        cvozgwELQUzZHUyXDoiJ5Z/tLuTY1WA=
X-Google-Smtp-Source: APXvYqxCdytRvhloaoKigv0Gde6ma+4f3G42KTSjsjlSTKXDMZbt6w2BlEBLUog/7u88FW2IekSaow==
X-Received: by 2002:a17:902:9a8b:: with SMTP id w11mr4426590plp.9.1575371628072;
        Tue, 03 Dec 2019 03:13:48 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id g192sm3124849pgc.3.2019.12.03.03.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 03:13:47 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Don Brace <don.brace@microsemi.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH resend] scsi: smartpqi: add missed free_irq in suspend
Date:   Tue,  3 Dec 2019 19:13:37 +0800
Message-Id: <20191203111337.13054-1-hslester96@gmail.com>
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
index 7b7ef3acb504..2251c39afb1b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8078,6 +8078,8 @@ static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t stat
 	pqi_ctrl_wait_for_pending_io(ctrl_info, NO_TIMEOUT);
 	pqi_stop_heartbeat_timer(ctrl_info);
 
+	free_irq(pci_irq_vector(pci_dev, 0), &ctrl_info->queue_groups[0]);
+
 	if (state.event == PM_EVENT_FREEZE)
 		return 0;
 
-- 
2.24.0

