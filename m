From: "Jack Wang" <jack_wang@usish.com>
Subject: [PATCH] libsas: set sas_address and device type of rphy
Date: Fri, 23 Sep 2011 14:32:32 +0800
Message-ID: <67EFB401F0334372A629F8C2A4AFADDD@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00C7_01CC79FD.A1EF8EE0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:36605 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1IWGcS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2011 02:32:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <jbottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: 'Dan Williams' <dan.j.williams@intel.com>, 'Xiangliang Yu' <yuxiangl@marvell.com>, 'Mark Salyzyn' <mark_salyzyn@us.xyratex.com>, 'Luben Tuikov' <ltuikov@yahoo.com>, lindar_liu@usish.com, =?gb2312?B?J9PasK67qic=?= <crystal_yu@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_00C7_01CC79FD.A1EF8EE0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit

Hi James,

Libsas forget to set the sas_address and device type of rphy lead to file
under /sys/class/sas_x show wrong value, fix that.

>From 976849ae6da4bc454a89d91b98824c915d3c99a2 Mon Sep 17 00:00:00 2001
From: Jack Wang <jack_wang@usish.com>
Date: Fri, 23 Sep 2011 14:19:24 +0800
Subject: [PATCH] set rphy sas_address and device type correctly

Signed-off-by: Jack Wang <jack_wang@usish.com>
Tested-by: Crystal Yu <crystal_yu@usish.com>
---
 sas_expander.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sas_expander.c b/sas_expander.c
index 874e29d..4ad0a40 100644
--- a/sas_expander.c
+++ b/sas_expander.c
@@ -199,6 +199,8 @@ static void sas_set_ex_phy(struct domain_device *dev,
int phy_id,
 	phy->virtual = dr->virtual;
 	phy->last_da_index = -1;
 
+	phy->phy->identify.sas_address = SAS_ADDR(phy->attached_sas_addr);
+	phy->phy->identify.device_type = phy->attached_dev_type;
 	phy->phy->identify.initiator_port_protocols = phy->attached_iproto;
 	phy->phy->identify.target_port_protocols = phy->attached_tproto;
 	phy->phy->identify.phy_identifier = phy_id;
-- 
1.7.4.msysgit.0

------=_NextPart_000_00C7_01CC79FD.A1EF8EE0
Content-Type: application/octet-stream;
	name="0001-set-rphy-sas_address-and-device-type-correctly.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-set-rphy-sas_address-and-device-type-correctly.patch"

>From 976849ae6da4bc454a89d91b98824c915d3c99a2 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Fri, 23 Sep 2011 14:19:24 +0800=0A=
Subject: [PATCH] set rphy sas_address and device type correctly=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
Tested-by: Crystal Yu <crystal_yu@usish.com>=0A=
---=0A=
 sas_expander.c |    2 ++=0A=
 1 files changed, 2 insertions(+), 0 deletions(-)=0A=
=0A=
diff --git a/sas_expander.c b/sas_expander.c=0A=
index 874e29d..4ad0a40 100644=0A=
--- a/sas_expander.c=0A=
+++ b/sas_expander.c=0A=
@@ -199,6 +199,8 @@ static void sas_set_ex_phy(struct domain_device =
*dev, int phy_id,=0A=
 	phy->virtual =3D dr->virtual;=0A=
 	phy->last_da_index =3D -1;=0A=
 =0A=
+	phy->phy->identify.sas_address =3D SAS_ADDR(phy->attached_sas_addr);=0A=
+	phy->phy->identify.device_type =3D phy->attached_dev_type;=0A=
 	phy->phy->identify.initiator_port_protocols =3D phy->attached_iproto;=0A=
 	phy->phy->identify.target_port_protocols =3D phy->attached_tproto;=0A=
 	phy->phy->identify.phy_identifier =3D phy_id;=0A=
-- =0A=
1.7.4.msysgit.0=0A=
=0A=

------=_NextPart_000_00C7_01CC79FD.A1EF8EE0--

