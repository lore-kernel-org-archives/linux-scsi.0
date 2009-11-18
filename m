From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 2/5] pm8001: enhance error handle for IO patch
Date: Wed, 18 Nov 2009 17:17:38 +0800
Message-ID: <CA498A64096C4A139D61B0A89574E35F@usish.com.cn>
References: <20091118004222.GA10309@serverengines.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0021_01CA6873.076B22F0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:49368 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbZKRJRe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 04:17:34 -0500
In-Reply-To: <20091118004222.GA10309@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_0021_01CA6873.076B22F0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Enhance error handle for IO patch, when the port is down ,fast return 
phy down for task.

------=_NextPart_000_0021_01CA6873.076B22F0
Content-Type: application/octet-stream;
	name="0002-enhance-error-handle-for-IO.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-enhance-error-handle-for-IO.patch"

>From 7a47413727945fe9dc5c9b443b28795f0e658c18 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Wed, 18 Nov 2009 15:27:46 +0800=0A=
Subject: [PATCH 2/4] enhance error handle for IO=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_hwi.c  |   29 ++++++++++++++++++++++++++---=0A=
 drivers/scsi/pm8001/pm8001_init.c |    7 ++++++-=0A=
 drivers/scsi/pm8001/pm8001_sas.c  |   36 =
+++++++++++++++++++++++++++++++++++-=0A=
 drivers/scsi/pm8001/pm8001_sas.h  |    4 ++++=0A=
 4 files changed, 71 insertions(+), 5 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c =
b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
index 68695b7..3a121fb 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_hwi.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
@@ -2906,13 +2906,17 @@ hw_event_sas_phy_up(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 		le32_to_cpu(pPayload->lr_evt_status_phyid_portid);=0A=
 	u8 link_rate =3D=0A=
 		(u8)((lr_evt_status_phyid_portid & 0xF0000000) >> 28);=0A=
+	u8 port_id =3D (u8)(lr_evt_status_phyid_portid & 0x0000000F);=0A=
 	u8 phy_id =3D=0A=
 		(u8)((lr_evt_status_phyid_portid & 0x000000F0) >> 4);=0A=
+	u32 npip_portstate =3D le32_to_cpu(pPayload->npip_portstate);=0A=
+	u8 portstate =3D (u8)(npip_portstate & 0x0000000F);=0A=
+	struct pm8001_port *port =3D &pm8001_ha->port[port_id];=0A=
 	struct sas_ha_struct *sas_ha =3D pm8001_ha->sas;=0A=
 	struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];=0A=
 	unsigned long flags;=0A=
 	u8 deviceType =3D pPayload->sas_identify.dev_type;=0A=
-=0A=
+	port->port_state =3D  portstate;=0A=
 	PM8001_MSG_DBG(pm8001_ha,=0A=
 		pm8001_printk("HW_EVENT_SAS_PHY_UP \n"));=0A=
 =0A=
@@ -2925,16 +2929,19 @@ hw_event_sas_phy_up(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("end device.\n"));=0A=
 		pm8001_chip_phy_ctl_req(pm8001_ha, phy_id,=0A=
 			PHY_NOTIFY_ENABLE_SPINUP);=0A=
+		port->port_attached =3D 1;=0A=
 		get_lrate_mode(phy, link_rate);=0A=
 		break;=0A=
 	case SAS_EDGE_EXPANDER_DEVICE:=0A=
 		PM8001_MSG_DBG(pm8001_ha,=0A=
 			pm8001_printk("expander device.\n"));=0A=
+		port->port_attached =3D 1;=0A=
 		get_lrate_mode(phy, link_rate);=0A=
 		break;=0A=
 	case SAS_FANOUT_EXPANDER_DEVICE:=0A=
 		PM8001_MSG_DBG(pm8001_ha,=0A=
 			pm8001_printk("fanout expander device.\n"));=0A=
+		port->port_attached =3D 1;=0A=
 		get_lrate_mode(phy, link_rate);=0A=
 		break;=0A=
 	default:=0A=
