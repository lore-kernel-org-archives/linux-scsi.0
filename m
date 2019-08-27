Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE3CC3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 08:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C72B2173E
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 08:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbfH0IyE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 04:54:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfH0IyE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 04:54:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B34A08980EB;
        Tue, 27 Aug 2019 08:54:03 +0000 (UTC)
Received: from localhost (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F373C5D70D;
        Tue, 27 Aug 2019 08:53:59 +0000 (UTC)
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
Subject: [PATCH 0/4] genirq/nvme: add IRQF_RESCUE_THREAD for avoiding IRQ flood
Date:   Tue, 27 Aug 2019 16:53:40 +0800
Message-Id: <20190827085344.30799-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Tue, 27 Aug 2019 08:54:04 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Guys,

The 1st patch implements one simple EWMA based mechanism for detecting IRQ flood.

The 2nd patch adds IRQF_RESCUE_THREAD, and interrupts will be handled in
the created rescue thread in case that IRQ flood comes.

The 3rd patch applies the flag of IRQF_RESCURE_THREAD for NVMe.

The last patch uses irq's affinity in case of IRQF_RESCUE_THREAD.

Please review & comment!

Long, please test and see if your issue can be fixed.

Ming Lei (4):
  softirq: implement IRQ flood detection mechanism
  genirq: add IRQF_RESCUE_THREAD
  nvme: pci: pass IRQF_RESCURE_THREAD to request_threaded_irq
  genirq: use irq's affinity for threaded irq with IRQF_RESCUE_THREAD

 drivers/base/cpu.c        | 25 +++++++++++++++++++++
 drivers/nvme/host/pci.c   | 17 +++++++++++++--
 include/linux/hardirq.h   |  2 ++
 include/linux/interrupt.h |  6 +++++
 kernel/irq/handle.c       |  6 ++++-
 kernel/irq/manage.c       | 25 ++++++++++++++++++++-
 kernel/softirq.c          | 46 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 123 insertions(+), 4 deletions(-)

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


-- 
2.20.1

