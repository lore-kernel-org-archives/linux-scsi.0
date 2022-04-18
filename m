Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE3AC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Apr 2022 21:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiDRVj5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 17:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiDRVjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 17:39:55 -0400
X-Greylist: delayed 593 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Apr 2022 14:37:14 PDT
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602312E9FB;
        Mon, 18 Apr 2022 14:37:14 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C522443AC2;
        Mon, 18 Apr 2022 21:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1650317237; x=
        1652131638; bh=DseoJO+1W+w4gJy4d+4KRn/Xh6rVi45Wkk2zlEFZIs8=; b=m
        FaKYx+8H7sR2gse8TAbnnQSX7iCJFdNdyH/ruHIA+VI6NEY1CIr2gZLgB2+Qc527
        TfVQ3j00FerOdhugBbeXhru5QavpSwvg5QFOATg0Km7ahFfDlCXr4H9VLDwqJAxN
        zZ2YOTR2hfIHXgf/8BeSdIct1dde8kxOuBXAmBkvD4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fasM8xoosYKD; Tue, 19 Apr 2022 00:27:17 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B50D1437E1;
        Tue, 19 Apr 2022 00:27:17 +0300 (MSK)
Received: from yadro.com (10.178.113.178) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 19
 Apr 2022 00:27:15 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH] scsi: target: core: Silence the message about unknown VPD pages
Date:   Tue, 19 Apr 2022 00:26:22 +0300
Message-ID: <20220418212622.275516-1-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.113.178]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Target does not support some VPD pages and is very verbose about it.
Sometimes initiators don't bother and just keep sending the same request
from time to time, filling up the logs.

This patch lowers the message priority to debug.

Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
---
 drivers/target/target_core_spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 4c76498d3fb0..c14441c89bed 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -769,7 +769,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		}
 	}
 
-	pr_err("Unknown VPD Code: 0x%02x\n", cdb[2]);
+	pr_debug("Unknown VPD Code: 0x%02x\n", cdb[2]);
 	ret = TCM_INVALID_CDB_FIELD;
 
 out:
-- 
2.35.1

