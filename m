Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF77CC3A5A4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 08:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9071C21872
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 08:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbfH0Iy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 04:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729895AbfH0IyZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 04:54:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D729C308339B;
        Tue, 27 Aug 2019 08:54:24 +0000 (UTC)
Received: from localhost (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E74585D71C;
        Tue, 27 Aug 2019 08:54:21 +0000 (UTC)
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
Subject: [PATCH 4/4] genirq: use irq's affinity for threaded irq with IRQF_RESCUE_THREAD
Date:   Tue, 27 Aug 2019 16:53:44 +0800
Message-Id: <20190827085344.30799-5-ming.lei@redhat.com>
In-Reply-To: <20190827085344.30799-1-ming.lei@redhat.com>
References: <20190827085344.30799-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 27 Aug 2019 08:54:25 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In case of IRQF_RESCUE_THREAD, the threaded handler is only used to
handle interrupt when IRQ flood comes, use irq's affinity for this thread
so that scheduler may select other not too busy CPUs for handling the
interrupt.

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
 kernel/irq/manage.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1566abbf50e8..03bc041348b7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -968,7 +968,18 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 	if (cpumask_available(desc->irq_common_data.affinity)) {
 		const struct cpumask *m;
 
-		m = irq_data_get_effective_affinity_mask(&desc->irq_data);
+		/*
+		 * Managed IRQ's affinity is setup gracefull on MUNA locality,
+		 * also if IRQF_RESCUE_THREAD is set, interrupt flood has been
+		 * triggered, so ask scheduler to run the thread on CPUs
+		 * specified by this interrupt's affinity.
+		 */
+		if ((action->flags & IRQF_RESCUE_THREAD) &&
+				irqd_affinity_is_managed(&desc->irq_data))
+			m = desc->irq_common_data.affinity;
+		else
+			m = irq_data_get_effective_affinity_mask(
+					&desc->irq_data);
 		cpumask_copy(mask, m);
 	} else {
 		valid = false;
-- 
2.20.1

