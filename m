From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/8] Revert "[SCSI] libfc: fix exchange being deleted when the
	abort itself is timed out"
Date: Fri, 25 Feb 2011 15:02:56 -0800
Message-ID: <20110225230256.9310.25478.stgit@localhost6.localdomain6>
References: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20459 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab1BYXC4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 18:02:56 -0500
In-Reply-To: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

From: Parikh, Neerav <neerav.parikh@intel.com>

When abort for an exchange timed out it didn't release the reference to
the exchange resulting in a memory leak.

After discussion with the author of the patch (CC) that introduced this
bug it was suggested to revert that patch.

This reverts commit ea3e2e72eeb3e8a9440a5da965914f9b12088626.

Signed-off by: Neerav Parikh <Neerav.Parikh@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 08bf5fa..10a5436 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -666,13 +666,10 @@ static void fc_exch_timeout(struct work_struct *work)
 		if (e_stat & ESB_ST_ABNORMAL)
 			rc = fc_exch_done_locked(ep);
 		spin_unlock_bh(&ep->ex_lock);
+		if (!rc)
+			fc_exch_delete(ep);
 		if (resp)
 			resp(sp, ERR_PTR(-FC_EX_TIMEOUT), arg);
-		if (!rc) {
-			/* delete the exchange if it's already being aborted */
-			fc_exch_delete(ep);
-			return;
-		}
 		fc_seq_exch_abort(sp, 2 * ep->r_a_tov);
 		goto done;
 	}

