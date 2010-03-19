From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: FW: [PATCH 2/2] RFC: The be2iscsi driver support for bsg
Date: Fri, 19 Mar 2010 15:48:35 -0700
Message-ID: <20100319224835.GA31748@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21164 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab0CSWtT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2010 18:49:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jayamohank@serverengines.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, open-iscsi@googlegroups.com

> On Thu, 18 Mar 2010 16:02:52 -0500
> Mike Christie <michaelc@cs.wisc.edu> wrote:
> 
> > On 03/18/2010 08:58 AM, FUJITA Tomonori wrote:
> > >
> > > - You invent your hardware specific data structure for the simplest
> > >    operation such as setting IP address.
> >
> > I think this is what Jay is not trying to do. I think the patch has some
> > extra code like the ISCSI_BSG_HST_VENDOR parts that makes it confusing -
> > it got me too. The ISCSI_BSG_HST_VENDOR code in be2iscsi looks like it
> > is basically disabled (should remove for a formal patch when he sends
> > for merging).
> >
> > It looks like there is a common struct iscsi_bsg_common_format that is
> > getting passed around, and then in be2iscsi the driver is using that
> > info to make a be2iscsi specific command. So scsi_transport_iscsi /
> > ISCSI_SET_IP_ADDR / iscsi_bsg_common_format  gets translated by b2iscsi
> > to b2iscsi / OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR / be_modify_ip_addr.
> 
> Yeah, seems you are right. But looks like this patchset also adds the
> vendor specific message support (ISCSI_BSG_HST_VENDOR)?
> 
> I still want to know why vendors can't do this via the existing
> netlink interface. open-iscsi uses the netlink interface for some pdu
> so I guess that having a different channel for management might be a
> good idea.

In the current state *iscsi netlink interface* does not allow the user space
apps for iSCSI H/W offload solution (in our case its qla4xxx) to pass down bunch 
of parameter's in one shot for configuration purposes. As of know one can pass 
one param at a time using netlink but that does not fit very well for offload
solution. Basically on the driver/FW side, it needs to use MBX interface for 
most of the configuration part which requires payload to be passed back and forth.

Looking into what was done on bsg side for FC looks a better fit and 
provides the flexibility to add vendor specific stuff nicely and supports 
dma payloads etc. So I agree with what  has been discussed so far, about the 
need for *iSCSI bsg interface* support for H/W iSCSI offload solution. 

Ditto for flash management stuff - using bsg vendor mechanism makes more sense.

Here's an early snapshot of the patch which we are working on to add 
the support using bsg vendor specific part - btw this is based on the previous
iscsi bsg patch  and need to be synced up with what was posted recently. 
So we hope that this gives you an idea why this needed.
(Please discard the *PING changes* for right now)



diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 81b5f29..47c3f45 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -443,6 +443,38 @@ struct scsi_qla_host {
 	struct srb *status_srb;
 };
 
