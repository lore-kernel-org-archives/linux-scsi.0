Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8413C43461
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 06:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 818BD61178
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 06:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhDHGTi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 02:19:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16037 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhDHGT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 02:19:29 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FG9y66sp2zPp06;
        Thu,  8 Apr 2021 14:16:30 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.179.202) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 14:19:08 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux . pdl" <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 2/3] scsi: mptfusion: Remove unused local variable 'port'
Date:   Thu, 8 Apr 2021 14:18:50 +0800
Message-ID: <20210408061851.3089-3-thunder.leizhen@huawei.com>
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

drivers/message/fusion/mptctl.c: In function ‘mptctl_gettargetinfo
drivers/message/fusion/mptctl.c:1372:7: warning: variable ‘port’ set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/message/fusion/mptctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 0a9321239e76..72025996cd70 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1367,7 +1367,6 @@ mptctl_gettargetinfo (MPT_ADAPTER *ioc, unsigned long arg)
 	int			lun;
 	int			maxWordsLeft;
 	int			numBytes;
-	u8			port;
 	struct scsi_device 	*sdev;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_targetinfo))) {
@@ -1379,13 +1378,8 @@ mptctl_gettargetinfo (MPT_ADAPTER *ioc, unsigned long arg)
 
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_gettargetinfo called.\n",
 	    ioc->name));
-	/* Get the port number and set the maximum number of bytes
-	 * in the returned structure.
-	 * Ignore the port setting.
-	 */
 	numBytes = karg.hdr.maxDataSize - sizeof(mpt_ioctl_header);
 	maxWordsLeft = numBytes/sizeof(int);
-	port = karg.hdr.port;
 
 	if (maxWordsLeft <= 0) {
 		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_gettargetinfo() - no memory available!\n",
-- 
2.21.1


