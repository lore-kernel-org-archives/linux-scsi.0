Return-Path: <SRS0=IrwI=4Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55041C10F00
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Mar 2020 13:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26ECB206D5
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Mar 2020 13:21:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UkLBdsgf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgCGNVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Mar 2020 08:21:14 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46139 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgCGNVO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2020 08:21:14 -0500
Received: by mail-pg1-f196.google.com with SMTP id y30so2435448pga.13;
        Sat, 07 Mar 2020 05:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+4N5Moch/yrItYB3yVug7sPU1dP8keEtPUU51Od+Q5E=;
        b=UkLBdsgfk9BxVl/AWIqQjBMjlVkqnlU95/liM3kJP1nwT2xwQLbehv9T1PfZMbBgFs
         dW7ulLTLpe8HAoVhJLDhjo8TBVAGwZdNi16kqRj5VoozrOHOaIwwkVrAArFEkeKqjsJ+
         n49f+NcPxp14DnAIhJkL0JTV9oEOsJgp1/TAn9GTVot5VqzIinSSwYEaY8UsrpH1rdoI
         QBYfyGdTmlN4dYCoZcugUDliIKkKo9YudbKBQKe1gXKNO/bD3+s9qwXQ7bI+6LARBTd2
         jUojT+gx6Y14isGUiM2dUxw9ZgpWz/p1WjsZlR833p54rXMzeCpID+nV+CKVGEvHXMNY
         cUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+4N5Moch/yrItYB3yVug7sPU1dP8keEtPUU51Od+Q5E=;
        b=FV9Jt/6l62XfNIcdJC9b1ldqdxx88VrWkqfS9hJ3pjdcHalCUqvYNLP+T+SYHoQ3xC
         8HG/CYCTVahq/VsAd6Yt3fct0rtCnrWwLghmVydAPm+9G82tTji43wH/iG3DCyoozozp
         Us5zzZYOCbu+3FNVZGnz2d5rZRpllpvl7AgcqmUE3MjiLSUYEJpHLkCRhTDr1YQFJxsa
         TSfLpN53Bl+LdfiVjSO2XnBTV4f+Z6YEFuc6Mnn3vpoeMM+znqRwKAivJ/JFq+BjTP7c
         apjqUGSSBUeRwPzEO8dyCcsp/qJidQoHKKOCP904PK6uILigHuJD2tgC/TdVH9BKCf2O
         ++qQ==
X-Gm-Message-State: ANhLgQ3lRM/dqm7dHAoqoDvWGlGujMFNYHVTeGLxKGuDtUWo8A75nhCo
        UmjUtod+92QxVZKQL1tMBPU=
X-Google-Smtp-Source: ADFU+vubKHMNC6UrLGQt96l9uJLo1ejGpy3575HwHo/2Sqpi7F1ud1LHENw1jLaNssn6RnRz/3gJOw==
X-Received: by 2002:a63:67c5:: with SMTP id b188mr7889209pgc.111.1583587272756;
        Sat, 07 Mar 2020 05:21:12 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:4735:1319:cf26:e1d9:fc7c])
        by smtp.gmail.com with ESMTPSA id a143sm15241554pfd.108.2020.03.07.05.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 05:21:11 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH] scsi: aacraid: fix -Wcast-function-type
Date:   Sat,  7 Mar 2020 20:21:03 +0700
Message-Id: <20200307132103.4687-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

correct usage prototype of callback scsi_cmnd.scsi_done()
Report by: https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/scsi/aacraid/aachba.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 33dbc051bff9..92a1058df3f5 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -798,6 +798,11 @@ static int aac_probe_container_callback1(struct scsi_cmnd * scsicmd)
 	return 0;
 }
 
+static void  aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
+{
+	aac_probe_container_callback1(scsi_cmnd);
+}
+
 int aac_probe_container(struct aac_dev *dev, int cid)
 {
 	struct scsi_cmnd *scsicmd = kmalloc(sizeof(*scsicmd), GFP_KERNEL);
@@ -810,7 +815,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
 		return -ENOMEM;
 	}
 	scsicmd->list.next = NULL;
-	scsicmd->scsi_done = (void (*)(struct scsi_cmnd*))aac_probe_container_callback1;
+	scsicmd->scsi_done = (void (*)(struct scsi_cmnd *))aac_probe_container_scsi_done;
 
 	scsicmd->device = scsidev;
 	scsidev->sdev_state = 0;
-- 
2.20.1

