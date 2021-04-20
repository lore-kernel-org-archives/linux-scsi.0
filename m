Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4193AC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1631F61107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbhDTCOz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:55 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:34392 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbhDTCOt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:49 -0400
Received: by mail-pj1-f42.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so509682pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Mj06gALYvu8ukWReAlIV+noMXfPcvG5xdlk3RJ8D0U=;
        b=Hs+smMKXHP9aQh7QtDNBt7CH+YPavhVd4LoNlcRPR6Z3pCtscwWt5BAebT6Q1IgHAY
         fy0VTthD9RpgvGoZ24EIYu+jcjwoN1GhNR6IUHpzw5H3taTBovVEMZtOM0hZdgabK8A6
         pRKDM2pTLeQBcGr/FAcWa5M1VHIOfPOnF9v+b/SY+IEsf01qNluGh4dVXsKnTcwuL/JR
         xG5xIkqZvi9M3QDVvHWJ0ri/ApvKzEDRh0Pvo9GQ3MiPsIfVi8Tii/gLy1ekyxYh793W
         Y26+tUsOlZ9WRDbcWdrdxwCaq6BgzhyasFJY4Y2vVlxNNEHt/VO9LnoKcgjA5Ewxojw7
         rX0g==
X-Gm-Message-State: AOAM533A37j0Bm5mmDIvD73elMQC/ns9RN9w4fFOn2y3kK/qcyLKVWe0
        kX1bUIh4ukC6+cEeey6igI0=
X-Google-Smtp-Source: ABdhPJyDP8a4qZYzXEFPfkRKb5YHVlNFEAP9gKDwtnjpXkp1HmXe6SimY39LUCLJ+UxR8n7tAtvS1g==
X-Received: by 2002:a17:90b:e8e:: with SMTP id fv14mr2126876pjb.5.1618884859202;
        Mon, 19 Apr 2021 19:14:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 099/117] ufs: Remove a local variable
Date:   Mon, 19 Apr 2021 19:13:44 -0700
Message-Id: <20210420021402.27678-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A later patch will introduce a type with the name 'scsi_status'. Remove
a local variable with the same name to prevent confusion. This patch
does not change any functionality.

Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fa596cf66c23..0c2c18f2acf3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4934,7 +4934,6 @@ static inline int
 ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	int result = 0;
-	int scsi_status;
 	int ocs;
 
 	/* overall command status of utrd */
@@ -4952,18 +4951,10 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
 		switch (result) {
 		case UPIU_TRANSACTION_RESPONSE:
-			/*
-			 * get the response UPIU result to extract
-			 * the SCSI command status
-			 */
-			result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
-
-			/*
-			 * get the result based on SCSI status response
-			 * to notify the SCSI midlayer of the command status
-			 */
-			scsi_status = result & MASK_SCSI_STATUS;
-			result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
+			/* Propagate the SCSI status to the SCSI midlayer. */
+			result = ufshcd_scsi_cmd_status(lrbp,
+				ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) &
+				MASK_SCSI_STATUS);
 
 			/*
 			 * Currently we are only supporting BKOPs exception
