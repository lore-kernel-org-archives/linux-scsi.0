From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 1/7] scsi: storvsc: Rather than look for sets of specific protocol versions, make decisions based on ranges.
Date: Wed,  3 Jun 2015 15:34:26 -0700
Message-ID: <1433370872-3302-1-git-send-email-kys@microsoft.com>
References: <1433370839-3240-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:56159
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791AbbFCVNO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Jun 2015 17:13:14 -0400
In-Reply-To: <1433370839-3240-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: Keith Mange <keith.mange@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>

From: Keith Mange <keith.mange@microsoft.com>

Rather than look for sets of specific protocol versions,
make decisions based on ranges. This will be safer and require fewer changes
going forward as we add more storage protocol versions.

Tested-by: Alex Ng <alexng@microsoft.com>
Signed-off-by: Keith Mange <keith.mange@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3c6584f..582f3b5 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -988,8 +988,7 @@ static int storvsc_channel_init(struct hv_device *device)
 	 * support multi-channel.
 	 */
 	max_chns = vstor_packet->storage_channel_properties.max_channel_cnt;
-	if ((vmbus_proto_version != VERSION_WIN7) &&
-	   (vmbus_proto_version != VERSION_WS2008))  {
+	if (vmbus_proto_version >= VERSION_WIN8) {
 		if (vstor_packet->storage_channel_properties.flags &
 		    STORAGE_CHANNEL_SUPPORTS_MULTI_CHANNEL)
 			process_sub_channels = true;
@@ -1758,9 +1757,7 @@ static int storvsc_probe(struct hv_device *device,
 	 * set state to properly communicate with the host.
 	 */
 
-	switch (vmbus_proto_version) {
-	case VERSION_WS2008:
-	case VERSION_WIN7:
+	if (vmbus_proto_version < VERSION_WIN8) {
 		sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
 		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
 		vmstor_current_major = VMSTOR_WIN7_MAJOR;
@@ -1768,8 +1765,7 @@ static int storvsc_probe(struct hv_device *device,
 		max_luns_per_target = STORVSC_IDE_MAX_LUNS_PER_TARGET;
 		max_targets = STORVSC_IDE_MAX_TARGETS;
 		max_channels = STORVSC_IDE_MAX_CHANNELS;
-		break;
-	default:
+	} else {
 		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
 		vmscsi_size_delta = 0;
 		vmstor_current_major = VMSTOR_WIN8_MAJOR;
@@ -1783,7 +1779,6 @@ static int storvsc_probe(struct hv_device *device,
 		 * VCPUs in the guest.
 		 */
 		max_sub_channels = (num_cpus / storvsc_vcpus_per_sub_channel);
-		break;
 	}
 
 	scsi_driver.can_queue = (max_outstanding_req_per_channel *
-- 
1.7.4.1

