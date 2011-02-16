From: michaelc@cs.wisc.edu
Subject: [PATCH 01/17] BNX2I: Allow ep CONNECT_FAILED condition to go through proper cleanup
Date: Wed, 16 Feb 2011 15:04:25 -0600
Message-ID: <1297890281-9076-2-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1BPVEb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:31 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4VhF027047
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:31 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tso004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:31 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Eddie Wai <eddie.wai@broadcom.com>

Allow CNIC to go through the proper cleanup procedure for an endpoint
which failed to connect.  Proper cleanup is necessary for the chip
to reset back to the initial state for the offloaded endpoint.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
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
1.7.2.3

