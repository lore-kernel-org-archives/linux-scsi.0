From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/12] libfc: remove unneeded variables in fc_exch_recv_req()
Date: Fri, 09 Apr 2010 14:22:33 -0700
Message-ID: <20100409212233.1968.10671.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:14638 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346Ab0DIVWq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:22:46 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

fc_exch_recv_req has variables eof, sof, and f_ctl,
which are set but never used.  Delete them.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index d0496da..daff880 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1241,9 +1241,6 @@ static void fc_exch_recv_req(struct fc_lport *lport, struct fc_exch_mgr *mp,
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 	struct fc_seq *sp = NULL;
 	struct fc_exch *ep = NULL;
-	enum fc_sof sof;
-	enum fc_eof eof;
-	u32 f_ctl;
 	enum fc_pf_rjt_reason reject;
 
 	/* We can have the wrong fc_lport at this point with NPIV, which is a
@@ -1260,9 +1257,6 @@ static void fc_exch_recv_req(struct fc_lport *lport, struct fc_exch_mgr *mp,
 	if (reject == FC_RJT_NONE) {
 		sp = fr_seq(fp);	/* sequence will be held */
 		ep = fc_seq_exch(sp);
-		sof = fr_sof(fp);
-		eof = fr_eof(fp);
-		f_ctl = ntoh24(fh->fh_f_ctl);
 		fc_seq_send_ack(sp, fp);
 
 		/*

