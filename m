From: "Jack Wang" <jack_wang@usish.com>
Subject: [PATCH]libsas : do not set invalid phy
Date: Wed, 28 Dec 2011 08:49:03 +0800
Message-ID: <55AF4742E909495DB7D4D448381E7BFB@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0096_01CCC53D.8E0CEB30"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:35736 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab1L1At6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Dec 2011 19:49:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dan.j.williams@intel.com, yuxiangl@marvell.com, ltuikov@yahoo.com, James.Bottomley@HansenPartnership.com
Cc: 'james' <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0096_01CCC53D.8E0CEB30
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

For detecting a failure to transmit initial dev to host FIS as described in
section G.5 of sas-2 r 04b , In order to generate the dev to host FIS, we
send a link reset to the expander port, but this may still fail for some
device, when this happened , we should ignore this , do not set the phy, let
libsas find the device later .

>From a315c8ee6f6b7ad000d6dc72d31dfb576ecbceb5 Mon Sep 17 00:00:00 2001
From: Jack Wang <jack_wang@usish.com>
Date: Tue, 27 Dec 2011 02:25:19 -0500
Subject: [PATCH] don't set the invalid phy

Signed-off-by: Lindar Liu <Lindar_liu@usish.com>
Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/libsas/sas_expander.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c
b/drivers/scsi/libsas/sas_expander.c
index e47599b..c7a27c7 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -304,6 +304,12 @@ static int sas_ex_phy_discover_helper(struct
domain_device *dev, u8 *disc_req,
 		/* Wait for the reset to trigger the negotiation */
 		msleep(500);
 	}
+	if ((dr->attached_dev_type == 0 &&
+		dr->attached_sata_dev)) {
+		sas_printk("Found sata attached_dev_type = 0, ignore it to
let it found later!\n");
+		return 0;
+	}
+
 	sas_set_ex_phy(dev, single, disc_resp);
 	return 0;
 }
-- 
1.7.1


------=_NextPart_000_0096_01CCC53D.8E0CEB30
Content-Type: application/octet-stream;
	name="0001-don-t-set-the-invalid-phy.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-don-t-set-the-invalid-phy.patch"

>From a315c8ee6f6b7ad000d6dc72d31dfb576ecbceb5 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Tue, 27 Dec 2011 02:25:19 -0500=0A=
Subject: [PATCH] don't set the invalid phy=0A=
=0A=
Signed-off-by: Lindar Liu <Lindar_liu@usish.com>=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/libsas/sas_expander.c |    6 ++++++=0A=
 1 files changed, 6 insertions(+), 0 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/libsas/sas_expander.c =
b/drivers/scsi/libsas/sas_expander.c=0A=
index e47599b..c7a27c7 100644=0A=
--- a/drivers/scsi/libsas/sas_expander.c=0A=
+++ b/drivers/scsi/libsas/sas_expander.c=0A=
@@ -304,6 +304,12 @@ static int sas_ex_phy_discover_helper(struct =
domain_device *dev, u8 *disc_req,=0A=
 		/* Wait for the reset to trigger the negotiation */=0A=
 		msleep(500);=0A=
 	}=0A=
+	if ((dr->attached_dev_type =3D=3D 0 &&=0A=
+		dr->attached_sata_dev)) {=0A=
+		sas_printk("Found sata attached_dev_type =3D 0, ignore it to let it =
found later!\n");=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
 	sas_set_ex_phy(dev, single, disc_resp);=0A=
 	return 0;=0A=
 }=0A=
-- =0A=
1.7.1=0A=
=0A=

------=_NextPart_000_0096_01CCC53D.8E0CEB30--

