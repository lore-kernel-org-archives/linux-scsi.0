Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C5EC49EA2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAF6661369
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhFPDry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:47:54 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7286 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhFPDry (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 23:47:54 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G4WDZ5q2tz1BMVP;
        Wed, 16 Jun 2021 11:40:46 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 11:45:46 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 11:45:44 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Sumit Saxena" <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "megaraidlinux . pdl" <megaraidlinux.pdl@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 2/4] scsi: qedf: use DEVICE_ATTR_RO macro
Date:   Wed, 16 Jun 2021 11:44:17 +0800
Message-ID: <20210616034419.725-3-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210616034419.725-1-thunder.leizhen@huawei.com>
References: <20210616034419.725-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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


