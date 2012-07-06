From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/6] libfc: fix retries with FDMI lport states
Date: Fri, 06 Jul 2012 10:40:15 -0700
Message-ID: <20120706174015.4102.70850.stgit@fritz>
References: <20120706173959.4102.12091.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab2GFRkQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jul 2012 13:40:16 -0400
In-Reply-To: <20120706173959.4102.12091.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Marcus Dennis <marcusx.e.dennis@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

The FC-GS-3 sepc requires to wait for least 3 times R_A_TOV per
sec 4.6.1 "If the Requesting_CT does not receive a Response
CT_IU from the Responding_CT within three times R_A_TOV,
it shall consider this to be a protocol error."

This means added four new states with management server
could add significant delay with multiple retries
on default 12 second timeout(3 * R_A_TOV), so instead
just skip these states on very first timeout on any of
these states to not stuck with states for such longer
period.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index c1402fb..45b24a4 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1590,8 +1590,9 @@ static void fc_lport_timeout(struct work_struct *work)
 	case LPORT_ST_RPA:
 	case LPORT_ST_DHBA:
 	case LPORT_ST_DPRT:
-		fc_lport_enter_ms(lport, lport->state);
-		break;
+		FC_LPORT_DBG(lport, "Skipping lport state %s to SCR\n",
+			     fc_lport_state(lport));
+		/* fall thru */
 	case LPORT_ST_SCR:
 		fc_lport_enter_scr(lport);
 		break;

