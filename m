From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 50/64] libfc: don't do discovery before callback is set
Date: Tue, 25 Aug 2009 14:02:54 -0700
Message-ID: <20090825210254.1553.40316.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52144 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbZHYVCw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:52 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

It's possible to "restart" discovery before it was started if
an RSCN is received early enough.  We were jumping to 0
due to the disc_callback function pointer not getting set.

Don't restart discovery if disc_callback is NULL.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 4284218..1a699f4 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -219,6 +219,9 @@ static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
  */
 static void fc_disc_restart(struct fc_disc *disc)
 {
+	if (!disc->disc_callback)
+		return;
+
 	FC_DISC_DBG(disc, "Restarting discovery\n");
 
 	disc->requested = 1;

