Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381A3C0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 12:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjGLMz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 08:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjGLMzz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 08:55:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F666173B
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 05:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689166506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5CYqK3Y+IQKFaUkutdkJlO3sotphYax9MRe0AccKI2w=;
        b=dke2vJbuuzwNsdIrF+pNwO8Op2CQkVl2b1+qPkn7Q8ShwHnwGhfpG2Kiwxa2vvB9C22zs7
        7pqKFtq7TTiSyZJsFGlzEO36wgMinv/nV/2T2fl1mQjtdvXRz4oCKeyDSYrBmbKHNE+HzO
        JIlhMpw+w8EiDyV2lhJxlPrlle1mmJU=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-PESh_r3nPIO4H1zgny0CSw-1; Wed, 12 Jul 2023 08:55:03 -0400
X-MC-Unique: PESh_r3nPIO4H1zgny0CSw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 151EB3C0FC99;
        Wed, 12 Jul 2023 12:55:03 +0000 (UTC)
Received: from localhost (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E15D3C1ED96;
        Wed, 12 Jul 2023 12:55:01 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/8] blk-mq: fix wrong queue mapping for kdump kernel
Date:   Wed, 12 Jul 2023 20:54:47 +0800
Message-Id: <20230712125455.1986455-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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


Thanks,
Ming

Ming Lei (8):
  blk-mq: add blk_mq_max_nr_hw_queues()
  nvme-pci: use blk_mq_max_nr_hw_queues() to calculate io queues
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

 block/blk-mq.c                            | 9 +++++++++
 drivers/nvme/host/pci.c                   | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 3 +++
 drivers/scsi/lpfc/lpfc_init.c             | 1 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 +++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 3 +++
 drivers/scsi/mpt3sas/mpt3sas_base.c       | 4 ++--
 drivers/scsi/pm8001/pm8001_init.c         | 4 +++-
 include/linux/blk-mq.h                    | 1 +
 9 files changed, 28 insertions(+), 5 deletions(-)

-- 
2.40.1

