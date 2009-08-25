From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 36/64] libfc: rport debug messages were printing pointer values
Date: Tue, 25 Aug 2009 14:01:39 -0700
Message-ID: <20090825210139.1553.81510.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10111 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbZHYVBz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:01:55 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Don't print large negative decimal numbers for frame pointers in
the debug messages from fc_rport_error().  Just print 0 if its a
frame pointer, and print the error numbers as positive.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index cbf6c9f..6ecf36d 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -436,7 +436,8 @@ static void fc_rport_timeout(struct work_struct *work)
 static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 {
 	FC_RPORT_DBG(rdata, "Error %ld in state %s, retries %d\n",
-		     PTR_ERR(fp), fc_rport_state(rdata), rdata->retries);
+		     IS_ERR(fp) ? -PTR_ERR(fp) : 0,
+		     fc_rport_state(rdata), rdata->retries);
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PLOGI:

