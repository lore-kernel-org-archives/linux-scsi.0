Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB631C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D4486140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347150AbhI2WJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:32 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:42646 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347175AbhI2WJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:25 -0400
Received: by mail-pj1-f53.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so3150468pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h56QCgPf2uCu3KptNp50HCOmxx+b3YeaL9N0yvLZ6hw=;
        b=jHtjOEw4FGHfiiPODbCfembmCE9/7Xn9F6K+cRm0zOzkqyA6MgDP8E+sbhn8EHf8ou
         zAHYsSol+NVzdmm2g7b8p4C4oXnLczynMgc+NUO4zhdeMAN5TqzKdyIpUkSKPX4XViJD
         hxYC1zvmivt/Xr291eOzRc+NY4Fd+IH3kid+f63VvQP08UdmrnqtO5JFPptksSn8b7Rt
         WNS7n7Yl+Bhb/ElZLbwr+1JAoKpn0/7KfO1aLTG1FN/HsfqV4rVN8YANGkFfE3Ui1AVY
         gPuJE63t/Mxk38E/MdzN0+3n31QEu0dcN3F97VtfTAlg+vcTNcEpHCDHb7H4aDXC1srF
         PgxQ==
X-Gm-Message-State: AOAM533yo8DUaiS6/jlXYqnBK+zleMcOZE+03+RxtCX/vOU+KBMiCRbb
        m7A8mjuayKr2iIdnW6x78pQ=
X-Google-Smtp-Source: ABdhPJyG7yuPZRpF2Exh8xwDQ0X7pzvK+yRBmTDflsR4EjrExrD5E5IPpAEJBFYnlxpHx3Dlkee3+Q==
X-Received: by 2002:a17:90b:3b84:: with SMTP id pc4mr2389174pjb.220.1632953263787;
        Wed, 29 Sep 2021 15:07:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 55/84] myrs: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:31 -0700
Message-Id: <20210929220600.3509089-56-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 07f274afd7e5..2ffe3cadda66 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1595,14 +1595,14 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 
 	if (!scmd->device->hostdata) {
 		scmd->result = (DID_NO_CONNECT << 16);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 
 	switch (scmd->cmnd[0]) {
 	case REPORT_LUNS:
 		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0x0);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	case MODE_SENSE:
 		if (scmd->device->channel >= cs->ctlr_info->physchan_present) {
@@ -1616,7 +1616,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 				myrs_mode_sense(cs, scmd, ldev_info);
 				scmd->result = (DID_OK << 16);
 			}
-			scmd->scsi_done(scmd);
+			scsi_done(scmd);
 			return 0;
 		}
 		break;
@@ -1756,7 +1756,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 			if (WARN_ON(!hw_sgl)) {
 				scsi_dma_unmap(scmd);
 				scmd->result = (DID_ERROR << 16);
-				scmd->scsi_done(scmd);
+				scsi_done(scmd);
 				return 0;
 			}
 			hw_sgl->sge_addr = (u64)sg_dma_address(sgl);
@@ -2083,7 +2083,7 @@ static void myrs_handle_scsi(struct myrs_hba *cs, struct myrs_cmdblk *cmd_blk,
 		scmd->result = (DID_BAD_TARGET << 16);
 	else
 		scmd->result = (DID_OK << 16) | status;
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 }
 
 static void myrs_handle_cmdblk(struct myrs_hba *cs, struct myrs_cmdblk *cmd_blk)
