From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Christoph Hellwig <hch@infradead.org> wrote:
Date: Mon, 2 Jun 2014 16:41:22 -0400
Message-ID: <1401741682-12156-1-git-send-email-joe.lawrence@stratus.com>
References: <20140602163150.GB26828@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o141.mxlogic.net ([208.65.145.74]:49499 "EHLO
	p02c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbaFBUtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:49:23 -0400
In-Reply-To: <20140602163150.GB26828@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Joe Lawrence <joe.lawrence@stratus.com>

> On Mon, Jun 02, 2014 at 10:37:26AM -0400, Joe Lawrence wrote:
> > If mpt3sas_send_trigger_data_event exits early without inserting a
> > fw_event, be sure to undo any prior allocations.
> 
> Looks good, but why don't we just allocate the two in a single
> allocation?

Hi Christoph,

The following routines already handle two allocations safely:

 mpt2sas_scsih_event_callback
 mpt3sas_scsih_event_callback

but if we wanted to merge them, it could look something like this (introducing
a bunch of UglyCamelCaseCastings).  Compile tested only...  and doesn't include
mpt3sas or fusion versions.

-- >8 --

>From b34615dfb103613f228a82eb4eb6644a04036256 Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Sun, 1 Jun 2014 22:36:45 -0400
Subject: [PATCH] mpt3sas: combine fw_event_work and its event_data

Tack the firmware reply event_data payload to the end of its
corresponding struct fw_event_work allocation.

This fixes the following smatch warning:

  drivers/scsi/mpt3sas/mpt3sas_scsih.c:2522
    mpt3sas_send_trigger_data_event() warn: possible memory leak of
    'fw_event'

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   54 +++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e6f0720..8c2aa5d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -190,7 +190,7 @@ struct fw_event_work {
 	u8			VP_ID;
 	u8			ignore;
 	u16			event;
-	void			*event_data;
+	char			event_data[0];
 };
 
 /* raid transport support */
@@ -2495,7 +2495,6 @@ _scsih_fw_event_free(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	list_del(&fw_event->list);
-	kfree(fw_event->event_data);
 	kfree(fw_event);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
@@ -2516,12 +2515,10 @@ mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
 
 	if (ioc->is_driver_loading)
 		return;
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	fw_event = kzalloc(sizeof(*fw_event) + sizeof(*event_data),
+			   GFP_ATOMIC);
 	if (!fw_event)
 		return;
-	fw_event->event_data = kzalloc(sizeof(*event_data), GFP_ATOMIC);
-	if (!fw_event->event_data)
-		return;
 	fw_event->event = MPT3SAS_PROCESS_TRIGGER_DIAG;
 	fw_event->ioc = ioc;
 	memcpy(fw_event->event_data, event_data, sizeof(*event_data));
@@ -3216,7 +3213,8 @@ _scsih_check_topo_delete_events(struct MPT3SAS_ADAPTER *ioc,
 		if (fw_event->event != MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST ||
 		    fw_event->ignore)
 			continue;
-		local_event_data = fw_event->event_data;
+		local_event_data = (Mpi2EventDataSasTopologyChangeList_t *)
+				   &fw_event->event_data;
 		if (local_event_data->ExpStatus ==
 		    MPI2_EVENT_SAS_TOPO_ES_ADDED ||
 		    local_event_data->ExpStatus ==
@@ -5051,7 +5049,8 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	u64 sas_address;
 	unsigned long flags;
 	u8 link_rate, prev_link_rate;
-	Mpi2EventDataSasTopologyChangeList_t *event_data = fw_event->event_data;
+	Mpi2EventDataSasTopologyChangeList_t *event_data =
+		(Mpi2EventDataSasTopologyChangeList_t *) &fw_event->event_data;
 
 #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
@@ -5249,7 +5248,7 @@ _scsih_sas_device_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 	u64 sas_address;
 	unsigned long flags;
 	Mpi2EventDataSasDeviceStatusChange_t *event_data =
-	    fw_event->event_data;
+	    (Mpi2EventDataSasDeviceStatusChange_t *) &fw_event->event_data;
 
 #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
@@ -5345,7 +5344,7 @@ _scsih_sas_enclosure_dev_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_enclosure_dev_status_change_event_debug(ioc,
-		     fw_event->event_data);
+		     &fw_event->event_data);
 #endif
 }
 
@@ -5369,7 +5368,8 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 	u32 termination_count;
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
-	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
+	Mpi2EventDataSasBroadcastPrimitive_t *event_data =
+		(Mpi2EventDataSasBroadcastPrimitive_t *) &fw_event->event_data;
 	u16 ioc_status;
 	unsigned long flags;
 	int r;
@@ -5521,7 +5521,8 @@ static void
 _scsih_sas_discovery_event(struct MPT3SAS_ADAPTER *ioc,
 	struct fw_event_work *fw_event)
 {
-	Mpi2EventDataSasDiscovery_t *event_data = fw_event->event_data;
+	Mpi2EventDataSasDiscovery_t *event_data =
+		(Mpi2EventDataSasDiscovery_t *) &fw_event->event_data;
 
 #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
@@ -6007,7 +6008,8 @@ _scsih_sas_ir_config_change_event(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2EventIrConfigElement_t *element;
 	int i;
 	u8 foreign_config;
-	Mpi2EventDataIrConfigChangeList_t *event_data = fw_event->event_data;
+	Mpi2EventDataIrConfigChangeList_t *event_data =
+		(Mpi2EventDataIrConfigChangeList_t *) &fw_event->event_data;
 
 #ifdef CONFIG_SCSI_MPT3SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
@@ -6077,7 +6079,8 @@ _scsih_sas_ir_volume_event(struct MPT3SAS_ADAPTER *ioc,
 	u16 handle;
 	u32 state;
 	int rc;
-	Mpi2EventDataIrVolume_t *event_data = fw_event->event_data;
+	Mpi2EventDataIrVolume_t *event_data =
+		(Mpi2EventDataIrVolume_t *) fw_event->event_data;
 
 	if (ioc->shost_recovery)
 		return;
@@ -6160,7 +6163,8 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasDevicePage0_t sas_device_pg0;
 	u32 ioc_status;
-	Mpi2EventDataIrPhysicalDisk_t *event_data = fw_event->event_data;
+	Mpi2EventDataIrPhysicalDisk_t *event_data =
+		(Mpi2EventDataIrPhysicalDisk_t *) &fw_event->event_data;
 	u64 sas_address;
 
 	if (ioc->shost_recovery)
@@ -6280,7 +6284,8 @@ static void
 _scsih_sas_ir_operation_status_event(struct MPT3SAS_ADAPTER *ioc,
 	struct fw_event_work *fw_event)
 {
-	Mpi2EventDataIrOperationStatus_t *event_data = fw_event->event_data;
+	Mpi2EventDataIrOperationStatus_t *event_data =
+		(Mpi2EventDataIrOperationStatus_t *) &fw_event->event_data;
 	static struct _raid_device *raid_device;
 	unsigned long flags;
 	u16 handle;
@@ -7042,7 +7047,9 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 
 	switch (fw_event->event) {
 	case MPT3SAS_PROCESS_TRIGGER_DIAG:
-		mpt3sas_process_trigger_data(ioc, fw_event->event_data);
+		mpt3sas_process_trigger_data(ioc,
+			(struct SL_WH_TRIGGERS_EVENT_DATA_T *)
+			&fw_event->event_data);
 		break;
 	case MPT3SAS_REMOVE_UNRESPONDING_DEVICES:
 		while (scsi_host_in_recovery(ioc->shost) || ioc->shost_recovery)
@@ -7200,22 +7207,15 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		return 1;
 	}
 
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
-	if (!fw_event) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
-		return 1;
-	}
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
-	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
-	if (!fw_event->event_data) {
+	fw_event = kzalloc(sizeof(*fw_event) + sz, GFP_ATOMIC);
+	if (!fw_event) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
-		kfree(fw_event);
 		return 1;
 	}
 
-	memcpy(fw_event->event_data, mpi_reply->EventData, sz);
+	memcpy(&fw_event->event_data, mpi_reply->EventData, sz);
 	fw_event->ioc = ioc;
 	fw_event->VF_ID = mpi_reply->VF_ID;
 	fw_event->VP_ID = mpi_reply->VP_ID;
-- 
1.7.10.4

