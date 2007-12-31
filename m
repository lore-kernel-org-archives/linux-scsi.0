From: Rob Love <robert.w.love@intel.com>
Subject: [PATCH] [FCoE] Don't panic if session is null in fc_sess_seq_alloc(),
	just return null.
Date: Mon, 31 Dec 2007 10:19:48 -0800
Message-ID: <20071231181948.28443.42615.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31966 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbXLaSaS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Dec 2007 13:30:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Rob Love <robert.w.love@intel.com>
---

 drivers/scsi/ofc/libfc/fc_sess.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/libfc/fc_sess.c
index 34cc2b0..8ac6811 100644
--- a/drivers/scsi/ofc/libfc/fc_sess.c
+++ b/drivers/scsi/ofc/libfc/fc_sess.c
@@ -665,6 +665,8 @@ struct fc_seq *fc_sess_seq_alloc(struct fc_sess *sess,
 	struct fc_exch *ep;
 	struct fc_local_port *lp;
 
+	if (!sess)
+		return NULL;
 	lp = sess->fs_local_port;
 	sp = fc_seq_start_exch(lp->fl_vf->vf_exch_mgr,
 			       recv, errh, arg, sess->fs_local_fid,

