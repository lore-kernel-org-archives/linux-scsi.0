Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC82C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 22:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjEaWlC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 18:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjEaWlC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 18:41:02 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62384124
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 15:40:57 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-530638a60e1so172939a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 15:40:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685572857; x=1688164857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ceI++dw7kQ2Z3x6UAADoqO1DyqIuOuSIZwCYDcEREw=;
        b=ibFYlXWuWAYMvQDdb8hRn93vJJnG+IhR1bLT+OM2Mis9uq0eKb6vK/qb4JL/lSi+Db
         W7AZdLYDj682dyFxoDbCT5QvhLFS0rNmo6apRIRXdrIoBrvsrSoFdYxovv8fbn5hFU9Y
         +xiwBYAC5oSOkG4jO05atcTUVx6KEbUQB5ua6rdOLMRoF4g7oY3fqYPdQIszdE/uskYS
         ZbJcv+r2GANBo63cb71gNKOKZoopKjfL+fbXo0tOJlmcLUNcMm9trYQAbJ0pee3zYmyu
         5TQgBQoksZxp0b9h7lKzsAYtYkwtOa87kjYLe0GvM7yDbJAxE/AHrdELvgqUJd/R4VuG
         eThw==
X-Gm-Message-State: AC+VfDz0muvoQX0VZaQFWwCaLW2Y/NbI761cQ1MrOIEjIGJYooC3YUvn
        aWrNb+TxVCt1TUbgA9BxWcY=
X-Google-Smtp-Source: ACHHUZ6EkfYvKYHFwDqTyX1c2qF2nC5jehvIdrYgYONQ6QJe4J+Lu7TP46TI9JWTz5qH08jIHSAW6Q==
X-Received: by 2002:a17:902:ab97:b0:1af:c7f8:b329 with SMTP id f23-20020a170902ab9700b001afc7f8b329mr6336474plr.24.1685572856762;
        Wed, 31 May 2023 15:40:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id c12-20020a170903234c00b001ab2592ed33sm1915306plh.171.2023.05.31.15.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 15:40:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: [PATCH] scsi: ufs: Remove a ufshcd_add_command_trace() call
Date:   Wed, 31 May 2023 15:40:47 -0700
Message-Id: <20230531224050.25554-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_add_command_trace() traces SCSI commands. Remove a
ufshcd_add_command_trace() call from a code path that is not related to
SCSI commands.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0856f01b761d..1f7a4ec211ff 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5400,7 +5400,6 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 		   lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 		if (hba->dev_cmd.complete) {
 			hba->dev_cmd.cqe = cqe;
-			ufshcd_add_command_trace(hba, task_tag, UFS_DEV_COMP);
 			complete(hba->dev_cmd.complete);
 			ufshcd_clk_scaling_update_busy(hba);
 		}
