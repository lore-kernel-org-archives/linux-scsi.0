From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 27/35] libfc, fcoe: Don't EXPORT_SYMBOLS unnecessarily
Date: Fri, 11 Sep 2009 16:59:19 -0700
Message-ID: <20090911235919.27223.49492.stgit@localhost.localdomain>
References: <20090911235655.27223.69728.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21145 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbZIKX7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:59:18 -0400
In-Reply-To: <20090911235655.27223.69728.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

These are a few functions that were not used by other
modules. They did not need to be exported so this patch
removes the EXPORT_SYMBOLS call for each.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c  |    1 -
 drivers/scsi/libfc/fc_fcp.c   |    1 -
 drivers/scsi/libfc/fc_frame.c |    1 -
 drivers/scsi/libfc/fc_rport.c |    2 --
 4 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index c40eab5..8e815d4 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -519,7 +519,6 @@ static int fc_seq_exch_abort(const struct fc_seq *req_sp,
 		error = -ENOBUFS;
 	return error;
 }
-EXPORT_SYMBOL(fc_seq_exch_abort);
 
 /*
  * Exchange timeout - handle exchange timer expiration.
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index a474773..a523e4f 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -279,7 +279,6 @@ void fc_fcp_ddp_setup(struct fc_fcp_pkt *fsp, u16 xid)
 			fsp->xfer_ddp = xid;
 	}
 }
-EXPORT_SYMBOL(fc_fcp_ddp_setup);
 
 /*
  * fc_fcp_ddp_done - calls to LLD's ddp_done to release any
diff --git a/drivers/scsi/libfc/fc_frame.c b/drivers/scsi/libfc/fc_frame.c
index c5f4484..8ddb685 100644
--- a/drivers/scsi/libfc/fc_frame.c
+++ b/drivers/scsi/libfc/fc_frame.c
@@ -70,7 +70,6 @@ struct fc_frame *__fc_frame_alloc(size_t len)
 }
 EXPORT_SYMBOL(__fc_frame_alloc);
 
-
 struct fc_frame *fc_frame_alloc_fill(struct fc_lport *lp, size_t payload_len)
 {
 	struct fc_frame *fp;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index bf42a98..239fe54 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1567,13 +1567,11 @@ int fc_setup_rport(void)
 		return -ENOMEM;
 	return 0;
 }
-EXPORT_SYMBOL(fc_setup_rport);
 
 void fc_destroy_rport(void)
 {
 	destroy_workqueue(rport_event_queue);
 }
-EXPORT_SYMBOL(fc_destroy_rport);
 
 void fc_rport_terminate_io(struct fc_rport *rport)
 {

