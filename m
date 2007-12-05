From: Joe Eykholt <fcoe@eykholt.com>
Subject: [OpenFCoE PATCH] Don't deliver BLS frames to the fast path.
Date: Tue, 04 Dec 2007 16:51:54 -0800
Message-ID: <20071205005154.26026.71936.stgit@mink.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:36147 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751245AbXLEAv5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:51:57 -0500
Received: from mink.he.net ([127.0.0.1]) by eykholt.com for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 16:51:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Don't deliver BLS frames to the fast path.



Signed-off-by: Joe Eykholt <fcoe@eykholt.com>

---
 drivers/scsi/ofc/libfc/fc_local_port.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index 55de5d3..66a1d47 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -1607,7 +1607,8 @@ void fc_local_port_recv(struct fc_local_port *lp, struct fc_frame *fp)
 		/* fall through */
 	case FC_EOF_N:
 		mp = lp->fl_vf->vf_exch_mgr;
-		if ((f_ctl & (FC_FC_EX_CTX | FC_FC_SEQ_CTX)) == FC_FC_EX_CTX) {
+		if ((f_ctl & (FC_FC_EX_CTX | FC_FC_SEQ_CTX)) == FC_FC_EX_CTX &&
+		    fh->fh_type != FC_TYPE_BLS) {
 			fc_exch_recv_seq_resp(mp, fp);
 		} else if (f_ctl & FC_FC_SEQ_CTX) {
 			fc_exch_recv_resp(mp, fp);


