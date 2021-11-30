Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C87C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbhK3Xh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:37:57 -0500
Received: from mail-pj1-f50.google.com ([209.85.216.50]:40896 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbhK3Xhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:37:55 -0500
Received: by mail-pj1-f50.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so19500576pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:34:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lk9NkVJVVSBBrCi1eWz7MQANLjx7ZaJC7Rk/B06iL8o=;
        b=cLmKHVTZpGGsujO5GLSYCyCfAT2og5hJcEsp39xeraC0cJWWj9PIAPxe+aEo/h7shO
         qPqTHQcH05ApFeMynvIVKttsdF5zqRWX7cmVs46di6tq38Ba/hCuPqmcw3dnut59XE6d
         C+TT14E2ZBDPPf0u3K6SHrFUd2ockr/6fFodTsxaQZLAtDbRycxPDSvY2w3kQG8jXBxw
         RO8/bI67k22RBosuosUJA3AAa+YsQg0VNGANjnDAyddKupyBMRiV8aYerhMujqmydBOY
         J77tIBuk8phHaCpoboLS49NTCX0DQQnVSmsXeChMC2Qxi9oGdqPBNf3RpOAhSUgFKIn1
         louQ==
X-Gm-Message-State: AOAM533o3dE32kgxQ0lRQ/R/SeeoOL7P1/4OhYLlyBqEhybuVQrriZ1I
        bOyYcqoA9Hzs0q/YCwUNOcw+BVOZ8wk=
X-Google-Smtp-Source: ABdhPJw1adiC17j/OXJIEfWAkA5DCFtaFZU5UQvo0Pya7eXpqBtc8XCQGaZ3u/vRZEFH1YjWc2Y3fA==
X-Received: by 2002:a17:90b:380a:: with SMTP id mq10mr2684005pjb.61.1638315274673;
        Tue, 30 Nov 2021 15:34:34 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:34:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 11/17] scsi: ufs: Remove the 'update_scaling' local variable
Date:   Tue, 30 Nov 2021 15:33:18 -0800
Message-Id: <20211130233324.1402448-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes the next patch in
this series easier to read.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index da4714aaa850..4e9755c060af 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5225,7 +5225,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	struct scsi_cmnd *cmd;
 	int result;
 	int index;
-	bool update_scaling = false;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
@@ -5243,18 +5242,16 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Do not touch lrbp after scsi done */
 			scsi_done(cmd);
 			ufshcd_release(hba);
-			update_scaling = true;
+			ufshcd_clk_scaling_update_busy(hba);
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			if (hba->dev_cmd.complete) {
 				ufshcd_add_command_trace(hba, index,
 							 UFS_DEV_COMP);
 				complete(hba->dev_cmd.complete);
-				update_scaling = true;
+				ufshcd_clk_scaling_update_busy(hba);
 			}
 		}
-		if (update_scaling)
-			ufshcd_clk_scaling_update_busy(hba);
 	}
 }
 
