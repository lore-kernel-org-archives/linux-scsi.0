Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B070C3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 08:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 529FA2184D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 08:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfH0IyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 04:54:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729783AbfH0IyT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 04:54:19 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4495D8BA2DA;
        Tue, 27 Aug 2019 08:54:19 +0000 (UTC)
Received: from localhost (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D0CF5DA8B;
        Tue, 27 Aug 2019 08:54:18 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Long Li <longli@microsoft.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 3/4] nvme: pci: pass IRQF_RESCURE_THREAD to request_threaded_irq
Date:   Tue, 27 Aug 2019 16:53:43 +0800
Message-Id: <20190827085344.30799-4-ming.lei@redhat.com>
In-Reply-To: <20190827085344.30799-1-ming.lei@redhat.com>
References: <20190827085344.30799-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 27 Aug 2019 08:54:19 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If one vector is spread on several CPUs, usually the interrupt is only
handled on one of these CPUs. Meantime, IO can be issued to the single
hw queue from different CPUs concurrently, this way is easy to cause
IRQ flood and CPU lockup.

Pass IRQF_RESCURE_THREAD in above case for asking genirq to handle
interrupt in the rescurd thread when irq flood is detected.

Cc: Long Li <longli@microsoft.com>
Cc: Ingo Molnar <mingo@redhat.com>,
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: John Garry <john.garry@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/nvme/host/pci.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 45a80b708ef4..0b8d49470230 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1501,8 +1501,21 @@ static int queue_request_irq(struct nvme_queue *nvmeq)
 		return pci_request_irq(pdev, nvmeq->cq_vector, nvme_irq_check,
 				nvme_irq, nvmeq, "nvme%dq%d", nr, nvmeq->qid);
 	} else {
-		return pci_request_irq(pdev, nvmeq->cq_vector, nvme_irq,
-				NULL, nvmeq, "nvme%dq%d", nr, nvmeq->qid);
+		char *devname;
+		const struct cpumask *mask;
+		unsigned long irqflags = IRQF_SHARED;
+		int vector = pci_irq_vector(pdev, nvmeq->cq_vector);
+
+		devname = kasprintf(GFP_KERNEL, "nvme%dq%d", nr, nvmeq->qid);
+		if (!devname)
+			return -ENOMEM;
+
+		mask = pci_irq_get_affinity(pdev, nvmeq->cq_vector);
+		if (mask && cpumask_weight(mask) > 1)
+			irqflags |= IRQF_RESCUE_THREAD;
+
+		return request_threaded_irq(vector, nvme_irq, NULL, irqflags,
+				devname, nvmeq);
 	}
 }
 
-- 
2.20.1

