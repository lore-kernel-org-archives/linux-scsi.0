From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: [PATCH] [SCSI] pm8001 missing break statements
Date: Mon, 26 Sep 2011 07:57:36 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018AE3E2@XYUS-EX22.xyus.xyratex.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A9018AE2D8@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CC7C5C.A16C7F36"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:38708 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794Ab1IZO62 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Sep 2011 10:58:28 -0400
Content-class: urn:content-classes:message
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2D8@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Wang <jack_wang@usish.com>, James Bottomley <jbottomley@parallels.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01CC7C5C.A16C7F36
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Code Inspection: found two missing break directives. First one will
result in not retrying an a task that report
IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY, the second will result in cosmetic
debug printk conflicting statement stutter. Because checkpatch.pl came
up with a warning regarding unnecessary space before a newline on one of
the fragments associated with the diff context, I took the liberty of
fixing all the cases of this issue in the pair of files touched by this
defect. These cosmetic changes hide the break changes :-(

To help focus, break changes are in pm8001_hwi.c fragment line 1649 for
the IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY case statement and pm8001_sas.c
line 1000 deals with the conflicting debug print stutter.

The real patch is enclosed as an attachment since Outlook is my current
MTA. This code change has not shown any side effect in roughly a year of
random acts of testing.

Signed-off-by: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: Jack Wang <jack_wang@usish.com>

 pm8001_hwi.c |   73
+++++++++++++++++++++++++++++------------------------------
 pm8001_sas.c |    7 +++--
 2 files changed, 41 insertions(+), 39 deletions(-)

diff -ru scsi-misc-2.6/drivers/scsi/pm8001/pm8001_hwi.c
scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_hwi.c
--- scsi-misc-2.6/drivers/scsi/pm8001/pm8001_hwi.c	2011-09-15
12:52:02.000000000 -0400
+++ scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_hwi.c	2011-09-26
10:41:45.000000000 -0400
@@ -567,11 +567,11 @@
 	value =3D pm8001_cr32(pm8001_ha, 0, 0x44);
 	offset =3D value & 0x03FFFFFF;
 	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("Scratchpad 0 Offset: %x \n", offset));
+		pm8001_printk("Scratchpad 0 Offset: %x\n", offset));
 	pcilogic =3D (value & 0xFC000000) >> 26;
 	pcibar =3D get_pci_bar_index(pcilogic);
 	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("Scratchpad 0 PCI BAR: %d \n", pcibar));
+		pm8001_printk("Scratchpad 0 PCI BAR: %d\n", pcibar));
 	pm8001_ha->main_cfg_tbl_addr =3D base_addr =3D
 		pm8001_ha->io_mem[pcibar].memvirtaddr + offset;
 	pm8001_ha->general_stat_tbl_addr =3D
@@ -1245,7 +1245,7 @@
=20
 	if (mpi_msg_free_get(circularQ, 64, &pMessage) < 0) {
 		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("No free mpi buffer \n"));
+			pm8001_printk("No free mpi buffer\n"));
 		return -1;
 	}
 	BUG_ON(!payload);
@@ -1262,7 +1262,7 @@
 	pm8001_cw32(pm8001_ha, circularQ->pi_pci_bar,
 		circularQ->pi_offset, circularQ->producer_idx);
 	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("after PI=3D %d CI=3D %d \n",
circularQ->producer_idx,
+		pm8001_printk("after PI=3D %d CI=3D %d\n",
circularQ->producer_idx,
 		circularQ->consumer_index));
 	return 0;
 }
@@ -1474,7 +1474,7 @@
 	switch (status) {
 	case IO_SUCCESS:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS"
-			",param =3D %d \n", param));
+			",param =3D %d\n", param));
 		if (param =3D=3D 0) {
 			ts->resp =3D SAS_TASK_COMPLETE;
 			ts->stat =3D SAM_STAT_GOOD;
@@ -1490,14 +1490,14 @@
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ABORTED IOMB Tag \n"));
+			pm8001_printk("IO_ABORTED IOMB Tag\n"));
 		ts->resp =3D SAS_TASK_COMPLETE;
 		ts->stat =3D SAS_ABORTED_TASK;
 		break;
 	case IO_UNDERFLOW:
 		/* SSP Completion with error */
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW"
-			",param =3D %d \n", param));
+			",param =3D %d\n", param));
 		ts->resp =3D SAS_TASK_COMPLETE;
 		ts->stat =3D SAS_DATA_UNDERRUN;
 		ts->residual =3D param;
@@ -1649,6 +1649,7 @@
 		ts->resp =3D SAS_TASK_COMPLETE;
 		ts->stat =3D SAS_OPEN_REJECT;
 		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;
+		break;
 	default:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("Unknown status 0x%x\n", status));
@@ -1937,14 +1938,14 @@
 				ts->buf_valid_size =3D sizeof(*resp);
 			} else
 				PM8001_IO_DBG(pm8001_ha,
-					pm8001_printk("response to large
\n"));
+					pm8001_printk("response to
large\n"));
 		}
 		if (pm8001_dev)
 			pm8001_dev->running_req--;
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ABORTED IOMB Tag \n"));
+			pm8001_printk("IO_ABORTED IOMB Tag\n"));
 		ts->resp =3D SAS_TASK_COMPLETE;
 		ts->stat =3D SAS_ABORTED_TASK;
 		if (pm8001_dev)
@@ -2728,11 +2729,11 @@
 	u32 phy_op =3D le32_to_cpu(pPayload->phyop_phyid) & OP_BITS;
 	if (status !=3D 0) {
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("%x phy execute %x phy op failed!
\n",
+			pm8001_printk("%x phy execute %x phy op
failed!\n",
 			phy_id, phy_op));
 	} else
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("%x phy execute %x phy op success!
\n",
+			pm8001_printk("%x phy execute %x phy op
success!\n",
 			phy_id, phy_op));
 	return 0;
 }
@@ -3018,7 +3019,7 @@
 		break;
 	case PORT_INVALID:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" PortInvalid portID %d \n",
port_id));
+			pm8001_printk(" PortInvalid portID %d\n",
port_id));
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" Last phy Down and port
invalid\n"));
 		port->port_attached =3D 0;
@@ -3027,7 +3028,7 @@
 		break;
 	case PORT_IN_RESET:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" Port In Reset portID %d \n",
