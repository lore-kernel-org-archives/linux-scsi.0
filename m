Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7B4C19F2C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbiHCQ3w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbiHCQ3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F6B474E5;
        Wed,  3 Aug 2022 09:29:27 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9F10241305;
        Wed,  3 Aug 2022 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544165; x=1661358566; bh=UZx7O79uzg91XujHbNS/78m3g
        0VCYVZ6MyHH03e8Ggc=; b=RkJQtEA9k6/TFzROpY52XRaSpaDuozV8YB5oN4/P9
        jealZYIKEFe+SeWnNNedS6UD4Jr4Hxpi6dOXOKmhkGmHe29POvl8HAu0b4/E8pCJ
        5KGFJiqZem/uCRObO3tev1tobwxk6JUMVidSQcv3kTwMVshxoWcTBzZFPqCjJjr2
        Q0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KoC34oFUx45M; Wed,  3 Aug 2022 19:29:25 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id CAF1B412C5;
        Wed,  3 Aug 2022 19:29:17 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:17 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:17 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 21/48] target: core: checks against peer node SCSI2 reservation
Date:   Mon, 13 Dec 2021 22:28:57 +0300
Message-ID: <20220803162857.27770-22-d.bogdanov@yadro.com>
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

For the case of SCSI-2 reservation by peer node dev->reservation_holder
session is NULL. So use this information as reservation existence.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_pr.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 2f4c65d5d766..c4329f639323 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -95,7 +95,8 @@ target_scsi2_reservation_check(struct se_cmd *cmd)
 		break;
 	}
 
-	if (dev->reservation_holder->se_node_acl != sess->se_node_acl)
+	if (!dev->reservation_holder ||
+	    dev->reservation_holder->se_node_acl != sess->se_node_acl)
 		return TCM_RESERVATION_CONFLICT;
 
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS_WITH_ISID) {
@@ -211,6 +212,9 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 	if (!(dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS))
 		goto out_unlock;
 
+	if (!dev->reservation_holder)
+		goto out_unlock;
+
 	if (dev->reservation_holder->se_node_acl != sess->se_node_acl)
 		goto out_unlock;
 
@@ -262,12 +266,15 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	tpg = sess->se_tpg;
 	spin_lock(&dev->dev_reservation_lock);
 	if ((dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) &&
-	     dev->reservation_holder->se_node_acl != sess->se_node_acl) {
+	    (!dev->reservation_holder ||
+	     dev->reservation_holder->se_node_acl != sess->se_node_acl)) {
 		pr_err("SCSI-2 RESERVATION CONFLICT for %s fabric\n",
 			tpg->se_tpg_tfo->fabric_name);
 		pr_err("Original reserver LUN: %llu %s\n",
 			cmd->se_lun->unpacked_lun,
-			dev->reservation_holder->se_node_acl->initiatorname);
+			(dev->reservation_holder) ?
+			 dev->reservation_holder->se_node_acl->initiatorname :
+			 "peer");
 		pr_err("Current attempt - LUN: %llu -> MAPPED LUN: %llu"
 			" from %s \n", cmd->se_lun->unpacked_lun,
 			cmd->orig_fe_lun,
-- 
2.25.1

