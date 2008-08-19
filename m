From: michaelc@cs.wisc.edu
Subject: [PATCH 5/9] fc class: Add support for new transport errors
Date: Tue, 19 Aug 2008 18:45:27 -0500
Message-ID: <1219189531-5243-6-git-send-email-michaelc@cs.wisc.edu>
References: <1219189531-5243-1-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-2-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-3-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-4-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbYHSXps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 19:45:48 -0400
In-Reply-To: <1219189531-5243-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the target is blocked and fast io fail tmo has not fired
then we requeue with DID_TRANSPORT_DISRUPTED. Once that
tmo fires we fail with DID_TRANSPORT_FAILFAST.

v2
- seperate from
"fc class: unblock target after calling terminate callback"
to make it easier to review.
- Add JamesS's ack from list.
v2
- initial patch

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: James Smart <James.Smart@emulex.com>
---
 include/scsi/scsi_transport_fc.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 347e30f..65d3986 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -660,15 +660,15 @@ fc_remote_port_chkready(struct fc_rport *rport)
 		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
 			result = 0;
 		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
-			result = DID_IMM_RETRY << 16;
+			result = DID_TRANSPORT_DISRUPTED << 16;
 		else
 			result = DID_NO_CONNECT << 16;
 		break;
 	case FC_PORTSTATE_BLOCKED:
 		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
-			result = DID_NO_CONNECT << 16;
+			result = DID_TRANSPORT_FAILFAST << 16;
 		else
-			result = DID_IMM_RETRY << 16;
+			result = DID_TRANSPORT_DISRUPTED << 16;
 		break;
 	default:
 		result = DID_NO_CONNECT << 16;
-- 
1.5.4.1

