Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D9FCD13DE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjIRQ0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjIRQ0S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:26:18 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63DB24457
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:22:22 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1c46b30a1ceso14839285ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695054115; x=1695658915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2TqlPkjwyXKr2IgdDGn6gtkPnsspM7borbVflhN6PYE=;
        b=AkKuf2qKAnWC7/MUMINu5aBQ1n8wEArtNc0Lp+2/eYzHvflKvFpeqAOlPvUYd1y1kw
         QaeXRGOLDOKH/RiQpT31dg+igXNmc6Z7mKZTSyMMG1Mv2gW++ec4HXnUSpwQIraJdFuu
         faT+6FctkTjZXf6fvNb/kIZ7Gk/QLqfoGyxwEkw3ZLgQfXFGweilvh01bQL4o/bJacR/
         7rxt/HzUHiKklCjZpNY23Xn6HIwvKot8vT6kKCzcRvUF/VoxS2V4tJ49mnq49DQ6PE7Q
         bFsYA3T8qt++KUTJACHvhbkDCs8VMr/PtsgekGlVDyFZC1qLbU+OeG6NEc4Fbe6imsRr
         mqzw==
X-Gm-Message-State: AOJu0Yx4yDs0F5R11RQwNlS9I8TvVSWLw0Y6ranQ0slci8mOfCfHKIQh
        5oCsqp6fme3/N7bOKi1yMAE=
X-Google-Smtp-Source: AGHT+IGykO8rgz3pzEAG9rNGtSQWPl96pMDMWwiFml4LSfIh6Z0qIXNKJRes0ANNk8hDjTqlX18PDA==
X-Received: by 2002:a17:902:d2d2:b0:1c4:bc8:4b64 with SMTP id n18-20020a170902d2d200b001c40bc84b64mr10464851plc.5.1695054114622;
        Mon, 18 Sep 2023 09:21:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id z14-20020a170902d54e00b001bd28b9c3ddsm8489414plf.299.2023.09.18.09.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:21:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 4/4] scsi: ufs: Set the Command Priority (CP) flag for RT requests
Date:   Mon, 18 Sep 2023 09:20:15 -0700
Message-ID: <20230918162058.1562033-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918162058.1562033-1-bvanassche@acm.org>
References: <20230918162058.1562033-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the UFS device execute realtime (RT) requests before other requests.
This will be used in Android to reduce the I/O latency of the foreground
app.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++++
 include/ufs/ufs.h         | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c69bf532c4ab..54c3811d5534 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2717,6 +2717,8 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
  */
 static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
+	struct request *rq = scsi_cmd_to_rq(lrbp->cmd);
+	unsigned int ioprio_class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	u8 upiu_flags;
 
 	if (hba->ufs_version <= ufshci_version(1, 1))
@@ -2726,6 +2728,8 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
 				    lrbp->cmd->sc_data_direction, 0);
+	if (ioprio_class == IOPRIO_CLASS_RT)
+		upiu_flags |= UPIU_CMD_FLAGS_CP;
 	ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
 }
 
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 0cced88f4531..e77ab1786856 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -98,9 +98,10 @@ enum upiu_response_transaction {
 	UPIU_TRANSACTION_REJECT_UPIU	= 0x3F,
 };
 
-/* UPIU Read/Write flags */
+/* UPIU Read/Write flags. See also table "UPIU Flags" in the UFS standard. */
 enum {
 	UPIU_CMD_FLAGS_NONE	= 0x00,
+	UPIU_CMD_FLAGS_CP	= 0x04,
 	UPIU_CMD_FLAGS_WRITE	= 0x20,
 	UPIU_CMD_FLAGS_READ	= 0x40,
 };
