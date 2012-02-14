From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH] mvsas: fix enum checks
Date: Tue, 14 Feb 2012 15:40:39 +0100
Message-ID: <1329230439-26976-1-git-send-email-danny.kukawka@bisect.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:52526 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666Ab2BNOko (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2012 09:40:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Xiangliang Yu <yuxiangl@marvell.com>, Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

=46ix for:
drivers/scsi/mvsas/mv_sas.c: In function =E2=80=98mvs_update_phyinfo=E2=
=80=99:
drivers/scsi/mvsas/mv_sas.c:1163:34: warning: comparison between
  =E2=80=98enum sas_device_type=E2=80=99 and =E2=80=98enum sas_dev_type=
=E2=80=99 [-Wenum-compare]
drivers/scsi/mvsas/mv_sas.c:1166:39: warning: comparison between
  =E2=80=98enum sas_device_type=E2=80=99 and =E2=80=98enum sas_dev_type=
=E2=80=99 [-Wenum-compare]

Changed SAS_END_DEV to SAS_END_DEVICE and NO_DEVICE with
SAS_PHY_UNUSED.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/scsi/mvsas/mv_sas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a4884a5..7a57780 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1160,10 +1160,10 @@ void mvs_update_phyinfo(struct mvs_info *mvi, i=
nt i, int get_st)
 			phy->identify.device_type =3D
 				phy->att_dev_info & PORT_DEV_TYPE_MASK;
=20
-			if (phy->identify.device_type =3D=3D SAS_END_DEV)
+			if (phy->identify.device_type =3D=3D SAS_END_DEVICE)
 				phy->identify.target_port_protocols =3D
 							SAS_PROTOCOL_SSP;
-			else if (phy->identify.device_type !=3D NO_DEVICE)
+			else if (phy->identify.device_type !=3D SAS_PHY_UNUSED)
 				phy->identify.target_port_protocols =3D
 							SAS_PROTOCOL_SMP;
 			if (oob_done)
--=20
1.7.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
