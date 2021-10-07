Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5695DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4365561108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242320AbhJGUch (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:37 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:39661 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242363AbhJGUcc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:32 -0400
Received: by mail-pj1-f46.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso7327165pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G/U5AT0JdS1JPpSLRlnz336WYbeTNuEagu7XBIhXTCc=;
        b=ZmCk1XwikE9mFC0tRypzIOdg9mVhY1KFNOcjGZLk2+2dZ/Tk+CHzBZeJRZi9Jmu5ok
         6kK0hGY3BTMVB9iHxgYS+kFo79zfD3sZ/iawmqVUz7gO+azup4gLi6tW0cIqOQ8+NThl
         FLMQ4wal4WWNk15iKC61+72A1DOO4Rbvf3dHWa43/4PMIcyFhB8IViKEa1L8rYsFxqFO
         w3tNirmiC4PlbDTi9mXvRUOSs4Sd1ztfLCWQGWlal6da/Ol1z5VNiXkwBbVISXlUTz6j
         6AXG+WOMnykDnp4BSOLUKH8wxAa+NhVRRyeBkQM5tJWDNLIVo9eZQyztmjQbL8V9MFWZ
         tqhQ==
X-Gm-Message-State: AOAM5327HyPo/8Upu/D8bztNFO/uhi2CL5eyNRFJ3zxQ34jpZcttyFXg
        0loyVM7BPw0zNQtX2EpFQZU=
X-Google-Smtp-Source: ABdhPJyBTxeR5c3oqe+3+nSnQW12M7YGEUWv+xOQ4xXLuyeL+n0g/w9WWX9lAMCxTI4H1y2r2TN9Yw==
X-Received: by 2002:a17:90b:4f4b:: with SMTP id pj11mr7304552pjb.4.1633638637611;
        Thu, 07 Oct 2021 13:30:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 37/88] hptiop: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:32 -0700
Message-Id: <20211007202923.2174984-38-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hptiop.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 61cda7b7624f..f18f6a677c1b 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -769,7 +769,7 @@ static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
 
 skip_resid:
 	dprintk("scsi_done(%p)\n", scp);
-	scp->scsi_done(scp);
+	scsi_done(scp);
 	free_req(hba, &hba->reqs[tag]);
 }
 
@@ -1002,9 +1002,6 @@ static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 	int sg_count = 0;
 	struct hptiop_request *_req;
 
-	BUG_ON(!done);
-	scp->scsi_done = done;
-
 	_req = get_req(hba);
 	if (_req == NULL) {
 		dprintk("hptiop_queuecmd : no free req\n");
@@ -1059,7 +1056,7 @@ static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 
 cmd_done:
 	dprintk("scsi_done(scp=%p)\n", scp);
-	scp->scsi_done(scp);
+	scsi_done(scp);
 	return 0;
 }
 
