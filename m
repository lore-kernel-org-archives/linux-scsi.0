Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B5DC47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E37561159
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhEXDK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:58 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:39860 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbhEXDKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:54 -0400
Received: by mail-pf1-f170.google.com with SMTP id c17so19687926pfn.6
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z9le2znCFiWxH/qpKzW0BBcMGqfV1LOmADjtvCBfw3k=;
        b=OumetVx9KUdD488gUSa1BNfysI1VPK0oM851vIX094EJozLz8MBMwUmDdEtGi1LBnb
         OSxjYE47gz7XBvA2gzq3DCqrtpEFuJWwL+/Zhu6lWIE8rY3gRZXC57c+Fr6FFuQlG9YQ
         k/Uoy6p1X1cuUX0mZsbZf5C+izQ1JpuQ8eygTgO0t0OG63WNWeJ8e/JRlNsrmnKDZFzV
         26biPG4M4enCAnPAVXnB3y8q+l9rsRoTIbM44n3UzNt0E6dYlI6FTUpPPREOPXQex5JC
         XAumZtfYo8DojG3VYYXVAiMk0Q5VENwACRT2OksphuFNERQlWXXS+++y6MpC0UQEdOGQ
         LZZA==
X-Gm-Message-State: AOAM530USXFfb8XDCh3RBep9w0+k530mZiatysbdhTAICDUNQEwGTpzY
        SmUDRnDa0EGhJPs1YJ9KbiQ=
X-Google-Smtp-Source: ABdhPJx+vBBQojzKbDgWYghGO1MKQmyvS+rfEzvEWVQYmvw3p5Swvw1rX8I85svraH/y6FJZZAulpg==
X-Received: by 2002:a05:6a00:bc2:b029:2df:93cc:371a with SMTP id x2-20020a056a000bc2b02902df93cc371amr22157666pfu.12.1621825766846;
        Sun, 23 May 2021 20:09:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 15/51] aha1542: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:20 -0700
Message-Id: <20210524030856.2824-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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
