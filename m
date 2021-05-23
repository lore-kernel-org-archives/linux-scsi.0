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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E80C47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 21:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470E161166
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 21:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhEWVQA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 17:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbhEWVP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 17:15:56 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A42C06138A;
        Sun, 23 May 2021 14:14:26 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y7so12052940eda.2;
        Sun, 23 May 2021 14:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k3/TbwNFI9HmhMLl8iv6vlhOjkQhUhwgc45VnlZgXpQ=;
        b=W60V5nAxC/JJPeu1DW7gBrxEGdxhUWLNPrg2O2rkZl67RCJ+HvU0phYa7k5Sf8WOwW
         ilnq+zzKGrhTudnFETqltfNgqpXUcyrlbbjsqwhxbalkAr/EADGhzIo6Xe1os4/YoFzq
         xheCGLK5CWii2vcbJhX8nqOfpKQ6X+KjblXGJ6JoNAI9z5pK3cYo6qH8tA2Z3SfT8J19
         7L95w0AU63Auzu5u2vS8XV1r/Sw7dYukc7LNgJLzrL5aQJ6XZ1NBaZa7Y8kO8ITpuIaQ
         IOwC6A4yopMIenaE0bbqM4LUdS5p7FqJoRvMqaHc53KC8tg+8B5oLjYEKElqQUHufUnQ
         LkEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k3/TbwNFI9HmhMLl8iv6vlhOjkQhUhwgc45VnlZgXpQ=;
        b=gUHN6LsOU5Lb16yJQl7gLNw6IRnJZ7j8Pbqbt6HPp361PWFfZGZN6OCqhLuIiEZmWl
         2yybUbGV6zbhTKIRQ5vJi2P+x7cJD9VBX0Gq7XbYQtdtRGxPbcgkMlhDNvCe45svk31W
         fEg5HiEFF6IJUIlKLJyjdN2hFRaeLGSg3KDxiINhHaDygfHhB1b1qYBiS9jCJx/Fhy41
         9T41474YejYxHBpz01PCVH9E3ZdATVH58a6kiOfdXEccGqfxjQSvWkjMZCsnBEzgMLWW
         ZWLzX2rKflSTIXFYqjfAqqw0HOSFUJTo/5TkVlu/oCaz68Sblba3Nvcc7FWhl7e/gAai
         VQHw==
X-Gm-Message-State: AOAM533Vslh+mLUPlPGEB2sZafkoHnQRAwPDNU87OW3IMJsmhJCdocVt
        HshuoE4KvFL/NQ/Jatjoxys=
X-Google-Smtp-Source: ABdhPJzA4DXJYm8b5VzpVVtlpASJZhCgZcVxGeOxmgM1eUCgnntKC/ExCbE6z0LbIqxWqSS+6eKpvg==
X-Received: by 2002:a50:fd17:: with SMTP id i23mr22962801eds.54.1621804465083;
        Sun, 23 May 2021 14:14:25 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.gmail.com with ESMTPSA id t6sm2444ejd.123.2021.05.23.14.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 14:14:24 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/3] scsi: ufs: Use UPIU query trace in devman_upiu_cmd
Date:   Sun, 23 May 2021 23:14:09 +0200
Message-Id: <20210523211409.210304-4-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523211409.210304-1-huobean@gmail.com>
References: <20210523211409.210304-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Since devman_upiu_cmd is not COMMAND UPIU, and doesn't have
CDB, it is better to use UPIU query trace, which provides more
helpful information for issue shooting.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ed9059b3e63d..e8756a4fb972 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6697,6 +6697,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	hba->dev_cmd.complete = &wait;
 
+	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -6729,6 +6730,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		}
 	}
 
+	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
+				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
+
 out:
 	blk_put_request(req);
 out_unlock:
-- 
2.25.1

