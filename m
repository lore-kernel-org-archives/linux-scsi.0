From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH] [SCSI] bnx2fc: Convert use of __constant_htons to htons
Date: Wed, 19 Aug 2015 11:25:11 +0530
Message-ID: <20150819055511.GA26504@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In little endian cases, the macro htons unfolds to __swab16 which
provides special case for constants. In big endian cases,
__constant_htons and htons expand directly to the same expression.
So, replace __constant_htons with htons with the goal of getting
rid of the definition of __constant_htons completely.

The semantic patch that performs this transformation is as follows:

@@expression x;@@

- __constant_htons(x)
+ htons(x)

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index d5cdc47..99f801c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1201,7 +1201,7 @@ static int bnx2fc_interface_setup(struct bnx2fc_interface *interface)
 	dev_add_pack(&interface->fip_packet_type);
 
 	interface->fcoe_packet_type.func = bnx2fc_rcv;
-	interface->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
+	interface->fcoe_packet_type.type = htons(ETH_P_FCOE);
 	interface->fcoe_packet_type.dev = netdev;
 	dev_add_pack(&interface->fcoe_packet_type);
 
-- 
1.9.1
