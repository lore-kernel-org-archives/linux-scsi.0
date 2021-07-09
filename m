Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E167C07E9B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB2C613CF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhGIINQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 04:13:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbhGIINQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 04:13:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625818233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C1gJOuWhuvnc9KCkfOjk/ntBVmRGSL89MKV7NbOH/eY=;
        b=ht3MRcaMd6oKJG0Xx0+sxK5DXoxbzBH1yhsjQ68v/zSG30H3BNyDPn7eKRMtv4nY3dtWQw
        Z3ckHfe7Yui4VXtJqdobHFbjzxChxjmCYsnZ7623iRnxCW52sDhUeMZd9W+wWGNns0y5j7
        IORskpT4xQRGl2zSrMakaDVgaPgYpjE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-GedepIcWMLaOkz_xiC_LYQ-1; Fri, 09 Jul 2021 04:10:29 -0400
X-MC-Unique: GedepIcWMLaOkz_xiC_LYQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67DD0100C609;
        Fri,  9 Jul 2021 08:10:27 +0000 (UTC)
Received: from localhost (ovpn-13-13.pek2.redhat.com [10.72.13.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A8D72C00F;
        Fri,  9 Jul 2021 08:10:16 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 0/10] blk-mq: cleanup map queues & fix blk_mq_alloc_request_hctx
Date:   Fri,  9 Jul 2021 16:09:55 +0800
Message-Id: <20210709081005.421340-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

blk_mq_alloc_request_hctx() is used by NVMe fc/rdma/tcp/loop to connect
io queue. Also the sw ctx is chosen as the 1st online cpu in hctx->cpumask.
However, all cpus in hctx->cpumask may be offline.

This usage model isn't well supported by blk-mq which supposes allocator is
always done on one online CPU in hctx->cpumask. This assumption is
related with managed irq, which also requires blk-mq to drain inflight
request in this hctx when the last cpu in hctx->cpumask is going to
offline.

However, NVMe fc/rdma/tcp/loop don't use managed irq, so we should allow
them to ask for request allocation when the specified hctx is inactive
(all cpus in hctx->cpumask are offline). Fix blk_mq_alloc_request_hctx() by
allowing to allocate request when all CPUs of this hctx are offline.

Also cleans up map queues helpers, replace current pci/virtio/rdma
helpers with blk_mq_dev_map_queues(), and deal with the device
difference by passing one callback from driver, and the actual only
difference is that how to retrieve queue affinity. Finally the single helper
can meet all driver's requirement.


V3:
	- cleanup map queues helpers, and remove pci/virtio/rdma queue
	  helpers
	- store use managed irq info into qmap


V2:
	- use flag of BLK_MQ_F_MANAGED_IRQ
	- pass BLK_MQ_F_MANAGED_IRQ from driver explicitly
	- kill BLK_MQ_F_STACKING


Ming Lei (10):
  blk-mq: rename blk-mq-cpumap.c as blk-mq-map.c
  blk-mq: Introduce blk_mq_dev_map_queues
  blk-mq: pass use managed irq info to blk_mq_dev_map_queues
  scsi: replace blk_mq_pci_map_queues with blk_mq_dev_map_queues
  nvme: replace blk_mq_pci_map_queues with blk_mq_dev_map_queues
  virito: add APIs for retrieving vq affinity
  virtio: blk/scsi: replace blk_mq_virtio_map_queues with
    blk_mq_dev_map_queues
  nvme: rdma: replace blk_mq_rdma_map_queues with blk_mq_dev_map_queues
  blk-mq: remove map queue helpers for pci, rdma and virtio
  blk-mq: don't deactivate hctx if managed irq isn't used

 block/Makefile                            |  5 +-
 block/{blk-mq-cpumap.c => blk-mq-map.c}   | 57 +++++++++++++++++++++++
 block/blk-mq-pci.c                        | 48 -------------------
 block/blk-mq-rdma.c                       | 44 -----------------
 block/blk-mq-virtio.c                     | 46 ------------------
 block/blk-mq.c                            | 27 +++++++----
 block/blk-mq.h                            |  5 ++
 drivers/block/virtio_blk.c                | 12 ++++-
 drivers/nvme/host/pci.c                   | 12 ++++-
 drivers/nvme/host/rdma.c                  | 18 +++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    | 21 ++++-----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  5 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  4 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  9 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  6 ++-
 drivers/scsi/qla2xxx/qla_os.c             |  4 +-
 drivers/scsi/scsi_priv.h                  |  9 ++++
 drivers/scsi/smartpqi/smartpqi_init.c     |  7 ++-
 drivers/scsi/virtio_scsi.c                | 11 ++++-
 drivers/virtio/virtio.c                   | 10 ++++
 include/linux/blk-mq.h                    |  8 +++-
 include/linux/virtio.h                    |  2 +
 22 files changed, 186 insertions(+), 184 deletions(-)
 rename block/{blk-mq-cpumap.c => blk-mq-map.c} (58%)
 delete mode 100644 block/blk-mq-pci.c
 delete mode 100644 block/blk-mq-rdma.c
 delete mode 100644 block/blk-mq-virtio.c

-- 
2.31.1

