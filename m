From: Robert Love <robert.w.love@intel.com>
Subject: [Open-FCoE PATCH 3/6] libfc: handle RRQ exch timeout
Date: Wed, 21 Jan 2009 12:44:55 -0800
Message-ID: <20090121204455.2468.24539.stgit@fritz>
References: <20090121204444.2468.66245.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49777 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZAUUoz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2009 15:44:55 -0500
In-Reply-To: <20090121204444.2468.66245.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

Cleanup exchange held due to RRQ when RRQ exch times out, in this case the
ABTS is already done causing RRQ req therefore proceeding with cleanup in
fc_exch_rrq_resp should be okay to restore exch resource.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index a09416f..e874e77 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1608,7 +1608,7 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 	if (IS_ERR(fp)) {
 		int err = PTR_ERR(fp);
 
-		if (err == -FC_EX_CLOSED)
+		if (err == -FC_EX_CLOSED || err == -FC_EX_TIMEOUT)
 			goto cleanup;
 		FC_DBG("Cannot process RRQ, because of frame error %d\n", err);
 		return;

