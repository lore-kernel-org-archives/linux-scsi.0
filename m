Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32BBC25B06
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbiHCQ35 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238341AbiHCQ3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFD86437;
        Wed,  3 Aug 2022 09:29:27 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2075241301;
        Wed,  3 Aug 2022 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544164; x=1661358565; bh=up0BrvEsLm9+0/EKtwIjmwbdV
        5hi3S99QmPqqfsgtwE=; b=o2wd1HWv06zkmYjJ7E8pena7Qkyg5+k7EHz0upieh
        BhqQ0sR2CQmame0R+wnIFGnUa+LmrobiO0+C6quojuQYzd7mcU8YfczzDyQIntTf
        dqvjOWx1a8eObfcqyQyPZCxcIw/Bl6Q+1cbNa9rCswk469F3dlz5n+c/EAeGRlCd
        ag=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BfhN0CMC4GnL; Wed,  3 Aug 2022 19:29:24 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7CAED4127C;
        Wed,  3 Aug 2022 19:29:17 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
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
Subject: [RFC PATCH 20/48] target: core: proper check of SCSI-2 reservation
Date:   Mon, 13 Dec 2021 22:20:31 +0300
Message-ID: <20220803162857.27770-21-d.bogdanov@yadro.com>
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

Use a check of the flag instead of session pointer like in other places.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c | 17 +++++++++++------
 drivers/target/target_core_pr.c       |  6 +++---
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 6e654edc4399..34901f0b2350 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1756,12 +1756,17 @@ static ssize_t target_core_dev_pr_show_spc2_res(struct se_device *dev,
 	struct se_node_acl *se_nacl;
 	ssize_t len;
 
-	if (sess) {
-		se_nacl = sess->se_node_acl;
-		len = sprintf(page,
-			      "SPC-2 Reservation: %s Initiator: %s\n",
-			      se_nacl->se_tpg->se_tpg_tfo->fabric_name,
-			      se_nacl->initiatorname);
+	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
+		if (sess) {
+			se_nacl = sess->se_node_acl;
+			len = sprintf(page,
+				"SPC-2 Reservation: %s Initiator: %s\n",
+				se_nacl->se_tpg->se_tpg_tfo->fabric_name,
+				se_nacl->initiatorname);
+		} else {
+			len = sprintf(page,
+				"SPC-2 Reservation: peer node\n");
+		}
 	} else {
 		len = sprintf(page, "No SPC-2 Reservation holder\n");
 	}
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 4bb16de29a1e..2f4c65d5d766 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -208,7 +208,7 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 		return TCM_RESERVATION_CONFLICT;
 
 	spin_lock(&dev->dev_reservation_lock);
-	if (!dev->reservation_holder)
+	if (!(dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS))
 		goto out_unlock;
 
 	if (dev->reservation_holder->se_node_acl != sess->se_node_acl)
@@ -261,8 +261,8 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 
 	tpg = sess->se_tpg;
 	spin_lock(&dev->dev_reservation_lock);
-	if (dev->reservation_holder &&
-	    dev->reservation_holder->se_node_acl != sess->se_node_acl) {
+	if ((dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) &&
+	     dev->reservation_holder->se_node_acl != sess->se_node_acl) {
 		pr_err("SCSI-2 RESERVATION CONFLICT for %s fabric\n",
 			tpg->se_tpg_tfo->fabric_name);
 		pr_err("Original reserver LUN: %llu %s\n",
-- 
2.25.1

