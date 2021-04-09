Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BD8C43460
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 12:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50CA4610FC
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 12:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhDIMsI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 08:48:08 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55646 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232990AbhDIMr6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Apr 2021 08:47:58 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 65E7A41408;
        Fri,  9 Apr 2021 12:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1617972463; x=1619786864; bh=U5GyY3Hr3yNOehxV+yAai293DXLkhHxSo2e
        8uLW71YQ=; b=DUDjw+YWFnXDfnL5HK4YzjNQEXyooIuUbGDCnsBU2QWoSBsHmN4
        AvN5hHN8ciXrUonx0XaaTBH+Z3skmNgqzCDZ5qTn+H2SSIxcpykNKm++OMRNUeiK
        QBn3rxHY6cPvLZhO1BwjYmv2/6IoUecW96EIeLbggVioFmS/K9jzk20E=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ATBlxAlgacWt; Fri,  9 Apr 2021 15:47:43 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BC077414B6;
        Fri,  9 Apr 2021 15:32:50 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.255) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Apr 2021 15:32:50 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v3 6/7] target: ibm_vscsi: replace enable attr to ops.enable
Date:   Fri, 9 Apr 2021 15:32:37 +0300
Message-ID: <20210409123238.26671-7-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210409123238.26671-1-d.bogdanov@yadro.com>
References: <20210409123238.26671-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.255]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove tpg/enable attribute.
Add fabric ops enable_tpg implementation instead.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 42 +++---------------------
 1 file changed, 4 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 9abd9e253af6..90129a6c3496 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3956,41 +3956,16 @@ static struct configfs_attribute *ibmvscsis_wwn_attrs[] = {
 	NULL,
 };
 
-static ssize_t ibmvscsis_tpg_enable_show(struct config_item *item,
-					 char *page)
-{
-	struct se_portal_group *se_tpg = to_tpg(item);
-	struct ibmvscsis_tport *tport = container_of(se_tpg,
-						     struct ibmvscsis_tport,
-						     se_tpg);
 
-	return snprintf(page, PAGE_SIZE, "%d\n", (tport->enabled) ? 1 : 0);
-}
-
-static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
-					  const char *page, size_t count)
+static int ibmvscsis_enable_tpg(struct se_portal_group *se_tpg, bool enable)
 {
-	struct se_portal_group *se_tpg = to_tpg(item);
 	struct ibmvscsis_tport *tport = container_of(se_tpg,
 						     struct ibmvscsis_tport,
 						     se_tpg);
 	struct scsi_info *vscsi = container_of(tport, struct scsi_info, tport);
-	unsigned long tmp;
-	int rc;
 	long lrc;
 
-	rc = kstrtoul(page, 0, &tmp);
-	if (rc < 0) {
-		dev_err(&vscsi->dev, "Unable to extract srpt_tpg_store_enable\n");
-		return -EINVAL;
-	}
-
-	if ((tmp != 0) && (tmp != 1)) {
-		dev_err(&vscsi->dev, "Illegal value for srpt_tpg_store_enable\n");
-		return -EINVAL;
-	}
-
-	if (tmp) {
+	if (enable) {
 		spin_lock_bh(&vscsi->intr_lock);
 		tport->enabled = true;
 		lrc = ibmvscsis_enable_change_state(vscsi);
@@ -4006,17 +3981,8 @@ static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
 		spin_unlock_bh(&vscsi->intr_lock);
 	}
 
-	dev_dbg(&vscsi->dev, "tpg_enable_store, tmp %ld, state %d\n", tmp,
-		vscsi->state);
-
-	return count;
+	return 0;
 }
-CONFIGFS_ATTR(ibmvscsis_tpg_, enable);
-
-static struct configfs_attribute *ibmvscsis_tpg_attrs[] = {
-	&ibmvscsis_tpg_attr_enable,
-	NULL,
-};
 
 static const struct target_core_fabric_ops ibmvscsis_ops = {
 	.module				= THIS_MODULE,
@@ -4046,10 +4012,10 @@ static const struct target_core_fabric_ops ibmvscsis_ops = {
 	.fabric_make_wwn		= ibmvscsis_make_tport,
 	.fabric_drop_wwn		= ibmvscsis_drop_tport,
 	.fabric_make_tpg		= ibmvscsis_make_tpg,
+	.fabric_enable_tpg		= ibmvscsis_enable_tpg,
 	.fabric_drop_tpg		= ibmvscsis_drop_tpg,
 
 	.tfc_wwn_attrs			= ibmvscsis_wwn_attrs,
-	.tfc_tpg_base_attrs		= ibmvscsis_tpg_attrs,
 };
 
 static void ibmvscsis_dev_release(struct device *dev) {};
-- 
2.25.1

