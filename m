Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B889C6FA91
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Sep 2022 10:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiITKgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Sep 2022 06:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiITKfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2022 06:35:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB3172FE3;
        Tue, 20 Sep 2022 03:34:03 -0700 (PDT)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MWyXT02jrz67ww1;
        Tue, 20 Sep 2022 18:32:09 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 12:33:49 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 11:33:47 +0100
From:   John Garry <john.garry@huawei.com>
To:     <damien.lemoal@opensource.wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>, <hch@lst.de>
CC:     <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <brking@us.ibm.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC 0/6] libata/scsi/libsas: Allocate SCSI device earlier for ata port probe
Date:   Tue, 20 Sep 2022 18:27:04 +0800
Message-ID: <1663669630-21333-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently for libata the SCSI device (sdev) associated with an ata_device
is allocated when the port probe has completed.

It's useful to have the SCSI device and its associated request queue
available earlier for the port probe. Specifically if we have the
request queue available, then we can:
- Easily put ATA qc in SCSI cmnd priv data
- Send ATA internal commands on SCSI device request queue for [0]. The
  current solution there is to use the shost sdev request queue, which
  isn't great.
  
This series changes the ata port probe to alloc the sdev in the
ata_device revalidation, and then just do a SCSI starget scan afterwards.

Why an RFC?
1. IPR  driver needs to be fixed up - it does not use ATA EH port probe
   Mail [1] needs following up
2. SATA PMP support needs verification, but I don't have a setup
3. This series needs to be merged into or go after [0]

Patch 1/6 could be merged now.

[0] https://lore.kernel.org/linux-ide/1654770559-101375-1-git-send-email-john.garry@huawei.com/
[1] https://lore.kernel.org/linux-ide/369448ed-f89a-c2db-1850-91450d8b5998@opensource.wdc.com/

Any comments welcome - please have a look.

Based on v6.0-rc4 and tested for QEMU AHCI and libsas.

John Garry (6):
  scsi: core: Use SCSI_SCAN_RESCAN in  __scsi_add_device()
  scsi: scsi_transport_sas: Allocate end device target id in the rphy
    alloc
  scsi: core: Add scsi_get_dev()
  ata: libata-scsi: Add ata_scsi_setup_sdev()
  scsi: libsas: Add sas_ata_setup_device()
  ata: libata-scsi: Allocate sdev early in port probe

 drivers/ata/libata-eh.c           |  4 +++
 drivers/ata/libata-scsi.c         | 45 +++++++++++++++++++++----------
 drivers/ata/libata.h              |  1 +
 drivers/scsi/libsas/sas_ata.c     | 20 ++++++++++++++
 drivers/scsi/scsi_scan.c          | 28 ++++++++++++++++++-
 drivers/scsi/scsi_transport_sas.c | 25 +++++++++++------
 include/linux/libata.h            |  2 ++
 include/scsi/scsi_host.h          |  3 +++
 8 files changed, 105 insertions(+), 23 deletions(-)

-- 
2.35.3

