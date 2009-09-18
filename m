From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/24] libfc: don't WARN_ON in lport_timeout for RESET state
Date: Fri, 18 Sep 2009 15:49:19 -0700
Message-ID: <20090918224919.5928.34863.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:57922 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758764AbZIRWtQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:49:16 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

It's possible and harmless to get FLOGI timeouts
while in RESET state.  Don't do a WARN_ON in that case.

Also, split out the other WARN_ONs in fc_lport_timeout, so
we can tell which one is hit by its line number.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 278fb04..97e8a35 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1275,10 +1275,13 @@ static void fc_lport_timeout(struct work_struct *work)
 
 	switch (lport->state) {
 	case LPORT_ST_DISABLED:
+		WARN_ON(1);
+		break;
 	case LPORT_ST_READY:
-	case LPORT_ST_RESET:
 		WARN_ON(1);
 		break;
+	case LPORT_ST_RESET:
+		break;
 	case LPORT_ST_FLOGI:
 		fc_lport_enter_flogi(lport);
 		break;

