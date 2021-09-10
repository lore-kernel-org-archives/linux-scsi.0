Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EA0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 11:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D108F61153
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 11:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhIJLrY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 07:47:24 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:60796
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232613AbhIJLrY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Sep 2021 07:47:24 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id F290A3F10B;
        Fri, 10 Sep 2021 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631274372;
        bh=+9/bpq7jclrEor7OSrcOzfI9neZF2mtMH+2UvxXLpiM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=GORjGQeaVrw9ROI9XY+JBKdNJ1IlkqgXQvbFRgEBpS2Smd5bNFm3G1+k72DPh5a48
         cOJXbg/UWK1H9CjI+brYbC1UyF6OV3Xhs3YpiZ4wiLtECRmEaLTmeycv4ZxMup3cHq
         VNSVkoE/K8JLSk0n3VR7oo+BLkMqIE2emRYUTK2+yOD5sR3vRVNqvMpJPWpliEG/ev
         ZKo3Qo5CV5Yn95/bqRTPFonqBJSg9tQ8o1jVEpggGqUJD/oCw11F/TY5xmsv7gaQSS
         Pd3N+HLNSjgoLpHNu/8t+DQmFfGWphoGRB5VOiqW73l65N0s76L43PNILpDAelKuMY
         62xQRN59kzPng==
From:   Colin King <colin.king@canonical.com>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Remove redundant initialization of pointer req
Date:   Fri, 10 Sep 2021 12:46:10 +0100
Message-Id: <20210910114610.44752-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer req is being initialized with a value that is never read, it
is being updated later on. The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7811c4952035..b5e21fad9551 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3236,7 +3236,7 @@ qla24xx_abort_command(srb_t *sp)
 	fc_port_t	*fcport = sp->fcport;
 	struct scsi_qla_host *vha = fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = vha->req;
+	struct req_que *req;
 	struct qla_qpair *qpair = sp->qpair;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
-- 
2.32.0

