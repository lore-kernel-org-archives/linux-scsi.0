Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CAACD37B0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjIRQ0t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjIRQ0T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:26:19 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4181C23CDE
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:22:14 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1c3d8fb23d9so36559185ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:22:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695054100; x=1695658900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JzlqkJgudxivYIXs+IzQPdAZD4igib+RglO/avRHMBM=;
        b=cs6fHObstPwRC8WlBAs6XhgLYhRR3YqTa+f7My0TFnenxJ9tNWVmJtgMiJQGgXYc0r
         JPl6ircR45nUaiIfYGs6n5U7wXYevvuej0fHzT893ORplEacCteyOqwchRvXB1GPOxdR
         4MaquY7VDz6WRbyPqOxkNQEZLGMwE5qDMUdpwPpySLpJ9C/mtCnKHeuMh63am2lrH7pN
         fcMR7DRBzFY5L423Ygimg/vRXPcYnAtRxyaSO8h9KoLuK2R3wC0qySrRXLlSsG87zQKl
         nRyObFu1qg6AKNGdDNq41CneB5Ofn6ZnEyNC9S9xh1E9K7nlNf55iJORb4wld910NYA/
         FP6g==
X-Gm-Message-State: AOJu0YzIFj5Gh1kLtfe9p5z7mdkXvyvlDixezk3MbNCVbldOQ5Hmekx+
        150SZAlkRccjcjatuPH5oYI=
X-Google-Smtp-Source: AGHT+IG8DRZWuIiIjDmDqQ2lyTzrXqVie076wcPl/1FkVjfPrnZaZiSpfPLnDSN6SAbI59ZngwuTUA==
X-Received: by 2002:a17:902:d491:b0:1c3:e3b1:98df with SMTP id c17-20020a170902d49100b001c3e3b198dfmr10136949plg.52.1695054099719;
        Mon, 18 Sep 2023 09:21:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id z14-20020a170902d54e00b001bd28b9c3ddsm8489414plf.299.2023.09.18.09.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:21:39 -0700 (PDT)
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
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH 3/4] scsi: ufs: Simplify ufshcd_comp_scsi_upiu()
Date:   Mon, 18 Sep 2023 09:20:14 -0700
Message-ID: <20230918162058.1562033-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918162058.1562033-1-bvanassche@acm.org>
References: <20230918162058.1562033-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_comp_scsi_upiu() has one caller and that caller ensures that
lrbp->cmd != NULL. Hence leave out the lrbp->cmd check from
ufshcd_comp_scsi_upiu().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 100729981738..c69bf532c4ab 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2714,27 +2714,19 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
  *			   for SCSI Purposes
  * @hba: per adapter instance
  * @lrbp: pointer to local reference block
- *
- * Return: 0 upon success; < 0 upon failure.
  */
-static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	u8 upiu_flags;
-	int ret = 0;
 
 	if (hba->ufs_version <= ufshci_version(1, 1))
 		lrbp->command_type = UTP_CMD_TYPE_SCSI;
 	else
 		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
 
-	if (likely(lrbp->cmd)) {
-		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, lrbp->cmd->sc_data_direction, 0);
-		ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
-	} else {
-		ret = -EINVAL;
-	}
-
-	return ret;
+	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
+				    lrbp->cmd->sc_data_direction, 0);
+	ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
 }
 
 /**
