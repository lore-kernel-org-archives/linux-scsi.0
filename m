Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB50C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 10:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347400AbiCOKuG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 06:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347604AbiCOKsA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 06:48:00 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3240522D6;
        Tue, 15 Mar 2022 03:45:02 -0700 (PDT)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KHqlb4ryTz6809b;
        Tue, 15 Mar 2022 18:44:11 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 15 Mar 2022 11:44:56 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 10:44:53 +0000
From:   John Garry <john.garry@huawei.com>
To:     <damien.lemoal@opensource.wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <bvanassche@acm.org>,
        <ming.lei@redhat.com>, <hch@lst.de>, <hare@suse.de>
CC:     <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <martin.wilck@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 0/2] scsi/libata: A potential tagging fix and improvement
Date:   Tue, 15 Mar 2022 18:39:04 +0800
Message-ID: <1647340746-17600-1-git-send-email-john.garry@huawei.com>
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

Two loosely related patches are included:

- Fix for scsi_realloc_sdev_budget_map(). I noticed that the budget token
  for scsi commands was way in excess of the device queue depth, so I
  think we need to fix the sbitmap depth. I need to test this more.

- libata change to use scsi command budget token for qc tag for SAS host.
  I marked this as RFC as for SAS hosts I don't see anything which
  guarantees that the budget size is <= 32 always.
  For libsas hosts we resize the device depth to 32 in the slave configure
  callback, but this seems an unreliable approach since not all hosts may
  call this.
  In addition, I am worried that even if we resize the device depth
  properly in the slave config callback, we may still try to alloc qc tag
  prior to this - in lun scan, for example.
  So we need a way to guarantee that the device queue depth is <= 32
  always, which I would be open to suggestions for.

John Garry (2):
  scsi: core: Fix sbitmap depth in scsi_realloc_sdev_budget_map()
  libata: Use scsi cmnd budget token for qc tag for SAS host

 drivers/ata/libata-core.c |  5 +++--
 drivers/ata/libata-sata.c | 21 ++++-----------------
 drivers/ata/libata-scsi.c |  2 +-
 drivers/ata/libata.h      |  4 ++--
 drivers/scsi/scsi_scan.c  |  5 +++++
 include/linux/libata.h    |  1 -
 6 files changed, 15 insertions(+), 23 deletions(-)

-- 
2.26.2

