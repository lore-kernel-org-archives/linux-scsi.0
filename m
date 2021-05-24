Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6438C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9C1F6115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhEXDLd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:33 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:39608 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhEXDLc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:32 -0400
Received: by mail-pl1-f172.google.com with SMTP id t9so5462686ply.6
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XEfWU9LUhzWPDuMzwDDPW6MUHgQj6+8h3kxlWqjtmfs=;
        b=lQ/tTY5yMJJEkdGZO9czPYKT4MdQHOnCustsg4Zu/W4ByDzSxVhgj+aiEOcjUwAWxI
         pB0wWuDE+hik2lu0SaPk7TKeB6o7yq2ng7N1bjpvK3LbXAC6sgsIpC6bxTfl9UMB4g0i
         JY/m/wKnv0xpnysPeXG+lBDVIRe4qp9gZjEAwJb4zYKkJuZe4y7qVnGu3zH4To0PfIFg
         XaF9nt9Y42U5vJOSwaGz3cO/KNojFY2oZLNSWt6r93FUUUffWXzGs4g4qrpkqxwoWC/d
         GtTpjMw0FdSxqJNHyfs3tF05CwJvZ+p7T9osztNcErAY9u808jaoz4bRH2pkfXP0MrtM
         qbQQ==
X-Gm-Message-State: AOAM533W2WcSYVjRZZyyqfFtF+jz/reO2XRlfyOFtRqSlJjszehXDMjL
        ICsrx9dbEhpxJNpBQP3uxNA=
X-Google-Smtp-Source: ABdhPJwnKVYjB51KOtScsk5hL84rny38eK5hfIuDN3ey+0o0wF614TZngSJpE12We2UFLqYsl+BLww==
X-Received: by 2002:a17:90a:880c:: with SMTP id s12mr22615731pjn.66.1621825803942;
        Sun, 23 May 2021 20:10:03 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 35/51] qedi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:40 -0700
Message-Id: <20210524030856.2824-36-bvanassche@acm.org>
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
 drivers/scsi/qedi/qedi_fw.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..f371c358c8c4 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -611,14 +611,7 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		goto error;
 	}
 
-	if (!sc_cmd->request) {
-		QEDI_WARN(&qedi->dbg_ctx,
-			  "sc_cmd->request is NULL, sc_cmd=%p.\n",
-			  sc_cmd);
-		goto error;
-	}
-
-	if (!sc_cmd->request->q) {
+	if (!scsi_cmd_to_rq(sc_cmd)->q) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "request->q is NULL so request is not valid, sc_cmd=%p.\n",
 			  sc_cmd);
