Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5CAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 12:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37FCD610D1
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 12:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbhJLMdg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 08:33:36 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3967 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236456AbhJLMde (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 08:33:34 -0400
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HTFL54mJLz67yVC;
        Tue, 12 Oct 2021 20:27:41 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 14:31:30 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 13:31:27 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 0/4] hisi_sas: Some misc patches for next
Date:   Tue, 12 Oct 2021 20:26:24 +0800
Message-ID: <1634041588-74824-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This small series includes the following:
- Relocate the init device functionality to a more appropriate location
- Make the phy control function synchronous
- For faulty SATA disk, disable their phy to stop spinning in the error
  handler
- For previous patch we need to export a libsas phy control function

Thanks!

Luo Jiaxing (2):
  scsi: libsas: Export sas_phy_enable()
  scsi: hisi_sas: Disable SATA disk phy for severe I_T nexus reset
    failure

Xiang Chen (2):
  scsi: hisi_sas: Initialise devices in .slave_alloc callback
  scsi: hisi_sas: Wait for phyup in hisi_sas_control_phy()

 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 89 ++++++++++++++++++++------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 13 +---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 19 ++----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 11 +---
 drivers/scsi/libsas/sas_init.c         |  3 +-
 include/scsi/libsas.h                  |  1 +
 7 files changed, 84 insertions(+), 53 deletions(-)

-- 
2.26.2

