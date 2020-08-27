Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EB5C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 13:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE06622CAE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 13:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgH0NFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 09:05:41 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10334 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbgH0NAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 09:00:00 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5CD0C349B6ABD8A98A5C;
        Thu, 27 Aug 2020 20:59:58 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 20:59:51 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <sathya.prakash@broadcom.com>, <sreekanth.reddy@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>,
        <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: mptscsih: remove set but not used 'timeleft'
Date:   Thu, 27 Aug 2020 20:59:25 +0800
Message-ID: <20200827125925.428357-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/message/fusion/mptscsih.c: In function ‘mptscsih_IssueTaskMgmt’:
drivers/message/fusion/mptscsih.c:1519:17: warning: variable ‘timeleft’
set but not used [-Wunused-but-set-variable]
 1519 |  unsigned long  timeleft;
      |                 ^~~~~~~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/message/fusion/mptscsih.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 8543f0324d5a..a5ef9faf71c7 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1516,7 +1516,6 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, u64 lun,
 	int		 ii;
 	int		 retval;
 	MPT_ADAPTER 	*ioc = hd->ioc;
-	unsigned long	 timeleft;
 	u8		 issue_hard_reset;
 	u32		 ioc_raw_state;
 	unsigned long	 time_count;
@@ -1614,7 +1613,7 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, u64 lun,
 		}
 	}
 
-	timeleft = wait_for_completion_timeout(&ioc->taskmgmt_cmds.done,
+	wait_for_completion_timeout(&ioc->taskmgmt_cmds.done,
 		timeout*HZ);
 	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
 		retval = FAILED;
-- 
2.25.4

