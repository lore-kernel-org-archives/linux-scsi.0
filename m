From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH 1/1] [SCSI] mpt2sas: Convert non-returned local variable to
 boolean when relevant
Date: Wed, 17 Dec 2014 15:56:18 +0100
Message-ID: <20141217145618.GA2812@sloth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33882 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaLQO4V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2014 09:56:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch was produced using Coccinelle. A simplified version of the
semantic patch is:

@r exists@
identifier f;
local idexpression u8 x;
identifier xname;
@@

f(...) {
...when any
(
  x@xname = 1;
|
  x@xname = 0;
)
...when any
}

@bad exists@
identifier r.f;
local idexpression u8 r.x
expression e1 != {0, 1}, e2;
@@

f(...) {
...when any
(
  x = e1;
|
  x + e2
)
...when any
}

@depends on !bad@
identifier r.f;
local idexpression u8 r.x;
identifier r.xname;
@@

f(...) {
...
++ bool xname;
- int xname;
<...
(
  x =
- 1
+ true
|
  x =
- -1
+ false
)
...>

}

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c      | 24 ++++++++++++------------
 drivers/scsi/mpt2sas/mpt2sas_config.c    |  5 +++--
 drivers/scsi/mpt2sas/mpt2sas_ctl.c       | 22 +++++++++++-----------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 17 ++++++++---------
 drivers/scsi/mpt2sas/mpt2sas_transport.c | 27 ++++++++++++++-------------
 5 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 58e4521..7a8c362 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1414,10 +1414,10 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	struct msix_entry *entries, *a;
 	int r;
 	int i;
-	u8 try_msix = 0;
+	bool try_msix = false;
 
 	if (msix_disable == -1 || msix_disable == 0)
-		try_msix = 1;
+		try_msix = true;
 
 	if (!try_msix)
 		goto try_ioapic;
@@ -3115,7 +3115,7 @@ _base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER *ioc, int request_bytes,
 {
 	MPI2DefaultReply_t *default_reply = (MPI2DefaultReply_t *)reply;
 	int i;
-	u8 failed;
+	bool failed;
 	u16 dummy;
 	__le32 *mfp;
 
@@ -3150,10 +3150,10 @@ _base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER *ioc, int request_bytes,
 	}
 
 	/* send message 32-bits at a time */
-	for (i = 0, failed = 0; i < request_bytes/4 && !failed; i++) {
+	for (i = 0, failed = false; i < request_bytes/4 && !failed; i++) {
 		writel(cpu_to_le32(request[i]), &ioc->chip->Doorbell);
 		if ((_base_wait_for_doorbell_ack(ioc, 5, sleep_flag)))
-			failed = 1;
+			failed = true;
 	}
 
 	if (failed) {
@@ -3236,7 +3236,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
 	u16 smid;
 	u32 ioc_state;
 	unsigned long timeleft;
-	u8 issue_reset;
+	bool issue_reset;
 	int rc;
 	void *request;
 	u16 wait_state_count;
@@ -3300,7 +3300,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SasIoUnitControlRequest_t)/4);
 		if (!(ioc->base_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = true;
 		goto issue_host_reset;
 	}
 	if (ioc->base_cmds.status & MPT2_CMD_REPLY_VALID)
@@ -3341,7 +3341,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
 	u16 smid;
 	u32 ioc_state;
 	unsigned long timeleft;
-	u8 issue_reset;
+	bool issue_reset;
 	int rc;
 	void *request;
 	u16 wait_state_count;
@@ -3398,7 +3398,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SepRequest_t)/4);
 		if (!(ioc->base_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = true;
 		goto issue_host_reset;
 	}
 	if (ioc->base_cmds.status & MPT2_CMD_REPLY_VALID)
@@ -4026,9 +4026,9 @@ mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_type)
 {
 	int i, j;
 	u32 event_mask, desired_event;
-	u8 send_update_to_fw;
+	bool send_update_to_fw;
 
-	for (i = 0, send_update_to_fw = 0; i <
+	for (i = 0, send_update_to_fw = false; i <
 	    MPI2_EVENT_NOTIFY_EVENTMASK_WORDS; i++) {
 		event_mask = ~event_type[i];
 		desired_event = 1;
@@ -4036,7 +4036,7 @@ mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_type)
 			if (!(event_mask & desired_event) &&
 			    (ioc->event_masks[i] & desired_event)) {
 				ioc->event_masks[i] &= ~desired_event;
-				send_update_to_fw = 1;
+				send_update_to_fw = true;
 			}
 			desired_event = (desired_event << 1);
 		}
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index c72a2ff..8793518 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -291,7 +291,8 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	unsigned long timeleft;
 	Mpi2ConfigRequest_t *config_request;
 	int r;
-	u8 retry_count, issue_host_reset = 0;
+	bool issue_host_reset = false;
+	u8 retry_count;
 	u16 wait_state_count;
 	struct config_request mem;
 
@@ -402,7 +403,7 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		if ((ioc->shost_recovery) || (ioc->config_cmds.status &
 		    MPT2_CMD_RESET) || ioc->pci_error_recovery)
 			goto retry_config;
-		issue_host_reset = 1;
+		issue_host_reset = true;
 		r = -EFAULT;
 		goto free_mem;
 	}
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index ca4e563..4d7edb2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -352,7 +352,7 @@ mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
 	u16 event;
 	int i;
 	u32 sz, event_data_sz;
