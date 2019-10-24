Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D656CA9EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D43632070B
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409420AbfJXOYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:24:53 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:32896 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409401AbfJXOYx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:24:53 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 50CF9A534B6008F833E7;
        Thu, 24 Oct 2019 22:24:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:24:39 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <hare@suse.com>,
        <ming.lei@redhat.com>, "John Garry" <john.garry@huawei.com>
Subject: [PATCH 0/6] hisi_sas: Expose multiple hw queues for v3 hw as experimental
Date:   Thu, 24 Oct 2019 22:21:15 +0800
Message-ID: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series adds support to expose multiple hw queues for SCSI mid-layer
as an experimental feature.

For now it is experimental due to known CPU hotplug issue for managed
interrupts.

So now we have two module parameters to enable managed interrupts for v3
hw driver:
- auto_affine_msi_experimental:
Use managed interrupts plus and manage reply map internally. Use
request tag for IPTT (apart from reserved commands).
- expose_mq_experimental
Use managed interrupts plus and expose multipe hw queues. Manage IPTT
internally with sbitmap.

Paramater auto_affine_msi_experimental shows better performance (than
expose_mq_experimental), so we need to maintain it for now to stop
complaints about performance regression (even though enabling this
parameter is unsafe).

I want to remove these module parameters ASAP.

This series also includes a change to convert the driver to use sbitmap
where possible for managing IPTT.

This series is based on 5.4 + [0], even though being advertised for
topic-sas-5.4 dev branch. Sorry for send before that is merged, but I just
wanted to get these posted.

[0] https://lore.kernel.org/linux-scsi/1571674935-108326-1-git-send-email-john.garry@huawei.com/T/#t


John Garry (6):
  scsi: hisi_sas: Use sbitmap for IPTT management
  scsi: hisi_sas: Pass scsi_cmnd pointer to hisi_sas_hw.slot_index_alloc
  scsi: hisi_sas: Add bitmaps_alloc_v3_hw()
  scsi: hisi_sas: Add slot_index_alloc_v3_hw() and
    slot_index_free_v3_hw()
  scsi: hisi_sas: Split interrupt_init_v3_hw()
  scsi: hisi_sas: Expose multiple hw queues for v3 as experimental

 drivers/scsi/hisi_sas/hisi_sas.h       |  12 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 135 ++++++++++++-------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 110 +++++++++++++-------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 100 ++++++++++++++++--
 4 files changed, 242 insertions(+), 115 deletions(-)

-- 
2.17.1

