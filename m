From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 1/2] storvsc: use in place iterator function
Date: Thu, 18 May 2017 09:18:11 -0700
Message-ID: <20170518161812.14124-2-sthemmin@microsoft.com>
References: <20170518161812.14124-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170518161812.14124-1-sthemmin@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, kys@microsoft.com
Cc: devel@linuxdriverproject.org, Stephen Hemminger <sthemmin@microsoft.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In 4.12-rc1, new functions were added to support iterating
over elements in the vmbus event ring. This patch uses them to
simplify the ring buffer handling in virtual SCSI driver as well.

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ae966dc3bbc5..f8a1649e4c63 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1149,13 +1149,9 @@ static void storvsc_on_receive(struct storvsc_device *stor_device,
 static void storvsc_on_channel_callback(void *context)
 {
 	struct vmbus_channel *channel = (struct vmbus_channel *)context;
+	const struct vmpacket_descriptor *desc;
 	struct hv_device *device;
 	struct storvsc_device *stor_device;
-	u32 bytes_recvd;
-	u64 request_id;
-	unsigned char packet[ALIGN(sizeof(struct vstor_packet), 8)];
-	struct storvsc_cmd_request *request;
-	int ret;
 
 	if (channel->primary_channel != NULL)
 		device = channel->primary_channel->device_obj;
@@ -1166,32 +1162,22 @@ static void storvsc_on_channel_callback(void *context)
 	if (!stor_device)
 		return;
 
-	do {
-		ret = vmbus_recvpacket(channel, packet,
-				       ALIGN((sizeof(struct vstor_packet) -
-					     vmscsi_size_delta), 8),
-				       &bytes_recvd, &request_id);
-		if (ret == 0 && bytes_recvd > 0) {
-
-			request = (struct storvsc_cmd_request *)
-					(unsigned long)request_id;
-
-			if ((request == &stor_device->init_request) ||
-			    (request == &stor_device->reset_request)) {
-
-				memcpy(&request->vstor_packet, packet,
-				       (sizeof(struct vstor_packet) -
-					vmscsi_size_delta));
-				complete(&request->wait_event);
-			} else {
-				storvsc_on_receive(stor_device,
-						(struct vstor_packet *)packet,
-						request);
-			}
+	foreach_vmbus_pkt(desc, channel) {
+		void *packet = hv_pkt_data(desc);
+		struct storvsc_cmd_request *request;
+
+		request = (struct storvsc_cmd_request *)
+			((unsigned long)desc->trans_id);
+
+		if (request == &stor_device->init_request ||
+		    request == &stor_device->reset_request) {
+			memcpy(&request->vstor_packet, packet,
+			       (sizeof(struct vstor_packet) - vmscsi_size_delta));
+			complete(&request->wait_event);
 		} else {
-			break;
+			storvsc_on_receive(stor_device, packet, request);
 		}
-	} while (1);
+	}
 }
 
 static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
-- 
2.11.0
