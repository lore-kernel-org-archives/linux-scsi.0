Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E17C49361
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40F21610A2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhFPDrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:47:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7447 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhFPDrv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 23:47:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4WGx3cc9zZhk2;
        Wed, 16 Jun 2021 11:42:49 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 11:45:44 +0800
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
Subject: [PATCH v2 1/4] scsi: qedi: use DEVICE_ATTR_RO macro
Date:   Wed, 16 Jun 2021 11:44:16 +0800
Message-ID: <20210616034419.725-2-thunder.leizhen@huawei.com>
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
 drivers/scsi/qedi/qedi_sysfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_sysfs.c b/drivers/scsi/qedi/qedi_sysfs.c
index 04ee68e6499c912..be174d30eb7c275 100644
--- a/drivers/scsi/qedi/qedi_sysfs.c
+++ b/drivers/scsi/qedi/qedi_sysfs.c
@@ -16,9 +16,9 @@ static inline struct qedi_ctx *qedi_dev_to_hba(struct device *dev)
 	return iscsi_host_priv(shost);
 }
 
-static ssize_t qedi_show_port_state(struct device *dev,
-				    struct device_attribute *attr,
-				    char *buf)
+static ssize_t port_state_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
 {
 	struct qedi_ctx *qedi = qedi_dev_to_hba(dev);
 
@@ -28,8 +28,8 @@ static ssize_t qedi_show_port_state(struct device *dev,
 		return sprintf(buf, "Linkdown\n");
 }
 
-static ssize_t qedi_show_speed(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static ssize_t speed_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
 {
 	struct qedi_ctx *qedi = qedi_dev_to_hba(dev);
 	struct qed_link_output if_link;
@@ -39,8 +39,8 @@ static ssize_t qedi_show_speed(struct device *dev,
 	return sprintf(buf, "%d Gbit\n", if_link.speed / 1000);
 }
 
-static DEVICE_ATTR(port_state, 0444, qedi_show_port_state, NULL);
-static DEVICE_ATTR(speed, 0444, qedi_show_speed, NULL);
+static DEVICE_ATTR_RO(port_state);
+static DEVICE_ATTR_RO(speed);
 
 struct device_attribute *qedi_shost_attrs[] = {
 	&dev_attr_port_state,
-- 
2.26.0.106.g9fadedd


