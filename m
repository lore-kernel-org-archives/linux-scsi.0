From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 1/3] Vmbus: Add function to report available ring buffer to
 write in total ring size percentage
Date: Thu, 22 Mar 2018 17:15:36 -0700
Message-ID: <20180323001538.31876-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

Netvsc has a similar function to calculate how much ring buffer in
percentage is available to write. This function is useful for storvsc and
other vmbus devices.

Define a similar function in vmbus to be used by storvsc.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/hv/ring_buffer.c |  2 ++
 include/linux/hyperv.h   | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 8699bb969e7e..3c836c099a8f 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -227,6 +227,8 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 	ring_info->ring_buffer->feature_bits.value = 1;
 
 	ring_info->ring_size = page_cnt << PAGE_SHIFT;
+	ring_info->ring_size_div10_reciprocal =
+		reciprocal_value(ring_info->ring_size / 10);
 	ring_info->ring_datasize = ring_info->ring_size -
 		sizeof(struct hv_ring_buffer);
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 2048f3c3b68a..eb7204851089 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -36,6 +36,7 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/interrupt.h>
+#include <linux/reciprocal_div.h>
 
 #define MAX_PAGE_BUFFER_COUNT				32
 #define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
@@ -121,6 +122,7 @@ struct hv_ring_buffer {
 struct hv_ring_buffer_info {
 	struct hv_ring_buffer *ring_buffer;
 	u32 ring_size;			/* Include the shared header */
+	struct reciprocal_value ring_size_div10_reciprocal;
 	spinlock_t ring_lock;
 
 	u32 ring_datasize;		/* < ring_size */
@@ -155,6 +157,16 @@ static inline u32 hv_get_bytes_to_write(const struct hv_ring_buffer_info *rbi)
 	return write;
 }
 
+static inline u32 hv_get_avail_to_write_percent(
+		const struct hv_ring_buffer_info *rbi)
+{
+	u32 avail_write = hv_get_bytes_to_write(rbi);
+
+	return reciprocal_divide(
+			(avail_write  << 3) + (avail_write << 1),
+			rbi->ring_size_div10_reciprocal);
+}
+
 /*
  * VMBUS version is 32 bit entity broken up into
  * two 16 bit quantities: major_number. minor_number.
-- 
2.14.1
