From: Joe Eykholt <fcoe@eykholt.com>
Subject: [OpenFCoE] [PATCH] (user-level) Don't deliver BLS frames to the fast
 path.
Date: Fri, 30 Nov 2007 10:55:15 -0800
Message-ID: <47505C93.30906@eykholt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:50821 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762240AbXK3SzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Nov 2007 13:55:06 -0500
Received: from 67.91.200.194 ([67.91.200.194]) by eykholt.com for <linux-scsi@vger.kernel.org>; Fri, 30 Nov 2007 10:55:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Don't deliver BLS frames to the fast path.

---
 usr/common/libfc/src/fc/fc_local_port.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/usr/common/libfc/src/fc/fc_local_port.c b/usr/common/libfc/src/fc/fc_local_port.c
index ba909d0..a798765 100644
--- a/usr/common/libfc/src/fc/fc_local_port.c
+++ b/usr/common/libfc/src/fc/fc_local_port.c
@@ -1611,7 +1611,8 @@ void fc_local_port_recv(struct fc_local_port *lp, struct fc_frame *fp)
                /* fall through */
        case FC_EOF_N:
                mp = lp->fl_vf->vf_exch_mgr;
-               if ((f_ctl & (FC_FC_EX_CTX | FC_FC_SEQ_CTX)) == FC_FC_EX_CTX) {
+               if ((f_ctl & (FC_FC_EX_CTX | FC_FC_SEQ_CTX)) == FC_FC_EX_CTX &&
+                   fh->fh_type != FC_TYPE_BLS) {
                        fc_exch_recv_seq_resp(mp, fp);
                } else if (f_ctl & FC_FC_SEQ_CTX) {
                        fc_exch_recv_resp(mp, fp);
--
1.5.3.6
