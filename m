Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299D4C10DCE
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 14:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 041632084E
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 14:57:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kknT1sfY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgCHO5D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Mar 2020 10:57:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38993 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgCHO5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2020 10:57:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id r15so2862277wrx.6;
        Sun, 08 Mar 2020 07:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xqq/vTA6tykG9TBsibOSbNfU3tQWQjZeskxxd3r+KGk=;
        b=kknT1sfYhxatk4+aYjEDlmxZFat7D0LGJrDPKdkJ2XZQhUJlcLb2+O0wLS6c6uSvtU
         ZvEZr05n1OGGgaAu5hsul46MmI/0s109RcUnwUPagpIrtEZRjOUnao9bpm7CkrOoutwI
         U2Uj35qFvUK1wjxD2d5WmfMbCm5gtirNhd7Xb6fnUMJeotBVSRUFuUWQQzW5EC5P8jN3
         R35DHiMj4AYH26ZVeg9a/fWci4qtO58qUoyqsg+S92gsyW5BPbKN2tM0JCwzth06RMdC
         2si2OhY9n0Tm88HUb/es34O99tDk82zXB10hXwYKycd4+8MOh0s4dDI2iXvYRfOhslHT
         Rnrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xqq/vTA6tykG9TBsibOSbNfU3tQWQjZeskxxd3r+KGk=;
        b=im8YlYBLC/QKX2RYp2lf6/50GoLp++IV95V+sDMT7/yDqdSUusR3yFErHdlSreFwXj
         Q4vzrGOaut06ZlR5XN++XRtvq48UGmyDOv+ZtuzZRezGu+lbzO4cJORERwYaHnlC7gIG
         NAQf+sL/mvnavF+tARzN1sy3hgJSAuRB64DXe/a3FJ6zrNBaOrUgezDD5rzm6H8VLz2G
         LnqoI46UaNZE2Y+9B8MVG/K5cq2PfiTjpxSMbuYa+01w9aGrf5j1fERrDGaRG9Iuvfj5
         U8MSzCe1VzoUT8QHsGICkIM3JRZUXvWTyzDPRNl7wgLb80HdJhwyUCvt0Iv+m9Wxjh4H
         mfRg==
X-Gm-Message-State: ANhLgQ3g1hx7fFXQE3BmpMdcq/2K81XZN5bwUeMsxZ8KLpPv0QNdJJQO
        /VFW1z//NoHnPQNkBi9gJH4=
X-Google-Smtp-Source: ADFU+vv4nH113SbuU37i/x3vm5eNBQFXQaQO0XHCy5zsa2i6nCgyU79hmPYcPoCYUsVn3T13A8gsNg==
X-Received: by 2002:a5d:6086:: with SMTP id w6mr15265449wrt.224.1583679420092;
        Sun, 08 Mar 2020 07:57:00 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id 61sm7383232wrd.58.2020.03.08.07.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2020 07:56:59 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
X-Google-Original-From: Bean Huo <beanhuo@micron.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 1/1] scsi: ufs: fix lrbp pointer incorrect initialization issue
Date:   Sun,  8 Mar 2020 15:56:48 +0100
Message-Id: <20200308145648.28675-2-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200308145648.28675-1-beanhuo@micron.com>
References: <20200308145648.28675-1-beanhuo@micron.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The parameter cmd of ufshcd_init_cmd_priv() wasn't given a correct tag
value while the SCSI layer calls back ufshcd_init_cmd_priv(), this results
in all pointers of lrbp in UFS driver point to first the lrbp.

As this is just observed, the patch is for reference so others
who want to use the latest UFS driver can avoid this issue. Any recommend
is welcomed.

Fixes: 34656dda81ac ("scsi: ufs: Let the SCSI core allocate per-command UFS data")
---
 drivers/scsi/ufs/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e987fa3a77c7..396512a9234f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2471,6 +2471,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		BUG();
 	}
 
+	ufshcd_init_lrb(hba, lrbp, tag);
+
 	WARN_ON_ONCE(!ufshcd_is_scsi(cmd->request));
 
 	if (!down_read_trylock(&hba->clk_scaling_lock))
@@ -2707,6 +2709,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	init_completion(&wait);
 	lrbp = ufshcd_req_to_lrb(req);
+	ufshcd_init_lrb(hba, lrbp, tag);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
 	if (unlikely(err))
 		goto out_put_tag;
@@ -5900,6 +5903,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	init_completion(&wait);
 	lrbp = ufshcd_req_to_lrb(req);
+	ufshcd_init_lrb(hba, lrbp, tag);
 	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
-- 
2.17.1

