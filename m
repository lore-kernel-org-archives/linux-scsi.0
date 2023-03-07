Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481E2C678D5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 05:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjCGFjO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 00:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjCGFjL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 00:39:11 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97D43B858
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 21:39:09 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PW42R1Cv8zKq45;
        Tue,  7 Mar 2023 13:37:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 13:38:34 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 0/4] Add poll support for hisi_sas v3 hw
Date:   Tue, 7 Mar 2023 14:09:11 +0800
Message-ID: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

To support IO_URING IOPOLL support for hisi_sas, need to do:
- Add and fill mq_poll interface to poll queue;
- For internal IOs (including internal abort IOs), need to deliver and 
complete them through non-iopoll queue (queue 0);

It only sends internal abort commands to non-poll queue which actually 
requires to send a internal abort command to every queue, so it still has
a risk. Make iopoll support module parameter as "experimental".

I have tested performance on v3 hw with different modes as following, and
it promotes much for 4K READ/WRITE when enabling poll momde:

			4K READ	    4K RANDREAD	    4K WRITE	4K RANDWRITE
interrupt + libaio	1770k	    1316k	    1197k	831k
interrupt + io_uring	1848k	    1390k	    1238k	857k
iopoll + io_uring	2117k	    1364k	    1874k	849k

Xiang Chen (4):
  scsi: hisi_sas: Add function complete_v3_hw()
  scsi: hisi_sas: Add poll support for v3 hw
  scsi: hisi_sas: Sync complete queue for poll queue
  scsi: hisi_sas: Add device attribute experimental_iopoll_q_cnt for v3
    hw

 drivers/scsi/hisi_sas/hisi_sas.h       |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  95 ++++++++++++++++++++++--------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 102 +++++++++++++++++++++++++++++----
 3 files changed, 167 insertions(+), 36 deletions(-)

-- 
2.8.1

