From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 2/9] pm8001: enhance error handle for IO patch
Date: Mon, 7 Dec 2009 17:22:42 +0800
Message-ID: <01BD1BD3BCD54896AAA7ACE23040C20A@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0020_01CA7761.E26FEF00"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53049 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759297AbZLGJWh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:22:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_0020_01CA7761.E26FEF00
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Enhance error handle for IO patch, when the port is down, fast return phy
down for task.

Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c  |   29 +++++++++++++++++++--
 drivers/scsi/pm8001/pm8001_init.c |    7 ++++-
 drivers/scsi/pm8001/pm8001_sas.c  |   49
++++++++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm8001_sas.h  |    4 +++
 4 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index 68695b7..3a121fb 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2906,13 +2906,17 @@ hw_event_sas_phy_up(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 		le32_to_cpu(pPayload->lr_evt_status_phyid_portid);
 	u8 link_rate =
 		(u8)((lr_evt_status_phyid_portid & 0xF0000000) >> 28);
+	u8 port_id = (u8)(lr_evt_status_phyid_portid & 0x0000000F);
 	u8 phy_id =
 		(u8)((lr_evt_status_phyid_portid & 0x000000F0) >> 4);
+	u32 npip_portstate = le32_to_cpu(pPayload->npip_portstate);
+	u8 portstate = (u8)(npip_portstate & 0x0000000F);
+	struct pm8001_port *port = &pm8001_ha->port[port_id];
 	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
 	u8 deviceType = pPayload->sas_identify.dev_type;
-
+	port->port_state =  portstate;
 	PM8001_MSG_DBG(pm8001_ha,
 		pm8001_printk("HW_EVENT_SAS_PHY_UP \n"));
 
@@ -2925,16 +2929,19 @@ hw_event_sas_phy_up(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("end device.\n"));
 		pm8001_chip_phy_ctl_req(pm8001_ha, phy_id,
 			PHY_NOTIFY_ENABLE_SPINUP);
+		port->port_attached = 1;
 		get_lrate_mode(phy, link_rate);
 		break;
 	case SAS_EDGE_EXPANDER_DEVICE:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("expander device.\n"));
+		port->port_attached = 1;
 		get_lrate_mode(phy, link_rate);
 		break;
 	case SAS_FANOUT_EXPANDER_DEVICE:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("fanout expander device.\n"));
+		port->port_attached = 1;
 		get_lrate_mode(phy, link_rate);
 		break;
 	default:
@@ -2976,11 +2983,17 @@ hw_event_sata_phy_up(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 		le32_to_cpu(pPayload->lr_evt_status_phyid_portid);
 	u8 link_rate =
 		(u8)((lr_evt_status_phyid_portid & 0xF0000000) >> 28);
+	u8 port_id = (u8)(lr_evt_status_phyid_portid & 0x0000000F);
 	u8 phy_id =
 		(u8)((lr_evt_status_phyid_portid & 0x000000F0) >> 4);
+	u32 npip_portstate = le32_to_cpu(pPayload->npip_portstate);
+	u8 portstate = (u8)(npip_portstate & 0x0000000F);
+	struct pm8001_port *port = &pm8001_ha->port[port_id];
 	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
+	port->port_state =  portstate;
+	port->port_attached = 1;
 	get_lrate_mode(phy, link_rate);
 	phy->phy_type |= PORT_TYPE_SATA;
 	phy->phy_attached = 1;
@@ -3014,7 +3027,13 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 		(u8)((lr_evt_status_phyid_portid & 0x000000F0) >> 4);
 	u32 npip_portstate = le32_to_cpu(pPayload->npip_portstate);
 	u8 portstate = (u8)(npip_portstate & 0x0000000F);
-
+	struct pm8001_port *port = &pm8001_ha->port[port_id];
+	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
+	port->port_state =  portstate;
+	phy->phy_type = 0;
+	phy->identify.device_type = 0;
+	phy->phy_attached = 0;
+	memset(&phy->dev_sas_addr, 0, SAS_ADDR_SIZE);
 	switch (portstate) {
 	case PORT_VALID:
 		break;
@@ -3023,26 +3042,30 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 			pm8001_printk(" PortInvalid portID %d \n",
port_id));
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" Last phy Down and port invalid\n"));
+		port->port_attached = 0;
 		pm8001_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
 			port_id, phy_id, 0, 0);
 		break;
 	case PORT_IN_RESET:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" PortInReset portID %d \n",