+struct qla4xxx_bsg_cmd {
+	uint32_t cmd;
+	uint32_t sub_cmd;
+	uint32_t data_len;
+	uint32_t instance;
+};
+
+enum ql4_bsg_vendor_priv_cmd {
+	QL4_GET_DATA,
+	QL4_SET_DATA,
+	QL4_RESTORE_FACTORY_DEF,
+	QL4_DISABLE_ACB,
+};
+
+enum ql4_get_data {
+	QL4_GET_FLASH,
+	QL4_GET_DDB_DEF,
+	QL4_GET_DDB,
+	QL4_GET_IFCB_DEF,
+	QL4_GET_IFCB,
+	QL4_GET_ACB,
+	QL4_GET_ISCSI_STAT,
+};
+
+enum ql4_set_data {
+	QL4_SET_FLASH,
+	QL4_SET_DDB,
+	QL4_SET_IFCB,
+	QL4_SET_ACB,
+	QL4_RST_ISCSI_STAT,
+};
+
 static inline int is_qla4010(struct scsi_qla_host *ha)
 {
 	return ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP4010;
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 96ebfb0..b5f3178 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -34,6 +34,24 @@ int qla4xxx_get_flash(struct scsi_qla_host * ha, dma_addr_t dma_addr,
 int qla4xxx_get_firmware_status(struct scsi_qla_host * ha);
 int qla4xxx_get_firmware_state(struct scsi_qla_host * ha);
 int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha);
+int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
+			    dma_addr_t dma_addr);
+int qla4xxx_set_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
+		      uint32_t offset, uint32_t option, uint32_t len);
+int qla4xxx_get_acb(struct scsi_qla_host *ha, struct qla4xxx_bsg_cmd vendor_cmd,
+		    dma_addr_t data_dma);
+int qla4xxx_bsg_get_ifcb(struct scsi_qla_host *ha, uint32_t sub_cmd,
+			 dma_addr_t data_dma);
+int qla4xxx_set_ifcb(struct scsi_qla_host *ha, dma_addr_t data_dma);
+int qla4xxx_set_acb(struct scsi_qla_host *ha, uint32_t instance, uint32_t acb_len,
+		    dma_addr_t data_dma);
+int qla4xxx_restore_factory_defaults(struct scsi_qla_host *ha,
+					struct iscsi_bsg_job *job);
+int qla4xxx_ping(struct iscsi_bsg_job *job);
+int qla4xxx_rst_iscsi_stat(struct scsi_qla_host *ha, uint32_t device_index);
+int qla4xxx_get_iscsi_stat(struct scsi_qla_host *ha, uint32_t device_index,
+                           dma_addr_t data_dma);
+int qla4xxx_disable_acb(struct scsi_qla_host *ha, uint32_t acb_instance);
 
 /* FIXME: Goodness!  this really wants a small struct to hold the
  * parameters. On x86 the args will get passed on the stack! */
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index c196d55..94e4f96 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -529,6 +529,7 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			/* No action */
 			DEBUG2(printk("scsi%ld: AEN %04x\n", ha->host_no,
 				      mbox_status));
+			clear_bit(AF_DISABLE_ACB_COMPLETE, &ha->flags);
 			break;
 
 		case MBOX_ASTS_IP_ADDR_STATE_CHANGED:
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 09d6d4b..d59456d 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -5,6 +5,9 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
+
+#include <scsi/scsi_bsg_iscsi.h>
+
 #include "ql4_def.h"
 #include "ql4_glbl.h"
 #include "ql4_dbg.h"
@@ -803,7 +806,7 @@ int qla4xxx_get_fw_version(struct scsi_qla_host * ha)
 	return QLA_SUCCESS;
 }
 
-static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
+int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
 				   dma_addr_t dma_addr)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
@@ -905,3 +908,307 @@ qla4xxx_send_tgts_exit:
 	return ret_val;
 }
 
