From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 06/12] IB/srp: Fix reconnection failure handling
Date: Mon, 18 May 2015 13:24:17 +0200
Message-ID: <5559CBE1.9000202@sandisk.com>
References: <5559CB3A.6060102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0079.outbound.protection.outlook.com ([207.46.100.79]:61207
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751870AbbERLY1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 May 2015 07:24:27 -0400
In-Reply-To: <5559CB3A.6060102@sandisk.com>
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
index 83e4d8a..982e329 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1259,11 +1259,8 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 
 	for (i = 0; i < target->ch_count; i++) {
 		ch = &target->ch[i];
-		if (ret || !ch->target) {
-			if (i > 1)
-				ret = 0;
+		if (ret || !ch->target)
 			break;
-		}
 		ret = srp_connect_ch(ch, multich);
 		multich = true;
 	}
-- 
2.1.4

