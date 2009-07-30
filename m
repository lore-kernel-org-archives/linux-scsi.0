From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/22] libfc: fix WARNING from fc_seq_start_next on closed
	exchanges
Date: Wed, 29 Jul 2009 17:04:38 -0700
Message-ID: <20090730000438.24658.13.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23834 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbZG3AEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:38 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

We saw periodic messages like:

WARNING: at drivers/scsi/libfc/fc_exch.c:825 fc_seq_start_next+0x30/0x4b

This was due to trying to allocate a sequence in a request handler
when the exchange had been reset.

Delete the WARN_ON.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index e6d82d7..cab5499 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -822,7 +822,6 @@ struct fc_seq *fc_seq_start_next(struct fc_seq *sp)
 	struct fc_exch *ep = fc_seq_exch(sp);
 
 	spin_lock_bh(&ep->ex_lock);
-	WARN_ON((ep->esb_stat & ESB_ST_COMPLETE) != 0);
 	sp = fc_seq_start_next_locked(sp);
 	spin_unlock_bh(&ep->ex_lock);
 

