From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/12] IB/srp: Remove a superfluous check from srp_free_req_data()
Date: Thu, 30 Apr 2015 11:01:03 +0200
Message-ID: <5541EF4F.6050200@sandisk.com>
References: <5541EE21.3050809@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0085.outbound.protection.outlook.com ([157.56.110.85]:12719
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155AbbD3JBK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 05:01:10 -0400
In-Reply-To: <5541EE21.3050809@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

All srp_free_req_data() callers guarantee that ch->target != NULL
hence remove the ch->target test from srp_free_req_data().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 3727b90..a73eb1e5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -853,7 +853,7 @@ static void srp_free_req_data(struct srp_target_port *target,
 	struct srp_request *req;
 	int i;
 
-	if (!ch->target || !ch->req_ring)
+	if (!ch->req_ring)
 		return;
 
 	for (i = 0; i < target->req_ring_size; ++i) {
-- 
2.1.4

