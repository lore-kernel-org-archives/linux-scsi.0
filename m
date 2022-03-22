Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E66C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 10:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiCVKrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 06:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiCVKrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 06:47:10 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A3912752;
        Tue, 22 Mar 2022 03:45:42 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN7PY4fsNz67Q1X;
        Tue, 22 Mar 2022 18:43:29 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 22 Mar 2022 11:45:39 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 10:45:36 +0000
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
        <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hch@lst.de>, <ming.lei@redhat.com>,
        <hare@suse.de>
CC:     <chenxiang66@hisilicon.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <dm-devel@redhat.com>,
        <beanhuo@micron.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH RFC 00/11] blk-mq/libata/scsi: SCSI driver tagging improvements
Date:   Tue, 22 Mar 2022 18:39:34 +0800
Message-ID: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently SCSI low-level drivers are required to manage tags for commands
which do not come via the block layer - libata internal commands would be
an example of one of these.

There was some work to provide "reserved commands" support in such series
as https://lore.kernel.org/linux-scsi/20211125151048.103910-1-hare@suse.de/

This was based on allocating a request for the lifetime of the "internal"
command.

This series tries to solve that problem by not just allocating the request
but also sending it through the block layer, that being the normal flow
for a request. We need to do this as we may only poll completion of
requests through the block layer, so would need to do this for poll queue
support.

There is still scope to allocate commands just to get a tag as token as
that may suit some other scenarios, but it's not what we do here.

This series extends blk-mq to support a request queue having a custom set
of ops. In addition SCSI core code adds support for these type of requests.

This series does not include SCSI core handling for enabling reserved
tags per tagset, but that would be easy to add.

Based on mkp-scsi 5.18/scsi-staging @ 66daf3e6b993 

Please consider as an RFC for now. I think that the libata change has the
largest scope for improvement...

John Garry (11):
  blk-mq: Add blk_mq_init_queue_ops()
  scsi: core: Add SUBMITTED_BY_SCSI_CUSTOM_OPS
  libata: Send internal commands through the block layer
  scsi: libsas: Send SMP commands through the block layer
  scsi: libsas: Send TMF commands through the block layer
  scsi: core: Add scsi_alloc_request_hwq()
  scsi: libsas: Send internal abort commands through the block layer
  scsi: libsas: Change ATA support to deal with each qc having a SCSI
    command
  scsi: libsas: Add sas_task_to_unique_tag()
  scsi: libsas: Add sas_task_to_hwq()
  scsi: hisi_sas: Remove private tag management

 block/blk-mq.c                         |  23 +++-
 drivers/ata/libata-core.c              | 121 +++++++++++++------
 drivers/md/dm-rq.c                     |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  66 +----------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |   3 +-
 drivers/scsi/libsas/sas_ata.c          |  11 +-
 drivers/scsi/libsas/sas_expander.c     |  38 ++++--
 drivers/scsi/libsas/sas_internal.h     |   1 +
 drivers/scsi/libsas/sas_scsi_host.c    | 153 ++++++++++++++++++++-----
 drivers/scsi/scsi_lib.c                |  14 +++
 include/linux/blk-mq.h                 |   5 +-
 include/scsi/libsas.h                  |   4 +-
 include/scsi/scsi_cmnd.h               |   4 +
 14 files changed, 298 insertions(+), 150 deletions(-)

-- 
2.26.2

