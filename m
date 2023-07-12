Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FE0EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 12:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbjGLM4Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 08:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjGLM4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 08:56:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A613C19B4
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 05:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689166531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gV9SQll/aiZU7jZHjbK/6CqsGn0qDXytoHDv6FeUPyo=;
        b=Jv1x8vGC84/rIMffpUkklQGYcLtg/3onybr80fyRj6wNiX6vsXJJkUiSZRpXzuznVX1TUM
        +trJY0BQ8efYaqqDYVCow5V7hQ76rhh1O0fx2vX0pfTxCQL4eRr567O0ahIF9CN4t3PeUv
        o+7u2o33af8SJ3p3c2A4/BSJPlCt/Fs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-hvkH-1cePRinCSykJgDspQ-1; Wed, 12 Jul 2023 08:55:27 -0400
X-MC-Unique: hvkH-1cePRinCSykJgDspQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC4BE10504AE;
        Wed, 12 Jul 2023 12:55:26 +0000 (UTC)
Received: from localhost (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BB08C1ED96;
        Wed, 12 Jul 2023 12:55:25 +0000 (UTC)
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
Subject: [PATCH 6/8] scsi: megaraid: take blk_mq_max_nr_hw_queues() into account for calculating io vectors
Date:   Wed, 12 Jul 2023 20:54:53 +0800
Message-Id: <20230712125455.1986455-7-ming.lei@redhat.com>
In-Reply-To: <20230712125455.1986455-1-ming.lei@redhat.com>
References: <20230712125455.1986455-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 050eed8e2684..214713803c2e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5921,6 +5921,10 @@ __megasas_alloc_irq_vectors(struct megasas_instance *instance)
 	int i, irq_flags;
 	struct irq_affinity desc = { .pre_vectors = instance->low_latency_index_start };
 	struct irq_affinity *descp = &desc;
+	unsigned max_vecs = instance->msix_vectors - instance->iopoll_q_count;
+
+	if (max_vecs > blk_mq_max_nr_hw_queues())
+		max_vecs = blk_mq_max_nr_hw_queues();
 
 	irq_flags = PCI_IRQ_MSIX;
 
@@ -5934,7 +5938,7 @@ __megasas_alloc_irq_vectors(struct megasas_instance *instance)
 	 */
 	i = pci_alloc_irq_vectors_affinity(instance->pdev,
 		instance->low_latency_index_start,
-		instance->msix_vectors - instance->iopoll_q_count, irq_flags, descp);
+		max_vecs, irq_flags, descp);
 
 	return i;
 }
-- 
2.40.1

