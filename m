From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 17/27] libfc: fix exchange being deleted when the abort itself
	is timed out
Date: Tue, 30 Nov 2010 16:19:25 -0800
Message-ID: <20101201001925.18369.16047.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23668 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab0LAATZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:25 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Should not continue when the abort itself is being timeout since in that case
the exchange will be deleted and relesased. We still want to call the
associated response handler to let the layer, e.g., fcp, know the exchange
itself is being timed out.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 8bfb421..d21367d 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -650,10 +650,13 @@ static void fc_exch_timeout(struct work_struct *work)
 		if (e_stat & ESB_ST_ABNORMAL)
 			rc = fc_exch_done_locked(ep);
 		spin_unlock_bh(&ep->ex_lock);
-		if (!rc)
-			fc_exch_delete(ep);
 		if (resp)
 			resp(sp, ERR_PTR(-FC_EX_TIMEOUT), arg);
+		if (!rc) {
+			/* delete the exchange if it's already being aborted */
+			fc_exch_delete(ep);
+			return;
+		}
 		fc_seq_exch_abort(sp, 2 * ep->r_a_tov);
 		goto done;
 	}

