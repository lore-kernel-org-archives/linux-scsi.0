From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 05/12] IB/srp: Fix reconnection failure handling
Date: Thu, 30 Apr 2015 10:58:57 +0200
Message-ID: <5541EED1.8020702@sandisk.com>
References: <5541EE21.3050809@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0060.outbound.protection.outlook.com ([207.46.100.60]:34009
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750803AbbD3I7C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 04:59:02 -0400
In-Reply-To: <5541EE21.3050809@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Although it is possible to let SRP I/O continue if a reconnect
results in a reduction of the number of channels, the current
code does not handle this scenario correctly. Instead of making
the reconnect code more complex, consider this as a reconnection
failure.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: <stable@vger.kernel.org> #v3.19
---
 drivers/infiniband/ulp/srp/ib_srp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0eb07d3..5d7d790 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1246,11 +1246,8 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 	}
 	for (i = 0; i < target->ch_count; i++) {
 		ch = &target->ch[i];
-		if (ret || !ch->target) {
-			if (i > 1)
-				ret = 0;
+		if (ret)
 			break;
-		}
 		ret = srp_connect_ch(ch, multich);
 		multich = true;
 	}
-- 
2.1.4

