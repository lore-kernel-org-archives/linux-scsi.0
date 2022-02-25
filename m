Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38F8C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 05:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237667AbiBYF5C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 00:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiBYF5A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 00:57:00 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ADE1F03BE
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 21:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645768586; x=1677304586;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YOTw6aiBEo4hOezxZZQmQ1gQ9ksmHED9kU9s6KDdBvY=;
  b=C7YDpHFxc0y5B4ey1qmySqJGf1KKSKuwZ5mvQs5AYKHd7OwJk+HyeDe1
   E+KPVp0gsWXh0v0fTssygv69zexfLzVuYin4A05en8LuB11eAOc4JfNso
   d4fZC4jOt/fmfHT7Hhcv4zub/bePlE8znb8eMv7p1GfCs1+OBOgfbckrw
   jVug/sVH66EeHQva1ch0o4URTcmjd5GzswxF46+sAFkH9RXC2iRlNwojE
   5+P3LAx3x3oCBzv1MuDAeIHvbNNabG8ERLZzU+fDQiTpZl9/EvNBky42l
   OxWSSKN/Ut86bn32F08DfCmcFA86oRYjVrjNQepeL6Hn4NDgZPe6M6dZ6
   w==;
X-IronPort-AV: E=Sophos;i="5.90,135,1643644800"; 
   d="scan'208";a="193921597"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 13:56:25 +0800
IronPort-SDR: TT6aSOngZ8+nLyNCp40Avdd2/loE/YjWuKoMbTnh915bv/92pEeq+lkgN/UUBcgdEcmy+/iDQR
 Z6KsbN25yBYISTgaYBrzsixASLIk1R2dC+3MTpUS/zz2GcaVZY15ktEcrbUbDFcTNnzMkC5ZX7
 Wzvt81OjS+KAZeGRT2tSpjypZtlGnVd6rhb5ZFIReYyqGMryhf1ONhbxVMmjJrB1fH1W29OfAy
 UZh+OuqEzDMGrEvTsovdEJy/rBqirGt/5xHgqBv701BcWbkdEvwq29YmclkIPhBYfjB7qAJ/Ah
 R8i1WSd/LBYrHKjndHwyEa1J
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 21:29:00 -0800
IronPort-SDR: xbGZN/KnBtJ34B00DpbblPv9p0BlRFSHh3clXKtFr25JWYduH2inGUlEnsTVLYdn2Up+kvFVIq
 j5apSmVQNNlRLbh99u1vXyRjujQKFQTIjhS4NgBxH8Eyac6W2nYE7cpUYNGj9uDqQOWayhZeqA
 wRENOthHdnoX+YH+V56LT0qyuibC99o6slC2Wltu30kD0ZQ4T+VTLZZh5Yktw14jLg3/ky2oyr
 BvSYfHiZiXjtRkclWcoNVJ0Dgl3cktENfnpzzDuOdf3bwqIyuv476uklHDrqnCK9N56HdbL5UI
 wz8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 21:56:28 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4fCt55Ycz1Rwrw
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 21:56:26 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1645768586;
         x=1648360587; bh=YOTw6aiBEo4hOezxZZQmQ1gQ9ksmHED9kU9s6KDdBvY=; b=
        kwK5pxbNd/rKM9oTdwtDZPmEVOyGXxP8Pf3yZqOrn9VnLzVZy/D7DS7TlzRe9gbJ
        mL6A9ZZYlQ3qaNhFaUtPTerJPIG7nVkPT6du8zupgwpDJiMZBMUICAfXX6THhvRG
        xG+oK6smQBj/rGl+fNeuLfiRn01T8MleAf99l9NJWJc86rHafhpIXC6EeOWsdABR
        ZRfn0qafa7ZcGHxOWPDVPeMMgMSpY6f3cZFoXUh0wRRpt3yIFb06JZJ60iHUVR67
        m6yNz9VUvl01xZEizfbTKbsh1hyZ7G/3zIweuBIyy+tcLAg5CXHdXq7BGx5HVzyc
        dOnwuRr02DJNKBnSKVX3dg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id uQwWWVQ6qyr7 for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 21:56:26 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4fCs2Hxgz1Rvlx;
        Thu, 24 Feb 2022 21:56:25 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] scsi: libsas: cleanup sas_form_port()
Date:   Fri, 25 Feb 2022 14:56:21 +0900
Message-Id: <20220225055621.410896-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sparse throws a warning about context imbalance ("different lock
contexts for basic block") in sas_form_port() as it gets confused with
the fact that a port is locked within one of the 2 search loop and
unlocked afterward outside of the search loops once the phy is added to
the port. Since this code is not easy to follow, improve it by factoring
out the code adding the phy to the port once the port is locked into the
helper function __sas_form_port(). This helper can then be called
directly within the port search loops, avoiding confusion and clearing
the sparse warning.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/libsas/sas_port.c | 76 ++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_por=
t.c
index 67b429dcf1ff..90bd1666f888 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -67,6 +67,39 @@ static void sas_resume_port(struct asd_sas_phy *phy)
 	sas_discover_event(port, DISCE_RESUME);
 }
