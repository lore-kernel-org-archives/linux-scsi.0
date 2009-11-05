From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] fc class: fail fast bsg requests
Date: Thu,  5 Nov 2009 11:18:09 -0600
Message-ID: <1257441489-9055-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZKERSI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2009 12:18:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, "james.smart@emulex.com" <james.smart@emulex.com>

From: Mike Christie <michaelc@cs.wisc.edu>

If the port state is blocked and the fast io fail tmo has
fired then this patch will fail bsg requests immediately.
This is needed if userspace is sending IOs to test the transport
like with fcping, so it will not have to wait for the dev loss tmo.
With this patch he bsg req fast io fail code behaves like the normal
and sg io/passthrough fast io fail.

Patch was made over scsi-rc-fixes. It is only compiled tested.
I found this while looking over the iscsi bsg patch.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: james.smart@emulex.com <james.smart@emulex.com>
---
 drivers/scsi/scsi_transport_fc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index c6f70da..1004684 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3769,8 +3769,9 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
 		return;
 
 	while (!blk_queue_plugged(q)) {
-		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED))
-				break;
+		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED) &&
+		    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
+			break;
 
 		req = blk_fetch_request(q);
 		if (!req)
-- 
1.6.0.6

