Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE73C8300B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 12:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F592076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 12:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgD3MSi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:18:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3402 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbgD3MSh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 08:18:37 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CE7CA85C2F6A35573474;
        Thu, 30 Apr 2020 20:18:34 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Apr 2020
 20:18:26 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <himanshu.madhani@oracle.com>, <aeasi@marvell.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] scsi: qla2xxx: use true,false for need_mpi_reset
Date:   Thu, 30 Apr 2020 20:17:51 +0800
Message-ID: <20200430121751.15232-1-yanaijie@huawei.com>
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

Fix the following coccicheck warning:

drivers/scsi/qla2xxx/qla_tmpl.c:1031:6-20: WARNING: Assignment of 0/1 to
bool variable
drivers/scsi/qla2xxx/qla_tmpl.c:1062:3-17: WARNING: Assignment of 0/1 to
bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 819c46f31c05..281973b317a8 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -1028,7 +1028,7 @@ void
 qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	ulong flags = 0;
-	bool need_mpi_reset = 1;
+	bool need_mpi_reset = true;
 
 #ifndef __CHECKER__
 	if (!hardware_locked)
@@ -1059,7 +1059,7 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 			       "-> fwdt1 fwdump residual=%+ld\n",
 			       fwdt->dump_size - len);
 		} else {
-			need_mpi_reset = 0;
+			need_mpi_reset = false;
 		}
 
 		vha->hw->mpi_fw_dump_len = len;
-- 
2.21.1

