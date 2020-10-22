Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD2EC388F7
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 17:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BC2A24650
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 17:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="aTYU/2wA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900105AbgJVR3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 13:29:36 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:35598 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2899801AbgJVR3f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Oct 2020 13:29:35 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9811B413AB;
        Thu, 22 Oct 2020 17:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1603387238; x=1605201639; bh=6wIn2VjSacRwxkLF7efE5WImb78CORNfEbr
        g4ahQ6V4=; b=aTYU/2wAllLDhrL5psjpfsJwsyqpnoZMdUIDPjzP2bTnGodrM8i
        uHE3oTBi0ds0pLwTbnrz/rYrRYnMTBASsBAlECo2PQZr8EJCbu3AyHeU5qZqKV+Y
        S/sVn8qjxYrDfC248hN3Vx2ixxpkJcA1iVFPF2f89MVvAKGSJe1PmoGc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tAEqMxZRY0jL; Thu, 22 Oct 2020 20:20:38 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id CDB5B413A0;
        Thu, 22 Oct 2020 20:20:38 +0300 (MSK)
Received: from localhost (172.17.204.63) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 22
 Oct 2020 20:20:38 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Konstantin Vinogradov <k.vinogradov@yadro.com>
Subject: [PATCH 1/3] scsi: target: core: Set residuals for 4Kn devices
Date:   Thu, 22 Oct 2020 20:20:09 +0300
Message-ID: <20201022172011.42367-2-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201022172011.42367-1-a.kovaleva@yadro.com>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.63]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
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
index 9fb0be0aa620..6d73b453c2cb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1325,17 +1325,6 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
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

