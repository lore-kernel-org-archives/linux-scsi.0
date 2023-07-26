Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0010C0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 09:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbjGZJmD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 05:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbjGZJlv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 05:41:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46789121
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 02:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690364464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2DxJS8RxHnnXfV+djc15xnTM9KjPIA9NavQgadLTDR8=;
        b=bUFoL8jbpbbMVT0/u+JH6RIB1JtDxgp02H33z/ImVjjBMRhs/hRwLfgKVFV+CL6Icfor4V
        FMwFUmOwMzCwG8rQ2YTu9dUBoXJKjTQNcCdVkjEAHNWZR1Dos27o9+u55m9xqyD8OLB9U3
        OFRSpnG+HcKo1nE517dsO/T7Af1MQco=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-w_AlwBYUO3Sf2SeTYlwxOw-1; Wed, 26 Jul 2023 05:40:57 -0400
X-MC-Unique: w_AlwBYUO3Sf2SeTYlwxOw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04DE285A58A;
        Wed, 26 Jul 2023 09:40:57 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 356B0F782E;
        Wed, 26 Jul 2023 09:40:55 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH V2 6/9] scsi: mpi3mr: take blk_mq_max_nr_hw_queues() into account for calculating io vectors
Date:   Wed, 26 Jul 2023 17:40:24 +0800
Message-Id: <20230726094027.535126-7-ming.lei@redhat.com>
In-Reply-To: <20230726094027.535126-1-ming.lei@redhat.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Take blk-mq's knowledge into account for calculating io queues.

Fix wrong queue mapping in case of kdump kernel.

On arm and ppc64, 'maxcpus=1' is passed to kdump kernel command line,
see `Documentation/admin-guide/kdump/kdump.rst`, so num_possible_cpus()
still returns all CPUs because 'maxcpus=1' just bring up one single
cpu core during booting.

blk-mq sees single queue in kdump kernel, and in driver's viewpoint
there are still multiple queues, this inconsistency causes driver to apply
wrong queue mapping for handling IO, and IO timeout is triggered.

Meantime, single queue makes much less resource utilization, and reduce
risk of kernel failure.

Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 5fa07d6ee5b8..8fe14e728af6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -815,6 +815,9 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 
 		desc.post_vectors = mrioc->requested_poll_qcount;
 		min_vec = desc.pre_vectors + desc.post_vectors;
+		if (max_vectors - min_vec > scsi_max_nr_hw_queues())
+			max_vectors = min_vec + scsi_max_nr_hw_queues();
+
 		irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
 
 		retval = pci_alloc_irq_vectors_affinity(mrioc->pdev,
-- 
2.40.1

