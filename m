Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00538C6FA82
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Sep 2022 21:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiILVqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 17:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiILVqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 17:46:03 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112824D161;
        Mon, 12 Sep 2022 14:46:03 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A5DE6453FB;
        Mon, 12 Sep 2022 21:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1663019160; x=
        1664833561; bh=hpTp6LvnefmUUmUgQkrJc7InovoeactjAYbbLsGrqic=; b=a
        68n88L2Ymb/e9eYeNZebntwd1zOF/+tbtf32EKqeaWYnj4WpeuK0AW15CvDSmk/e
        yq5pLRpFQcLsTuCyvSG0jryc+zhOv1BH0sVhHgKkVlB/H7xugXq4d7EpNWlaCkBV
        om5pXNvZoG4ovZd/OROML9BPdd7AeY5+f3Ao5E4F1c=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id X1JqmwsPGO1e; Tue, 13 Sep 2022 00:46:00 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3BD2F453CC;
        Tue, 13 Sep 2022 00:46:00 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 13 Sep 2022 00:45:59 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 13 Sep 2022 00:45:56 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        "Dmitry Bogdanov" <d.bogdanov@yadro.com>
Subject: [PATCH v3] scsi: target: alua: do not report emtpy port group
Date:   Tue, 13 Sep 2022 00:45:49 +0300
Message-ID: <20220912214549.27882-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Default target port group is always returned in the list of port
groups, even if the behaviour is unwanted, i.e. it has no members and
non-default port groups are primary port groups.

That violates SPC-4 "6.37 REPORT TARGET PORT GROUPS command":
 Every target port group shall contain at least one target port. The
 target port group descriptor shall include one target port descriptor
 for each target port in the target port group.

This patch hides port groups with no ports in REPORT TARGET PORT GROUPS
response.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
v3:
  update commit message
v2:
  new solution - just skip all empty groups
---
 drivers/target/target_core_alua.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index fb91423a4e2e..c8470e7c0e10 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -164,6 +164,9 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
 			tg_pt_gp_list) {
+		/* Skip empty port groups */
+		if (!tg_pt_gp->tg_pt_gp_members)
+			continue;
 		/*
 		 * Check if the Target port group and Target port descriptor list
 		 * based on tg_pt_gp_members count will fit into the response payload.
-- 
2.25.1

