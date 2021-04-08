Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B973FC43462
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 06:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94B68611B0
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 06:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhDHGTj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 02:19:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16036 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhDHGT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 02:19:29 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FG9y66bK6zPnyy;
        Thu,  8 Apr 2021 14:16:30 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.179.202) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 14:19:07 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux . pdl" <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/3] scsi: mptfusion: Remove unused local variable 'time_count'
Date:   Thu, 8 Apr 2021 14:18:49 +0800
Message-ID: <20210408061851.3089-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210408061851.3089-1-thunder.leizhen@huawei.com>
References: <20210408061851.3089-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.202]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning:

drivers/message/fusion/mptctl.c: In function ‘mptctl_do_taskmgmt:
drivers/message/fusion/mptctl.c:324:17: warning: variable ‘time_count’ set but not used [-Wunused-but-set-variable]

Fixes: 7d757f185540 ("[SCSI] mptfusion: Updated SCSI IO IOCTL error handling.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/message/fusion/mptctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 24aebad60366..0a9321239e76 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -321,7 +321,6 @@ mptctl_do_taskmgmt(MPT_ADAPTER *ioc, u8 tm_type, u8 bus_id, u8 target_id)
 	int		 ii;
 	int		 retval;
 	unsigned long	 timeout;
-	unsigned long	 time_count;
 	u16		 iocstatus;
 
 
@@ -383,7 +382,6 @@ mptctl_do_taskmgmt(MPT_ADAPTER *ioc, u8 tm_type, u8 bus_id, u8 target_id)
 		ioc->name, tm_type, timeout));
 
 	INITIALIZE_MGMT_STATUS(ioc->taskmgmt_cmds.status)
-	time_count = jiffies;
 	if ((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
 	    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
 		mpt_put_msg_frame_hi_pri(mptctl_taskmgmt_id, ioc, mf);
-- 
2.21.1


