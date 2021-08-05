Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C4AC4320E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17D446112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242913AbhHETT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:27 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:46021 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242914AbhHETTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:20 -0400
Received: by mail-pj1-f46.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso11947668pjf.4
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z9le2znCFiWxH/qpKzW0BBcMGqfV1LOmADjtvCBfw3k=;
        b=CgPhQNusz3hprWzn3tua+FTGy8UujQoalyViFvVwy89STIp4eBsVD8CkuQtRyKFc0U
         8+JsLRnktSlahpwKn/smGoOfzzklGinwXU+Fii1VgAts858rbsi7wE9m+/PVgc6+paZk
         OgUbN2VqD4EvjHVSAc2udUKwLz4nFY1Wd4Q42YIZnVtx6/0eZNWYn5C6VEyYzeLf7DHb
         92uU4VvTiAl7lyJV30jlEkrCEGtDVh+eMo7osp+cKapAw4SmeKsbaGZMC9j8MyMJwMc+
         8EtNhWaZcU27i8WjsiRXB+vUgPN5xpPTZglXkNN6yf0/gAY0hptcnNPIYwXngEgKBni7
         JR/Q==
X-Gm-Message-State: AOAM532Q6YPpwMPm72VvGgIALKgT2k88FiRDN54MdgGLkcL4wC920d+r
        s5e8zZl022J6wgbY3ngwH7Y=
X-Google-Smtp-Source: ABdhPJzJBLlMmITfAQzKsgUTX0hrAdod2jF5vl8VHZYPP6DCln8asw1qsmWMvdPJ+k0T1/xqIuQM6g==
X-Received: by 2002:a17:90b:a54:: with SMTP id gw20mr6159119pjb.215.1628191142346;
        Thu, 05 Aug 2021 12:19:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 15/52] aha1542: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:51 -0700
Message-Id: <20210805191828.3559897-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha1542.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 1210e61afb18..584a59522038 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -262,11 +262,12 @@ static void aha1542_free_cmd(struct scsi_cmnd *cmd)
 	struct aha1542_cmd *acmd = scsi_cmd_priv(cmd);
 
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		struct request *rq = scsi_cmd_to_rq(cmd);
 		void *buf = acmd->data_buffer;
 		struct req_iterator iter;
 		struct bio_vec bv;
 
-		rq_for_each_segment(bv, cmd->request, iter) {
+		rq_for_each_segment(bv, rq, iter) {
 			memcpy_to_page(bv.bv_page, bv.bv_offset, buf,
 				       bv.bv_len);
 			buf += bv.bv_len;
@@ -447,11 +448,12 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 #endif
 
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		struct request *rq = scsi_cmd_to_rq(cmd);
 		void *buf = acmd->data_buffer;
 		struct req_iterator iter;
 		struct bio_vec bv;
 
-		rq_for_each_segment(bv, cmd->request, iter) {
+		rq_for_each_segment(bv, rq, iter) {
 			memcpy_from_page(buf, bv.bv_page, bv.bv_offset,
 					 bv.bv_len);
 			buf += bv.bv_len;
