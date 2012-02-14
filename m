From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH] pm8001: fix enum checks
Date: Tue, 14 Feb 2012 15:40:55 +0100
Message-ID: <1329230455-27084-1-git-send-email-danny.kukawka@bisect.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:52644 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666Ab2BNOlB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2012 09:41:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Danny Kukawka <dkukawka@suse.de>, jack_wang@usish.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

=46ix for:
drivers/scsi/pm8001/pm8001_hwi.c: In function =E2=80=98hw_event_sas_phy=
_up=E2=80=99:
drivers/scsi/pm8001/pm8001_hwi.c:2932:32: warning: comparison between
  =E2=80=98enum sas_device_type=E2=80=99 and =E2=80=98enum sas_dev_type=
=E2=80=99 [-Wenum-compare]
drivers/scsi/pm8001/pm8001_hwi.c:2934:37: warning: comparison between
  =E2=80=98enum sas_device_type=E2=80=99 and =E2=80=98enum sas_dev_type=
=E2=80=99 [-Wenum-compare]

Changed SAS_END_DEV to SAS_END_DEVICE and NO_DEVICE with
SAS_PHY_UNUSED.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8=
001_hwi.c
index b7b92f7..46fd7219 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2929,9 +2929,9 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm800=
1_ha, void *piomb)
 	phy->phy_type |=3D PORT_TYPE_SAS;
 	phy->identify.device_type =3D deviceType;
 	phy->phy_attached =3D 1;
-	if (phy->identify.device_type =3D=3D SAS_END_DEV)
+	if (phy->identify.device_type =3D=3D SAS_END_DEVICE)
 		phy->identify.target_port_protocols =3D SAS_PROTOCOL_SSP;
-	else if (phy->identify.device_type !=3D NO_DEVICE)
+	else if (phy->identify.device_type !=3D SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols =3D SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode =3D SAS_OOB_MODE;
 	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
--=20
1.7.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
