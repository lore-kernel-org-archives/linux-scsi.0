From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH] scsi: fcoe: Convert use of __constant_htons to htons
Date: Wed, 19 Aug 2015 11:18:44 +0530
Message-ID: <20150819054844.GA21960@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, linux-kernel@vger.kernel.org
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
 drivers/scsi/fcoe/fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ec193a8..d3eb80c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -364,7 +364,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	 * on the ethertype for the given device
 	 */
 	fcoe->fcoe_packet_type.func = fcoe_rcv;
-	fcoe->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
+	fcoe->fcoe_packet_type.type = htons(ETH_P_FCOE);
 	fcoe->fcoe_packet_type.dev = netdev;
 	dev_add_pack(&fcoe->fcoe_packet_type);
 
-- 
1.9.1
