From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 3/5] reuse the original port when reenable the phy in a port
Date: Wed, 1 Jul 2009 20:37:26 +0800
Message-ID: <7813BB8F7D624D168612B73E822A1ED9@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_01C9FA8B.BF15E0D0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usish.com ([210.5.144.203]:47553 "EHLO sr-smtp.usish.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZGAMhY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jul 2009 08:37:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, lindar_liu@usish.com, tom_peng@usish.com, aoqingyun@usish.com, jack_wang@usish.com

This is a multi-part message in MIME format.

------=_NextPart_000_0012_01C9FA8B.BF15E0D0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

>From 24abd7f05d2293e03aacbdd9d620d6378ea5e2aa Mon Sep 17 00:00:00 2001
From: Tom Peng <tom_peng@usish.com>
Date: Wed, 1 Jul 2009 19:04:01 +0800
Subject: [PATCH 3/5] reuse the original port when reenable the phy in a port

Signed-off-by: Tom Peng <tom_peng@usish.com>
Signed-off-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: Lindar Liu <lindar_liu@usish.com>
---
 drivers/scsi/libsas/sas_port.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index e6ac59c..5aad165 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -69,16 +69,27 @@ static void sas_form_port(struct asd_sas_phy *phy)
 			SAS_DPRINTK("phy%d matched wide port%d\n", phy->id,
 				    port->id);
 			break;
-		} else if (*(u64 *) port->sas_addr == 0 &&
port->num_phys==0) {
-			memcpy(port->sas_addr, phy->sas_addr,
SAS_ADDR_SIZE);
-			break;
 		}
 		spin_unlock(&port->phy_list_lock);
 	}
+	/* The phy does not match any port currently existed, create new one
*/
+	if (i == sas_ha->num_phys) {
+		for (i = 0; i < sas_ha->num_phys; i++) {
+			port = sas_ha->sas_port[i];
+			spin_lock(&port->phy_list_lock);
+			if (*(u64 *)port->sas_addr == 0
+				&& port->num_phys == 0) {
+				memcpy(port->sas_addr, phy->sas_addr,
+					SAS_ADDR_SIZE);
+				break;
+			}
+			spin_unlock(&port->phy_list_lock);
+		}
+	}
 
 	if (i >= sas_ha->num_phys) {
 		printk(KERN_NOTICE "%s: couldn't find a free port, bug?\n",
-		       __func__);
+			__func__);
 		spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 		return;
 	}
-- 



------=_NextPart_000_0012_01C9FA8B.BF15E0D0
Content-Type: application/octet-stream;
	name="0003-reuse-the-original-port-when-reenable-the-phy-in-a-p.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0003-reuse-the-original-port-when-reenable-the-phy-in-a-p.patch"

>From 24abd7f05d2293e03aacbdd9d620d6378ea5e2aa Mon Sep 17 00:00:00 2001=0A=
From: Tom Peng <tom_peng@usish.com>=0A=
Date: Wed, 1 Jul 2009 19:04:01 +0800=0A=
Subject: [PATCH 3/5] reuse the original port when reenable the phy in a =
port=0A=
=0A=
Signed-off-by: Tom Peng <tom_peng@usish.com>=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
Signed-off-by: Lindar Liu <lindar_liu@usish.com>=0A=
---=0A=
 drivers/scsi/libsas/sas_port.c |   19 +++++++++++++++----=0A=
 1 files changed, 15 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/libsas/sas_port.c =
b/drivers/scsi/libsas/sas_port.c=0A=
index e6ac59c..5aad165 100644=0A=
--- a/drivers/scsi/libsas/sas_port.c=0A=
+++ b/drivers/scsi/libsas/sas_port.c=0A=
@@ -69,16 +69,27 @@ static void sas_form_port(struct asd_sas_phy *phy)=0A=
 			SAS_DPRINTK("phy%d matched wide port%d\n", phy->id,=0A=
 				    port->id);=0A=
 			break;=0A=
-		} else if (*(u64 *) port->sas_addr =3D=3D 0 && port->num_phys=3D=3D0) =
{=0A=
-			memcpy(port->sas_addr, phy->sas_addr, SAS_ADDR_SIZE);=0A=
-			break;=0A=
 		}=0A=
 		spin_unlock(&port->phy_list_lock);=0A=
 	}=0A=
+	/* The phy does not match any port currently existed, create new one */=0A=
+	if (i =3D=3D sas_ha->num_phys) {=0A=
+		for (i =3D 0; i < sas_ha->num_phys; i++) {=0A=
+			port =3D sas_ha->sas_port[i];=0A=
+			spin_lock(&port->phy_list_lock);=0A=
+			if (*(u64 *)port->sas_addr =3D=3D 0=0A=
+				&& port->num_phys =3D=3D 0) {=0A=
+				memcpy(port->sas_addr, phy->sas_addr,=0A=
+					SAS_ADDR_SIZE);=0A=
+				break;=0A=
+			}=0A=
+			spin_unlock(&port->phy_list_lock);=0A=
+		}=0A=
+	}=0A=
 =0A=
 	if (i >=3D sas_ha->num_phys) {=0A=
 		printk(KERN_NOTICE "%s: couldn't find a free port, bug?\n",=0A=
-		       __func__);=0A=
+			__func__);=0A=
 		spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);=0A=
 		return;=0A=
 	}=0A=
-- =0A=
=0A=
=0A=

------=_NextPart_000_0012_01C9FA8B.BF15E0D0--

