Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CC4C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 06:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57CA761165
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 06:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhDHGTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 02:19:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15962 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbhDHGT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 02:19:29 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FG9yp52Z9zyNZ9;
        Thu,  8 Apr 2021 14:17:06 +0800 (CST)
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
Subject: [PATCH 3/3] scsi: mptfusion: Fix error return code of mptctl_hp_hostinfo()
Date:   Thu, 8 Apr 2021 14:18:51 +0800
Message-ID: <20210408061851.3089-4-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210408061851.3089-1-thunder.leizhen@huawei.com>
References: <20210408061851.3089-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.202]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ensure that all "goto out" error branches return correct error codes.
Currently, always returns 0.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/message/fusion/mptctl.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 72025996cd70..57bf511245b6 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2326,7 +2326,7 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 	ToolboxIstwiReadWriteRequest_t	*IstwiRWRequest;
 	MPT_FRAME_HDR		*mf = NULL;
 	unsigned long		timeleft;
-	int			retval;
+	int			retval = 0;
 	u32			msgcontext;
 
 	/* Reset long to int. Should affect IA64 and SPARC only
@@ -2453,6 +2453,7 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT
 			"%s, no msg frames!!\n", ioc->name, __func__));
+		retval = -EFAULT;
 		goto out;
 	}
 
@@ -2471,12 +2472,13 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 		IstwiRWRequest->DeviceAddr = 0xB0;
 
 	pbuf = pci_alloc_consistent(ioc->pcidev, 4, &buf_dma);
-	if (!pbuf)
+	if (!pbuf) {
+		retval = -ENOMEM;
 		goto out;
+	}
 	ioc->add_sge((char *)&IstwiRWRequest->SGL,
 	    (MPT_SGE_FLAGS_SSIMPLE_READ|4), buf_dma);
 
-	retval = 0;
 	SET_MGMT_MSG_CONTEXT(ioc->ioctl_cmds.msg_context,
 				IstwiRWRequest->MsgContext);
 	INITIALIZE_MGMT_STATUS(ioc->ioctl_cmds.status)
@@ -2486,10 +2488,10 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 	timeleft = wait_for_completion_timeout(&ioc->ioctl_cmds.done,
 			HZ*MPT_IOCTL_DEFAULT_TIMEOUT);
 	if (!(ioc->ioctl_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
-		retval = -ETIME;
 		printk(MYIOC_s_WARN_FMT "%s: failed\n", ioc->name, __func__);
 		if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET) {
 			mpt_free_msg_frame(ioc, mf);
+			retval = -ETIME;
 			goto out;
 		}
 		if (!timeleft) {
@@ -2497,9 +2499,11 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 			       "HOST INFO command timeout, doorbell=0x%08x\n",
 			       ioc->name, mpt_GetIocState(ioc, 0));
 			mptctl_timeout_expired(ioc, mf);
-		} else
-			goto retry_wait;
-		goto out;
+			retval = -ETIME;
+			goto out;
+		}
+
+		goto retry_wait;
 	}
 
 	/*
@@ -2530,7 +2534,7 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 		return -EFAULT;
 	}
 
-	return 0;
+	return retval;
 
 }
 
-- 
2.21.1