+int qla4xxx_bsg_get_ifcb(struct scsi_qla_host *ha, uint32_t sub_cmd,
+			 dma_addr_t data_dma)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(mbox_sts, 0, sizeof(mbox_sts));
+
+	switch(sub_cmd) {
+	case QL4_GET_IFCB_DEF:
+		mbox_cmd[0] = MBOX_CMD_GET_INIT_FW_CTRL_BLOCK_DEFAULTS;
+		break;
+	case QL4_GET_IFCB:
+		mbox_cmd[0] = MBOX_CMD_GET_INIT_FW_CTRL_BLOCK;
+		break;
+	}
+
+	mbox_cmd[1] = 0;
+	mbox_cmd[2] = LSDW(data_dma);
+	mbox_cmd[3] = MSDW(data_dma);
+	//TODO: ACB version chk
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, mbox_cmd, mbox_sts)
+		!= QLA_SUCCESS) {
+		printk("scsi%ld: %s: "
+			"Failed to get init_fw_ctrl_blk, staus: %04X\n",
+			ha->host_no, __func__, mbox_sts[0]);
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_get_acb(struct scsi_qla_host *ha, struct qla4xxx_bsg_cmd vendor_cmd,
+		    dma_addr_t data_dma)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_GET_ACB;
+	mbox_cmd[1] = vendor_cmd.instance;  /* Primary/Secondary */
+	mbox_cmd[2] = LSDW(data_dma);
+	mbox_cmd[3] = MSDW(data_dma);
+	mbox_cmd[4] = vendor_cmd.data_len;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, mbox_cmd, mbox_sts)
+		!= QLA_SUCCESS) {
+		printk("scsi%ld: %s: "
+			"Failed to get acb, staus: %04X\n",
+			ha->host_no, __func__, mbox_sts[0]);
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_set_flash(struct scsi_qla_host *ha,        dma_addr_t dma_addr,
+		      uint32_t offset, uint32_t option, uint32_t len)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_WRITE_FLASH;
+	mbox_cmd[1] = LSDW(dma_addr);
+	mbox_cmd[2] = MSDW(dma_addr);
+	mbox_cmd[3] = offset;
+	mbox_cmd[4] = len;
+	mbox_cmd[5] = option;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, mbox_cmd, mbox_sts)
+		!= QLA_SUCCESS) {
+		printk("scsi%ld: %s: "
+			"MBOX_CMD_WRITE_FLASH failed w/ status %04X\n",
+			ha->host_no, __func__, mbox_sts[0]);
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_set_ifcb(struct scsi_qla_host *ha, dma_addr_t data_dma)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_INITIALIZE_FIRMWARE;
+	mbox_cmd[1] = 0;
+	mbox_cmd[2] = LSDW(data_dma);
+	mbox_cmd[3] = MSDW(data_dma);
+	//TODO: ADD ACB support
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_INITIALIZE_FIRMWARE,"
+			      " failed w/ status %04X\n",
+			      ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_set_acb(struct scsi_qla_host *ha, uint32_t instance,
+		    uint32_t acb_len, dma_addr_t data_dma)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_SET_ACB;
+	mbox_cmd[1] = instance;
+	mbox_cmd[2] = LSDW(data_dma);
+	mbox_cmd[3] = MSDW(data_dma);
+	mbox_cmd[4] = acb_len;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_SET_ACB, failed w/ "
+		    "status %04X\n", ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+/**
+ * qla4xxx_restore_factory_defaults - restore hba factory defaults
+ * @ha: Pointer to host adapter structure.
+ * @job: iscsi_bsg_job to handle
+ **/
+int qla4xxx_restore_factory_defaults(struct scsi_qla_host *ha, struct iscsi_bsg_job *job)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_RESTORE_FACTORY_DEFAULTS;
+	mbox_cmd[3] = job->request->rqst_data.h_vendor.vendor_cmd[4];
+	mbox_cmd[4] = job->request->rqst_data.h_vendor.vendor_cmd[5];
+	mbox_cmd[5] = job->request->rqst_data.h_vendor.vendor_cmd[6];
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+		&mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_RESTORE_FACTORY_DEFAULTS,"
+			      " failed w/ status %04X\n",
+			      ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+/**
+ * qla4xxx_ping - ping to specified IP address
+ * @ha: Pointer to host adapter structure.
+ * @job: iscsi_bsg_job to handle
+ **/
+int qla4xxx_ping(struct iscsi_bsg_job *job)
+{
+        uint32_t        mbox_cmd[MBOX_REG_COUNT];
+        uint32_t        mbox_sts[MBOX_REG_COUNT];
+	uint32_t	ctrl_flag;
+	struct scsi_qla_host *ha = to_qla_host(job->shost);
+
+	if (job->request->rqst_data.h_ping.ip_type && ISCSI_IPv4) 
+		ctrl_flag = ctrl_flag || ISCSI_IPv4; 
+	else if (job->request->rqst_data.h_ping.ip_type && ISCSI_IPv6)
+		ctrl_flag = ctrl_flag || ISCSI_IPv6;
+	else
+		ctrl_flag = 0;
+
+
+        memset(mbox_cmd, 0, sizeof(mbox_cmd));
+        memset(mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_PING;
+	mbox_cmd[1] = ctrl_flag;
+	mbox_cmd[2] = job->request->rqst_data.h_ping.ip_address[0];
+	mbox_cmd[3] = job->request->rqst_data.h_ping.ip_address[1];
+	mbox_cmd[4] = job->request->rqst_data.h_ping.ip_address[2];
+	mbox_cmd[5] = job->request->rqst_data.h_ping.ip_address[3];
+	mbox_cmd[5] = job->request->rqst_data.h_ping.payload_size;
+	
+	
+        if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+                &mbox_sts[0]) != QLA_SUCCESS) {
+                DEBUG2(printk("scsi%ld: %s: MBOX_CMD_PING, failed w/ "
+                    "status %04X\n", ha->host_no, __func__, mbox_sts[0]));
+                return QLA_ERROR;
+        }
+
+        return QLA_SUCCESS;
+}
+
+int qla4xxx_get_iscsi_stat(struct scsi_qla_host *ha, uint32_t device_index,
+			   dma_addr_t data_dma)
+{
+        uint32_t mbox_cmd[MBOX_REG_COUNT];
+        uint32_t mbox_sts[MBOX_REG_COUNT];
+
+        memset(mbox_cmd, 0, sizeof(mbox_cmd));
+        memset(mbox_sts, 0, sizeof(mbox_sts));
+
+        mbox_cmd[0] = MBOX_CMD_GET_MANAGEMENT_DATA;
+	mbox_cmd[1] = device_index;
+	mbox_cmd[2] = LSDW(data_dma);
+	mbox_cmd[3] = MSDW(data_dma);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+		&mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_MANAGEMENT_DATA,"
+			" failed w/ status %04X\n",
+			ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_rst_iscsi_stat(struct scsi_qla_host *ha, uint32_t device_index)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_GET_MANAGEMENT_DATA;
+	mbox_cmd[1] = device_index;
+	mbox_cmd[2] = 0;
+	mbox_cmd[3] = 0;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+		&mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_MANAGEMENT_DATA,"
+			" failed w/ status %04X\n",
+			ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_disable_acb(struct scsi_qla_host *ha, uint32_t acb_instance)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_DISABLE_ACB;
+	mbox_cmd[1] = acb_instance;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		if(mbox_sts[0] == MBOX_STS_INTERMEDIATE_COMPLETION) {
+			unsigned long  wait_cnt;
+
+			/* Poll AF_DISABLE_ACB_COMPLETE bit for
+			 * AEN 8027 completion */
+			wait_cnt = jiffies + WAIT_CMD_TOV * HZ;
+			while (!time_after_eq(jiffies, wait_cnt)) {
+
+				if (test_bit(AF_DISABLE_ACB_COMPLETE,
+					&ha->flags) ==0) {
+					break;
+				}
+
+				DEBUG2(printk("."));
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				schedule_timeout(1 * HZ);
+			}
+		}
+		if (test_bit(AF_DISABLE_ACB_COMPLETE,
+			     &ha->flags) == 0) {
+			DEBUG2(printk("scsi%ld: %s: Succeeded\n",
+			    ha->host_no, __func__));
+			goto exit_disable_acb;
+		} else {
+
+			DEBUG2(printk("scsi%ld: %s: "
+			    "Intermediate Timed Out\n",
+			    ha->host_no, __func__));
+		}
+
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_SET_ACB, failed w/ "
+		    "status %04X\n", ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+exit_disable_acb:
+	return QLA_SUCCESS;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 83c8b5e..e1d106c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8,6 +8,8 @@
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_bsg_iscsi.h>
+#include <scsi/scsi_netlink.h>
 
 #include "ql4_def.h"
 #include "ql4_version.h"
@@ -67,6 +69,7 @@ static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf);
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
+static int qla4xxx_bsg_request(struct iscsi_bsg_job *job);
 
 /*
  * SCSI host template entry points
@@ -105,6 +108,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
+	.vendor_id              = SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC,
 };
 
 static struct iscsi_transport qla4xxx_iscsi_transport = {
@@ -122,8 +126,210 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.get_session_param	= qla4xxx_sess_get_param,
 	.get_host_param		= qla4xxx_host_get_param,
 	.session_recovery_timedout = qla4xxx_recovery_timedout,
+	.bsg_request            = qla4xxx_bsg_request,
 };
 
+/**
+ * qla4xxx_set_data - data from application to driver
+ * @ha: Pointer to host adapter structure.
+ * @job: iscsi_bsg_job to handle
+ * @vendor_cmd: bsg vendor specific command structure
+ * @data: data buffer
+ * @data_dma: DMA address of data buffer
+ **/
+int qla4xxx_set_data(struct scsi_qla_host *ha, struct iscsi_bsg_job *job,
+                struct qla4xxx_bsg_cmd vendor_cmd, uint8_t *data,
+                dma_addr_t data_dma)
+{
+	int rval = QLA_SUCCESS;
+	uint32_t offset, option;
+	uint32_t num, count;
+	struct scatterlist *sge = NULL;
+
+	count = 0;
+	for_each_sg(job->request_payload.sg_list, sge,
+		    job->request_payload.sg_cnt, num) {
+		memcpy(data, sg_virt(sge), sg_dma_len(sge));
+		data += sg_dma_len(sge);
+		count += sg_dma_len(sge);
+	}
+	data -= count;
+
+	switch(vendor_cmd.sub_cmd) {
+	case QL4_SET_FLASH:
+		offset = job->request->rqst_data.h_vendor.vendor_cmd[4];
+		option = job->request->rqst_data.h_vendor.vendor_cmd[5];
+
+		rval = qla4xxx_set_flash(ha, data_dma, offset, option,
+						vendor_cmd.data_len);
+		break;
+	case QL4_SET_DDB:
+		rval = qla4xxx_set_ddb_entry(ha, vendor_cmd.instance, data_dma);
+		break;
+	case QL4_SET_IFCB:
+		rval = qla4xxx_set_ifcb(ha, data_dma);
+		break;
+	case QL4_SET_ACB:
+		rval = qla4xxx_set_acb(ha, vendor_cmd.instance, vendor_cmd.data_len,
+					data_dma);
+		break;
+	case QL4_RST_ISCSI_STAT:
+		rval = qla4xxx_rst_iscsi_stat(ha, vendor_cmd.instance);
+		break;
+	}
+	job->reply->reply_payload_rcv_len = 0;
+	return rval;
+}
+
+/**
+ * qla4xxx_get_data - data from driver to application
+ * @ha: Pointer to host adapter structure.
+ * @job: iscsi_bsg_job to handle
+ * @vendor_cmd: bsg vendor specific command structure
+ * @data: data buffer
+ * @data_dma: DMA address of data buffer
+ **/
+int qla4xxx_get_data(struct scsi_qla_host *ha, struct iscsi_bsg_job *job,
+               struct qla4xxx_bsg_cmd vendor_cmd, uint8_t *data,
+               dma_addr_t data_dma)
+{
+	int rval = QLA_SUCCESS;
+	uint32_t offset;
+	uint32_t num, count;
+	struct scatterlist *sge = NULL;
+
+	switch(vendor_cmd.sub_cmd) {
+	case QL4_GET_FLASH:
+		offset = job->request->rqst_data.h_vendor.vendor_cmd[4];
+		rval = qla4xxx_get_flash(ha, data_dma, offset, vendor_cmd.data_len);
+		break;
+	case QL4_GET_DDB_DEF:
+		rval = qla4xxx_get_default_ddb(ha, data_dma);
+		break;
+	case QL4_GET_DDB:
+		rval = qla4xxx_get_fwddb_entry(ha, vendor_cmd.instance, NULL,
+				data_dma, NULL, NULL, NULL, NULL, NULL, NULL);
+		break;
+	case QL4_GET_IFCB_DEF:
+	case QL4_GET_IFCB:
+		rval = qla4xxx_bsg_get_ifcb(ha, vendor_cmd.sub_cmd, data_dma);
+		break;
+	case QL4_GET_ACB:
+		rval = qla4xxx_get_acb(ha, vendor_cmd, data_dma);
+		break;
+	case QL4_GET_ISCSI_STAT:
+		rval = qla4xxx_get_iscsi_stat(ha, vendor_cmd.instance, data_dma);
+		break;
+	}
+
+	count = 0;
+	for_each_sg(job->reply_payload.sg_list, sge,
+		    job->reply_payload.sg_cnt, num) {
+		memcpy(sg_virt(sge), data, sg_dma_len(sge));
+		data += sg_dma_len(sge);
+		count += sg_dma_len(sge);
+	}
+
+	job->reply->reply_payload_rcv_len = count;
+	return rval;
+}
+
+/**
+ * qla4xxx_process_vendor_specific - handle vendor specific bsg request
+ * @job: iscsi_bsg_job to handle
+ **/
+int qla4xxx_process_vendor_specific(struct iscsi_bsg_job *job)
+{
+	struct qla4xxx_bsg_cmd vendor_cmd;
+	uint32_t tot_len, num;
+	uint8_t *data;
+	dma_addr_t data_dma;
+	struct scsi_qla_host *ha = to_qla_host(job->shost);
+	struct scatterlist *sge = NULL;
+	int rval = QLA_SUCCESS;
+
+	vendor_cmd.cmd = job->request->rqst_data.h_vendor.vendor_cmd[0];
+	vendor_cmd.sub_cmd = job->request->rqst_data.h_vendor.vendor_cmd[1];
+	vendor_cmd.data_len = job->request->rqst_data.h_vendor.vendor_cmd[2];
+	vendor_cmd.instance = job->request->rqst_data.h_vendor.vendor_cmd[3];
+
+	dma_map_sg(&ha->pdev->dev, job->request_payload.sg_list,
+		   job->request_payload.sg_cnt, DMA_TO_DEVICE);
+
+	dma_map_sg(&ha->pdev->dev, job->reply_payload.sg_list,
+		   job->reply_payload.sg_cnt, DMA_TO_DEVICE);
+
+	for_each_sg(job->request_payload.sg_list, sge,
+		    job->request_payload.sg_cnt, num) {
+		tot_len += sg_dma_len(sge);
+	}
+
+	data = dma_alloc_coherent(&ha->pdev->dev, vendor_cmd.data_len,
+					&data_dma, GFP_KERNEL);
+
+	if (data == NULL){
+		DEBUG2(printk("scsi %ld: %s: fail to allocate memory"
+			" for data", ha->host_no, __func__));
+		return -EIO;
+	}
+
+	switch(vendor_cmd.cmd) {
+	case QL4_GET_DATA:
+		rval = qla4xxx_get_data(ha, job, vendor_cmd, data, data_dma);
+		break;
+	case QL4_SET_DATA:
+		rval = qla4xxx_set_data(ha, job, vendor_cmd, data, data_dma);
+		break;
+	case QL4_RESTORE_FACTORY_DEF:
+		rval = qla4xxx_restore_factory_defaults(ha, job);
+		break;
+	case QL4_DISABLE_ACB:
+		rval = qla4xxx_disable_acb(ha, vendor_cmd.instance);
+		break;
+	}
+
+	job->reply->result = rval;
+	job->job_done(job);
+
+	dma_free_coherent(&ha->pdev->dev, vendor_cmd.data_len, data,
+			  data_dma);
+
+	dma_unmap_sg(&ha->pdev->dev,
+	     job->request_payload.sg_list,
+	     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+
+	dma_unmap_sg(&ha->pdev->dev,
+	     job->reply_payload.sg_list,
+	     job->reply_payload.sg_cnt, DMA_TO_DEVICE);
+
+	return rval;
+}
+
+/**
+ * qla4xxx_bsg_request - handle bsg request from ISCSI transport
+ * @job: iscsi_bsg_job to handle
+ */
+static int qla4xxx_bsg_request(struct iscsi_bsg_job *job)
+{
+	uint32_t msgcode;
+	int rval = -EINVAL;
+
+	msgcode = job->request->msgcode;
+
+	switch (msgcode) {
+	case ISCSI_BSG_HST_VENDOR:
+		rval = qla4xxx_process_vendor_specific(job);
+		break;
+	case ISCSI_BSG_HST_PING:
+		rval = qla4xxx_ping(job);
+		break;
+	default:
+		break;
+	}
+
+	return rval;
+}
+
 static struct scsi_transport_template *qla4xxx_scsi_transport;
 
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2ea8252..fb97a5c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -403,9 +403,9 @@ iscsi_bsg_map_buffer(struct iscsi_bsg_buffer *buf, struct request *req)
 
 /**
  * iscsi_req_to_bsgjob - Allocate/create the iscsi_bsg_job structure for the
- *                   bsg request
- * @req:       BSG request that needs a job structure
- * @shost:     SCSI Host corresponding to the bsg object
+ * 			 bsg request
+ * @req:	BSG request that needs a job structure
+ * @shost:	SCSI Host corresponding to the bsg object
  */
 static int
 iscsi_req_to_bsgjob(struct request *req, struct Scsi_Host *shost)
@@ -428,7 +428,7 @@ iscsi_req_to_bsgjob(struct request *req, struct Scsi_Host *shost)
 	 * then gets reformatted as a blk request, which then gets
 	 * reformatted as a iscsi bsg request. And on completion, we have
 	 * to wrap return results such that SGIO v4 thinks it was a scsi
-	 * status.  I hope this was all worth it.
+	 * status. I hope this was all worth it.
 	 */
 
 	req->special = job;
@@ -500,6 +500,9 @@ iscsi_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
 			goto fail_host_msg;
 		}
 		break;
+	case ISCSI_BSG_HST_PING:
+		cmdlen += sizeof(struct iscsi_bsg_host_ping);
+		break;
 
 	default:
 		ret = -EBADR;


Thanks
Ravi



> 
> --
> You received this message because you are subscribed to the Google Groups "open-iscsi" group.
> To post to this group, send email to open-iscsi@googlegroups.com.
> To unsubscribe from this group, send email to open-iscsi+unsubscribe@googlegroups.com.
> For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
