Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F89C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3644D61132
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhHETTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:06 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:40668 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242722AbhHETTC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:02 -0400
Received: by mail-pj1-f49.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so14092479pji.5
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l6VDWq6IVEh87e1uNmLaYE9v1k4d4/jK9l4qdKk6+CY=;
        b=pR5+fMSUyVYXJXSV5aRxCVe9w7Ms4qH2URAQNxslnYGmDOF/TENhBOGn3xKt37uZDL
         y5FNRg/RDCY3wAeQQGtfC5q7FKHtY8ko5WvR/MfmHxVWOuMPbNOlktZs3H/ISG0biIuW
         GvK3uj46atk4jnIIUhkyHRRJ8lH4403xV6QQaay0jV8bzVQGTF6xgw2JKopH0/vLGNY8
         EmDfcI7dRT3y3yQLNYPgwnvN+RLdfYzxLAF2mEjLDkdzNtIoCPNjDTXP7viLCA+uBYoH
         m/QXVki8RdM9Je6tKkGH+NysHr9vFDCZCaq+wTyj3tOYbpjzfAMFvW54IUKjIuWQXw96
         H9FQ==
X-Gm-Message-State: AOAM531ZOnyLcz0FEgVebefsl+QF6Bas4cCYDMwH4PE1ojEa/1a96smj
        9wDEhV8KWOepRIA2SqDCMl0=
X-Google-Smtp-Source: ABdhPJxGanboA0n7jyvnH9y2/ftQaDBg4oZmcRVL9o1KAN/ctnRSoiSH53eHpFLGsn7SjnF6BO8w0w==
X-Received: by 2002:a62:828d:0:b029:3c4:dced:4c7c with SMTP id w135-20020a62828d0000b02903c4dced4c7cmr901809pfd.76.1628191126863;
        Thu, 05 Aug 2021 12:18:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 05/52] scsi_transport_fc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:41 -0700
Message-Id: <20210805191828.3559897-6-bvanassche@acm.org>
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 49748cd817a5..60e406bcf42a 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3804,7 +3804,7 @@ bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd)
 	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
 
 	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
-		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
+		(scsi_cmd_to_rq(scmd)->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
 		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);
 		return false;
 	}
