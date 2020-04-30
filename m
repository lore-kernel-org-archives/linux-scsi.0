Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1734BC19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbiHCQ3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbiHCQ3Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:24 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CB443E59;
        Wed,  3 Aug 2022 09:29:20 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7992F412CC;
        Wed,  3 Aug 2022 16:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544158; x=1661358559; bh=nHf1+JiaUlppLZuGjnVcLvxaH
        EGVObBWMJ9YhuHNlac=; b=R+Hkl2vTFgIlHjOY+i3/cSnQ7obMPAFu6yngWfLU0
        rDHhTfN0TodtEYaCWJpyV/eTA22vo9QL1I/7BlMm2NExOfgiZU5KcIB1zeum6TRs
        XAyZ0Z0bHTLJz+35DjkO7+GAb7hT8yBhGo1Xf+Tqs3DInt1beuWYOjUuBnCuNc64
        1k=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XTGavMJdcEV5; Wed,  3 Aug 2022 19:29:18 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3F458412C9;
        Wed,  3 Aug 2022 19:29:14 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:14 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:13 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 10/48] scsi: target/core: Unlock PR generation bump
Date:   Thu, 30 Apr 2020 17:16:53 +0300
Message-ID: <20220803162857.27770-11-d.bogdanov@yadro.com>
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

From: Konstantin Shelekhin <k.shelekhin@yadro.com>

Get rid of spinlock and bump PR generation atomically. This is required
to prevent deadlock later on.

Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c |  3 ++-
 drivers/target/target_core_pr.c       | 25 ++++++-------------------
 include/target/target_core_base.h     |  2 +-
 3 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 40b9808738d2..610de251994e 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1814,7 +1814,8 @@ static ssize_t target_pr_res_pr_all_tgt_pts_show(struct config_item *item,
 static ssize_t target_pr_res_pr_generation_show(struct config_item *item,
 		char *page)
 {
-	return sprintf(page, "0x%08x\n", pr_to_dev(item)->t10_pr.pr_generation);
+	return sprintf(page, "0x%08x\n",
+			atomic_read(&pr_to_dev(item)->t10_pr.pr_generation));
 }
 
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 668670b1414a..8f3d920d2590 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -594,8 +594,6 @@ target_scsi3_pr_reservation_check(struct se_cmd *cmd)
 
 static u32 core_scsi3_pr_generation(struct se_device *dev)
 {
-	u32 prg;
-
 	/*
 	 * PRGeneration field shall contain the value of a 32-bit wrapping
 	 * counter mainted by the device server.
@@ -605,11 +603,7 @@ static u32 core_scsi3_pr_generation(struct se_device *dev)
 	 *
 	 * See spc4r17 section 6.3.12 READ_KEYS service action
 	 */
-	spin_lock(&dev->dev_reservation_lock);
-	prg = dev->t10_pr.pr_generation++;
-	spin_unlock(&dev->dev_reservation_lock);
-
-	return prg;
+	return atomic_inc_return(&dev->t10_pr.pr_generation);
 }
 
 static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
@@ -1057,15 +1051,8 @@ static void __core_scsi3_add_registration(
 	/*
 	 * Increment PRgeneration counter for struct se_device upon a successful
 	 * REGISTER, see spc4r17 section 6.3.2 READ_KEYS service action
-	 *
-	 * Also, when register_move = 1 for PROUT REGISTER_AND_MOVE service
-	 * action, the struct se_device->dev_reservation_lock will already be held,
-	 * so we do not call core_scsi3_pr_generation() which grabs the lock
-	 * for the REGISTER.
 	 */
-	pr_reg->pr_res_generation = (register_move) ?
-			dev->t10_pr.pr_generation++ :
-			core_scsi3_pr_generation(dev);
+	pr_reg->pr_res_generation = core_scsi3_pr_generation(dev);
 
 	spin_lock(&pr_tmpl->registration_lock);
 	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
@@ -3481,7 +3468,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * Increment PRGeneration for existing registrations..
 	 */
 	if (!new_reg)
-		dest_pr_reg->pr_res_generation = pr_tmpl->pr_generation++;
+		dest_pr_reg->pr_res_generation = core_scsi3_pr_generation(dev);
 	spin_unlock(&dev->dev_reservation_lock);
 
 	pr_debug("SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE"
@@ -3703,7 +3690,7 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	if (!buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	put_unaligned_be32(dev->t10_pr.pr_generation, buf);
+	put_unaligned_be32(atomic_read(&dev->t10_pr.pr_generation), buf);
 
 	spin_lock(&dev->t10_pr.registration_lock);
 	list_for_each_entry(pr_reg, &dev->t10_pr.registration_list,
@@ -3758,7 +3745,7 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	if (!buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	put_unaligned_be32(dev->t10_pr.pr_generation, &buf[0]);
+	put_unaligned_be32(atomic_read(&dev->t10_pr.pr_generation), &buf[0]);
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_reg = dev->dev_pr_res_holder;
@@ -3900,7 +3887,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	if (!buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	put_unaligned_be32(dev->t10_pr.pr_generation, &buf[0]);
+	put_unaligned_be32(atomic_read(&dev->t10_pr.pr_generation), &buf[0]);
 
 	spin_lock(&dev->dev_reservation_lock);
 	if (dev->dev_pr_res_holder) {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6ed484683ab6..7e13db647faa 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -385,7 +385,7 @@ struct t10_reservation {
 	 * for SCSI device */
 	int pr_aptpl_active;
 #define PR_APTPL_BUF_LEN			262144
-	u32 pr_generation;
+	atomic_t pr_generation;
 	spinlock_t registration_lock;
 	spinlock_t aptpl_reg_lock;
 	/*
-- 
2.25.1

