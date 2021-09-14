Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D98FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 10:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AFA0610FB
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 10:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhINK5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 06:57:12 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:42358 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231849AbhINK5I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 06:57:08 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C1C2F41EC9;
        Tue, 14 Sep 2021 10:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1631616948; x=1633431349; bh=blLD9pRpWmgUzJUdfSAValefXtQx1U3Sgue
        uthUrbVo=; b=Drl6I5IGWX0ZSOhWycnXhkNH4x60VrVUuYm2HE/2n7yo1DsXgOa
        2HZWdIzrCVczOlD+rsAyvFlwaSslxpmE+EqVUNJV88j38SCmsw6Ljzy5SMOY45Xy
        8Rv7tw9yHjdb0nhvem4s/5H0/0+s2dtAngRbI29p7maiDQdph1YDms8o=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id B0uhCGR3oU1a; Tue, 14 Sep 2021 13:55:48 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 75EB341EC5;
        Tue, 14 Sep 2021 13:55:48 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.9) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 14
 Sep 2021 13:55:47 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        James Smart <james.smart@broadcom.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 3/3] scsi: efct: decrease area under spinlock
Date:   Tue, 14 Sep 2021 13:55:39 +0300
Message-ID: <20210914105539.6942-4-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914105539.6942-1-d.bogdanov@yadro.com>
References: <20210914105539.6942-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.9]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Under session level spinlock node->active_ios_lock in
efct_scsi_io_alloc() there is a getting other spinlock of port level.
That lead to competition between sessions and even between IOs in the
same session due too much instructions under spinlock.

This change reduces spinlock area just to active_ios list for which
active_ios_lock is intended.
Spinlock CPU usage is decreased from 18% down to 13% in efct driver.
IOPS are increased from 220 kIOPS upto 264 kIOPS for one lun on my setup.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/elx/efct/efct_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_scsi.c b/drivers/scsi/elx/efct/efct_scsi.c
index 40fb3a724c76..8535bb7eabd8 100644
--- a/drivers/scsi/elx/efct/efct_scsi.c
+++ b/drivers/scsi/elx/efct/efct_scsi.c
@@ -38,8 +38,6 @@ efct_scsi_io_alloc(struct efct_node *node)
 
 	xport = efct->xport;
 
-	spin_lock_irqsave(&node->active_ios_lock, flags);
-
 	io = efct_io_pool_io_alloc(efct->xport->io_pool);
 	if (!io) {
 		efc_log_err(efct, "IO alloc Failed\n");
@@ -66,6 +64,7 @@ efct_scsi_io_alloc(struct efct_node *node)
 
 	/* Add to node's active_ios list */
 	INIT_LIST_HEAD(&io->list_entry);
+	spin_lock_irqsave(&node->active_ios_lock, flags);
 	list_add(&io->list_entry, &node->active_ios);
 
 	spin_unlock_irqrestore(&node->active_ios_lock, flags);
-- 
2.25.1