=20
+static struct domain_device *__sas_form_port(struct asd_sas_port *port,
+					     struct asd_sas_phy *phy,
+					     bool wideport)
+{
+	struct domain_device *port_dev =3D port->port_dev;
+
+	list_add_tail(&phy->port_phy_el, &port->phy_list);
+	sas_phy_set_target(phy, port_dev);
+	phy->port =3D port;
+	port->num_phys++;
+	port->phy_mask |=3D (1U << phy->id);
+
+	if (wideport)
+		pr_debug("phy%d matched wide port%d\n", phy->id,
+			 port->id);
+	else
+		memcpy(port->sas_addr, phy->sas_addr, SAS_ADDR_SIZE);
+
+	if (*(u64 *)port->attached_sas_addr =3D=3D 0) {
+		port->class =3D phy->class;
+		memcpy(port->attached_sas_addr, phy->attached_sas_addr,
+		       SAS_ADDR_SIZE);
+		port->iproto =3D phy->iproto;
+		port->tproto =3D phy->tproto;
+		port->oob_mode =3D phy->oob_mode;
+		port->linkrate =3D phy->linkrate;
+	} else {
+		port->linkrate =3D max(port->linkrate, phy->linkrate);
+	}
+
+	return port_dev;
+}
+
 /**
  * sas_form_port - add this phy to a port
  * @phy: the phy of interest
@@ -79,7 +112,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	int i;
 	struct sas_ha_struct *sas_ha =3D phy->ha;
 	struct asd_sas_port *port =3D phy->port;
-	struct domain_device *port_dev;
+	struct domain_device *port_dev =3D NULL;
 	struct sas_internal *si =3D
 		to_sas_internal(sas_ha->core.shost->transportt);
 	unsigned long flags;
@@ -110,8 +143,8 @@ static void sas_form_port(struct asd_sas_phy *phy)
 		if (*(u64 *) port->sas_addr &&
 		    phy_is_wideport_member(port, phy) && port->num_phys > 0) {
 			/* wide port */
-			pr_debug("phy%d matched wide port%d\n", phy->id,
-				 port->id);
+			port_dev =3D __sas_form_port(port, phy, true);
+			spin_unlock(&port->phy_list_lock);
 			break;
 		}
 		spin_unlock(&port->phy_list_lock);
@@ -122,40 +155,21 @@ static void sas_form_port(struct asd_sas_phy *phy)
 			port =3D sas_ha->sas_port[i];
 			spin_lock(&port->phy_list_lock);
 			if (*(u64 *)port->sas_addr =3D=3D 0
-				&& port->num_phys =3D=3D 0) {
-				memcpy(port->sas_addr, phy->sas_addr,
-					SAS_ADDR_SIZE);
+			    && port->num_phys =3D=3D 0) {
+				port_dev =3D __sas_form_port(port, phy, false);
+				spin_unlock(&port->phy_list_lock);
 				break;
 			}
 			spin_unlock(&port->phy_list_lock);
 		}
-	}
=20
-	if (i >=3D sas_ha->num_phys) {
-		pr_err("%s: couldn't find a free port, bug?\n", __func__);
-		spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
-		return;
+		if (i >=3D sas_ha->num_phys) {
+			pr_err("%s: couldn't find a free port, bug?\n",
+			       __func__);
+			spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
+			return;
+		}
 	}
-
-	/* add the phy to the port */
-	port_dev =3D port->port_dev;
-	list_add_tail(&phy->port_phy_el, &port->phy_list);
-	sas_phy_set_target(phy, port_dev);
-	phy->port =3D port;
-	port->num_phys++;
-	port->phy_mask |=3D (1U << phy->id);
-
-	if (*(u64 *)port->attached_sas_addr =3D=3D 0) {
-		port->class =3D phy->class;
-		memcpy(port->attached_sas_addr, phy->attached_sas_addr,
-		       SAS_ADDR_SIZE);
-		port->iproto =3D phy->iproto;
-		port->tproto =3D phy->tproto;
-		port->oob_mode =3D phy->oob_mode;
-		port->linkrate =3D phy->linkrate;
-	} else
-		port->linkrate =3D max(port->linkrate, phy->linkrate);
-	spin_unlock(&port->phy_list_lock);
 	spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
=20
 	if (!port->port) {
--=20
2.35.1

