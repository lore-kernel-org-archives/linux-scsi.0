From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH] message/fusion: remove redundant memset
Date: Wed, 8 Aug 2007 08:32:51 +0200
Message-ID: <200708080832.51578.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2235 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbXHHGcy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Aug 2007 02:32:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

	alloc_fcdev() calls alloc_netdev() which uses kzalloc to alloc
all the memory together with dev->priv region hence no zeroing of structs
inside struct mpt_lan_priv needed.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/message/fusion/mptlan.c | 47738 -> 47618 (-120 bytes)
 drivers/message/fusion/mptlan.o | 170800 -> 170124 (-676 bytes)

 drivers/message/fusion/mptlan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc1-mm2-a/drivers/message/fusion/mptlan.c	2007-08-01 08:43:47.000000000 +0200
+++ linux-2.6.23-rc1-mm2-b/drivers/message/fusion/mptlan.c	2007-08-07 01:33:49.000000000 +0200
@@ -1351,10 +1351,11 @@ mpt_lan_post_receive_buckets_work(struct
 static struct net_device *
 mpt_register_lan_device (MPT_ADAPTER *mpt_dev, int pnum)
 {
-	struct net_device *dev = alloc_fcdev(sizeof(struct mpt_lan_priv));
-	struct mpt_lan_priv *priv = NULL;
+	struct net_device *dev;
+	struct mpt_lan_priv *priv;
 	u8 HWaddr[FC_ALEN], *a;

+	dev = alloc_fcdev(sizeof(struct mpt_lan_priv));
 	if (!dev)
 		return NULL;

@@ -1366,7 +1367,6 @@ mpt_register_lan_device (MPT_ADAPTER *mp
 	priv->mpt_dev = mpt_dev;
 	priv->pnum = pnum;

-	memset(&priv->post_buckets_task, 0, sizeof(priv->post_buckets_task));
 	INIT_DELAYED_WORK(&priv->post_buckets_task,
 			  mpt_lan_post_receive_buckets_work);
 	priv->post_buckets_active = 0;
@@ -1391,8 +1391,6 @@ mpt_register_lan_device (MPT_ADAPTER *mp
 	spin_lock_init(&priv->txfidx_lock);
 	spin_lock_init(&priv->rxfidx_lock);

-	memset(&priv->stats, 0, sizeof(priv->stats));
-
 	/*  Grab pre-fetched LANPage1 stuff. :-) */
 	a = (u8 *) &mpt_dev->lan_cnfg_page1.HardwareAddressLow;

