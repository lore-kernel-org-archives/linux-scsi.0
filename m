From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 6/6] fcoe: remove a stray unlock
Date: Fri, 20 Apr 2012 12:16:54 -0700
Message-ID: <20120420191654.4634.16631.stgit@localhost6.localdomain6>
References: <20120420191620.4634.94869.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1438 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab2DTTQz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 15:16:55 -0400
In-Reply-To: <20120420191620.4634.94869.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>

From: Dan Carpenter <dan.carpenter@oracle.com>

We moved the locking in dd060e74fb "[SCSI] fcoe: remove frame dropping
code from fcoe_percpu_clean" but this unlock was missed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ac1df93..76e3d0b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2294,10 +2294,9 @@ static void fcoe_percpu_clean(struct fc_lport *lport)
 			continue;
 
 		skb = dev_alloc_skb(0);
-		if (!skb) {
-			spin_unlock_bh(&pp->fcoe_rx_list.lock);
+		if (!skb)
 			continue;
-		}
+
 		skb->destructor = fcoe_percpu_flush_done;
 
 		spin_lock_bh(&pp->fcoe_rx_list.lock);

