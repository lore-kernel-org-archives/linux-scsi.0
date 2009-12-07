From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 9/9] pm8001: misc code cleanup
Date: Mon, 7 Dec 2009 17:23:11 +0800
Message-ID: <F0D474ADA758480680678FFCA63BE661@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_002F_01CA7761.F3CE5840"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:46716 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759305AbZLGJXI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:23:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_002F_01CA7761.F3CE5840
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit


Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    8 ++++++--
 drivers/scsi/pm8001/pm8001_sas.c |    2 +-
 drivers/scsi/pm8001/pm8001_sas.h |    4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index 6e1bdd8..9b44c6f 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2895,7 +2895,8 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 	u8 deviceType = pPayload->sas_identify.dev_type;
 	port->port_state =  portstate;
 	PM8001_MSG_DBG(pm8001_ha,
-		pm8001_printk("HW_EVENT_SAS_PHY_UP \n"));
+		pm8001_printk("HW_EVENT_SAS_PHY_UP port id = %d, phy id =
%d\n",
+		port_id, phy_id));
 
 	switch (deviceType) {
 	case SAS_PHY_UNUSED:
@@ -2969,6 +2970,9 @@ hw_event_sata_phy_up(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
+	PM8001_MSG_DBG(pm8001_ha,
+		pm8001_printk("HW_EVENT_SATA_PHY_UP port id = %d,"
+		" phy id = %d\n", port_id, phy_id));
 	port->port_state =  portstate;
 	port->port_attached = 1;
 	get_lrate_mode(phy, link_rate);
@@ -4058,7 +4062,7 @@ static int pm8001_chip_phy_ctl_req(struct
pm8001_hba_info *pm8001_ha,
 	struct inbound_queue_table *circularQ;
 	int ret;
 	u32 opc = OPC_INB_LOCAL_PHY_CONTROL;
-	memset((u8 *)&payload, 0, sizeof(payload));
+	memset(&payload, 0, sizeof(payload));
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag = 1;
 	payload.phyop_phyid =
diff --git a/drivers/scsi/pm8001/pm8001_sas.c
b/drivers/scsi/pm8001/pm8001_sas.c
index e3d4f38..7f9c83a 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -819,7 +819,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info
*pm8001_ha,
 		task->task_done = pm8001_task_done;
 		task->timer.data = (unsigned long)task;
 		task->timer.function = pm8001_tmf_timedout;
-		task->timer.expires = jiffies + PM8001_TASK_TIMEOUT*HZ;
+		task->timer.expires = jiffies + PM8001_TASK_TIMEOUT * HZ;
 		add_timer(&task->timer);
 
 		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h
b/drivers/scsi/pm8001/pm8001_sas.h
index 599601e..8e38ca8 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -59,11 +59,11 @@
 
 #define DRV_NAME		"pm8001"
 #define DRV_VERSION		"0.1.36"
-#define PM8001_FAIL_LOGGING	0x01 /* libsas EH function logging */
+#define PM8001_FAIL_LOGGING	0x01 /* Error message logging */
 #define PM8001_INIT_LOGGING	0x02 /* driver init logging */
 #define PM8001_DISC_LOGGING	0x04 /* discovery layer logging */
 #define PM8001_IO_LOGGING	0x08 /* I/O path logging */
-#define PM8001_EH_LOGGING	0x10 /* Error message logging */
+#define PM8001_EH_LOGGING	0x10 /* libsas EH function logging*/
 #define PM8001_IOCTL_LOGGING	0x20 /* IOCTL message logging */
 #define PM8001_MSG_LOGGING	0x40 /* misc message logging */
 #define pm8001_printk(format, arg...)	printk(KERN_INFO "%s %d:" format,\
-- 
1.6.5.1.1367.gcd48


------=_NextPart_000_002F_01CA7761.F3CE5840
Content-Type: application/octet-stream;
	name="0009-misc-code-cleanup.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0009-misc-code-cleanup.patch"

>From e317322e9c713be7c31478b5de0bf16e33e6cc3b Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Mon, 7 Dec 2009 15:58:57 +0800=0A=
Subject: [PATCH 9/9] misc code cleanup=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_hwi.c |    8 ++++++--=0A=
 drivers/scsi/pm8001/pm8001_sas.c |    2 +-=0A=
 drivers/scsi/pm8001/pm8001_sas.h |    4 ++--=0A=
 3 files changed, 9 insertions(+), 5 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c =
b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
index 6e1bdd8..9b44c6f 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_hwi.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
@@ -2895,7 +2895,8 @@ hw_event_sas_phy_up(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 	u8 deviceType =3D pPayload->sas_identify.dev_type;=0A=
 	port->port_state =3D  portstate;=0A=
 	PM8001_MSG_DBG(pm8001_ha,=0A=
-		pm8001_printk("HW_EVENT_SAS_PHY_UP \n"));=0A=
+		pm8001_printk("HW_EVENT_SAS_PHY_UP port id =3D %d, phy id =3D %d\n",=0A=
+		port_id, phy_id));=0A=
 =0A=
 	switch (deviceType) {=0A=
 	case SAS_PHY_UNUSED:=0A=
@@ -2969,6 +2970,9 @@ hw_event_sata_phy_up(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 	struct sas_ha_struct *sas_ha =3D pm8001_ha->sas;=0A=
 	struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];=0A=
 	unsigned long flags;=0A=
+	PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("HW_EVENT_SATA_PHY_UP port id =3D %d,"=0A=
+		" phy id =3D %d\n", port_id, phy_id));=0A=
 	port->port_state =3D  portstate;=0A=
 	port->port_attached =3D 1;=0A=
 	get_lrate_mode(phy, link_rate);=0A=
@@ -4058,7 +4062,7 @@ static int pm8001_chip_phy_ctl_req(struct =
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
index e3d4f38..7f9c83a 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.c=0A=
@@ -819,7 +819,7 @@ pm8001_exec_internal_task_abort(struct =
pm8001_hba_info *pm8001_ha,=0A=
 		task->task_done =3D pm8001_task_done;=0A=
 		task->timer.data =3D (unsigned long)task;=0A=
 		task->timer.function =3D pm8001_tmf_timedout;=0A=
-		task->timer.expires =3D jiffies + PM8001_TASK_TIMEOUT*HZ;=0A=
+		task->timer.expires =3D jiffies + PM8001_TASK_TIMEOUT * HZ;=0A=
 		add_timer(&task->timer);=0A=
 =0A=
 		res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.h =
b/drivers/scsi/pm8001/pm8001_sas.h=0A=
index 599601e..8e38ca8 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.h=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.h=0A=
@@ -59,11 +59,11 @@=0A=
 =0A=
 #define DRV_NAME		"pm8001"=0A=
 #define DRV_VERSION		"0.1.36"=0A=
-#define PM8001_FAIL_LOGGING	0x01 /* libsas EH function logging */=0A=
+#define PM8001_FAIL_LOGGING	0x01 /* Error message logging */=0A=
 #define PM8001_INIT_LOGGING	0x02 /* driver init logging */=0A=
 #define PM8001_DISC_LOGGING	0x04 /* discovery layer logging */=0A=
 #define PM8001_IO_LOGGING	0x08 /* I/O path logging */=0A=
-#define PM8001_EH_LOGGING	0x10 /* Error message logging */=0A=
+#define PM8001_EH_LOGGING	0x10 /* libsas EH function logging*/=0A=
 #define PM8001_IOCTL_LOGGING	0x20 /* IOCTL message logging */=0A=
 #define PM8001_MSG_LOGGING	0x40 /* misc message logging */=0A=
 #define pm8001_printk(format, arg...)	printk(KERN_INFO "%s %d:" format,\=0A=
-- =0A=
1.6.5.1.1367.gcd48=0A=
=0A=

------=_NextPart_000_002F_01CA7761.F3CE5840--

