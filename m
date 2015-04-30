From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 10/12] IB/srp: Remove !ch->target tests from the reconnect
 code
Date: Thu, 30 Apr 2015 11:01:22 +0200
Message-ID: <5541EF62.8050107@sandisk.com>
References: <5541EE21.3050809@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0064.outbound.protection.outlook.com ([157.56.110.64]:4192
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751102AbbD3JB3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 05:01:29 -0400
In-Reply-To: <5541EE21.3050809@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Remove the !ch->target tests from the reconnect code. These
tests are not needed: upon entry of srp_rport_reconnect()
it is guaranteed that all ch->target pointers are non-NULL.
None of the functions srp_new_cm_id(), srp_finish_req(),
srp_create_ch_ib() nor srp_connect_ch() modifies this pointer.
srp_free_ch_ib() is never called concurrently with
srp_rport_reconnect().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a73eb1e5..400ef7a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1216,14 +1216,10 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 	 */
 	for (i = 0; i < target->ch_count; i++) {
 		ch = &target->ch[i];
-		if (!ch->target)
-			break;
 		ret += srp_new_cm_id(ch);
 	}
 	for (i = 0; i < target->ch_count; i++) {
 		ch = &target->ch[i];
-		if (!ch->target)
-			break;
 		for (j = 0; j < target->req_ring_size; ++j) {
 			struct srp_request *req = &ch->req_ring[j];
 
@@ -1232,8 +1228,6 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 	}
 	for (i = 0; i < target->ch_count; i++) {
 		ch = &target->ch[i];
-		if (!ch->target)
-			break;
 		/*
 		 * Whether or not creating a new CM ID succeeded, create a new
 		 * QP. This guarantees that all completion callback function
-- 
2.1.4

