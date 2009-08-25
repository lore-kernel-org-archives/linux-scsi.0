From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/64] fcoe: remove unnecessary list and lock initializations.
Date: Tue, 25 Aug 2009 13:59:19 -0700
Message-ID: <20090825205919.1553.19577.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39366 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168AbZHYU7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:17 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The hostlist and the hostlist_lock were initialized both in
the delcaration and in fcoe_init().  Remove the unneeded code.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index d205ac0..e481882 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1881,9 +1881,6 @@ static int __init fcoe_init(void)
 	int rc = 0;
 	struct fcoe_percpu_s *p;
 
-	INIT_LIST_HEAD(&fcoe_hostlist);
-	rwlock_init(&fcoe_hostlist_lock);
-
 	for_each_possible_cpu(cpu) {
 		p = &per_cpu(fcoe_percpu, cpu);
 		skb_queue_head_init(&p->fcoe_rx_list);

