From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 11/12] IB/srp: Remove !ch->target tests from the reconnect
 code
Date: Mon, 18 May 2015 13:26:17 +0200
Message-ID: <5559CC59.8@sandisk.com>
References: <5559CB3A.6060102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0066.outbound.protection.outlook.com ([65.55.169.66]:50062
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753724AbbERL0Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 May 2015 07:26:25 -0400
In-Reply-To: <5559CB3A.6060102@sandisk.com>
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
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index dd6f928..a0a2348 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1226,14 +1226,10 @@ static int srp_rport_reconnect(struct srp_rport *rport)
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
 
@@ -1242,8 +1238,6 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 	}
 	for (i = 0; i < target->ch_count; i++) {
 		ch = &target->ch[i];
-		if (!ch->target)
-			break;
 		/*
 		 * Whether or not creating a new CM ID succeeded, create a new
 		 * QP. This guarantees that all completion callback function
@@ -1260,7 +1254,7 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 
 	for (i = 0; i < target->ch_count; i++) {
 		ch = &target->ch[i];
-		if (ret || !ch->target)
+		if (ret)
 			break;
 		ret = srp_connect_ch(ch, multich);
 		multich = true;
-- 
2.1.4

