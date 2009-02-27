From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/24] libfc: exch mgr is freed while lport still retrying
	sequences
Date: Fri, 27 Feb 2009 10:55:13 -0800
Message-ID: <20090227185513.25509.73270.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50265 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591AbZB0Sz2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:55:28 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

From: Steve Ma <steve.ma@intel.com>

When a sequence cannot be delivered to the target, the local
port will schedule retries, While this process is in progress,
if we destroy the FCoE interface, the fcoe_sw_destroy routine is
entered, and the fc_exch_mgr_free(lp->emp) is called.  Thus
if fc_exch_alloc() is called when retrying the sequence,
the mempool_alloc() will fail to allocate the exchange because
the mempool of the exchange manager has already been released.
This patch is to cancel any pending retry work of the local
port before we start to destroy the interface.

Also, when resetting the local port, we should also stop the
scheduled pending retries.

Signed-off-by: Steve Ma <steve.ma@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a6ab692..e6ea4f1 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -619,6 +619,7 @@ int fc_fabric_logoff(struct fc_lport *lport)
 	mutex_lock(&lport->lp_mutex);
 	fc_lport_enter_logo(lport);
 	mutex_unlock(&lport->lp_mutex);
+	cancel_delayed_work_sync(&lport->retry_work);
 	return 0;
 }
 EXPORT_SYMBOL(fc_fabric_logoff);
@@ -918,6 +919,7 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
  */
 int fc_lport_reset(struct fc_lport *lport)
 {
+	cancel_delayed_work_sync(&lport->retry_work);
 	mutex_lock(&lport->lp_mutex);
 	fc_lport_enter_reset(lport);
 	mutex_unlock(&lport->lp_mutex);

