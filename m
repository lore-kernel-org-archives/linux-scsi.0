From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/3] scsi: storvsc: Size the queue depth based on the ringbuffer size
Date: Fri, 27 Feb 2015 17:01:46 -0800
Message-ID: <1425085307-27897-2-git-send-email-kys@microsoft.com>
References: <1425084227-27224-1-git-send-email-kys@microsoft.com>
 <1425085307-27897-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425085307-27897-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Size the queue depth based on the ringbuffer size. Also accomodate for the
fact that we could have multiple channels (ringbuffers) per adaptor.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 27fe850..5a12897 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -309,10 +309,15 @@ enum storvsc_request_type {
  */
 
 static int storvsc_ringbuffer_size = (256 * PAGE_SIZE);
+static u32 max_outstanding_req_per_channel;
+
+static int storvsc_vcpus_per_sub_channel = 4;
 
 module_param(storvsc_ringbuffer_size, int, S_IRUGO);
 MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
+module_param(storvsc_vcpus_per_sub_channel, int, S_IRUGO);
+MODULE_PARM_DESC(vcpus_per_sub_channel, "Ratio of VCPUs to subchannels");
 /*
  * Timeout in seconds for all devices managed by this driver.
  */
@@ -320,7 +325,6 @@ static int storvsc_timeout = 180;
 
 static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
 
-#define STORVSC_MAX_IO_REQUESTS				200
 
 static void storvsc_on_channel_callback(void *context);
 
@@ -1376,7 +1380,6 @@ static int storvsc_do_io(struct hv_device *device,
 
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
-	scsi_change_queue_depth(sdevice, STORVSC_MAX_IO_REQUESTS);
 
 	blk_queue_max_segment_size(sdevice->request_queue, PAGE_SIZE);
 
@@ -1646,7 +1649,6 @@ static struct scsi_host_template scsi_driver = {
 	.eh_timed_out =		storvsc_eh_timed_out,
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		255,
-	.can_queue =		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
 	.this_id =		-1,
 	/* no use setting to 0 since ll_blk_rw reset it to 1 */
 	/* currently 32 */
@@ -1686,6 +1688,7 @@ static int storvsc_probe(struct hv_device *device,
 			const struct hv_vmbus_device_id *dev_id)
 {
 	int ret;
+	int num_cpus = num_online_cpus();
 	struct Scsi_Host *host;
 	struct hv_host_device *host_dev;
 	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
@@ -1694,6 +1697,7 @@ static int storvsc_probe(struct hv_device *device,
 	int max_luns_per_target;
 	int max_targets;
 	int max_channels;
+	int max_sub_channels = 0;
 
 	/*
 	 * Based on the windows host we are running on,
@@ -1719,12 +1723,18 @@ static int storvsc_probe(struct hv_device *device,
 		max_luns_per_target = STORVSC_MAX_LUNS_PER_TARGET;
 		max_targets = STORVSC_MAX_TARGETS;
 		max_channels = STORVSC_MAX_CHANNELS;
+		/*
+		 * On Windows8 and above, we support sub-channels for storage.
+		 * The number of sub-channels offerred is based on the number of
+		 * VCPUs in the guest.
+		 */
+		max_sub_channels = (num_cpus / storvsc_vcpus_per_sub_channel);
 		break;
 	}
 
-	if (dev_id->driver_data == SFC_GUID)
-		scsi_driver.can_queue = (STORVSC_MAX_IO_REQUESTS *
-					 STORVSC_FC_MAX_TARGETS);
+	scsi_driver.can_queue = (max_outstanding_req_per_channel *
+				 max_sub_channels + 1);
+
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
 	if (!host)
@@ -1837,7 +1847,6 @@ static struct hv_driver storvsc_drv = {
 
 static int __init storvsc_drv_init(void)
 {
-	u32 max_outstanding_req_per_channel;
 
 	/*
 	 * Divide the ring buffer data size (which is 1 page less
@@ -1852,10 +1861,6 @@ static int __init storvsc_drv_init(void)
 		vmscsi_size_delta,
 		sizeof(u64)));
 
-	if (max_outstanding_req_per_channel <
-	    STORVSC_MAX_IO_REQUESTS)
-		return -EINVAL;
-
 	return vmbus_driver_register(&storvsc_drv);
 }
 
-- 
1.7.4.1
