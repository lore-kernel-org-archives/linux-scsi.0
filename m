Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75870C47247
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538902082E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgEGE2w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 00:28:52 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36069 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEGE2v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 00:28:51 -0400
Received: by mail-pl1-f193.google.com with SMTP id f15so1557835plr.3
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2020 21:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C0cot1my3DSTorq5qYnwXxrVta8UfIO9bwrwrWtZ1vU=;
        b=WLYN/ofV75jbcRjQDaDrcN0ZwC4ossnezrAstM6Qst5vLHmkvkrAF7wzcLVA87Nitj
         YbJ6JkW2cD1GtOX2mJPDR5cqIRj/ha5gDIVkD31g+NKNs4D6KlLrcKx46pbXDssmbXE6
         ORGUk+kneQtL+VAcmCihVWJhRen/jzEJR4TQy2MN0Xh3yoZi0n6kU4UlLXDMCcPadakc
         tCkD+ikv0GetGYuCREaY7RkvfGtWyZorE2XxqbKXg17ny3Bbsyjo+2Y4ZfPQ6AwYWNDa
         TFjJvaaMqqCKOCN7SRS8royd1BT7mBF6x7scWFoSo6ueFTwjcIKMvejfm6YnhLP5CjPy
         pF/w==
X-Gm-Message-State: AGi0PuZz4bgT0+sarlk+cmTPHlER2jo6AOzG+dWHzsiYhRQTOy0BI3np
        Q6hfCrRL6ldQp6+kmh9+DSE=
X-Google-Smtp-Source: APiQypLAqfyDugQKwtIJ7GS67v7s1Fln67aTyF1dPNunxvOXVq88c8BhLFJCuTwDj5pgeyCf2AaFmg==
X-Received: by 2002:a17:90a:a608:: with SMTP id c8mr13087868pjq.90.1588825730806;
        Wed, 06 May 2020 21:28:50 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:246f:3453:e672:e40c])
        by smtp.gmail.com with ESMTPSA id z28sm3471028pfr.3.2020.05.06.21.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 21:28:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v5 05/11] qla2xxx: Make a gap in struct qla2xxx_offld_chain explicit
Date:   Wed,  6 May 2020 21:28:29 -0700
Message-Id: <20200507042835.9135-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507042835.9135-1-bvanassche@acm.org>
References: <20200507042835.9135-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes struct qla2xxx_offld_chain compatible with ARCH=i386.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dbg.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 433e95502808..b106b6808d34 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -238,6 +238,7 @@ struct qla2xxx_offld_chain {
 	uint32_t chain_size;
 
 	uint32_t size;
+	uint32_t reserved;
 	u64	 addr;
 };
 
