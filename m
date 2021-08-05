Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0463C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1CDA6112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242609AbhHETSz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:18:55 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:46985 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhHETSz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:18:55 -0400
Received: by mail-pj1-f48.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso8224526pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T4l2L2bo4HSpQ9tmJiH9KxIIo4Z/lQ1TJBcn2iUc+U0=;
        b=hsT8PLlBORyU21ry6pWNOdXvM241H/daDPTe/ard1tluU+rOLcpIAHhvVAGslh3HkM
         hkdM+IIOETTGd5D5brbTx/8AI6M+to9vT4OWl1wJc31jBkJKnBRaKjJeJitcpHmcLVmJ
         dLuIYejkK073cxfv9C20e67V/+6BhMW4OcJHIhRnF7W0IIxnjgzr69ulm1AKgoVcFlKm
         cLrG5gGaH6JO8FYelhLGR6Znj8bkWbMEBdjHOMXs2to/OGupuCvgDcNoXCwiSlDafcEz
         i8LAd9mZiUikt+7bEd2nJ2L7jNNvqBueUGvC0L8ci/Kdsrb/nmvapAP/vC/q3OZPUEhl
         PBSg==
X-Gm-Message-State: AOAM531qZ/c4LGBN13igRIaHYsECBy4XkCpzfcpzQxSBw9qkXnR7L6eD
        5n9d+26Dx/aa75S3S6LJKSs=
X-Google-Smtp-Source: ABdhPJxNRgbRq2semjbftXywMA1rZ0DGBtwLd5KlHrhXjjZ5+J8c+M9Op2+U9Lb41ntKCVlGsXn0Sg==
X-Received: by 2002:a17:90b:a54:: with SMTP id gw20mr6157824pjb.215.1628191120423;
        Thu, 05 Aug 2021 12:18:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 01/52] core: Introduce the scsi_cmd_to_rq() function
Date:   Thu,  5 Aug 2021 12:17:37 -0700
Message-Id: <20210805191828.3559897-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'request' member of struct scsi_cmnd is superfluous. The struct
request and struct scsi_cmnd data structures are adjacent and hence the
request pointer can be derived easily from a scsi_cmnd pointer. Introduce
a helper function that performs that conversion in a type-safe way. This
patch is the first step towards removing the request member from struct
scsi_cmnd. Making that change has the following advantages:
- This is a performance optimization since adding an offset to a pointer
  takes less time than dereferencing a pointer.
- struct scsi_cmnd becomes smaller.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 90da9617d28a..e76278ea1fee 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -146,6 +146,12 @@ struct scsi_cmnd {
 	unsigned int extra_len;	/* length of alignment and padding */
 };
 
+/* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
+static inline struct request *scsi_cmd_to_rq(struct scsi_cmnd *scmd)
+{
+	return blk_mq_rq_from_pdu(scmd);
+}
+
 /*
  * Return the driver private allocation behind the command.
  * Only works if cmd_size is set in the host template.