port_id));
+			pm8001_printk(" Port In Reset portID %d\n",
port_id));
 		break;
 	case PORT_NOT_ESTABLISHED:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3220,7 +3221,7 @@
 		pm8001_printk(" status =3D 0x%x\n", status));
 	for (i =3D 0; i < GENERAL_EVENT_PAYLOAD; i++)
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("inb_IOMB_payload[0x%x] 0x%x, \n",
i,
+			pm8001_printk("inb_IOMB_payload[0x%x] 0x%x,\n",
i,
 			pPayload->inb_IOMB_payload[i]));
 	return 0;
 }
@@ -3312,12 +3313,12 @@
 		break;
 	case HW_EVENT_SAS_PHY_UP:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PHY_START_STATUS \n"));
+			pm8001_printk("HW_EVENT_PHY_START_STATUS\n"));
 		hw_event_sas_phy_up(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_SATA_PHY_UP:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_SATA_PHY_UP \n"));
+			pm8001_printk("HW_EVENT_SATA_PHY_UP\n"));
 		hw_event_sata_phy_up(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_PHY_STOP_STATUS:
@@ -3329,12 +3330,12 @@
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_SATA_SPINUP_HOLD \n"));
+			pm8001_printk("HW_EVENT_SATA_SPINUP_HOLD\n"));
 		sas_ha->notify_phy_event(&phy->sas_phy,
PHYE_SPINUP_HOLD);
 		break;
 	case HW_EVENT_PHY_DOWN:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PHY_DOWN \n"));
+			pm8001_printk("HW_EVENT_PHY_DOWN\n"));
 		sas_ha->notify_phy_event(&phy->sas_phy,
PHYE_LOSS_OF_SIGNAL);
 		phy->phy_attached =3D 0;
 		phy->phy_state =3D 0;
@@ -3446,7 +3447,7 @@
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
 		PM8001_MSG_DBG(pm8001_ha,
-
pm8001_printk("HW_EVENT_LINK_ERR_PHY_RESET_FAILED \n"));
+
pm8001_printk("HW_EVENT_LINK_ERR_PHY_RESET_FAILED\n"));
 		pm8001_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_PHY_RESET_FAILED,
 			port_id, phy_id, 0, 0);
@@ -3456,25 +3457,25 @@
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RESET_TIMER_TMO
\n"));
+
pm8001_printk("HW_EVENT_PORT_RESET_TIMER_TMO\n"));
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached =3D 0;
 		sas_ha->notify_port_event(sas_phy,
PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RECOVERY_TIMER_TMO
\n"));
+
pm8001_printk("HW_EVENT_PORT_RECOVERY_TIMER_TMO\n"));
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached =3D 0;
 		sas_ha->notify_port_event(sas_phy,
PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_PORT_RECOVER:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RECOVER \n"));
+			pm8001_printk("HW_EVENT_PORT_RECOVER\n"));
 		break;
 	case HW_EVENT_PORT_RESET_COMPLETE:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RESET_COMPLETE
\n"));
+
pm8001_printk("HW_EVENT_PORT_RESET_COMPLETE\n"));
 		break;
 	case EVENT_BROADCAST_ASYNCH_EVENT:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3502,21 +3503,21 @@
=20
 	switch (opc) {
 	case OPC_OUB_ECHO:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("OPC_OUB_ECHO
\n"));
+		PM8001_MSG_DBG(pm8001_ha,
pm8001_printk("OPC_OUB_ECHO\n"));
 		break;
 	case OPC_OUB_HW_EVENT:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_HW_EVENT \n"));
+			pm8001_printk("OPC_OUB_HW_EVENT\n"));
 		mpi_hw_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SSP_COMP:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SSP_COMP \n"));
+			pm8001_printk("OPC_OUB_SSP_COMP\n"));
 		mpi_ssp_completion(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SMP_COMP:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SMP_COMP \n"));
+			pm8001_printk("OPC_OUB_SMP_COMP\n"));
 		mpi_smp_completion(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_LOCAL_PHY_CNTRL:
@@ -3526,26 +3527,26 @@
 		break;
 	case OPC_OUB_DEV_REGIST:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_DEV_REGIST \n"));
+			pm8001_printk("OPC_OUB_DEV_REGIST\n"));
 		mpi_reg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEREG_DEV:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("unresgister the deviece \n"));
+			pm8001_printk("unresgister the deviece\n"));
 		mpi_dereg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEV_HANDLE:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GET_DEV_HANDLE \n"));
+			pm8001_printk("OPC_OUB_GET_DEV_HANDLE\n"));
 		break;
 	case OPC_OUB_SATA_COMP:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SATA_COMP \n"));
+			pm8001_printk("OPC_OUB_SATA_COMP\n"));
 		mpi_sata_completion(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SATA_EVENT:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SATA_EVENT \n"));
+			pm8001_printk("OPC_OUB_SATA_EVENT\n"));
 		mpi_sata_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SSP_EVENT:
@@ -3858,19 +3859,19 @@
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	if (task->data_dir =3D=3D PCI_DMA_NONE) {
 		ATAP =3D 0x04;  /* no data*/
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("no data \n"));
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("no data\n"));
 	} else if (likely(!task->ata_task.device_control_reg_update)) {
 		if (task->ata_task.dma_xfer) {
 			ATAP =3D 0x06; /* DMA */
-			PM8001_IO_DBG(pm8001_ha, pm8001_printk("DMA
\n"));
+			PM8001_IO_DBG(pm8001_ha,
pm8001_printk("DMA\n"));
 		} else {
 			ATAP =3D 0x05; /* PIO*/
-			PM8001_IO_DBG(pm8001_ha, pm8001_printk("PIO
\n"));
+			PM8001_IO_DBG(pm8001_ha,
pm8001_printk("PIO\n"));
 		}
 		if (task->ata_task.use_ncq &&
 			dev->sata_dev.command_set !=3D ATAPI_COMMAND_SET)
{
 			ATAP =3D 0x07; /* FPDMA */
-			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA
\n"));
+			PM8001_IO_DBG(pm8001_ha,
pm8001_printk("FPDMA\n"));
 		}
 	}
 	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task,
&hdr_tag))
diff -ru scsi-misc-2.6/drivers/scsi/pm8001/pm8001_sas.c
scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_sas.c
--- scsi-misc-2.6/drivers/scsi/pm8001/pm8001_sas.c	2011-09-15
12:52:02.000000000 -0400
+++ scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_sas.c	2011-09-26
10:40:37.000000000 -0400
@@ -651,7 +651,7 @@
 				flag =3D 1; /* directly sata*/
 		}
 	} /*register this device to HBA*/
