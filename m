Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A32DC001DE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 09:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbjGZJmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 05:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbjGZJmD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 05:42:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D914113E
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 02:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690364471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=991prPOr3CC0OYGragucunFfWE1ASbB8T8+eCTuUx4g=;
        b=GESk7ezAkcSkYgwui/QwYZ92WO56zoNdwLfCG4bpa4yROBZGZVJSCk4XZ4PzdqpUvy7x4D
        YPP29mDkbL1ddJD6x82Rk5+meQrZR1tRa7rcW3Bbz0ihRkNL6laW9JvBDNQOVLjK0Yx1qX
        WcJ6dH7E6tWyS4+TcyP0HSf7d8rZYI0=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-06SQxYjyMtOj-FMRXjmHLA-1; Wed, 26 Jul 2023 05:41:07 -0400
X-MC-Unique: 06SQxYjyMtOj-FMRXjmHLA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1EF53815F60;
        Wed, 26 Jul 2023 09:41:06 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2ED79492C13;
        Wed, 26 Jul 2023 09:41:05 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH V2 9/9] scsi: pm8001: take blk_mq_max_nr_hw_queues() into account for calculating io vectors
Date:   Wed, 26 Jul 2023 17:40:27 +0800
Message-Id: <20230726094027.535126-10-ming.lei@redhat.com>
In-Reply-To: <20230726094027.535126-1-ming.lei@redhat.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 2e886c1d867d..3e769f4fe26d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -965,6 +965,8 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 		rc = pci_alloc_irq_vectors(pm8001_ha->pdev, 1, 1,
 					   PCI_IRQ_MSIX);
 	} else {
+		unsigned int max_vecs = min_t(unsigned int, PM8001_MAX_MSIX_VEC,
+				scsi_max_nr_hw_queues() + 1);
 		/*
 		 * Queue index #0 is used always for housekeeping, so don't
 		 * include in the affinity spreading.
@@ -973,7 +975,7 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 			.pre_vectors = 1,
 		};
 		rc = pci_alloc_irq_vectors_affinity(
-				pm8001_ha->pdev, 2, PM8001_MAX_MSIX_VEC,
+				pm8001_ha->pdev, 2, max_vecs,
 				PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc);
 	}
 
-- 
2.40.1

