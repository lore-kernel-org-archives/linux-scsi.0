Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2365FC4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 08:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0998761166
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 08:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbhDPIlR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 04:41:17 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:42072 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239906AbhDPIlN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Apr 2021 04:41:13 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DE08641377;
        Fri, 16 Apr 2021 08:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1618562438; x=1620376839; bh=MljioKK9Xw1yKFwQF9/j/BzhwzTYi1mN83C
        qqgDv1ZM=; b=Ju2XJB6W3lcysCGC1wK15pQvK2l1ucijf+keMBDjwEmx+lDICAk
        ktqDg1uNLwOsAZaUGoXnCjWIk2rUvclNhEDvAxdmL4uBnwc/slZhiJ6QVPdj5Tao
        qWmFxF0dhCORts4rmdPFH6pJ/+Zw9T0IILjP8oa+/+CSBtQnYzpdNlo4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fuiQrMObLiVJ; Fri, 16 Apr 2021 11:40:38 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 25B434138D;
        Fri, 16 Apr 2021 11:40:38 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.63) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 16
 Apr 2021 11:40:37 +0300
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
Subject: [PATCH v4 5/7] target: srpt replace enable attr to ops.enable
Date:   Fri, 16 Apr 2021 11:26:30 +0300
Message-ID: <20210416082632.2000-6-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416082632.2000-1-d.bogdanov@yadro.com>
References: <20210416082632.2000-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.63]
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
 drivers/infiniband/ulp/srpt/ib_srpt.c | 38 +++------------------------
 1 file changed, 4 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6be60aa5ffe2..527205941347 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3700,47 +3700,17 @@ static struct configfs_attribute *srpt_da_attrs[] = {
 	NULL,
 };
 
-static ssize_t srpt_tpg_enable_show(struct config_item *item, char *page)
+static int srpt_enable_tpg(struct se_portal_group *se_tpg, bool enable)
 {
-	struct se_portal_group *se_tpg = to_tpg(item);
 	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
 
-	return sysfs_emit(page, "%d\n", sport->enabled);
-}
-
-static ssize_t srpt_tpg_enable_store(struct config_item *item,
-		const char *page, size_t count)
-{
-	struct se_portal_group *se_tpg = to_tpg(item);
-	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
-	unsigned long tmp;
-	int ret;
-
-	ret = kstrtoul(page, 0, &tmp);
-	if (ret < 0) {
-		pr_err("Unable to extract srpt_tpg_store_enable\n");
-		return -EINVAL;
-	}
-
-	if ((tmp != 0) && (tmp != 1)) {
-		pr_err("Illegal value for srpt_tpg_store_enable: %lu\n", tmp);
-		return -EINVAL;
-	}
-
 	mutex_lock(&sport->mutex);
-	srpt_set_enabled(sport, tmp);
+	srpt_set_enabled(sport, enable);
 	mutex_unlock(&sport->mutex);
 
-	return count;
+	return 0;
 }
 
-CONFIGFS_ATTR(srpt_tpg_, enable);
-
-static struct configfs_attribute *srpt_tpg_attrs[] = {
-	&srpt_tpg_attr_enable,
-	NULL,
-};
-
 /**
  * srpt_make_tpg - configfs callback invoked for mkdir /sys/kernel/config/target/$driver/$port/$tpg
  * @wwn: Corresponds to $driver/$port.
@@ -3851,12 +3821,12 @@ static const struct target_core_fabric_ops srpt_template = {
 	.fabric_make_wwn		= srpt_make_tport,
 	.fabric_drop_wwn		= srpt_drop_tport,
 	.fabric_make_tpg		= srpt_make_tpg,
+	.fabric_enable_tpg		= srpt_enable_tpg,
 	.fabric_drop_tpg		= srpt_drop_tpg,
 	.fabric_init_nodeacl		= srpt_init_nodeacl,
 
 	.tfc_discovery_attrs		= srpt_da_attrs,
 	.tfc_wwn_attrs			= srpt_wwn_attrs,
-	.tfc_tpg_base_attrs		= srpt_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= srpt_tpg_attrib_attrs,
 };
 
-- 
2.25.1

