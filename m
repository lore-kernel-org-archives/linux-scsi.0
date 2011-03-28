From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/4] bnx2fc: host stats show the link speed 'unknown' on
 NIC partitioned interfaces
Date: Mon, 28 Mar 2011 16:12:54 -0700
Message-ID: <1301353974.6312.50.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3614 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1C1XND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2011 19:13:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, mchan@broadcom.com

NIC partitioned interfaces reports the speed of 2500 which was not handled by
the driver.  Also, removed unnecessary return for a void function.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e2e6475..754e9c6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -677,10 +677,11 @@ static void bnx2fc_link_speed_update(struct fc_lport *lport)
 
 		if (ecmd.speed == SPEED_1000)
 			lport->link_speed = FC_PORTSPEED_1GBIT;
-		if (ecmd.speed == SPEED_10000)
+		else if (ecmd.speed == SPEED_2500)
+			lport->link_speed = FC_PORTSPEED_2GBIT;
+		else if (ecmd.speed == SPEED_10000)
 			lport->link_speed = FC_PORTSPEED_10GBIT;
 	}
-	return;
 }
 static int bnx2fc_link_ok(struct fc_lport *lport)
 {
-- 
1.7.0.6




