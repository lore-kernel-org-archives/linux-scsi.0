Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDCCC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF23613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhDTAK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:58 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:40935 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbhDTAKm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:42 -0400
Received: by mail-pl1-f182.google.com with SMTP id 20so14724219pll.7
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vQtfbEqwvZ8pTEbd3UWaphlrD+FFD1Z3NGjpzfK5gAo=;
        b=Na4yCFzqc6K/3SpWetIuv1ZcmdEweO4EyTdik+e/I0lCBCfvd8OmbS0VGptsZgS6fI
         ipbm4YPXb9fq5/8YjBNjQyoW1t7s3CukN2rFXt2RtwXcr5zro2NbFdc9lhmfHgNq827K
         a9DO63BS7PPO2UYJL8eDYCxpwaS1B35eZYP5Q5DYSoCaZ37UmTLVSlJmzoWcit2OISsL
         MSn/59xx09zZHKLpuoWF5TPX2j2Pab5IT1lgbT+tBkhmQUaf/LZurU3EFR6Qs6tm1BQb
         0Jk8Rn0W0MMv24TO2mwWh3fSsVx4G4HM02ro7Vw8BYe+MIlD6GeQct420RCXWhGqRFTb
         DK1A==
X-Gm-Message-State: AOAM532/MYPLkYIxqu2FJPlmncm66c/G2b0RgqYclm44Il8R5nu2OBk6
        fi3uSqR2LjKExmS3IPTFSnQ=
X-Google-Smtp-Source: ABdhPJxt5NTH46PwYBILk5G3YsenQYmFOlfy109Fq4cJK/esVjZQo3Yj7+j9wbhHX57SCVElGtX0Vg==
X-Received: by 2002:a17:903:304b:b029:eb:4cf:8321 with SMTP id u11-20020a170903304bb02900eb04cf8321mr25975897pla.40.1618877410212;
        Mon, 19 Apr 2021 17:10:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 068/117] mesh: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:56 -0700
Message-Id: <20210420000845.25873-69-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mesh.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 0a9f4e44ab2c..1d01913cac55 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -595,12 +595,12 @@ static void mesh_done(struct mesh_state *ms, int start_next)
 	ms->current_req = NULL;
 	tp->current_req = NULL;
 	if (cmd) {
-		cmd->result = (ms->stat << 16) | cmd->SCp.Status;
+		cmd->status.combined = (ms->stat << 16) | cmd->SCp.Status;
 		if (ms->stat == DID_OK)
-			cmd->result |= cmd->SCp.Message << 8;
+			cmd->status.combined |= cmd->SCp.Message << 8;
 		if (DEBUG_TARGET(cmd)) {
 			printk(KERN_DEBUG "mesh_done: result = %x, data_ptr=%d, buflen=%d\n",
-			       cmd->result, ms->data_ptr, scsi_bufflen(cmd));
+			       cmd->status.combined, ms->data_ptr, scsi_bufflen(cmd));
 #if 0
 			/* needs to use sg? */
 			if ((cmd->cmnd[0] == 0 || cmd->cmnd[0] == 0x12 || cmd->cmnd[0] == 3)
@@ -993,7 +993,7 @@ static void handle_reset(struct mesh_state *ms)
 	for (tgt = 0; tgt < 8; ++tgt) {
 		tp = &ms->tgts[tgt];
 		if ((cmd = tp->current_req) != NULL) {
-			cmd->result = DID_RESET << 16;
+			cmd->status.combined = DID_RESET << 16;
 			tp->current_req = NULL;
 			mesh_completed(ms, cmd);
 		}
@@ -1003,7 +1003,7 @@ static void handle_reset(struct mesh_state *ms)
 	ms->current_req = NULL;
 	while ((cmd = ms->request_q) != NULL) {
 		ms->request_q = (struct scsi_cmnd *) cmd->host_scribble;
-		cmd->result = DID_RESET << 16;
+		cmd->status.combined = DID_RESET << 16;
 		mesh_completed(ms, cmd);
 	}
 	ms->phase = idle;
