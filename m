Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B58EC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D932065F
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgENVgS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 17:36:18 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41067 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgENVgR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 17:36:17 -0400
Received: by mail-pg1-f193.google.com with SMTP id r10so1827608pgv.8
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 14:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vNqcWeXPZJ3AMKyAWKxWXBU66xmPlLfLnmMbsKeXPuc=;
        b=KNBjXDNLLowEmnhVXtTXNQ6HVHMsB6zZkLgv0qUiJk6GoQLwebCrvX2dMBbfgH9zxO
         v5LrAAYEe5at5/Gou8R7c3nRAPPqNy48aB//qOjgXwAqfB0w/zAdkyOaWln1U8kTRRUC
         kz8D/I8YLGj9q2KiXN1b4phd5+CiVGI19V+iyCRDGwOHVjF1WG/Cz25YBcEnglLz0Jbq
         o7aAWSf12/rpDqYqfNs+cLQQkfAgzzHK/hz6aY/Wjsj8HPTI43JpTNyrh5mXoHVoP0cn
         hGIuu8279Wces8NCtTUq8CRt0/OPHp5GrcD2++7NiaSaXM103NTYicShMz5Xx24h6ifK
         v/zw==
X-Gm-Message-State: AOAM530xC6BvuWmHYX/H3w/daPxqDJSzE6c+9M7019aaMVMFACs6IDoG
        KBHzX6bLenKGDWOdnUFyH+E=
X-Google-Smtp-Source: ABdhPJw8Ok2ZqGZ8NQ5395ijPTGSiF1Y9wTZMz+BcTS7/aCyRcShaly7Kc4Z6av5mZEeItuxDX8EeA==
X-Received: by 2002:a65:608c:: with SMTP id t12mr142276pgu.46.1589492176486;
        Thu, 14 May 2020 14:36:16 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:6c16:7f27:8c37:e02d])
        by smtp.gmail.com with ESMTPSA id a142sm145754pfa.6.2020.05.14.14.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 14:36:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v6 13/15] qla2xxx: Use make_handle() instead of open-coding it
Date:   Thu, 14 May 2020 14:35:14 -0700
Message-Id: <20200514213516.25461-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514213516.25461-1-bvanassche@acm.org>
References: <20200514213516.25461-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Cc: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 87d0f5e4d81a..0a9a838c7f20 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -819,7 +819,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		goto skip_rio;
 	switch (mb[0]) {
 	case MBA_SCSI_COMPLETION:
-		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
+		handles[0] = le32_to_cpu(make_handle(mb[2], mb[1]));
 		handle_cnt = 1;
 		break;
 	case MBA_CMPLT_1_16BIT:
@@ -858,10 +858,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
 	case MBA_CMPLT_2_32BIT:
-		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
-		handles[1] = le32_to_cpu(
-		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 7) << 16)) |
-		    RD_MAILBOX_REG(ha, reg, 6));
+		handles[0] = le32_to_cpu(make_handle(mb[2], mb[1]));
+		handles[1] =
+			le32_to_cpu(make_handle(RD_MAILBOX_REG(ha, reg, 7),
+						RD_MAILBOX_REG(ha, reg, 6)));
 		handle_cnt = 2;
 		mb[0] = MBA_SCSI_COMPLETION;
 		break;
