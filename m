Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD22C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 08:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 691C0611AD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 08:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhIJInA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 04:43:00 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:53640 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231795AbhIJIm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Sep 2021 04:42:57 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E3E954CF61;
        Fri, 10 Sep 2021 08:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1631263304; x=1633077705; bh=WCqdR0lGNhKsChBagkOCR9grMUl7iqFBpw/
        /TuTbXXc=; b=iyiy+DEBnl3DoUgsWgRMoGjY0m/StOABp40o321J1gffg/X5wP8
        KAjMrDiD5Cf5QIY2QYVMkeLuZjtSk/WfSaPPSsVbJm0PJN959xvhERHtWApE4UPL
        WUSdlXQrCgCJGDOEPhbvWExMNn9bOdPEQePal+OOxNXvA6YIpg2AhW4U=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8M-jI3cpE0n1; Fri, 10 Sep 2021 11:41:44 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8BF5F4B951;
        Fri, 10 Sep 2021 11:41:43 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.141) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 10 Sep 2021 11:41:42 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v5 5/7] target: srpt replace enable attr to ops.enable
Date:   Fri, 10 Sep 2021 11:41:31 +0300
Message-ID: <20210910084133.17956-6-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210910084133.17956-1-d.bogdanov@yadro.com>
References: <20210910084133.17956-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.141]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
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
index 3cadf1295417..f86ee1c4b970 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3705,47 +3705,17 @@ static struct configfs_attribute *srpt_da_attrs[] = {
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
@@ -3856,12 +3826,12 @@ static const struct target_core_fabric_ops srpt_template = {
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

