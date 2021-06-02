Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E32AC4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 275A861042
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhFBDCr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 23:02:47 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6130 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhFBDCr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 23:02:47 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fvty31HN8zYpts;
        Wed,  2 Jun 2021 10:58:19 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 11:01:03 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 11:01:02 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: qedf: use DEVICE_ATTR_RO macro
Date:   Wed, 2 Jun 2021 11:00:56 +0800
Message-ID: <20210602030056.10799-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use DEVICE_ATTR_RO macro helper instead of plain DEVICE_ATTR, which makes
the code a bit shorter and easier to read.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/scsi/qedf/qedf_attr.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_attr.c b/drivers/scsi/qedf/qedf_attr.c
index d995f72a67595bd..461c0c9180c444e 100644
--- a/drivers/scsi/qedf/qedf_attr.c
+++ b/drivers/scsi/qedf/qedf_attr.c
@@ -24,9 +24,8 @@ static struct qedf_ctx *qedf_get_base_qedf(struct qedf_ctx *qedf)
 	return lport_priv(base_lport);
 }
 
-static ssize_t
-qedf_fcoe_mac_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
+static ssize_t fcoe_mac_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	struct fc_lport *lport = shost_priv(class_to_shost(dev));
 	u32 port_id;
@@ -42,9 +41,8 @@ qedf_fcoe_mac_show(struct device *dev,
 	return scnprintf(buf, PAGE_SIZE, "%pM\n", fcoe_mac);
 }
 
-static ssize_t
-qedf_fka_period_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
+static ssize_t fka_period_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
 {
 	struct fc_lport *lport = shost_priv(class_to_shost(dev));
 	struct qedf_ctx *qedf = lport_priv(lport);
@@ -59,8 +57,8 @@ qedf_fka_period_show(struct device *dev,
 	return scnprintf(buf, PAGE_SIZE, "%d\n", fka_period);
 }
 
-static DEVICE_ATTR(fcoe_mac, S_IRUGO, qedf_fcoe_mac_show, NULL);
-static DEVICE_ATTR(fka_period, S_IRUGO, qedf_fka_period_show, NULL);
+static DEVICE_ATTR_RO(fcoe_mac);
+static DEVICE_ATTR_RO(fka_period);
 
 struct device_attribute *qedf_host_attrs[] = {
 	&dev_attr_fcoe_mac,
-- 
2.26.0.106.g9fadedd


