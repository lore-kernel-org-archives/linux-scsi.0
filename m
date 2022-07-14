Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEA8C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 18:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbiGNS3r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 14:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiGNS3q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 14:29:46 -0400
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D731E275EF;
        Thu, 14 Jul 2022 11:29:45 -0700 (PDT)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.156.149])
        by sinmsgout01.his.huawei.com (SkyGuard) with ESMTP id 4LkNFF60MVz9xF8b;
        Fri, 15 Jul 2022 02:24:49 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Jul 2022 20:29:39 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Jul 2022 19:29:37 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH 0/5] hisi_sas/libsas: Some misc patches
Date:   Fri, 15 Jul 2022 02:23:17 +0800
Message-ID: <1657823002-139010-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This is just some random patches which I have collected for the hisi_sas
driver and libsas over the last cycle, described briefly as follows:
- Remove some duplication in slave_configure_v3_hw()
- Some DMA mapping API usage tidying
- v3 HW SATA completion error processing improvement
- For libsas, resume host when changing phy settings via sysfs - our test
  guys seem to find it useful.

Thanks in advance, John

John Garry (1):
  scsi: hisi_sas: Call hisi_sas_slave_configure() from
    slave_configure_v3_hw()

Xiang Chen (3):
  scsi: hisi_sas: Remove unnecessary variable to hold DMA map elements
  scsi: hisi_sas: Relocate DMA unmap of SMP task
  scsi: libsas: Resume SAS host for phy reset or enable via sysfs

Xingui Yang (1):
  scsi: hisi_sas: Modify v3 HW SATA completion error processing

 drivers/scsi/hisi_sas/hisi_sas_main.c  | 49 ++++++++++++--------------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  2 --
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  2 --
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 16 +++++----
 drivers/scsi/libsas/sas_init.c         |  4 +++
 5 files changed, 36 insertions(+), 37 deletions(-)

-- 
2.35.3

