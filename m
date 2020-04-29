Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928C0C83006
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 14:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E7EF20B80
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 14:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgD2OKf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 10:10:35 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3384 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726691AbgD2OKe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 10:10:34 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 53D43B3A7432DA87A112;
        Wed, 29 Apr 2020 22:10:33 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Apr 2020
 22:10:26 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <hmadhani@marvell.com>, <joe.carnuccio@cavium.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] scsi: qla2xxx: Make qla_set_ini_mode() return void
Date:   Wed, 29 Apr 2020 22:09:52 +0800
Message-ID: <20200429140952.8240-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The return value is not used by the caller and the local variable 'rc'
is not needed. So make qla_set_ini_mode() return void and remove 'rc'.
This also fixes the following coccicheck warning:

drivers/scsi/qla2xxx/qla_attr.c:1906:5-7: Unneeded variable: "rc".
Return "0" on line 2180

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 4cfebf34ad7c..ca7118982c12 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1925,9 +1925,8 @@ static char *mode_to_str[] = {
 };
 
 #define NEED_EXCH_OFFLOAD(_exchg) ((_exchg) > FW_DEF_EXCHANGES_CNT)
-static int qla_set_ini_mode(scsi_qla_host_t *vha, int op)
+static void qla_set_ini_mode(scsi_qla_host_t *vha, int op)
 {
-	int rc = 0;
 	enum {
 		NO_ACTION,
 		MODE_CHANGE_ACCEPT,
@@ -2200,8 +2199,6 @@ static int qla_set_ini_mode(scsi_qla_host_t *vha, int op)
 		    vha->ql2xexchoffld, vha->u_ql2xexchoffld);
 		break;
 	}
-
-	return rc;
 }
 
 static ssize_t
-- 
2.21.1

