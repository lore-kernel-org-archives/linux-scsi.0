Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6B9C19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbiHCQ35 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238342AbiHCQ3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F96B48CB3;
        Wed,  3 Aug 2022 09:29:28 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 50B5E412FA;
        Wed,  3 Aug 2022 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544166; x=1661358567; bh=6t31BwzaJqtNyNhVTPhBBhTP5
        uz2EKN7rApucpAjv7I=; b=lKMB7uv64JWtCI32xvggjjYQRZ4jpN9V72CKUlRDw
        5djyT+CMC1O8sjBaLHdoYbz5CFSDmLkVepOp3ZPOnRkDB43BFzKdV+CPNY4n21iq
        uFHXRfOTtn2fbVQ5AeFJHvHOH6ADIAGICtCEIyogMsOCl2xvZIT3J3ed4Yf0O9bf
        9w=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9eq6r0XM3CWw; Wed,  3 Aug 2022 19:29:26 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 36664412DB;
        Wed,  3 Aug 2022 19:29:18 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:18 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:17 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 22/48] target: core: UA on all luns after reset
Date:   Fri, 11 Mar 2022 11:11:59 +0300
Message-ID: <20220803162857.27770-23-d.bogdanov@yadro.com>
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

Allocate UA "BUS DEVICE RESET OCCURRED" on all LUNs on the
device upon reception of TMF LUN RESET.

That patch passes a libisci test SCSI.MultipathIO.Reset.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_device.c    | 19 +++++++++++++++++++
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c |  3 +--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index a4c31f3112ce..7c887792bb88 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -285,6 +285,25 @@ void target_pr_kref_release(struct kref *kref)
 	complete(&deve->pr_comp);
 }
 
+/*
+ * Establish UA condition on SCSI device - all LUNs
+ */
+void target_dev_ua_allocate(struct se_device *dev, u8 asc, u8 ascq)
+{
+	struct se_dev_entry *se_deve;
+	struct se_lun *lun;
+
+	spin_lock(&dev->se_port_lock);
+	list_for_each_entry(lun, &dev->dev_sep_list, lun_dev_link) {
+
+		spin_lock(&lun->lun_deve_lock);
+		list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link)
+			core_scsi3_ua_allocate(se_deve, asc, ascq);
+		spin_unlock(&lun->lun_deve_lock);
+	}
+	spin_unlock(&dev->se_port_lock);
+}
+
 static void
 target_luns_data_has_changed(struct se_node_acl *nacl, struct se_dev_entry *new,
 			     bool skip_new)
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 8bd48eb1cf9b..eeb405908987 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -88,6 +88,7 @@ int	target_configure_device(struct se_device *dev);
 void	target_free_device(struct se_device *);
 int	target_for_each_device(int (*fn)(struct se_device *dev, void *data),
 			       void *data);
+void	target_dev_ua_allocate(struct se_device *dev, u8 asc, u8 ascq);
 
 /* target_core_configfs.c */
 extern struct configfs_item_operations target_core_dev_item_ops;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7838dc20f713..5926316252eb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3531,8 +3531,7 @@ static void target_tmr_work(struct work_struct *work)
 		tmr->response = (!ret) ? TMR_FUNCTION_COMPLETE :
 					 TMR_FUNCTION_REJECTED;
 		if (tmr->response == TMR_FUNCTION_COMPLETE) {
-			target_ua_allocate_lun(cmd->se_sess->se_node_acl,
-					       cmd->orig_fe_lun, 0x29,
+			target_dev_ua_allocate(dev, 0x29,
 					       ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
 		}
 		break;
-- 
2.25.1

