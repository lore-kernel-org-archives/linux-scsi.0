Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126EBC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Dec 2022 09:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiLUJcC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 04:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbiLUJbx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 04:31:53 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C96318385;
        Wed, 21 Dec 2022 01:31:49 -0800 (PST)
Received: from dggpemm500012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NcSlG55HvzqT5Y;
        Wed, 21 Dec 2022 17:27:22 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 21 Dec 2022 17:31:47 +0800
From:   Xingui Yang <yangxingui@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.g.garry@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <yangxingui@huawei.com>,
        <prime.zeng@hisilicon.com>, <kangfenglong@huawei.com>
Subject: [PATCH v3 0/3] Directly kick-off EH when device removed with active IO
Date:   Wed, 21 Dec 2022 09:25:11 +0000
Message-ID: <20221221092514.4091-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches solve the age-old problem - that is, EH eventually
kicking in only after 30 seconds when a disk is removed with active IO.

This series add a new libsas API - sas_device_task_abort() - to abort
device active io and define a interface lldd_device_task_abort() for
LLDD to implement.

Changes since v2:
- Support both for sas and sata device
- Add a new libsas API
- LLDD implement lldd_device_task_abort()

Xingui Yang (3):
  scsi: libsas: Add sas_device_task_abort()
  scsi: libsas: Directly kick-off EH when device removed with active IO
  scsi: hisi_sas: Implement lldd_device_task_abort()

 drivers/scsi/hisi_sas/hisi_sas_main.c | 19 +++++++++++++++++++
 drivers/scsi/libsas/sas_discover.c    |  3 +++
 drivers/scsi/libsas/sas_scsi_host.c   |  9 +++++++++
 include/scsi/libsas.h                 |  2 ++
 4 files changed, 33 insertions(+)

-- 
2.17.1

