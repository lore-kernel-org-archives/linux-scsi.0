From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH] mptlan: fix mpt_lan_sdu_send()'s return type
Date: Tue, 24 Apr 2018 15:15:58 +0200
Message-ID: <20180424131558.3010-1-luc.vanoostenryck@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/message/fusion/mptlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 55dd71bbd..4cbed4d06 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -670,7 +670,7 @@ mpt_lan_send_reply(struct net_device *dev, LANSendReply_t *pSendRep)
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-static int
+static netdev_tx_t
 mpt_lan_sdu_send (struct sk_buff *skb, struct net_device *dev)
 {
 	struct mpt_lan_priv *priv = netdev_priv(dev);
-- 
2.17.0
