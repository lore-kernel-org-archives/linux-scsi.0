Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01387C4708D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 10:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbiLBKel (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 05:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbiLBKds (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 05:33:48 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D5CCE406;
        Fri,  2 Dec 2022 02:33:45 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4B00140888;
        Fri,  2 Dec 2022 10:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1669977223; x=1671791624; bh=gKjKjvmhkVl5pOOYcXM71597Z
        rzjWPDL26Rqu3hAECI=; b=kQVylMCWQ/AV3oGCItRu4dH0AIDHwazOJLQ6rIrBN
        toeyDX5T6Iwk5RL/IK1uztcHbsUXEvphQMVwk7xr4R/WtjCyBCNwhyB/uZCaCI9m
        Cx7iMjar6qBhmfvhI1vXnYUvLAXSmlpaXxw6D7dzpCr4nZw+UHeGCQCB0nSh5Jwc
        34=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ycw33XhWaOdX; Fri,  2 Dec 2022 13:33:43 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 2421F41200;
        Fri,  2 Dec 2022 13:33:42 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 2 Dec 2022 13:33:41 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Fri, 2 Dec 2022 13:33:41 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [RESEND v2 4/4] target: core: new key must be used for moved PR
Date:   Fri, 2 Dec 2022 13:33:31 +0300
Message-ID: <20221202103331.14297-5-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221202103331.14297-1-d.bogdanov@yadro.com>
References: <20221202103331.14297-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to SPC4 5.12.8:
e) Retain the reservation key specified in the SERVICE ACTION
RESERVATION KEY field and associated information;

But currently sa_res_key is only used for the not existing I_T nexus.
The patch adds a changing of the key for the existing I_T nexus the PR
moved to.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
v2:
  fix indentation
---
 drivers/target/target_core_pr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 6a5f9504a481..1493b1d01194 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3440,8 +3440,6 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 *       transport protocols where port names are not required;
 	 * d) Register the reservation key specified in the SERVICE ACTION
 	 *    RESERVATION KEY field;
-	 * e) Retain the reservation key specified in the SERVICE ACTION
-	 *    RESERVATION KEY field and associated information;
 	 *
 	 * Also, It is not an error for a REGISTER AND MOVE service action to
 	 * register an I_T nexus that is already registered with the same
@@ -3463,6 +3461,12 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
 						iport_ptr);
 		new_reg = 1;
+	} else {
+		/*
+		 * e) Retain the reservation key specified in the SERVICE ACTION
+		 *    RESERVATION KEY field and associated information;
+		 */
+		dest_pr_reg->pr_res_key = sa_res_key;
 	}
 	/*
 	 * f) Release the persistent reservation for the persistent reservation
-- 
2.25.1

