Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76585C2D0C3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53528206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfLXWDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 17:03:01 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39484 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfLXWDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 17:03:00 -0500
Received: by mail-pf1-f196.google.com with SMTP id q10so11274779pfs.6
        for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2019 14:03:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hQd1tOwJd5b/3b/xi+/bMgKM+Vqh+/hV2XfCiAlxcIk=;
        b=nHIp9yLKouuZ6h5Y/fKN6hUW4SrSwgjEzn6HSpVqAHIIusR7geYfnti/znS532xZZy
         kFUR/JvK6VhnD8wtBgRI+nooqrxz2cMfoXLemfC8QkHxKRZb9MAg6HAgIbcYg837dWES
         ZtF5Gk3pvJ9VuI9rgCyV7TacprxfOTvRNaBtt1WObDDoHTl+WLsA4LeitcYYJ3NdcceV
         FH9v7VJZCKW3xGSfL1nr/UxfF/EUzi18bSknRroDw2x7MgCvl9OYm8ctroAEzpTCBZNH
         xQIXc72OXFqp9FVImi3i3s5becNuQFYRqp+/kq+R3AU8+k/p01/Kr184AgsVeskqgwZl
         CQyw==
X-Gm-Message-State: APjAAAU6S4VWmPzHBV+5QHuZoLnBPCobfcNE2GQz8w/VC4Go0s6Jz7xD
        Pi740JTv0A3qayaMhdX6GlA=
X-Google-Smtp-Source: APXvYqwh2+tDgi9oQUOprdIJF0a30cfe4OxZxoQLW+Q7SVXz3MKF2K64zx8kZ7ccyeGlKAFyx6t5uw==
X-Received: by 2002:aa7:8699:: with SMTP id d25mr39818390pfo.139.1577224980253;
        Tue, 24 Dec 2019 14:03:00 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:1206:80fd:a97:a7d:f0c8])
        by smtp.gmail.com with ESMTPSA id m15sm26839779pgi.91.2019.12.24.14.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 14:02:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/6] ufs: Make ufshcd_prepare_utp_scsi_cmd_upiu() easier to read
Date:   Tue, 24 Dec 2019 14:02:45 -0800
Message-Id: <20191224220248.30138-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191224220248.30138-1-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the lrbp->cmd expression occurs multiple times, introduce a new
local variable to hold that pointer. This patch does not change any
functionality.

Cc: Bean Huo <beanhuo@micron.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index acc84e964e8f..80b028ba39e9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2233,6 +2233,7 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 static
 void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
 {
+	struct scsi_cmnd *cmd = lrbp->cmd;
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
 	unsigned short cdb_len;
 
@@ -2246,12 +2247,11 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
 	/* Total EHS length and Data segment length will be zero */
 	ucd_req_ptr->header.dword_2 = 0;
 
-	ucd_req_ptr->sc.exp_data_transfer_len =
-		cpu_to_be32(lrbp->cmd->sdb.length);
+	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);
 
-	cdb_len = min_t(unsigned short, lrbp->cmd->cmd_len, UFS_CDB_SIZE);
+	cdb_len = min_t(unsigned short, cmd->cmd_len, UFS_CDB_SIZE);
 	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
-	memcpy(ucd_req_ptr->sc.cdb, lrbp->cmd->cmnd, cdb_len);
+	memcpy(ucd_req_ptr->sc.cdb, cmd->cmnd, cdb_len);
 
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
 }
