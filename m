Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA3FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 09:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbiB1Jtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 04:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiB1Jtm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 04:49:42 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8AF20F7A
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 01:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646041743; x=1677577743;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S8WrUEAj3mx265sewDQuc6FFkHtlneViBxmnlwYjrJo=;
  b=pZFWYnC5YnJqs6bjXWDfo2psKyEeXfZcM3uxYPEVe/x0sTKiVMVlIpkx
   +XvTNiY4y89ugTpavlkL0I771VYI3rvncYDWaNH5aa7NNex0rIlp90Klw
   8TaT+18i7aXJGp4xVoKKKl8u1KEYHLCkVnZcyV3jeUjSV0iSDUEPzrsrE
   EKrsFgI1ThjoRLV09Fcm5u4mO0iJKZ9h1AIek9LDjI+FjsA78H107Oc0a
   5nyj/SwbTAvwYzgU0wZgvn3gS0HsV4yQ+hOSFF4FgbOz5VfK8bSga+QrX
   AYCoEKoZS6sjudfyWQnz5+h+BXHOT6Jz4lmECCiE5icZVjAoQNyq628D0
   A==;
X-IronPort-AV: E=Sophos;i="5.90,142,1643644800"; 
   d="scan'208";a="195067963"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2022 17:49:03 +0800
IronPort-SDR: vpHN+G2DjbE22Lj5h4qjEgdYVRC1Z87d8JQekUn23iDLn6dtYuKYD+Ef3g56cT3nABFlH9VDDC
 e2VYZV2p6O7W0q5hb52tAJSwQ1+Vks7RME18t/p4RH1U7ZzT3i0UQrpXny2v5HGWMCxdzYgYjW
 y9FhiEN8zJ6NO9wXMnZ3431DrvPD9ZSAjpbrrWNmk1+wXFUw+A0smM9fur2izhCYm9xEVnnyNO
 IejheJgaQeW5OxsDId4C8nnmAKis59ciCV4OyEw1dfsDwX/PJIHIVF6nucFr9nugE5n0rCaabD
 iAUsw2pRoz7Q/fpFHXedaFGO
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 01:21:32 -0800
IronPort-SDR: XCh1Z8kdsmAMyPnXzA1TI7leEzGYzTb2DnU67NSnvSN8XUNB6dC8E7aykBGuhtxnq3NPTCAhIw
 9Wns9a2xgmGS0P320mIjf4V80dXNwkb9hnL6XYLI8U8/AcxPVQ1KN+ZZWkYH9IXfz2HXAiNLQ0
 GZW2ZWioHUhuvbVp4SB1I3OFbPwnyO1gVRNtg+c0sOe4/rsiRz1Xmd4ZeUk+TJtoYwMeNcEY3v
 n5xgmSYxT8Kk/JHgKdvSRcyrU5Y6EEm5fcfo4yQjxGXzlT1gHv/N3ej2WVTQllC0vjDjlpqape
 /AE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 01:49:03 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K6bDt1XCbz1Rwrw
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 01:49:02 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1646041741;
         x=1648633742; bh=S8WrUEAj3mx265sewDQuc6FFkHtlneViBxmnlwYjrJo=; b=
        lhYvmDaKHxMTHz2pybmd2V2YM+UwyL1rXtdTVyGCfHJBTN/KymkamuWe/HOUu9TB
        2fIAwqoOEAu6qErge9zZNDWxcQ7AmFnkFaekgZdvQWRaGfvDOkOM0GSrR6R6N2kB
        X3YqG8TreUfRffRyYqTGmPUXVj8kLVlbR4GFWr1AiAW+0yuvEoFhKLMP5UvQtGPu
        unG4NZbLuuKGZRYaKT6T6SfEi+YWWUekQiGPH+agpE3mhBxi3cYEDRSrusjQ+wpI
        0REmVk1lSiQBdKe92E6x6Qjqy5T2kLkdLB5R17qTuKlCmfOf5YpDkiEmHIwu6On/
        crvUBiKjIk/zYHhhymngAA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rgzAgkskcY90 for <linux-scsi@vger.kernel.org>;
        Mon, 28 Feb 2022 01:49:01 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K6bDr5nFmz1Rvlx;
        Mon, 28 Feb 2022 01:49:00 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2] scsi: libsas: cleanup sas_form_port()
Date:   Mon, 28 Feb 2022 18:48:57 +0900
Message-Id: <20220228094857.557329-1-damien.lemoal@opensource.wdc.com>
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
helper function sas_form_port_add_phy(). This helper can then be called
directly within the port search loops, avoiding confusion and clearing
the sparse warning.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
Changes from v1:
* Renamed helper function to sas_form_port_add_phy()

 drivers/scsi/libsas/sas_port.c | 73 +++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_por=
t.c
index 67b429dcf1ff..11599c0e3fc3 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -67,6 +67,34 @@ static void sas_resume_port(struct asd_sas_phy *phy)
 	sas_discover_event(port, DISCE_RESUME);
 }
=20
+static void sas_form_port_add_phy(struct asd_sas_port *port,
+				  struct asd_sas_phy *phy, bool wideport)
+{
+	list_add_tail(&phy->port_phy_el, &port->phy_list);
+	sas_phy_set_target(phy, port->port_dev);
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
+}
+
 /**
  * sas_form_port - add this phy to a port
  * @phy: the phy of interest
@@ -79,7 +107,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	int i;
 	struct sas_ha_struct *sas_ha =3D phy->ha;
 	struct asd_sas_port *port =3D phy->port;
-	struct domain_device *port_dev;
+	struct domain_device *port_dev =3D NULL;
 	struct sas_internal *si =3D
 		to_sas_internal(sas_ha->core.shost->transportt);
 	unsigned long flags;
@@ -110,8 +138,9 @@ static void sas_form_port(struct asd_sas_phy *phy)
 		if (*(u64 *) port->sas_addr &&
 		    phy_is_wideport_member(port, phy) && port->num_phys > 0) {
 			/* wide port */
-			pr_debug("phy%d matched wide port%d\n", phy->id,
-				 port->id);
+			port_dev =3D port->port_dev;
+			sas_form_port_add_phy(port, phy, true);
+			spin_unlock(&port->phy_list_lock);
 			break;
 		}
 		spin_unlock(&port->phy_list_lock);
@@ -122,40 +151,22 @@ static void sas_form_port(struct asd_sas_phy *phy)
 			port =3D sas_ha->sas_port[i];
 			spin_lock(&port->phy_list_lock);
 			if (*(u64 *)port->sas_addr =3D=3D 0
-				&& port->num_phys =3D=3D 0) {
-				memcpy(port->sas_addr, phy->sas_addr,
-					SAS_ADDR_SIZE);
+			    && port->num_phys =3D=3D 0) {
+				port_dev =3D port->port_dev;
+				sas_form_port_add_phy(port, phy, false);
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

