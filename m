Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0EDC432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DB1A61078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbhHETTI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:08 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:47019 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhHETTD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:03 -0400
Received: by mail-pj1-f50.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso8225353pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6C1YMminU/sYC5PWrfQ8cJBHDuyZ+19QMjzEYfMIJRQ=;
        b=aViwHw40t5BjTQ0NMdmiChWFGQlxQ4a+AnDa40iXgOciOejqLZ7K0/84he8cyP4//o
         9jwW8bnrwVvLYJSIKw8LWEzjEkyqo+C0U3s95ir/6zK7meuy+dJfVH20F97sPKwMIfRU
         SdXf2Dxg6gQeD7iRqreSGMwDRxgQuIM2LA/S6dIb12ecCPZe/tfR0/3NFeM/eSj7aJ4O
         dU9BIaIJuNnH85pZQQlLZgFeUxs6OkDYl19dufTWe+w0I8ngpEx0SeK4ZkWokhRwAzA8
         zppoTWUdV1OB1bT9doUgvWJuiZH8OHfSq7ZDE9YQE6TkwLFYuXhmt8ey/NzfdCBATJce
         ibpw==
X-Gm-Message-State: AOAM533StVIsYY2GFejS0UtC0daQ+dDTHHh99tZzpRAZP/TiC170iaKO
        2G08PVucs021RMds7y+tLCk=
X-Google-Smtp-Source: ABdhPJxiIxo2ZE0CYj20XaARo0i5vT9wKWXGIMK3zFWuitBxLDLqghq6oUh/LAKM6Yu6K6ABiAPIeA==
X-Received: by 2002:a17:90b:20b:: with SMTP id fy11mr16496525pjb.79.1628191128340;
        Thu, 05 Aug 2021 12:18:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 06/52] scsi_transport_spi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:42 -0700
Message-Id: <20210805191828.3559897-7-bvanassche@acm.org>
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
 drivers/scsi/scsi_transport_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 5af7a10e9514..bd72c38d7bfc 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1230,7 +1230,7 @@ int spi_populate_tag_msg(unsigned char *msg, struct scsi_cmnd *cmd)
 {
         if (cmd->flags & SCMD_TAGGED) {
 		*msg++ = SIMPLE_QUEUE_TAG;
-        	*msg++ = cmd->request->tag;
+		*msg++ = scsi_cmd_to_rq(cmd)->tag;
         	return 2;
 	}
 
