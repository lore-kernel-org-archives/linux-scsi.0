Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D79DC41513
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 16:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjHHQJA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 12:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbjHHQHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 12:07:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC877296
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 08:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691509518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ketWVMOak+Jss00Ni7DMSRSVvfoPSxigoCA6y+QxH1E=;
        b=NMuXjKZ1u/TXvHI3Fn7SaKEEX3X1dGFwR23oh5A6ZIDnFLj3WzWnjZ20Z5TXKnTihMHo5O
        ZU/f7Xh9JFk7fG76He31EeXaTEy6GjNKPdPyWVclcC2X3OyzhfsGeWhHCenF7FcK56lKi9
        ZPLCTXEmV8K6VPP7IfPz4GJMUjac+Cs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-MxRzmOzlP2azCBUyTJYr2w-1; Tue, 08 Aug 2023 06:43:16 -0400
X-MC-Unique: MxRzmOzlP2azCBUyTJYr2w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0DF880557C;
        Tue,  8 Aug 2023 10:43:15 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D5A51121314;
        Tue,  8 Aug 2023 10:43:14 +0000 (UTC)
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
Subject: [PATCH V3 08/14] scsi: megaraid: take blk_mq_max_nr_hw_queues() into account for calculating io vectors
Date:   Tue,  8 Aug 2023 18:42:33 +0800
Message-Id: <20230808104239.146085-9-ming.lei@redhat.com>
In-Reply-To: <20230808104239.146085-1-ming.lei@redhat.com>
References: <20230808104239.146085-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
index 050eed8e2684..587ccbc1ec92 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5921,6 +5921,10 @@ __megasas_alloc_irq_vectors(struct megasas_instance *instance)
 	int i, irq_flags;
 	struct irq_affinity desc = { .pre_vectors = instance->low_latency_index_start };
 	struct irq_affinity *descp = &desc;
+	unsigned max_vecs = instance->msix_vectors - instance->iopoll_q_count;
+
+	if (max_vecs > scsi_max_nr_hw_queues())
+		max_vecs = scsi_max_nr_hw_queues();
 
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

