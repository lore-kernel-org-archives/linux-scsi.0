From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND V2 5/7] scsi: storvsc: use storage protocol version to
 determine storage capabilities
Date: Thu, 13 Aug 2015 08:43:50 -0700
Message-ID: <1439480632-11144-5-git-send-email-kys@microsoft.com>
References: <1439480609-11099-1-git-send-email-kys@microsoft.com>
 <1439480632-11144-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1439480632-11144-1-git-send-email-kys@microsoft.com>
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
Cc: Keith Mange <keith.mange@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Keith Mange <keith.mange@microsoft.com>

Use storage protocol version instead of vmbus protocol
version when determining storage capabilities.

Tested-by: Alex Ng <alexng@microsoft.com>
Signed-off-by: Keith Mange <keith.mange@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6f38cdf..58fa47a 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1049,7 +1049,7 @@ static int storvsc_channel_init(struct hv_device *device)
 	 * support multi-channel.
 	 */
 	max_chns = vstor_packet->storage_channel_properties.max_channel_cnt;
-	if (vmbus_proto_version >= VERSION_WIN8) {
+	if (vmstor_proto_version >= VMSTOR_PROTO_VERSION_WIN8) {
 		if (vstor_packet->storage_channel_properties.flags &
 		    STORAGE_CHANNEL_SUPPORTS_MULTI_CHANNEL)
 			process_sub_channels = true;
@@ -1491,9 +1491,9 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 	 * if the device is a MSFT virtual device.
 	 */
 	if (!strncmp(sdevice->vendor, "Msft", 4)) {
-		switch (vmbus_proto_version) {
-		case VERSION_WIN8:
-		case VERSION_WIN8_1:
+		switch (vmstor_proto_version) {
+		case VMSTOR_PROTO_VERSION_WIN8:
+		case VMSTOR_PROTO_VERSION_WIN8_1:
 			sdevice->scsi_level = SCSI_SPC_3;
 			break;
 		}
-- 
1.7.4.1
