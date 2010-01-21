From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/5] libfc: Don't assume response request present.
Date: Thu, 21 Jan 2010 10:15:55 -0800
Message-ID: <20100121181555.16741.22367.stgit@localhost.localdomain>
References: <20100121181538.16741.33676.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab0AUSPz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jan 2010 13:15:55 -0500
In-Reply-To: <20100121181538.16741.33676.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hugh Daschbach <hdasch@broadcom.com>, Robert Love <robert.w.love@intel.com>

From: Hugh Daschbach <hdasch@broadcom.com>

Fix NULL pointer dereference crash occurs in fc_lport_bsg_request()
for bsg requests that do not contain a response request.
Specifically, FC_BSG_HST_ADD_RPORT and FC_BSG_HST_DEL_RPORT bsg
requests are not guaranteed to include a response request.

Signed-off-by: Hugh Daschbach <hdasch@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 0b16502..7ec8ce7 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1800,7 +1800,8 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 	u32 did;
 
 	job->reply->reply_payload_rcv_len = 0;
-	rsp->resid_len = job->reply_payload.payload_len;
+	if (rsp)
+		rsp->resid_len = job->reply_payload.payload_len;
 
 	mutex_lock(&lport->lp_mutex);
 

