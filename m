From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/16] libfc: use offload EM instance again instead jumping to
	next EM
Date: Fri, 12 Mar 2010 16:08:39 -0800
Message-ID: <20100313000839.22251.87261.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54373 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAIk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:40 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Since use of offloads is more efficient than switching
to non-offload EM. However kept logic same to call em_match
if it is provided in the list of EMs.

Converted fc_exch_alloc to inline being now tiny a function
and already not an exported libfc API any more.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index dd7e188..fe1ceb3 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -734,19 +734,14 @@ err:
  * EM is selected when a NULL match function pointer is encountered
  * or when a call to a match function returns true.
  */
-static struct fc_exch *fc_exch_alloc(struct fc_lport *lport,
-				     struct fc_frame *fp)
+static inline struct fc_exch *fc_exch_alloc(struct fc_lport *lport,
+					    struct fc_frame *fp)
 {
 	struct fc_exch_mgr_anchor *ema;
-	struct fc_exch *ep;
 
-	list_for_each_entry(ema, &lport->ema_list, ema_list) {
-		if (!ema->match || ema->match(fp)) {
-			ep = fc_exch_em_alloc(lport, ema->mp);
-			if (ep)
-				return ep;
-		}
-	}
+	list_for_each_entry(ema, &lport->ema_list, ema_list)
+		if (!ema->match || ema->match(fp))
+			return fc_exch_em_alloc(lport, ema->mp);
 	return NULL;
 }
 

