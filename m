From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 39/64] libfc: have rport_create do a lookup for pre-existing
	rports first
Date: Tue, 25 Aug 2009 14:01:55 -0700
Message-ID: <20090825210155.1553.72381.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18090 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbZHYVBx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:01:53 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

For future discovery patches, change rport_create to return a previously
created rport_priv that has the FC_ID as long as it isn't in deleted state.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |    9 +++------
 drivers/scsi/libfc/fc_rport.c |    4 ++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index e6b13bf..266aa1e 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -377,12 +377,9 @@ static int fc_disc_new_target(struct fc_disc *disc,
 	    ids->port_id != fc_host_port_id(lport->host) &&
 	    ids->port_name != lport->wwpn) {
 		if (!rdata) {
-			rdata = lport->tt.rport_lookup(lport, ids->port_id);
-			if (!rdata) {
-				rdata = lport->tt.rport_create(lport, ids);
-				if (!rdata)
-					error = -ENOMEM;
-			}
+			rdata = lport->tt.rport_create(lport, ids);
+			if (!rdata)
+				error = -ENOMEM;
 		}
 		if (rdata) {
 			rdata->ops = &fc_disc_rport_ops;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a9087b3..29bb6fd 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -98,6 +98,10 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 {
 	struct fc_rport_priv *rdata;
 
+	rdata = lport->tt.rport_lookup(lport, ids->port_id);
+	if (rdata)
+		return rdata;
+
 	rdata = kzalloc(sizeof(*rdata), GFP_KERNEL);
 	if (!rdata)
 		return NULL;

