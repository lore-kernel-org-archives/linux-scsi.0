Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B304C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D65D61002
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbhHIXEu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:50 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:52908 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236965AbhHIXEq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:46 -0400
Received: by mail-pj1-f49.google.com with SMTP id nt11so7148199pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z9le2znCFiWxH/qpKzW0BBcMGqfV1LOmADjtvCBfw3k=;
        b=DkK5yqtQdrxIWX2rhMzhbXu/u9tMdhgabMTpvzBhXFgQNfkKVChQ/cvtDns1sfP9Cq
         i6eSGqyUNceevgfqMd4v3UveA4esB2ZXTClGy4sGQS/j/RvjHEq4R3cV5qA2nXvQcSZb
         impceVxPLSLyhcTMhwIaPU6iyan+aepJefeyZG3QTsXJLwp7AN2vN4/PbJkGDxIvBtK9
         6nwew+sy/u+FgKlVbbCSLcSwmbj3GWJ12/rhG7AdpFRLIysFCtsGnam4QDyulxkw2DRx
         POU1kQsXFvyU3KBbwj05ct4MMA6gu5m3Zsm0Y1zeHL8e14AVaLrBdYsFSpUPfbmXIPvU
         tsNg==
X-Gm-Message-State: AOAM531VjcPXIog6h5i++8RiQCY+f+WO1u5s0nocfb2QH8LfgB1rx99s
        G9vA/241eQbLQZ492L/TP4I=
X-Google-Smtp-Source: ABdhPJwm/vI6dViS+8PIp4bQ8OVsmjEhLnu4/4G8mFhAvwP6tDwOz064Fyd9WL+DsjxMRMLQTqcT7A==
X-Received: by 2002:a17:902:bd82:b029:129:2e87:9946 with SMTP id q2-20020a170902bd82b02901292e879946mr22311947pls.53.1628550265262;
        Mon, 09 Aug 2021 16:04:25 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 15/52] aha1542: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:18 -0700
Message-Id: <20210809230355.8186-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
