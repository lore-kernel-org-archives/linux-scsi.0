From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH] [SCSI] fnic: Replace memset with eth_broadcast_addr
Date: Mon, 22 Jun 2015 08:18:06 +0530
Message-ID: <20150622024806.GA4736@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35545 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbbFVCsO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2015 22:48:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Use eth_zero_addr to assign the zero address to the given address
array instead of memset when second argument is a broadcast
address 0xff.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@eth_broadcast_addr@
identifier e;
@@

-memset(e,\(0xff\|0xFF\|255\),ETH_ALEN);
+eth_broadcast_addr(e);
// </smpl>

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 155b286..650d448 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -276,7 +276,7 @@ int fnic_flogi_reg_handler(struct fnic *fnic, u32 fc_id)
 	}
 
 	if (fnic->ctlr.map_dest) {
-		memset(gw_mac, 0xff, ETH_ALEN);
+		eth_broadcast_addr(gw_mac);
 		format = FCPIO_FLOGI_REG_DEF_DEST;
 	} else {
 		memcpy(gw_mac, fnic->ctlr.dest_addr, ETH_ALEN);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
