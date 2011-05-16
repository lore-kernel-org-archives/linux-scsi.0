From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/8] libfc: don't call resp handler after FC_EX_TIMEOUT
Date: Mon, 16 May 2011 16:45:45 -0700
Message-ID: <20110516234545.24502.83410.stgit@localhost6.localdomain6>
References: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:41961 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1EPXpr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 19:45:47 -0400
In-Reply-To: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

In cases exch is already timed out then exch layer could
end up calling resp handler again for its response frame
received after timeout, though in this case fc_exch_timeout
handler would have already called resp with FC_EX_TIMEOUT.

This would cause REC response handler to release its
fsp pkt hold twice instead once and possibly similar issues
with other ELS exchanges in this race.

To avoid this race have resp updated under exch lock
in rx path, the resp would get set to NULL in case
of FC_EX_TIMEOUT under the same lock to prevent resp
callback after FC_EX_TIMEOUT.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 4d2994d..3b8a645 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1434,6 +1434,7 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	    (f_ctl & (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) ==
 	    (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) {
 		spin_lock_bh(&ep->ex_lock);
+		resp = ep->resp;
 		rc = fc_exch_done_locked(ep);
 		WARN_ON(fc_seq_exch(sp) != ep);
 		spin_unlock_bh(&ep->ex_lock);

