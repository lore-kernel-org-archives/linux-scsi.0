From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/16] libfc: fix oops in point-to-point mode
Date: Fri, 12 Mar 2010 16:07:46 -0800
Message-ID: <20100313000746.22251.7776.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27997 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934747Ab0CMAHr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:07:47 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

In point-to-point mode, if the PLOGI to the remote port times
out, it can get deleted by the remote port module.  Since there's
no reference by the local port, lport->ptp_data points to a freed
rport, and when the local port is reset and tries to logout again,
an oops occurs in mutex_lock_nested().

Hold a reference count on the point-to-point rdata.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 7ec8ce7..af7343a 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -227,9 +227,12 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 			       u64 remote_wwnn)
 {
 	mutex_lock(&lport->disc.disc_mutex);
-	if (lport->ptp_rdata)
+	if (lport->ptp_rdata) {
 		lport->tt.rport_logoff(lport->ptp_rdata);
+		kref_put(&lport->ptp_rdata->kref, lport->tt.rport_destroy);
+	}
 	lport->ptp_rdata = lport->tt.rport_create(lport, remote_fid);
+	kref_get(&lport->ptp_rdata->kref);
 	lport->ptp_rdata->ids.port_name = remote_wwpn;
 	lport->ptp_rdata->ids.node_name = remote_wwnn;
 	mutex_unlock(&lport->disc.disc_mutex);
@@ -946,7 +949,11 @@ static void fc_lport_reset_locked(struct fc_lport *lport)
 	if (lport->dns_rdata)
 		lport->tt.rport_logoff(lport->dns_rdata);
 
-	lport->ptp_rdata = NULL;
+	if (lport->ptp_rdata) {
+		lport->tt.rport_logoff(lport->ptp_rdata);
+		kref_put(&lport->ptp_rdata->kref, lport->tt.rport_destroy);
+		lport->ptp_rdata = NULL;
+	}
 
 	lport->tt.disc_stop(lport);
 

