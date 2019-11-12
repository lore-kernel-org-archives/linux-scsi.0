Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CCCC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 22:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0791121A49
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 22:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4ihNSx/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfKLWf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 17:35:29 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56158 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKLWf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 17:35:29 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so4966660wmb.5;
        Tue, 12 Nov 2019 14:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LP3okD6bfEMVRR6gihLk+Rf09o9lY8LLHF8+yoRa1O8=;
        b=X4ihNSx/iLguwoZNGX305tcSfuS4Iu0XmAHzKTz0Q2Dm48Y+UfeV5iPL2DNJv0Cnmm
         LXSjNXEB8e/qFBsqiIp+pcpyibatJgaZr+KxcnOu2WKp6JthUYlnw6Slp7dAgPP7zqAe
         dIqoh0p/4TVzuEutcH1gwQFnTrA7mExHXIGou3kgrFy+BBnbyzbczijuwvk3Nxb9qcQt
         qP7SLAFWnJGspPwHUjgNevnOnq/9jmTpgq/aQUP0YBRscHEJUcwx0TnX0tpyG4EBBd2m
         afFBPUjtXNJNcLOufLI9PeCnlDzvekMujPeBhDYFYikKMVyz2U0QKFNddtBpq7FjVtW4
         bwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LP3okD6bfEMVRR6gihLk+Rf09o9lY8LLHF8+yoRa1O8=;
        b=JTA2NWR+Iz7Bzo7KsVTaqY5yjO38A/6z62VlpXDyVLkX0Y5m/LuNUVNTSqFBISLtM+
         XZIp+/C6/TcUCgPQjw+JFbcrWdEhTL+pzmn3yxme6Uf5zP338tcLz4A8RpquQ6+qWJ5+
         UcCcFRixqdLTXgq7B6Y5PagN+eoFIx8uB9ethT87OyVGs9hnDBoViuz48rteTFpxAkxK
         tl2W4ffEGjAgjBTVkIk5M+KavanGs/kU8jo0ZxPpq3EG9gt7PStKC2BdGnyD4Hr2FJaR
         fW8Ty/tJirzCdE71ehRlKEjQh0+e8VSug6bXbNPjl5hkVlay7G8VfMItEu0NhLiL1UPX
         dDUw==
X-Gm-Message-State: APjAAAVNoBVjoXN9LgaqC4NHrLYPaeJWQrs/tJrOdLP1vcwkBB7FZW1I
        wWBYBBphvADPa3SxMA8ZFDE=
X-Google-Smtp-Source: APXvYqy54vbv0xDEBEnteg1TauUpY1p+iKOTXfCKfEPhupLTeSMhFMf74nXJtpGH8NIkUMz59GAOGA==
X-Received: by 2002:a1c:984b:: with SMTP id a72mr6374780wme.78.1573598127171;
        Tue, 12 Nov 2019 14:35:27 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfdef.dynamic.kabel-deutschland.de. [95.91.253.239])
        by smtp.gmail.com with ESMTPSA id d20sm584356wra.4.2019.11.12.14.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 14:35:26 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: ufs: fix potential bug which ends in system hang-up
Date:   Tue, 12 Nov 2019 23:34:36 +0100
Message-Id: <20191112223436.27449-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112223436.27449-1-huobean@gmail.com>
References: <20191112223436.27449-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

In function __ufshcd_query_descriptor(), in the event of an error
happening, we directly goto out_unlock, and forget to invaliate
hba->dev_cmd.query.descriptor pointer. Thus results in this pointer
still validity in ufshcd_copy_query_response() for other query requests
which go through ufshcd_exec_raw_upiu_cmd(). This will cuases __memcpy()
crash and system hangs up, log shows as below:

Unable to handle kernel paging request at virtual address
ffff000012233c40
Mem abort info:
   ESR = 0x96000047
   Exception class = DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
Data abort info:
   ISV = 0, ISS = 0x00000047
   CM = 0, WnR = 1
swapper pgtable: 4k pages, 48-bit VAs, pgdp = 0000000028cc735c
[ffff000012233c40] pgd=00000000bffff003, pud=00000000bfffe003,
pmd=00000000ba8b8003, pte=0000000000000000
 Internal error: Oops: 96000047 [#2] PREEMPT SMP
 ...
 Call trace:
  __memcpy+0x74/0x180
  ufshcd_issue_devman_upiu_cmd+0x250/0x3c0
  ufshcd_exec_raw_upiu_cmd+0xfc/0x1a8
  ufs_bsg_request+0x178/0x3b0
  bsg_queue_rq+0xc0/0x118
  blk_mq_dispatch_rq_list+0xb0/0x538
  blk_mq_sched_dispatch_requests+0x18c/0x1d8
  __blk_mq_run_hw_queue+0xb4/0x118
  blk_mq_run_work_fn+0x28/0x38
  process_one_work+0x1ec/0x470
  worker_thread+0x48/0x458
  kthread+0x130/0x138
  ret_from_fork+0x10/0x1c
 Code: 540000ab a8c12027 a88120c7 a8c12027 (a88120c7)
 ---[ end trace 793e1eb5dff69f2d ]---
 note: kworker/0:2H[2054] exited with preempt_count 1

This patch is to move "descriptor = NULL" down to below
the label "out_unlock".

Fixes: d44a5f98bb49b2(ufs: query descriptor API)
Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 527bd3b4f834..977d0c6fef95 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2989,10 +2989,10 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 
-	hba->dev_cmd.query.descriptor = NULL;
 	*buf_len = be16_to_cpu(response->upiu_res.length);
 
 out_unlock:
+	hba->dev_cmd.query.descriptor = NULL;
 	mutex_unlock(&hba->dev_cmd.lock);
 out:
 	ufshcd_release(hba);
-- 
2.17.1