port_id));
+			pm8001_printk(" Port In Reset portID %d \n",
port_id));
 		break;
 	case PORT_NOT_ESTABLISHED:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" phy Down and
PORT_NOT_ESTABLISHED\n"));
+		port->port_attached = 0;
 		break;
 	case PORT_LOSTCOMM:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" phy Down and PORT_LOSTCOMM\n"));
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" Last phy Down and port invalid\n"));
+		port->port_attached = 0;
 		pm8001_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
 			port_id, phy_id, 0, 0);
 		break;
 	default:
+		port->port_attached = 0;
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" phy Down and(default) = %x\n",
 			portstate));
diff --git a/drivers/scsi/pm8001/pm8001_init.c
b/drivers/scsi/pm8001/pm8001_init.c
index 42ebe72..fb6379a 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -200,8 +200,13 @@ static int __devinit pm8001_alloc(struct
pm8001_hba_info *pm8001_ha)
 {
 	int i;
 	spin_lock_init(&pm8001_ha->lock);
-	for (i = 0; i < pm8001_ha->chip->n_phy; i++)
+	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
 		pm8001_phy_init(pm8001_ha, i);
+		pm8001_ha->port[i].wide_port_phymap = 0;
+		pm8001_ha->port[i].port_attached = 0;
+		pm8001_ha->port[i].port_state = 0;
+		INIT_LIST_HEAD(&pm8001_ha->port[i].list);
+	}
 
 	pm8001_ha->tags = kzalloc(PM8001_MAX_CCB, GFP_KERNEL);
 	if (!pm8001_ha->tags)
diff --git a/drivers/scsi/pm8001/pm8001_sas.c
b/drivers/scsi/pm8001/pm8001_sas.c
index 1f767a0..49721c8 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -329,6 +329,23 @@ int pm8001_slave_configure(struct scsi_device *sdev)
 	}
 	return 0;
 }