-	PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device \n"));
+	PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device\n"));
 	PM8001_CHIP_DISP->reg_dev_req(pm8001_ha, pm8001_device, flag);
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 	wait_for_completion(&completion);
@@ -1000,13 +1000,14 @@
 		/* The task is still in Lun, release it then */
 		case TMF_RESP_FUNC_SUCC:
 			PM8001_EH_DBG(pm8001_ha,
-				pm8001_printk("The task is still in Lun
\n"));
+				pm8001_printk("The task is still in
Lun\n"));
+			break;
 		/* The task is not in Lun or failed, reset the phy */
 		case TMF_RESP_FUNC_FAILED:
 		case TMF_RESP_FUNC_COMPLETE:
 			PM8001_EH_DBG(pm8001_ha,
 			pm8001_printk("The task is not in Lun or
failed,"
-			" reset the phy \n"));
+			" reset the phy\n"));
 			break;
 		}
 	}

______________________________________________________________________
This email may contain privileged or confidential information, which shou=
ld only be used for the purpose for which it was sent by Xyratex. No furt=
her rights or licenses are granted to use such information. If you are no=
t the intended recipient of this message, please notify the sender by ret=
urn and delete it. You may not use, copy, disclose or rely on the informa=
tion contained in it.
 =

Internet email is susceptible to data corruption, interception and unauth=
orised amendment for which Xyratex does not accept liability. While we ha=
ve taken reasonable precautions to ensure that this email is free of viru=
ses, Xyratex does not accept liability for the presence of any computer v=
iruses in this email, nor for any losses caused as a result of viruses.
 =

Xyratex Technology Limited (03134912), Registered in England & Wales, Reg=
istered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 =

