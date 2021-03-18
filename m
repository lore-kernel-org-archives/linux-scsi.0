Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB79BC4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9234164F3B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhCRJq4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 05:46:56 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:58588 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229803AbhCRJqe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 05:46:34 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 64ED941308;
        Thu, 18 Mar 2021 09:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1616060792; x=1617875193; bh=ZNsnz0/wcJq5weNHNyvGZBxkmsFXT8B0mc2
        il32Ih2g=; b=l1vmvivKN3B6v1F9RawbfxLs74GNlyRiyxEf5+gHNuB+klA1zXU
        Wz3yNEgyDjBjrQBkC8SBKXcXUKGuKXYDVjpmn6q2zYXgZ1HkckxFscR398TDN6VF
        wEQaHrkEJ75ZGP36dmf8v9CAiBUw8/j9TlHduXTmK1C5lqHByTjx0l/g=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oQmH3_t5P05k; Thu, 18 Mar 2021 12:46:32 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9CAE941360;
        Thu, 18 Mar 2021 12:44:21 +0300 (MSK)
Received: from yadro.com (10.199.0.137) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 18
 Mar 2021 12:44:21 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, <linux-scsi@vger.kernel.org>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 2/2] target: Make the virtual LUN 0 device dummy
Date:   Thu, 18 Mar 2021 12:42:25 +0300
Message-ID: <20210318094224.17524-3-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318094224.17524-1-k.shelekhin@yadro.com>
References: <20210318094224.17524-1-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.137]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Create the device for the virtual LUN 0 using the DUMMY flag. This
change makes it possible to remove some special-casing in the
INQUIRY code.

Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_device.c | 2 +-
 drivers/target/target_core_spc.c    | 6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7787c527aad3..2d50da7840fc 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1029,7 +1029,7 @@ int core_dev_setup_virtual_lun0(void)
 {
 	struct se_hba *hba;
 	struct se_device *dev;
-	char buf[] = "rd_pages=8,rd_nullio=1";
+	char buf[] = "rd_pages=8,rd_nullio=1,rd_dummy=1";
 	int ret;
 
 	hba = core_alloc_hba("rd_mcp", 0, HBA_FLAGS_INTERNAL_USE);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ca5579ebc81d..70a661801cb9 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -701,7 +701,6 @@ static sense_reason_t
 spc_emulate_inquiry(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_portal_group *tpg = cmd->se_lun->lun_tpg;
 	unsigned char *rbuf;
 	unsigned char *cdb = cmd->t_task_cdb;
 	unsigned char *buf;
@@ -715,10 +714,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
-	if (dev == rcu_access_pointer(tpg->tpg_virt_lun0->lun_se_dev))
-		buf[0] = 0x3f; /* Not connected */
-	else
-		buf[0] = dev->transport->get_device_type(dev);
+	buf[0] = dev->transport->get_device_type(dev);
 
 	if (!(cdb[1] & 0x1)) {
 		if (cdb[2]) {
-- 
2.30.2

