Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3497CC4167E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Nov 2022 11:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiKULRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 06:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiKULQg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 06:16:36 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21FD1D646
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 03:12:01 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NG4Nb0FPqzqSZb;
        Mon, 21 Nov 2022 19:07:27 +0800 (CST)
Received: from dggpeml500003.china.huawei.com (7.185.36.200) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 19:11:20 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500003.china.huawei.com
 (7.185.36.200) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 19:11:19 +0800
From:   Yu Liao <liaoyu15@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <liaoyu15@huawei.com>, <liwei391@huawei.com>
Subject: [PATCH] scsi: qla2xxx: Simplify condition check in qlt_free_session_done
Date:   Mon, 21 Nov 2022 19:09:15 +0800
Message-ID: <20221121110915.3450528-1-liaoyu15@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500003.china.huawei.com (7.185.36.200)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

!A || (A && B) is equivalent to !A || B. Hence, simplify condition.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index bb754a950802..1e3e38d35968 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1028,8 +1028,7 @@ void qlt_free_session_done(struct work_struct *work)
 		}
 
 		if (ha->flags.edif_enabled &&
-		    (!own || (own &&
-			      own->iocb.u.isp24.status_subcode == ELS_PLOGI))) {
+		    (!own || own->iocb.u.isp24.status_subcode == ELS_PLOGI)) {
 			sess->edif.authok = 0;
 			if (!ha->flags.host_shutting_down) {
 				ql_dbg(ql_dbg_edif, vha, 0x911e,
-- 
2.25.1