The Xyratex group of companies also includes, Xyratex Ltd, registered in =
Bermuda, Xyratex International Inc, registered in California, Xyratex (Ma=
laysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd =
registered in The People's Republic of China and Xyratex Japan Limited re=
gistered in Japan.
______________________________________________________________________
 =

=0D
------_=_NextPart_001_01CC7C5C.A16C7F36
Content-Type: application/octet-stream;
	name="pm8001_missing_breaks.patch"
Content-Transfer-Encoding: base64
Content-Description: pm8001_missing_breaks.patch
Content-Disposition: attachment;
	filename="pm8001_missing_breaks.patch"

Q29kZSBJbnNwZWN0aW9uOiBmb3VuZCB0d28gbWlzc2luZyBicmVhayBkaXJlY3RpdmVzLiBGaXJz
dCBvbmUgd2lsbCByZXN1bHQgaW4gbm90IHJldHJ5aW5nIGFuIGEgdGFzayB0aGF0IHJlcG9ydCBJ
T19PUEVOX0NOWF9FUlJPUl9IV19SRVNPVVJDRV9CVVNZLCB0aGUgc2Vjb25kIHdpbGwgcmVzdWx0
IGluIGNvc21ldGljIGRlYnVnIHByaW50ayBjb25mbGljdGluZyBzdGF0ZW1lbnQgc3R1dHRlci4g
QmVjYXVzZSBjaGVja3BhdGNoLnBsIGNhbWUgdXAgd2l0aCBhIHdhcm5pbmcgcmVnYXJkaW5nIHVu
bmVjZXNzYXJ5IHNwYWNlIGJlZm9yZSBhIG5ld2xpbmUgb24gb25lIG9mIHRoZSBmcmFnbWVudHMg
YXNzb2NpYXRlZCB3aXRoIHRoZSBkaWZmIGNvbnRleHQsIEkgdG9vayB0aGUgbGliZXJ0eSBvZiBm
aXhpbmcgYWxsIHRoZSBjYXNlcyBvZiB0aGlzIGlzc3VlIGluIHRoZSBwYWlyIG9mIGZpbGVzLiBU
aGVzZSBjb3NtZXRpYyBjaGFuZ2VzIGhpZGUgdGhlIGJyZWFrIGNoYW5nZXMuCgpUbyBoZWxwIGZv
Y3VzLCBicmVhayBjaGFuZ2VzIGFyZSBpbiBwbTgwMDFfaHdpLmMgZnJhZ21lbnQgbGluZSAxNjQ5
IGZvciB0aGUgSU9fT1BFTl9DTlhfRVJST1JfSFdfUkVTT1VSQ0VfQlVTWSBjYXNlIHN0YXRlbWVu
dCBhbmQgcG04MDAxX3Nhcy5jIGxpbmUgMTAwMCBkZWFscyB3aXRoIHRoZSBjb25mbGljdGluZyBk
ZWJ1ZyBwcmludCBzdHV0dGVyLgoKU2lnbmVkLW9mZi1ieTogTWFyayBTYWx5enluIDxtYXJrX3Nh
bHl6eW5AdXMueHlyYXRleC5jb20+CkNjOiBKYW1lcyBCb3R0b21sZXkgPGpib3R0b21sZXlAcGFy
YWxsZWxzLmNvbT4KQ2M6IEphY2sgV2FuZyA8amFja193YW5nQHVzaXNoLmNvbT4KCiBwbTgwMDFf
aHdpLmMgfCAgIDczICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCiBwbTgwMDFfc2FzLmMgfCAgICA3ICsrKy0tCiAyIGZpbGVzIGNoYW5n
ZWQsIDQxIGluc2VydGlvbnMoKyksIDM5IGRlbGV0aW9ucygtKQoKZGlmZiAtcnUgc2NzaS1taXNj
LTIuNi9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9od2kuYyBzY3NpLW1pc2MtMi42Lm5ldy9k
cml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9od2kuYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJz
L3Njc2kvcG04MDAxL3BtODAwMV9od2kuYwkyMDExLTA5LTE1IDEyOjUyOjAyLjAwMDAwMDAwMCAt
MDQwMAorKysgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfaHdp
LmMJMjAxMS0wOS0yNiAxMDo0MTo0NS4wMDAwMDAwMDAgLTA0MDAKQEAgLTU2NywxMSArNTY3LDEx
IEBACiAJdmFsdWUgPSBwbTgwMDFfY3IzMihwbTgwMDFfaGEsIDAsIDB4NDQpOwogCW9mZnNldCA9
IHZhbHVlICYgMHgwM0ZGRkZGRjsKIAlQTTgwMDFfSU5JVF9EQkcocG04MDAxX2hhLAotCQlwbTgw
MDFfcHJpbnRrKCJTY3JhdGNocGFkIDAgT2Zmc2V0OiAleCBcbiIsIG9mZnNldCkpOworCQlwbTgw
MDFfcHJpbnRrKCJTY3JhdGNocGFkIDAgT2Zmc2V0OiAleFxuIiwgb2Zmc2V0KSk7CiAJcGNpbG9n
aWMgPSAodmFsdWUgJiAweEZDMDAwMDAwKSA+PiAyNjsKIAlwY2liYXIgPSBnZXRfcGNpX2Jhcl9p
bmRleChwY2lsb2dpYyk7CiAJUE04MDAxX0lOSVRfREJHKHBtODAwMV9oYSwKLQkJcG04MDAxX3By
aW50aygiU2NyYXRjaHBhZCAwIFBDSSBCQVI6ICVkIFxuIiwgcGNpYmFyKSk7CisJCXBtODAwMV9w
cmludGsoIlNjcmF0Y2hwYWQgMCBQQ0kgQkFSOiAlZFxuIiwgcGNpYmFyKSk7CiAJcG04MDAxX2hh
LT5tYWluX2NmZ190YmxfYWRkciA9IGJhc2VfYWRkciA9CiAJCXBtODAwMV9oYS0+aW9fbWVtW3Bj
aWJhcl0ubWVtdmlydGFkZHIgKyBvZmZzZXQ7CiAJcG04MDAxX2hhLT5nZW5lcmFsX3N0YXRfdGJs
X2FkZHIgPQpAQCAtMTI0NSw3ICsxMjQ1LDcgQEAKIAogCWlmIChtcGlfbXNnX2ZyZWVfZ2V0KGNp
cmN1bGFyUSwgNjQsICZwTWVzc2FnZSkgPCAwKSB7CiAJCVBNODAwMV9JT19EQkcocG04MDAxX2hh
LAotCQkJcG04MDAxX3ByaW50aygiTm8gZnJlZSBtcGkgYnVmZmVyIFxuIikpOworCQkJcG04MDAx
X3ByaW50aygiTm8gZnJlZSBtcGkgYnVmZmVyXG4iKSk7CiAJCXJldHVybiAtMTsKIAl9CiAJQlVH
X09OKCFwYXlsb2FkKTsKQEAgLTEyNjIsNyArMTI2Miw3IEBACiAJcG04MDAxX2N3MzIocG04MDAx
X2hhLCBjaXJjdWxhclEtPnBpX3BjaV9iYXIsCiAJCWNpcmN1bGFyUS0+cGlfb2Zmc2V0LCBjaXJj
dWxhclEtPnByb2R1Y2VyX2lkeCk7CiAJUE04MDAxX0lPX0RCRyhwbTgwMDFfaGEsCi0JCXBtODAw
MV9wcmludGsoImFmdGVyIFBJPSAlZCBDST0gJWQgXG4iLCBjaXJjdWxhclEtPnByb2R1Y2VyX2lk
eCwKKwkJcG04MDAxX3ByaW50aygiYWZ0ZXIgUEk9ICVkIENJPSAlZFxuIiwgY2lyY3VsYXJRLT5w
cm9kdWNlcl9pZHgsCiAJCWNpcmN1bGFyUS0+Y29uc3VtZXJfaW5kZXgpKTsKIAlyZXR1cm4gMDsK
IH0KQEAgLTE0NzQsNyArMTQ3NCw3IEBACiAJc3dpdGNoIChzdGF0dXMpIHsKIAljYXNlIElPX1NV
Q0NFU1M6CiAJCVBNODAwMV9JT19EQkcocG04MDAxX2hhLCBwbTgwMDFfcHJpbnRrKCJJT19TVUND
RVNTIgotCQkJIixwYXJhbSA9ICVkIFxuIiwgcGFyYW0pKTsKKwkJCSIscGFyYW0gPSAlZFxuIiwg
cGFyYW0pKTsKIAkJaWYgKHBhcmFtID09IDApIHsKIAkJCXRzLT5yZXNwID0gU0FTX1RBU0tfQ09N
UExFVEU7CiAJCQl0cy0+c3RhdCA9IFNBTV9TVEFUX0dPT0Q7CkBAIC0xNDkwLDE0ICsxNDkwLDE0
IEBACiAJCWJyZWFrOwogCWNhc2UgSU9fQUJPUlRFRDoKIAkJUE04MDAxX0lPX0RCRyhwbTgwMDFf
aGEsCi0JCQlwbTgwMDFfcHJpbnRrKCJJT19BQk9SVEVEIElPTUIgVGFnIFxuIikpOworCQkJcG04
MDAxX3ByaW50aygiSU9fQUJPUlRFRCBJT01CIFRhZ1xuIikpOwogCQl0cy0+cmVzcCA9IFNBU19U
QVNLX0NPTVBMRVRFOwogCQl0cy0+c3RhdCA9IFNBU19BQk9SVEVEX1RBU0s7CiAJCWJyZWFrOwog
CWNhc2UgSU9fVU5ERVJGTE9XOgogCQkvKiBTU1AgQ29tcGxldGlvbiB3aXRoIGVycm9yICovCiAJ
CVBNODAwMV9JT19EQkcocG04MDAxX2hhLCBwbTgwMDFfcHJpbnRrKCJJT19VTkRFUkZMT1ciCi0J
CQkiLHBhcmFtID0gJWQgXG4iLCBwYXJhbSkpOworCQkJIixwYXJhbSA9ICVkXG4iLCBwYXJhbSkp
OwogCQl0cy0+cmVzcCA9IFNBU19UQVNLX0NPTVBMRVRFOwogCQl0cy0+c3RhdCA9IFNBU19EQVRB
X1VOREVSUlVOOwogCQl0cy0+cmVzaWR1YWwgPSBwYXJhbTsKQEAgLTE2NDksNiArMTY0OSw3IEBA
CiAJCXRzLT5yZXNwID0gU0FTX1RBU0tfQ09NUExFVEU7CiAJCXRzLT5zdGF0ID0gU0FTX09QRU5f
UkVKRUNUOwogCQl0cy0+b3Blbl9yZWpfcmVhc29uID0gU0FTX09SRUpfUlNWRF9SRVRSWTsKKwkJ
YnJlYWs7CiAJZGVmYXVsdDoKIAkJUE04MDAxX0lPX0RCRyhwbTgwMDFfaGEsCiAJCQlwbTgwMDFf
cHJpbnRrKCJVbmtub3duIHN0YXR1cyAweCV4XG4iLCBzdGF0dXMpKTsKQEAgLTE5MzcsMTQgKzE5
MzgsMTQgQEAKIAkJCQl0cy0+YnVmX3ZhbGlkX3NpemUgPSBzaXplb2YoKnJlc3ApOwogCQkJfSBl
bHNlCiAJCQkJUE04MDAxX0lPX0RCRyhwbTgwMDFfaGEsCi0JCQkJCXBtODAwMV9wcmludGsoInJl
c3BvbnNlIHRvIGxhcmdlIFxuIikpOworCQkJCQlwbTgwMDFfcHJpbnRrKCJyZXNwb25zZSB0byBs
YXJnZVxuIikpOwogCQl9CiAJCWlmIChwbTgwMDFfZGV2KQogCQkJcG04MDAxX2Rldi0+cnVubmlu
Z19yZXEtLTsKIAkJYnJlYWs7CiAJY2FzZSBJT19BQk9SVEVEOgogCQlQTTgwMDFfSU9fREJHKHBt
ODAwMV9oYSwKLQkJCXBtODAwMV9wcmludGsoIklPX0FCT1JURUQgSU9NQiBUYWcgXG4iKSk7CisJ
CQlwbTgwMDFfcHJpbnRrKCJJT19BQk9SVEVEIElPTUIgVGFnXG4iKSk7CiAJCXRzLT5yZXNwID0g
U0FTX1RBU0tfQ09NUExFVEU7CiAJCXRzLT5zdGF0ID0gU0FTX0FCT1JURURfVEFTSzsKIAkJaWYg
KHBtODAwMV9kZXYpCkBAIC0yNzI4LDExICsyNzI5LDExIEBACiAJdTMyIHBoeV9vcCA9IGxlMzJf
dG9fY3B1KHBQYXlsb2FkLT5waHlvcF9waHlpZCkgJiBPUF9CSVRTOwogCWlmIChzdGF0dXMgIT0g
MCkgewogCQlQTTgwMDFfTVNHX0RCRyhwbTgwMDFfaGEsCi0JCQlwbTgwMDFfcHJpbnRrKCIleCBw
aHkgZXhlY3V0ZSAleCBwaHkgb3AgZmFpbGVkISBcbiIsCisJCQlwbTgwMDFfcHJpbnRrKCIleCBw
aHkgZXhlY3V0ZSAleCBwaHkgb3AgZmFpbGVkIVxuIiwKIAkJCXBoeV9pZCwgcGh5X29wKSk7CiAJ
fSBlbHNlCiAJCVBNODAwMV9NU0dfREJHKHBtODAwMV9oYSwKLQkJCXBtODAwMV9wcmludGsoIiV4
IHBoeSBleGVjdXRlICV4IHBoeSBvcCBzdWNjZXNzISBcbiIsCisJCQlwbTgwMDFfcHJpbnRrKCIl
eCBwaHkgZXhlY3V0ZSAleCBwaHkgb3Agc3VjY2VzcyFcbiIsCiAJCQlwaHlfaWQsIHBoeV9vcCkp
OwogCXJldHVybiAwOwogfQpAQCAtMzAxOCw3ICszMDE5LDcgQEAKIAkJYnJlYWs7CiAJY2FzZSBQ
T1JUX0lOVkFMSUQ6CiAJCVBNODAwMV9NU0dfREJHKHBtODAwMV9oYSwKLQkJCXBtODAwMV9wcmlu
dGsoIiBQb3J0SW52YWxpZCBwb3J0SUQgJWQgXG4iLCBwb3J0X2lkKSk7CisJCQlwbTgwMDFfcHJp
bnRrKCIgUG9ydEludmFsaWQgcG9ydElEICVkXG4iLCBwb3J0X2lkKSk7CiAJCVBNODAwMV9NU0df
REJHKHBtODAwMV9oYSwKIAkJCXBtODAwMV9wcmludGsoIiBMYXN0IHBoeSBEb3duIGFuZCBwb3J0
IGludmFsaWRcbiIpKTsKIAkJcG9ydC0+cG9ydF9hdHRhY2hlZCA9IDA7CkBAIC0zMDI3LDcgKzMw
MjgsNyBAQAogCQlicmVhazsKIAljYXNlIFBPUlRfSU5fUkVTRVQ6CiAJCVBNODAwMV9NU0dfREJH
KHBtODAwMV9oYSwKLQkJCXBtODAwMV9wcmludGsoIiBQb3J0IEluIFJlc2V0IHBvcnRJRCAlZCBc
biIsIHBvcnRfaWQpKTsKKwkJCXBtODAwMV9wcmludGsoIiBQb3J0IEluIFJlc2V0IHBvcnRJRCAl
ZFxuIiwgcG9ydF9pZCkpOwogCQlicmVhazsKIAljYXNlIFBPUlRfTk9UX0VTVEFCTElTSEVEOgog
CQlQTTgwMDFfTVNHX0RCRyhwbTgwMDFfaGEsCkBAIC0zMjIwLDcgKzMyMjEsNyBAQAogCQlwbTgw
MDFfcHJpbnRrKCIgc3RhdHVzID0gMHgleFxuIiwgc3RhdHVzKSk7CiAJZm9yIChpID0gMDsgaSA8
IEdFTkVSQUxfRVZFTlRfUEFZTE9BRDsgaSsrKQogCQlQTTgwMDFfTVNHX0RCRyhwbTgwMDFfaGEs
Ci0JCQlwbTgwMDFfcHJpbnRrKCJpbmJfSU9NQl9wYXlsb2FkWzB4JXhdIDB4JXgsIFxuIiwgaSwK
KwkJCXBtODAwMV9wcmludGsoImluYl9JT01CX3BheWxvYWRbMHgleF0gMHgleCxcbiIsIGksCiAJ
CQlwUGF5bG9hZC0+aW5iX0lPTUJfcGF5bG9hZFtpXSkpOwogCXJldHVybiAwOwogfQpAQCAtMzMx
MiwxMiArMzMxMywxMiBAQAogCQlicmVhazsKIAljYXNlIEhXX0VWRU5UX1NBU19QSFlfVVA6CiAJ
CVBNODAwMV9NU0dfREJHKHBtODAwMV9oYSwKLQkJCXBtODAwMV9wcmludGsoIkhXX0VWRU5UX1BI
WV9TVEFSVF9TVEFUVVMgXG4iKSk7CisJCQlwbTgwMDFfcHJpbnRrKCJIV19FVkVOVF9QSFlfU1RB
UlRfU1RBVFVTXG4iKSk7CiAJCWh3X2V2ZW50X3Nhc19waHlfdXAocG04MDAxX2hhLCBwaW9tYik7
CiAJCWJyZWFrOwogCWNhc2UgSFdfRVZFTlRfU0FUQV9QSFlfVVA6CiAJCVBNODAwMV9NU0dfREJH
KHBtODAwMV9oYSwKLQkJCXBtODAwMV9wcmludGsoIkhXX0VWRU5UX1NBVEFfUEhZX1VQIFxuIikp
OworCQkJcG04MDAxX3ByaW50aygiSFdfRVZFTlRfU0FUQV9QSFlfVVBcbiIpKTsKIAkJaHdfZXZl
bnRfc2F0YV9waHlfdXAocG04MDAxX2hhLCBwaW9tYik7CiAJCWJyZWFrOwogCWNhc2UgSFdfRVZF
TlRfUEhZX1NUT1BfU1RBVFVTOgpAQCAtMzMyOSwxMiArMzMzMCwxMiBAQAogCQlicmVhazsKIAlj
YXNlIEhXX0VWRU5UX1NBVEFfU1BJTlVQX0hPTEQ6CiAJCVBNODAwMV9NU0dfREJHKHBtODAwMV9o
YSwKLQkJCXBtODAwMV9wcmludGsoIkhXX0VWRU5UX1NBVEFfU1BJTlVQX0hPTEQgXG4iKSk7CisJ
CQlwbTgwMDFfcHJpbnRrKCJIV19FVkVOVF9TQVRBX1NQSU5VUF9IT0xEXG4iKSk7CiAJCXNhc19o
YS0+bm90aWZ5X3BoeV9ldmVudCgmcGh5LT5zYXNfcGh5LCBQSFlFX1NQSU5VUF9IT0xEKTsKIAkJ
YnJlYWs7CiAJY2FzZSBIV19FVkVOVF9QSFlfRE9XTjoKIAkJUE04MDAxX01TR19EQkcocG04MDAx
X2hhLAotCQkJcG04MDAxX3ByaW50aygiSFdfRVZFTlRfUEhZX0RPV04gXG4iKSk7CisJCQlwbTgw
MDFfcHJpbnRrKCJIV19FVkVOVF9QSFlfRE9XTlxuIikpOwogCQlzYXNfaGEtPm5vdGlmeV9waHlf
ZXZlbnQoJnBoeS0+c2FzX3BoeSwgUEhZRV9MT1NTX09GX1NJR05BTCk7CiAJCXBoeS0+cGh5X2F0
dGFjaGVkID0gMDsKIAkJcGh5LT5waHlfc3RhdGUgPSAwOwpAQCAtMzQ0Niw3ICszNDQ3LDcgQEAK
IAkJYnJlYWs7CiAJY2FzZSBIV19FVkVOVF9MSU5LX0VSUl9QSFlfUkVTRVRfRkFJTEVEOgogCQlQ
TTgwMDFfTVNHX0RCRyhwbTgwMDFfaGEsCi0JCQlwbTgwMDFfcHJpbnRrKCJIV19FVkVOVF9MSU5L
X0VSUl9QSFlfUkVTRVRfRkFJTEVEIFxuIikpOworCQkJcG04MDAxX3ByaW50aygiSFdfRVZFTlRf
TElOS19FUlJfUEhZX1JFU0VUX0ZBSUxFRFxuIikpOwogCQlwbTgwMDFfaHdfZXZlbnRfYWNrX3Jl
cShwbTgwMDFfaGEsIDAsCiAJCQlIV19FVkVOVF9MSU5LX0VSUl9QSFlfUkVTRVRfRkFJTEVELAog
CQkJcG9ydF9pZCwgcGh5X2lkLCAwLCAwKTsKQEAgLTM0NTYsMjUgKzM0NTcsMjUgQEAKIAkJYnJl
YWs7CiAJY2FzZSBIV19FVkVOVF9QT1JUX1JFU0VUX1RJTUVSX1RNTzoKIAkJUE04MDAxX01TR19E
QkcocG04MDAxX2hhLAotCQkJcG04MDAxX3ByaW50aygiSFdfRVZFTlRfUE9SVF9SRVNFVF9USU1F
Ul9UTU8gXG4iKSk7CisJCQlwbTgwMDFfcHJpbnRrKCJIV19FVkVOVF9QT1JUX1JFU0VUX1RJTUVS
X1RNT1xuIikpOwogCQlzYXNfcGh5X2Rpc2Nvbm5lY3RlZChzYXNfcGh5KTsKIAkJcGh5LT5waHlf
YXR0YWNoZWQgPSAwOwogCQlzYXNfaGEtPm5vdGlmeV9wb3J0X2V2ZW50KHNhc19waHksIFBPUlRF
X0xJTktfUkVTRVRfRVJSKTsKIAkJYnJlYWs7CiAJY2FzZSBIV19FVkVOVF9QT1JUX1JFQ09WRVJZ
X1RJTUVSX1RNTzoKIAkJUE04MDAxX01TR19EQkcocG04MDAxX2hhLAotCQkJcG04MDAxX3ByaW50
aygiSFdfRVZFTlRfUE9SVF9SRUNPVkVSWV9USU1FUl9UTU8gXG4iKSk7CisJCQlwbTgwMDFfcHJp
bnRrKCJIV19FVkVOVF9QT1JUX1JFQ09WRVJZX1RJTUVSX1RNT1xuIikpOwogCQlzYXNfcGh5X2Rp
c2Nvbm5lY3RlZChzYXNfcGh5KTsKIAkJcGh5LT5waHlfYXR0YWNoZWQgPSAwOwogCQlzYXNfaGEt
Pm5vdGlmeV9wb3J0X2V2ZW50KHNhc19waHksIFBPUlRFX0xJTktfUkVTRVRfRVJSKTsKIAkJYnJl
YWs7CiAJY2FzZSBIV19FVkVOVF9QT1JUX1JFQ09WRVI6CiAJCVBNODAwMV9NU0dfREJHKHBtODAw
MV9oYSwKLQkJCXBtODAwMV9wcmludGsoIkhXX0VWRU5UX1BPUlRfUkVDT1ZFUiBcbiIpKTsKKwkJ
CXBtODAwMV9wcmludGsoIkhXX0VWRU5UX1BPUlRfUkVDT1ZFUlxuIikpOwogCQlicmVhazsKIAlj
YXNlIEhXX0VWRU5UX1BPUlRfUkVTRVRfQ09NUExFVEU6CiAJCVBNODAwMV9NU0dfREJHKHBtODAw
MV9oYSwKLQkJCXBtODAwMV9wcmludGsoIkhXX0VWRU5UX1BPUlRfUkVTRVRfQ09NUExFVEUgXG4i
KSk7CisJCQlwbTgwMDFfcHJpbnRrKCJIV19FVkVOVF9QT1JUX1JFU0VUX0NPTVBMRVRFXG4iKSk7
CiAJCWJyZWFrOwogCWNhc2UgRVZFTlRfQlJPQURDQVNUX0FTWU5DSF9FVkVOVDoKIAkJUE04MDAx
X01TR19EQkcocG04MDAxX2hhLApAQCAtMzUwMiwyMSArMzUwMywyMSBAQAogCiAJc3dpdGNoIChv
cGMpIHsKIAljYXNlIE9QQ19PVUJfRUNITzoKLQkJUE04MDAxX01TR19EQkcocG04MDAxX2hhLCBw
bTgwMDFfcHJpbnRrKCJPUENfT1VCX0VDSE8gXG4iKSk7CisJCVBNODAwMV9NU0dfREJHKHBtODAw
MV9oYSwgcG04MDAxX3ByaW50aygiT1BDX09VQl9FQ0hPXG4iKSk7CiAJCWJyZWFrOwogCWNhc2Ug
T1BDX09VQl9IV19FVkVOVDoKIAkJUE04MDAxX01TR19EQkcocG04MDAxX2hhLAotCQkJcG04MDAx
X3ByaW50aygiT1BDX09VQl9IV19FVkVOVCBcbiIpKTsKKwkJCXBtODAwMV9wcmludGsoIk9QQ19P
VUJfSFdfRVZFTlRcbiIpKTsKIAkJbXBpX2h3X2V2ZW50KHBtODAwMV9oYSwgcGlvbWIpOwogCQli
cmVhazsKIAljYXNlIE9QQ19PVUJfU1NQX0NPTVA6CiAJCVBNODAwMV9NU0dfREJHKHBtODAwMV9o
YSwKLQkJCXBtODAwMV9wcmludGsoIk9QQ19PVUJfU1NQX0NPTVAgXG4iKSk7CisJCQlwbTgwMDFf
cHJpbnRrKCJPUENfT1VCX1NTUF9DT01QXG4iKSk7CiAJCW1waV9zc3BfY29tcGxldGlvbihwbTgw
MDFfaGEsIHBpb21iKTsKIAkJYnJlYWs7CiAJY2FzZSBPUENfT1VCX1NNUF9DT01QOgogCQlQTTgw
MDFfTVNHX0RCRyhwbTgwMDFfaGEsCi0JCQlwbTgwMDFfcHJpbnRrKCJPUENfT1VCX1NNUF9DT01Q
IFxuIikpOworCQkJcG04MDAxX3ByaW50aygiT1BDX09VQl9TTVBfQ09NUFxuIikpOwogCQltcGlf
c21wX2NvbXBsZXRpb24ocG04MDAxX2hhLCBwaW9tYik7CiAJCWJyZWFrOwogCWNhc2UgT1BDX09V
Ql9MT0NBTF9QSFlfQ05UUkw6CkBAIC0zNTI2LDI2ICszNTI3LDI2IEBACiAJCWJyZWFrOwogCWNh
c2UgT1BDX09VQl9ERVZfUkVHSVNUOgogCQlQTTgwMDFfTVNHX0RCRyhwbTgwMDFfaGEsCi0JCQlw
bTgwMDFfcHJpbnRrKCJPUENfT1VCX0RFVl9SRUdJU1QgXG4iKSk7CisJCQlwbTgwMDFfcHJpbnRr
KCJPUENfT1VCX0RFVl9SRUdJU1RcbiIpKTsKIAkJbXBpX3JlZ19yZXNwKHBtODAwMV9oYSwgcGlv
bWIpOwogCQlicmVhazsKIAljYXNlIE9QQ19PVUJfREVSRUdfREVWOgogCQlQTTgwMDFfTVNHX0RC
RyhwbTgwMDFfaGEsCi0JCQlwbTgwMDFfcHJpbnRrKCJ1bnJlc2dpc3RlciB0aGUgZGV2aWVjZSBc
biIpKTsKKwkJCXBtODAwMV9wcmludGsoInVucmVzZ2lzdGVyIHRoZSBkZXZpZWNlXG4iKSk7CiAJ
CW1waV9kZXJlZ19yZXNwKHBtODAwMV9oYSwgcGlvbWIpOwogCQlicmVhazsKIAljYXNlIE9QQ19P
VUJfR0VUX0RFVl9IQU5ETEU6CiAJCVBNODAwMV9NU0dfREJHKHBtODAwMV9oYSwKLQkJCXBtODAw
MV9wcmludGsoIk9QQ19PVUJfR0VUX0RFVl9IQU5ETEUgXG4iKSk7CisJCQlwbTgwMDFfcHJpbnRr
KCJPUENfT1VCX0dFVF9ERVZfSEFORExFXG4iKSk7CiAJCWJyZWFrOwogCWNhc2UgT1BDX09VQl9T
QVRBX0NPTVA6CiAJCVBNODAwMV9NU0dfREJHKHBtODAwMV9oYSwKLQkJCXBtODAwMV9wcmludGso
Ik9QQ19PVUJfU0FUQV9DT01QIFxuIikpOworCQkJcG04MDAxX3ByaW50aygiT1BDX09VQl9TQVRB
X0NPTVBcbiIpKTsKIAkJbXBpX3NhdGFfY29tcGxldGlvbihwbTgwMDFfaGEsIHBpb21iKTsKIAkJ
YnJlYWs7CiAJY2FzZSBPUENfT1VCX1NBVEFfRVZFTlQ6CiAJCVBNODAwMV9NU0dfREJHKHBtODAw
MV9oYSwKLQkJCXBtODAwMV9wcmludGsoIk9QQ19PVUJfU0FUQV9FVkVOVCBcbiIpKTsKKwkJCXBt
ODAwMV9wcmludGsoIk9QQ19PVUJfU0FUQV9FVkVOVFxuIikpOwogCQltcGlfc2F0YV9ldmVudChw
bTgwMDFfaGEsIHBpb21iKTsKIAkJYnJlYWs7CiAJY2FzZSBPUENfT1VCX1NTUF9FVkVOVDoKQEAg
LTM4NTgsMTkgKzM4NTksMTkgQEAKIAljaXJjdWxhclEgPSAmcG04MDAxX2hhLT5pbmJuZF9xX3Ri
bFswXTsKIAlpZiAodGFzay0+ZGF0YV9kaXIgPT0gUENJX0RNQV9OT05FKSB7CiAJCUFUQVAgPSAw
eDA0OyAgLyogbm8gZGF0YSovCi0JCVBNODAwMV9JT19EQkcocG04MDAxX2hhLCBwbTgwMDFfcHJp
bnRrKCJubyBkYXRhIFxuIikpOworCQlQTTgwMDFfSU9fREJHKHBtODAwMV9oYSwgcG04MDAxX3By
aW50aygibm8gZGF0YVxuIikpOwogCX0gZWxzZSBpZiAobGlrZWx5KCF0YXNrLT5hdGFfdGFzay5k
ZXZpY2VfY29udHJvbF9yZWdfdXBkYXRlKSkgewogCQlpZiAodGFzay0+YXRhX3Rhc2suZG1hX3hm
ZXIpIHsKIAkJCUFUQVAgPSAweDA2OyAvKiBETUEgKi8KLQkJCVBNODAwMV9JT19EQkcocG04MDAx
X2hhLCBwbTgwMDFfcHJpbnRrKCJETUEgXG4iKSk7CisJCQlQTTgwMDFfSU9fREJHKHBtODAwMV9o
YSwgcG04MDAxX3ByaW50aygiRE1BXG4iKSk7CiAJCX0gZWxzZSB7CiAJCQlBVEFQID0gMHgwNTsg
LyogUElPKi8KLQkJCVBNODAwMV9JT19EQkcocG04MDAxX2hhLCBwbTgwMDFfcHJpbnRrKCJQSU8g
XG4iKSk7CisJCQlQTTgwMDFfSU9fREJHKHBtODAwMV9oYSwgcG04MDAxX3ByaW50aygiUElPXG4i
KSk7CiAJCX0KIAkJaWYgKHRhc2stPmF0YV90YXNrLnVzZV9uY3EgJiYKIAkJCWRldi0+c2F0YV9k
ZXYuY29tbWFuZF9zZXQgIT0gQVRBUElfQ09NTUFORF9TRVQpIHsKIAkJCUFUQVAgPSAweDA3OyAv
KiBGUERNQSAqLwotCQkJUE04MDAxX0lPX0RCRyhwbTgwMDFfaGEsIHBtODAwMV9wcmludGsoIkZQ
RE1BIFxuIikpOworCQkJUE04MDAxX0lPX0RCRyhwbTgwMDFfaGEsIHBtODAwMV9wcmludGsoIkZQ
RE1BXG4iKSk7CiAJCX0KIAl9CiAJaWYgKHRhc2stPmF0YV90YXNrLnVzZV9uY3EgJiYgcG04MDAx
X2dldF9uY3FfdGFnKHRhc2ssICZoZHJfdGFnKSkKZGlmZiAtcnUgc2NzaS1taXNjLTIuNi9kcml2
ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9zYXMuYyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Nj
c2kvcG04MDAxL3BtODAwMV9zYXMuYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvcG04
MDAxL3BtODAwMV9zYXMuYwkyMDExLTA5LTE1IDEyOjUyOjAyLjAwMDAwMDAwMCAtMDQwMAorKysg
c2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfc2FzLmMJMjAxMS0w
OS0yNiAxMDo0MDozNy4wMDAwMDAwMDAgLTA0MDAKQEAgLTY1MSw3ICs2NTEsNyBAQAogCQkJCWZs
YWcgPSAxOyAvKiBkaXJlY3RseSBzYXRhKi8KIAkJfQogCX0gLypyZWdpc3RlciB0aGlzIGRldmlj
ZSB0byBIQkEqLwotCVBNODAwMV9ESVNDX0RCRyhwbTgwMDFfaGEsIHBtODAwMV9wcmludGsoIkZv
dW5kIGRldmljZSBcbiIpKTsKKwlQTTgwMDFfRElTQ19EQkcocG04MDAxX2hhLCBwbTgwMDFfcHJp
bnRrKCJGb3VuZCBkZXZpY2VcbiIpKTsKIAlQTTgwMDFfQ0hJUF9ESVNQLT5yZWdfZGV2X3JlcShw
bTgwMDFfaGEsIHBtODAwMV9kZXZpY2UsIGZsYWcpOwogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
JnBtODAwMV9oYS0+bG9jaywgZmxhZ3MpOwogCXdhaXRfZm9yX2NvbXBsZXRpb24oJmNvbXBsZXRp
b24pOwpAQCAtMTAwMCwxMyArMTAwMCwxNCBAQAogCQkvKiBUaGUgdGFzayBpcyBzdGlsbCBpbiBM
dW4sIHJlbGVhc2UgaXQgdGhlbiAqLwogCQljYXNlIFRNRl9SRVNQX0ZVTkNfU1VDQzoKIAkJCVBN
ODAwMV9FSF9EQkcocG04MDAxX2hhLAotCQkJCXBtODAwMV9wcmludGsoIlRoZSB0YXNrIGlzIHN0
aWxsIGluIEx1biBcbiIpKTsKKwkJCQlwbTgwMDFfcHJpbnRrKCJUaGUgdGFzayBpcyBzdGlsbCBp
biBMdW5cbiIpKTsKKwkJCWJyZWFrOwogCQkvKiBUaGUgdGFzayBpcyBub3QgaW4gTHVuIG9yIGZh
aWxlZCwgcmVzZXQgdGhlIHBoeSAqLwogCQljYXNlIFRNRl9SRVNQX0ZVTkNfRkFJTEVEOgogCQlj
YXNlIFRNRl9SRVNQX0ZVTkNfQ09NUExFVEU6CiAJCQlQTTgwMDFfRUhfREJHKHBtODAwMV9oYSwK
IAkJCXBtODAwMV9wcmludGsoIlRoZSB0YXNrIGlzIG5vdCBpbiBMdW4gb3IgZmFpbGVkLCIKLQkJ
CSIgcmVzZXQgdGhlIHBoeSBcbiIpKTsKKwkJCSIgcmVzZXQgdGhlIHBoeVxuIikpOwogCQkJYnJl
YWs7CiAJCX0KIAl9Cg==

------_=_NextPart_001_01CC7C5C.A16C7F36--
