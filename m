Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1918AC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 06:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB9C207F5
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 06:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgGaGx4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 02:53:56 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8309 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731435AbgGaGx4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 31 Jul 2020 02:53:56 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2F1BC2A61A13C4F4A6A4;
        Fri, 31 Jul 2020 14:53:54 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 14:53:47 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jingxiangfeng@huawei.com>
Subject: [PATCH] scsi: lpfc: Add the missed misc_deregister() for lpfc_init()
Date:   Fri, 31 Jul 2020 14:56:39 +0800
Message-ID: <20200731065639.190646-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_init() misses to call misc_deregister() in an error path. Add a
label 'unregister' to fix it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6637f84a3d1b..ec40bc91e124 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13982,17 +13982,18 @@ lpfc_init(void)
 		printk(KERN_ERR "Could not register lpfcmgmt device, "
 			"misc_register returned with status %d", error);
 
+	error = -ENOMEM;
 	lpfc_transport_functions.vport_create = lpfc_vport_create;
 	lpfc_transport_functions.vport_delete = lpfc_vport_delete;
 	lpfc_transport_template =
 				fc_attach_transport(&lpfc_transport_functions);
 	if (lpfc_transport_template == NULL)
-		return -ENOMEM;
+		goto unregister;
 	lpfc_vport_transport_template =
 		fc_attach_transport(&lpfc_vport_transport_functions);
 	if (lpfc_vport_transport_template == NULL) {
 		fc_release_transport(lpfc_transport_template);
-		return -ENOMEM;
+		goto unregister;
 	}
 	lpfc_nvme_cmd_template();
 	lpfc_nvmet_cmd_template();
@@ -14018,6 +14019,8 @@ lpfc_init(void)
 cpuhp_failure:
 	fc_release_transport(lpfc_transport_template);
 	fc_release_transport(lpfc_vport_transport_template);
+unregister:
+	misc_deregister(&lpfc_mgmt_dev);
 
 	return error;
 }
-- 
2.17.1

