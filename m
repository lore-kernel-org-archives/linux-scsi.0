From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH] mvsas: fix warnings
Date: Wed, 6 Jun 2012 11:36:38 -0700
Message-ID: <20120606113638.08fbef77@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:43434 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab2FFSgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2012 14:36:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>
Cc: linux-scsi@vger.kernel.org


This fixes a couple of warnings in the mv_sas device.

drivers/scsi/mvsas/mv_sas.c: In function =E2=80=98mvs_task_exec=E2=80=99=
:
drivers/scsi/mvsas/mv_sas.c:888:24: warning: unused variable =E2=80=98d=
ev=E2=80=99 [-Wunused-variable]
drivers/scsi/mvsas/mv_sas.c: In function =E2=80=98mvs_update_phyinfo=E2=
=80=99:
drivers/scsi/mvsas/mv_sas.c:1157:34: warning: comparison between =E2=80=
=98enum sas_device_type=E2=80=99 and =E2=80=98enum sas_dev_type=E2=80=99=
 [-Wenum-compare]
drivers/scsi/mvsas/mv_sas.c:1160:39: warning: comparison between =E2=80=
=98enum sas_device_type=E2=80=99 and =E2=80=98enum sas_dev_type=E2=80=99=
 [-Wenum-compare]

The first is a trivial unused variable.
The second is a case where a comparison is being done with the incorrec=
t enum.
Please review the latter change since it looks like the
original code maybe incorrect.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/scsi/mvsas/mv_sas.c	2012-06-06 11:09:39.300452498 -0700
+++ b/drivers/scsi/mvsas/mv_sas.c	2012-06-06 11:31:44.528574196 -0700
@@ -885,7 +885,6 @@ static int mvs_task_exec(struct sas_task
 				struct completion *completion, int is_tmf,
 				struct mvs_tmf_task *tmf)
 {
-	struct domain_device *dev =3D task->dev;
 	struct mvs_info *mvi =3D NULL;
 	u32 rc =3D 0;
 	u32 pass =3D 0;
@@ -1154,10 +1153,10 @@ void mvs_update_phyinfo(struct mvs_info
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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
