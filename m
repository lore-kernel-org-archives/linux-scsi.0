From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/6] libfc: don't exch_done() on invalid sequence ptr
Date: Fri, 06 Jul 2012 10:40:26 -0700
Message-ID: <20120706174026.4102.72390.stgit@fritz>
References: <20120706173959.4102.12091.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40525 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057Ab2GFRk0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jul 2012 13:40:26 -0400
In-Reply-To: <20120706173959.4102.12091.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

The lport_recv(), i.e., fc_lport_recv_req() may get called w/o the sequence ptr
being set in fr_seq(), particularly in the case of vn2vn mode, this may happen
if the passive fcp provider, e.g., tcm_fc, has not been registered yet.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 45b24a4..55f58ee 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -973,7 +973,8 @@ drop:
 	rcu_read_unlock();
 	FC_LPORT_DBG(lport, "dropping unexpected frame type %x\n", fh->fh_type);
 	fc_frame_free(fp);
-	lport->tt.exch_done(sp);
+	if (sp)
+		lport->tt.exch_done(sp);
 }
 
 /**

