Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60112C001DB
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 16:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjHHQP3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 12:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbjHHQNm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 12:13:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26617EE2
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 08:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691509630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C17OARe57EL9o7KdFcMFd+ePVCSI04MI+oyFBoL2yZ8=;
        b=HKhpf2FBZh8erRbQLLTSh7KrqssHsqdbb9RwakgTbd20auDW4i5zYGvf9zjBf4rYMerVUD
        fKZghyjsCYFrNdPeqgPcvOMIhkml2Syex0AWT63vnq/hvrELF5ZtnGmh5Bsae0pp5QtTdK
        UqmiFsz27evhwD1HpdaEwQbtHkpQdgM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-u3rrZKuKNmyLrBZpCjaFeg-1; Tue, 08 Aug 2023 06:42:48 -0400
X-MC-Unique: u3rrZKuKNmyLrBZpCjaFeg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 596E9101A52E;
        Tue,  8 Aug 2023 10:42:48 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7880F492C13;
        Tue,  8 Aug 2023 10:42:46 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 0/14] blk-mq: fix wrong queue mapping for kdump kernel
Date:   Tue,  8 Aug 2023 18:42:25 +0800
Message-Id: <20230808104239.146085-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Fix wrong queue mapping for kdump kernel since blk-mq updates
nr_hw_queues to 1, so driver and blk-mq may have different queue topo.


V3:
	- cover more drivers
	- clean up blk-mq a bit, as suggested by Christoph

V2:
	- add helper of scsi_max_nr_hw_queues() for avoiding potential build
	failure because scsi driver often doesn't deal with blk-mq directly
	- apply scsi_max_nr_hw_queues() for all scsi changes
	- move lpfc's change into managed irq code path


Ming Lei (14):
  blk-mq: add blk_mq_max_nr_hw_queues()
  nvme-pci: use blk_mq_max_nr_hw_queues() to calculate io queues
  ublk: limit max allowed nr_hw_queues
  virtio-blk: limit max allowed submit queues
  scsi: core: add helper of scsi_max_nr_hw_queues()
  scsi: lpfc: use blk_mq_max_nr_hw_queues() to calculate io vectors
  scsi: mpi3mr: take blk_mq_max_nr_hw_queues() into account for
    calculating io vectors
  scsi: megaraid: take blk_mq_max_nr_hw_queues() into account for
    calculating io vectors
  scsi: mpt3sas: take blk_mq_max_nr_hw_queues() into account for
    calculating io vectors
  scsi: pm8001: take blk_mq_max_nr_hw_queues() into account for
    calculating io vectors
  scsi: hisi: take blk_mq_max_nr_hw_queues() into account for
    calculating io vectors
  scsi: ufs: limit max allowed nr_hw_queues
  scsi: storvsc: limit max allowed nr_hw_queues
  blk-mq: add helpers for treating kdump kernel

 block/blk-mq.c                            | 55 ++++++++++++++++++-----
 drivers/block/ublk_drv.c                  |  2 +-
 drivers/block/virtio_blk.c                |  3 +-
 drivers/nvme/host/pci.c                   |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  3 ++
 drivers/scsi/lpfc/lpfc_init.c             |  2 +
 drivers/scsi/megaraid/megaraid_sas_base.c |  6 ++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           |  3 ++
 drivers/scsi/mpt3sas/mpt3sas_base.c       |  4 +-
 drivers/scsi/pm8001/pm8001_init.c         |  4 +-
 drivers/scsi/storvsc_drv.c                |  3 ++
 drivers/ufs/core/ufs-mcq.c                |  2 +-
 include/linux/blk-mq.h                    |  1 +
 include/scsi/scsi_host.h                  |  5 +++
 14 files changed, 75 insertions(+), 20 deletions(-)

-- 
2.40.1