+ /* Find the local port id that's attached to this device */
+static int sas_find_local_port_id(struct domain_device *dev)
+{
+	struct domain_device *pdev = dev->parent;
+
+	/* Directly attached device */
+	if (!pdev)
+		return dev->port->id;
+	while (pdev) {
+		struct domain_device *pdev_p = pdev->parent;
+		if (!pdev_p)
+			return pdev->port->id;
+		pdev = pdev->parent;
+	}
+	return 0;
+}
+
 /**
   * pm8001_task_exec - queue the task(ssp, smp && ata) to the hardware.
   * @task: the task to be execute.
@@ -346,11 +363,12 @@ static int pm8001_task_exec(struct sas_task *task,
const int num,
 	struct domain_device *dev = task->dev;
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev;
+	struct pm8001_port *port = NULL;
 	struct sas_task *t = task;
 	struct pm8001_ccb_info *ccb;
 	u32 tag = 0xdeadbeef, rc, n_elem = 0;
 	u32 n = num;
-	unsigned long flags = 0;
+	unsigned long flags = 0, flags_libsas = 0;
 
 	if (!dev->port) {
 		struct task_status_struct *tsm = &t->task_status;
@@ -379,6 +397,35 @@ static int pm8001_task_exec(struct sas_task *task,
const int num,
 			rc = SAS_PHY_DOWN;
 			goto out_done;
 		}
+		port = &pm8001_ha->port[sas_find_local_port_id(dev)];
+		if (!port->port_attached) {
+			if (sas_protocol_ata(t->task_proto)) {
+				struct task_status_struct *ts =
&t->task_status;
+				ts->resp = SAS_TASK_UNDELIVERED;
+				ts->stat = SAS_PHY_DOWN;
+
+				spin_unlock_irqrestore(&pm8001_ha->lock,
flags);
+
spin_unlock_irqrestore(dev->sata_dev.ap->lock,
+						flags_libsas);
+				t->task_done(t);
+				spin_lock_irqsave(dev->sata_dev.ap->lock,
+					flags_libsas);
+				spin_lock_irqsave(&pm8001_ha->lock, flags);
+				if (n > 1)
+					t = list_entry(t->list.next,
+							struct sas_task,
list);
+				continue;
+			} else {
+				struct task_status_struct *ts =
&t->task_status;
+				ts->resp = SAS_TASK_UNDELIVERED;
+				ts->stat = SAS_PHY_DOWN;
+				t->task_done(t);
+				if (n > 1)
+					t = list_entry(t->list.next,
+							struct sas_task,
list);
+				continue;
+			}
+		}
 		rc = pm8001_tag_alloc(pm8001_ha, &tag);
 		if (rc)
 			goto err_out;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h
b/drivers/scsi/pm8001/pm8001_sas.h
index 30f2ede..c44a115 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -164,6 +164,10 @@ struct pm8001_chip_info {
 
 struct pm8001_port {
 	struct asd_sas_port	sas_port;
+	u8			port_attached;
+	u8			wide_port_phymap;
+	u8			port_state;
+	struct list_head	list;
 };
 
 struct pm8001_phy {
-- 
1.6.5.1.1367.gcd48


------=_NextPart_000_0020_01CA7761.E26FEF00
Content-Type: application/octet-stream;
	name="0002-enhance-error-handle-for-IO.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-enhance-error-handle-for-IO.patch"

>From cb4c5819a4e50a15e51a52bad2a491b7ba0d4328 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Wed, 18 Nov 2009 15:27:46 +0800=0A=
Subject: [PATCH 2/9] enhance error handle for IO=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_hwi.c  |   29 +++++++++++++++++++--=0A=
 drivers/scsi/pm8001/pm8001_init.c |    7 ++++-=0A=
 drivers/scsi/pm8001/pm8001_sas.c  |   49 =
++++++++++++++++++++++++++++++++++++-=0A=
 drivers/scsi/pm8001/pm8001_sas.h  |    4 +++=0A=
 4 files changed, 84 insertions(+), 5 deletions(-)=0A=
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
index 1f767a0..49721c8 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.c=0A=
@@ -329,6 +329,23 @@ int pm8001_slave_configure(struct scsi_device *sdev)=0A=
 	}=0A=
 	return 0;=0A=
 }=0A=
+ /* Find the local port id that's attached to this device */=0A=
+static int sas_find_local_port_id(struct domain_device *dev)=0A=
+{=0A=
+	struct domain_device *pdev =3D dev->parent;=0A=
+=0A=
+	/* Directly attached device */=0A=
+	if (!pdev)=0A=
+		return dev->port->id;=0A=
+	while (pdev) {=0A=
+		struct domain_device *pdev_p =3D pdev->parent;=0A=
+		if (!pdev_p)=0A=
+			return pdev->port->id;=0A=
+		pdev =3D pdev->parent;=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
 /**=0A=
   * pm8001_task_exec - queue the task(ssp, smp && ata) to the hardware.=0A=
   * @task: the task to be execute.=0A=
@@ -346,11 +363,12 @@ static int pm8001_task_exec(struct sas_task *task, =
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
@@ -379,6 +397,35 @@ static int pm8001_task_exec(struct sas_task *task, =
const int num,=0A=
 			rc =3D SAS_PHY_DOWN;=0A=
 			goto out_done;=0A=
 		}=0A=
+		port =3D &pm8001_ha->port[sas_find_local_port_id(dev)];=0A=
+		if (!port->port_attached) {=0A=
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

------=_NextPart_000_0020_01CA7761.E26FEF00--

