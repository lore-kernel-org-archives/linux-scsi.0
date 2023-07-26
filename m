Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEF6C001E0
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 09:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbjGZJld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 05:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbjGZJl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 05:41:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28552B6
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 02:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690364440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qw3JY1fSFkCDbqzWrwPQL1ow2KshJKSV3fmVfeQPZXE=;
        b=Is3rzyZ00VZyex6RIhnuxWFXO4BhOy/XG4U9/Fx3lxpsHBLeMgc/WHUaWk4TvTR1ptYfZd
        SR2t3aIeu9AagHmv1uIzBLg7rC9s+jQAIzdH15iNjC5XxEDeHewBXGPrWwcuB7k5mq16hx
        TSIECs8NYpl10ASUVjvKR5Yry2pXeEk=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-nPty-3TXN5CPhkgu8OlO_A-1; Wed, 26 Jul 2023 05:40:36 -0400
X-MC-Unique: nPty-3TXN5CPhkgu8OlO_A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AB713C01BA1;
        Wed, 26 Jul 2023 09:40:36 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C90C0492C13;
        Wed, 26 Jul 2023 09:40:34 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/9] blk-mq: fix wrong queue mapping for kdump kernel
Date:   Wed, 26 Jul 2023 17:40:18 +0800
Message-Id: <20230726094027.535126-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On arm and ppc64, 'maxcpus=1' is required for kdump kernel,
see `Documentation/admin-guide/kdump/kdump.rst`, so num_possible_cpus()
still returns all CPUs because 'maxcpus=1' just bring up one single
cpu core during booting.

blk-mq sees single queue in kdump kernel, and in driver's viewpoint
there are still multiple queues, this inconsistency causes driver to apply
wrong queue mapping for handling IO, and IO timeout is triggered.

This issue is only triggered on managed irq in case of multiple hw
queues. Some drivers takes online cpus into account for nr_hw_queues,
and don't have such issue, such as nvme rdma/tcp.

Meantime, single queue makes much less resource utilization, and reduce
risk of kernel failure.

V2:
	- add helper of scsi_max_nr_hw_queues() for avoiding potential build
	failure because scsi driver often doesn't deal with blk-mq directly
	- apply scsi_max_nr_hw_queues() for all scsi changes
	- move lpfc's change into managed irq code path


Thanks,
Ming

Ming Lei (9):
  blk-mq: add blk_mq_max_nr_hw_queues()
  nvme-pci: use blk_mq_max_nr_hw_queues() to calculate io queues
  scsi: core: add helper of scsi_max_nr_hw_queues()
  scsi: lpfc: use blk_mq_max_nr_hw_queues() to calculate io vectors
  scsi: hisi: take blk_mq_max_nr_hw_queues() into account for
    calculating io vectors
  scsi: mpi3mr: take blk_mq_max_nr_hw_queues() into account for
    calculating io vectors
  scsi: megaraid: take blk_mq_max_nr_hw_queues() into account for
    calculating io vectors
  scsi: mpt3sas: take blk_mq_max_nr_hw_queues() into account for
    calculating io vectors
  scsi: pm8001: take blk_mq_max_nr_hw_queues() into account for
    calculating io vectors

 block/blk-mq.c                            | 16 ++++++++++++++++
 drivers/nvme/host/pci.c                   |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  3 +++
 drivers/scsi/lpfc/lpfc_init.c             |  2 ++
 drivers/scsi/megaraid/megaraid_sas_base.c |  6 +++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           |  3 +++
 drivers/scsi/mpt3sas/mpt3sas_base.c       |  4 ++--
 drivers/scsi/pm8001/pm8001_init.c         |  4 +++-
 include/linux/blk-mq.h                    |  1 +
 include/scsi/scsi_host.h                  |  5 +++++
 10 files changed, 41 insertions(+), 5 deletions(-)

-- 
2.40.1

