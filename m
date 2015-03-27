From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 4/7] scsi: storvsc: Retrieve information about the
 capability of the target
Date: Fri, 27 Mar 2015 00:27:17 -0700
Message-ID: <1427441240-29314-4-git-send-email-kys@microsoft.com>
References: <1427441219-29275-1-git-send-email-kys@microsoft.com>
 <1427441240-29314-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1427441240-29314-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

The storage protocol informs the guest of the I/O capabilities of the storage
stack. Retrieve this information and use it in the guest.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 0ba7f2c..cdf048b 100644
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
