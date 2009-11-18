From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 4/5] pm8001: misc fixes and minor code cleanup
Date: Wed, 18 Nov 2009 17:18:03 +0800
Message-ID: <4342780783144E9288890DF6EC7D0D82@usish.com.cn>
References: <20091118004345.GA10344@serverengines.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0027_01CA6873.16485F90"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:49394 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268AbZKRJR6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 04:17:58 -0500
In-Reply-To: <20091118004345.GA10344@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_0027_01CA6873.16485F90
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch does a couple of very small, mostly
    single line changes which I feel will be an overkill to put in
    individual patches.

	1) delete unnecessary cast.
	2) fix potential NULL pointer dereference.
	3) bit set pm8001_ha->flags
	4) cleanup
	5) local sata do not reset as it will not be found if reset.

------=_NextPart_000_0027_01CA6873.16485F90
Content-Type: application/octet-stream;
	name="0004-misc-fixes-and-minor-cleanup.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0004-misc-fixes-and-minor-cleanup.patch"

>From 8e9a4cefb5b9b4e91e0fb9323fc750601243e5a4 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Wed, 18 Nov 2009 15:49:20 +0800=0A=
Subject: [PATCH 4/4] misc fixes and minor cleanup=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_hwi.c |    2 +-=0A=
 drivers/scsi/pm8001/pm8001_sas.c |    8 +++++---=0A=
 2 files changed, 6 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c =
b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
index b4426b5..83374dc 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_hwi.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
@@ -4081,7 +4081,7 @@ static int pm8001_chip_phy_ctl_req(struct =
pm8001_hba_info *pm8001_ha,=0A=
 	struct inbound_queue_table *circularQ;=0A=
 	int ret;=0A=
 	u32 opc =3D OPC_INB_LOCAL_PHY_CONTROL;=0A=
-	memset((u8 *)&payload, 0, sizeof(payload));=0A=
+	memset(&payload, 0, sizeof(payload));=0A=
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];=0A=
 	payload.tag =3D 1;=0A=
 	payload.phyop_phyid =3D=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.c =
b/drivers/scsi/pm8001/pm8001_sas.c=0A=
index b2acc35..845ad1c 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.c=0A=
@@ -603,11 +603,11 @@ static int pm8001_dev_found_notify(struct =
domain_device *dev)=0A=
 	spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
 =0A=
 	pm8001_device =3D pm8001_alloc_dev(pm8001_ha);=0A=
-	pm8001_device->sas_device =3D dev;=0A=
 	if (!pm8001_device) {=0A=
 		res =3D -1;=0A=
 		goto found_out;=0A=
 	}=0A=
+	pm8001_device->sas_device =3D dev;=0A=
 	dev->lldd_dev =3D pm8001_device;=0A=
 	pm8001_device->dev_type =3D dev->dev_type;=0A=
 	pm8001_device->dcompletion =3D &completion;=0A=
@@ -643,7 +643,7 @@ static int pm8001_dev_found_notify(struct =
domain_device *dev)=0A=
 	wait_for_completion(&completion);=0A=
 	if (dev->dev_type =3D=3D SAS_END_DEV)=0A=
 		msleep(50);=0A=
-	pm8001_ha->flags =3D PM8001F_RUN_TIME ;=0A=
+	pm8001_ha->flags |=3D PM8001F_RUN_TIME ;=0A=
 	return 0;=0A=
 found_out:=0A=
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
@@ -806,7 +806,7 @@ pm8001_exec_internal_task_abort(struct =
pm8001_hba_info *pm8001_ha,=0A=
 		task->task_done =3D pm8001_task_done;=0A=
 		task->timer.data =3D (unsigned long)task;=0A=
 		task->timer.function =3D pm8001_tmf_timedout;=0A=
-		task->timer.expires =3D jiffies + PM8001_TASK_TIMEOUT*HZ;=0A=
+		task->timer.expires =3D jiffies + PM8001_TASK_TIMEOUT * HZ;=0A=
 		add_timer(&task->timer);=0A=
 =0A=
 		res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);=0A=
@@ -931,6 +931,8 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)=0A=
 =0A=
 	if (dev_is_sata(dev)) {=0A=
 		DECLARE_COMPLETION_ONSTACK(completion_setstate);=0A=
+		if (scsi_is_sas_phy_local(phy))=0A=
+			return 0;=0A=
 		rc =3D sas_phy_reset(phy, 1);=0A=
 		msleep(2000);=0A=
 		rc =3D pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,=0A=
-- =0A=
1.6.5.1.1367.gcd48=0A=
=0A=

------=_NextPart_000_0027_01CA6873.16485F90--

