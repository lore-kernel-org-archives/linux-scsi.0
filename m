From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 54/64] libfc: fix: rport_recv_req needs disc_mutex when
	calling rport_lookup
Date: Tue, 25 Aug 2009 14:03:15 -0700
Message-ID: <20090825210315.1553.46861.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64207 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218AbZHYVDN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:13 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The rport_lookup function must be called while holding the disc_mutex.
Otherwise, the rdata could be deleted just after that by another thread.

All callers now check the state after grabbing the rdata rp_mutex.
Even though rport_lookup skips ports in DELETE state, it does that
without holding the rdata rp_mutex, so that the state may change.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index acdc72d..02200b2 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -932,14 +932,17 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 	fh = fc_frame_header_get(fp);
 	s_id = ntoh24(fh->fh_s_id);
 
+	mutex_lock(&lport->disc.disc_mutex);
 	rdata = lport->tt.rport_lookup(lport, s_id);
 	if (!rdata) {
+		mutex_unlock(&lport->disc.disc_mutex);
 		els_data.reason = ELS_RJT_UNAB;
 		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
 		fc_frame_free(fp);
 		return;
 	}
 	mutex_lock(&rdata->rp_mutex);
+	mutex_unlock(&lport->disc.disc_mutex);
 
 	op = fc_frame_payload_op(fp);
 	switch (op) {

