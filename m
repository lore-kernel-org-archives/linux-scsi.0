From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 3/4] libfc: avoid exchanges collision during lport reset
Date: Fri, 28 Oct 2011 11:34:17 -0700
Message-ID: <20111028183417.15165.77742.stgit@localhost6.localdomain6>
References: <20111028183305.15165.96974.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab1J1Spk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2011 14:45:40 -0400
In-Reply-To: <20111028183305.15165.96974.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: robert.w.love@intel.com, Vasu Dev <vasu.dev@intel.com>, Yi Zou <yi.zou@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Currently timer delay is large and is using msleep to avoid
avoid exchanges collision across lport reset, so instead
do this by initializing exches pool indexes during
reset also.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/libfc/fc_exch.c  |    4 ++++
 drivers/scsi/libfc/fc_lport.c |   10 +---------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 81235f3..1b22130 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1793,6 +1793,9 @@ restart:
 			goto restart;
 		}
 	}
+	pool->next_index = 0;
+	pool->left = FC_XID_UNKNOWN;
+	pool->right = FC_XID_UNKNOWN;
 	spin_unlock_bh(&pool->lock);
 }
 
@@ -2281,6 +2284,7 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lport,
 		goto free_mempool;
 	for_each_possible_cpu(cpu) {
 		pool = per_cpu_ptr(mp->pool, cpu);
+		pool->next_index = 0;
 		pool->left = FC_XID_UNKNOWN;
 		pool->right = FC_XID_UNKNOWN;
 		spin_lock_init(&pool->lock);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 628f347..e0fb891 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1030,16 +1030,8 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 			   FCH_EVT_LIPRESET, 0);
 	fc_vports_linkchange(lport);
 	fc_lport_reset_locked(lport);
-	if (lport->link_up) {
-		/*
-		 * Wait upto resource allocation time out before
-		 * doing re-login since incomplete FIP exchanged
-		 * from last session may collide with exchanges
-		 * in new session.
-		 */
-		msleep(lport->r_a_tov);
+	if (lport->link_up)
 		fc_lport_enter_flogi(lport);
-	}
 }
 
 /**

