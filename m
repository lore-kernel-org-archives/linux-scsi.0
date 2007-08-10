From: akpm@linux-foundation.org
Subject: [patch 30/30] message/fusion: remove redundant memset
Date: Fri, 10 Aug 2007 14:50:53 -0700
Message-ID: <200708102150.l7ALorA8011410@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46119 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760705AbXHJWBo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, m.kozlowski@tuxland.pl, Eric.Moore@lsil.com

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

alloc_fcdev() calls alloc_netdev() which uses kzalloc to alloc all the
memory together with dev->priv region hence no zeroing of structs inside
struct mpt_lan_priv needed.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptlan.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/message/fusion/mptlan.c~message-fusion-remove-redundant-memset drivers/message/fusion/mptlan.c
--- a/drivers/message/fusion/mptlan.c~message-fusion-remove-redundant-memset
+++ a/drivers/message/fusion/mptlan.c
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
 
_
