From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 6/7] mptfusion: combine fw_event_work and its event_data
Date: Wed, 4 Jun 2014 12:52:09 -0400
Message-ID: <1401900729-19855-1-git-send-email-joe.lawrence@stratus.com>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:49002 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFDQw0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 12:52:26 -0400
In-Reply-To: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

Tack the firmware reply event_data payload to the end of its
corresponding struct fw_event_work allocation.  Rework fw_event_work
allocation calculations to include the event_data size where
appropriate.

This clarifies the code a bit and avoids the following smatch warnings:

  drivers/message/fusion/mptsas.c:1003 mptsas_queue_device_delete()
    error: memcpy() 'fw_event->event_data' too small (29 vs 36)

  drivers/message/fusion/mptsas.c:1017 mptsas_queue_rescan() error: not
    allocating enough data 168 vs 160

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

JL: In the existing code, struct fw_event_work includes an aligned
    char event_data[1] and when event data payload is required, a
    larger number of bytes is allocated.  This is calculated by
    subtracting the offsetof(struct fw_event_work, event_data) from
    the sizeof(struct fw_event_work) and adding the required payload
    size.  Was a single byte required to guarantee the alignment?
    If not, it seems clearer to just use a 0-length array and avoid the
    offsetof part.

 drivers/message/fusion/mptsas.c |   24 ++++++++++++------------
 drivers/message/fusion/mptsas.h |    2 +-
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 8bb580d..35c87b1 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -992,15 +992,15 @@ mptsas_queue_device_delete(MPT_ADAPTER *ioc,
 	struct fw_event_work *fw_event;
 	int sz;
 
-	sz = offsetof(struct fw_event_work, event_data) +
-	    sizeof(MpiEventDataSasDeviceStatusChange_t);
+	sz = sizeof(*fw_event) +
+		sizeof(MpiEventDataSasDeviceStatusChange_t);
 	fw_event = kzalloc(sz, GFP_ATOMIC);
 	if (!fw_event) {
 		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n",
 		    ioc->name, __func__, __LINE__);
 		return;
 	}
-	memcpy(fw_event->event_data, sas_event_data,
+	memcpy(&fw_event->event_data, sas_event_data,
 	    sizeof(MpiEventDataSasDeviceStatusChange_t));
 	fw_event->event = MPI_EVENT_SAS_DEVICE_STATUS_CHANGE;
 	fw_event->ioc = ioc;
@@ -1013,7 +1013,7 @@ mptsas_queue_rescan(MPT_ADAPTER *ioc)
 	struct fw_event_work *fw_event;
 	int sz;
 
-	sz = offsetof(struct fw_event_work, event_data);
+	sz = sizeof(*fw_event);
 	fw_event = kzalloc(sz, GFP_ATOMIC);
 	if (!fw_event) {
 		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n",
@@ -3617,7 +3617,7 @@ mptsas_send_expander_event(struct fw_event_work *fw_event)
 
 	ioc = fw_event->ioc;
 	expander_data = (MpiEventDataSasExpanderStatusChange_t *)
-	    fw_event->event_data;
+	    &fw_event->event_data;
 	memcpy(&sas_address, &expander_data->SASAddress, sizeof(__le64));
 	sas_address = le64_to_cpu(sas_address);
 	port_info = mptsas_find_portinfo_by_sas_address(ioc, sas_address);
@@ -3694,7 +3694,7 @@ mptsas_send_link_status_event(struct fw_event_work *fw_event)
 	u8 link_rate;
 
 	ioc = fw_event->ioc;
-	link_data = (MpiEventDataSasPhyLinkStatus_t *)fw_event->event_data;
+	link_data = (MpiEventDataSasPhyLinkStatus_t *) &fw_event->event_data;
 
 	memcpy(&sas_address, &link_data->SASAddress, sizeof(__le64));
 	sas_address = le64_to_cpu(sas_address);
@@ -4043,7 +4043,7 @@ mptsas_handle_queue_full_event(struct fw_event_work *fw_event)
 
 
 	ioc = fw_event->ioc;
-	qfull_data = (EventDataQueueFull_t *)fw_event->event_data;
+	qfull_data = (EventDataQueueFull_t *) &fw_event->event_data;
 	fw_id = qfull_data->TargetID;
 	fw_channel = qfull_data->Bus;
 	current_depth = le16_to_cpu(qfull_data->CurrentDepth);
@@ -4584,7 +4584,7 @@ mptsas_send_sas_event(struct fw_event_work *fw_event)
 
 	ioc = fw_event->ioc;
 	sas_event_data = (EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *)
-	    fw_event->event_data;
+	    &fw_event->event_data;
 	device_info = le32_to_cpu(sas_event_data->DeviceInfo);
 
 	if ((device_info &
@@ -4652,7 +4652,7 @@ mptsas_send_raid_event(struct fw_event_work *fw_event)
 	RaidPhysDiskPage0_t phys_disk;
 
 	ioc = fw_event->ioc;
-	raid_event_data = (EVENT_DATA_RAID *)fw_event->event_data;
+	raid_event_data = (EVENT_DATA_RAID *) &fw_event->event_data;
 	status = le32_to_cpu(raid_event_data->SettingsStatus);
 	state = (status >> 8) & 0xff;
 
@@ -4950,7 +4950,7 @@ mptsas_send_ir2_event(struct fw_event_work *fw_event)
 	RaidPhysDiskPage0_t phys_disk;
 
 	ioc = fw_event->ioc;
-	ir2_data = (MPI_EVENT_DATA_IR2 *)fw_event->event_data;
+	ir2_data = (MPI_EVENT_DATA_IR2 *) &fw_event->event_data;
 	reasonCode = ir2_data->ReasonCode;
 
 	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Entering %s: "
@@ -5095,14 +5095,14 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 
 	event_data_sz = ((reply->MsgLength * 4) -
 	    offsetof(EventNotificationReply_t, Data));
-	sz = offsetof(struct fw_event_work, event_data) + event_data_sz;
+	sz = sizeof(*fw_event) + event_data_sz;
 	fw_event = kzalloc(sz, GFP_ATOMIC);
 	if (!fw_event) {
 		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n", ioc->name,
 		 __func__, __LINE__);
 		return 0;
 	}
-	memcpy(fw_event->event_data, reply->Data, event_data_sz);
+	memcpy(&fw_event->event_data, reply->Data, event_data_sz);
 	fw_event->event = event;
 	fw_event->ioc = ioc;
 	mptsas_add_fw_event(ioc, fw_event, delay);
diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsas.h
index 57e86ab..c396483 100644
--- a/drivers/message/fusion/mptsas.h
+++ b/drivers/message/fusion/mptsas.h
@@ -110,7 +110,7 @@ struct fw_event_work {
 	MPT_ADAPTER	*ioc;
 	u32			event;
 	u8			retries;
-	u8			__attribute__((aligned(4))) event_data[1];
+	char			event_data[0] __aligned(4);
 };
 
 struct mptsas_discovery_event {
-- 
1.7.10.4

