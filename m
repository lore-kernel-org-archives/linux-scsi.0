Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E280C10F27
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 16:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB5EB2464B
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 16:11:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jjlu8YJy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgCIQLS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 12:11:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35466 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbgCIQLR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 12:11:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id m3so113506wmi.0;
        Mon, 09 Mar 2020 09:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Xun5inmSt0p8/3AqSHJwkgCG5OoazJFfQobHNuz3kAY=;
        b=Jjlu8YJyTqfdUdFXfoYZJeoOd0NJZ6KHvXfpqFClpBhlOPPA5CSC5X1C3PFtd5ANPR
         Qm8TBLIoNoosAZ1slMHvh0HAtiDTBJ72bxI++u+DAzOMVbx1FYY2rPY5voKLKylTyoK3
         oCkOVtrfF3hEv4dZFL9hnol34k85rVRCo8dkZgSfbYCpqFY5JjR9uOMT0W1CW7ywtJzC
         RcakjDqDnLl5ZBD+rxWzVeK6M7VSobm7R7Mayxtvq5pKGekQD6VQ6IyVxDDA/WbhhmVe
         i50+RolhUxZB0XOWgfG9YpF83T7RvoB6FSn1/xtNLTFL3Iek4pK6yyrZmLPdzcWJ7VjQ
         Cajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Xun5inmSt0p8/3AqSHJwkgCG5OoazJFfQobHNuz3kAY=;
        b=LXK5XmucPcPbuF2pwrNAkNOOvDfBubuyIBrn41r+9QTG91EifTsvjyzhku+4wVXan8
         MTenv7t2zIO7d3lJlr1coBsYZMBdiidqR1nQqQUKCVElxZT7t40G2yZ3DhHibiVCTYL6
         /PSTHtqM0/dp2emGj2UGOAvJz6dwfP6LsV5Q8v444xx8ovLRdojck33U7pwtK0HhQY+r
         kvHw3RVVJDkWkUwHaUqJmB0VdyzRtKH3pbYepk54oS3o+gNdxEQLU9t99O/ztGyC24uB
         i+/Se1enxnxPPddKnrW9V/EfGKdu35Dj7mnclfEWw9kpiDlkMNJN/NvwW4ysdFgdVo1p
         U+OA==
X-Gm-Message-State: ANhLgQ037jQ3hwY6nj42We2udaetYM8bDkCktPrpiVH9EzzugVyBJ8N/
        KyYs29Na/ep5nZz++aG2uSI=
X-Google-Smtp-Source: ADFU+vus+HoTa9bUQCpqaYb5BvtifqGEuUA/zX2pe3bNXXliTpzv3Rra2aycdm+orpXIdHaZWWv1Ig==
X-Received: by 2002:a1c:25c1:: with SMTP id l184mr55026wml.122.1583770275271;
        Mon, 09 Mar 2020 09:11:15 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id s14sm50104932wrv.44.2020.03.09.09.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 09:11:14 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/1] scsi: ufs: fix LRB pointer incorrect initialization issue
Date:   Mon,  9 Mar 2020 17:10:57 +0100
Message-Id: <20200309161057.9897-2-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200309161057.9897-1-beanhuo@micron.com>
References: <20200309161057.9897-1-beanhuo@micron.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

There are two issues with the ufshcd_init_lrb() call in
ufshcd_init_cmd_priv():

- cmd->tag is set from inside scsi_mq_prep_fn() and hence is not yet set
  when ufshcd_init_cmd_priv() is set.
- Inside ufshcd_init_cmd_priv() the tag can only be derived from the SCSI
  command pointer if no scheduler has been associated with the UFS block
  device. If no scheduler is associated with a block device, the
  relationship between hctx->tags->static_rqs[] and rq->tag is static.
  If a scheduler has been configured, a single tag can be associated
  with a different struct request if a request is reallocated.

Fixes: 34656dda81ac ("ufs: Let the SCSI core allocate per-command UFS data")

v2-v3:
    - delete ufshcd_init_cmd_priv()
    - change commit message

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e987fa3a77c7..dfb44e8cc9dd 100644
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
@@ -3504,14 +3507,6 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 	}
 }
 
-static int ufshcd_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
-{
-	struct ufs_hba *hba = shost_priv(shost);
-
-	ufshcd_init_lrb(hba, scsi_cmd_priv(cmd), cmd->tag);
-	return 0;
-}
-
 /**
  * ufshcd_dme_link_startup - Notify Unipro to perform link startup
  * @hba: per adapter instance
@@ -4834,6 +4829,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			continue;
 		cmd = blk_mq_rq_to_pdu(req);
 		lrbp = scsi_cmd_priv(cmd);
+		ufshcd_init_lrb(hba, lrbp, index);
 		if (ufshcd_is_scsi(req)) {
 			ufshcd_add_command_trace(hba, req, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
@@ -5900,6 +5896,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	init_completion(&wait);
 	lrbp = ufshcd_req_to_lrb(req);
+	ufshcd_init_lrb(hba, lrbp, tag);
 	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
@@ -7180,7 +7177,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
-	.init_cmd_priv		= ufshcd_init_cmd_priv,
 	.queuecommand		= ufshcd_queuecommand,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_configure	= ufshcd_slave_configure,
-- 
2.17.1