@@ -2976,11 +2983,17 @@ hw_event_sata_phy_up(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 		le32_to_cpu(pPayload->lr_evt_status_phyid_portid);=0A=
 	u8 link_rate =3D=0A=
 		(u8)((lr_evt_status_phyid_portid & 0xF0000000) >> 28);=0A=
+	u8 port_id =3D (u8)(lr_evt_status_phyid_portid & 0x0000000F);=0A=
 	u8 phy_id =3D=0A=
 		(u8)((lr_evt_status_phyid_portid & 0x000000F0) >> 4);=0A=
+	u32 npip_portstate =3D le32_to_cpu(pPayload->npip_portstate);=0A=
+	u8 portstate =3D (u8)(npip_portstate & 0x0000000F);=0A=
+	struct pm8001_port *port =3D &pm8001_ha->port[port_id];=0A=
 	struct sas_ha_struct *sas_ha =3D pm8001_ha->sas;=0A=
 	struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];=0A=
 	unsigned long flags;=0A=
+	port->port_state =3D  portstate;=0A=
+	port->port_attached =3D 1;=0A=
 	get_lrate_mode(phy, link_rate);=0A=
 	phy->phy_type |=3D PORT_TYPE_SATA;=0A=
 	phy->phy_attached =3D 1;=0A=
@@ -3014,7 +3027,13 @@ hw_event_phy_down(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 		(u8)((lr_evt_status_phyid_portid & 0x000000F0) >> 4);=0A=
 	u32 npip_portstate =3D le32_to_cpu(pPayload->npip_portstate);=0A=
 	u8 portstate =3D (u8)(npip_portstate & 0x0000000F);=0A=
-=0A=
+	struct pm8001_port *port =3D &pm8001_ha->port[port_id];=0A=
+	struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];=0A=
+	port->port_state =3D  portstate;=0A=
+	phy->phy_type =3D 0;=0A=
+	phy->identify.device_type =3D 0;=0A=
+	phy->phy_attached =3D 0;=0A=
+	memset(&phy->dev_sas_addr, 0, SAS_ADDR_SIZE);=0A=
 	switch (portstate) {=0A=
 	case PORT_VALID:=0A=
 		break;=0A=
@@ -3023,26 +3042,30 @@ hw_event_phy_down(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 			pm8001_printk(" PortInvalid portID %d \n", port_id));=0A=
 		PM8001_MSG_DBG(pm8001_ha,=0A=
 			pm8001_printk(" Last phy Down and port invalid\n"));=0A=
+		port->port_attached =3D 0;=0A=
 		pm8001_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,=0A=
 			port_id, phy_id, 0, 0);=0A=
 		break;=0A=
 	case PORT_IN_RESET:=0A=
 		PM8001_MSG_DBG(pm8001_ha,=0A=
-			pm8001_printk(" PortInReset portID %d \n", port_id));=0A=
+			pm8001_printk(" Port In Reset portID %d \n", port_id));=0A=
 		break;=0A=
 	case PORT_NOT_ESTABLISHED:=0A=
 		PM8001_MSG_DBG(pm8001_ha,=0A=
 			pm8001_printk(" phy Down and PORT_NOT_ESTABLISHED\n"));=0A=
+		port->port_attached =3D 0;=0A=
 		break;=0A=
 	case PORT_LOSTCOMM:=0A=
 		PM8001_MSG_DBG(pm8001_ha,=0A=
 			pm8001_printk(" phy Down and PORT_LOSTCOMM\n"));=0A=
 		PM8001_MSG_DBG(pm8001_ha,=0A=
 			pm8001_printk(" Last phy Down and port invalid\n"));=0A=
+		port->port_attached =3D 0;=0A=
 		pm8001_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,=0A=
 			port_id, phy_id, 0, 0);=0A=
 		break;=0A=
 	default:=0A=
+		port->port_attached =3D 0;=0A=
 		PM8001_MSG_DBG(pm8001_ha,=0A=
 			pm8001_printk(" phy Down and(default) =3D %x\n",=0A=
 			portstate));=0A=
