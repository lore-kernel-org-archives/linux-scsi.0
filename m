Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE03C43600
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F34613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhDTAK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:27 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:33774 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbhDTAKN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:13 -0400
Received: by mail-pj1-f42.google.com with SMTP id kb13-20020a17090ae7cdb02901503d67f0beso397725pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6i3dul2nqK3b2IAOlko0yNKzep22prs4WbyldnpEDUU=;
        b=dYXeN7fEx0sDiXkR51MDHtCzgc17Ag1JVG1RYaVXNjKD9rdWVVH3s2K/QkGFtmJOqS
         RfvSv0/cGWq/T+/h3IsaAdqBQ5YqXR2IVYx/dlYgGJsfuBXvxYfvosGJcSZ6H2xzu4Vf
         kI5LLKdWxJ6NBy7xoqZZRUsTdnUbSoV06sdlsG21bd12dLLqlVoseVsAV5jm10nVvCN9
         W54r3h6+7nVt0HwPLyGPwVqhxTqhfk3J/SHLaHEhs/tl4dEWN78S/IoJb5AtZDZ42xv3
         75a9W2Fnsz11WKyriO8gkVo9CvsmBXyUTV7YfLs+IPcrRJCJSAP3FHGEaMRZ2+TBMRU7
         gozw==
X-Gm-Message-State: AOAM531RRcfR3uqIQEPK8m2CqGFYtoY2zr2B7UBZqHi3ulWSFptqXFFG
        H1TgIzolGgKi8WT08m7X7rR1FbwEodXgMw==
X-Google-Smtp-Source: ABdhPJxJ7kKtcNN8tTSOHKAMe0MXA6sSUBVbeV+Ki7aPjdXWklOUoOnrcrMattIYHpnJ8ItPttg5HQ==
X-Received: by 2002:a17:902:7795:b029:ec:b1ca:de75 with SMTP id o21-20020a1709027795b02900ecb1cade75mr3468572pll.70.1618877381912;
        Mon, 19 Apr 2021 17:09:41 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>
Subject: [PATCH 043/117] esas2r: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:31 -0700
Message-Id: <20210420000845.25873-44-bvanassche@acm.org>
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

Cc: Bradley Grove <linuxdrivers@attotech.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/esas2r/esas2r.h      |  2 +-
 drivers/scsi/esas2r/esas2r_main.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index ed63f7a9ea54..3823ec7909c4 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -1010,7 +1010,7 @@ void esas2r_complete_request_cb(struct esas2r_adapter *a,
 void esas2r_reset_detected(struct esas2r_adapter *a);
 void esas2r_target_state_changed(struct esas2r_adapter *ha, u16 targ_id,
 				 u8 state);
-int esas2r_req_status_to_error(u8 req_stat);
+enum host_status esas2r_req_status_to_error(u8 req_stat);
 void esas2r_kill_adapter(int i);
 void esas2r_free_request(struct esas2r_adapter *a, struct esas2r_request *rq);
 struct esas2r_request *esas2r_alloc_request(struct esas2r_adapter *a);
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index a9dd6345f064..0967bfc751cc 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -824,10 +824,10 @@ int esas2r_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	unsigned bufflen;
 
 	/* Assume success, if it fails we will fix the result later. */
-	cmd->result = DID_OK << 16;
+	cmd->status.combined = DID_OK << 16;
 
 	if (unlikely(test_bit(AF_DEGRADED_MODE, &a->flags))) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		cmd->scsi_done(cmd);
 		return 0;
 	}
@@ -984,7 +984,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 	esas2r_log(ESAS2R_LOG_INFO, "eh_abort (%p)", cmd);
 
 	if (test_bit(AF_DEGRADED_MODE, &a->flags)) {
-		cmd->result = DID_ABORT << 16;
+		cmd->status.combined = DID_ABORT << 16;
 
 		scsi_set_resid(cmd, 0);
 
@@ -1050,7 +1050,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 	 * freed it, or we didn't find it at all.  Either way, success!
 	 */
 
-	cmd->result = DID_ABORT << 16;
+	cmd->status.combined = DID_ABORT << 16;
 
 	scsi_set_resid(cmd, 0);
 
@@ -1523,7 +1523,7 @@ void esas2r_complete_request_cb(struct esas2r_adapter *a,
 			     rq->func_rsp.scsi_rsp.scsi_stat,
 			     rq->cmd);
 
-		rq->cmd->result =
+		rq->cmd->status.combined =
 			((esas2r_req_status_to_error(rq->req_stat) << 16)
 			 | (rq->func_rsp.scsi_rsp.scsi_stat & STATUS_MASK));
 
@@ -1873,7 +1873,7 @@ void esas2r_target_state_changed(struct esas2r_adapter *a, u16 targ_id,
 }
 
 /* Translate status to a Linux SCSI mid-layer error code */
-int esas2r_req_status_to_error(u8 req_stat)
+enum host_status esas2r_req_status_to_error(u8 req_stat)
 {
 	switch (req_stat) {
 	case RS_OVERRUN:
