From: Joe Eykholt <fcoe@eykholt.com>
Subject: [OpenFCoE PATCH] Add a missing spin_unlock() found when a BLS frame
	was mis-delivered.
Date: Tue, 04 Dec 2007 16:51:12 -0800
Message-ID: <20071205005112.25831.66010.stgit@mink.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:34971 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750937AbXLEAvP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:51:15 -0500
Received: from mink.he.net ([127.0.0.1]) by eykholt.com for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 16:51:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add a missing spin_unlock() found when a BLS frame was mis-delivered.



Signed-off-by: Joe Eykholt <fcoe@eykholt.com>

---
 drivers/scsi/ofc/openfc/openfc_scsi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
index 86e6895..5fa0ad6 100644
--- a/drivers/scsi/ofc/openfc/openfc_scsi.c
+++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
@@ -548,6 +548,8 @@ void openfc_scsi_abort_iocontext(struct fc_scsi_pkt *fsp)
 		fsp->status_code = OPENFC_ERROR;
 		fsp->io_status = (SUGGEST_RETRY << 24);
 		(*fsp->done) (fsp);
+	} else {
+		spin_unlock(&qp->scsi_pkt_lock);
 	}
 }
 


