From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/27] libfc: fix memory leakage in remote port
Date: Tue, 30 Nov 2010 16:19:04 -0800
Message-ID: <20101201001904.18369.57123.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5041 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab0LAATF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:05 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

There seems rdata should get put before return.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a84ef13..a7175ad 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -652,7 +652,7 @@ void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_RPORT_DBG(rdata, "Received a FLOGI %s\n", fc_els_resp_type(fp));
 
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
-		return;
+		goto put;
 
 	mutex_lock(&rdata->rp_mutex);
 
@@ -689,6 +689,7 @@ out:
 	fc_frame_free(fp);
 err:
 	mutex_unlock(&rdata->rp_mutex);
+put:
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 	return;
 bad:

