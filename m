From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 1/8] BNX2I: Allow ep CONNECT_FAILED condition to go
 through proper cleanup
Date: Wed, 5 Jan 2011 12:44:20 -0800
Message-ID: <1294260267-17413-2-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4816 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab1AEUlz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 15:41:55 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Allow CNIC to go through the proper cleanup procedure for an endpoint
which failed to connect.  Proper cleanup is necessary for the chip
to reset back to the initial state for the offloaded endpoint.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f0dce26..f9415aa 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1935,13 +1935,13 @@ static int bnx2i_ep_tcp_conn_active(struct bnx2i_endpoint *bnx2i_ep)
 		cnic_dev_10g = 1;
 
 	switch (bnx2i_ep->state) {
-	case EP_STATE_CONNECT_FAILED:
 	case EP_STATE_CLEANUP_FAILED:
 	case EP_STATE_OFLD_FAILED:
 	case EP_STATE_DISCONN_TIMEDOUT:
 		ret = 0;
 		break;
 	case EP_STATE_CONNECT_START:
+	case EP_STATE_CONNECT_FAILED:
 	case EP_STATE_CONNECT_COMPL:
 	case EP_STATE_ULP_UPDATE_START:
 	case EP_STATE_ULP_UPDATE_COMPL:
-- 
1.7.0.5


