Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2F8C10F27
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 00:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32D27206D7
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 00:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AO6bAbAZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgCHAQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Mar 2020 19:16:43 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37023 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgCHAQn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2020 19:16:43 -0500
Received: by mail-wm1-f67.google.com with SMTP id a141so6153071wme.2;
        Sat, 07 Mar 2020 16:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=puasjDo+SNd1oJ8PhfWyEtBcz6+kL7Tjj515kW76Htg=;
        b=AO6bAbAZ/E9SQqdSWWOjBJXmeQPGzR8LkWQOEMtFyk9YXLMBRIwKfR/nemqquc0QFY
         Ud52S9CUwSuUaMRCF4C6CKoveIl38pZMq7793vYfnY8xjmeUi99pbN9VDMf+zJxbdMV2
         RvfcOEXvLuxs5txv7XSI8svTC88hmvrHXo7bEU0/HcWFc15XkZot6Sl6TLanvrXWMNKZ
         mg+9wYAC/EMSObdyqgT9qb3C/gfkazQqYy62cWO30PoN1ToVuLaZ6xJ5IIqf0OkfFLtz
         j66l7QfG7VkhETdZBE65j0tnV0JkDb7pOwX0ul1sS5tg/MQ0pXLI3xtl87Zcsmjvh7B7
         jncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=puasjDo+SNd1oJ8PhfWyEtBcz6+kL7Tjj515kW76Htg=;
        b=A06n/nmtBI+S2qBzWDUZdPE5jrLk00ts8jfftB4Kh7JWz6lNv65MlOOTls0PzXaTat
         sJ0IKbpuF1MsUbtbZYzmb9AtRBBBSn6tSwYs4O9Cjtim6cMS+ROysy7obvdhwpOxms0o
         mSizLyR4E8NKLtEMyCmA+86t71aJYZVZi6IFoj9XJcjBreEZPS6pUYvaMX/fHdiQB/Xm
         M/LBfZiwR64W6cYp3wC/XHg0ocuG1jXmoLQArdCkFe7Z+IyRrEe/aeLpquM8kpGzLH9h
         kZGmedsE5tvAQeMX77faA9GAaNazDvO0ZbhShNsaWUUU6FtlG93FPK8/KWUx2yvccARq
         lOFA==
X-Gm-Message-State: ANhLgQ0Gx26SrvAwTusaget0V3+9RTg0k6+N6gz8xfUN20DNY/fN+Zkg
        6vxoYJN39EFg1EMHG5PK5Cg=
X-Google-Smtp-Source: ADFU+vv96/8c4o0klZfb/el4Lm4qyBb6ELZAxkre0tczVdlZXB3Oy6jIHhk7Y2ju9w16eAmQVwBy7g==
X-Received: by 2002:a1c:c906:: with SMTP id f6mr12065519wmb.16.1583626600925;
        Sat, 07 Mar 2020 16:16:40 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id i67sm32968308wri.50.2020.03.07.16.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 16:16:40 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
X-Google-Original-From: Bean Huo <beanhuo@micron.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [REF PATCH] scsi: ufs: fix lrbp pointer incorrect initialization issue
Date:   Sun,  8 Mar 2020 01:16:27 +0100
Message-Id: <20200308001627.19108-1-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The paramter cmd of ufshcd_init_cmd_priv() didn't take correct
tag value, this results in all pointers of lrbp points to first
the lrbp.
As this is just observed, this patch is for referecen so others
who want to use latest UFS driver can avoid this issue.

Fixes: 34656dda81ac ("scsi: ufs: Let the SCSI core allocate per-command UFS data")
---
 drivers/scsi/ufs/ufshcd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e987fa3a77c7..3ccf431e21b8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2471,6 +2471,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		BUG();
 	}
 
+	ufshcd_init_lrb(hba, lrbp, tag);
+
 	WARN_ON_ONCE(!ufshcd_is_scsi(cmd->request));
 
 	if (!down_read_trylock(&hba->clk_scaling_lock))
@@ -2713,6 +2715,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	hba->dev_cmd.complete = &wait;
 
+	ufshcd_init_lrb(hba, lrbp, tag);
+
 	ufshcd_add_query_upiu_trace(hba, tag, "query_send");
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
@@ -5900,6 +5904,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	init_completion(&wait);
 	lrbp = ufshcd_req_to_lrb(req);
+	ufshcd_init_lrb(hba, lrbp, tag);
 	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
-- 
2.17.1

