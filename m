Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE57C6FD1F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Mar 2023 03:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCTDDw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Mar 2023 23:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCTDDt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Mar 2023 23:03:49 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CDC1997
        for <linux-scsi@vger.kernel.org>; Sun, 19 Mar 2023 20:03:47 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Pg0196spKz9tMR;
        Mon, 20 Mar 2023 11:03:25 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 11:03:45 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 0/4] scsi: hisi_sas: Some misc changes
Date:   Mon, 20 Mar 2023 11:34:21 +0800
Message-ID: <1679283265-115066-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

This series contain some fixes including:
- Grab sas_dev lock when traversing sas_dev list to avoid NULL pointer
- Handle NCQ error when IPTT is valid
- Ensure all enabled PHYs up during controller reset
- Exit suspend state when usage count of runtime PM is greater than 0

Xingui Yang (2):
  scsi: hisi_sas: Grab sas_dev lock when traversing the members of
    sas_dev.list
  scsi: hisi_sas: Handle NCQ error when IPTT is valid

Yihang Li (2):
  scsi: hisi_sas: Ensure all enabled PHYs up during controller reset
  scsi: hisi_sas: Exit suspending state when usage count is greater than
    0

 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 57 ++++++++++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  8 +++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  8 +++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 83 ++++++++++++++++++++++++++--------
 5 files changed, 124 insertions(+), 35 deletions(-)

-- 
2.8.1

