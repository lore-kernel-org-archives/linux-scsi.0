From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH v2 06/14] BNX2I: Allow to abort the connection if
 connect request times out
Date: Thu, 18 Nov 2010 17:30:01 -0800
Message-ID: <1290130209-32133-7-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3006 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0KSCMz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 21:12:55 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

In the situation where the connect completion response arrives after
the connect request has already timed out, the connection was not being
aborted but only the resource was being freed.  This creates a problem
for 5771X (10g) as the chip flags this with an assertion.

This change will properly aborts the connection before freeing the
resource.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 4882b00..a2c9b1f 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1906,13 +1906,13 @@ static int bnx2i_ep_tcp_conn_active(struct bnx2i_endpoint *bnx2i_ep)
 		cnic_dev_10g = 1;
 
 	switch (bnx2i_ep->state) {
-	case EP_STATE_CONNECT_START:
 	case EP_STATE_CONNECT_FAILED:
 	case EP_STATE_CLEANUP_FAILED:
 	case EP_STATE_OFLD_FAILED:
 	case EP_STATE_DISCONN_TIMEDOUT:
 		ret = 0;
 		break;
+	case EP_STATE_CONNECT_START:
 	case EP_STATE_CONNECT_COMPL:
 	case EP_STATE_ULP_UPDATE_START:
 	case EP_STATE_ULP_UPDATE_COMPL:
-- 
1.7.0.5


