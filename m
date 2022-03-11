Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E651C19F2D
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238213AbiHCQcN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237606AbiHCQbd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:31:33 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6416342;
        Wed,  3 Aug 2022 09:30:15 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id AE436412FE;
        Wed,  3 Aug 2022 16:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544212; x=1661358613; bh=EyVD6bNDYi6Hci8/RaMsy90vn
        T1nj8IM+Qzvs9n7IKU=; b=mdSuoobvPkqdGfO04V80E1BlFFQ6ouwb5erMdDKEw
        LYDMXPsLI3EExm7o74Vr2WB9QtFgV6sjY4tXdLl6X0TaaDis7gx5dLMJhYkbVoeC
        gXwrEmyT8P9bxaMx7IdJKVkvPsuPGa0/0lZNOvgslyvKQ8AepbreCVMBEboKA+0N
        CY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id A8pKwWcY2DeP; Wed,  3 Aug 2022 19:30:12 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 799334127C;
        Wed,  3 Aug 2022 19:29:26 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:26 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:25 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 45/48] target: cluster: add reset cluster function
Date:   Fri, 11 Mar 2022 11:40:31 +0300
Message-ID: <20220803162857.27770-46-d.bogdanov@yadro.com>
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

Introduce `reset' function pointer in target cluster ops.
For no cluster case do just clear SCSI2 reservation status.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_device.c | 9 +++++++++
 drivers/target/target_core_tmr.c    | 9 +--------
 include/target/target_core_base.h   | 1 +
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4f36d12d2213..7d0d889961c2 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -802,6 +802,14 @@ static void target_reserve2_nodlm(struct se_device *dev, struct se_session *sess
 	}
 }
 
+static void target_reset_nodlm(struct se_device *dev)
+{
+	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
+		target_release_reservation(dev);
+		pr_debug("LUN_RESET: SCSI-2 Released reservation\n");
+	}
+}
+
 const struct target_cluster_ops nodlm_cluster_ops = {
 	.name = "single",
 	.owner = NULL,
@@ -813,6 +821,7 @@ const struct target_cluster_ops nodlm_cluster_ops = {
 	.pr_unlock = target_dummy_nodlm,
 	.pr_sync = target_prsync_nodlm,
 	.reserve = target_reserve2_nodlm,
+	.reset = target_reset_nodlm,
 };
 
 struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 6984bfa976a4..878401ab8145 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -402,14 +402,7 @@ int core_tmr_lun_reset(
 {
 	core_local_lun_reset(dev, tmr, NULL, NULL);
 
-	/*
-	 * Clear any legacy SPC-2 reservation when called during
-	 * LOGICAL UNIT RESET
-	 */
-	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
-		dev->cl_ops->reserve(dev, NULL);
-		pr_debug("LUN_RESET: SCSI-2 Released reservation\n");
-	}
+	dev->cl_ops->reset(dev);
 
 	target_dev_ua_allocate(dev, 0x29,
 			ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index af3c972c3376..c8900da705b6 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -791,6 +791,7 @@ struct target_cluster_ops {
 	int (*pr_unlock)(struct se_device *dev);
 	int (*pr_sync)(struct se_device *dev, u8 pro_sa);
 	void (*reserve)(struct se_device *dev, struct se_session *sess);
+	void (*reset)(struct se_device *dev);
 };
 
 struct se_device {
-- 
2.25.1

