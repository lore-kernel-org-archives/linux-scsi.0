From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v2 10/11] mptfusion: combine fw_event_work and its event_data
Date: Wed, 25 Jun 2014 17:06:42 -0400
Message-ID: <1403730402-20324-1-git-send-email-joe.lawrence@stratus.com>
References: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o143.mxlogic.net ([208.65.144.76]:39036 "EHLO
	p02c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaFYVIH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 17:08:07 -0400
In-Reply-To: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Christoph Hellwig <hch@lst.de>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, Joe Lawrence <joe.lawrence@stratus.com>

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
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/message/fusion/mptsas.c |   16 ++++++----------
 drivers/message/fusion/mptsas.h |    2 +-
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 54b51a9..5454d838 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -990,11 +990,10 @@ mptsas_queue_device_delete(MPT_ADAPTER *ioc,
 	MpiEventDataSasDeviceStatusChange_t *sas_event_data)
 {
 	struct fw_event_work *fw_event;
-	int sz;
 
-	sz = offsetof(struct fw_event_work, event_data) +
-	    sizeof(MpiEventDataSasDeviceStatusChange_t);
-	fw_event = kzalloc(sz, GFP_ATOMIC);
+	fw_event = kzalloc(sizeof(*fw_event) +
+			   sizeof(MpiEventDataSasDeviceStatusChange_t),
+			   GFP_ATOMIC);
 	if (!fw_event) {
 		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n",
 		    ioc->name, __func__, __LINE__);
@@ -1011,10 +1010,8 @@ static void
 mptsas_queue_rescan(MPT_ADAPTER *ioc)
 {
 	struct fw_event_work *fw_event;
-	int sz;
 
-	sz = offsetof(struct fw_event_work, event_data);
-	fw_event = kzalloc(sz, GFP_ATOMIC);
+	fw_event = kzalloc(sizeof(*fw_event), GFP_ATOMIC);
 	if (!fw_event) {
 		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n",
 		    ioc->name, __func__, __LINE__);
@@ -4983,7 +4980,7 @@ static int
 mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 {
 	u32 event = le32_to_cpu(reply->Event);
-	int sz, event_data_sz;
+	int event_data_sz;
 	struct fw_event_work *fw_event;
 	unsigned long delay;
 
@@ -5093,8 +5090,7 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 
 	event_data_sz = ((reply->MsgLength * 4) -
 	    offsetof(EventNotificationReply_t, Data));
-	sz = offsetof(struct fw_event_work, event_data) + event_data_sz;
-	fw_event = kzalloc(sz, GFP_ATOMIC);
+	fw_event = kzalloc(sizeof(*fw_event) + event_data_sz, GFP_ATOMIC);
 	if (!fw_event) {
 		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n", ioc->name,
 		 __func__, __LINE__);
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

