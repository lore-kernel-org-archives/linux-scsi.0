From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] iscsi class: fix refcount leak
Date: Mon, 16 Jun 2008 10:11:32 -0500
Message-ID: <1213629095-5078-2-git-send-email-michaelc@cs.wisc.edu>
References: <1213629095-5078-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbYFPPMB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2008 11:12:01 -0400
In-Reply-To: <1213629095-5078-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Must do a module_out if the endpoint lookup fails.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9fd5c6d..bc0f74d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1422,8 +1422,10 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		break;
 	case ISCSI_UEVENT_CREATE_BOUND_SESSION:
 		ep = iscsi_lookup_endpoint(ev->u.c_bound_session.ep_handle);
-		if (!ep)
-			return -EINVAL;
+		if (!ep) {
+			err = -EINVAL;
+			break;
+		}
 
 		err = iscsi_if_create_session(priv, ep, ev,
 					ev->u.c_bound_session.initial_cmdsn,
-- 
1.5.4.1

