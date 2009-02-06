From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/17] fcoe: exch mgr is freed while lport still retrying
	sequences
Date: Fri, 06 Feb 2009 10:55:59 -0800
Message-ID: <20090206185559.26188.41553.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZBFS4A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:00 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Steve Ma <steve.ma@intel.com>, Robert Love <robert.w.love@intel.com>

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
index a6ab692..a60b919 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -617,6 +617,7 @@ int fc_fabric_logoff(struct fc_lport *lport)
 {
 	lport->tt.disc_stop_final(lport);
 	mutex_lock(&lport->lp_mutex);
+	cancel_delayed_work_sync(&lport->retry_work);
 	fc_lport_enter_logo(lport);
 	mutex_unlock(&lport->lp_mutex);
 	return 0;
@@ -938,6 +939,7 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 		       fc_host_port_id(lport->host), fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_RESET);
+	cancel_delayed_work_sync(&lport->retry_work);
 
 	if (lport->dns_rp)
 		lport->tt.rport_logoff(lport->dns_rp);

