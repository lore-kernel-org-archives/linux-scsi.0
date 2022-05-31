Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AFDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 09:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245229AbiEaJ2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 05:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245234AbiEaJ2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 05:28:46 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7682C112;
        Tue, 31 May 2022 02:28:20 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A78284D5CE;
        Tue, 31 May 2022 09:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1653989293; x=
        1655803694; bh=MOf6TYYpKbHAk8M3h/AxNWkw4vVmQCgU8JSy/LqhUcE=; b=G
        25u18MGE84a8ZJd7GcWwlGH1HpZWBGlnZSnjVrNiltHkP0LSocppkLRu4gn8fM2z
        d+zQnWm3rEXEKD7gepC0kf25r1o8Igy3ZfYmVqDy/4FApoK9bniS3uyU6tIA1FQF
        IEOVnvekkm15EHucLkhFqYfT3+Ghp5f+nETyBg4THA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MZKEeI9482Yp; Tue, 31 May 2022 12:28:13 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 83D714D62E;
        Tue, 31 May 2022 12:28:13 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 31 May 2022 12:28:13 +0300
Received: from NB-591.corp.yadro.com (10.178.114.42) by
 T-EXCH-09.corp.yadro.com (172.17.11.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.22; Tue, 31 May 2022 12:28:12 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH] scsi: efct: reject PRLI when no target configured
Date:   Tue, 31 May 2022 12:28:05 +0300
Message-ID: <20220531092805.12899-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When target is not yet configured PRLI is ignored and consequent PLOGI
comes in the wrong state and produces WARN:
  WARNING: CPU: 25 PID: 2429 at drivers/scsi/elx/libefc/efc_device.c:350 efc_send_ls_acc_after_attach+0x20/0x58 [efct]

Reject PRLI like in other error cases when session can not be created.
And fix a memory leak of wq_data in the same place.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/elx/efct/efct_lio.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index 9c45a0ca9191..dbe2f1871da3 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -1183,6 +1183,7 @@ static void efct_lio_setup_session(struct work_struct *work)
 	struct se_session *se_sess;
 	int watermark;
 	int ini_count;
+	int ret = 0;
 	u64 id;
 
 	/* Check to see if it's belongs to vport,
@@ -1196,7 +1197,8 @@ static void efct_lio_setup_session(struct work_struct *work)
 		se_tpg = &tpg->tpg;
 	} else {
 		efc_log_err(efct, "failed to init session\n");
-		return;
+		ret = -EIO;
+		goto done;
 	}
 
 	/*
@@ -1210,9 +1212,8 @@ static void efct_lio_setup_session(struct work_struct *work)
 				       node, efct_session_cb);
 	if (IS_ERR(se_sess)) {
 		efc_log_err(efct, "failed to setup session\n");
-		kfree(wq_data);
-		efc_scsi_sess_reg_complete(node, -EIO);
-		return;
+		ret = -EIO;
+		goto done;
 	}
 
 	tgt_node = node->tgt_node;
@@ -1224,8 +1225,6 @@ static void efct_lio_setup_session(struct work_struct *work)
 	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_KERNEL)))
 		efc_log_err(efct, "Node lookup store failed\n");
 
-	efc_scsi_sess_reg_complete(node, 0);
-
 	/* update IO watermark: increment initiator count */
 	ini_count = atomic_add_return(1, &efct->tgt_efct.initiator_count);
 	watermark = efct->tgt_efct.watermark_max -
@@ -1234,7 +1233,9 @@ static void efct_lio_setup_session(struct work_struct *work)
 			efct->tgt_efct.watermark_min : watermark;
 	atomic_set(&efct->tgt_efct.io_high_watermark, watermark);
 
+done:
 	kfree(wq_data);
+	efc_scsi_sess_reg_complete(node, ret);
 }
 
 int efct_scsi_new_initiator(struct efc *efc, struct efc_node *node)
-- 
2.25.1

