Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B3BC6FA86
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiI0CTK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiI0CTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:19:08 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D3D93233;
        Mon, 26 Sep 2022 19:19:06 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mc3Cj0VmjzHq6C;
        Tue, 27 Sep 2022 10:16:49 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 10:19:04 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>, <bvanassche@acm.org>,
        <john.garry@huawei.com>, <jinpu.wang@cloud.ionos.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 1/8] scsi: libsas: introduce sas address comparation helpers
Date:   Tue, 27 Sep 2022 10:29:34 +0800
Message-ID: <20220927022941.4029476-2-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927022941.4029476-1-yanaijie@huawei.com>
References: <20220927022941.4029476-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sas address comparation is widely used in libsas. However they are all
opencoded and to avoid the line spill over 80 columns, are mostly split
into multi-lines. Introduce some helpers to prepare some refactor.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_internal.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 8d0ad3abc7b5..3384429b7eb0 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -111,6 +111,23 @@ static inline void sas_smp_host_handler(struct bsg_job *job,
 }
 #endif
 
+static inline bool sas_phy_match_dev_addr(struct domain_device *dev,
+					 struct ex_phy *phy)
+{
+	return SAS_ADDR(dev->sas_addr) == SAS_ADDR(phy->attached_sas_addr);
+}
+
+static inline bool sas_phy_match_port_addr(struct asd_sas_port *port,
+					   struct ex_phy *phy)
+{
+	return SAS_ADDR(port->sas_addr) == SAS_ADDR(phy->attached_sas_addr);
+}
+
+static inline bool sas_phy_addr_match(struct ex_phy *p1, struct ex_phy *p2)
+{
+	return  SAS_ADDR(p1->attached_sas_addr) == SAS_ADDR(p2->attached_sas_addr);
+}
+
 static inline void sas_fail_probe(struct domain_device *dev, const char *func, int err)
 {
 	pr_warn("%s: for %s device %016llx returned %d\n",
-- 
2.31.1

