Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8982C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 10:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACB5961107
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 10:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhINK5N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 06:57:13 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:42366 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231938AbhINK5I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 06:57:08 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D8DBA41EC4;
        Tue, 14 Sep 2021 10:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1631616948; x=1633431349; bh=zTLGgES6oKEQKMMqAUGCsoKTd4sVMY3wPb2
        26/A9TeA=; b=GPJCkKLHSE5F3WXu3GIG2mw8e8y2Wwg7tAbN2vggoqArs9UpO5q
        nI2G1DojE8h/njHg5TrxgjOvwvtipNuT5DcoMXzrtnGbkM/FbdSf7U8VBfGfJqEj
        Cb43qnlHyBHT7Uy+V9z/Nl2WKD/YdlfOpASxXucPy50+lg1WgnGvInX8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id n_Awqr-nv2Ha; Tue, 14 Sep 2021 13:55:48 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 23A0C41ECB;
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
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 2/3] scsi: efct: fix nport free
Date:   Tue, 14 Sep 2021 13:55:38 +0300
Message-ID: <20210914105539.6942-3-d.bogdanov@yadro.com>
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

nport_free for an empty nport hangs the state machine waiting for mbox
completion if nport is not yet attached thinking that it is attaching
right now.
Add a check for nport attaching state and complete nport free.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/elx/libefc/efc_cmds.c | 7 ++++++-
 drivers/scsi/elx/libefc/efclib.h   | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc/efc_cmds.c b/drivers/scsi/elx/libefc/efc_cmds.c
index 37e6697d86b8..f8665d48904a 100644
--- a/drivers/scsi/elx/libefc/efc_cmds.c
+++ b/drivers/scsi/elx/libefc/efc_cmds.c
@@ -249,6 +249,7 @@ efc_nport_attach_reg_vpi_cb(struct efc *efc, int status, u8 *mqe,
 {
 	struct efc_nport *nport = arg;
 
+	nport->attaching = false;
 	if (efc_nport_get_mbox_status(nport, mqe, status)) {
 		efc_nport_free_resources(nport, EFC_EVT_NPORT_ATTACH_FAIL, mqe);
 		return -EIO;
@@ -286,6 +287,8 @@ efc_cmd_nport_attach(struct efc *efc, struct efc_nport *nport, u32 fc_id)
 	if (rc) {
 		efc_log_err(efc, "REG_VPI command failure\n");
 		efc_nport_free_resources(nport, EFC_EVT_NPORT_ATTACH_FAIL, buf);
+	} else {
+		nport->attaching = true;
 	}
 
 	return rc;
@@ -302,8 +305,10 @@ efc_cmd_nport_free(struct efc *efc, struct efc_nport *nport)
 	/* Issue the UNREG_VPI command to free the assigned VPI context */
 	if (nport->attached)
 		efc_nport_free_unreg_vpi(nport);
-	else
+	else if (nport->attaching)
 		nport->free_req_pending = true;
+	else
+		efc_sm_post_event(&nport->sm, EFC_EVT_NPORT_FREE_OK, NULL);
 
 	return 0;
 }
diff --git a/drivers/scsi/elx/libefc/efclib.h b/drivers/scsi/elx/libefc/efclib.h
index ee291cabf7e0..dde20891c2dd 100644
--- a/drivers/scsi/elx/libefc/efclib.h
+++ b/drivers/scsi/elx/libefc/efclib.h
@@ -142,6 +142,7 @@ struct efc_nport {
 	bool			is_vport;
 	bool			free_req_pending;
 	bool			attached;
+	bool			attaching;
 	bool			p2p_winner;
 	struct efc_domain	*domain;
 	u64			wwpn;
-- 
2.25.1

