From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/28] libfc: Cleanup return paths in fc_rport_error_retry
Date: Fri, 28 Jan 2011 16:03:26 -0800
Message-ID: <20110129000326.1784.22729.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38854 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1A2AD1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:03:27 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

This patch makes it so that we only have one call to
fc_rport_error. This patch does not completely
consolidate return statements, there is still one return
used when not calling fc_rport_error, but alternative
solutions made the code more confusing.

[ Patch modified by Robert Love ]
[ Patch title and commit message edited by Robert Love
  to make it more relevant ]

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a7175ad..325bc42 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -575,7 +575,7 @@ static void fc_rport_error_retry(struct fc_rport_priv *rdata,
 
 	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
 	if (PTR_ERR(fp) == -FC_EX_CLOSED)
-		return fc_rport_error(rdata, fp);
+		goto out;
 
 	if (rdata->retries < rdata->local_port->max_rport_retry_count) {
 		FC_RPORT_DBG(rdata, "Error %ld in state %s, retrying\n",
@@ -588,7 +588,8 @@ static void fc_rport_error_retry(struct fc_rport_priv *rdata,
 		return;
 	}
 
-	return fc_rport_error(rdata, fp);
+out:
+	fc_rport_error(rdata, fp);
 }
 
 /**

