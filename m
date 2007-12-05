From: Joe Eykholt <fcoe@eykholt.com>
Subject: [OpenFCoE PATCH] Add a missing spin_unlock() found when a BLS frame
	was mis-delivered.
Date: Tue, 04 Dec 2007 17:30:32 -0800
Message-ID: <20071205013032.7067.95628.stgit@mink.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:44464 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750993AbXLEBag (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 20:30:36 -0500
Received: from mink.he.net ([127.0.0.1]) by eykholt.com for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 17:30:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add a missing spin_unlock() found when a BLS frame was mis-delivered.



Signed-off-by: Joe Eykholt <fcoe@eykholt.com>

---
 drivers/scsi/ofc/openfc/openfc_scsi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
index 9e66c5f..6adfd59 100644
--- a/drivers/scsi/ofc/openfc/openfc_scsi.c
+++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
@@ -580,6 +580,8 @@ static void openfc_scsi_rcv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 		fc_seq_exch_complete(sp);
 		fsp->state = OPENFC_SRB_RCV_STATUS;
 		(*fsp->done) (fsp);
+	} else {
+		spin_unlock(&qp->scsi_pkt_lock);
 	}
 out:
 	fc_frame_free(fp);


