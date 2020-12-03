Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90103C71155
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 08:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39254217A0
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 08:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388385AbgLCIWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:22:06 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:59958 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388286AbgLCIWG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Dec 2020 03:22:06 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D11EC412DF;
        Thu,  3 Dec 2020 08:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1606983683; x=1608798084; bh=bVn+HIZliuuX3OZc5WnIyyho5Dj51W9C6f8
        03/z4Lbk=; b=TieMRrRyB5WdSrPIuFcNFdPJrd0qO9/qQSemp/tu1zzM+YVW2D1
        4Nf0I3oKV83uUzW5sbmbZDo0cVqvzHHP8Sftal8s6wrXeIMANmWGf96asLVqsGpZ
        1OdvLiyQLgYPtwJDm+NvJnCWkdpjLc7H25qFfhnZhsIegsc4gDdmX02s=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sPiQD2T6765o; Thu,  3 Dec 2020 11:21:23 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 587B041393;
        Thu,  3 Dec 2020 11:21:23 +0300 (MSK)
Received: from localhost (172.17.204.63) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 3 Dec
 2020 11:21:22 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <martin.petersen@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Konstantin Vinogradov <k.vinogradov@yadro.com>
Subject: [RESEND PATCH 1/3] scsi: target: core: Set residuals for 4Kn devices
Date:   Thu, 3 Dec 2020 11:20:33 +0300
Message-ID: <20201203082035.54566-2-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201203082035.54566-1-a.kovaleva@yadro.com>
References: <20201203082035.54566-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.63]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

TCM always fails SBC commands with residuals for 4Kn devices when the
command is processed by sbc_parse_cdb(). That prevents residual
signalling to the transport driver because residual kind and residual
amount aren't set. It also makes residual handling different from
512-byte formatted devices - if there are residuals 512-byte LUN would
proceed with command execution while 4K-byte LUN would fail.

Based-on: https://patchwork.kernel.org/project/target-devel/patch/20170523234854.21452-31-bart.vanassche@sandisk.com/
Based-on-patch-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Konstantin Vinogradov <k.vinogradov@yadro.com>
---
 drivers/target/target_core_transport.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fca4bd079d02..f27a7d6cc1e0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1332,17 +1332,6 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 				return TCM_INVALID_CDB_FIELD;
 			}
 		}
-		/*
-		 * Reject READ_* or WRITE_* with overflow/underflow for
-		 * type SCF_SCSI_DATA_CDB.
-		 */
-		if (dev->dev_attrib.block_size != 512)  {
-			pr_err("Failing OVERFLOW/UNDERFLOW for LBA op"
-				" CDB on non 512-byte sector setup subsystem"
-				" plugin: %s\n", dev->transport->name);
-			/* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
-			return TCM_INVALID_CDB_FIELD;
-		}
 		/*
 		 * For the overflow case keep the existing fabric provided
 		 * ->data_length.  Otherwise for the underflow case, reset
-- 
2.24.3 (Apple Git-128)

