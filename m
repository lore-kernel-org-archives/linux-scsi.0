From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/12] libfc: Fix panic in fc_exch_recv
Date: Fri, 10 Feb 2012 17:18:51 -0800
Message-ID: <20120211011851.7668.53965.stgit@localhost6.localdomain6>
References: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3287 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab2BKBSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 20:18:52 -0500
In-Reply-To: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neerav Parikh <neerav.parikh@intel.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Adding and removing the host into the zone causes this panic.

BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
IP: [<ffffffffa0491707>] fc_exch_recv+0xc57/0xe70 [libfc]
Call Trace:
[<ffffffffa050e04b>] bnx2fc_l2_rcv_thread+0x37b/0x430 [bnx2fc]
[<ffffffffa050dcd0>] ? bnx2fc_l2_rcv_thread+0x0/0x430 [bnx2fc]
[<ffffffff81090886>] kthread+0x96/0xa0
[<ffffffff8100c14a>] child_rip+0xa/0x20
[<ffffffff810907f0>] ? kthread+0x0/0xa0
[<ffffffff8100c140>] ? child_rip+0x0/0x20

During fc_exch_reset, the active exchanges are aborted and the exch is deleted.
As part of processing ABTS response, due to 'ep' being NULL, any access to ep in
fc_exch_recv_bls() causes this panic. Fixed to access 'ep' only if non-NULL.

Reviewed-by: Neerav Parikh <neerav.parikh@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 4d70d96..630291f 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1642,9 +1642,10 @@ static void fc_exch_recv_bls(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		case FC_RCTL_ACK_0:
 			break;
 		default:
-			FC_EXCH_DBG(ep, "BLS rctl %x - %s received",
-				    fh->fh_r_ctl,
-				    fc_exch_rctl_name(fh->fh_r_ctl));
+			if (ep)
+				FC_EXCH_DBG(ep, "BLS rctl %x - %s received",
+					    fh->fh_r_ctl,
+					    fc_exch_rctl_name(fh->fh_r_ctl));
 			break;
 		}
 		fc_frame_free(fp);

