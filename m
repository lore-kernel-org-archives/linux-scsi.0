Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265D0C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DF11611EE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351208AbhERRq0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:26 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:38599 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351181AbhERRqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:21 -0400
Received: by mail-pf1-f177.google.com with SMTP id k19so7962299pfu.5
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cFlK9UBqTu+oQyrVfNU9J4WjWfzurhnGH9PF7hpa+Yc=;
        b=JQyRHMgqkdkVD/dPk1ywj/KZMnPKKqHucn1hIlAM894obb9K7V44YfGjCNbsS3rGjg
         lTTP1KBRFGPfzciOVcVI27mCt5DOw9eLQtYDi3J0nvx6wiul/wbu7/3lZxaw4CgFL4Wg
         kVA0QFpSVspo3gnoR9E+Y+6F1afT9u3L6Csnqu0BeZ+RAy7Obd837oBiLokAHnXuDYvB
         ltWsunuYVXb4XLJCyGz8eh7Mjs/AJMStf5gvW1fwbZ8asb6FpAxPENj6gaeAHAzQ40I/
         MI+qBIOUEtBHd/RwidMFRJ2c4snBRxLv3tqNfrOAQm60Qa9vltayY5vmD0QsXUO5/iZ3
         gN5w==
X-Gm-Message-State: AOAM532zL3ycrvYUtWrsC8iwLq9roSl411ygVzyFnC0zxvDQRVaCIR9x
        6NLZGvf9O2imzZMWGrRqfQqZFttaZHU=
X-Google-Smtp-Source: ABdhPJxi3Y3aqksVW+rNmu15uBxMlEdYr90A34eTU1LD8LLlbVHbrG1g+KwQ4H+TRIRTa10PM3jDeA==
X-Received: by 2002:a63:5d18:: with SMTP id r24mr6293463pgb.94.1621359902844;
        Tue, 18 May 2021 10:45:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 05/50] scsi_transport_fc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:05 -0700
Message-Id: <20210518174450.20664-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
index da5b503dc7a1..c21d2e473ab3 100644
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
