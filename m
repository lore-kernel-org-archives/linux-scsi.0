From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/3] drain_workqueue vs scsi_flush_work
Date: Fri, 02 Dec 2011 15:56:45 -0800
Message-ID: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13409 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab1LBX4q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2011 18:56:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Tejun, James,

While trying to use drain_workqueue() in libsas I hit the
WARN_ON_ONCE(!is_chained_work(wq)) in __queue_work().  However, as I
mention in patch-2 libsas expects that new unchained work can be
submitted during a drain.  So, patch-2 is a hack to accept new work when
drain_workqueue() is used publicly as a "stronger flush", while keeping
the same warn+drop behavior for internal usages of drain_workqueue() in
the destroy_workqueue() case.

Smoke tested on sas topoloogy of:
host-->ata
host-->expander-->ata
host-->expander-->expander-->ata

--
Dan


---

Dan Williams (3):
      workqueue: promote workqueue_lock to hard-irq safe
      workqueue: defer work to a draining queue
      scsi: use drain_workqueue

 drivers/scsi/hosts.c      |    8 ++-
 drivers/scsi/isci/host.c  |    3 -
 include/linux/workqueue.h |    3 +
 include/scsi/scsi_host.h  |    2 -
 kernel/workqueue.c        |  114 ++++++++++++++++++++++++++++++++-------------
 5 files changed, 89 insertions(+), 41 deletions(-)
