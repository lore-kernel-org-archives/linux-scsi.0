Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4960DC19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbiHCQ3z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238333AbiHCQ3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C23481D9;
        Wed,  3 Aug 2022 09:29:26 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7EDD1412E7;
        Wed,  3 Aug 2022 16:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544164; x=1661358565; bh=yh6LXQKlGYjI0UzGNwr6MY9lw
        j4LYJh3vaAjP2xKYPQ=; b=km7ljrz7zEtU8gyY3GRgDnRkBL1uFXYKqzyPlMJHa
        UatXHM3w4037HkMNabemiLq+dY5CYnpxO7YBRkylOliQ57E3PDd2dkx0yzAC9bCO
        GH7S+Vf1Gtfj63WmSEdb2oYZ7eAqx/NnXztyl1+lr3xe2ULKUQnNv4r8OiYreZxK
        Vc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sucqdIsIgKFG; Wed,  3 Aug 2022 19:29:24 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4591841292;
        Wed,  3 Aug 2022 19:29:17 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:17 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:16 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 19/48] target: core: remove superfluous checks
Date:   Mon, 13 Dec 2021 22:15:47 +0300
Message-ID: <20220803162857.27770-20-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803162857.27770-1-d.bogdanov@yadro.com>
References: <20220803162857.27770-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

remove double checks on path of SCSI-2 reservations

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_pr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index aaa383e1ee58..4bb16de29a1e 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -95,9 +95,6 @@ target_scsi2_reservation_check(struct se_cmd *cmd)
 		break;
 	}
 
-	if (!dev->reservation_holder || !sess)
-		return 0;
-
 	if (dev->reservation_holder->se_node_acl != sess->se_node_acl)
 		return TCM_RESERVATION_CONFLICT;
 
@@ -211,7 +208,7 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 		return TCM_RESERVATION_CONFLICT;
 
 	spin_lock(&dev->dev_reservation_lock);
-	if (!dev->reservation_holder || !sess)
+	if (!dev->reservation_holder)
 		goto out_unlock;
 
 	if (dev->reservation_holder->se_node_acl != sess->se_node_acl)
-- 
2.25.1