diff --git a/drivers/scsi/pm8001/pm8001_init.c =
b/drivers/scsi/pm8001/pm8001_init.c=0A=
index 42ebe72..fb6379a 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_init.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_init.c=0A=
@@ -200,8 +200,13 @@ static int __devinit pm8001_alloc(struct =
pm8001_hba_info *pm8001_ha)=0A=
 {=0A=
 	int i;=0A=
 	spin_lock_init(&pm8001_ha->lock);=0A=
-	for (i =3D 0; i < pm8001_ha->chip->n_phy; i++)=0A=
+	for (i =3D 0; i < pm8001_ha->chip->n_phy; i++) {=0A=
 		pm8001_phy_init(pm8001_ha, i);=0A=
+		pm8001_ha->port[i].wide_port_phymap =3D 0;=0A=
+		pm8001_ha->port[i].port_attached =3D 0;=0A=
+		pm8001_ha->port[i].port_state =3D 0;=0A=
+		INIT_LIST_HEAD(&pm8001_ha->port[i].list);=0A=
+	}=0A=
 =0A=
 	pm8001_ha->tags =3D kzalloc(PM8001_MAX_CCB, GFP_KERNEL);=0A=
 	if (!pm8001_ha->tags)=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.c =
b/drivers/scsi/pm8001/pm8001_sas.c=0A=
index 1f767a0..b2acc35 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.c=0A=
@@ -346,11 +346,12 @@ static int pm8001_task_exec(struct sas_task *task, =
const int num,=0A=
 	struct domain_device *dev =3D task->dev;=0A=
 	struct pm8001_hba_info *pm8001_ha;=0A=
 	struct pm8001_device *pm8001_dev;=0A=
+	struct pm8001_port *port =3D NULL;=0A=
 	struct sas_task *t =3D task;=0A=
 	struct pm8001_ccb_info *ccb;=0A=
 	u32 tag =3D 0xdeadbeef, rc, n_elem =3D 0;=0A=
 	u32 n =3D num;=0A=
-	unsigned long flags =3D 0;=0A=
+	unsigned long flags =3D 0, flags_libsas =3D 0;=0A=
 =0A=
 	if (!dev->port) {=0A=
 		struct task_status_struct *tsm =3D &t->task_status;=0A=
@@ -379,6 +380,39 @@ static int pm8001_task_exec(struct sas_task *task, =
const int num,=0A=
 			rc =3D SAS_PHY_DOWN;=0A=
 			goto out_done;=0A=
 		}=0A=
+		if (dev->port->id >=3D pm8001_ha->chip->n_phy)=0A=
+			port =3D &pm8001_ha->port[dev->port->id -=0A=
+				pm8001_ha->chip->n_phy];=0A=
+		else=0A=
+			port =3D &pm8001_ha->port[dev->port->id];=0A=
+		if (port && !port->port_attached) {=0A=
+			if (sas_protocol_ata(t->task_proto)) {=0A=
+				struct task_status_struct *ts =3D &t->task_status;=0A=
+				ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+				ts->stat =3D SAS_PHY_DOWN;=0A=
+=0A=
+				spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
+				spin_unlock_irqrestore(dev->sata_dev.ap->lock,=0A=
+						flags_libsas);=0A=
+				t->task_done(t);=0A=
+				spin_lock_irqsave(dev->sata_dev.ap->lock,=0A=
+					flags_libsas);=0A=
+				spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
+				if (n > 1)=0A=
+					t =3D list_entry(t->list.next,=0A=
+							struct sas_task, list);=0A=
+				continue;=0A=
+			} else {=0A=
+				struct task_status_struct *ts =3D &t->task_status;=0A=
+				ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+				ts->stat =3D SAS_PHY_DOWN;=0A=
+				t->task_done(t);=0A=
+				if (n > 1)=0A=
+					t =3D list_entry(t->list.next,=0A=
+							struct sas_task, list);=0A=
+				continue;=0A=
+			}=0A=
+		}=0A=
 		rc =3D pm8001_tag_alloc(pm8001_ha, &tag);=0A=
 		if (rc)=0A=
 			goto err_out;=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.h =
b/drivers/scsi/pm8001/pm8001_sas.h=0A=
index 30f2ede..c44a115 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.h=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.h=0A=
@@ -164,6 +164,10 @@ struct pm8001_chip_info {=0A=
 =0A=
 struct pm8001_port {=0A=
 	struct asd_sas_port	sas_port;=0A=
+	u8			port_attached;=0A=
+	u8			wide_port_phymap;=0A=
+	u8			port_state;=0A=
+	struct list_head	list;=0A=
 };=0A=
 =0A=
 struct pm8001_phy {=0A=
-- =0A=
1.6.5.1.1367.gcd48=0A=
=0A=

------=_NextPart_000_0021_01CA6873.076B22F0--

