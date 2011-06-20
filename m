From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/12] libfc: Enhancement to RPORT state machine applicable
 only for VN2VN mode
Date: Mon, 20 Jun 2011 16:30:18 -0700
Message-ID: <20110620233018.31635.63696.stgit@localhost6.localdomain6>
References: <20110620233007.31635.60206.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab1FTXaT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:30:19 -0400
In-Reply-To: <20110620233007.31635.60206.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Problem: Existing RPORT state machine continues witg FLOGI/PLOGI process
only after it receices beacon from other end. Once claiming stage is over
(either clain notify or clain repose), beacon is sent and state machine
enters into operational mode where it initiates the rlogin process (FLOGI/PLOGI)
to the peer but before this rlogin is initiated, exitsing implementation
checks if it received beacon from other end, it beacon is not received yet,
rlogin process is not initiated. Other end initiates FLOGI but peer end keeps
on rejecting FLOGI, hence after 3 retries other end deletes associated rport,
then sends a beacon. Once the beacon is received, peer end now initiates rlogin
to the peer end but since associated rport is deleted FLOGI is neither accepted
nor the reject response send out because rport is deleted. Hence unable to proceed
withg FLOGI/PLOGI process and fails to establish VN2VN connection.

Fix: VN2VN spec is not standard yet but based on exitsing collateral on T11, it appears
that, both end shall send beacon and enter into 'operational mode' without
explictly waiting for beacon from other end. Fix is to allow the RPORT login
process as long as respective RPORT is created (as part of claim notification /
claim response) even though state of RPORT is INIT. Means don't wait for beacon
from peer end, if peer end initiates FLOGI (means peer end exist and responding).

Notes: This patch is preparing the FCoE stack for target wrt offload. This is generic
patch and harmless even if applied on storage initiator because 'else if' condition
of function 'fcoe_oem_found' shall evaluate to TRUE only for targets.

Dependencies: None

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 49e1ccc..3b66937 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -801,6 +801,20 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_INIT:
+		/*
+		 * If received the FLOGI request on RPORT which is INIT state
+		 * (means not transition to FLOGI either fc_rport timeout
+		 * function didn;t trigger or this end hasn;t received
+		 * beacon yet from other end. In that case only, allow RPORT
+		 * state machine to continue, otherwise fall through which
+		 * causes the code to send reject response.
+		 * NOTE; Not checking for FIP->state such as VNMP_UP or
+		 * VNMP_CLAIM because if FIP state is not one of those,
+		 * RPORT wouldn;t have created and 'rport_lookup' would have
+		 * failed anyway in that case.
+		 */
+		if (lport->point_to_multipoint)
+			break;
 	case RPORT_ST_DELETE:
 		mutex_unlock(&rdata->rp_mutex);
 		rjt_data.reason = ELS_RJT_FIP;