-	u8 send_aen = 0;
+	bool send_aen = false;
 
 	if (!ioc->event_log)
 		return;
@@ -371,7 +371,7 @@ mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
 		sz = min_t(u32, event_data_sz, MPT2_EVENT_DATA_SIZE);
 		memset(event_log[i].data, 0, MPT2_EVENT_DATA_SIZE);
 		memcpy(event_log[i].data, mpi_reply->EventData, sz);
-		send_aen = 1;
+		send_aen = true;
 	}
 
 	/* This aen_event_read_flag flag is set until the
@@ -541,7 +541,7 @@ static int
 _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
     Mpi2SCSITaskManagementRequest_t *tm_request)
 {
-	u8 found = 0;
+	bool found = false;
 	u16 i;
 	u16 handle;
 	struct scsi_cmnd *scmd;
@@ -576,7 +576,7 @@ _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
 		if (priv_data->sas_target->handle != handle)
 			continue;
 		tm_request->TaskMID = cpu_to_le16(ioc->scsi_lookup[i - 1].smid);
-		found = 1;
+		found = true;
 	}
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
@@ -622,7 +622,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command karg,
 	u16 ioc_status;
 	u16 smid;
 	unsigned long timeout, timeleft;
-	u8 issue_reset;
+	bool issue_reset;
 	u32 sz;
 	void *psge;
 	void *data_out = NULL;
@@ -635,7 +635,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command karg,
 	long ret;
 	u16 wait_state_count;
 
-	issue_reset = 0;
+	issue_reset = false;
 
 	if (ioc->ctl_cmds.status != MPT2_CMD_NOT_USED) {
 		printk(MPT2SAS_ERR_FMT "%s: ctl_cmd in use\n",
@@ -915,7 +915,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command karg,
 		    __func__);
 		_debug_dump_mf(mpi_request, karg.data_sge_offset);
 		if (!(ioc->ctl_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = true;
 		goto issue_host_reset;
 	}
 
@@ -1357,7 +1357,7 @@ _ctl_diag_register_2(struct MPT2SAS_ADAPTER *ioc,
 	unsigned long timeleft;
 	u16 smid;
 	u16 ioc_status;
-	u8 issue_reset = 0;
+	bool issue_reset = false;
 
 	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
@@ -1467,7 +1467,7 @@ _ctl_diag_register_2(struct MPT2SAS_ADAPTER *ioc,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2DiagBufferPostRequest_t)/4);
 		if (!(ioc->ctl_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = true;
 		goto issue_host_reset;
 	}
 
@@ -1934,7 +1934,7 @@ _ctl_diag_read_buffer(struct MPT2SAS_ADAPTER *ioc, void __user *arg)
 	unsigned long timeleft, request_size, copy_size;
 	u16 smid;
 	u16 ioc_status;
-	u8 issue_reset = 0;
+	bool issue_reset = false;
 
 	if (copy_from_user(&karg, arg, sizeof(karg))) {
 		printk(KERN_ERR "failure at %s:%d/%s()!\n",
@@ -2056,7 +2056,7 @@ _ctl_diag_read_buffer(struct MPT2SAS_ADAPTER *ioc, void __user *arg)
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2DiagBufferPostRequest_t)/4);
 		if (!(ioc->ctl_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = true;
 		goto issue_host_reset;
 	}
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6a1c036..9a3b36b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1961,7 +1961,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 	struct _raid_device *raid_device;
 	unsigned long flags;
 	int qdepth;
-	u8 ssp_target = 0;
+	bool ssp_target = false;
 	char *ds = "";
 	char *r_level = "";
 	u16 handle, volume_handle = 0;
@@ -2090,7 +2090,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 	sas_device->volume_wwid = volume_wwid;
 	if (sas_device->device_info & MPI2_SAS_DEVICE_INFO_SSP_TARGET) {
 		qdepth = MPT2SAS_SAS_QUEUE_DEPTH;
-		ssp_target = 1;
+		ssp_target = true;
 		ds = "SSP";
 	} else {
 		qdepth = MPT2SAS_SATA_QUEUE_DEPTH;
@@ -2264,7 +2264,7 @@ mpt2sas_scsih_set_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 {
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
-	u8 skip = 0;
+	bool skip = false;
 
 	shost_for_each_device(sdev, ioc->shost) {
 		if (skip)
@@ -2274,7 +2274,7 @@ mpt2sas_scsih_set_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 			continue;
 		if (sas_device_priv_data->sas_target->handle == handle) {
 			sas_device_priv_data->sas_target->tm_busy = 1;
-			skip = 1;
+			skip = true;
 			ioc->ignore_loginfos = 1;
 		}
 	}
@@ -2292,7 +2292,7 @@ mpt2sas_scsih_clear_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 {
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
-	u8 skip = 0;
+	bool skip = false;
 
 	shost_for_each_device(sdev, ioc->shost) {
 		if (skip)
@@ -2302,7 +2302,7 @@ mpt2sas_scsih_clear_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 			continue;
 		if (sas_device_priv_data->sas_target->handle == handle) {
 			sas_device_priv_data->sas_target->tm_busy = 0;
-			skip = 1;
+			skip = true;
 			ioc->ignore_loginfos = 0;
 		}
 	}
@@ -6317,7 +6317,7 @@ _scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc,
 {
 	Mpi2EventIrConfigElement_t *element;
 	int i;
-	u8 foreign_config;
+	bool foreign_config;
 	Mpi2EventDataIrConfigChangeList_t *event_data =
 		(Mpi2EventDataIrConfigChangeList_t *)
 		fw_event->event_data;
@@ -6332,8 +6332,7 @@ _scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc,
 	if (ioc->shost_recovery)
 		return;
 
-	foreign_config = (le32_to_cpu(event_data->Flags) &
-	    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG) ? 1 : 0;
+	foreign_config = (le32_to_cpu(event_data->Flags) & MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG) ? true : false;
 
 	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
 	for (i = 0; i < event_data->NumElements; i++, element++) {
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index e689bf2..75807c0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -298,7 +298,7 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	unsigned long timeleft;
 	void *psge;
 	u32 sgl_flags;
-	u8 issue_reset = 0;
+	bool issue_reset = false;
 	void *data_out = NULL;
 	dma_addr_t data_out_dma;
 	u32 sz;
@@ -412,7 +412,7 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SmpPassthroughRequest_t)/4);
 		if (!(ioc->transport_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = true;
 		goto issue_host_reset;
 	}
 
@@ -789,7 +789,7 @@ mpt2sas_transport_port_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
 	unsigned long flags;
 	struct _sas_port *mpt2sas_port, *next;
 	struct _sas_node *sas_node;
-	u8 found = 0;
+	bool found = false;
 	struct _sas_phy *mpt2sas_phy, *next_phy;
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
@@ -803,7 +803,7 @@ mpt2sas_transport_port_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
 	    port_list) {
 		if (mpt2sas_port->remote_identify.sas_address != sas_address)
 			continue;
-		found = 1;
+		found = true;
 		list_del(&mpt2sas_port->port_list);
 		goto out;
 	}
@@ -1088,7 +1088,7 @@ _transport_get_expander_phy_error_log(struct MPT2SAS_ADAPTER *ioc,
 	unsigned long timeleft;
 	void *psge;
 	u32 sgl_flags;
-	u8 issue_reset = 0;
+	bool issue_reset = false;
 	void *data_out = NULL;
 	dma_addr_t data_out_dma;
 	u32 sz;
@@ -1204,7 +1204,7 @@ _transport_get_expander_phy_error_log(struct MPT2SAS_ADAPTER *ioc,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SmpPassthroughRequest_t)/4);
 		if (!(ioc->transport_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = true;
 		goto issue_host_reset;
 	}
 
@@ -1411,7 +1411,7 @@ _transport_expander_phy_control(struct MPT2SAS_ADAPTER *ioc,
 	unsigned long timeleft;
 	void *psge;
 	u32 sgl_flags;
-	u8 issue_reset = 0;
+	bool issue_reset = false;
 	void *data_out = NULL;
 	dma_addr_t data_out_dma;
 	u32 sz;
@@ -1534,7 +1534,7 @@ _transport_expander_phy_control(struct MPT2SAS_ADAPTER *ioc,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SmpPassthroughRequest_t)/4);
 		if (!(ioc->transport_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = true;
 		goto issue_host_reset;
 	}
 
@@ -1648,7 +1648,8 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 	u16 sz;
 	int rc = 0;
 	unsigned long flags;
-	int i, discovery_active;
+	bool discovery_active;
+	int i;
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	if (_transport_sas_node_find_by_sas_address(ioc,
@@ -1693,14 +1694,14 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 	}
 
 	/* unable to enable/disable phys when when discovery is active */
-	for (i = 0, discovery_active = 0; i < ioc->sas_hba.num_phys ; i++) {
+	for (i = 0, discovery_active = false; i < ioc->sas_hba.num_phys ; i++) {
 		if (sas_iounit_pg0->PhyData[i].PortFlags &
 		    MPI2_SASIOUNIT0_PORTFLAGS_DISCOVERY_IN_PROGRESS) {
 			printk(MPT2SAS_ERR_FMT "discovery is active on "
 			    "port = %d, phy = %d: unable to enable/disable "
 			    "phys, try again later!\n", ioc->name,
 			    sas_iounit_pg0->PhyData[i].Port, i);
-			discovery_active = 1;
+			discovery_active = true;
 		}
 	}
 
@@ -1904,7 +1905,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	unsigned long timeleft;
 	void *psge;
 	u32 sgl_flags;
-	u8 issue_reset = 0;
+	bool issue_reset = false;
 	dma_addr_t dma_addr_in = 0;
 	dma_addr_t dma_addr_out = 0;
 	dma_addr_t pci_dma_in = 0;
@@ -2077,7 +2078,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SmpPassthroughRequest_t)/4);
 		if (!(ioc->transport_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = true;
 		goto issue_host_reset;
 	}
 
-- 
1.9.1

