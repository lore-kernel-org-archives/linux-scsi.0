Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D95C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F97E6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhDTAKR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:17 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:42751 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhDTAKC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:02 -0400
Received: by mail-pg1-f179.google.com with SMTP id m12so4673242pgr.9
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U0IX1kl6bIG5rdB3UU2k/e0cRn/9x8iQILwZ4F/kStg=;
        b=NbQ3MYxJXl/dJ0WI8MhhFJK0cKGxATzqDkyxV/q2yXPG12JHzutW8ovUPoPqAZmtAY
         Salrp4TfqubKQWVOY37LfPdW0FAUHo1q9gg//H6hg33o0FJfDIWo0r1vxyvh5GEDEOwo
         zjCOa3t0SBBLm/2eECgEUxjbTI5Y/NkSmtXMbFxi6en7MCbVUY+oATC9OBG9tcO0Xv5x
         1ja2XxeVbuGnDaWaO5Reh/MgkzYk6K09oV2UPYVz96duojNX7YX6eWGHkc4ix5zkIuL1
         ur9uY81cAbyzAYDBQJw7WQghseZ6Fb6q/gz6KKUiAol3DxxMBA0fvuoosxw96JHaBSdL
         nkrg==
X-Gm-Message-State: AOAM531CrgnGwK9ihih3fnHRt9Qlj475iyLub8gDGd0lju3cJ+Wzq9It
        vYsdWEE94XmbO/9s9PiipjI=
X-Google-Smtp-Source: ABdhPJyhPAd1LXY2+5CkKqYM5NhqD3WLHroYIAtxT93O8C6lDJj7W1VNnejcjvC9oTNiFfP6O8WmcA==
X-Received: by 2002:a63:a847:: with SMTP id i7mr10257562pgp.203.1618877371509;
        Mon, 19 Apr 2021 17:09:31 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 034/117] bfa: Use type int32_t to represent a signed integer
Date:   Mon, 19 Apr 2021 17:07:22 -0700
Message-Id: <20210420000845.25873-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since a negative value may be assigned to 'rc', use a signed type for that
variable.

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Fixes: b85daafe46ee ("[SCSI] bfa: Add BSG interface to support ELS, CT and vendor commands.")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bfa/bfad_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index be8dfbe13e90..371856bc67a8 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3552,7 +3552,7 @@ bfad_im_bsg_request(struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
-	uint32_t rc = BFA_STATUS_OK;
+	int32_t rc = BFA_STATUS_OK;
 
 	switch (bsg_request->msgcode) {
 	case FC_BSG_HST_VENDOR:
