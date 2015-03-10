From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/3] scsi: storvsc: Retrieve information about the capability of the target
Date: Mon,  9 Mar 2015 20:45:05 -0700
Message-ID: <1425959107-24199-1-git-send-email-kys@microsoft.com>
References: <1425958941-23374-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425958941-23374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

The storage protocol informs the guest of the I/O capabilities of the storage
stack. Retrieve this information and use it in the guest.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index be8f12e..5c13eec 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -377,6 +377,10 @@ struct storvsc_device {
 	unsigned char path_id;
 	unsigned char target_id;
 
+	/*
+	 * Max I/O, the device can support.
+	 */
+	u32   max_transfer_bytes;
 	/* Used for vsc/vsp channel reset process */
 	struct storvsc_cmd_request init_request;
 	struct storvsc_cmd_request reset_request;
@@ -974,6 +978,8 @@ static int storvsc_channel_init(struct hv_device *device)
 		    STORAGE_CHANNEL_SUPPORTS_MULTI_CHANNEL)
 			process_sub_channels = true;
 	}
+	stor_device->max_transfer_bytes =
+		vstor_packet->storage_channel_properties.max_transfer_bytes;
 
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
 	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
-- 
1.7.4.1
